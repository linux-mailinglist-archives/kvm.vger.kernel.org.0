Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80062159DB7
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgBKXzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:55:32 -0500
Received: from mga06.intel.com ([134.134.136.31]:29633 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgBKXzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 18:55:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 15:55:31 -0800
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="226679926"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 15:55:31 -0800
Message-ID: <c45a6e8ab6af089da1001c0db28783dcea6bebd5.camel@linux.intel.com>
Subject: Re: [PATCH v17 0/9] mm / virtio: Provide support for free page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, yang.zhang.wz@gmail.com,
        pagupta@redhat.com, konrad.wilk@oracle.com, nitesh@redhat.com,
        riel@surriel.com, willy@infradead.org, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        vbabka@suse.cz, osalvador@suse.de
Date:   Tue, 11 Feb 2020 15:55:31 -0800
In-Reply-To: <20200211150510.ca864143284c8ccaa906f524@linux-foundation.org>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
         <20200211150510.ca864143284c8ccaa906f524@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-02-11 at 15:05 -0800, Andrew Morton wrote:
> On Tue, 11 Feb 2020 14:45:51 -0800 Alexander Duyck <alexander.duyck@gmail.com> wrote:
> 
> > This series provides an asynchronous means of reporting free guest pages
> > to a hypervisor so that the memory associated with those pages can be
> > dropped and reused by other processes and/or guests on the host. Using
> > this it is possible to avoid unnecessary I/O to disk and greatly improve
> > performance in the case of memory overcommit on the host.
> 
> "greatly improve" sounds nice.
> 
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
> > encounter the end of the list or have processed at least one sixteenth of
> > the pages that were listed in nr_free prior to us starting. If we fill the
> > scatterlist before we reach the end of the list we rotate the list so that
> > the first unreported page we encounter is moved to the head of the list as
> > that is where we will resume after we have freed the reported pages back
> > into the tail of the list.
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
> >                    16    8827457.25  0.09%    3282347.00  0.34%
> > 
> > Patches Applied     1    1007897.00  0.23%     361887.00  0.26%
> >                    16    8784741.75  0.39%    3240669.25  0.48%
> > 
> > Patches Enabled     1    1010227.50  0.39%     359749.25  0.56%
> >                    16    8756219.00  0.24%    3226608.75  0.97%
> > 
> > Patches Enabled     1    1050982.00  4.26%     357966.25  0.14%
> >  page shuffle      16    8672601.25  0.49%    3223177.75  0.40%
> > 
> > Patches enabled     1    1003238.00  0.22%     360211.00  0.22%
> >  shuffle w/ RFC    16    8767010.50  0.32%    3199874.00  0.71%
> 
> But these differences seem really small - around 1%?  I think we're
> just showing not much harm was caused?

Yes. Basically I am just showing the iterations are not negatively
impacted. The big difference between the cases where it is enabled versus
the cases where it is not is that the guest memory footprint is much
smaller in the enabled cases than in the baseline or "Applied" cases.

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
> 
> And this is the "great improvement", yes?

Yes, this is the great improvement. Basically what we get is effectively
auto-ballooning so the guests aren't having to go to swap when they start
to get loaded up since they are returning the memory to the host when they
are done with it.

> Is it possible to measure the end-user-visible benefits of this?

If I clear the page cache on my host via drop_caches, fire up my 32G VM,
and run the following commands:
  memhog 32g
  echo 3 > /proc/sys/vm/drop_caches

On the host I just have to monitor /proc/meminfo and I can see the
difference. I get the following results on the host, in the enabled case
it takes about 30 seconds for it to settle into the final state since I
only report page a bit at a time:
Baseline/Applied
  MemTotal:    131963012 kB
  MemFree:      95189740 kB

Enabled:
  MemTotal:    131963012 kB
  MemFree:     126459472 kB

This is what I was referring to with the comment above. I had a test I was
running back around the first RFC that consisted of bringing up enough VMs
so that there was a bit of memory overcommit and then having the VMs in
turn run memhog. As I recall the difference between the two was  something
like a couple minutes to run through all the VMs as the memhog would take
up to 40+ seconds for one that was having to pull from swap while it took
only 5 to 7 seconds for the VMs that were all running the page hinting.

I had referenced it here in the RFC:
https://lore.kernel.org/lkml/20190204181118.12095.38300.stgit@localhost.localdomain/

I have been verifying the memory has been getting freed but didn't feel
like the test added much value so I haven't added it to the cover page for
a while since the time could vary widely and is dependent on things like
the disk type used for the host swap since my SSD is likely faster than
spinning rust, but may not be as fast as other SSDs on the market. Since
the disk speed can play such a huge role I wasn't comfortable posting
numbers since the benefits could vary so widely.

> > Any of the overhead visible with this patch set enabled seems due to page
> > faults caused by accessing the reported pages and the host zeroing the page
> > before giving it back to the guest. This overhead is much more visible when
> > using THP than with standard 4K pages. In addition page shuffling seemed to
> > increase the amount of faults generated due to an increase in memory churn.
> > The overehad is reduced when using MADV_FREE as we can avoid the extra
> > zeroing of the pages when they are reintroduced to the host, as can be seen
> > when the RFC is applied with shuffling enabled.
> > 
> > The overall guest size is kept fairly small to only a few GB while the test
> > is running. If the host memory were oversubscribed this patch set should
> > result in a performance improvement as swapping memory in the host can be
> > avoided.
> 
> "should result".  Can we firm this up a lot?

I said "should result" here because if the guests are using all of their
memory then the free page reporting won't make a difference since you have
to have free pages before they can be reported. Also we cannot use free
page reporting in the cases such as when a device is direct assigned into
the guest as that currently prevents us from disassociating a page from
the guest.




