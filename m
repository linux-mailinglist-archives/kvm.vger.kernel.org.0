Return-Path: <kvm+bounces-14952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 237B88A80BC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6B7B1F22370
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 10:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6000E13C3DE;
	Wed, 17 Apr 2024 10:19:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB2813B5AE;
	Wed, 17 Apr 2024 10:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713349190; cv=none; b=MiFv6nhtUWOXrdWlg3DEQfhWhTdnEt/Yp3x3Bqey2klnhkwZwexh1y9gA0soG4OTxwqpoD7qs7oSvc/rQlxjvx+GQXDfB93RWSUVkOr55WCNcgzFIsozWw/P2iJQ6cIplHNhcjMLFKgATxr+sAJ+va2JOvl9mm9NnfsJznBaMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713349190; c=relaxed/simple;
	bh=KpH/GhjCXXgVAzGKKcfwNjiWuVqRoJLtjOgyw/WOkf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2rh/e6B0WU+KOxvroelzu+Yg9gSy/iTG/zbC0s2DtvwQ8x7aQwpR3ZEQSag6D24yCN3h9B4izThj+LR/UA8edItmrkDIxtnRYPHVKrRCG30jUIp3YJM9EPeYbpRokSRGRaHS7isXDoTDbrTcBu2bGjBQJbSua/Y3FV0UgJPWI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D734339;
	Wed, 17 Apr 2024 03:20:15 -0700 (PDT)
Received: from [10.1.39.28] (FVFF763DQ05P.cambridge.arm.com [10.1.39.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCD063F64C;
	Wed, 17 Apr 2024 03:19:44 -0700 (PDT)
Message-ID: <b40b263b-3744-41d9-be45-99b38c7f5e6e@arm.com>
Date: Wed, 17 Apr 2024 11:19:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/43] arm64: RME: Keep a spare page delegated to the
 RMM
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-13-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-13-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 12/04/2024 09:42, Steven Price wrote:
> Pages can only be populated/destroyed on the RMM at the 4KB granule,
> this requires creating the full depth of RTTs. However if the pages are
> going to be combined into a 4MB huge page the last RTT is only

minor nit: 2MB huge page.

> temporarily needed. Similarly when freeing memory the huge page must be
> temporarily split requiring temporary usage of the full depth oF RTTs.
> 
> To avoid needing to perform a temporary allocation and delegation of a
> page for this purpose we keep a spare delegated page around. In
> particular this avoids the need for memory allocation while destroying
> the realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 5 +++++
>   arch/arm64/kvm/rme.c             | 8 ++++++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index cf8cc4d30364..fba85e9ce3ae 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -50,6 +50,9 @@ enum realm_state {
>    * @state: The lifetime state machine for the realm
>    * @rd: Kernel mapping of the Realm Descriptor (RD)
>    * @params: Parameters for the RMI_REALM_CREATE command
> + * @spare_page: A physical page that has been delegated to the Realm world but
> + *              is otherwise free. Used to avoid temporary allocation during
> + *              RTT operations.
>    * @num_aux: The number of auxiliary pages required by the RMM
>    * @vmid: VMID to be used by the RMM for the realm
>    * @ia_bits: Number of valid Input Address bits in the IPA
> @@ -60,6 +63,8 @@ struct realm {
>   	void *rd;
>   	struct realm_params *params;
>   
> +	phys_addr_t spare_page;
> +
>   	unsigned long num_aux;
>   	unsigned int vmid;
>   	unsigned int ia_bits;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 658d14e8d87d..9652ec6ab2fd 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -103,6 +103,7 @@ static int realm_create_rd(struct kvm *kvm)
>   	}
>   
>   	realm->rd = rd;
> +	realm->spare_page = PHYS_ADDR_MAX;
>   
>   	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
>   		WARN_ON(rmi_realm_destroy(rd_phys));
> @@ -283,6 +284,13 @@ void kvm_destroy_realm(struct kvm *kvm)
>   
>   	rme_vmid_release(realm->vmid);
>   
> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> +		/* Leak the page if the undelegate fails */
> +		if (!WARN_ON(rmi_granule_undelegate(realm->spare_page)))
> +			free_page((unsigned long)phys_to_virt(realm->spare_page));
> +		realm->spare_page = PHYS_ADDR_MAX;
> +	}
> +
>   	for (i = 0; i < pgt->pgd_pages; i++) {
>   		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
>   

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

