Return-Path: <kvm+bounces-24557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83038957759
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:19:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F8741F25A78
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D531E1DD397;
	Mon, 19 Aug 2024 22:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqypCEJe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904F11DB452
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105963; cv=none; b=tBkGvTRGzjGlU4WZJsUvMjhRwRh2AZfyXrI8ypWlVx/0uE6opmu+owGkLRizAN6lVqzZTaFqA2eQBj/A6hNJCYiJSZkLF05ueyFkZAefKZqUSNark3sRc7A87w7yeri2SCEOvQtqebFD18Rki82Uf1Es0BMMD/rYNGi0X3i9+IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105963; c=relaxed/simple;
	bh=SYp3tksf77bo6qTn2UGfcC0zNiZVqhwqCOP3DWafP9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M2DvugFJsVvkR5DMuMxyomcrGxiFk2SqK2kno73kkeR8Xz1f6dUMWvg2nPVijT/l+atnMm6jWE2xkxxQTdGgBsmYcZGPU5HIhMtrMgn+oOkY72uYjry7YNNrWAYu93LDtmnOnVMV97o/l3ceP0v4UUNCyPUc8siE4/OW5cqfhOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqypCEJe; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1831ae05so4338652b3a.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724105961; x=1724710761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/SYLh/JPAc2oF3XEhfhevi/a4vY//ccYnWwMPOLwIpg=;
        b=eqypCEJeQwJo43ULBUahh2ta3RWnT5lzs1eyRIX95z9I00BkVUv4r3GQcBFcSuoOXA
         M6gCDqi/J3HhAtpXjfCUvSfZp59LFeKGBq3iTo5oAp3X2sdMRGIPHvYn25+C1fbg8kc1
         XQnmwZ6mYrKWOraE170gsCStpQs63dQgXG6hMbjg9alVMpyZr8vQaRVhVZDWhMzAUS8r
         lHTPXFssL3bPaA3o9MstXzFFL31MwqKAh975KvBxJjJCJEjpz87FhEnrl7LWw0sbv/74
         XGlwUobv5VYw/lWrtY7HgGUvhTG1UOJP26QaDEy59GyiJu8a2+1VGlI+OzMkRj7l2M4a
         xaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724105961; x=1724710761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/SYLh/JPAc2oF3XEhfhevi/a4vY//ccYnWwMPOLwIpg=;
        b=aYSFI3uh+cEF02g1UjzCJwSyzC5Qa6YstqK1m6MwiTGUyRIvPkTEJYwGNiXjk+NR8Q
         Rd7nWWTUxAklpf+n2NL2972ZZd8Hss7oh6RJHsohzEJ+aveiDE6LVuUM69djpHwTmvph
         qZ61lkPGDqoKeWHE5IqhYTf3YQs2TTmGKWr8tlgi7eqoFakTfYFJtJMysKbhVKMeWGwk
         ARv2Bn94/Te85OvpFaU8zxtOYbSn2vr65ISoEi5lKIV3KIM6KM8iC68ByMAG3tL/01RT
         +1bDylTBX0QR7BRbAc7IeKI1j0VFGDuGGJPpg39rQuF7ZTfkhPU14ivJN+PQFYFj6WsC
         EvSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpWn0jPLFA1lT5S+nb1pBJoQOwkomBLk9s37ott7LAE8kM64ukYz628aLCROxlSe/m8gINLApWJXvw3hdrH5TN6Q9P
X-Gm-Message-State: AOJu0Yzct5RQAAvfibUxyZDU8IlDPZzTpThpARaJaeI2IhKKY4ZJVFQR
	HixpR+7pN0A+A0y0uN3gpXr9H3oRjrEetiVMDOFzdfYNo6BunAkNMp/rFJ3kM2tqfSxEuOcG+AI
	/Kg==
X-Google-Smtp-Source: AGHT+IHm278QwIY/OX92uRPN+eRVywdVAQcXvKqkS5cFMSC5mSDI9+smOYf7rkHoPuip6boFZYqviDtYqSc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f06:b0:706:71f1:51bd with SMTP id
 d2e1a72fcca58-713c53a2077mr42981b3a.6.1724105960751; Mon, 19 Aug 2024
 15:19:20 -0700 (PDT)
Date: Mon, 19 Aug 2024 15:19:19 -0700
In-Reply-To: <20240812171341.1763297-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240812171341.1763297-1-vipinsh@google.com> <20240812171341.1763297-3-vipinsh@google.com>
Message-ID: <ZsPE56MnelsV490m@google.com>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 12, 2024, Vipin Sharma wrote:
> Use MMU read lock to recover NX huge pages belonging to TDP MMU. Iterate
> through kvm->arch.possible_nx_huge_pages while holding
> kvm->arch.tdp_mmu_pages_lock. Rename kvm_tdp_mmu_zap_sp() to
> tdp_mmu_zap_sp() and make it static as there are no callers outside of
> TDP MMU.
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 933bb8b11c9f..7c7d207ee590 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -817,9 +817,11 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	rcu_read_unlock();
>  }
>  
> -bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +static bool tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)

At this point, I think we should rename this to tdp_mmu_zap_possible_nx_huge_page(),
as I can't imagine there's another use case where we'll zap a SP starting from the
SP itself, i.e. without first walking from the root.

>  {
> -	u64 old_spte;
> +	struct tdp_iter iter = {};

Rather than initializes the on-stack structure, I think it makes sense to directly
initialize the whole thing and then WARN after, e.g. so that its easier to see
that "iter" is simply being filled from @sp.

	struct tdp_iter iter = {
		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
		.sptep = sp->ptep,
		.level = sp->role.level + 1,
		.gfn = sp->gfn,
		.as_id = kvm_mmu_page_as_id(sp),
	};

	lockdep_assert_held_read(&kvm->mmu_lock);

	/*
	 * Root shadow pages don't a parent page table and thus no associated
	 * entry, but they can never be possible NX huge pages.
	 */
	if (WARN_ON_ONCE(!sp->ptep))
		return false;

> +
> +	lockdep_assert_held_read(&kvm->mmu_lock);
>  
>  	/*
>  	 * This helper intentionally doesn't allow zapping a root shadow page,
> @@ -828,12 +830,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	if (WARN_ON_ONCE(!sp->ptep))
>  		return false;
>  
> -	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> -	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
> +	iter.old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> +	iter.sptep = sp->ptep;
> +	iter.level = sp->role.level + 1;
> +	iter.gfn = sp->gfn;
> +	iter.as_id = kvm_mmu_page_as_id(sp);
> +
> +retry:
> +	/*
> +	 * Since mmu_lock is held in read mode, it's possible to race with
> +	 * another CPU which can remove sp from the page table hierarchy.
> +	 *
> +	 * No need to re-read iter.old_spte as tdp_mmu_set_spte_atomic() will
> +	 * update it in the case of failure.
> +	 */
> +	if (sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
>  		return false;
>  
> -	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> -			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
> +	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
> +		goto retry;

I'm pretty sure there's no need to retry.  Non-leaf SPTEs don't have Dirty bits,
and KVM always sets the Accessed bit (and never clears it) for non-leaf SPTEs.
Ditty for the Writable bit.

So unless I'm missing something, the only way for the CMPXCHG to fail is if the
SPTE was zapped or replaced with something else, in which case the sp->spt will
fail.  I would much prefer to WARN on that logic failing than have what appears
to be a potential infinite loop.

