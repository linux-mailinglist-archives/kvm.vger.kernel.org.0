Return-Path: <kvm+bounces-26121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F91D971BBF
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60431F242E5
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA4D1BC066;
	Mon,  9 Sep 2024 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQAogBSY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B21BB69F
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889912; cv=none; b=BSFwA5/lKHghb5R8HdIWDukWkBPuEMvwDoRbrFYB0yODNcHdHfVxO+yfiVNVatzp7guuD0T3NaT5ssxTtQgcwj/pS9mWuTwkPmrerhTIwLgqHasxoH17KC9P23Y2DhG/QfB1tZzAirj8yyMXXn13ntn+BvVdShaqSDgEUVCe4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889912; c=relaxed/simple;
	bh=0qbnXvkzmhga39KKgbR31l0OB8fM8okXecKZNPmMmY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NpwhfZnlPHSCC2Bkl53pjWhADjpHazx1v0RTRyY+ySARrXo55swjsS4dmVrMAZNTv9Y1l2y364MdvhpNuHbVIR4jc/pOvTp6o9gAs1F4CT6VLPhYbri3IwvkTGmB2srS9zfRPTQjoyP6uSZ8TWQXbsN0GEG23I+ATsjdRYDLLko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQAogBSY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725889908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y0tZEvsZterp2aqnAF3GcnqbGD9ikKZZm7hI4RTRcxk=;
	b=cQAogBSYew5E0XI/m5BkEKFuGhx4ZLHaOHg82TUTc3ZvDwRgZ+niWtRCExImqugm7CSCeO
	NcGGrvWK+mIkBkuHtuPo5U7djI9HytVjkdfNna+wdTn0oJsKR8UPye63S+VGI5wC5mxKYx
	61RjTKdxnw3YeuJyvTaCeGu7D+KZKvk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-BJZgLszWPaesD5N8E0CbRw-1; Mon, 09 Sep 2024 09:51:43 -0400
X-MC-Unique: BJZgLszWPaesD5N8E0CbRw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-378929f1a4eso969125f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725889902; x=1726494702;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y0tZEvsZterp2aqnAF3GcnqbGD9ikKZZm7hI4RTRcxk=;
        b=j5V+o+N55Eli6UWQTfrRwIFKTynaAU5N5gL5W0B6gtmASl6BgnvAtn4FiwuzGN6h+D
         cFvyNe1fBuM6rlnIWE5yvkpMK1J4U3urMknvJbE0Nj0oacB0Hd/S63xhgRp0jur6BfR/
         dcp6m2pmvjmgiAY6M7JnsLDP5qk5dJj6O0uzUmkAJiAl1AjBmAz/1ExKEKkacuEbbGki
         qKDlY93auixLdD7MFxHeFkh7cak4Gi+5PgkGhi+45qovl7kOYB93DrwahUk19wsV7xzI
         BBnH6mt2C2YN4iBboDzaDf81J34hbSd230FiV1+k/bU56UpzAXYapSeggSbu5ktVLFJI
         DF0g==
X-Forwarded-Encrypted: i=1; AJvYcCXP1V7EeAyS40yf1DNkMHj44n/+ceq8ZPm4fGRwhrH2GEKRI5GW02mMC52aPoh3jWYzzPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YySp/L9QB4bR96KwUzfq0FDoqp0lFcWeGjCPGn5wRFBnnpo8Mtb
	4fNdkqtBlAD/Jd76XXl3nj1z9gfd+O6vx9Sg5xNihl/6kVbxdefMWMLBxq3fPA7saY5Z8FgyTP6
	VX/t/psVUHGfr2XK/T3VuSv3kuPSCnwP5NfcPl5TaMUfPFWKCWg==
X-Received: by 2002:adf:e84a:0:b0:374:c92e:f69f with SMTP id ffacd0b85a97d-378895caf24mr7229060f8f.16.1725889901773;
        Mon, 09 Sep 2024 06:51:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDfIgsMO6NLNmoe2gXmS+oP/AsxfqL24bcUlxSPiMg6y6PqpLe7sOx2QTJodRnKO68Qy7p9g==
X-Received: by 2002:adf:e84a:0:b0:374:c92e:f69f with SMTP id ffacd0b85a97d-378895caf24mr7229033f8f.16.1725889900970;
        Mon, 09 Sep 2024 06:51:40 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956650fdsm6120284f8f.25.2024.09.09.06.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 06:51:40 -0700 (PDT)
Message-ID: <d8dc1d89-4f23-41c8-bddf-ebbc41f579d5@redhat.com>
Date: Mon, 9 Sep 2024 15:51:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/21] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-3-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Export a function to walk down the TDP without modifying it and simply
> check if a PGA is mapped.
> 
> Future changes will support pre-populating TDX private memory. In order to
> implement this KVM will need to check if a given GFN is already
> pre-populated in the mirrored EPT. [1]
> 
> There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
> the KVM MMU that almost does what is required. However, to make sense of
> the results, MMU internal PTE helpers are needed. Refactor the code to
> provide a helper that can be used outside of the KVM MMU code.
> 
> Refactoring the KVM page fault handler to support this lookup usage was
> also considered, but it was an awkward fit.
> 
> kvm_tdp_mmu_gpa_is_mapped() is based on a diff by Paolo Bonzini.
> 
> Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Change exported function to just return of GPA is mapped because "You
>     are executing with the filemap_invalidate_lock() taken, and therefore
>     cannot race with kvm_gmem_punch_hole()" (Paolo)
>     https://lore.kernel.org/kvm/CABgObfbpNN842noAe77WYvgi5MzK2SAA_FYw-=fGa+PcT_Z22w@mail.gmail.com/
>   - Take root hpa instead of enum (Paolo)
> 
> TDX MMU Prep v2:
>   - Rename function with "mirror" and use root enum
> 
> TDX MMU Prep:
>   - New patch
> ---
>   arch/x86/kvm/mmu.h         |  3 +++
>   arch/x86/kvm/mmu/mmu.c     |  3 +--
>   arch/x86/kvm/mmu/tdp_mmu.c | 37 ++++++++++++++++++++++++++++++++-----
>   3 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 8f289222b353..5faa416ac874 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -254,6 +254,9 @@ extern bool tdp_mmu_enabled;
>   #define tdp_mmu_enabled false
>   #endif
>   
> +bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +
>   static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>   {
>   	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7e66d7c426c1..01808cdf8627 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4713,8 +4713,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	return direct_page_fault(vcpu, fault);
>   }
>   
> -static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> -			    u8 *level)
> +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
>   {
>   	int r;
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 37b3769a5d32..019b43723d90 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1911,16 +1911,13 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>    *
>    * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
>    */
> -int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> -			 int *root_level)
> +static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +				  struct kvm_mmu_page *root)
>   {
> -	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
>   	struct tdp_iter iter;
>   	gfn_t gfn = addr >> PAGE_SHIFT;
>   	int leaf = -1;
>   
> -	*root_level = vcpu->arch.mmu->root_role.level;
> -
>   	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
>   		leaf = iter.level;
>   		sptes[leaf] = iter.old_spte;
> @@ -1929,6 +1926,36 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>   	return leaf;
>   }
>   
> +int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> +			 int *root_level)
> +{
> +	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
> +	*root_level = vcpu->arch.mmu->root_role.level;
> +
> +	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
> +}
> +
> +bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	bool is_direct = kvm_is_addr_direct(kvm, gpa);
> +	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
> +				 vcpu->arch.mmu->mirror_root_hpa;
> +	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
> +	int leaf;
> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	rcu_read_lock();
> +	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
> +	rcu_read_unlock();
> +	if (leaf < 0)
> +		return false;
> +
> +	spte = sptes[leaf];
> +	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
> +}
> +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
> +
>   /*
>    * Returns the last level spte pointer of the shadow page walk for the given
>    * gpa, and sets *spte to the spte value. This spte may be non-preset. If no

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

I will take another look at the locking after I see some callers.

Paolo


