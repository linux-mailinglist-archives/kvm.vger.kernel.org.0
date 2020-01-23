Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5736A146E49
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 17:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAWQ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 11:26:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:20351 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgAWQ0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 11:26:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 08:26:39 -0800
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="220715783"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 08:26:39 -0800
Message-ID: <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
Subject: Re: [PATCH v16.1 0/9] mm / virtio: Provide support for free page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Alexander Graf <graf@amazon.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, osalvador@suse.de,
        "Paterson-Jones, Roland" <rolandp@amazon.com>, hannes@cmpxchg.org,
        hare@suse.com
Date:   Thu, 23 Jan 2020 08:26:39 -0800
In-Reply-To: <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
         <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-01-23 at 11:20 +0100, Alexander Graf wrote:
> Hi Alex,
> 
> On 22.01.20 18:43, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting free guest pages
> > to a hypervisor so that the memory associated with those pages can be
> > dropped and reused by other processes and/or guests on the host. Using
> > this it is possible to avoid unnecessary I/O to disk and greatly improve
> > performance in the case of memory overcommit on the host.
> > 
> > When enabled we will be performing a scan of free memory every 2 seconds
> > while pages of sufficiently high order are being freed. In each pass at
> > least one sixteenth of each free list will be reported. By doing this we
> > avoid racing against other threads that may be causing a high amount of
> > memory churn.
> > 
> > The lowest page order currently scanned when reporting pages is
> > pageblock_order so that this feature will not interfere with the use of
> > Transparent Huge Pages in the case of virtualization.
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
> > node of a E5-2630 v3. The host has had some features such as CPU turbo
> > disabled in the BIOS.
> > 
> > Test                   page_fault1 (THP)    page_fault2
> > Name            tasks  Process Iter  STDEV  Process Iter  STDEV
> > Baseline            1    1012402.50  0.14%     361855.25  0.81%
> >                     16    8827457.25  0.09%    3282347.00  0.34%
> > 
> > Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
> >                     16    8784741.75  0.39%    3240669.25  0.48%
> > 
> > Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
> >                     16    8756219.00  0.24%    3226608.75  0.97%
> > 
> > Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
> >   page shuffle      16    8672601.25  0.49%    3223177.75  0.40%
> > 
> > Patches enabled     1    1003238.00  0.22%     360211.00  0.22%
> >   shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%
> > 
> > The results above are for a baseline with a linux-next-20191219 kernel,
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
> > The overhead is reduced when using MADV_FREE as we can avoid the extra
> > zeroing of the pages when they are reintroduced to the host, as can be seen
> > when the RFC is applied with shuffling enabled.
> > 
> > The overall guest size is kept fairly small to only a few GB while the test
> > is running. If the host memory were oversubscribed this patch set should
> > result in a performance improvement as swapping memory in the host can be
> > avoided.
> 
> I really like the approach overall. Voluntarily propagating free memory 
> from a guest to the host has been a sore point ever since KVM was 
> around. This solution looks like a very elegant way to do so.
> 
> The big piece I'm missing is the page cache. Linux will by default try 
> to keep the free list as small as it can in favor of page cache, so most 
> of the benefit of this patch set will be void in real world scenarios.

Agreed. This is a the next piece of this I plan to work on once this is
accepted. For now the quick and dirty approach is to essentially make use
of the /proc/sys/vm/drop_caches interface in the guest by either putting
it in a cronjob somewhere or to have it after memory intensive workloads.

> Traditionally, this was solved by creating pressure from the host 
> through virtio-balloon: Exactly the piece that this patch set gets away 
> with. I never liked "ballooning", because the host has very limited 
> visibility into the actual memory utility of its guests. So leaving the 
> decision on how much memory is actually needed at a given point in time 
> should ideally stay with the guest.
> 
> What would keep us from applying the page hinting approach to inactive, 
> clean page cache pages? With writeback in place as well, we would slowly 
> propagate pages from
> 
>    dirty -> clean -> clean, inactive -> free -> host owned
> 
> which gives a guest a natural path to give up "not important" memory.

I considered something similar. Basically one thought I had was to
essentially look at putting together some sort of epoch. When the host is
under memory pressure it would need to somehow notify the guest and then
the guest would start moving the epoch forward so that we start evicting
pages out of the page cache when the host is under memory pressure.

> The big problem I see is that what I really want from a user's point of 
> view is a tuneable that says "Automatically free clean page cache pages 
> that were not accessed in the last X minutes". Otherwise we may run into 
> the risk of evicting some times in use page cache pages.
> 
> I have a hard time grasping the mm code to understand how hard that 
> would be to implement that though :).
> 
> 
> Alex

Yeah, I am not exactly an expert on this either as I have only been
working int he MM tree for about a year now.

I have submitted this as a topic for LSF/MM summit[1] and I am hoping to
get some feedback on the best way to apply proactive memory pressure as
one of the subtopics if iti s selected.

Thanks.

- Alex

[1]: https://lore.kernel.org/linux-mm/4b8671d16573307da09afc56030c2a5f5a9c45bf.camel@linux.intel.com/


