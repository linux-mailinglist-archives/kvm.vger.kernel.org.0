Return-Path: <kvm+bounces-8341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6084684E1E0
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 14:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92E681C260C9
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 13:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CD979DDB;
	Thu,  8 Feb 2024 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsWgE9UB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3B6F082;
	Thu,  8 Feb 2024 13:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707398390; cv=none; b=AFmz5iCUaxTXKrfak/RGm8lpIgqmozZbeqrdwB1DSQNMFvPGhVybYHA3xJoqCj9sDd5/x40BXdCZxsGSKdmeJhGxphBYyeqdQProhALfXfBljek2RXXjK2HQvyCLmMZsCzJ1sqtSxFX7N3yhqp8f7G1W1UoH8KpvoH1GAsJiOwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707398390; c=relaxed/simple;
	bh=u2aOtaES0XCeOIHcnCnk47OhtVva9gOZNTOt1HqeVlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSSYiR7iltTKODOj5h8ECNBSfORtXh4u36NDO0Fa05iT8VEOR5TTmDZdwORHVtLTn3Zv1BSf7N4ZNmAtK3J3P+RCyq/R+PoFEQZmxNeXgs0gCMoAcQmG6+muOMrZQx0zUKqDWjjcpatzzQGQ0rng6cM+z1JqiIc7hK12MF8tgVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsWgE9UB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0368C433C7;
	Thu,  8 Feb 2024 13:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707398389;
	bh=u2aOtaES0XCeOIHcnCnk47OhtVva9gOZNTOt1HqeVlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EsWgE9UB5Xhr5faBRJSC38oV1eFUo130oUkgiAW4oWOSmD6kCpUW9tDUji+/QWiMa
	 cUHKOVSj2Z/gTeYr7lQgGtg0ORJkhDSt/Av2JGMNVX7WDHwi/kRRucS5M5EhssocfV
	 AiNl63vjdb39XgB08OnnkEUtvSnGUcaC91J+ktoFSeBE53kA4ZqzIvSh6H+BTlyFhW
	 HhOM+ktYTODFr2O0Mbuf7c13L1hYxtGpcoe1leLr0y4Eel5hRRoYN6HMEgzutg9Tqr
	 5o56TKRWnpYiGA7ypamAOHWoE7g4FF+cBzFlk0eqMVwIDYyiljFh9kGsnYeVDMc9NR
	 r8+xhr0Fsy7Cw==
Date: Thu, 8 Feb 2024 13:19:39 +0000
From: Will Deacon <will@kernel.org>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Message-ID: <20240208131938.GB23428@willie-the-truck>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207204652.22954-2-ankita@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 08, 2024 at 02:16:49AM +0530, ankita@nvidia.com wrote:
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c651df904fe3..2a893724ee9b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -717,15 +717,28 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
>  				kvm_pte_t *ptep)
>  {
> -	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> -	kvm_pte_t attr = device ? KVM_S2_MEMATTR(pgt, DEVICE_nGnRE) :
> -			    KVM_S2_MEMATTR(pgt, NORMAL);
> +	kvm_pte_t attr;
>  	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
>  
> +	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
> +			KVM_PGTABLE_PROT_NORMAL_NC)) {
> +	case 0:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL);
> +		break;
> +	case KVM_PGTABLE_PROT_DEVICE:
> +		if (prot & KVM_PGTABLE_PROT_X)
> +			return -EINVAL;
> +		attr = KVM_S2_MEMATTR(pgt, DEVICE_nGnRE);
> +		break;
> +	case KVM_PGTABLE_PROT_NORMAL_NC:
> +		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}

Cosmetic nit, but I'd find this a little easier to read if the normal
case was the default (i.e. drop 'case 0') and we returned an error for
DEVICE | NC.

Will

