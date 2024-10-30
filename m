Return-Path: <kvm+bounces-30029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C039B65EA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 122901C209FB
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 14:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B711F4FB1;
	Wed, 30 Oct 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTbMZxDk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DF01F473D
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298513; cv=none; b=GjUrGhDg+Jhhoeld9GejXDUbW+rnytu7sJ4IYbo3qIG2VurM7Olf2C0rRisjCOOQzgJsOeWPMVFN4ZfT3/UjVZ5dyu9ySB4OzoBq/CrLOaEGkidLTl3omDpX9Gudjy77ZjfS3qTSk2+CQ63sppQ9eLMuocFaArtK2MbTLajNmZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298513; c=relaxed/simple;
	bh=2yRQmuJJ6sT+0V/3Iulpf4QlwwsywcGSPSgOUVmFmsc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tSo+cumWIgVjnTeSqtGlT/cICgB3CEbD3jEEJSV7b0sWZSruDlvIpFdxbyV5CIK7ey+PKzRILl2OgDsczDxK7a+8Ds99m/qXyb6iWiRQxYPksXNThwnBFIOplTrLRxgONFOeAWvlbMiVnURMyG+uWU6wkC1duEB8y5Q+u6nLG1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oTbMZxDk; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c7ba2722fso62914165ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 07:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730298511; x=1730903311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GTp2ewWGPW0TW7CBlZiJJqpjbZEo8dYN/EbPFSkUuR4=;
        b=oTbMZxDkr8KrpZ/9h3tTl/b1ZTiDXaKpQ6/61zh3/0yB0Ug1kCgd/rdE5c0vt9Uq7M
         VUeu/cvpnortYIczqJv8qfWs2CjaVqcgb2uqBDSb7QIJZUMmI69vfVbdjqzoVKwaPAy5
         HL2MG1dcvh9Q4Z5u+QLNUjbREW9A/0APUPsGxZdxDtbB+nwn0YFsgR7gKg61w72bnnN7
         mkqub4c+WR8fEDvlEmFz9ReWgT+AoCTHQTdvEQNM112D+40vlbpcs/SFDq0tjMgfKnPI
         0a+GHuEnUYX5a/kfCownGJnfbfYb1DY4tmBxQsWs0Txd3yXVdIDPtbW4TRz6QBhtK97N
         NFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730298511; x=1730903311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GTp2ewWGPW0TW7CBlZiJJqpjbZEo8dYN/EbPFSkUuR4=;
        b=GGz5GdoREJNsBDBtkDRLCOx/7J0eZG7nsvGxOlpG/M2vllOjmucj2N1beE+ghPOsSv
         GW1PojOqf4TJ1mfVBwRJHT1uS3+aunFzjsRvkSbHRIHq/ZuBXJUzX32nI3qbZ2uN0nNT
         oVGH51myjmnoNz4lJuFob7DXzL5t1Ztty3e3vGIaq2skIqMsvF4nZwHTZQSpG/XIHoSI
         QIyfQtZp1twPAq/1HXQDRya3Sknk+Xi9MuZsL1Bt4ONOF96xZ+8yOK2meS1KBuo1vi+4
         SvO/79CScHCmngAbY54+exOWsAa/xS4zaye1O1o1mf79NfSqhe1WWKnwS3oz+VQGP4ZH
         Xpww==
X-Forwarded-Encrypted: i=1; AJvYcCXsAI4RANWYMKDKQ8Db7J4LTMrrKdFzzQieafJkED8TZb4U9C1f1tNqJzkTrCXVivKzb2I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoZpyDayOCxOpl3kaVnZyPWkUHSH3FIHIlwHUA5NEivicQaVgL
	GzbcwQxhH574siETpwmaeXfzNM7TGx1opW1MN6kueG8IFzUJN6Ivb40p8yDUu/jJAR9xF51iMUX
	Cow==
X-Google-Smtp-Source: AGHT+IGvyvv+UuU+n7Fy8JhvcxqI0V5keILsIwkImrcxT1GQxNZQqyGj169BaloYUwrP5Q5CbjjHGz0+tLw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88f:b0:20c:5da9:ede0 with SMTP id
 d9443c01a7336-210f76d896emr318815ad.10.1730298510582; Wed, 30 Oct 2024
 07:28:30 -0700 (PDT)
Date: Wed, 30 Oct 2024 07:28:28 -0700
In-Reply-To: <20240906204515.3276696-3-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906204515.3276696-1-vipinsh@google.com> <20240906204515.3276696-3-vipinsh@google.com>
Message-ID: <ZyJCjJx2lxnEnDwa@google.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Vipin Sharma wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 455caaaa04f5..fc597f66aa11 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7317,8 +7317,8 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  	return err;
>  }
>  
> -void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
> -			       unsigned long nr_pages)
> +void kvm_recover_nx_huge_pages(struct kvm *kvm, bool shared,
> +			       struct list_head *pages, unsigned long nr_pages)
>  {
>  	struct kvm_memory_slot *slot;
>  	int rcu_idx;
> @@ -7329,7 +7329,10 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
>  	ulong to_zap;
>  
>  	rcu_idx = srcu_read_lock(&kvm->srcu);
> -	write_lock(&kvm->mmu_lock);
> +	if (shared)


Hmm, what if we do this?

enum kvm_mmu_types {
	KVM_SHADOW_MMU,
#ifdef CONFIG_X86_64
	KVM_TDP_MMU,
#endif
	KVM_NR_MMU_TYPES,
};

#ifndef CONFIG_X86_64
#define KVM_TDP_MMU -1
#endif

And then this becomes:

	if (mmu_type == KVM_TDP_MMU)
		
> +		read_lock(&kvm->mmu_lock);
> +	else
> +		write_lock(&kvm->mmu_lock);
>  
>  	/*
>  	 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
> @@ -7341,8 +7344,13 @@ void kvm_recover_nx_huge_pages(struct kvm *kvm, struct list_head *pages,
>  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
>  	to_zap = ratio ? DIV_ROUND_UP(nr_pages, ratio) : 0;
>  	for ( ; to_zap; --to_zap) {
> -		if (list_empty(pages))
> +		if (tdp_mmu_enabled)

Shouldn't this be?

		if (shared)

Or if we do the above

		if (mmu_type == KVM_TDP_MMU)
			 
Actually, better idea (sans comments)

	if (mmu_type == KVM_TDP_MMU) {
		read_lock(&kvm->mmu_lock);
		kvm_tdp_mmu_pages_lock(kvm);
	} else {
		write_lock(&kvm->mmu_lock);
	}

	rcu_read_lock();

	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
	to_zap = ratio ? DIV_ROUND_UP(possible_nx->nr_pages, ratio) : 0;
	for ( ; to_zap; --to_zap) {
		if (list_empty(possible_nx->pages))
			break;

                ...

		/* Blah blah blah. */
		if (mmu_type == KVM_TDP_MMU)
			kvm_tdp_mmu_pages_unlock(kvm);

                ...

		/* Blah blah blah. */
		if (mmu_type == KVM_TDP_MMU)
			kvm_tdp_mmu_pages_lock(kvm);
	}
	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);

	rcu_read_unlock();

	if (mmu_type == KVM_TDP_MMU) {
		kvm_tdp_mmu_pages_unlock(kvm);
		read_unlock(&kvm->mmu_lock);
	} else {
		write_unlock(&kvm->mmu_lock);
	}
	srcu_read_unlock(&kvm->srcu, rcu_idx);

> @@ -825,23 +835,51 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	rcu_read_unlock();
>  }
>  
> -bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> +bool kvm_tdp_mmu_zap_possible_nx_huge_page(struct kvm *kvm,

This rename, and any refactoring that is associated with said rename, e.g. comments,
belongs in a separate patch.

> +					   struct kvm_mmu_page *sp)
>  {
> -	u64 old_spte;
> +	struct tdp_iter iter = {
> +		.old_spte = sp->ptep ? kvm_tdp_mmu_read_spte(sp->ptep) : 0,
> +		.sptep = sp->ptep,
> +		.level = sp->role.level + 1,
> +		.gfn = sp->gfn,
> +		.as_id = kvm_mmu_page_as_id(sp),
> +	};
> +
> +	lockdep_assert_held_read(&kvm->mmu_lock);

Newline here, to isolate the lockdep assertion from the functional code.

> +	if (WARN_ON_ONCE(!is_tdp_mmu_page(sp)))
> +		return false;
>  
>  	/*
> -	 * This helper intentionally doesn't allow zapping a root shadow page,
> -	 * which doesn't have a parent page table and thus no associated entry.
> +	 * Root shadow pages don't a parent page table and thus no associated

Missed a word or three.

> +	 * entry, but they can never be possible NX huge pages.
>  	 */
>  	if (WARN_ON_ONCE(!sp->ptep))
>  		return false;
>  
> -	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
> -	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
> +	/*
> +	 * Since mmu_lock is held in read mode, it's possible another task has
> +	 * already modified the SPTE. Zap the SPTE if and only if the SPTE
> +	 * points at the SP's page table, as checking  shadow-present isn't
> +	 * sufficient, e.g. the SPTE could be replaced by a leaf SPTE, or even
> +	 * another SP. Note, spte_to_child_pt() also checks that the SPTE is
> +	 * shadow-present, i.e. guards against zapping a frozen SPTE.
> +	 */
> +	if ((tdp_ptep_t)sp->spt != spte_to_child_pt(iter.old_spte, iter.level))
>  		return false;
>  
> -	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> -			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
> +	/*
> +	 * If a different task modified the SPTE, then it should be impossible
> +	 * for the SPTE to still be used for the to-be-zapped SP. Non-leaf
> +	 * SPTEs don't have Dirty bits, KVM always sets the Accessed bit when
> +	 * creating non-leaf SPTEs, and all other bits are immutable for non-
> +	 * leaf SPTEs, i.e. the only legal operations for non-leaf SPTEs are
> +	 * zapping and replacement.
> +	 */
> +	if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE)) {
> +		WARN_ON_ONCE((tdp_ptep_t)sp->spt == spte_to_child_pt(iter.old_spte, iter.level));
> +		return false;
> +	}
>  
>  	return true;
>  }

