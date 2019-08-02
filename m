Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0F18030E
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 01:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392560AbfHBXPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 19:15:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:52106 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbfHBXPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 19:15:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 16:15:23 -0700
X-IronPort-AV: E=Sophos;i="5.64,339,1559545200"; 
   d="scan'208";a="184721864"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 16:15:23 -0700
Message-ID: <c43723f2acdf257309dca55eac900dc71bca31c3.camel@linux.intel.com>
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
Date:   Fri, 02 Aug 2019 16:15:23 -0700
In-Reply-To: <ac434f1cad234920c0e75fe809ac05053395524b.camel@linux.intel.com>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
         <9cddf98d-e2ce-0f8a-d46c-e15a54bc7391@redhat.com>
         <3f6c133ec1eabb8f4fd5c0277f8af254b934b14f.camel@linux.intel.com>
         <291a1259-fd20-1712-0f0f-5abdefdca95f@redhat.com>
         <ac434f1cad234920c0e75fe809ac05053395524b.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-08-02 at 10:28 -0700, Alexander Duyck wrote:
> On Fri, 2019-08-02 at 12:19 -0400, Nitesh Narayan Lal wrote:
> > On 8/2/19 11:13 AM, Alexander Duyck wrote:
> > > On Fri, 2019-08-02 at 10:41 -0400, Nitesh Narayan Lal wrote:
> > > > On 8/1/19 6:24 PM, Alexander Duyck wrote:
> > > > > 

<snip>

> > > > > One side effect of these patches is that the guest becomes much more
> > > > > resilient in terms of NUMA locality. With the pages being freed and then
> > > > > reallocated when used it allows for the pages to be much closer to the
> > > > > active thread, and as a result there can be situations where this patch
> > > > > set will out-perform the stock kernel when the guest memory is not local
> > > > > to the guest vCPUs.
> > > > Was this the reason because of which you were seeing better results for
> > > > page_fault1 earlier?
> > > Yes I am thinking so. What I have found is that in the case where the
> > > patches are not applied on the guest it takes a few runs for the numbers
> > > to stabilize. What I think was going on is that I was running memhog to
> > > initially fill the guest and that was placing all the pages on one node or
> > > the other and as such was causing additional variability as the pages were
> > > slowly being migrated over to the other node to rebalance the workload.
> > > One way I tested it was by trying the unpatched case with a direct-
> > > assigned device since that forces it to pin the memory. In that case I was
> > > getting bad results consistently as all the memory was forced to come from
> > > one node during the pre-allocation process.
> > > 
> > 
> > I have also seen that the page_fault1 values take some time to get stabilize on
> > an unmodified kernel.
> > What I am wondering here is that if on a single NUMA guest doing the following
> > will give the right/better idea or not:
> > 
> > 1. Pin the guest to a single NUMA node.
> > 2. Run memhog so that it touches all the guest memory.
> > 3. Run will-it-scale/page_fault1.
> > 
> > Compare/observe the values for the last core (this is considering the other core
> > values doesn't drastically differ).
> 
> I'll rerun the test with qemu affinitized to one specific socket. It will
> cut the core/thread count down to 8/16 on my test system. Also I will try
> with THP and page shuffling enabled.

Okay so results with 8/16 all affinitized to one socket, THP enabled
page_fault1, and shuffling enabled:

With page reporting disabled in the hypervisor there wasn't much
difference. I saw a range of 0.69% to -1.35% versus baseline, and an
average of 0.16% improvement. So effectively no change.

With page reporting enabled I saw a range of -2.10% to -4.50%, with an
average of -3.05% regression. This is much closer to what I would expect
for this patch set as the page faulting, double zeroing (once in host, and
once in guest), and hinting process itself should have some overhead.

