Return-Path: <kvm+bounces-39961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C60CA4D299
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0691D3AC001
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485F51F03D1;
	Tue,  4 Mar 2025 04:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="etjibc7l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9267A14F9FB
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062923; cv=none; b=AE/XjvIqGNE5dmBZ7VOTh3CAXllNvRu/85jAVeqadtHehMw403SGqlh+L8C60nWAkGlR37h5eLIq/mpOytsexD0GgT8tLy+V6DTDuzxCnunNgyDpJjcrjvv8KEAWdrhA6wWVaK0SXP9EEka3J6vyr9d5/AEQanW4ABCy6jnvqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062923; c=relaxed/simple;
	bh=eDv7izcYqzv4YAygR57Owiww1VX6TewRxTapsAxTfog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r3VVEuh3D4/fYsKAHGlEnK0qXET0AUNB0+0+SHi33gyqhuAQPf9aBS93U/pJe2AdoMx62M4kdPrRcXuwsLnF6yNYw30phC/r2zxjjbnUnJDZLccb9qCgVymC3ySAa44kO6QNJLeJDX12Jnmr87MXVSlGUad1+wE1ZsKYmrd/reI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=etjibc7l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741062920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=koAfnbIioMA+14AQ61if+zlW74/NZhlzHrW6k45ApV8=;
	b=etjibc7loZucRBeE7BgTWiW+B55gkte9R1l0LW9EXA5dzo73pKkFooS0mCX8u2rkZDhjc/
	ExzmM7n3tLMCDSSmYUC7wYo/YU9F8bkIYHFVcnLgo0uGunRyrwblnNEPE/0HMj9Pwy1/zY
	lUYKCWFkwMt5s/erRDGUqiBGTi7AYvU=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-qRMK5Bm-PAS4caSCHlOuSQ-1; Mon, 03 Mar 2025 23:35:19 -0500
X-MC-Unique: qRMK5Bm-PAS4caSCHlOuSQ-1
X-Mimecast-MFC-AGG-ID: qRMK5Bm-PAS4caSCHlOuSQ_1741062918
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-22366901375so85640615ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 20:35:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741062918; x=1741667718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=koAfnbIioMA+14AQ61if+zlW74/NZhlzHrW6k45ApV8=;
        b=asOh2W2M6Ts+viTbyGMbLgTucugJ11nxM8ti0XuEhmV8RiT2Zy0/OY8wJbpnljjh1w
         rRpUtuZFQ2xwRm0pt6TTIL6v596HOBmUPGul3sNNjn7iPnDJkFwZDeeee5XlsPSyaWCA
         nDnGuY2TdOeyR3uPfd5TTZk/g+cpY3ml4jXsOUBRkMKWIPifYSGDH7Q/g7Cw+0QCDwVf
         6qh+hgTCQh8I/j9QGMwWTqRPi74tZjymELpwgSqkfvVrrDnZnaCLxDKLG+CD0BaV2d48
         LJn/56zndsHtROmTX+9W9iKmpm4M3FY9hC0dT+PZVNRW3FBZP6Ln4ErVSUY+SExX3AZ4
         dArw==
X-Forwarded-Encrypted: i=1; AJvYcCVUScdgVO/J/kq+1FXATcTjkNEAmxOlgsWzZuf38lCdjOsjPFqiIns/05fiJqEgF9tdYzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YysUW2SdaU1GnHqjYZ6Z0qOMEtFF8G+Y2eOK4SbPJrgtPh1248r
	AF4e6RhiBOk4H/fMsR/o86LsstHaYgXmDEQdCQITly5kgKQniJZPnSU2BJsrE3qycx+IbgFqhW3
	XgI7Ml7AfgGeF7Mp/56nPdTZVY2P5HHxXhEqfnnh0bvU1W48unA==
X-Gm-Gg: ASbGncuBp2GOblDAtm2jn15Y07Z4TLYEdAYr0WZKAVlehUvIaAd4KbRsQcWiX7vDnen
	4KMKHrnm8ggqVHp1NXGm4iJmK6NDTZfW/SytRdtud8klhnk/6CcFTjAb2nzVOB9Y3NG3mzgYwyg
	UnzR1sXU9OJwsWX8YvZOl3gQhJQdbdFR+BTRnOSg1pLnnuZ0R/nmZMWcW5YdE4eJwNHS+VPaDED
	orc/AFsOUVCKTTdg5hy97dGqPWLpxnGfJmKqc8x1MqXn0VXeetF5OmDI3tzsaY+By1NaFO+OiwS
	CbJTKwMnAo4E9jFJjw==
X-Received: by 2002:a05:6a00:1913:b0:736:3ea8:4813 with SMTP id d2e1a72fcca58-7366e54bffdmr3139292b3a.2.1741062917997;
        Mon, 03 Mar 2025 20:35:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQXRcbRKs/P20up2fdaG8YXNHl5+RMV13H5szfYcd+4TW2P2h1zQR3oil9dzOG5dukT3+nLg==
X-Received: by 2002:a05:6a00:1913:b0:736:3ea8:4813 with SMTP id d2e1a72fcca58-7366e54bffdmr3139257b3a.2.1741062917556;
        Mon, 03 Mar 2025 20:35:17 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7dcb4611sm9141977a12.0.2025.03.03.20.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 20:35:16 -0800 (PST)
Message-ID: <b89caaaf-3d26-4ca4-b395-08bf3f90dd1f@redhat.com>
Date: Tue, 4 Mar 2025 14:35:08 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/45] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-19-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-19-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> The guest can request that a region of it's protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
> 
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do with by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>   arch/arm64/kvm/rme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 87 insertions(+)
> 

With the following comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 507eb4b71bb7..f965869e9ef7 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -624,6 +624,64 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
>   		realm_unmap_private_range(kvm, start, end);
>   }
>   
> +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			       unsigned long start,
> +			       unsigned long end,
> +			       unsigned long ripas,
> +			       unsigned long *top_ipa)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> +	unsigned long ipa = start;
> +	int ret = 0;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
> +

This doesn't look correct to me. Looking at RMM::smc_rtt_set_ripas(), it's possible
the SMC call is returned without updating 'next' to a valid address. In this case,
the garbage content resident in 'next' can be used to updated to 'ipa' in next
iternation. So we need to initialize it in advance, like below.

	unsigned long ipa = start;
	unsigned long next = start;

	while (ipa < end) {
		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);

> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int walk_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			/*
> +			 * If the RMM walk ended early then more tables are
> +			 * needed to reach the required depth to set the RIPAS.
> +			 */
> +			if (walk_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      walk_level,
> +							      level,
> +							      memcache);
> +				/* Retry with RTTs created */
> +				if (!ret)
> +					continue;
> +			} else {
> +				ret = -EINVAL;
> +			}
> +
> +			break;
> +		} else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
> +			     ret);
> +			ret = -EINVAL;

			ret = -ENXIO;

> +			break;
> +		}
> +		ipa = next;
> +	}
> +
> +	*top_ipa = ipa;
> +
> +	if (ripas == RMI_EMPTY && ipa != start)
> +		realm_unmap_private_range(kvm, start, ipa);
> +
> +	return ret;
> +}
> +
>   static int realm_init_ipa_state(struct realm *realm,
>   				unsigned long ipa,
>   				unsigned long end)
> @@ -863,6 +921,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>   	kvm_free_stage2_pgd(&kvm->arch.mmu);
>   }
>   
> +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long base = rec->run->exit.ripas_base;
> +	unsigned long top = rec->run->exit.ripas_top;
> +	unsigned long ripas = rec->run->exit.ripas_value;
> +	unsigned long top_ipa;
> +	int ret;
> +

Some checks are needed here to ensure the addresses (@base and @top) falls inside
the protected (private) space for two facts: (1) Those parameters originates from
the guest, which can be misbehaving. (2) RMM::smc_rtt_set_ripas() isn't limited to
the private space, meaning it also can change RIPAS for the ranges in the shared
space.

> +	do {
> +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +		write_lock(&kvm->mmu_lock);
> +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> +		write_unlock(&kvm->mmu_lock);
> +
> +		if (WARN_RATELIMIT(ret && ret != -ENOMEM,
> +				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> +				   base, top, ripas))
> +			break;
> +
> +		base = top_ipa;
> +	} while (top_ipa < top);
> +}
> +
>   int kvm_rec_enter(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -873,6 +957,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
>   		for (int i = 0; i < REC_RUN_GPRS; i++)
>   			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>   		break;
> +	case RMI_EXIT_RIPAS_CHANGE:
> +		kvm_complete_ripas_change(vcpu);
> +		break;
>   	}
>   
>   	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)

Thanks,
Gavin


