Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248647FD28
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfHBPN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 11:13:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:27126 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbfHBPN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 11:13:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 08:13:56 -0700
X-IronPort-AV: E=Sophos;i="5.64,338,1559545200"; 
   d="scan'208";a="324597851"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 08:13:56 -0700
Message-ID: <3f6c133ec1eabb8f4fd5c0277f8af254b934b14f.camel@linux.intel.com>
Subject: Re: [PATCH v3 0/6] mm / virtio: Provide support for unused page
 reporting
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com
Date:   Fri, 02 Aug 2019 08:13:56 -0700
In-Reply-To: <9cddf98d-e2ce-0f8a-d46c-e15a54bc7391@redhat.com>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
         <9cddf98d-e2ce-0f8a-d46c-e15a54bc7391@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-08-02 at 10:41 -0400, Nitesh Narayan Lal wrote:
> On 8/1/19 6:24 PM, Alexander Duyck wrote:
> > This series provides an asynchronous means of reporting to a hypervisor
> > that a guest page is no longer in use and can have the data associated
> > with it dropped. To do this I have implemented functionality that allows
> > for what I am referring to as unused page reporting
> > 
> > The functionality for this is fairly simple. When enabled it will allocate
> > statistics to track the number of reported pages in a given free area.
> > When the number of free pages exceeds this value plus a high water value,
> > currently 32, it will begin performing page reporting which consists of
> > pulling pages off of free list and placing them into a scatter list. The
> > scatterlist is then given to the page reporting device and it will perform
> > the required action to make the pages "reported", in the case of
> > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > and as such they are forced out of the guest. After this they are placed
> > back on the free list, and an additional bit is added if they are not
> > merged indicating that they are a reported buddy page instead of a
> > standard buddy page. The cycle then repeats with additional non-reported
> > pages being pulled until the free areas all consist of reported pages.
> > 
> > I am leaving a number of things hard-coded such as limiting the lowest
> > order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
> > determine what the limit is on how many pages it wants to allocate to
> > process the hints. The upper limit for this is based on the size of the
> > queue used to store the scatterlist.
> > 
> > My primary testing has just been to verify the memory is being freed after
> > allocation by running memhog 40g on a 40g guest and watching the total
> > free memory via /proc/meminfo on the host. With this I have verified most
> > of the memory is freed after each iteration. As far as performance I have
> > been mainly focusing on the will-it-scale/page_fault1 test running with
> > 16 vcpus. With that I have seen up to a 2% difference between the base
> > kernel without these patches and the patches with virtio-balloon enabled
> > or disabled.
> 
> A couple of questions:
> 
> - The 2% difference which you have mentioned, is this visible for
>   all the 16 cores or just the 16th core?
> - I am assuming that the difference is seen for both "number of process"
>   and "number of threads" launched by page_fault1. Is that right?

Really, the 2% is bordering on just being noise. Sometimes it is better
sometimes it is worse. However I think it is just slight variability in
the tests since it doesn't usually form any specific pattern.

I have been able to tighten it down a bit by actually splitting my guest
over 2 nodes and pinning the vCPUs so that the nodes in the guest match up
to the nodes in the host. Doing that I have seen results where I had less
than 1% variability between with the patches and without.

One thing I am looking at now is modifying the page_fault1 test to use THP
instead of 4K pages as I suspect there is a fair bit of overhead in
accessing the pages 4K at a time vs 2M at a time. I am hoping with that I
can put more pressure on the actual change and see if there are any
additional spots I should optimize.

> > One side effect of these patches is that the guest becomes much more
> > resilient in terms of NUMA locality. With the pages being freed and then
> > reallocated when used it allows for the pages to be much closer to the
> > active thread, and as a result there can be situations where this patch
> > set will out-perform the stock kernel when the guest memory is not local
> > to the guest vCPUs.
> 
> Was this the reason because of which you were seeing better results for
> page_fault1 earlier?

Yes I am thinking so. What I have found is that in the case where the
patches are not applied on the guest it takes a few runs for the numbers
to stabilize. What I think was going on is that I was running memhog to
initially fill the guest and that was placing all the pages on one node or
the other and as such was causing additional variability as the pages were
slowly being migrated over to the other node to rebalance the workload.
One way I tested it was by trying the unpatched case with a direct-
assigned device since that forces it to pin the memory. In that case I was
getting bad results consistently as all the memory was forced to come from
one node during the pre-allocation process.

