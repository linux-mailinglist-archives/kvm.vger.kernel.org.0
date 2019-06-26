Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C256508
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 11:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfFZJB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 05:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfFZJB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 05:01:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 414C5C04FFF6;
        Wed, 26 Jun 2019 09:01:45 +0000 (UTC)
Received: from turbo.dinechin.lan (unknown [10.36.118.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EAA160C4C;
        Wed, 26 Jun 2019 09:01:22 +0000 (UTC)
References: <20190619222922.1231.27432.stgit@localhost.localdomain> <ff133df4-6291-bece-3d8d-dc3f12f398cf@redhat.com>
User-agent: mu4e 1.3.2; emacs 26.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, riel@surriel.com, konrad.wilk@oracle.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v1 0/6] mm / virtio: Provide support for paravirtual waste page treatment
In-reply-to: <ff133df4-6291-bece-3d8d-dc3f12f398cf@redhat.com>
Date:   Wed, 26 Jun 2019 11:01:08 +0200
Message-ID: <7hmui42017.fsf@turbo.dinechin.lan>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 26 Jun 2019 09:01:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


David Hildenbrand writes:

> On 20.06.19 00:32, Alexander Duyck wrote:
>> This series provides an asynchronous means of hinting to a hypervisor
>> that a guest page is no longer in use and can have the data associated
>> with it dropped. To do this I have implemented functionality that allows
>> for what I am referring to as waste page treatment.
>> 
>> I have based many of the terms and functionality off of waste water
>> treatment, the idea for the similarity occurred to me after I had reached
>> the point of referring to the hints as "bubbles", as the hints used the
>> same approach as the balloon functionality but would disappear if they
>> were touched, as a result I started to think of the virtio device as an
>> aerator. The general idea with all of this is that the guest should be
>> treating the unused pages so that when they end up heading "downstream"
>> to either another guest, or back at the host they will not need to be
>> written to swap.
>> 
>> When the number of "dirty" pages in a given free_area exceeds our high
>> water mark, which is currently 32, we will schedule the aeration task to
>> start going through and scrubbing the zone. While the scrubbing is taking
>> place a boundary will be defined that we use to seperate the "aerated"
>> pages from the "dirty" ones. We use the ZONE_AERATION_ACTIVE bit to flag
>> when these boundaries are in place.
>
> I still *detest* the terminology, sorry. Can't you come up with a
> simpler terminology that makes more sense in the context of operating
> systems and pages we want to hint to the hypervisor? (that is the only
> use case you are using it for so far)

FWIW, I thought the terminology made sense, in particular given the analogy
with the balloon driver. Operating systems in general, and Linux in
particular, already use tons of analogy-supported terminology. In
particular, a "waste page treatment" terminology is not very far from
the very common "garbage collection" or "scrubbing" wordings. I would find
"hinting" much less specific. for example.

Usually, the phrases that stick are somewhat unique while providing a
useful analogy to server as a reminder of what the thing actually
does. IMHO, it's the case here on both fronts, so I like it.

>
>> 
>> I am leaving a number of things hard-coded such as limiting the lowest
>> order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
>> determine what batch size it wants to allocate to process the hints.
>> 
>> My primary testing has just been to verify the memory is being freed after
>> allocation by running memhog 32g in the guest and watching the total free
>> memory via /proc/meminfo on the host. With this I have verified most of
>> the memory is freed after each iteration. As far as performance I have
>> been mainly focusing on the will-it-scale/page_fault1 test running with
>> 16 vcpus. With that I have seen a less than 1% difference between the
>
> 1% throughout all benchmarks? Guess that is quite good.
>
>> base kernel without these patches, with the patches and virtio-balloon
>> disabled, and with the patches and virtio-balloon enabled with hinting.
>> 
>> Changes from the RFC:
>> Moved aeration requested flag out of aerator and into zone->flags.
>> Moved boundary out of free_area and into local variables for aeration.
>> Moved aeration cycle out of interrupt and into workqueue.
>> Left nr_free as total pages instead of splitting it between raw and aerated.
>> Combined size and physical address values in virtio ring into one 64b value.
>> Restructured the patch set to reduce patches from 11 to 6.
>> 
>
> I'm planning to look into the details, but will be on PTO for two weeks
> starting this Saturday (and still have other things to finish first :/ ).
>
>> ---
>> 
>> Alexander Duyck (6):
>>       mm: Adjust shuffle code to allow for future coalescing
>>       mm: Move set/get_pcppage_migratetype to mmzone.h
>>       mm: Use zone and order instead of free area in free_list manipulators
>>       mm: Introduce "aerated" pages
>>       mm: Add logic for separating "aerated" pages from "raw" pages
>>       virtio-balloon: Add support for aerating memory via hinting
>> 
>> 
>>  drivers/virtio/Kconfig              |    1 
>>  drivers/virtio/virtio_balloon.c     |  110 ++++++++++++++
>>  include/linux/memory_aeration.h     |  118 +++++++++++++++
>>  include/linux/mmzone.h              |  113 +++++++++------
>>  include/linux/page-flags.h          |    8 +
>>  include/uapi/linux/virtio_balloon.h |    1 
>>  mm/Kconfig                          |    5 +
>>  mm/Makefile                         |    1 
>>  mm/aeration.c                       |  270 +++++++++++++++++++++++++++++++++++
>>  mm/page_alloc.c                     |  203 ++++++++++++++++++--------
>>  mm/shuffle.c                        |   24 ---
>>  mm/shuffle.h                        |   35 +++++
>>  12 files changed, 753 insertions(+), 136 deletions(-)
>>  create mode 100644 include/linux/memory_aeration.h
>>  create mode 100644 mm/aeration.c
>
> Compared to
>
>  17 files changed, 838 insertions(+), 86 deletions(-)
>  create mode 100644 include/linux/memory_aeration.h
>  create mode 100644 mm/aeration.c
>
> this looks like a good improvement :)


-- 
Cheers,
Christophe de Dinechin (IRC c3d)
