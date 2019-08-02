Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090EE7FF92
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 19:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405108AbfHBR2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 13:28:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:22555 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405025AbfHBR2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 13:28:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 10:28:29 -0700
X-IronPort-AV: E=Sophos;i="5.64,338,1559545200"; 
   d="scan'208";a="167292961"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 10:28:28 -0700
Message-ID: <ac434f1cad234920c0e75fe809ac05053395524b.camel@linux.intel.com>
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
Date:   Fri, 02 Aug 2019 10:28:28 -0700
In-Reply-To: <291a1259-fd20-1712-0f0f-5abdefdca95f@redhat.com>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
         <9cddf98d-e2ce-0f8a-d46c-e15a54bc7391@redhat.com>
         <3f6c133ec1eabb8f4fd5c0277f8af254b934b14f.camel@linux.intel.com>
         <291a1259-fd20-1712-0f0f-5abdefdca95f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-08-02 at 12:19 -0400, Nitesh Narayan Lal wrote:
> On 8/2/19 11:13 AM, Alexander Duyck wrote:
> > On Fri, 2019-08-02 at 10:41 -0400, Nitesh Narayan Lal wrote:
> > > On 8/1/19 6:24 PM, Alexander Duyck wrote:
> > > > This series provides an asynchronous means of reporting to a hypervisor
> > > > that a guest page is no longer in use and can have the data associated
> > > > with it dropped. To do this I have implemented functionality that allows
> > > > for what I am referring to as unused page reporting
> > > > 
> > > > The functionality for this is fairly simple. When enabled it will allocate
> > > > statistics to track the number of reported pages in a given free area.
> > > > When the number of free pages exceeds this value plus a high water value,
> > > > currently 32, it will begin performing page reporting which consists of
> > > > pulling pages off of free list and placing them into a scatter list. The
> > > > scatterlist is then given to the page reporting device and it will perform
> > > > the required action to make the pages "reported", in the case of
> > > > virtio-balloon this results in the pages being madvised as MADV_DONTNEED
> > > > and as such they are forced out of the guest. After this they are placed
> > > > back on the free list, and an additional bit is added if they are not
> > > > merged indicating that they are a reported buddy page instead of a
> > > > standard buddy page. The cycle then repeats with additional non-reported
> > > > pages being pulled until the free areas all consist of reported pages.
> > > > 
> > > > I am leaving a number of things hard-coded such as limiting the lowest
> > > > order processed to PAGEBLOCK_ORDER, and have left it up to the guest to
> > > > determine what the limit is on how many pages it wants to allocate to
> > > > process the hints. The upper limit for this is based on the size of the
> > > > queue used to store the scatterlist.
> > > > 
> > > > My primary testing has just been to verify the memory is being freed after
> > > > allocation by running memhog 40g on a 40g guest and watching the total
> > > > free memory via /proc/meminfo on the host. With this I have verified most
> > > > of the memory is freed after each iteration. As far as performance I have
> > > > been mainly focusing on the will-it-scale/page_fault1 test running with
> > > > 16 vcpus. With that I have seen up to a 2% difference between the base
> > > > kernel without these patches and the patches with virtio-balloon enabled
> > > > or disabled.
> > > A couple of questions:
> > > 
> > > - The 2% difference which you have mentioned, is this visible for
> > >   all the 16 cores or just the 16th core?
> > > - I am assuming that the difference is seen for both "number of process"
> > >   and "number of threads" launched by page_fault1. Is that right?
> > Really, the 2% is bordering on just being noise. Sometimes it is better
> > sometimes it is worse. However I think it is just slight variability in
> > the tests since it doesn't usually form any specific pattern.
> > 
> > I have been able to tighten it down a bit by actually splitting my guest
> > over 2 nodes and pinning the vCPUs so that the nodes in the guest match up
> > to the nodes in the host. Doing that I have seen results where I had less
> > than 1% variability between with the patches and without.
> 
> Interesting. I usually pin the guest to a single NUMA node to avoid this.

I was trying to put as much stress on this as I could so my thought was
the more CPUs the better. Also an added advantage to splitting the guest
over 2 nodes is that it split the zone locks up so that it reduced how
much of a bottleneck it was.

> > One thing I am looking at now is modifying the page_fault1 test to use THP
> > instead of 4K pages as I suspect there is a fair bit of overhead in
> > accessing the pages 4K at a time vs 2M at a time. I am hoping with that I
> > can put more pressure on the actual change and see if there are any
> > additional spots I should optimize.
> 
> +1. Right now I don't think will-it-scale touches all the guest memory.
> May I know how much memory does will-it-scale/page_fault1, occupies in your case
> and how much do you get back with your patch-set?

If I recall correctly each process/thread of the page_fault1 test occupies
128MB or memory per iteration. When you consider the base case with 1
thread is a half million iterations that should be something like up to
64GB allocated and freed per thread.

One thing I overlooked testing this time around was a setup with memory
shuffling enabled. That would cause the iterations to use a larger swath
of memory as each 128G would have chunks randomly placed on the tail of
the free lists. I will try to go and re-run a test on a pair of kernels
with that enabled to see if that has any effect.

> Do you have any plans of running any other benchmarks as well?
> Just to see the impact on other sub-systems.

The problem is other benchmarks such as netperf aren't going to show much
since they tend to operate on 4K pages, and add a bunch of additional
overhead such as skb allocation and network header processing.

What I am trying to do is focus on benchmarking just the changes without
getting too much other code pulled in. That is why I am thinking
page_fault1 modified so that it will MADV_HUGEPAGE is probably the ideal
test for this. Currently the 4K page size of page_fault1 is likely adding
a bunch of overhead for us having to split and merge pages and that would
be one of the reasons why the changes are essentially falling into the
noise.

By using THP it will be triggering allocations of higher-order pages and
then freeing that memory at the higher order as well. By using THP it can
do that much quicker and I can avoid the split/merge overhead. I am seeing
something on the order of about 1.3 million iterations per thread versus
the 500 thousand I was seeing with standard pages.

> > > > One side effect of these patches is that the guest becomes much more
> > > > resilient in terms of NUMA locality. With the pages being freed and then
> > > > reallocated when used it allows for the pages to be much closer to the
> > > > active thread, and as a result there can be situations where this patch
> > > > set will out-perform the stock kernel when the guest memory is not local
> > > > to the guest vCPUs.
> > > Was this the reason because of which you were seeing better results for
> > > page_fault1 earlier?
> > Yes I am thinking so. What I have found is that in the case where the
> > patches are not applied on the guest it takes a few runs for the numbers
> > to stabilize. What I think was going on is that I was running memhog to
> > initially fill the guest and that was placing all the pages on one node or
> > the other and as such was causing additional variability as the pages were
> > slowly being migrated over to the other node to rebalance the workload.
> > One way I tested it was by trying the unpatched case with a direct-
> > assigned device since that forces it to pin the memory. In that case I was
> > getting bad results consistently as all the memory was forced to come from
> > one node during the pre-allocation process.
> > 
> 
> I have also seen that the page_fault1 values take some time to get stabilize on
> an unmodified kernel.
> What I am wondering here is that if on a single NUMA guest doing the following
> will give the right/better idea or not:
> 
> 1. Pin the guest to a single NUMA node.
> 2. Run memhog so that it touches all the guest memory.
> 3. Run will-it-scale/page_fault1.
> 
> Compare/observe the values for the last core (this is considering the other core
> values doesn't drastically differ).

I'll rerun the test with qemu affinitized to one specific socket. It will
cut the core/thread count down to 8/16 on my test system. Also I will try
with THP and page shuffling enabled.

