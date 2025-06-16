Return-Path: <kvm+bounces-49593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22673ADAD94
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 962103A39C7
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA0329C321;
	Mon, 16 Jun 2025 10:41:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFD7295D8F;
	Mon, 16 Jun 2025 10:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750070496; cv=none; b=exe5ot2DWHUuiyIJyGiaZMgsBcmESvpTh3O9RuIIhGlcrqK03WIJKJSgJnDpFbl/oGqx4TtX7LA3pqw4XZkjn82TOT0SNvJthbd617guuVfz7bNfbIHRN2mBkXR92sxMWgLvKWmiDq9/qFduP36aE8SgBrcvPLPTepqVW+PWpR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750070496; c=relaxed/simple;
	bh=Lw2dE+P+MII1mRCnkvkm+zkgPFhWavrLZBJGcO21axg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTCojAZ29koW7fTNp9q0J4Y4QMjoH0jfH4J6QR6VOpNbfsY1I99XYyeDQkGuLCMOLq6vBUyPSibVuXpgDyimmQCxEwNm56WJHwz6g11XJ0AG9wXTsNTfqPyZQlcl8UsqghELzn+HWuI7o4qBpvygzO8YSDOW1i8MzMZQuzi4grE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27592150C;
	Mon, 16 Jun 2025 03:41:12 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31E963F58B;
	Mon, 16 Jun 2025 03:41:31 -0700 (PDT)
Message-ID: <b39ce0e3-5d44-4334-b739-2af07a24a668@arm.com>
Date: Mon, 16 Jun 2025 11:41:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/43] arm64: RME: RTT tear down
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-11-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250611104844.245235-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 11/06/2025 11:48, Steven Price wrote:
> The RMM owns the stage 2 page tables for a realm, and KVM must request
> that the RMM creates/destroys entries as necessary. The physical pages
> to store the page tables are delegated to the realm as required, and can
> be undelegated when no longer used.
> 
> Creating new RTTs is the easy part, tearing down is a little more
> tricky. The result of realm_rtt_destroy() can be used to effectively
> walk the tree and destroy the entries (undelegating pages that were
> given to the realm).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>

A couple of minor nits below. Should have spotted earlier, apologies.
...

> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 73261b39f556..0f89295fa59c 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -17,6 +17,22 @@ static unsigned long rmm_feat_reg0;
>   #define RMM_PAGE_SHIFT		12
>   #define RMM_PAGE_SIZE		BIT(RMM_PAGE_SHIFT)
>   
> +#define RMM_RTT_BLOCK_LEVEL	2
> +#define RMM_RTT_MAX_LEVEL	3
> +
> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
> +#define RMM_RTT_LEVEL_SHIFT(l)	\
> +	((RMM_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> +#define RMM_L2_BLOCK_SIZE	BIT(RMM_RTT_LEVEL_SHIFT(2))
> +
> +static inline unsigned long rme_rtt_level_mapsize(int level)
> +{
> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
> +		return RMM_PAGE_SIZE;
> +
> +	return (1UL << RMM_RTT_LEVEL_SHIFT(level));
> +}
> +
>   static bool rme_has_feature(unsigned long feature)
>   {
>   	return !!u64_get_bits(rmm_feat_reg0, feature);
> @@ -82,6 +98,126 @@ static int free_delegated_granule(phys_addr_t phys)
>   	return 0;
>   }
>   
> +static void free_rtt(phys_addr_t phys)
> +{
> +	if (free_delegated_granule(phys))
> +		return;
> +
> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
> +}
> +
> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
> +			     int level, phys_addr_t *rtt_granule,
> +			     unsigned long *next_addr)
> +{
> +	unsigned long out_rtt;
> +	int ret;
> +
> +	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
> +			      &out_rtt, next_addr);
> +
> +	*rtt_granule = out_rtt;
> +
> +	return ret;

ultra minor nit: this could simply be :

	return rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level, 
rtt_granule, next_addr);


...

> +
> +static int realm_tear_down_rtt_range(struct realm *realm,
> +				     unsigned long start, unsigned long end)
> +{

minor nit: Is it worth adding a comment here, why we start from 
start_level + 1 and downwards ? Something like:

	/*
	 * Root level RTTs can only be destroyed after the RD is
	 * destroyed. So tear down everything below the root level.
	 */

Similarly, we may be able to clarify a comment in kvm_free_stage2_pgd()

Suzuki


