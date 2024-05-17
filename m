Return-Path: <kvm+bounces-17708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4928C8CAF
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 21:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8F361F24618
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8E6140363;
	Fri, 17 May 2024 19:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="keqijqfQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DDC13E88B;
	Fri, 17 May 2024 19:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715973394; cv=none; b=JUThMU+DILK2fho71STnXnMu7fJeDb1oxm6suI3xftBIbmOZs6wCpRNCs+4wxZJW8OAm0z+58sQxn4ZScTqFTnQnPSiw4Im9BQL348OHeQOnlPYTUFz3xM3X16PgvYDoggSRYYei+F5dwEWkWuJzFAMFiRZLP30GdMj28uFNvJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715973394; c=relaxed/simple;
	bh=AdLTb+S12ECjINrC+lcxR6ymuekdRFo972UYhf0LNwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHZSrWc0YR7EewHYe0bu28fJoCDYRa20Of9fjh3dwtsuB6yInFg/T2F2Fb5CDw4DBAOlRWGdENkRuAhu00N1GKYVS5uQrMzOOHrG2i4XyPGqSQ5IfjSbgbtz3QiwhmIiWKREmnQ1fwd1vSyx/RYAeWvWi02DS3nJln6zqkxwLmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=keqijqfQ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715973393; x=1747509393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AdLTb+S12ECjINrC+lcxR6ymuekdRFo972UYhf0LNwE=;
  b=keqijqfQimR82yGDCbCXAomed+55Uv7RLXxzK+XLtQR+F3NaGOzDW/bV
   99flURMoZS74D5ylbKLjWOG206VSnif1A8K+IFp6plrRNDWUn3F677dVY
   aj30wYtgR+DiUfCJNFopDqHWtCnLHVkBgQlKFROy0v668aOPzzUCFpq/y
   2El2Dgh4XjbmAxWSMAENDky/BbwvvkQ4BYywYL6YwzOLbE2LwXK3ABLPY
   kdqd71cD3BSLfXJhsy05QZKc83yYHULmBe/hMKt10Y63VF1SmiRK+uz3C
   iz87+m5my8eni8LlUILDYCapyiorr4esNjJ6lpfCLIxDJhMzAWkZLRu7n
   Q==;
X-CSE-ConnectionGUID: l6N7WvW7Q4G2x6XBIXvtMw==
X-CSE-MsgGUID: b53rqZttTs2/wfh7Frh7rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="29679419"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="29679419"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 12:16:31 -0700
X-CSE-ConnectionGUID: aZrBwtK8QBGXT33FcsK3Bw==
X-CSE-MsgGUID: aFIXKuJ5Qlei+lPrX4Bsjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="69343285"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 12:16:30 -0700
Date: Fri, 17 May 2024 12:16:30 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240517191630.GC412700@ls.amr.corp.intel.com>
References: <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>

On Fri, May 17, 2024 at 06:16:26PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Fri, 2024-05-17 at 02:03 -0700, Isaku Yamahata wrote:
> > 
> > On top of your patch, I created the following patch to remove
> > kvm_gfn_for_root().
> > Although I haven't tested it yet, I think the following shows my idea.
> > 
> > - Add gfn_shared_mask to struct tdp_iter.
> > - Use iter.gfn_shared_mask to determine the starting sptep in the root.
> > - Remove kvm_gfn_for_root()
> 
> I investigated it.

Thanks for looking at it.


> After this, gfn_t's never have shared bit. It's a simple rule. The MMU mostly
> thinks it's operating on a shared root that is mapped at the normal GFN. Only
> the iterator knows that the shared PTEs are actually in a different location.
> 
> There are some negative side effects:
> 1. The struct kvm_mmu_page's gfn doesn't match it's actual mapping anymore.
> 2. As a result of above, the code that flushes TLBs for a specific GFN will be
> confused. It won't functionally matter for TDX, just look buggy to see flushing
> code called with the wrong gfn.

flush_remote_tlbs_range() is only for Hyper-V optimization.  In other cases,
x86_op.flush_remote_tlbs_range = NULL or the member isn't defined at compile
time.  So the remote tlb flush falls back to flushing whole range.  I don't
expect TDX in hyper-V guest.  I have to admit that the code looks superficially
broken and confusing.


> 3. A lot of tracepoints no longer have the "real" gfn

Anyway we'd like to sort out trace points and pr_err() eventually because we
already added new pferr flags.


> 4. mmio spte doesn't have the shared bit, as previous (no effect)
> 5. Some zapping code (__tdp_mmu_zap_root(), tdp_mmu_zap_leafs()) intends to
> actually operating on the raw_gfn. It wants to iterate the whole EPT, so it goes
> from 0 to tdp_mmu_max_gfn_exclusive(). So now for mirrored it does, but for
> shared it only covers the shared range. Basically kvm_mmu_max_gfn() is wrong if
> we pretend shared GFNs are just strangely mapped normal GFNs. Maybe we could
> just fix this up to report based on GPAW for TDX? Feels wrong.

Yes, it's broken with kvm_mmu_max_gfn().


> On the positive effects side:
> 1. There is code that passes sp->gfn into things that it shouldn't (if it has
> shared bits) like memslot lookups.
> 2. Also code that passes iter.gfn into things it shouldn't like
> kvm_mmu_max_mapping_level().
> 
> These places are not called by TDX, but if you know that gfn's might include
> shared bits, then that code looks buggy.
> 
> I think the solution in the diff is more elegant then before, because it hides
> what is really going on with the shared root. That is both good and bad. Can we
> accept the downsides?

Kai, do you have any thoughts?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

