Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2DD1470D5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWSdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 13:33:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:12374 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgAWSdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 13:33:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 10:33:38 -0800
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="220753681"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 10:33:38 -0800
Message-ID: <3e24a8ad7afe7c2f6ec8ffe7260a3e31bbe41651.camel@linux.intel.com>
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
Date:   Thu, 23 Jan 2020 10:33:37 -0800
In-Reply-To: <ad73c0c8-3a9c-8ffd-9a31-7e9a5cd5f246@amazon.com>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
         <914aa4c3-c814-45e0-830b-02796b00b762@amazon.com>
         <af0b12780092e0007ec9e6dbfc92bc15b604b8f4.camel@linux.intel.com>
         <ad73c0c8-3a9c-8ffd-9a31-7e9a5cd5f246@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-01-23 at 17:54 +0100, Alexander Graf wrote:
> 
> On 23.01.20 17:26, Alexander Duyck wrote:
> > On Thu, 2020-01-23 at 11:20 +0100, Alexander Graf wrote:
> > > Hi Alex,
> > > 
> > > On 22.01.20 18:43, Alexander Duyck wrote:
> [...]
> > > > The overall guest size is kept fairly small to only a few GB while the test
> > > > is running. If the host memory were oversubscribed this patch set should
> > > > result in a performance improvement as swapping memory in the host can be
> > > > avoided.
> > > 
> > > I really like the approach overall. Voluntarily propagating free memory
> > > from a guest to the host has been a sore point ever since KVM was
> > > around. This solution looks like a very elegant way to do so.
> > > 
> > > The big piece I'm missing is the page cache. Linux will by default try
> > > to keep the free list as small as it can in favor of page cache, so most
> > > of the benefit of this patch set will be void in real world scenarios.
> > 
> > Agreed. This is a the next piece of this I plan to work on once this is
> > accepted. For now the quick and dirty approach is to essentially make use
> > of the /proc/sys/vm/drop_caches interface in the guest by either putting
> > it in a cronjob somewhere or to have it after memory intensive workloads.
> > 
> > > Traditionally, this was solved by creating pressure from the host
> > > through virtio-balloon: Exactly the piece that this patch set gets away
> > > with. I never liked "ballooning", because the host has very limited
> > > visibility into the actual memory utility of its guests. So leaving the
> > > decision on how much memory is actually needed at a given point in time
> > > should ideally stay with the guest.
> > > 
> > > What would keep us from applying the page hinting approach to inactive,
> > > clean page cache pages? With writeback in place as well, we would slowly
> > > propagate pages from
> > > 
> > >     dirty -> clean -> clean, inactive -> free -> host owned
> > > 
> > > which gives a guest a natural path to give up "not important" memory.
> > 
> > I considered something similar. Basically one thought I had was to
> > essentially look at putting together some sort of epoch. When the host is
> > under memory pressure it would need to somehow notify the guest and then
> > the guest would start moving the epoch forward so that we start evicting
> > pages out of the page cache when the host is under memory pressure.
> 
> I think we want to consider an interface in which the host actively asks 
> guests to purge pages to be on the same line as swapping: The last line 
> of defense.

I suppose. The only reason I was thinking that we may want to look at
doing something like that was to avoid putting pressure on the guest when
the host doesn't need us to.

> In the normal mode of operation, you still want to shrink down 
> voluntarily, so that everyone cooperatively tries to make free for new 
> guests you could potentially run on the same host.
> 
> If you start to apply pressure to guests to find out of they might have 
> some pages to spare, we're almost back to the old style ballooning approach.

Thats true. In addition we avoid possible issues with us trying to flush
out a bunch of memory from multiple guests as once since they would be
proactively freeing the memory.

I'm thinking the inactive state could be something similar to MADV_FREE in
terms of behavior.  If it sits in the queue for long enough we decide
nobody is using it anymore so it is freed, but if it is accessed it is
cheap for us to just put it back without much in the way of overhead.

> Btw, have you ever looked at CMM2 [1]? With that, the host can 
> essentially just "steal" pages from the guest when it needs any, without 
> the need to execute the guest meanwhile. That means inside the host 
> swapping path, CMM2 can just evict guest page cache pages as easily as 
> we evict host page cache pages. To me, that's even more attractive in 
> the swap / emergency case than an interface which requires the guest to 
> proactively execute while we are in a low mem situation.

<snip>

> [1] https://www.kernel.org/doc/ols/2006/ols2006v2-pages-321-336.pdf

I hadn't read through this before. If nothing else the verbiage is useful
since what we are discussing is essentially how to deal with the
"volatile" pages within the system, the "unused" pages are the ones we
have reported to the host with the page reporting, and the "stable" pages
are those pages that have been faulted back into the guest when it
accessed them.

I can see there would be some advantages to CMM2, however it seems like it
is adding a significant amount of state to pages since it has to support a
fairly significant number of states and then there is the added complexity
for all the transitions in and out of stable from the various states
depending on how things are being changed.

Do you happen to know if anyone has done any research into how much
overhead is added with CMM2 enabled? I'd be curious since it seems like
the paper mentions having to track a signficant number of state
transitions for the memory throughout the kernel.

