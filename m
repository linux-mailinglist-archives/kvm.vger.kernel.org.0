Return-Path: <kvm+bounces-39946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 215CDA4D05D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 945951886068
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 00:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E964DA04;
	Tue,  4 Mar 2025 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JmLOVapi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797AA3A8C1
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 00:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741049149; cv=none; b=RClG4Wk++HaTD0msstpyaJhzB2+Y3jCcHnxFZc+kticyds08uuuMDYSMDQVrHFUqWDP5pT/hAOPRifGXaz4ExuuE/qCzCVHNhCmSjQbRVd0xGdTfCpv7p9pbxjGzEGy0GhQ4DaMTQOXYwArTAX5SCU7usU7ADXRVVxcy4AI6Es0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741049149; c=relaxed/simple;
	bh=ovmDc4lS5Hmu2UTDDxQyxWMFkjx3qEAq6402LibD8Rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kdUHafvZ0qxFmyxgFcF/sXS15xH1Lvn61gwx6fyH0waBQIh8FX3bHG9witEme+waLBc3ynwJu4d1TuyRemhcNKtQao0VEqrvI/9K2Bfjk1MViRkbIutrqIDS41rYFvMsciyE09BsVspgW1qTfkHgQI3e94C6vyqKORk5WO+iYts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JmLOVapi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741049145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZ1Y9aie10eJ3JT0d1+HW6+xmJHQglbf4yjT189oefM=;
	b=JmLOVapiVZv4VFP0TdSLf1j/j1EYyj+HsFSreq1kaKe5TsHRCH0gSjh8zWnRmI6ZeCmqVx
	l2yJvP+A8jSWLDX9vgdSDbVCkq2ijMFJ6SS4YAIeqc+5LhuGx85qKguuHY9HdyAt2slix8
	DbbA0KXxRBn9/YhGC7FprXJTSvsZQD4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-abz6pxCMPfWCkw2mUJY5Dw-1; Mon, 03 Mar 2025 19:45:43 -0500
X-MC-Unique: abz6pxCMPfWCkw2mUJY5Dw-1
X-Mimecast-MFC-AGG-ID: abz6pxCMPfWCkw2mUJY5Dw_1741049143
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-22387acb40eso74155875ad.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 16:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741049140; x=1741653940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZ1Y9aie10eJ3JT0d1+HW6+xmJHQglbf4yjT189oefM=;
        b=kCKc+MITI8SVtGBcdCyBKY8xVQDPtGRb0+W2dgIIX3MhUplYCAKgHnelWUtBTx96U/
         Nbd0qEh7HdW0/UzEro4V/aLup0Zg1X9slSUPL/0P8gt2rE7hGfjQb6xFkKCSXzp9Ch7P
         y1In58+lEuYqei3atWyUAjXpjQa52Q/xTBGEgKpyERP0kFB5hwLCtshQDVHLN+LW8nbe
         +p3/Wjke8MkPwVnq3YgbOF3nonECVLFYCsxvZ5z+Z8QgaZQLWm0IX20EhuyBrN+6lzRe
         BXOrUofenjYls/OtgdD+Y2MN+INY30afX/pCdYo9AqB8HJpSFq/wZ8rS5/MHBap9o2hn
         /02A==
X-Forwarded-Encrypted: i=1; AJvYcCW0p8zknqKrXxCSp+k25f88tAk6d9s0RbM0757NA9skaMLMuKyBWfRsJVovWN4pIFVu+gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaI/tkCvqcXyLGZypRsdIYqBz251IQs9Fyn92gSjafICTKth0p
	WYfZJ9cplWobBJmKcWosRsX8mBaYELdtsNaloVTz2NOBXX4qzHBCWWNcZVAmfcVNtuPuhAWeBfh
	t6d+HUbEgHJz2k6LVsMGAun76miHL7exXyrH6OFZpFZnLD1DX+A==
X-Gm-Gg: ASbGncvzHG7JpCwPcTOFvcpP8PlxuT9S2E9+tRCO0Hq8lmehUgRBvYFiBaLWFdlJ044
	AN9MSttT6RCxcJQFK3bLkyBm+Ws6QxMJ4RmxeoZXzUNNOQcKvAysU3nLAXQFldWHGasa6BH+Hr1
	iBNT40BLvzAB/RJ6heRyqDNCQ8LWMGuQhtORyRqLyS60cirhCdEyALV8UHFnrK4ftROGakAY/vl
	rgajYZuSHcA8Gggv2HRquD0Og0HnCeQvjuAPSKoev95TQY1d9/EqpjPQaDz/VBXT5C7K1jj9zGg
	H+3bD/DtKghPBy1DKg==
X-Received: by 2002:a05:6a00:194b:b0:736:562b:9a9c with SMTP id d2e1a72fcca58-736562ba117mr8644248b3a.18.1741049140402;
        Mon, 03 Mar 2025 16:45:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6oAfXnG3/QR6tVmZhFEbz+wBa5IpAF44W86W6eYSgP01urAeMOjrEDL0mpgcHbYUspnh2hQ==
X-Received: by 2002:a05:6a00:194b:b0:736:562b:9a9c with SMTP id d2e1a72fcca58-736562ba117mr8644189b3a.18.1741049139878;
        Mon, 03 Mar 2025 16:45:39 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7364e0f713asm3286430b3a.26.2025.03.03.16.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 16:45:38 -0800 (PST)
Message-ID: <329d28ce-3d12-47ed-9d88-fd779a65fe92@redhat.com>
Date: Tue, 4 Mar 2025 10:45:30 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/45] arm64: RME: Allow VMM to set RIPAS
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
 <20250213161426.102987-17-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-17-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
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
>   arch/arm64/include/asm/kvm_rme.h |   5 +
>   arch/arm64/kvm/mmu.c             |   8 +-
>   arch/arm64/kvm/rme.c             | 384 +++++++++++++++++++++++++++++++
>   3 files changed, 394 insertions(+), 3 deletions(-)
> 

It generally looks good to me, but there are some code level improvements
may be needed. Please only take those only sensible to you, Steven. With
those suggestions addressed (not all taken)

> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 2e319db9a05f..0bcde070b446 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -92,6 +92,11 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
>   int kvm_create_rec(struct kvm_vcpu *vcpu);
>   void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>   
> +void kvm_realm_unmap_range(struct kvm *kvm,
> +			   unsigned long ipa,
> +			   u64 size,
> +			   bool unmap_private);
> +

The type of @ipa has been changed from phys_addr_t to unsigned long. It's
fine to have 'unsigned long size', to keep both of them consistent.

void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa,
                            unsigned long size, bool unmap_private);

>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
>   {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b4506484913d..24eb60063573 100644
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
> @@ -1963,7 +1964,8 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   
>   	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
>   			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +			     range->may_block,
> +			     range->only_shared);
>   
>   	kvm_nested_s2_unmap(kvm, range->may_block);
>   	return false;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 195390a66bc4..dc3fd66dd5bb 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,52 @@ static int get_start_level(struct realm *realm)
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
> +	phys_addr_t phys = PHYS_ADDR_MAX;
> +	void *virt;
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +
> +	kvm_account_pgtable_pages(virt, 1);
> +
> +	if (!virt)
> +		goto out;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		phys = PHYS_ADDR_MAX;
> +	}
> +
> +out:
> +	return phys;
> +}
> +

The function name (alloc_delegated_rtt) since it's only to allocate page
and delegate it for RTT. Besides, kvm_account_pgtable_pages() needs to
executed after the check. Also, the 'out' tag is unnecessary.

static phys_addr_t alloc_delegated_rtt(struct kvm_mmu_memory_cache *mc)
{
	phys_addr_t phys;
	void *virt;

	if (mc)
		virt = kvm_mmu_memory_cache_alloc(mc);
	else
		virt = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);

	if (!virt)
		return PHYS_ADDR_MAX;

	phys = virt_to_phys(virt);
         if (rmi_granule_delegate(phys)) {
		free_page((unsigned long)virt);
		return PHYS_ADDR_MAX;
	}

	return phys;
}

>   static void free_delegated_granule(phys_addr_t phys)
>   {
>   	if (WARN_ON(rmi_granule_undelegate(phys))) {
> @@ -99,6 +145,154 @@ static void free_delegated_granule(phys_addr_t phys)
>   	free_page((unsigned long)phys_to_virt(phys));
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
> +	ret = rmi_rtt_fold(virt_to_phys(realm->rd), addr, level, &out_rtt);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS && rtt_granule)
> +		*rtt_granule = out_rtt;
> +
> +	return ret;
> +}
> +
> +static int realm_destroy_protected_granule(struct realm *realm,
> +					   unsigned long ipa,
> +					   unsigned long *next_addr,
> +					   phys_addr_t *out_addr)

It may be reasonable to rename it to realm_destroy_private_granule() to match with
its caller realm_unmap_private_page()

> +{
> +	unsigned long rd = virt_to_phys(realm->rd);
> +	unsigned long addr;
> +	phys_addr_t rtt;
> +	int ret;
> +

The variable name 'addr' confuses me a bit. Maybe we can rename it to 'rtt_addr'.
Similarly, 'out_addr' can be renamed to 'out_rtt'.

> +loop:

retry:

> +	ret = rmi_data_destroy(rd, ipa, &addr, next_addr);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		if (*next_addr > ipa)
> +			return 0; /* UNASSIGNED */
> +		rtt = alloc_delegated_granule(NULL);
> +		if (WARN_ON(rtt == PHYS_ADDR_MAX))
> +			return -1;

			return -ENOMEM;

> +		/*
> +		 * ASSIGNED - ipa is mapped as a block, so split. The index
> +		 * from the return code should be 2 otherwise it appears
> +		 * there's a huge page bigger than KVM currently supports
> +		 */
> +		WARN_ON(RMI_RETURN_INDEX(ret) != 2);
> +		ret = realm_rtt_create(realm, ipa, 3, rtt);
> +		if (WARN_ON(ret)) {
> +			free_delegated_granule(rtt);
> +			return -1;

			return -ENXIO;		
> +		}
> +		/* retry */
> +		goto loop;

Drop '/* retry */'

		goto retry;

> +	} else if (WARN_ON(ret)) {
> +		return -1;

		return -ENXIO;
> +	}

A blank link is needed here.

> +	ret = rmi_granule_undelegate(addr);
> +	if (ret)
> +		return ret;
> +
> +	*out_addr = addr;
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
> +	phys_addr_t unmap_addr = PHYS_ADDR_MAX;
> +	int ret;
> +

s/unmap_addr/out_rtt

> +	for (addr = ipa; addr < end; addr = *next_addr) {
> +		ret = realm_destroy_protected_granule(realm, addr, next_addr,
> +						      &unmap_addr);
> +		if (WARN_ON(ret))
> +			return ret;

The WARN_ON() can be dropped since all errors has been guarded by WARN_ON()
in realm_destroy_protected_granule().

> +	}
> +
> +	if (unmap_addr != PHYS_ADDR_MAX)
> +		put_page(phys_to_page(unmap_addr));

s/put_page/free_page ?

> +
> +	return 0;
> +}
> +
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     int level,
> +				     unsigned long start,
> +				     unsigned long end)
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
> +						 min(next_addr, end));
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
> +							 next_addr);
> +			}
> +			break;
> +		default:
> +			WARN_ON(1);
> +			return;
> +		}
> +
> +		cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +}
> +
>   /* Calculate the number of s2 root rtts needed */
>   static int realm_num_root_rtts(struct realm *realm)
>   {
> @@ -209,6 +403,37 @@ static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
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
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_granule(mc);
> +		int ret;
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		ret = realm_rtt_create(realm, ipa, level, rtt);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT &&
> +		    RMI_RETURN_INDEX(ret) == level) {
> +			/* The RTT already exists, continue */
> +			continue;
> +		} else if (ret) {
> +			free_delegated_granule(rtt);
> +			return -ENXIO;
> +		}

nit: the nested if statement is unnecessary.

		if (ret) {
			free_delegated_granule(rtt);
			return -ENXIO;
		}

> +	}
> +
> +	return 0;
> +}
> +
>   static int realm_tear_down_rtt_level(struct realm *realm, int level,
>   				     unsigned long start, unsigned long end)
>   {
> @@ -299,6 +524,61 @@ static int realm_tear_down_rtt_range(struct realm *realm,
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
> +			free_delegated_granule(rtt_granule);
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
> @@ -306,6 +586,98 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end)
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
> +		cond_resched_rwlock_write(&kvm->mmu_lock);
> +	}
> +
> +	realm_fold_rtt_level(realm, get_start_level(realm) + 1,
> +			     start, end);
> +}
> +
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start, u64 size,
> +			   bool unmap_private)
> +{
> +	unsigned long end = start + size;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	end = min(BIT(realm->ia_bits - 1), end);
> +
> +	if (realm->state == REALM_STATE_NONE)
> +		return;
> +
> +	realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
> +				 start, end);
> +	if (unmap_private)
> +		realm_unmap_private_range(kvm, start, end);
> +}
> +
> +static int realm_init_ipa_state(struct realm *realm,
> +				unsigned long ipa,
> +				unsigned long end)
> +{
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (ipa < end) {
> +		unsigned long next;
> +
> +		ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int err_level = RMI_RETURN_INDEX(ret);
> +			int level = find_map_level(realm, ipa, end);
> +
> +			if (WARN_ON(err_level >= level))
> +				return -ENXIO;
> +
> +			ret = realm_create_rtt_levels(realm, ipa,
> +						      err_level,
> +						      level, NULL);
> +			if (ret)
> +				return ret;
> +			/* Retry with the RTT levels in place */
> +			continue;
> +		} else if (WARN_ON(ret)) {
> +			return -ENXIO;
> +		}
> +
> +		ipa = next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct arm_rme_init_ripas *args)
> +{
> +	gpa_t addr, end;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	addr = args->base;
> +	end = addr + args->size;
> +
> +	if (end < addr)
> +		return -EINVAL;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;

		return -EPERM;
> +
> +	return realm_init_ipa_state(realm, addr, end);
> +}
> +
>   /* Protects access to rme_vmid_bitmap */
>   static DEFINE_SPINLOCK(rme_vmid_lock);
>   static unsigned long *rme_vmid_bitmap;
> @@ -431,6 +803,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
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


