Return-Path: <kvm+bounces-39963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13626A4D2D7
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6299D3ABC75
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F2B1F463B;
	Tue,  4 Mar 2025 05:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VY3cAIp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AEC1F4717
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065021; cv=none; b=AKvFAEIsfrSbyTxsY8f58Hoer3eeQcAsGIQaymTjUPoUoS3CXyQMNz6jIme9MkIztUwzlSqwrWHhXrdA40Ou+CeIA4xBk69U6EA74RO8FkXGJx6qxqbBvAGuXEz525fwiG1om3/FqtthPvjtJUExA3gwbjLZJS/DhrM1dsCRieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065021; c=relaxed/simple;
	bh=mo6UEqLjhhD/gYk0pYC+753IVwsq5HZnkglHB39gdLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n20KbaymxCjt0ssg/LkrwJTOrY3BEnCJCC1cgUZFpDdIwnONeNcBxHZpnfF8v3PrlsocO02QZOXvR+9vuy2/o+TOTr8aKJb4hLdorTBT5JFiH6atUFSp+ZZt1zPibIuTucdVmmeyqzj/p7Al9RoCEj1y6An7rE0Hw85kEsERJBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VY3cAIp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741065016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8NQ+qKZ44E29enCPM7Eb/wfq67YXGlkr0AyFJChf4s=;
	b=VY3cAIp7ZPcE8qU/+QyHxNjEoVv6FhCnsZ6gMR7goMGguT8RZgc6/0SM4CiAGTEqzQyZmv
	KJ254RUZOXvX9KcNpUFltDeDy+ZgXA1etMKzeyRVTDaevoFiTBHT6AxqP/j6vmv86DTX17
	MY8HZ2Ptr4J8hoZjWh/MG9VhoJangZo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-cG2M_rpwPxOJ9cDVwpwHiw-1; Tue, 04 Mar 2025 00:10:09 -0500
X-MC-Unique: cG2M_rpwPxOJ9cDVwpwHiw-1
X-Mimecast-MFC-AGG-ID: cG2M_rpwPxOJ9cDVwpwHiw_1741065009
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2feda472a7bso4772402a91.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741065009; x=1741669809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U8NQ+qKZ44E29enCPM7Eb/wfq67YXGlkr0AyFJChf4s=;
        b=DKaDY2swnXwIB9V6FPWxrigXP/bM+JWmxz4K0M2uyb4yGwvRzwpynCFSlqZ15KgMSa
         tf1wYovVAyBXuRNlvpDieJtgajhnBx8RPTaHAkBYP2pCEJyv5JNvNn9efV1FmePBJdLb
         hPxp2RSqDP/P1JT5wUQT9PpQ8zmImPMJweznFmutSdeirV+DGCdks1BW1+GmJB2axeZw
         j/EUpKMEabjTYZOnt/fmPcpNDWJawtcLvyoyvFrBE6emqhbQ8VqO0Hkqd5XM5NQj5dTl
         j81FsW2dwvyuybaWAPYQ5azD4gNvQy9rvPdFztPbGhQmCrMOoWaxRBLESfHtAmkfMqdo
         nmAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe1SFRdcZsqwZIDpM6ApAjB8o69OBKtFxNz1Xcx4ECub6b4y71dJ7G9p234lbAk7UuwIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTehiiFiJPo1oV5WmUgnhYqFd7oXacLV2kVo7pbDMpf2bkYmVT
	mZtaWwEsvWrqi5Hjzkd+PtHjQ4FTJ0g85qBRKaqTphkUXTE2G8NDiU4UjVdP8a6eSopUrv7Faqk
	wn+6mdnifype32AssnjIsy1taL7rQsEZ+zgCY2QO8HdeO6tsuAw==
X-Gm-Gg: ASbGncsOZiBFLdnD2Sux9OZC0abSGOTZD9/jLUy54zJa2GLnL6oUahUbBfhNoFwZkfa
	lCVCuashVLw5bVkObAlUZ8T0nmip7xfNw0SH+2eJNVuZlCvkpTB+cpfHa4pGwBbZdxYw9Z+/AuC
	uHpHy2Nystv4qYWeKx7T1L9kJqPNl8Yo4LWkPskWzMSHkL6pGGzrhsEToEJQBnbnQgkPXlhczWd
	+cOB6j4a6TIHeWAauNXbxIRMJHlaGdLcbDnD/+Oako8JeP7hhYeAiYcXDvZwfIYEFxRtjr9wGBx
	AR/CORSS+iHGfwffoQ==
X-Received: by 2002:a17:90b:4c4d:b0:2fa:e9b:33ab with SMTP id 98e67ed59e1d1-2febab7878bmr27494283a91.16.1741065008851;
        Mon, 03 Mar 2025 21:10:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiZnTyS+PczRxTvLSMdHTFs/jB2+JERIbLYMAxRPKra+AaKI0Fes/aNpheWezo+oJpvWNtmw==
X-Received: by 2002:a17:90b:4c4d:b0:2fa:e9b:33ab with SMTP id 98e67ed59e1d1-2febab7878bmr27494245a91.16.1741065008475;
        Mon, 03 Mar 2025 21:10:08 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe825d2b85sm12057524a91.26.2025.03.03.21.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:10:07 -0800 (PST)
Message-ID: <8e852bc0-9a02-42d9-8d56-712c11508626@redhat.com>
Date: Tue, 4 Mar 2025 15:09:59 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/45] arm64: RME: Allow populating initial contents
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
 <20250213161426.102987-21-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-21-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Handle host potentially having a larger page size than the RMM
>     granule.
>   * Drop historic "par" (protected address range) from
>     populate_par_region() - it doesn't exist within the current
>     architecture.
>   * Add a cond_resched() call in kvm_populate_realm().
> Changes since v5:
>   * Refactor to use PFNs rather than tracking struct page in
>     realm_create_protected_data_page().
>   * Pull changes from a later patch (in the v5 series) for accessing
>     pages from a guest memfd.
>   * Do the populate in chunks to avoid holding locks for too long and
>     triggering RCU stall warnings.
> ---
>   arch/arm64/kvm/rme.c | 234 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 234 insertions(+)
> 

With the following comments addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f965869e9ef7..7880894db722 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -624,6 +624,228 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
>   		realm_unmap_private_range(kvm, start, end);
>   }
>   
> +static int realm_create_protected_data_granule(struct realm *realm,
> +					       unsigned long ipa,
> +					       phys_addr_t dst_phys,
> +					       phys_addr_t src_phys,
> +					       unsigned long flags)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	if (rmi_granule_delegate(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		WARN_ON(level == RMM_RTT_MAX_LEVEL);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      RMM_RTT_MAX_LEVEL, NULL);
> +		if (ret)
> +			return -EIO;
> +
> +		ret = rmi_data_create(rd, dst_phys, ipa, src_phys, flags);
> +	}
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int realm_create_protected_data_page(struct realm *realm,
> +					    unsigned long ipa,
> +					    kvm_pfn_t dst_pfn,
> +					    kvm_pfn_t src_pfn,
> +					    unsigned long flags)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	phys_addr_t dst_phys, src_phys;
> +	bool undelegate_failed = false;
> +	int ret, offset;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	for (offset = 0; offset < PAGE_SIZE; offset += RMM_PAGE_SIZE) {
> +		ret = realm_create_protected_data_granule(realm,
> +							  ipa,
> +							  dst_phys,
> +							  src_phys,
> +							  flags);
> +		if (ret)
> +			goto err;
> +
> +		ipa += RMM_PAGE_SIZE;
> +		dst_phys += RMM_PAGE_SIZE;
> +		src_phys += RMM_PAGE_SIZE;
> +	}
> +
> +	return 0;
> +
> +err:
> +	if (ret == -EIO) {
> +		/* current offset needs undelegating */
> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +			undelegate_failed = true;
> +	}
> +	while (offset > 0) {
> +		ipa -= RMM_PAGE_SIZE;
> +		offset -= RMM_PAGE_SIZE;
> +		dst_phys -= RMM_PAGE_SIZE;
> +
> +		rmi_data_destroy(rd, ipa, NULL, NULL);
> +
> +		if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +			undelegate_failed = true;
> +	}
> +
> +	if (undelegate_failed) {
> +		/*
> +		 * A granule could not be undelegated,
> +		 * so the page has to be leaked
> +		 */
> +		get_page(pfn_to_page(dst_pfn));
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +static int populate_region(struct kvm *kvm,
> +			   phys_addr_t ipa_base,
> +			   phys_addr_t ipa_end,
> +			   unsigned long data_flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct kvm_memory_slot *memslot;
> +	gfn_t base_gfn, end_gfn;
> +	int idx;
> +	phys_addr_t ipa;
> +	int ret = 0;
> +
> +	base_gfn = gpa_to_gfn(ipa_base);
> +	end_gfn = gpa_to_gfn(ipa_end);
> +
> +	idx = srcu_read_lock(&kvm->srcu);
> +	memslot = gfn_to_memslot(kvm, base_gfn);
> +	if (!memslot) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* We require the region to be contained within a single memslot */
> +	if (memslot->base_gfn + memslot->npages < end_gfn) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!kvm_slot_can_be_private(memslot)) {
> +		ret = -EINVAL;
		ret = -EPERM;

> +		goto out;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	ipa = ALIGN_DOWN(ipa_base, PAGE_SIZE);

The aignment operation is unnecessary since the base/size are ensured
to be aligned to PAGE_SIZE by its caller (kvm_populate_realm()).

> +	while (ipa < ipa_end) {
> +		struct vm_area_struct *vma;
> +		unsigned long hva;
> +		struct page *page;
> +		bool writeable;
> +		kvm_pfn_t pfn;
> +		kvm_pfn_t priv_pfn;
> +		struct page *gmem_page;
> +
> +		hva = gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
> +		vma = vma_lookup(current->mm, hva);
> +		if (!vma) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		pfn = __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_WRITE,
> +					&writeable, &page);
> +
> +		if (is_error_pfn(pfn)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		ret = kvm_gmem_get_pfn(kvm, memslot,
> +				       ipa >> PAGE_SHIFT,
> +				       &priv_pfn, &gmem_page, NULL);
> +		if (ret)
> +			break;
> +
> +		ret = realm_create_protected_data_page(realm, ipa,
> +						       priv_pfn,
> +						       pfn,
> +						       data_flags);
> +
> +		kvm_release_faultin_page(kvm, page, false, false);
> +
> +		if (ret)
> +			break;
> +
> +		ipa += PAGE_SIZE;
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +
> +out:
> +	srcu_read_unlock(&kvm->srcu, idx);
> +	return ret;
> +}
> +
> +static int kvm_populate_realm(struct kvm *kvm,
> +			      struct arm_rme_populate_realm *args)
> +{
> +	phys_addr_t ipa_base, ipa_end;
> +	unsigned long data_flags = 0;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
		return -EPERM;

> +
> +	if (!IS_ALIGNED(args->base, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->size, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	if (args->flags & ~RMI_MEASURE_CONTENT)
> +		return -EINVAL;

It's perfect to combine those checks:

	if (!IS_ALIGNED(...) ||
	    !IS_ALIGNED(...) ||
	    args->flags & ~RMI_MEASURE_CONTENT)
		return -EINVAL;

> +
> +	ipa_base = args->base;
> +	ipa_end = ipa_base + args->size;
> +
> +	if (ipa_end < ipa_base)
> +		return -EINVAL;
> +
> +	if (args->flags & RMI_MEASURE_CONTENT)
> +		data_flags |= RMI_MEASURE_CONTENT;
> +
> +	/*
> +	 * Perform the populate in parts to ensure locks are not held for too
> +	 * long
> +	 */
	
s/populate/population ?

> +	while (ipa_base < ipa_end) {
> +		phys_addr_t end = min(ipa_end, ipa_base + SZ_2M);
> +
> +		int ret = populate_region(kvm, ipa_base, end,
> +					  args->flags);
> +
> +		if (ret)
> +			return ret;
> +
> +		ipa_base = end;
> +
> +		cond_resched();
> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			       unsigned long start,
>   			       unsigned long end,
> @@ -873,6 +1095,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   		r = kvm_init_ipa_range_realm(kvm, &args);
>   		break;
>   	}
> +	case KVM_CAP_ARM_RME_POPULATE_REALM: {
> +		struct arm_rme_populate_realm args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_populate_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;

Thanks,
Gavin


