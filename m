Return-Path: <kvm+bounces-51234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49116AF0753
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EAFC1BC6A3A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B3C1CD0C;
	Wed,  2 Jul 2025 00:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eV4T26Rt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C9DD299
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751416687; cv=none; b=u6/zegObX7Bm9TAaeMN0Z09WX8kPDuLHzVgJGxShcHipJiSoCHlPUevszKXhgNUe2Iv1jMBpny5kKhxt32x1HDk9XKf7XC0gRB8PnLGf6vj7TREFWP99pIK5+sNGXCCdHEXuX5pFuw6RdUkdxpE20Np0oSPYz+xBMUW7sjQGatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751416687; c=relaxed/simple;
	bh=sW92Q7hECR3Ob30TL9z0CU35jQaNX34vivyC5WHTD8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RrEFZEn//n1p8qhpDMgHQLRGGA5mTJY8txPJ3b8GBb2oQQ6Uq/W+WfefMWgbCM4Cn9YC6ZGQ0BQemTktEAiVIfc323mzbmF+tD5b643kwbXUoHzba4RnQ0q9URokj53qOdTFDBC7A/qBaGq+rBk1kEoquMvh5DPPRgj157m+IGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eV4T26Rt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751416682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4Mg4TUJJ3uoMGKLosYWNsDRGOBUPcTRizt1GIxrfoM=;
	b=eV4T26RtaiLYWyQxftjKubQ2gKBAazS/7yZTngO8i8o8VXEVn2BirQIljvfgP9SootbYbm
	tazHJN4Vd5jMUk0Q0bd/Sj4NHnJ22g5Lc4gGpVAWVvfjDO30S7XVDwWZrXmk02pxEyH3R8
	WxPF01DLoF0Z/+u6O3xJGdi+/yk+Gec=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-fWO90eKXP5CXrPWeWCRHnA-1; Tue, 01 Jul 2025 20:38:01 -0400
X-MC-Unique: fWO90eKXP5CXrPWeWCRHnA-1
X-Mimecast-MFC-AGG-ID: fWO90eKXP5CXrPWeWCRHnA_1751416680
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-234fedd3e51so35687505ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 17:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751416680; x=1752021480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4Mg4TUJJ3uoMGKLosYWNsDRGOBUPcTRizt1GIxrfoM=;
        b=XvWF8vgDIF7FUwAUaPDypzsMlotRseedwNsBPRney81jrlLaxrTlRhGBcuVKmVoDBU
         vxsAnwY+SxjbdQui1QmEdy42cMBAdyGmRhwtImt+VS8Q8JonrlBuV+ATqyUeWgQ38F2Z
         z1aRicHPk0AaiqPLmCVpuzeqhgDbcQEdjTTog6KE/2xqSPPpxxxETyswJiR9n4O0gSqH
         2G5TTnr/ioGOowTni93y5b2sME9iPetWdynCd8POEBICwxWG1etU6YwGt7/iwJIyjD5z
         GJA01WFpzjys0JG1lNnjoNOqUu9lBiAnil8dE28835ZcQikputDihzRJInfTWaR6qP1r
         2QCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUo0Tgtpg6tMyeBMWXKzCwIPwvA9cirOjNkG0LxeiY7hGAir949DslK5w9zS3ONEzNAvVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmZIyXLNeYp2nI1GH2TRjj4Ne3ktjMW1l1iVyXeXkn6Vz5ggbG
	VARX2g6fSygan8OM7BQuKDwLxmj9f2U8Cfi7/HwQjiIdzyzoh2adxuMnUvuTwZYgctkFUCXAG3S
	uqV0RVxhWPFlyq0R/CqaN7ou58PRq/UrBwmT4kzAAXZcOo/RYB0t3UQ==
X-Gm-Gg: ASbGncuEGwm4CVlv8zFudiYauKt6qDk4oopfRzP1SwsHX5pB+zTUHlYuW9KejWW8dka
	JAUVanLf/XvKTrQAsTbEXf77CfS/EeZsTTqiUP4K+c3o8rPJA6TSG4iFlH/11MWy7NFnd8diVfz
	7m46bjtp4gn6Eu8FHSwTwERvdU/E0QsokoCr/EYTXBiqCYuTR/meJxTvz2PAL5q45uncWiV7cL5
	JD44firsV747bFsoz18Z4/9wH3MF3FxDICVZgfFRXrK//fmjbjSbE2J4xH72Vhs9usWHc3X38Cb
	sZVwwToc8ShqxqHu3zat5AvGr5ujezf/amyyW5z/4GhNKZ0OFds3/5QXZ75dwA==
X-Received: by 2002:a17:902:d492:b0:235:e1d6:f98b with SMTP id d9443c01a7336-23c6e4cb8e1mr11443515ad.22.1751416680313;
        Tue, 01 Jul 2025 17:38:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqWBNzwz1Gn5kKZy3/ksoxnqnCJZovaS6hZ3L4CKjG7zeKKGuGfbdtfsVSp+uEXrd9qX5fDw==
X-Received: by 2002:a17:902:d492:b0:235:e1d6:f98b with SMTP id d9443c01a7336-23c6e4cb8e1mr11443065ad.22.1751416679768;
        Tue, 01 Jul 2025 17:37:59 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39b8ddsm120646625ad.140.2025.07.01.17.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 17:37:59 -0700 (PDT)
Message-ID: <60bb33b4-133e-4ebd-950c-e9e2ba8fc38b@redhat.com>
Date: Wed, 2 Jul 2025 10:37:50 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/43] arm64: RME: Allow VMM to set RIPAS
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-16-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 
> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
> unmapped from the guest and undelegated allowing the memory to be reused
> by the host. When transitioning to RIPAS RAM the actual population of
> the leaf RTTs is done later on stage 2 fault, however it may be
> necessary to allocate additional RTTs to allow the RMM track the RIPAS
> for the requested range.
> 
> When freeing a block mapping it is necessary to temporarily unfold the
> RTT which requires delegating an extra page to the RMM, this page can
> then be recovered once the contents of the block mapping have been
> freed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v8:
>   * Propagate the 'may_block' flag to allow conditional calls to
>     cond_resched_rwlock_write().
>   * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>     kvm_account_pgtable_pages() and use when allocating RTTs.
>   * Code reorganisation to allow init_ipa_state and set_ipa_state to
>     share a common ripas_change() function,
>   * Other minor changes following review.
> Changes from v7:
>   * Replace use of "only_shared" with the upstream "attr_filter" field
>     of struct kvm_gfn_range.
>   * Clean up the logic in alloc_delegated_granule() for when to call
>     kvm_account_pgtable_pages().
>   * Rename realm_destroy_protected_granule() to
>     realm_destroy_private_granule() to match the naming elsewhere. Also
>     fix the return codes in the function to be descriptive.
>   * Several other minor changes to names/return codes.
> Changes from v6:
>   * Split the code dealing with the guest triggering a RIPAS change into
>     a separate patch, so this patch is purely for the VMM setting up the
>     RIPAS before the guest first runs.
>   * Drop the useless flags argument from alloc_delegated_granule().
>   * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>   * Deal with the RMM granule size potentially being smaller than the
>     host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>     still allocates an entire host page for every RMM granule (so wasting
>     memory when PAGE_SIZE>4k).
> Changes from v5:
>   * Adapt to rebasing.
>   * Introduce find_map_level()
>   * Rename some functions to be clearer.
>   * Drop the "spare page" functionality.
> Changes from v2:
>   * {alloc,free}_delegated_page() moved from previous patch to this one.
>   * alloc_delegated_page() now takes a gfp_t flags parameter.
>   * Fix the reference counting of guestmem pages to avoid leaking memory.
>   * Several misc code improvements and extra comments.
> ---
>   arch/arm64/include/asm/kvm_rme.h |   6 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 447 +++++++++++++++++++++++++++++++
>   3 files changed, 458 insertions(+), 3 deletions(-)
> 

With below nitpicks addressed. The changes looks good to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 9bcad6ec5dbb..8e21a10db5f2 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -101,6 +101,12 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   unsigned long size,
> +			   bool unmap_private,
> +			   bool may_block);
> +
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
>   {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f85164b322ae..37403eaa5699 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -323,6 +323,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * @start: The intermediate physical base address of the range to unmap
>    * @size:  The size of the area to unmap
>    * @may_block: Whether or not we are permitted to block
> + * @only_shared: If true then protected mappings should not be unmapped
>    *
>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
> @@ -330,7 +331,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>    * with things behind our backs.
>    */
>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
> -				 bool may_block)
> +				 bool may_block, bool only_shared)
>   {
>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>   	phys_addr_t end = start + size;
> @@ -344,7 +345,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>   void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>   			    u64 size, bool may_block)
>   {
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	__unmap_stage2_range(mmu, start, size, may_block, false);
>   }
>   
>   void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> @@ -1989,7 +1990,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     !(range->attr_filter & KVM_FILTER_PRIVATE));
>   
>   	kvm_nested_s2_unmap(kvm, range->may_block);
>   	return false;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 25705da6f153..fe75c41d6ac3 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -91,6 +91,60 @@ static int get_start_level(struct realm *realm)
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>   }
>   
> +static int find_map_level(struct realm *realm,
> +			  unsigned long start,
> +			  unsigned long end)
> +{
> +	int level = RMM_RTT_MAX_LEVEL;
> +
> +	while (level > get_start_level(realm)) {
> +		unsigned long map_size = rme_rtt_level_mapsize(level - 1);
> +
> +		if (!IS_ALIGNED(start, map_size) ||
> +		    (start + map_size) > end)
> +			break;
> +
> +		level--;
> +	}
> +
> +	return level;
> +}
> +
> +static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys;
> +	void *virt;
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(GFP_ATOMIC | __GFP_ZERO |
> +					       __GFP_ACCOUNT);

{} is needed here.

> +
> +	if (!virt)
> +		return PHYS_ADDR_MAX;
> +
> +	phys = virt_to_phys(virt);
> +

The empty line can be dropped.

> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +

This empty line can be dropped either.

> +		return PHYS_ADDR_MAX;
> +	}
> +
> +	return phys;
> +}
> +
> +static phys_addr_t alloc_rtt(struct kvm_mmu_memory_cache *mc)
> +{
> +	phys_addr_t phys = alloc_delegated_granule(mc);
> +
> +	if (phys != PHYS_ADDR_MAX)
> +		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
> +
> +	return phys;
> +}
> +
>   static int free_delegated_granule(phys_addr_t phys)
>   {
>   	if (WARN_ON(rmi_granule_undelegate(phys))) {
> @@ -111,6 +165,32 @@ static void free_rtt(phys_addr_t phys)
>   	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>   }
>   
> +static int realm_rtt_create(struct realm *realm,
> +			    unsigned long addr,
> +			    int level,
> +			    phys_addr_t phys)
> +{
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	return rmi_rtt_create(virt_to_phys(realm->rd), phys, addr, level);
> +}
> +
> +static int realm_rtt_fold(struct realm *realm,
> +			  unsigned long addr,
> +			  int level,
> +			  phys_addr_t *rtt_granule)
> +{
> +	unsigned long out_rtt;
> +	int ret;
> +
> +	addr = ALIGN_DOWN(addr, rme_rtt_level_mapsize(level - 1));
> +	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
> +		*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +

Strictly speaking, 'rtt_granule' can be updated unconditionally here because its
caller has to check the return value and free 'rtt_granule' on RMI_SUCCESS.

>   static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   			     int level, phys_addr_t *rtt_granule,
>   			     unsigned long *next_addr)
> @@ -126,6 +206,40 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>   	return ret;
>   }
>   
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (level == max_level)
> +		return 0;
> +

This check seems unnecessary since it has been covered by 'while (level++ < max_level)'.
So it can be dropped.

> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_rtt(mc);
> +		int ret;
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		ret = realm_rtt_create(realm, ipa, level, rtt);
> +

This empty line can be dropped.

> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
> +		    RMI_RETURN_INDEX(ret) == level - 1) {
> +			/* The RTT already exists, continue */
> +			continue;
> +		}

Empty line is needed in between.

> +		if (ret) {
> +			WARN(1, "Failed to create RTT at level %d: %d\n",
> +			     level, ret);
> +			free_rtt(rtt);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>   				     unsigned long start, unsigned long end)
>   {
> @@ -216,6 +330,61 @@ static int realm_tear_down_rtt_range(struct realm *realm,
>   					 start, end);
>   }
>   
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive value if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded = 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return -EINVAL;
> +
> +	map_size = rme_rtt_level_mapsize(level - 1);
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		phys_addr_t rtt_granule;
> +		int ret;
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		ret = realm_rtt_fold(realm, align_addr, level, &rtt_granule);
> +
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (level == RMM_RTT_MAX_LEVEL ||
> +			    RMI_RETURN_INDEX(ret) < level) {
> +				not_folded++;
> +				break;
> +			}
> +			/* Recurse a level deeper */
> +			ret = realm_fold_rtt_level(realm,
> +						   level + 1,
> +						   addr,
> +						   next_addr);
> +			if (ret < 0)
> +				return ret;
> +			else if (ret == 0)
> +				/* Try again at this level */
> +				next_addr = addr;
> +			break;

			if (ret < 0) {
			} else if {ret == 0) {

			}

> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return not_folded;
> +}
> +
>   void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -223,6 +392,138 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static int realm_destroy_private_granule(struct realm *realm,
> +					 unsigned long ipa,
> +					 unsigned long *next_addr,
> +					 phys_addr_t *out_rtt)
> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long rtt_addr;
> +	phys_addr_t rtt;
> +	int ret;
> +
> +retry:
> +	ret = rmi_data_destroy(rd, ipa, &rtt_addr, next_addr);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		if (*next_addr > ipa)
> +			return 0; /* UNASSIGNED */
> +		rtt = alloc_rtt(NULL);
> +		if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +			return -ENOMEM;
> +		/*
> +		 * ASSIGNED - ipa is mapped as a block, so split. The index
> +		 * from the return code should be 2 otherwise it appears
> +		 * there's a huge page bigger than KVM currently supports
> +		 */
> +		WARN_ON(RMI_RETURN_INDEX(ret) != 2);
> +		ret = realm_rtt_create(realm, ipa, 3, rtt);
> +		if (WARN_ON(ret)) {
> +			free_rtt(rtt);
> +			return -ENXIO;
> +		}
> +		goto retry;
> +	} else if (WARN_ON(ret)) {
> +		return -ENXIO;
> +	}
> +
> +	ret = rmi_granule_undelegate(rtt_addr);
> +	if (WARN_ON(ret))
> +		return -ENXIO;
> +
> +	*out_rtt = rtt_addr;
> +
> +	return 0;
> +}
> +
> +static int realm_unmap_private_page(struct realm *realm,
> +				    unsigned long ipa,
> +				    unsigned long *next_addr)
> +{
> +	unsigned long end = ALIGN(ipa + 1, PAGE_SIZE);
> +	unsigned long addr;
> +	phys_addr_t out_rtt = PHYS_ADDR_MAX;
> +	int ret;
> +
> +	for (addr = ipa; addr < end; addr = *next_addr) {
> +		ret = realm_destroy_private_granule(realm, addr, next_addr,
> +						    &out_rtt);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (out_rtt != PHYS_ADDR_MAX) {
> +		out_rtt = ALIGN_DOWN(out_rtt, PAGE_SIZE);
> +		free_page((unsigned long)phys_to_virt(out_rtt));
> +	}
> +
> +	return 0;
> +}
> +
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool may_block)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	ssize_t map_size = rme_rtt_level_mapsize(level);
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
> +
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return;
> +
> +	start |= shared_bit;
> +	end |= shared_bit;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		unsigned long align_addr = ALIGN(addr, map_size);
> +		int ret;
> +
> +		next_addr = ALIGN(addr + 1, map_size);
> +
> +		if (align_addr != addr || next_addr > end) {
> +			/* Need to recurse deeper */
> +			if (addr < align_addr)
> +				next_addr = align_addr;
> +			realm_unmap_shared_range(kvm, level + 1, addr,
> +						 min(next_addr, end),
> +						 may_block);
> +			continue;
> +		}
> +
> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr == addr) {
> +				/*
> +				 * There's a mapping here, but it's not a block
> +				 * mapping, so reset next_addr to the next block
> +				 * boundary and recurse to clear out the pages
> +				 * one level deeper.
> +				 */
> +				next_addr = ALIGN(addr + 1, map_size);
> +				realm_unmap_shared_range(kvm, level + 1, addr,
> +							 next_addr,
> +							 may_block);
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return;
> +		}
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
>   /* Calculate the number of s2 root rtts needed */
>   static int realm_num_root_rtts(struct realm *realm)
>   {
> @@ -318,6 +619,140 @@ static int realm_create_rd(struct kvm *kvm)
>   	return r;
>   }
>   
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	unsigned long next_addr, addr;
> +	int ret;
> +
> +	for (addr = start; addr < end; addr = next_addr) {
> +		ret = realm_unmap_private_page(realm, addr, &next_addr);
> +
> +		if (ret)
> +			break;
> +
> +		if (may_block)
> +			cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
> +			   unsigned long size, bool unmap_private,
> +			   bool may_block)
> +{
> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	if (!kvm_realm_is_created(kvm))
> +		return;
> +
> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
> +				 start, end, may_block);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end, may_block);
> +}
> +
> +enum ripas_action {
> +	RIPAS_INIT,
> +	RIPAS_SET,
> +};
> +
> +static int ripas_change(struct kvm *kvm,
> +			struct kvm_vcpu *vcpu,
> +			unsigned long ipa,
> +			unsigned long end,
> +			enum ripas_action action,
> +			unsigned long *top_ipa)
> +{

The 'enum ripas_action' is used in limited scope, I would replace it with a 'bool'
parameter to ripas_change(), something like below. If we plan to support more actions
in future, then the 'enum ripas_action' makes sense to me.

static int ripas_change(struct kvm *kvm,
			struct kvm_vcpu *vcpu,
			unsigned long ipa,
			unsigned long end,
			bool set_ripas,
			unsigned long *top_ipa)

> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys;
> +	struct kvm_mmu_memory_cache *memcache = NULL;
> +	int ret = 0;
> +
> +	if (vcpu) {
> +		rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
> +		memcache = &vcpu->arch.mmu_page_cache;
> +
> +		WARN_ON(action != RIPAS_SET);
> +	} else {
> +		WARN_ON(action != RIPAS_INIT);
> +	}
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		switch (action) {
> +		case RIPAS_INIT:
> +			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +			break;
> +		case RIPAS_SET:
> +			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
> +						&next);
> +			break;
> +		}
> +

if 'enum ripas_action' is replaced by 'bool set_ripas' as above, this needs
twist either.

> +		switch (RMI_RETURN_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			ipa = next;
> +			break;
> +		case RMI_ERROR_RTT:
> +			int err_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			if (err_level >= level)
> +				return -EINVAL;
> +
> +			ret = realm_create_rtt_levels(realm, ipa, err_level,
> +						      level, memcache);
> +			if (ret)
> +				return ret;
> +			/* Retry with the RTT levels in place */
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	if (top_ipa)
> +		*top_ipa = ipa;
> +
> +	return 0;
> +}
> +
> +static int realm_init_ipa_state(struct kvm *kvm,
> +				unsigned long ipa,
> +				unsigned long end)
> +{
> +	return ripas_change(kvm, NULL, ipa, end, RIPAS_INIT, NULL);
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct arm_rme_init_ripas *args)
> +{
> +	gpa_t addr, end;
> +
> +	addr = args->base;
> +	end = addr + args->size;
> +
> +	if (end < addr)
> +		return -EINVAL;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EPERM;
> +
> +	return realm_init_ipa_state(kvm, addr, end);
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;
> @@ -441,6 +876,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   	case KVM_CAP_ARM_RME_CREATE_REALM:
>   		r = kvm_create_realm(kvm);
>   		break;
> +	case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
> +		struct arm_rme_init_ripas args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_init_ipa_range_realm(kvm, &args);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;

Thanks,
Gavin


