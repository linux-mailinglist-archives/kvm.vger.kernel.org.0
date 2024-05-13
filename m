Return-Path: <kvm+bounces-17320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C41DA8C42C8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EDD5287B02
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7722153598;
	Mon, 13 May 2024 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WW854H3A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC91850279;
	Mon, 13 May 2024 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715608999; cv=none; b=eHxeRtF7hl5BgpQCt6sCGnFaEYlFzYV90X0tXCMc5so9436K2R2ISis4+TJuxFlMKdMznGWwd5uYKBMNN5brD8KZoxInlyfSZA+ijAwQ3g4IKCQcu45jW264C6oPfNkgoJ9XnrNpJ4QKA3fH+JhgXfe9H0CPW0iP1ow1e3ywxu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715608999; c=relaxed/simple;
	bh=xJFzAh3ysLEFv0WcBOW0PLVx4z6smc3rpdHEbvwQUtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m6O6ivzb7KQyGzQIUxuuEUHGrceeS9LzfLHx5Bkrq7Wsd11flmZKbPNhvSX0WNPvnm9yg2L7StKK3EK/FHmosnBtbbakXZrOaJ2lR3wgQP2qXjr63KlCPbNd+CxF20H59t8hMz7pWOkGRJgJb3Xpry/0RcOg3QgvP8loTxMxXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WW854H3A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176F4C113CC;
	Mon, 13 May 2024 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715608998;
	bh=xJFzAh3ysLEFv0WcBOW0PLVx4z6smc3rpdHEbvwQUtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WW854H3AORnWWjRhWN/bANcICXpLI+R9Oc4n+nvHPBPfpoqb/HuxeI3rbDhsVO4th
	 FOtxizkjI1Tqxuulo17DqJHn555n2sqxON/N/69b3h5czPLszdpI+h51ucoWI3RdYO
	 zvIJVKwr3hAruztAL5yBaWdl7r/r15eHx01+O4BKHyR5erugF7ckrSgVebLNajcAJY
	 g1GBZ1SZdmo8zkbAgcaJuyUV59DiG7WHXG6MeBwlzO8uq8qZPLoSoNL/ZU0PyF0QD9
	 flAgmWfeBsO2IL9pBWiArSP8t/US3HWqCMbyMI/agcja5EIJ50SqHKaAAyvvG/uZm6
	 Js4Q9TXNgH5aA==
Date: Mon, 13 May 2024 15:03:13 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: Fix __pkvm_init_switch_pgd C
 signature
Message-ID: <20240513140313.GB28749@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-3-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-3-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:31PM +0100, Pierre-Clément Tosi wrote:
> Update the function declaration to match the asm implementation.
> 
> Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL2")
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h | 3 +--
>  arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 3e2a1ac0c9bb..96daf7cf6802 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
>  #endif
>  
>  #ifdef __KVM_NVHE_HYPERVISOR__
> -void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
> -			    phys_addr_t pgd, void *sp, void *cont_fn);
> +void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
>  int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  		unsigned long *per_cpu_base, u32 hyp_va_bits);
>  void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index bc58d1b515af..bcaeb0fafd2d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
>  {
>  	struct kvm_nvhe_init_params *params;
>  	void *virt = hyp_phys_to_virt(phys);
> -	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
> +	typeof(__pkvm_init_switch_pgd) *fn;
>  	int ret;
>  
>  	BUG_ON(kvm_check_pvm_sysreg_table());
> -- 
> 2.45.0.118.g7fe29c98d7-goog

Acked-by: Will Deacon <will@kernel.org>

Will

