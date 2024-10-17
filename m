Return-Path: <kvm+bounces-29096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A56FB9A29AC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DC211C24817
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A16D1DF966;
	Thu, 17 Oct 2024 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPVZSF1j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE021DED5B
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729183961; cv=none; b=qmx6MdxWAihQ0R09HhakAf7ZMxCfeFOrzzFgrQhpKDaAp+4Vk00jWEcixdg2ldqmJxa/qyxQgv/4ni02rblXTXW4D8gMYXj8wzYDPZ2jDQV2k+lkFvnWRUpf/7YteVHWPGbqfH5ShpKKY3UXfMeWrvy6S6nQUBqgZllpafAgX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729183961; c=relaxed/simple;
	bh=Hp2skBmksm2Nop3WL/olNlttOKSxVOSk+nVKmera6iE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WCo9mDf+vNmODalYZ+dsw+XpfUN1u/uxW12W070QiagW+Ur6wKElxDa/mgRYitf3gco9ST4U8ypFH2xG1j8k1yt2NyXJtzl1egJWxI3D/SDHY96Fc3jL2OQPAtdFyIXED/j42bBo27Vtx1iMKtzH/+PGeFcjansyKxMuHAA56pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XPVZSF1j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729183958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0+znCeiC0PfO1yMAOLBPapR8CxqjVOUMXhxU/p8mNcc=;
	b=XPVZSF1jVqSaptCDeLBIiOu/kqUFaWZH33oENK4MQPvSBtgQZNsMTgpZJyZriX9HwiLPI/
	C74cu8kVTDgALxoMzT5TWRFjlobUyHGNieHQWnCj+mNCC4AmjEDatVWxcaiN7kB+kAIVi7
	TYOZiiAe3TRvr4rAgoyaunEI6E8T3Sw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-VRd1wop9O-ei9OC53kzG3g-1; Thu, 17 Oct 2024 12:52:37 -0400
X-MC-Unique: VRd1wop9O-ei9OC53kzG3g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314f1e0f2bso7252335e9.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729183956; x=1729788756;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0+znCeiC0PfO1yMAOLBPapR8CxqjVOUMXhxU/p8mNcc=;
        b=GC8euNh0ZCd/p171QWErOqTGXdA+F4UZd/w1jZ4KvHFaI23DyvX1Go37aN20kSELkL
         C/xrj5TpCQMoYoqdmlWOYdXDz36trBzlgas9BZTuqLx2lLyq/BW+BXIwpG01PB80Kk49
         TLEFIkqbVRHA7BJc/J5YVBK4ddiq3/tDr/AmasuVI5TfWgvEhTJxEEvGnfjmTVm2Ycfv
         iS/pKZ3HH+1o87XrVSFFPFWMUs1t7HaZK0ROf0nn+QYOFy09w6uFVuq/mrWwtzSKm7oT
         pTjO2hDPiEVUHgA9pyBYo/gPcNdk2Fv+bydNE1Bb/IUmfTPcZ98wKdd8xGjbDX0voD08
         Muiw==
X-Gm-Message-State: AOJu0YzW86Cgy+7S33beDKK2LQ9/Wyaqm/yQEyD+KtcbDaNpwduFlPg9
	CyQSSP15G7L8T1HuWoe4IjFfi/KpqX+CNb6kNWDeKrpyC0IFOj+O/Rr1yQHd6Myk7cLwY+Y20l7
	KdL4plar001GTLv7u58/3Jfd0mkYjfDsppRonFvX719yuq0i15Q==
X-Received: by 2002:a05:600c:5753:b0:431:3a6d:b84a with SMTP id 5b1f17b1804b1-4313a6dba27mr75063515e9.4.1729183956433;
        Thu, 17 Oct 2024 09:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+9P4TX0tiEiREMyduwnlWuKFINHCnWEmB3yE/eEN8k2eLvDXjhUQz/SOibJg8f/dw1u2fZQ==
X-Received: by 2002:a05:600c:5753:b0:431:3a6d:b84a with SMTP id 5b1f17b1804b1-4313a6dba27mr75063345e9.4.1729183955950;
        Thu, 17 Oct 2024 09:52:35 -0700 (PDT)
Received: from [192.168.10.28] ([151.95.144.54])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37d7fc419ffsm7713192f8f.111.2024.10.17.09.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 09:52:35 -0700 (PDT)
Message-ID: <12ad52ec-f5cc-43ff-9051-040fceeed68b@redhat.com>
Date: Thu, 17 Oct 2024 18:52:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/18] KVM: x86/mmu: Stop processing TDP MMU roots for
 test_age if young SPTE found
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>
References: <20241011021051.1557902-1-seanjc@google.com>
 <20241011021051.1557902-15-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241011021051.1557902-15-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 04:10, Sean Christopherson wrote:
> Return immediately if a young SPTE is found when testing, but not updating,
> SPTEs.  The return value is a boolean, i.e. whether there is one young SPTE
> or fifty is irrelevant (ignoring the fact that it's impossible for there to
> be fifty SPTEs, as KVM has a hard limit on the number of valid TDP MMU
> roots).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 84 ++++++++++++++++++--------------------
>   1 file changed, 40 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e8c061bf94ec..f412bca206c5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1192,35 +1192,6 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
>   	return flush;
>   }
>   
> -typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> -			      struct kvm_gfn_range *range);
> -
> -static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
> -						   struct kvm_gfn_range *range,
> -						   tdp_handler_t handler)
> -{
> -	struct kvm_mmu_page *root;
> -	struct tdp_iter iter;
> -	bool ret = false;
> -
> -	/*
> -	 * Don't support rescheduling, none of the MMU notifiers that funnel
> -	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
> -	 * this helper must NOT be used to unmap GFNs, as it processes only
> -	 * valid roots!
> -	 */
> -	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
> -		rcu_read_lock();
> -
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> -			ret |= handler(kvm, &iter, range);
> -
> -		rcu_read_unlock();
> -	}
> -
> -	return ret;
> -}
> -
>   /*
>    * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
>    * if any of the GFNs in the range have been accessed.
> @@ -1229,15 +1200,10 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>    * from the clear_young() or clear_flush_young() notifier, which uses the
>    * return value to determine if the page has been accessed.
>    */
> -static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
> -			  struct kvm_gfn_range *range)
> +static void kvm_tdp_mmu_age_spte(struct tdp_iter *iter)
>   {
>   	u64 new_spte;
>   
> -	/* If we have a non-accessed entry we don't need to change the pte. */
> -	if (!is_accessed_spte(iter->old_spte))
> -		return false;
> -
>   	if (spte_ad_enabled(iter->old_spte)) {
>   		iter->old_spte = tdp_mmu_clear_spte_bits(iter->sptep,
>   							 iter->old_spte,
> @@ -1253,23 +1219,53 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>   
>   	trace_kvm_tdp_mmu_spte_changed(iter->as_id, iter->gfn, iter->level,
>   				       iter->old_spte, new_spte);
> -	return true;
> +}
> +
> +static bool __kvm_tdp_mmu_age_gfn_range(struct kvm *kvm,
> +					struct kvm_gfn_range *range,
> +					bool test_only)
> +{
> +	struct kvm_mmu_page *root;
> +	struct tdp_iter iter;
> +	bool ret = false;
> +
> +	/*
> +	 * Don't support rescheduling, none of the MMU notifiers that funnel
> +	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
> +	 * this helper must NOT be used to unmap GFNs, as it processes only
> +	 * valid roots!
> +	 */
> +	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		rcu_read_lock();
> +
> +		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> +			if (!is_accessed_spte(iter.old_spte))
> +				continue;
> +
> +			ret = true;
> +			if (test_only)
> +				break;
> +
> +			kvm_tdp_mmu_age_spte(&iter);
> +		}
> +
> +		rcu_read_unlock();
> +
> +		if (ret && test_only)
> +			break;
> +	}
> +
> +	return ret;
>   }

If you use guard(rcu)() you can avoid the repeated breaks:
  
	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
		guard(rcu)();

		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
			if (!is_accessed_spte(iter.old_spte))
				continue;

			ret = true;
			if (test_only)
				return ret;

			kvm_tdp_mmu_age_spte(&iter);
		}
	}

	return ret;

Paolo


