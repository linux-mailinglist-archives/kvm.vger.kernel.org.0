Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778419912F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbfHVKnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbfHVKnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:43:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F13843082B02;
        Thu, 22 Aug 2019 10:43:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAB785888;
        Thu, 22 Aug 2019 10:43:14 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A7C1024F2F;
        Thu, 22 Aug 2019 10:43:13 +0000 (UTC)
Date:   Thu, 22 Aug 2019 06:43:13 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de,
        yang zhang wz <yang.zhang.wz@gmail.com>, riel@surriel.com,
        konrad wilk <konrad.wilk@oracle.com>, lcapitulino@redhat.com,
        wei w wang <wei.w.wang@intel.com>, aarcange@redhat.com,
        pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>,
        alexander h duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <1297409377.9866813.1566470593223.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190821145806.20926.22448.stgit@localhost.localdomain>
References: <20190821145806.20926.22448.stgit@localhost.localdomain>
Subject: Re: [PATCH v6 0/6] mm / virtio: Provide support for unused page
 reporting
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.181, 10.4.195.5]
Thread-Topic: mm / virtio: Provide support for unused page reporting
Thread-Index: xHUmoXrRE8GpYbacHABVEp4l9hFR1A==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 22 Aug 2019 10:43:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> This series provides an asynchronous means of reporting to a hypervisor
> that a guest page is no longer in use and can have the data associated
> with it dropped. To do this I have implemented functionality that allows
> for what I am referring to as unused page reporting
> 
> The functionality for this is fairly simple. When enabled it will allocate
> statistics to track the number of reported pages in a given free area.
> When the number of free pages exceeds this value plus a high water value,
> currently 32, it will begin performing page reporting which consists of
> pulling pages off of free list and placing them into a scatter list. The
> scatterlist is then given to the page reporting device and it will perform
> the required action to make the pages "reported", in the case of
> virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> and as such they are forced out of the guest. After this they are placed
> back on the free list, and an additional bit is added if they are not
> merged indicating that they are a reported buddy page instead of a
> standard buddy page. The cycle then repeats with additional non-reported
> pages being pulled until the free areas all consist of reported pages.
> 
> I am leaving a number of things hard-coded such as limiting the lowest
> order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
> determine what the limit is on how many pages it wants to allocate to
> process the hints. The upper limit for this is based on the size of the
> queue used to store the scattergather list.
> 
> My primary testing has just been to verify the memory is being freed after
> allocation by running memhog 40g on a 40g guest and watching the total
> free memory via /proc/meminfo on the host. With this I have verified most
> of the memory is freed after each iteration. 

I tried to go through the entire patch series. I can see you reported a
-3.27 drop from the baseline. If its because of re-faulting the page after
host has freed them? Can we avoid freeing all the pages from the guest free_area
and keep some pages(maybe some mixed order), so that next allocation is done from
the guest itself than faulting to host. This will work with real workload where
allocation and deallocation happen at regular intervals. 

This can be further optimized based on other factors like host memory pressure etc.

Thanks,
Pankaj       

As far as performance I have
> been mainly focusing on the will-it-scale/page_fault1 test running with
> 16 vcpus. I have modified it to use Transparent Huge Pages. With this I
> see almost no difference, -0.08%, with the patches applied and the feature
> disabled. I see a regression of -0.86% with the feature enabled, but the
> madvise disabled in the hypervisor due to a device being assigned. With
> the feature fully enabled I see a regression of -3.27% versus the baseline
> without these patches applied. In my testing I found that most of the
> overhead was due to the page zeroing that comes as a result of the pages
> having to be faulted back into the guest.
> 
> One side effect of these patches is that the guest becomes much more
> resilient in terms of NUMA locality. With the pages being freed and then
> reallocated when used it allows for the pages to be much closer to the
> active thread, and as a result there can be situations where this patch
> set will out-perform the stock kernel when the guest memory is not local
> to the guest vCPUs. To avoid that in my testing I set the affinity of all
> the vCPUs and QEMU instance to the same node.
> 
> Changes from the RFC:
> https://lore.kernel.org/lkml/20190530215223.13974.22445.stgit@localhost.localdomain/
> Moved aeration requested flag out of aerator and into zone->flags.
> Moved boundary out of free_area and into local variables for aeration.
> Moved aeration cycle out of interrupt and into workqueue.
> Left nr_free as total pages instead of splitting it between raw and aerated.
> Combined size and physical address values in virtio ring into one 64b value.
> 
> Changes from v1:
> https://lore.kernel.org/lkml/20190619222922.1231.27432.stgit@localhost.localdomain/
> Dropped "waste page treatment" in favor of "page hinting"
> Renamed files and functions from "aeration" to "page_hinting"
> Moved from page->lru list to scatterlist
> Replaced wait on refcnt in shutdown with RCU and cancel_delayed_work_sync
> Virtio now uses scatterlist directly instead of intermediate array
> Moved stats out of free_area, now in separate area and pointed to from zone
> Merged patch 5 into patch 4 to improve review-ability
> Updated various code comments throughout
> 
> Changes from v2:
> https://lore.kernel.org/lkml/20190724165158.6685.87228.stgit@localhost.localdomain/
> Dropped "page hinting" in favor of "page reporting"
> Renamed files from "hinting" to "reporting"
> Replaced "Hinted" page type with "Reported" page flag
> Added support for page poisoning while hinting is active
> Add QEMU patch that implements PAGE_POISON feature
> 
> Changes from v3:
> https://lore.kernel.org/lkml/20190801222158.22190.96964.stgit@localhost.localdomain/
> Added mutex lock around page reporting startup and shutdown
> Fixed reference to "page aeration" in patch 2
> Split page reporting function bit out into separate QEMU patch
> Limited capacity of scatterlist to vq size - 1 instead of vq size
> Added exception handling for case of virtio descriptor allocation failure
> 
> Changes from v4:
> https://lore.kernel.org/lkml/20190807224037.6891.53512.stgit@localhost.localdomain/
> Replaced spin_(un)lock with spin_(un)lock_irq in page_reporting_cycle()
> Dropped if/continue for ternary operator in page_reporting_process()
> Added checks for isolate and cma types to
> for_each_reporting_migratetype_order
> Added virtio-dev, Michal Hocko, and Oscar Salvador to to:/cc:
> Rebased on latest linux-next and QEMU git trees
> 
> Changes from v5:
> https://lore.kernel.org/lkml/20190812213158.22097.30576.stgit@localhost.localdomain/
> Replaced spin_(un)lock with spin_(un)lock_irq in page_reporting_startup()
> Updated shuffle code to use "shuffle_pick_tail" and updated patch description
> Dropped storage of order and migratettype while page is being reported
> Used get_pfnblock_migratetype to determine migratetype of page
> Renamed put_reported_page to free_reported_page, added order as argument
> Dropped check for CMA type as I believe we should be reporting those
> Added code to allow moving of reported pages into and out of isolation
> Defined page reporting order as minimum of Huge Page size vs MAX_ORDER - 1
> Cleaned up use of static branch usage for page_reporting_notify_enabled
> 
> ---
> 
> Alexander Duyck (6):
>       mm: Adjust shuffle code to allow for future coalescing
>       mm: Move set/get_pcppage_migratetype to mmzone.h
>       mm: Use zone and order instead of free area in free_list manipulators
>       mm: Introduce Reported pages
>       virtio-balloon: Pull page poisoning config out of free page hinting
>       virtio-balloon: Add support for providing unused page reports to host
> 
> 
>  drivers/virtio/Kconfig              |    1
>  drivers/virtio/virtio_balloon.c     |   84 ++++++++-
>  include/linux/mmzone.h              |  124 ++++++++-----
>  include/linux/page-flags.h          |   11 +
>  include/linux/page_reporting.h      |  177 ++++++++++++++++++
>  include/uapi/linux/virtio_balloon.h |    1
>  mm/Kconfig                          |    5 +
>  mm/Makefile                         |    1
>  mm/internal.h                       |   18 ++
>  mm/memory_hotplug.c                 |    1
>  mm/page_alloc.c                     |  216 ++++++++++++++++-------
>  mm/page_reporting.c                 |  336
>  +++++++++++++++++++++++++++++++++++
>  mm/shuffle.c                        |   40 +++-
>  mm/shuffle.h                        |   12 +
>  14 files changed, 896 insertions(+), 131 deletions(-)
>  create mode 100644 include/linux/page_reporting.h
>  create mode 100644 mm/page_reporting.c
> 
> --
> 
> 
