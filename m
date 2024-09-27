Return-Path: <kvm+bounces-27623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43242988691
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 15:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6580F1C2182F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 13:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8E91BF32A;
	Fri, 27 Sep 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AGZWDIkp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EB718C342
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727445122; cv=none; b=u1cSyMDJgXB3fE0kJuOEv/yvLwre02l/uMTghfjb9t05xAaN7vEhxeYeYheK07bueekVJnuKR9S6Ix4udPH1kfXqr/M3KSrQQkBiQDBSgbkviiesO1211/oUC8vKhaNYIlrtLPPJrRwdr08LPCQGQNZuNcYvqcITlk5YXdVfUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727445122; c=relaxed/simple;
	bh=TMvt6BrLR403fS08wVJ1UKHeD+enDKMmGKdX7ghvBKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ANSD3mjsGJpVLSSH35aG4Ef2S1Nz83eMmzhWR2X1NSwLuvM30XHn4HMuo7X3gBMkIGqDtfqi5pSLot6+CqGB7WYrTbYUEv3TZOu5rmKiWgT6356YmXCatuZZE1MdYAvR7VEzzWoCyEdwObccDIl68/NNJBP/1gBLW0GEPBMaYr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AGZWDIkp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e2261adfdeso28036357b3.2
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 06:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727445120; x=1728049920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nEP8CF+sqf5svRnf/ud30Te+lohW++0YXoaXmWT1Axo=;
        b=AGZWDIkpGECsFcfI1pN2OgeR93+/8NbvmE/Xe73hG9lebjjGZsMcF34dWKXSsHwnIJ
         xF3rWSsRdG08IKmpnioFdpZwJBMWpKbmkL4eFArMBpbXxPo33M5fc9DJHeUlI6aDamDt
         AWjNQebrnEopahIKtLRkGdDCEljrLMioEoQpLwuauWYUWuq9R4IlBImLnFYwkzoTBEBo
         +5/bX+NE36lxRjCvB8nSmC8KodnNXbXipCBYIaNQ7vz/HbIySDUgG1FfJvw7QF2Sta8+
         kwwLOHRyqxlZnZ5tlHN5oqk/twj0RFOzDg6vAXW+ju382E1RYX/p0YwXXbbsJvDa4S2w
         muug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727445120; x=1728049920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEP8CF+sqf5svRnf/ud30Te+lohW++0YXoaXmWT1Axo=;
        b=iPRcPtKzGQPWAbksa6B6mb6DPPjA+C2IJRMeRNDUXJy9iOxCOPv5TiLeOA/ovNQaoG
         MHjxN9SUweuFpxnR1oONfwqXnYdwMvpMXEz1Ls9SURPONbwW46fU9eT+xIVOcgr2faqs
         fXjzrVh59AOEC2Lewx4WMXLbA1en3ldle30LBWMssMFk6/UCf5LKUtklUSgUip2lUrgh
         EBPZVYnviIP78c6HMUblVO6A6TgUMfg1SI9J7W8Ih/UXHXKGkCIN/g18qECbgtEGRlRd
         HglgG1hN5KmwePWL6sPDLUIbuJDvWzKIkw3hKrHrRAYIUoiJm9E8J5vHU0mE9KzmC6De
         BXIw==
X-Forwarded-Encrypted: i=1; AJvYcCU0zFmYSrrWyiQ7acmxzGS4lcVoV4wr1fsjad/cRw7nmVaPD9F/ejpmQ/6D5X6kHIrdycQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqKqoo4/Jk8m66ZU60E3HWaAnjA0rCQzVbhU1xn2xCImX6CoNJ
	jQ6iM7rWo2h6L5dIq7G0TVyEUwWhDWiEC8VRv2JHGSXa47JFxQuR2ciwyLuGMlVZ/xmX49NLd7A
	tTg==
X-Google-Smtp-Source: AGHT+IF6dcvm3lu1nvRfd5b8XNVP3WMyqS4UlkG8cak+knDCbjrwpgrPBl9M4w7Sl64vvBi4CwXXBJlDmYk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d8c:b0:6b1:8b74:978a with SMTP id
 00721157ae682-6e2475a7f4emr891097b3.4.1727445120202; Fri, 27 Sep 2024
 06:52:00 -0700 (PDT)
Date: Fri, 27 Sep 2024 06:51:58 -0700
In-Reply-To: <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com> <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
Message-ID: <Zva4aORxE9ljlMNe@google.com>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, sagis@google.com, 
	chao.gao@intel.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 26, 2024, Yan Zhao wrote:
> On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > > KVM MMU behavior
> > > ================
> > > The leaf SPTE state machine is coded in make_spte().  Consider AD bits and
> > > the present bits for simplicity.  The two functionalities and AD bits
> > > support are related in this context.  unsync (manipulate D bit and W bit,
> > > and handle write protect fault) and access tracking (manipulate A bit and
> > > present bit, and hand handle page fault).  (We don't consider dirty page
> > > tracking for now as it's future work of TDX KVM.)
> > > 
> > > * If AD bit is enabled:
> > > D bit state change for dirty page tracking
> > > On the first EPT violation without prefetch,
> > > - D bits are set.
> > > - Make SPTE writable as TDX supports only RXW (or if write fault).
> > >   (TDX KVM doesn't support write protection at this state. It's future work.)
> > > 
> > > On the second EPT violation.
> > > - clear D bits if write fault.
> > 
> > Heh, I was literally just writing changelogs for patches to address this (I told
> > Sagi I would do it "this week"; that was four weeks ago).
> > 
> > This is a bug in make_spte().  Replacing a W=1,D=1 SPTE with a W=1,D=0 SPTE is
> > nonsensical.  And I'm pretty sure it's an outright but for the TDP MMU (see below).
> > 
> > Right now, the fixes for make_spte() are sitting toward the end of the massive
> > kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> > fairly confident that series can land in 6.13 (lots and lots of small patches).
> > 
> > ---
> > Author:     Sean Christopherson <seanjc@google.com>
> > AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> > Commit:     Sean Christopherson <seanjc@google.com>
> > CommitDate: Thu Sep 12 16:35:06 2024 -0700
> > 
> >     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
> >     
> >     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
> >     leaf SPTE (with the same target pfn) and clears the Writable bit or the
> >     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
> >     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
> >     if the existing SPTE is writable.
> >     
> >     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
> >     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
> >     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
> >     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
> >     the only SPTE that is dirty at the time of the next relevant clearing of
> >     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
> >     because it sees the D=0 SPTE, and thus will complete the clearing of the
> >     dirty logs without performing a TLB flush.
> But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
> matter clear_dirty_gfn_range() finds a D bit or not.

Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
anything should be backported it's that commit.

> kvm_mmu_slot_apply_flags
>   |kvm_mmu_slot_leaf_clear_dirty
>   |  |kvm_tdp_mmu_clear_dirty_slot
>   |    |clear_dirty_gfn_range
>   |kvm_flush_remote_tlbs_memslot
>      
> >     Opportunistically harden the TDP MMU against clearing the Writable bit as
> >     well, both to prevent similar bugs for write-protection, but also so that
> >     the logic can eventually be deduplicated into spte.c (mmu_spte_update() in
> >     the shadow MMU has similar logic).
> >     
> >     Fix the bug in the TDP MMU's page fault handler even though make_spte() is
> >     clearly doing odd things, e.g. it marks the page dirty in its slot but
> >     doesn't set the Dirty bit.  Precisely because replacing a leaf SPTE with
> >     another leaf SPTE is so rare, the cost of hardening KVM against such bugs
> >     is negligible.  The make_spte() will be addressed in a future commit.
> >     
> >     Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> >     Cc: David Matlack <dmatlack@google.com>
> >     Cc: stable@vger.kernel.org
> >     Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 3b996c1fdaab..7c6d1c610f0e 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1038,7 +1038,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >         else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> >                 return RET_PF_RETRY;
> >         else if (is_shadow_present_pte(iter->old_spte) &&
> > -                !is_last_spte(iter->old_spte, iter->level))
> > +                (!is_last_spte(iter->old_spte, iter->level) ||
> > +                 (is_mmu_writable_spte(old_spte) && !is_writable_pte(new_spte)) ||
> > +                 (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))))
> Should we also check is_accessed_spte() as what's done in mmu_spte_update()?

Heh, it's impossible to see in this standalone "posting", but earlier in the
massive series is a patch that removes that code.  Aptly titled "KVM: x86/mmu:
Don't force flush if SPTE update clears Accessed bit".

> It is possible for make_spte() to make the second spte !is_dirty_spte(), e.g.
> the second one is caused by a KVM_PRE_FAULT_MEMORY ioctl.

Ya, the mega-series also has a fix for that: "KVM: x86/mmu: Always set SPTE's
dirty bit if it's created as writable".

> >                 kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
> >  
> >         /*
> > ---
> > 
> > >  arch/x86/kvm/mmu/spte.h    |  6 ++++++
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++++++++---
> > >  2 files changed, 31 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > > index a72f0e3bde17..1726f8ec5a50 100644
> > > --- a/arch/x86/kvm/mmu/spte.h
> > > +++ b/arch/x86/kvm/mmu/spte.h
> > > @@ -214,6 +214,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> > >   */
> > >  #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> > >  
> > > +#define EXTERNAL_SPTE_IGNORE_CHANGE_MASK		\
> > > +	(shadow_acc_track_mask |			\
> > > +	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<		\
> > > +	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) |		\
> > 
> > Just make TDX require A/D bits, there's no reason to care about access tracking.
> If KVM_PRE_FAULT_MEMORY is allowed for TDX and if
> cpu_has_vmx_ept_ad_bits() is false in TDX's hardware (not sure if it's possible),

Make it a requirement in KVM that TDX hardware supports A/D bits and that KVM's
module param is enabled.  EPT A/D bits have been supported in all CPUs since
Haswell, I don't expect them to ever go away.

> access tracking bit is possbile to be changed, as in below scenario:
> 
> 1. KVM_PRE_FAULT_MEMORY ioctl calls kvm_arch_vcpu_pre_fault_memory() to map
>    a GFN, and make_spte() will call mark_spte_for_access_track() to
>    remove shadow_acc_track_mask (i.e. RWX bits) and move R+X left to
>    SHADOW_ACC_TRACK_SAVED_BITS_SHIFT.
> 2. If a concurrent page fault occurs on the same GFN on another vCPU, then
>    make_spte() in that vCPU will not see prefetch and the new_spte is
>    with RWX bits and with no bits set in SHADOW_ACC_TRACK_SAVED_MASK.

This should be fixed by the mega-series.  I'll make sure to Cc you on that series.

Thanks much for the input and feedback!

