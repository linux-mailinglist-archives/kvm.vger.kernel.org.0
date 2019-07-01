Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6554C3A8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbfFSWc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:32:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35970 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730182AbfFSWc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:32:58 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so506439ioh.3;
        Wed, 19 Jun 2019 15:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=7Bg82A9f7f4RunQMoMmcdR9mp3vDHwjyz3/uf1/B6Co=;
        b=BUWIZKTclx11jnrux4XAhfYbZb9dSGSj1E/6bQvoHLxuhBPkUPu+YWpQ485Vs0fgH9
         07d2hF9Ei42SbqfTz984tQe6vqxnkQskw3rVsNYEfHbaKnaapGBySK1QxiHzOTSkV97Y
         6nBcXGDDUa6a3/FQJ75AFUZ8Tfqbp6W19XMBPKiy7uCayarvngTU14fVWpSfa9vbcxgq
         itBs3i+QdUrBieBHvKaJFmqha5z4vfKkgEDoLx/lQq+jrJ9bUWhR/UDWckGSlqSqZ46R
         5SNU3TaZX9oNwUrIneafyL+AqhBCgSHTL5ePKBzU0IIimsQwTAPNrEU9Z+BjjRxXXB4d
         p6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=7Bg82A9f7f4RunQMoMmcdR9mp3vDHwjyz3/uf1/B6Co=;
        b=UtWEIBlx7k4gMxQ1hlhDzqLWN/e3Sf3fOYMbZavrRWhRLX4KGmipVt+4Nnq/vsmCWy
         nzgo1Na601XlztFZQ+cUtD79dxp9MX8HV05Ad8RRYmJI63BsIUUqzLlXldFktnW+lVQi
         1w3/8sx+7TJEitwqfzjzZAArnDFM9Nb6zPHaYf2FBWF51FtH4sy6FS8syWQ1eUCSNfyD
         dSzH1dUalOetx/pOB/tgKDV+kd2YOUmPUVVgK1pQ1TtKJoAfvwriaO/xdwVeiTStrfDI
         yIroWoviiwhTBVgRIoVoAlM5OzfFXuVCyKZ131+putwTtkZ3SPIq/ndC3pnVl6jdcmP3
         Hveg==
X-Gm-Message-State: APjAAAUwRPsBWeQyjz0ExJyQ0bYhd1zdgcj9cy74QxsjcgpcPhZKyzha
        b9aa4QcOqkDTxgSGZlNpLh8=
X-Google-Smtp-Source: APXvYqzc0qIqzB4wleX54UjkFOne7zbe/eiQNSOhbgTRX7xXVEA+CpQehXrV2IP+mVuZvNGNcBZyqg==
X-Received: by 2002:a6b:7b09:: with SMTP id l9mr12963476iop.114.1560983577080;
        Wed, 19 Jun 2019 15:32:57 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id e188sm21987403ioa.3.2019.06.19.15.32.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:32:56 -0700 (PDT)
Subject: [PATCH v1 0/6] mm / virtio: Provide support for paravirtual waste
 page treatment
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:32:54 -0700
Message-ID: <20190619222922.1231.27432.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series provides an asynchronous means of hinting to a hypervisor
that a guest page is no longer in use and can have the data associated
with it dropped. To do this I have implemented functionality that allows
for what I am referring to as waste page treatment.

I have based many of the terms and functionality off of waste water
treatment, the idea for the similarity occurred to me after I had reached
the point of referring to the hints as "bubbles", as the hints used the
same approach as the balloon functionality but would disappear if they
were touched, as a result I started to think of the virtio device as an
aerator. The general idea with all of this is that the guest should be
treating the unused pages so that when they end up heading "downstream"
to either another guest, or back at the host they will not need to be
written to swap.

When the number of "dirty" pages in a given free_area exceeds our high
water mark, which is currently 32, we will schedule the aeration task to
start going through and scrubbing the zone. While the scrubbing is taking
place a boundary will be defined that we use to seperate the "aerated"
pages from the "dirty" ones. We use the ZONE_AERATION_ACTIVE bit to flag
when these boundaries are in place.

I am leaving a number of things hard-coded such as limiting the lowest
order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
determine what batch size it wants to allocate to process the hints.

My primary testing has just been to verify the memory is being freed after
allocation by running memhog 32g in the guest and watching the total free
memory via /proc/meminfo on the host. With this I have verified most of
the memory is freed after each iteration. As far as performance I have
been mainly focusing on the will-it-scale/page_fault1 test running with
16 vcpus. With that I have seen a less than 1% difference between the
base kernel without these patches, with the patches and virtio-balloon
disabled, and with the patches and virtio-balloon enabled with hinting.

Changes from the RFC:
Moved aeration requested flag out of aerator and into zone->flags.
Moved boundary out of free_area and into local variables for aeration.
Moved aeration cycle out of interrupt and into workqueue.
Left nr_free as total pages instead of splitting it between raw and aerated.
Combined size and physical address values in virtio ring into one 64b value.
Restructured the patch set to reduce patches from 11 to 6.

---

Alexander Duyck (6):
      mm: Adjust shuffle code to allow for future coalescing
      mm: Move set/get_pcppage_migratetype to mmzone.h
      mm: Use zone and order instead of free area in free_list manipulators
      mm: Introduce "aerated" pages
      mm: Add logic for separating "aerated" pages from "raw" pages
      virtio-balloon: Add support for aerating memory via hinting


 drivers/virtio/Kconfig              |    1 
 drivers/virtio/virtio_balloon.c     |  110 ++++++++++++++
 include/linux/memory_aeration.h     |  118 +++++++++++++++
 include/linux/mmzone.h              |  113 +++++++++------
 include/linux/page-flags.h          |    8 +
 include/uapi/linux/virtio_balloon.h |    1 
 mm/Kconfig                          |    5 +
 mm/Makefile                         |    1 
 mm/aeration.c                       |  270 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                     |  203 ++++++++++++++++++--------
 mm/shuffle.c                        |   24 ---
 mm/shuffle.h                        |   35 +++++
 12 files changed, 753 insertions(+), 136 deletions(-)
 create mode 100644 include/linux/memory_aeration.h
 create mode 100644 mm/aeration.c

--
