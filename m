Return-Path: <kvm+bounces-15875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 238A38B1624
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 00:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 921961F22526
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 22:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C025F16D4CA;
	Wed, 24 Apr 2024 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W3mgvVWI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8C19BDC
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 22:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713997502; cv=none; b=dJGBE/bUbA+udz/ex2Eg6V4Nbco85W1i/yVnIEZEH0MOivmrUtojBmbU0e+onD9hmGDGFw1vhgyiSVSAeJe88H8fXHQcRmItYPWngc59XkyxYdGYNcZ67O0nhV4mYeT7Jji8WY622t+yELxInG+l3m14qafc1n7n3a1LfnBW6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713997502; c=relaxed/simple;
	bh=afOCXdLaCatGu3yM9MRIokEHahmNCXlOr3vSXsXWeBY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vy+JrRzm9piOhulelew/FeNPTbOhfV+wWRvKbv9fPfJ5k/s17CfLZgzDzfj1eMWEPfNahPnri4+R2TgO0s7qo1V4AAlWU63wgDwgJu/gWJfcPpKqGG8IsYYHHJj3a+VnSeWOympfDeT2BGG/biuOMEYoiDh3Hn34vn7dK3tgxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W3mgvVWI; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed613bb4d1so369439b3a.3
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713997500; x=1714602300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MCBEdd7mOJH2jqONKmc5LYR7Ix2PzspgStOeVe4lD+s=;
        b=W3mgvVWIHFtgGbg0iRV/zMwdwIpnEr9dHlmoQFqeIvaL2wmHO/bpO2P8kxEc7PDqtu
         9WtTzkcVXsyhrq9xgPOsrTAf3mWGByqT4h/nyUlVhAfvjV34V0K8jrXU2o5Cn+c1Uqod
         vW8yXT4Z3zoJBBqafgtHyDni5Gw/hac4zupgaXTmMorpmxL4tad26hSdNv+vBbChjTpf
         55RbV4TEPL/unRWL8Sj2foLXS4tUjMkNw23l9fOXC2DSC4vPGo/aSJgMu2NNOXbwKpxm
         7ciwitKfkkIEteUa1PikizYljo+KOtkkkOy8jtXXFUepicBeemeuZSfoBBf30jNSvNVq
         uFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713997500; x=1714602300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCBEdd7mOJH2jqONKmc5LYR7Ix2PzspgStOeVe4lD+s=;
        b=RHKaPH+jLXXMOotyW3IGbnEnQ7BWHD3bGH8GSBkk0rdEjZMniGTctoPNr35SAKj56H
         Z8LxikEjCoXQapHt+o9iUTyGtUX/nwdkbPlz2dm+gJN5dVuN8m7T8NvBWb6u62SVGRDA
         Ei+qVhJuPyWJAEQ2NcZOEwlsWWUkVpwW/BI4Ge+ZgrukivzzMtgI8KTyo0DVztuPWEPR
         X9Pe9sg9DxUIi/gWWV4gOONmHEn+Ur5IWgZ3BOwUb8FSS/2CmMoAGAnKssntdTzR2S4R
         gQ0Lwqggvmy5uyKrRYyomeA1EyHUqM/fsCCl550gpWP5cjsDCwI606mvSvovUVbiQ8Ap
         qmjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuSfV4Bp2bQV+rbNe1v5Gfw+/YgM/p/zlcAwB4GjJZvuH+Cu6XUGwDEVpRrN2S4bgg7fnaRy/tLbdEvMawYWa0ONcP
X-Gm-Message-State: AOJu0YygunB+vLBIcGLxNBuxJlP1yP5UKueEzYHD8euYDS5IFy3w8HRR
	OYRVHJ7IpMnAtxSD0l0L45ZR2weAfr5DZnmO4BWgP6fXjgJJ0Lc8w/gvgUNz4x7I3AuDwalCQLq
	d6w==
X-Google-Smtp-Source: AGHT+IEAXPsBUNYCxKf8Ii08b8jVMXjJ4Ztj1zvnIqs7EExuchDRdYGnWfIh1XhGlx6vZQAC176Ic55/2OA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1888:b0:6ea:ad01:358f with SMTP id
 x8-20020a056a00188800b006eaad01358fmr272152pfh.6.1713997499809; Wed, 24 Apr
 2024 15:24:59 -0700 (PDT)
Date: Wed, 24 Apr 2024 15:24:58 -0700
In-Reply-To: <20240423235013.GO3596705@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com>
Message-ID: <ZimGulY6qyxt6ylO@google.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 23, 2024, Isaku Yamahata wrote:
> On Thu, Apr 04, 2024 at 02:50:31PM -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
> > prepare newly-allocated gmem pages prior to mapping them into the guest.
> > In the case of SEV-SNP, this mainly involves setting the pages to
> > private in the RMP table.
> > 
> > However, for the GPA ranges comprising the initial guest payload, which
> > are encrypted/measured prior to starting the guest, the gmem pages need
> > to be accessed prior to setting them to private in the RMP table so they
> > can be initialized with the userspace-provided data. Additionally, an
> > SNP firmware call is needed afterward to encrypt them in-place and
> > measure the contents into the guest's launch digest.
> > 
> > While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
> > this handling can be done in an open-coded/vendor-specific manner, this
> > may expose more gmem-internal state/dependencies to external callers
> > than necessary. Try to avoid this by implementing an interface that
> > tries to handle as much of the common functionality inside gmem as
> > possible, while also making it generic enough to potentially be
> > usable/extensible for TDX as well.
> 
> I explored how TDX will use this hook.  However, it resulted in not using this
> hook, and instead used kvm_tdp_mmu_get_walk() with a twist.  The patch is below.
> 
> Because SEV-SNP manages the RMP that is not tied to NPT directly, SEV-SNP can
> ignore TDP MMU page tables when updating RMP.
> On the other hand, TDX essentially updates Secure-EPT when it adds a page to
> the guest by TDH.MEM.PAGE.ADD().  It needs to protect KVM TDP MMU page tables
> with mmu_lock, not guest memfd file mapping with invalidate_lock.  The hook
> doesn't apply to TDX well.  The resulted KVM_TDX_INIT_MEM_REGION logic is as
> follows.
> 
>   get_user_pages_fast(source addr)
>   read_lock(mmu_lock)
>   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
>   if the page table doesn't map gpa, error.
>   TDH.MEM.PAGE.ADD()
>   TDH.MR.EXTEND()
>   read_unlock(mmu_lock)
>   put_page()

Hmm, KVM doesn't _need_ to use invalidate_lock to protect against guest_memfd
invalidation, but I also don't see why it would cause problems.  I.e. why not
take mmu_lock() in TDX's post_populate() implementation?  That would allow having
a sanity check that the PFN that guest_memfd() has is indeed the PFN that KVM's
S-EPT mirror has, i.e. the PFN that KVM is going to PAGE.ADD.

> >From 7d4024049b51969a2431805c2117992fc7ec0981 Mon Sep 17 00:00:00 2001
> Message-ID: <7d4024049b51969a2431805c2117992fc7ec0981.1713913379.git.isaku.yamahata@intel.com>
> In-Reply-To: <cover.1713913379.git.isaku.yamahata@intel.com>
> References: <cover.1713913379.git.isaku.yamahata@intel.com>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> Date: Tue, 23 Apr 2024 11:33:44 -0700
> Subject: [PATCH] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
> 
> KVM_TDX_INIT_MEM_REGION needs to check if the given GFN is already
> populated.  Add wrapping logic to kvm_tdp_mmu_get_walk() to export it.

> +int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
> +				     kvm_pfn_t *pfn)
> +{
> +	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
> +	int leaf;
> +
> +	lockdep_assert_held(&vcpu->kvm->mmu_lock);
> +
> +	kvm_tdp_mmu_walk_lockless_begin();

This is obviously not a lockless walk.

> +	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, true);
> +	kvm_tdp_mmu_walk_lockless_end();
> +	if (leaf < 0)
> +		return -ENOENT;
> +
> +	spte = sptes[leaf];
> +	if (is_shadow_present_pte(spte) && is_last_spte(spte, leaf)) {
> +		*pfn = spte_to_pfn(spte);
> +		return leaf;
>  	}
>  
> -	return leaf;
> +	return -ENOENT;
>  }
> +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_get_walk_private_pfn);
>  
>  /*
>   * Returns the last level spte pointer of the shadow page walk for the given
> -- 
> 2.43.2
> 
> -- 
> Isaku Yamahata <isaku.yamahata@intel.com>

