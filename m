Return-Path: <kvm+bounces-35915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3450A15ACE
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 02:10:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D302F1668B3
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26EFA17C79;
	Sat, 18 Jan 2025 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AK6uPd5S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ED225A63C
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737162592; cv=none; b=lml+UaidqsTTtApjNAW64lKO2LbcekjJ+SELgNXwFyLX7HnKBjLdzkOVbVfM1rsA2y/9ka0HBpmpbJDLL1xxSrs1zTH710bO9D5RQUBMnk574jV09+Ll+3HcC+guAckaDNgg33+GVZAr/xONiisKHmVWNCbRHEINiYYMDKIUATc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737162592; c=relaxed/simple;
	bh=CJQo7SGTdezwWsdk7YEKzMAximS4ITIKGQyVuLLUz8o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eJXDJFpyDx/axMrNZZjzZSSn5LKeKgyyks1KumyrMVRLPV78gYot+cQJTn+9JodeK27c9ChcVe28zsTVEBKkDOSeCBQJyZoaShgqnPPto6Jn1X0C8EEe6DYtiUoTpNj/ElFkIMfsZG5bh+729Flidmt0bp+5H7ffGCzRZBF17n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AK6uPd5S; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166f9f52fbso76747485ad.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737162590; x=1737767390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=skownV6tQ3VekZTC6BWpf4VU8Lh94jahtGLNwDiwESM=;
        b=AK6uPd5SihoGbIPN3rKbMaOSGtFHu0zVKXosVOP+DD9UIiu8pdV0QKmxft0gOG70SU
         tTajkaI3E4CN9fA35dNerBx1qyfbJdb5zzw/OaR5pLpyzbjLUKNZBHaYiOzHhM0N8gjM
         JRLChBU1GYqhP/DfBhfQsrY2YXCJT791ZP8Ea9QOBd+klxlU28gp+X4T4hgHC5p9cEQ3
         i9JkhixiLYSQv4jszxWgKXBewdl3r0LDFbf+P8qpnMKBIVV5BeIOHRM0ufzW3MI9aVNK
         sbzSNzR9Hk4wxJbKVsrhWYNSdus8WoNS4fXRwmA31ul6VvbRhlZMydRY1SvLnpPkd4Y1
         5glQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737162590; x=1737767390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=skownV6tQ3VekZTC6BWpf4VU8Lh94jahtGLNwDiwESM=;
        b=YpsuhrHnizTAnFPrkFI1DxgrW/OZn3ifyhmLHXGYOXH4fLkyZOVFwHa+zdT1dW8Cui
         2CoHXAhBHmmpGxg9b8nZnKLmYcJtf2k+yicuwUIapvCGYoT2kK1UgOSD+3fgXFvSDdv6
         YrsCaJg7OFAWZmi67MKvTeR5ID9iXZqqdb4yF2AYOTtHmY63MrmIrR86mNc5G/4Vu0uE
         5ezJ1qgAL7/NVN/SfUTdxwrxZO5NFsHEYjGtRs2sd0c8N9HfVWfNHNPENed9U3j0YtSc
         yXbsUD/j+w2JDzdSxBd9IOecWxqfwMHIF4UIklq1n5BOMkVCuXTK7QFqXbRCnbFCwEay
         iOdw==
X-Forwarded-Encrypted: i=1; AJvYcCUUgJuJiisytwGp7YtGcG1x3BigZ9efVH/lCbI56/sMw3/ByW00mkXwend8OpM9bgLvxgU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe7gsxtGFT2IELwLPQ7U5SV0eLVrc6lW1ebfTjJdqDauZlRlaW
	6624oTw5VXE5zDxoTHGPkbyV4GYzmUlX87tUM60Wy9ibZBOAD/nG5SFAicFo0PWPbgOOMMQFE6S
	iZw==
X-Google-Smtp-Source: AGHT+IGOstFtGHEebFnImvCAbphJLOGYqV+Y9ra5EAzgwwB+Cyl9SeO5twyz8cU8aCf1YwXo7qlqqKCkO9Y=
X-Received: from pjbtc8.prod.google.com ([2002:a17:90b:5408:b0:2ef:abba:8bfd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec6:b0:215:a3fb:b4d6
 with SMTP id d9443c01a7336-21c3553b55dmr51780825ad.8.1737162590187; Fri, 17
 Jan 2025 17:09:50 -0800 (PST)
Date: Fri, 17 Jan 2025 17:09:48 -0800
In-Reply-To: <20241222193445.349800-16-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241222193445.349800-1-pbonzini@redhat.com> <20241222193445.349800-16-pbonzini@redhat.com>
Message-ID: <Z4r_XNcxPWpgjZio@google.com>
Subject: Re: [PATCH v6 15/18] KVM: x86/tdp_mmu: Propagate tearing down mirror
 page tables
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yan.y.zhao@intel.com, 
	isaku.yamahata@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 22, 2024, Paolo Bonzini wrote:
> +	/* Because write lock is held, operation should success. */

succeed.

> +	ret = static_call(kvm_x86_remove_external_spte)(kvm, gfn, level, old_pfn);
> +	KVM_BUG_ON(ret, kvm);
> +}
> +
>  /**
>   * handle_removed_pt() - handle a page table removed from the TDP structure
>   *
> @@ -435,6 +458,23 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  		}
>  		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
>  				    old_spte, FROZEN_SPTE, level, shared);
> +
> +		if (is_mirror_sp(sp)) {
> +			KVM_BUG_ON(shared, kvm);

Should these bail early if the KVM_BUG_ON() is hit?  Calling into the TDX module
after bugging the VM is a bit odd.

> +			remove_external_spte(kvm, gfn, old_spte, level);
> +		}
> +	}
> +
> +	if (is_mirror_sp(sp) &&
> +	    WARN_ON(static_call(kvm_x86_free_external_spt)(kvm, base_gfn, sp->role.level,

WARN_ON_ONCE(). I suspect that if this ever gets hit, it'll come in bunches.

> +							  sp->external_spt))) {
> +		/*
> +		 * Failed to free page table page in mirror page table and
> +		 * there is nothing to do further.
> +		 * Intentionally leak the page to prevent the kernel from
> +		 * accessing the encrypted page.
> +		 */
> +		sp->external_spt = NULL;
>  	}
>  
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> @@ -608,6 +648,13 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  	if (is_mirror_sptep(iter->sptep) && !is_frozen_spte(new_spte)) {
>  		int ret;
>  
> +		/*
> +		 * Users of atomic zapping don't operate on mirror roots,
> +		 * so don't handle it and bug the VM if it's seen.
> +		 */
> +		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> +			return -EBUSY;
> +
>  		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
>  						iter->old_spte, new_spte, iter->level);
>  		if (ret)
> @@ -700,8 +747,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>  	 * Users that do non-atomic setting of PTEs don't operate on mirror
>  	 * roots, so don't handle it and bug the VM if it's seen.
>  	 */
> -	if (is_mirror_sptep(sptep))
> +	if (is_mirror_sptep(sptep)) {
>  		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> +		remove_external_spte(kvm, gfn, old_spte, level);
> +	}
>  
>  	return old_spte;
>  }
> -- 
> 2.43.5
> 
> 

