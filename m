Return-Path: <kvm+bounces-18252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 474488D2A27
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3F2728A4C5
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1441115AADE;
	Wed, 29 May 2024 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C3U7UUsD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1691026AF3;
	Wed, 29 May 2024 01:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716947872; cv=none; b=aLjCcyii4XTHbQGFCiDKr4thwsSswpGoVVZIsZt5m66w41SiDfAXgd/29lBnB1PHcw83nS32YYEgIMs7MmpW05q8jUVS+2QGWfXH2caMfh/VRcD+06IouKYmRQdhu6ICOu+bJMgI5WfKLH0uav2ivLC9q7NuBwiVTwNQAsbt9rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716947872; c=relaxed/simple;
	bh=Te4e2I05ri/UrnBM5Gq3tFWOarslN8X9hkpMfjoqepQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpbJOiDk4K0QRna+v6ej8kYv2TdTETPiINbTCshuKQ2n+NNSXWcVRYDULwvp8JTOjoCmt5hce/Q3IX8y+a/JaQsqCK7Xox0ymvI+s4lSy0Kjncrh1Jh+Gupn7VF/NW+IddbvqWd9Wa3E1jI9mkb+br8C9bpUIQmAXNd/nKKTOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C3U7UUsD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716947870; x=1748483870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Te4e2I05ri/UrnBM5Gq3tFWOarslN8X9hkpMfjoqepQ=;
  b=C3U7UUsDlflQ3iF13cOVHvzJG99B9ct9o/1xV+e4xGaTa3bqoE8uLa1k
   uh90BO86nS9PHr68vG791phRjFB0OSTrRbSjnlJD3OwllIbLBp9YCaKZH
   p03j/qortCc0/H5ckLtw2tSwZ8d+O184D5GAg76QrxNA3jo2YDBHebRxw
   4JDZdwmrAqWEaOMef8yh5E33CugnKKSpcNgNwovgLRIUhrGmy40gF8bw0
   SJwCSPdq0hOCEtGtcNBA75rDZ1RGn2NzQgrIEcixAhkxxoQcierBnY7TN
   4qWsu2GP3zGrsff+Pu3HvY11/97anqMV7R92V6UMRHm+aNI7yyG6NHYCf
   Q==;
X-CSE-ConnectionGUID: atE22HCeSc6aq4w/TUbP8A==
X-CSE-MsgGUID: EkAEV2/cSX2jez6z3F9Mrw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13176992"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13176992"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:57:50 -0700
X-CSE-ConnectionGUID: 5ltQHltVRLGACwQ+kPYaoQ==
X-CSE-MsgGUID: 4zo49N+lQRijUV2pTHwTpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39697215"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:57:49 -0700
Date: Tue, 28 May 2024 18:57:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529015749.GF386318@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <a5ad658b1eec38f621315431a24e028187b5ca2d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5ad658b1eec38f621315431a24e028187b5ca2d.camel@intel.com>

On Tue, May 28, 2024 at 11:06:45PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
> >  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -                               u64 old_spte, u64 new_spte, int level,
> > -                               bool shared)
> > +                               u64 old_spte, u64 new_spte,
> > +                               union kvm_mmu_page_role role, bool shared)
> >  {
> > +       bool is_private = kvm_mmu_page_role_is_private(role);
> > +       int level = role.level;
> >         bool was_present = is_shadow_present_pte(old_spte);
> >         bool is_present = is_shadow_present_pte(new_spte);
> >         bool was_leaf = was_present && is_last_spte(old_spte, level);
> >         bool is_leaf = is_present && is_last_spte(new_spte, level);
> > -       bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> > +       kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > +       kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> > +       bool pfn_changed = old_pfn != new_pfn;
> >  
> >         WARN_ON_ONCE(level > PT64_ROOT_MAX_LEVEL);
> >         WARN_ON_ONCE(level < PG_LEVEL_4K);
> > @@ -513,7 +636,7 @@ static void handle_changed_spte(struct kvm *kvm, int
> > as_id, gfn_t gfn,
> >  
> >         if (was_leaf && is_dirty_spte(old_spte) &&
> >             (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> > -               kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> > +               kvm_set_pfn_dirty(old_pfn);
> >  
> >         /*
> >          * Recursively handle child PTs if the change removed a subtree from
> > @@ -522,15 +645,21 @@ static void handle_changed_spte(struct kvm *kvm, int
> > as_id, gfn_t gfn,
> >          * pages are kernel allocations and should never be migrated.
> >          */
> >         if (was_present && !was_leaf &&
> > -           (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > +           (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
> > +               KVM_BUG_ON(is_private !=
> > is_private_sptep(spte_to_child_pt(old_spte, level)),
> > +                          kvm);
> >                 handle_removed_pt(kvm, spte_to_child_pt(old_spte, level),
> > shared);
> > +       }
> > +
> > +       if (is_private && !is_present)
> > +               handle_removed_private_spte(kvm, gfn, old_spte, new_spte,
> > role.level);
> 
> I'm a little bothered by the asymmetry of where the mirrored hooks get called
> between setting and zapping PTEs. Tracing through the code, the relevent
> operations that are needed for TDX are:
> 1. tdp_mmu_iter_set_spte() from tdp_mmu_zap_leafs() and __tdp_mmu_zap_root()
> 2. tdp_mmu_set_spte_atomic() is used for mapping, linking
> 
> (1) is a simple case because the mmu_lock is held for writes. It updates the
> mirror root like normal, then has extra logic to call out to update the S-EPT.
> 
> (2) on the other hand just has the read lock, so it has to do the whole
> operation in a special way. First set REMOVED_SPTE, then update the private
> copy, then write to the mirror page tables. It can't get stuffed into
> handle_changed_spte() because it has to write REMOVED_SPTE first.
> 
> In some ways it makes sense to update the S-EPT. Despite claiming
> "handle_changed_spte() only updates stats.", it does some updating of other PTEs
> based on the current PTE change. Which is pretty similar to what the mirrored
> PTEs are doing. But we can't really do the setting of present PTEs because of
> the REMOVED_SPTE stuff.
> 
> So we could only make it more symmetrical by moving the S-EPT ops out of
> handle_changed_spte() and manually call it in the two places relevant for TDX,
> like the below.
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e966986bb9f2..c9ddb1c2a550 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -438,6 +438,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t
> pt, bool shared)
>                          */
>                         old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
>                                                           REMOVED_SPTE, level);
> +
> +                       if (is_mirror_sp(sp))
> +                               reflect_removed_spte(kvm, gfn, old_spte,
> REMOVED_SPTE, level);

The callback before handling lower level will result in error.


>                 }
>                 handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
>                                     old_spte, REMOVED_SPTE, sp->role, shared);


We should call it here after processing lower level.



> @@ -667,9 +670,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id,
> gfn_t gfn,
>                 handle_removed_pt(kvm, spte_to_child_pt(old_spte, level),
> shared);
>         }
>  
> -       if (is_mirror && !is_present)
> -               reflect_removed_spte(kvm, gfn, old_spte, new_spte, role.level);
> -
>         if (was_leaf && is_accessed_spte(old_spte) &&
>             (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
>                 kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> @@ -839,6 +839,9 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id,
> tdp_ptep_t sptep,
>                                                       new_spte, level), kvm);
>         }
>  
> +       if (is_mirror_sptep(sptep))
> +               reflect_removed_spte(kvm, gfn, old_spte, REMOVED_SPTE, level);
> +

Ditto.


>         role = sptep_to_sp(sptep)->role;
>         role.level = level;
>         handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);

The callback should be here.  It should be after handling the lower level.



> Otherwise, we could move the "set present" mirroring operations into
> handle_changed_spte(), and have some earlier conditional logic do the
> REMOVED_SPTE parts. It starts to become more scattered.
> Anyway, it's just a code clarity thing arising from having hard time explaining
> the design in the log. Any opinions?

Originally I tried to consolidate the callbacks by following TDP MMU using
handle_changed_spte().  Anyway we can pick from two outcomes based on which is
easy to understand/maintain.


> A separate but related comment is below.
> 
> >  
> >         if (was_leaf && is_accessed_spte(old_spte) &&
> >             (!is_present || !is_accessed_spte(new_spte) || pfn_changed))
> >                 kvm_set_pfn_accessed(spte_to_pfn(old_spte));
> >  }
> >  
> > @@ -648,6 +807,8 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
> >  static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >                             u64 old_spte, u64 new_spte, gfn_t gfn, int level)
> >  {
> > +       union kvm_mmu_page_role role;
> > +
> >         lockdep_assert_held_write(&kvm->mmu_lock);
> >  
> >         /*
> > @@ -660,8 +821,16 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id,
> > tdp_ptep_t sptep,
> >         WARN_ON_ONCE(is_removed_spte(old_spte) || is_removed_spte(new_spte));
> >  
> >         old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
> > +       if (is_private_sptep(sptep) && !is_removed_spte(new_spte) &&
> > +           is_shadow_present_pte(new_spte)) {
> > +               /* Because write spin lock is held, no race.  It should
> > success. */
> > +               KVM_BUG_ON(__set_private_spte_present(kvm, sptep, gfn,
> > old_spte,
> > +                                                     new_spte, level), kvm);
> > +       }
> 
> Based on the above enumeration, I don't see how this hunk gets used.

I should've removed it.  This is leftover from the old patches.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

