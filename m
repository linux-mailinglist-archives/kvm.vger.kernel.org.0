Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE12AC831
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405231AbfIGReR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:34:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36254 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391932AbfIGReR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:34:17 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so20000611iof.3;
        Sat, 07 Sep 2019 10:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1wlSEAd/yNqPov8hazkmuwObylmLJ4n7bwZJ/zSVuE=;
        b=nX/ZnggVrPn3mYrpQxjYzUSqOuhzl/Ki5d8x3fcQRyY95Cjdq1FR5XidwxJPXoE/dV
         ZHjSR7XLoGr/iym/ChD9eSJEuFtDFm8uelqpCDpSX7XudnAFzhbf8XZ1wToB3ict3D4U
         keROyrkJ3FgyFny6SfjibZCyAQMgxj5sllN1PcQxPFrUFRWOC39gCuT6KuyWpJubsJse
         XP1pvczx/jTBbWkozRPfFqR/BTxq+/1RYD0e8OXBS9Wvhh/X46gVFOwitx1Ktt+sviQp
         v/TPYnp44btB5msp/R2dN2+IYXaZNdSEfeKjTqrv4w0VoCUsnuh+OfNBMKkzCWp0N4eW
         HPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1wlSEAd/yNqPov8hazkmuwObylmLJ4n7bwZJ/zSVuE=;
        b=OpEfy92wfPgKFXNCclAi6/2F1kaoPBaNJ+AiJdsdQdW8CrkSiP0HMwbHk1cnThMB7M
         ogbVGWQbdqGt+3jRLjwcDwGpCZGqUuENn2x/nSgJ2EsY6W1wlEAGp22g4D0FiYDAaVI7
         4BaKY/wpijcNlcNt5iT55Q4T34YXP7ya/pFeyrZ+TPj1aanr3Dt+1kmniDEMZm6lqI1b
         DXR4TBoQHEizCHDyumSoMWk1hJvnk04phIpsu5jP/RjT8l3gAduCpKMbuYNWJxEcaPYY
         aEoeBPGvMEXMzfndUVeSFGebhBNWdFOIqUeAf/DTobUuh9BnkjeyCerKGGy2npYfcU/Q
         JhvQ==
X-Gm-Message-State: APjAAAV+xRmip/LMXMk69EKBC02j6lX88XFk4ysV0KfqNq5kn27dL7nc
        4QWUtT/4E2OPD90PmwKCwYlSKF0z0ujv01577Bg=
X-Google-Smtp-Source: APXvYqyL3r6EbggbESVOvEQiUNQ4L6hRKzNiJBvs6HGzqjTYf6K0GuLb4ShQNBqLt7AfI5UmxbdCaqcrjN2rBGALtkA=
X-Received: by 2002:a5d:8f86:: with SMTP id l6mr3723909iol.270.1567877655886;
 Sat, 07 Sep 2019 10:34:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 7 Sep 2019 10:34:04 -0700
Message-ID: <CAKgT0UdeSfD9ZKLZO=wF+kdfTq+=u1bUvsih5PUtNTs66obCgA@mail.gmail.com>
Subject: Re: [PATCH v9 0/8] mm / virtio: Provide support for unused page reporting
To:     virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>
Cc:     Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry about that. Looks like I fat fingered things and copied the
command line into the cover page. I corrected the subject here, and
pulled the command line out of the message below.

- Alex

On Sat, Sep 7, 2019 at 10:25 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
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
> of the memory is freed after each iteration. As far as performance I have
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
> I have not included the QEMU patches with this set as they haven't really
> changed in the last several revisions. If needed they can be located with
> the v8 patchset.
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
> Added checks for isolate and cma types to for_each_reporting_migratetype_order
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
> Changes from v6:
> https://lore.kernel.org/lkml/20190821145806.20926.22448.stgit@localhost.localdomain/
> Rebased on linux-next for 20190903
> Added jump label to __page_reporting_request so we release RCU read lock
> Removed "- 1" from capacity limit based on virtio ring
> Added code to verify capacity is non-zero or return error on startup
>
> Changes from v7:
> https://lore.kernel.org/lkml/20190904150920.13848.32271.stgit@localhost.localdomain/
> Updated poison fixes to clear flag if "nosanity" is enabled in kernel config
> Split shuffle per-cpu optimization into separate patch
> Moved check for !phdev->capacity into reporting patch where it belongs
> Added Reviewed-by tags received for v7
>
> Changes from v8:
> https://lore.kernel.org/lkml/20190906145213.32552.30160.stgit@localhost.localdomain/
> Added patch that moves HPAGE_SIZE definition for ARM64 to match other archs
> Switch back to using pageblock_order instead of HUGETLB_ORDER and MAX_ORDER - 1
> Boundary allocation now dynamic to support HUGETLB_PAGE_SIZE_VARIABLE option
> Made use of existing code/functions to reduce size of move_to_boundary function
> Dropped unused zone pointer from add_to/del_from_boundary functions
> Added additional possible mm and arm64 people as reviewers to Cc
> Added Reviewed-by tags received for v8
> Fixed missing parameter in kerneldoc
>
> ---
>
> Alexander Duyck (8):
>       mm: Add per-cpu logic to page shuffling
>       mm: Adjust shuffle code to allow for future coalescing
>       mm: Move set/get_pcppage_migratetype to mmzone.h
>       mm: Use zone and order instead of free area in free_list manipulators
>       arm64: Move hugetlb related definitions out of pgtable.h to page-defs.h
>       mm: Introduce Reported pages
>       virtio-balloon: Pull page poisoning config out of free page hinting
>       virtio-balloon: Add support for providing unused page reports to host
>
>
>  arch/arm64/include/asm/page-def.h   |    9 +
>  arch/arm64/include/asm/pgtable.h    |    9 -
>  drivers/virtio/Kconfig              |    1
>  drivers/virtio/virtio_balloon.c     |   87 ++++++++-
>  include/linux/mmzone.h              |  124 ++++++++----
>  include/linux/page-flags.h          |   11 +
>  include/linux/page_reporting.h      |  178 +++++++++++++++++
>  include/uapi/linux/virtio_balloon.h |    1
>  mm/Kconfig                          |    5
>  mm/Makefile                         |    1
>  mm/internal.h                       |   18 ++
>  mm/memory_hotplug.c                 |    1
>  mm/page_alloc.c                     |  217 +++++++++++++++------
>  mm/page_reporting.c                 |  358 +++++++++++++++++++++++++++++++++++
>  mm/shuffle.c                        |   40 ++--
>  mm/shuffle.h                        |   12 +
>  16 files changed, 931 insertions(+), 141 deletions(-)
>  create mode 100644 include/linux/page_reporting.h
>  create mode 100644 mm/page_reporting.c
>
> --
