Return-Path: <kvm+bounces-17582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB2D8C8284
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:17:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 196A01F22ACA
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 08:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B1D7224D1;
	Fri, 17 May 2024 08:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H+hJ02oP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A87C18651;
	Fri, 17 May 2024 08:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715933867; cv=none; b=GU+VThvi2f42rZP2rzjjcHTnzlVj0L0t5RXInJ2lGeaQM7ZweTMtzrBRDxHivknIZ0zXK6j3azCCrGSZFREcK1Ai5OzevPwkOutGHmDPm5dLfCOQLWYPxCmeHpEiByIFyKDaeitpe42YmydTsP0vDM8btUPcE7v5dz8ZBGEI1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715933867; c=relaxed/simple;
	bh=6XyLQCJHzjEhn+NcHrwI6HiuuveUlb/e3fhUH9ZIxPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHtPmGwNPe2Jr6yvfjGhNSLzA5X6YNravxDOLXYSTh1+bLR+xz3drXvKGE1qTUwdxHzaZ70z7ilqPV5ifzjerGWZqwRBtiw9coD9iu2SH81kaX8ylkEjq1g6W99Th3+MPHzg2Fgb/uleI17tm3zSd4UxIIXxlKjisdaLESZDIdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H+hJ02oP; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715933865; x=1747469865;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6XyLQCJHzjEhn+NcHrwI6HiuuveUlb/e3fhUH9ZIxPI=;
  b=H+hJ02oP9AQzTd0zhekj/ugydK/MFoCFRJ20H+8QvXrLmRye3ashe3Il
   ZWZbouU+7Fj+BI8ixbiBgaK65fP+T+PDrVc1Un9gOHXFISpUtDVhpqp0n
   LY+JWIfkUGPIAPW4aRN7LjYx521IaykHjY3/fn5MC77I40mKL0L1a2A+5
   WdAujOWUlh0dIZvWQxTlcaeY/EYTxcvLtlSxjMlqQpMnZ4yq1fdOvhUBy
   U1xDPYx1ruuJuKpFKccIuIF8oAJ4QMIbrtrQzgFpYw+lMlTe2DlBG/A05
   9gNqdVJK9rMUqr2hpbXYqWwCVejg1czuh+eNTi2IQTjI3icpXVFyUU0TU
   Q==;
X-CSE-ConnectionGUID: yaOI4LirSqS7k2r3wV4e6w==
X-CSE-MsgGUID: kp9SFcgkTqy4IXpCLeB+Lg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11902954"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="11902954"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 01:14:42 -0700
X-CSE-ConnectionGUID: gap6KCSNRa67dr9DK7j7sA==
X-CSE-MsgGUID: OqWrmzK8Qi+vfIC1Gxjp8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31659044"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 01:14:40 -0700
Date: Fri, 17 May 2024 01:14:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"sagis@google.com" <sagis@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240517081440.GM168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>

On Fri, May 17, 2024 at 02:36:43PM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On 17/05/2024 7:42 am, Isaku Yamahata wrote:
> > On Thu, May 16, 2024 at 04:36:48PM +0000,
> > "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
> > 
> > > On Thu, 2024-05-16 at 13:04 +0000, Huang, Kai wrote:
> > > > On Thu, 2024-05-16 at 02:57 +0000, Edgecombe, Rick P wrote:
> > > > > On Thu, 2024-05-16 at 14:07 +1200, Huang, Kai wrote:
> > > > > > 
> > > > > > I meant it seems we should just strip shared bit away from the GPA in
> > > > > > handle_ept_violation() and pass it as 'cr2_or_gpa' here, so fault->addr
> > > > > > won't have the shared bit.
> > > > > > 
> > > > > > Do you see any problem of doing so?
> > > > > 
> > > > > We would need to add it back in "raw_gfn" in kvm_tdp_mmu_map().
> > > > 
> > > > I don't see any big difference?
> > > > 
> > > > Now in this patch the raw_gfn is directly from fault->addr:
> > > > 
> > > >          raw_gfn = gpa_to_gfn(fault->addr);
> > > > 
> > > >          tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn+1) {
> > > >                  ...
> > > >          }
> > > > 
> > > > But there's nothing wrong to get the raw_gfn from the fault->gfn.  In
> > > > fact, the zapping code just does this:
> > > > 
> > > >          /*
> > > >           * start and end doesn't have GFN shared bit.  This function zaps
> > > >           * a region including alias.  Adjust shared bit of [start, end) if
> > > >           * the root is shared.
> > > >           */
> > > >          start = kvm_gfn_for_root(kvm, root, start);
> > > >          end = kvm_gfn_for_root(kvm, root, end);
> > > > 
> > > > So there's nothing wrong to just do the same thing in both functions.
> > > > 
> > > > The point is fault->gfn has shared bit stripped away at the beginning, and
> > > > AFAICT there's no useful reason to keep shared bit in fault->addr.  The
> > > > entire @fault is a temporary structure on the stack during fault handling
> > > > anyway.
> > > 
> > > I would like to avoid code churn at this point if there is not a real clear
> > > benefit. >>
> > > One small benefit of keeping the shared bit in the fault->addr is that it is
> > > sort of consistent with how that field is used in other scenarios in KVM. In
> > > shadow paging it's not even the GPA. So it is simply the "fault address" and has
> > > to be interpreted in different ways in the fault handler. For TDX the fault
> > > address *does* include the shared bit. And the EPT needs to be faulted in at
> > > that address.
> 
> It's about how we want to define the semantic of fault->addr (forget about
> shadow MMU because for it fault->addr has different meaning from TDP):
> 
> 1) It represents the faulting address which points to the actual guest
> memory (has no shared bit).
> 
> 2) It represents the faulting address which is truly used as the hardware
> page table walk.
> 
> The fault->gfn always represents the location of actual guest memory (w/o
> shared bit) in both cases.
> 
> I originally thought 2) isn't consistent for both SNP and TDX, but thinking
> more, I now think actually both the two semantics are consistent for SNP and
> TDX, which is important in order to avoid confusion.
> 
> Anyway it's a trivial because fault->addr is only used for fault handling
> path.
> 
> So yes fine to me we choose to use 2) here.  But IMHO we should explicitly
> add a comment to 'struct kvm_page_fault' that the @addr represents 2).

Ok. I'm fine with 2).


> And I think more important thing is how we handle this "gfn" and "raw_gfn"
> in tdp_iter and 'struct kvm_mmu_page'.  See below.
> 
> > > 
> > > If we strip the shared bit when setting fault->addr we have to reconstruct it
> > > when we do the actual shared mapping. There is no way around that. Which helper
> > > does it, isn't important I think. Doing the reconstruction inside
> > > tdp_mmu_for_each_pte() could be neat, except that it doesn't know about the
> > > shared bit position.
> > > 
> > > The zapping code's use of kvm_gfn_for_root() is different because the gfn comes
> > > without the shared bit. It's not stripped and then added back. Those are
> > > operations that target GFNs really.
> > > 
> > > I think the real problem is that we are gleaning whether the fault is to private
> > > or shared memory from different things. Sometimes from fault->is_private,
> > > sometimes the presence of the shared bits, and sometimes the role bit. I think
> > > this is confusing, doubly so because we are using some of these things to infer
> > > unrelated things (mirrored vs private).
> > 
> > It's confusing we don't check it in uniform way.
> > 
> > 
> > > My guess is that you have noticed this and somehow zeroed in on the shared_mask.
> > > I think we should straighten out the mirrored/private semantics and see what the
> > > results look like. How does that sound to you?
> > 
> > I had closer look of the related code.  I think we can (mostly) uniformly use
> > gpa/gfn without shared mask.  Here is the proposal.  We need a real patch to see
> > how the outcome looks like anyway.  I think this is like what Kai is thinking
> > about.
> > 
> > 
> > - rename role.is_private => role.is_mirrored_pt
> > 
> > - sp->gfn: gfn without shared bit.
> 
> I think we can treat 'tdp_iter' and 'struct kvm_mmu_page' in the same way,
> because conceptually they both reflects the page table.

Agreed that iter->gfn and sp->gfn should be in same way.


> So I think both of them can have "gfn" or "raw_gfn", and "shared_gfn_mask".
> 
> Or have both "raw_gfn" or "gfn" but w/o "shared_gfn_mask". This may be more
> straightforward because we can just use them when needed w/o needing to play
> with gfn_shared_mask.
> 
> > 
> > - fault->address: without gfn_shared_mask
> >    Actually it doesn't matter much.  We can use gpa with gfn_shared_mask.
> 
> See above.  I think it makes sense to include the shared bit here.  It's
> trivial anyway though.

Ok, let's make fault->addr include shared mask.


> > - Update struct tdp_iter
> >    struct tdp_iter
> >      gfn: gfn without shared bit
> 
> Or "raw_gfn"?
> 
> Which may be more straightforward because it can be just from:
> 
> 	raw_gfn = gpa_to_gfn(fault->addr);
> 	gfn = fault->gfn;
> 
> 	tdp_mmu_for_each_pte(..., raw_gfn, raw_gfn + 1, gfn)
> 
> Which is the reason to make fault->addr include the shared bit AFAICT.

If we can eliminate raw_gfn and kvm_gfn_for_root(), it's better.


> > 
> >      /* Add new members */
> > 
> >      /* Indicates which PT to walk. */
> >      bool mirrored_pt;
> 
> I don't think you need this?  It's only used to select the root for page
> table walk.  Once it's done, we already have the @sptep to operate on.
> 
> And I think you can just get @mirrored_pt from the sptep:
> 
> 	mirrored_pt = sptep_to_sp(sptep)->role.mirrored_pt;
> 
> Instead, I think we should keep the @is_private to indicate whether the GFN
> is private or not, which should be distinguished with 'mirrored_pt', which
> the root page table (and the @sptep) already reflects.
> 
> Of course if the @root/@sptep is mirrored_pt, the is_private should be
> always true, like:
> 
> 	WARN_ON_ONCE(sptep_to_sp(sptep)->role.is_mirrored_pt
> 			&& !is_private);
> 
> Am I missing anything?

You said it not correct to use role. So I tried to find a way to pass down
is_mirrored and avoid to use role.

Did you change your mind? or you're fine with new name is_mirrored?

https://lore.kernel.org/kvm/4ba18e4e-5971-4683-82eb-63c985e98e6b@intel.com/
  > I don't think using kvm_mmu_page.role is correct.



> > 
> >      // This is used tdp_iter_refresh_sptep()
> >      // shared gfn_mask if mirrored_pt
> >      // 0 if !mirrored_pt
> >      gfn_shared_mask >
> > - Pass mirrored_pt and gfn_shared_mask to
> >    tdp_iter_start(..., mirrored_pt, gfn_shared_mask)
> 
> As mentioned above, I am not sure whether we need @mirrored_pt, because it
> already have the @root.  Instead we should pass is_private, which indicates
> the GFN is private.

If we can use role, we don't need iter.mirrored_pt isn't needed.


> > - trace point: update to include mirroredd_pt. Or Leave it as is for now.
> > 
> > - pr_err() that log gfn in handle_changed_spte()
> >    Update to include mirrored_pt. Or Leave it as is for now.
> > 
> > - Update spte handler (handle_changed_spte(), handle_removed_pt()...),
> >    use iter->mirror_pt or pass down mirror_pt.
> > 
> 
> IIUC only sp->role.is_mirrored_pt is needed, tdp_iter->is_mirrored_pt isn't
> necessary.  But when the @sp is created, we need to initialize whether it is
> mirrored_pt.
> 
> Am I missing anything?

Because you didn't like to use role, I tried to find other way.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

