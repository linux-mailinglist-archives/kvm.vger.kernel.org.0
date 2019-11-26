Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6107210A269
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 17:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfKZQpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 11:45:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:26320 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbfKZQpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 11:45:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 08:45:33 -0800
X-IronPort-AV: E=Sophos;i="5.69,246,1571727600"; 
   d="scan'208";a="291772877"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Nov 2019 08:45:34 -0800
Message-ID: <2cd804f781b55d5c20e970dcd67b472fba6e1387.camel@linux.intel.com>
Subject: Re: [PATCH v14 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, osalvador@suse.de
Date:   Tue, 26 Nov 2019 08:45:20 -0800
In-Reply-To: <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
         <052f7442-4500-cd02-af2e-56d2f97a232c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-11-26 at 13:20 +0100, David Hildenbrand wrote:
> On 19.11.19 22:46, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting unused guest
> > pages to a hypervisor so that the memory associated with those pages can
> > be dropped and reused by other processes and/or guests on the host. Using
> > this it is possible to avoid unnecessary I/O to disk and greatly improve
> > performance in the case of memory overcommit on the host.
> > 
> > When enabled it will allocate a set of statistics to track the number of
> > reported pages. When the nr_free for a given free area is greater than
> > this by the high water mark we will schedule a worker to begin pulling the
> > non-reported memory and to provide it to the reporting interface via a
> > scatterlist.
> > 
> > Currently this is only in use by virtio-balloon however there is the hope
> > that at some point in the future other hypervisors might be able to make
> > use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> > currently using MADV_DONTNEED to indicate to the host kernel that the page
> > is currently unused. It will be zeroed and faulted back into the guest the
> > next time the page is accessed.
> 
> Remind me why we are using MADV_DONTNEED? Mostly for debugging purposes
> right now, right? Did you do any measurements with MADV_FREE? I guess
> there should be quite a performance increase in some scenarios.

There are actually a few reasons for not using MADV_FREE.

The first one was debugging as I could visibly see how much memory had
been freed by just checking the memory consumption by the guest. I didn't
have to wait for memory pressure to trigger the memory freeing. In
addition it would force the pages out of the guest so it was much easier
to see if I was freeing the wrong pages.

The second reason is because it is much more portable. The MADV_FREE has
only been a part of the Linux kernel since about 4.5. So if you are
running on an older kernel the option might not be available.

The third reason is simply effort involved. If I used MADV_DONTNEED then I
can just use ram_block_discard_range which is the same function used by
other parts of the balloon driver.

Finally it is my understanding is that MADV_FREE only works on anonymous
memory (https://elixir.bootlin.com/linux/v5.4/source/mm/madvise.c#L700). I
was concerned that using MADV_FREE wouldn't work if used on file backed
memory such as hugetlbfs which is an option for QEMU if I am not mistaken.

> > To track if a page is reported or not the Uptodate flag was repurposed and
> > used as a Reported flag for Buddy pages. We walk though the free list
> > isolating pages and adding them to the scatterlist until we either
> > encounter the end of the list or have filled the scatterlist with pages to
> > be reported. If we fill the scatterlist before we reach the end of the
> > list we rotate the list so that the first unreported page we encounter is
> > moved to the head of the list as that is where we will resume after we
> > have freed the reported pages back into the tail of the list.
> 
> So the boundary pointer didn't actually provide that big of a benefit I
> assume (IOW, worst thing is you have to re-scan the whole list)?

I rewrote the code quite a bit to get rid of the disadvantages.
Specifically what the boundary pointer was doing was saving our place in
the list when we left. Even without that we still had to re-scan the
entire list with each zone processed anyway. With these changes we end up
potentially having to perform one additional rescan per free list.

Where things differ now is that the fetching function doesn't bail out of
the list and start over per page. Instead it fills the entire scatterlist
before it exits, and before doing so it will advance the head to the next
non-reported page in the list. In addition instead of walking all of the
orders and migrate types looking for each page the code is now more
methodical and will only work one free list at a time and do not revisit
it until we have processed the entire zone.

Even with all that we still take a pretty significant performance hit in
the page shuffing case, however I am willing to give that up for the sake
of being less intrusive.

> > Below are the results from various benchmarks. I primarily focused on two
> > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > a modified version of will-it-scale/page_fault1 that was enabled to use
> > THP. I did this as it allows for better visibility into different parts
> > of the memory subsystem. The guest is running with 32G for RAM on one
> > node of a E5-2630 v3. The host has had some power saving features disabled
> > by setting the /dev/cpu_dma_latency value to 10ms.
> > 
> > Test                page_fault1 (THP)     page_fault2
> > Name         tasks  Process Iter  STDEV  Process Iter  STDEV
> > Baseline         1    1203934.75  0.04%     379940.75  0.11%
> >                 16    8828217.00  0.85%    3178653.00  1.28%
> > 
> > Patches applied  1    1207961.25  0.10%     380852.25  0.25%
> >                 16    8862373.00  0.98%    3246397.25  0.68%
> > 
> > Patches enabled  1    1207758.75  0.17%     373079.25  0.60%
> >  MADV disabled  16    8870373.75  0.29%    3204989.75  1.08%
> > 
> > Patches enabled  1    1261183.75  0.39%     373201.50  0.50%
> >                 16    8371359.75  0.65%    3233665.50  0.84%
> > 
> > Patches enabled  1    1090201.50  0.25%     376967.25  0.29%
> >  page shuffle   16    8108719.75  0.58%    3218450.25  1.07%
> > 
> > The results above are for a baseline with a linux-next-20191115 kernel,
> > that kernel with this patch set applied but page reporting disabled in
> > virtio-balloon, patches applied but the madvise disabled by direct
> > assigning a device, the patches applied and page reporting fully
> > enabled, and the patches enabled with page shuffling enabled.  These
> > results include the deviation seen between the average value reported here
> > versus the high and/or low value. I observed that during the test memory
> > usage for the first three tests never dropped whereas with the patches
> > fully enabled the VM would drop to using only a few GB of the host's
> > memory when switching from memhog to page fault tests.
> > 
> > Most of the overhead seen with this patch set enabled seems due to page
> > faults caused by accessing the reported pages and the host zeroing the page
> > before giving it back to the guest. This overhead is much more visible when
> > using THP than with standard 4K pages. In addition page shuffling seemed to
> > increase the amount of faults generated due to an increase in memory churn.
> 
> MADV_FREE would be interesting.

I can probably code something up. However that is going to push a bunch of
complexity into the QEMU code and doesn't really mean much to the kernel
code. I can probably add it as another QEMU patch to the set since it is
just a matter of having a function similar to ram_block_discard_range that
uses MADV_FREE instead of MADV_DONTNEED.

> > The overall guest size is kept fairly small to only a few GB while the test
> > is running. If the host memory were oversubscribed this patch set should
> > result in a performance improvement as swapping memory in the host can be
> > avoided.
> > 
> > A brief history on the background of unused page reporting can be found at:
> > https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/
> > 
> > Changes from v12:
> > https://lore.kernel.org/lkml/20191022221223.17338.5860.stgit@localhost.localdomain/
> > Rebased on linux-next 20191031
> > Renamed page_is_reported to page_reported
> > Renamed add_page_to_reported_list to mark_page_reported
> > Dropped unused definition of add_page_to_reported_list for non-reporting case
> > Split free_area_reporting out from get_unreported_tail
> > Minor updates to cover page
> > 
> > Changes from v13:
> > https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost.localdomain/
> > Rewrote core reporting functionality
> >   Merged patches 3 & 4
> >   Dropped boundary list and related code
> >   Folded get_reported_page into page_reporting_fill
> >   Folded page_reporting_fill into page_reporting_cycle
> > Pulled reporting functionality out of free_reported_page
> >   Renamed it to __free_isolated_page
> >   Moved page reporting specific bits to page_reporting_drain
> > Renamed phdev to prdev since we aren't "hinting" we are "reporting"
> > Added documentation to describe the usage of unused page reporting
> > Updated cover page and patch descriptions to avoid mention of boundary
> > 
> > 
> > ---
> > 
> > Alexander Duyck (6):
> >       mm: Adjust shuffle code to allow for future coalescing
> >       mm: Use zone and order instead of free area in free_list manipulators
> >       mm: Introduce Reported pages
> >       mm: Add unused page reporting documentation
> >       virtio-balloon: Pull page poisoning config out of free page hinting
> >       virtio-balloon: Add support for providing unused page reports to host
> > 
> > 
> >  Documentation/vm/unused_page_reporting.rst |   44 ++++
> >  drivers/virtio/Kconfig                     |    1 
> >  drivers/virtio/virtio_balloon.c            |   88 +++++++
> >  include/linux/mmzone.h                     |   56 +----
> >  include/linux/page-flags.h                 |   11 +
> >  include/linux/page_reporting.h             |   31 +++
> >  include/uapi/linux/virtio_balloon.h        |    1 
> >  mm/Kconfig                                 |   11 +
> >  mm/Makefile                                |    1 
> >  mm/memory_hotplug.c                        |    2 
> >  mm/page_alloc.c                            |  181 +++++++++++----
> >  mm/page_reporting.c                        |  337 ++++++++++++++++++++++++++++
> >  mm/page_reporting.h                        |  125 ++++++++++
> >  mm/shuffle.c                               |   12 -
> >  mm/shuffle.h                               |    6 
> >  15 files changed, 805 insertions(+), 102 deletions(-)
> 
> So roughly 100 LOC less added, that's nice to see :)
> 
> I'm planning to look into the details soon, just fairly busy lately. I
> hope Mel Et al. can also comment.

Agreed. I can see if I can generate something to get the MADV_FREE
numbers. I suspect they were probably be somewhere between the MADV
disabled and fully enabled case, since we will still be taking the page
faults but not doing the zeroing.

