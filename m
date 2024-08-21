Return-Path: <kvm+bounces-24793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C1695A51D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 21:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1449B1C212D8
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 19:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D75016E860;
	Wed, 21 Aug 2024 19:11:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DC616DEB5
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724267484; cv=none; b=BLNETLRIgT+rKlfqz1efAoZKB/xMuTZuOY5gcxR1beLN4Z9tGKBKwjBfyaG0o8hPeq4O7ZqsneD5lg3NVLAii7UlLYnp5Ft5RE3HLD1p0FtDR/oGY8Zpso6hc62VtCRcw+/ydAmJm20NJv2kyrdb8KPz/x9N+iG1ZoIDMhQlXc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724267484; c=relaxed/simple;
	bh=j3gdv4g7J8okfzQiw1uFjdKzl/lU4fCBgnTCcKpluVI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RGqNGmfMUi3GQn6kopWGjWT5vCVRbQc62s9JWIVyvppHVM2gk8vSnbORmU9v23gfc9CQpzowxFXwyb0vxBbczzofqG6DJIWqze0M8WHdernI7HPe9qJSA+CAvbq0HDpyXROdVkB2kZd4+5SuV/G482gUJSjRP/hpJBmDgJq2VUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WpwrB5B8WzpTZ7;
	Thu, 22 Aug 2024 03:09:46 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 99AF11800A7;
	Thu, 22 Aug 2024 03:11:18 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 22 Aug 2024 03:11:17 +0800
Subject: Re: [PATCH v3 03/16] KVM: arm64: nv: Handle shadow stage 2 page
 faults
To: Marc Zyngier <maz@kernel.org>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
	<alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240614144552.2773592-1-maz@kernel.org>
 <20240614144552.2773592-4-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <9ba30187-6630-02e6-d755-7d1b39118a32@huawei.com>
Date: Thu, 22 Aug 2024 03:11:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240614144552.2773592-4-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/6/14 22:45, Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8984b7c213e1..5aed2e9d380d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1407,6 +1407,7 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  }
>  
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +			  struct kvm_s2_trans *nested,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  bool fault_is_perm)
>  {
> @@ -1415,6 +1416,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	bool exec_fault, mte_allowed;
>  	bool device = false, vfio_allow_any_uc = false;
>  	unsigned long mmu_seq;
> +	phys_addr_t ipa = fault_ipa;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>  	struct vm_area_struct *vma;
> @@ -1498,10 +1500,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	}
>  
>  	vma_pagesize = 1UL << vma_shift;
> +
> +	if (nested) {
> +		unsigned long max_map_size;
> +
> +		max_map_size = force_pte ? PAGE_SIZE : PUD_SIZE;
> +
> +		ipa = kvm_s2_trans_output(nested);
> +
> +		/*
> +		 * If we're about to create a shadow stage 2 entry, then we
> +		 * can only create a block mapping if the guest stage 2 page
> +		 * table uses at least as big a mapping.
> +		 */
> +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +
> +		/*
> +		 * Be careful that if the mapping size falls between
> +		 * two host sizes, take the smallest of the two.
> +		 */
> +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> +			max_map_size = PMD_SIZE;
> +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> +			max_map_size = PAGE_SIZE;
> +
> +		force_pte = (max_map_size == PAGE_SIZE);
> +		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> +	}
> +
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = ipa >> PAGE_SHIFT;

I had seen a non-nested guest boot failure (with vma_pagesize ==
PUD_SIZE) and bisection led me here.

Is it intentional to ignore the fault_ipa adjustment when calculating
gfn if the guest memory is backed by hugetlbfs? This looks broken for
the non-nested case.

But since I haven't looked at user_mem_abort() for a long time, I'm not
sure if I'd missed something...

Thanks,
Zenghui

