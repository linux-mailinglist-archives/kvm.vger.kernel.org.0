Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C013211E8A6
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfLMQqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:46:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:47341 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfLMQqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 11:46:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:46:11 -0800
X-IronPort-AV: E=Sophos;i="5.69,309,1571727600"; 
   d="scan'208";a="204368997"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 08:46:10 -0800
Message-ID: <4d67ffe7a334d283d2641dbcae53bbc5123e70ad.camel@linux.intel.com>
Subject: Re: [PATCH v15 0/7] mm / virtio: Provide support for free page
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
Date:   Fri, 13 Dec 2019 08:46:10 -0800
In-Reply-To: <ead08075-c886-dc7d-2c7b-47b20e00b515@redhat.com>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
         <ead08075-c886-dc7d-2c7b-47b20e00b515@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-12-13 at 11:00 +0100, David Hildenbrand wrote:
> On 05.12.19 17:22, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting free guest pages
> > to a hypervisor so that the memory associated with those pages can be
> > dropped and reused by other processes and/or guests on the host. Using
> > this it is possible to avoid unnecessary I/O to disk and greatly improve
> > performance in the case of memory overcommit on the host.
> > 
> > When enabled we will be performing a scan of free memory every 2 seconds
> > while pages of sufficiently high order are being freed. Currently the order
> > used is pageblock_order so that this feature will not interfere with the
> > use of Transparent Huge Pages in the case of virtualization.
> > 
> > Currently this is only in use by virtio-balloon however there is the hope
> > that at some point in the future other hypervisors might be able to make
> > use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> > currently using MADV_DONTNEED to indicate to the host kernel that the page
> > is currently free. It will be zeroed and faulted back into the guest the
> > next time the page is accessed.
> > 
> > To track if a page is reported or not the Uptodate flag was repurposed and
> > used as a Reported flag for Buddy pages. We walk though the free list
> > isolating pages and adding them to the scatterlist until we either
> > encounter the end of the list, processed as many pages as were listed in
> > nr_free prior to us starting, or have filled the scatterlist with pages to
> > be reported. If we fill the scatterlist before we reach the end of the
> > list we rotate the list so that the first unreported page we encounter is
> > moved to the head of the list as that is where we will resume after we
> > have freed the reported pages back into the tail of the list.
> > 
> > Below are the results from various benchmarks. I primarily focused on two
> > tests. The first is the will-it-scale/page_fault2 test, and the other is
> > a modified version of will-it-scale/page_fault1 that was enabled to use
> > THP. I did this as it allows for better visibility into different parts
> > of the memory subsystem. The guest is running with 32G for RAM on one
> > node of a E5-2630 v3. The host has had some power saving features disabled
> > by setting the /dev/cpu_dma_latency value to 10ms.
> > 
> > Test                   page_fault1 (THP)    page_fault2
> > Name            tasks  Process Iter  STDEV  Process Iter  STDEV
> > Baseline            1    1208307.25  0.10%     408596.00  0.19%
> >                    16    8865204.75  0.16%    3344169.00  0.60%
> > 
> > Patches applied     1    1206809.00  0.26%     412558.25  0.32%
> >                    16    8814350.50  0.78%    3420102.00  1.16%
> > 
> > Patches enabled     1    1201386.25  0.21%     407903.75  0.32%
> >                    16    8880178.00  0.08%    3396700.50  0.54%
> > 
> > Patches enabled     1    1173529.00  1.04%     409006.50  0.45%
> >  page shuffle      16    8384540.25  0.74%    3288289.25  0.41%
> > 
> > Patches enabled     1    1193411.00  0.33%     406333.50  0.09%
> >  shuffle w/ RFC    16    8812639.75  0.73%    3321706.25  0.53%
> > 
> > The results above are for a baseline with a linux-next-20191203 kernel,
> > that kernel with this patch set applied but page reporting disabled in
> > virtio-balloon, the patches applied and page reporting fully enabled, the
> > patches enabled with page shuffling enabled, and the patches applied with
> > page shuffling enabled and an RFC patch that makes used of MADV_FREE in
> > QEMU. These results include the deviation seen between the average value
> > reported here versus the high and/or low value. I observed that during the
> > test memory usage for the first three tests never dropped whereas with the
> > patches fully enabled the VM would drop to using only a few GB of the
> > host's memory when switching from memhog to page fault tests.
> > 
> > Any of the overhead visible with this patch set enabled seems due to page
> > faults caused by accessing the reported pages and the host zeroing the page
> > before giving it back to the guest. This overhead is much more visible when
> > using THP than with standard 4K pages. In addition page shuffling seemed to
> > increase the amount of faults generated due to an increase in memory churn.
> > As seen in the data above, using MADV_FREE in QEMU mostly eliminates this
> > overhead.
> > 
> > The overall guest size is kept fairly small to only a few GB while the test
> > is running. If the host memory were oversubscribed this patch set should
> > result in a performance improvement as swapping memory in the host can be
> > avoided.
> > 
> > A brief history on the background of free page reporting can be found at:
> > https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.camel@linux.intel.com/
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
> > Changes from v14:
> > https://lore.kernel.org/lkml/20191119214454.24996.66289.stgit@localhost.localdomain/
> > Renamed "unused page reporting" to "free page reporting"
> >   Updated code, kconfig, and patch descriptions
> > Split out patch for __free_isolated_page
> >   Renamed function to __putback_isolated_page
> > Rewrote core reporting functionality
> >   Added logic to reschedule worker in 2 seconds instead of run to completion
> >   Removed reported_pages statistics
> >   Removed REPORTING_REQUESTED bit used in zone flags
> >   Replaced page_reporting_dev_info refcount with state variable
> >   Removed scatterlist from page_reporting_dev_info
> >   Removed capacity from page reporting device
> >   Added dynamic scatterlist allocation/free at start/end of reporting process
> >   Updated __free_one_page so that reported pages are not always added to tail
> >   Added logic to handle error from report function
> > Updated virtio-balloon patch that adds support for page reporting
> >   Updated patch description to try and highlight differences in approaches
> >   Updated logic to reflect that we cannot limit the scatterlist from device
> 
> Last time Mel said
> 
> "Ok, I'm ok with how this hooks into the allocator as the overhead is
> minimal. However, the patch itself still includes a number of
> optimisations instead of being a bare-boned implementation of the
> feature with optimisations layered on top."
> 
> and
> 
> "Either way, the separate patch could have supporting data on how much
> it improves the speed of reporting pages so it can be compared to any
> other optimisation that may be proposed. Supporting data would also help
> make the case that any complexity introduced by the optimisation is
> worthwhile."
> 
> But I was only partially following that discussion.
> 
> I can see that there is only one additional patch (before the reporting
> one) compared to the previous series on the MM side. Does that comment
> no longer apply (I can see e.g., "Removed REPORTING_REQUESTED bit used
> in zone flags" in the changelog) - IOW, did you drop all the
> optimizations in question for now? If so, can you share some performance
> differences with and without the previous optimizations? (just out of
> personal interest :) )

I found alternative approaches and did away with most of them. What I had
done is replaced the REPORTING_REQUESTED and reference count logic with
the state in order to guarantee that we will make our way through the list
and rearm the reporting thread if the work isn't completed.

One thing I still think I need to split out based on Mel's comments is the
list rotation and probably the new budget value I added.

As far as performance this new patch set performs better than the old one
did. Most of that is due to the fact that I increased the delay between
passes and dropped any optimizations for the shuffling code.

> Christmas is getting closer, and at least in Europe/Germany that usually
> means that things will slow down ... or however you want to call that.
> So I wouldn't expect too much review happening before next year (but I
> might be wrong of course).
> 
> Cheers!

That is one of the reasons why I wanted to see if there were any comments
I could get before the break. It gives me a chance to address them and
push one last patch set before I head out on Christmas break myself.

