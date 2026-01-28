Return-Path: <kvm+bounces-69413-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NVgMlBpemmB5gEAu9opvQ
	(envelope-from <kvm+bounces-69413-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:53:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A403A8504
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B364E301BCBC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3AA376468;
	Wed, 28 Jan 2026 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U/aDg1bC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1165E374748
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 19:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769629897; cv=none; b=DCcTTT1OO7o5JgNaxBxQYkrsOnQPnB7pSO1ZKZ5tc4Tljf+irqetfPK+xtb22+hitkCgx2kwVWfnbQ9PbHQj34RoluX5igHWQgiKoy87vv/7ycdKe3cE4W+BZY57VR4okZY9mcKIq8kmvrNNM46SOqWsFEik2LUKiMQqeCzVdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769629897; c=relaxed/simple;
	bh=DoY7z2AtHFkvOI3egT97zlHiNsmzFKz8EJ6ByjjVdYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RVtdsPQmOZx4uDl/KJzE9icSvYBzNya/ymV9K4umzf6z5wG8zpd08NKUQ12jszDQpZTDn6jMSEN6QX4JhwCIzhVeFXBxuI9UtVa+V0VIZeyNyhFaDUaR3Mob3vJCUOHPRLhlvwz5CM22dk2Z9f2Wvk/bVJOTawJxL8+H/Bn9cCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U/aDg1bC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0bae9acd4so1697965ad.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 11:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769629893; x=1770234693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bn9lJXHqEiscK/LgfNH9l+HtQHGcpdsiMU6EHRGmE3Q=;
        b=U/aDg1bCip37l30tGfqGeI1ZM+DuK541Rcz9jpMLuV6a0BgUqQbSyhkOAVVDJbu+4f
         8mL/ss/vowprY/yRIuCzl7QSLYDPf/uqFUPkhNi4WYvxJta1FhspjIWIo7S0uANIXlSH
         CXJAH2L37o/E2wX2c076N38nFDzuUv4ediozzgT4gmGfW7N4xXMGuZH0y2PIMocX9B4j
         Murp9mmOunkxrGXRHUI1lcweh/BMrjQ6phI5dXnuvmV25coyYfbjT9mStyea1WPE5/FI
         /SHqBOha2x3et5zPkopMgpvmqMub5cVSW/T5393UFvpT6oc7T/Z1AiM5VEbumli9qnk0
         OEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769629893; x=1770234693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bn9lJXHqEiscK/LgfNH9l+HtQHGcpdsiMU6EHRGmE3Q=;
        b=Gr75sNFjNd1MjNlj0uiYnBZuOR3dtHoHfS98luJ5TXF7Zay2Oqxd/00yy5wwOnHTUJ
         5s9PKCLlCZvQpqX5Sygt6taDL7ckVi3lMxsWS7p8T+C7SapbeqormZxIBIRBnnJOACym
         WY1aqtsTlpDmV93WSB0rp47XWyMmVmqyDT5YGF4uZx9PAFugDB0z3E4+/bUlrJU79sbh
         RZXNnt/V8Owsg+w6atcKYDXpVlZKF1ifLaRmZF4Q4qUL7RphMeVV/mIaBddZKB6K49d1
         iM1d8o/y5h9Qdl2nT2J+QkBcLSedOgqyepheWb+mr1YC2yVVLVAJccarkgUd8k5UMhMv
         wM3A==
X-Forwarded-Encrypted: i=1; AJvYcCVAfPiuIhVjgrn3kwF5R+lP+CM2WCz1uZYm+yXFsqfhZbsdD0+SyDm0q2Xn0Pt2c15JvTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbKngMVFciNAX95GWJ+U9d8lJWzNMuSKei74xkF7rKTnyjjoSe
	AyDSqWdePlrOvFReSPFE1eH6xwHvEVObPwtsnBdPRncjtT94rvy5I/NrE/cDqiO79MIbgK+211E
	Yv2Eqmg==
X-Received: from plnx15.prod.google.com ([2002:a17:902:820f:b0:2a1:4625:795])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3545:b0:297:c048:fb60
 with SMTP id d9443c01a7336-2a870d5d5e3mr58149345ad.25.1769629893346; Wed, 28
 Jan 2026 11:51:33 -0800 (PST)
Date: Wed, 28 Jan 2026 11:51:31 -0800
In-Reply-To: <aXgzlo1BsTjUIVzc@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102024.25023-1-yan.y.zhao@intel.com>
 <aWlvF2rld0Nz3nRz@google.com> <aWnuwb/2TrPAOrbu@yzhao56-desk.sh.intel.com>
 <aXeRf4Jw6-Sl1JCe@google.com> <aXgzlo1BsTjUIVzc@yzhao56-desk.sh.intel.com>
Message-ID: <aXpow-fzaII6RW_q@google.com>
Subject: Re: [PATCH v3 06/24] KVM: x86/mmu: Disallow page merging (huge page
 adjustment) for mirror root
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69413-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,kernel.org,intel.com,google.com,amd.com,suse.cz,suse.com,gmail.com,linux.intel.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2A403A8504
X-Rspamd-Action: no action

On Tue, Jan 27, 2026, Yan Zhao wrote:
> On Mon, Jan 26, 2026 at 08:08:31AM -0800, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 321dbde77d3f..0fe3be41594f 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1232,7 +1232,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  	for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
> >  		int r;
> >  
> > -		if (fault->nx_huge_page_workaround_enabled)
> > +		/*
> > +		 * Don't replace a page table (non-leaf) SPTE with a huge SPTE
> > +		 * (a.k.a. hugepage promotion) if the NX hugepage workaround is
> > +		 * enabled, as doing so will cause significant thrashing if one
> > +		 * or more leaf SPTEs needs to be executable.
> > +		 *
> > +		 * Disallow hugepage promotion for mirror roots as KVM doesn't
> > +		 * (yet) support promoting S-EPT entries while holding mmu_lock
> > +		 * for read (due to complexity induced by the TDX-Module APIs).
> > +		 */
> > +		if (fault->nx_huge_page_workaround_enabled || is_mirror_sp(root))
> A small nit:
> Here, we check is_mirror_sp(root).
> However, not far from here,  in kvm_tdp_mmu_map(), we have another check of
> is_mirror_sp(), which should get the same result since sp->role.is_mirror is
> inherited from its parent.
> 
>                if (is_mirror_sp(sp))
>                        kvm_mmu_alloc_external_spt(vcpu, sp);
> 
> So, do you think we can save the is_mirror status in a local variable?

Eh, I vote "no".  From a performance perspective, it's basically meaningless.
The check is a single uop to test a flag that is all but guaranteed to be
cache-hot, and any halfway decent CPU be able to predict the branch.

From a code perspective, I'd rather have the explicit is_mirror_sp(root) check,
as opposed to having to go look at the origins of is_mirror.

> Like this:
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b524b44733b8..c54befec3042 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1300,6 +1300,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>         struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
> +       bool is_mirror = root && is_mirror_sp(root);
>         struct kvm *kvm = vcpu->kvm;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> @@ -1316,7 +1317,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         for_each_tdp_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
>                 int r;
> 
> -               if (fault->nx_huge_page_workaround_enabled)
> +               /*
> +                * Don't replace a page table (non-leaf) SPTE with a huge SPTE
> +                * (a.k.a. hugepage promotion) if the NX hugepage workaround is
> +                * enabled, as doing so will cause significant thrashing if one
> +                * or more leaf SPTEs needs to be executable.
> +                *
> +                * Disallow hugepage promotion for mirror roots as KVM doesn't
> +                * (yet) support promoting S-EPT entries while holding mmu_lock
> +                * for read (due to complexity induced by the TDX-Module APIs).
> +                */
> +               if (fault->nx_huge_page_workaround_enabled || is_mirror)
>                         disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
> 
>                 /*
> @@ -1340,7 +1351,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                  */
>                 sp = tdp_mmu_alloc_sp(vcpu);
>                 tdp_mmu_init_child_sp(sp, &iter);
> -               if (is_mirror_sp(sp))
> +               if (is_mirror)
>                         kvm_mmu_alloc_external_spt(vcpu, sp);
> 

