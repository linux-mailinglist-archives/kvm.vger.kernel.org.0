Return-Path: <kvm+bounces-17553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3368C7D68
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 21:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6CB0282B91
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 19:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44AB9157467;
	Thu, 16 May 2024 19:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHZcpbwR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D650AD271;
	Thu, 16 May 2024 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715888532; cv=none; b=gPdg2flUWpPadvSI/ui0Lo/UeL1XyIzl1uW4ovfzi6x78sUtTuewwKBKAPZUy19gMPxTJor35pUYlQ+5S+vbOYop/5SqONg+6uP4/Wqowci/U0erAZrElP31WWB8hoxkj5uM90yOLDTej6Dq2soa2d4yXY/1j4RjWkUeku/phaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715888532; c=relaxed/simple;
	bh=aMfpaTppmylnv5JF/A7FOwPhC7HwUCujFk1v/GprbHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=udpS8V/H/gHuTiIeimswE9TnKCSIAhdenWv0JUoI2ggWYumIbXn3VmTPHvi2RkIMVP+wWXJibnqhLm32sqqu1cYMH1Kh+phhtgFLMq8q2Y05z35z8vRXhQ/4n4f4rBvM06ObpViUUSFzzMmuFhaLg0ab9oqr8HZGgRPbxq5nnCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHZcpbwR; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715888531; x=1747424531;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=aMfpaTppmylnv5JF/A7FOwPhC7HwUCujFk1v/GprbHw=;
  b=SHZcpbwRaDq+PZjWoRRl+Y1Z1ZT9C07YwMtQzJF9lFTckhaGuci2ne18
   85AqFp1P5HlnkzO+SKKlyAw5oaaeyJZ8mtyRI1BSrO8pgfdovzSZn68SN
   L2n6bpdDunmgbXy60FOIyQBWRvhV1moGW3E8ebus57e4FzHx5NyZgoTRV
   avvpkkr1bhGyvM31XOD+wxIyOa1NfzZSsMf733+mVQwmpEnQwFFX4w72t
   3FdXSkqX6Qo/wvaEVe9xowaQeIX3udBoQXtFC4nDFTgPaAM6nCdihwIMJ
   TeRy9fhKQjhrvpj45v3nYgCepOpNfsiuumhS3bFkxCAHESv4cvRTg1EPy
   Q==;
X-CSE-ConnectionGUID: DviGObKXTM6A1jzmP3dbvw==
X-CSE-MsgGUID: /hBFuJ25S2ahsCPOaQhGiA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11839164"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11839164"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 12:42:10 -0700
X-CSE-ConnectionGUID: i+ENKuZpR7qZB/pn19adww==
X-CSE-MsgGUID: 2+txm3wORD68LYg6FzkX0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="36285642"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 12:42:09 -0700
Date: Thu, 16 May 2024 12:42:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"sagis@google.com" <sagis@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240516194209.GL168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>

On Thu, May 16, 2024 at 04:36:48PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-05-16 at 13:04 +0000, Huang, Kai wrote:
> > On Thu, 2024-05-16 at 02:57 +0000, Edgecombe, Rick P wrote:
> > > On Thu, 2024-05-16 at 14:07 +1200, Huang, Kai wrote:
> > > > 
> > > > I meant it seems we should just strip shared bit away from the GPA in 
> > > > handle_ept_violation() and pass it as 'cr2_or_gpa' here, so fault->addr 
> > > > won't have the shared bit.
> > > > 
> > > > Do you see any problem of doing so?
> > > 
> > > We would need to add it back in "raw_gfn" in kvm_tdp_mmu_map().
> > 
> > I don't see any big difference?
> > 
> > Now in this patch the raw_gfn is directly from fault->addr:
> > 
> >         raw_gfn = gpa_to_gfn(fault->addr);
> > 
> >         tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn+1) {
> >                 ...
> >         }
> > 
> > But there's nothing wrong to get the raw_gfn from the fault->gfn.  In
> > fact, the zapping code just does this:
> > 
> >         /*
> >          * start and end doesn't have GFN shared bit.  This function zaps
> >          * a region including alias.  Adjust shared bit of [start, end) if
> >          * the root is shared.
> >          */
> >         start = kvm_gfn_for_root(kvm, root, start);
> >         end = kvm_gfn_for_root(kvm, root, end);
> > 
> > So there's nothing wrong to just do the same thing in both functions.
> > 
> > The point is fault->gfn has shared bit stripped away at the beginning, and
> > AFAICT there's no useful reason to keep shared bit in fault->addr.  The
> > entire @fault is a temporary structure on the stack during fault handling
> > anyway.
> 
> I would like to avoid code churn at this point if there is not a real clear
> benefit.
> 
> One small benefit of keeping the shared bit in the fault->addr is that it is
> sort of consistent with how that field is used in other scenarios in KVM. In
> shadow paging it's not even the GPA. So it is simply the "fault address" and has
> to be interpreted in different ways in the fault handler. For TDX the fault
> address *does* include the shared bit. And the EPT needs to be faulted in at
> that address.
> 
> If we strip the shared bit when setting fault->addr we have to reconstruct it
> when we do the actual shared mapping. There is no way around that. Which helper
> does it, isn't important I think. Doing the reconstruction inside
> tdp_mmu_for_each_pte() could be neat, except that it doesn't know about the
> shared bit position.
> 
> The zapping code's use of kvm_gfn_for_root() is different because the gfn comes
> without the shared bit. It's not stripped and then added back. Those are
> operations that target GFNs really.
> 
> I think the real problem is that we are gleaning whether the fault is to private
> or shared memory from different things. Sometimes from fault->is_private,
> sometimes the presence of the shared bits, and sometimes the role bit. I think
> this is confusing, doubly so because we are using some of these things to infer
> unrelated things (mirrored vs private).

It's confusing we don't check it in uniform way.


> My guess is that you have noticed this and somehow zeroed in on the shared_mask.
> I think we should straighten out the mirrored/private semantics and see what the
> results look like. How does that sound to you?

I had closer look of the related code.  I think we can (mostly) uniformly use
gpa/gfn without shared mask.  Here is the proposal.  We need a real patch to see
how the outcome looks like anyway.  I think this is like what Kai is thinking
about.


- rename role.is_private => role.is_mirrored_pt

- sp->gfn: gfn without shared bit.

- fault->address: without gfn_shared_mask
  Actually it doesn't matter much.  We can use gpa with gfn_shared_mask.

- Update struct tdp_iter
  struct tdp_iter
    gfn: gfn without shared bit

    /* Add new members */

    /* Indicates which PT to walk. */
    bool mirrored_pt;

    // This is used tdp_iter_refresh_sptep()
    // shared gfn_mask if mirrored_pt
    // 0 if !mirrored_pt
    gfn_shared_mask

- Pass mirrored_pt and gfn_shared_mask to
  tdp_iter_start(..., mirrored_pt, gfn_shared_mask)

  and update tdp_iter_refresh_sptep()
  static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
        ...
        iter->sptep = iter->pt_path[iter->level - 1] +
                SPTE_INDEX((iter->gfn << PAGE_SHIFT) | iter->gfn_shared_mask, iter->level);

  Change for_each_tdp_mte_min_level() accordingly.
  Also the iteretor to call this.
   
  #define for_each_tdp_pte_min_level(kvm, iter, root, min_level, start, end)      \
          for (tdp_iter_start(&iter, root, min_level, start,                      \
               mirrored_root, mirrored_root ? kvm_gfn_shared_mask(kvm) : 0);      \
               iter.valid && iter.gfn < kvm_gfn_for_root(kvm, root, end);         \
               tdp_iter_next(&iter))

- trace point: update to include mirroredd_pt. Or Leave it as is for now.

- pr_err() that log gfn in handle_changed_spte()
  Update to include mirrored_pt. Or Leave it as is for now.

- Update spte handler (handle_changed_spte(), handle_removed_pt()...),
  use iter->mirror_pt or pass down mirror_pt.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

