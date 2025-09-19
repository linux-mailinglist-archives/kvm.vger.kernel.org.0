Return-Path: <kvm+bounces-58227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B128DB8B793
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 180957B1A67
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB0F275113;
	Fri, 19 Sep 2025 22:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="moW/wAEZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8DE72614
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321110; cv=none; b=F7k2qds0apJBhGVoY/LDUFiBvKDSWG/unxRdq/qRPdpEhnNOLMqBN3nenKm1gwA/ijdwr/d9J+a0RjTXu4bOklpbYT7X0XI3wgKj2WgK2DbuPLoX4ah5kIMN+EEiUSdf93ghEpX+wkXIbgrE7pc7lmslqj5QnP5c9poglsoDMCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321110; c=relaxed/simple;
	bh=b0+SXBdaGt6E2cG1g4ZFwKzgkUPdMCBKOQS9ayB2968=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/WAhTgbMh3w/GnSp00zF1aJOld3dveY/DXj2VYL8kAGD4CGudud6mL+UD8wFT6L47xRz/jei25qjezRczyqi4JyfMUfQsfFUHSxGukuVMt1FliysRAmy/IpAci/c7pkmRZjBUvTq3q+mkPc8N22T3T/eVUpYSPNPw799UQ8W8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=moW/wAEZ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Sep 2025 15:31:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758321105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c10gttiRf4SwrPt9wISmA+SEZzX4oEt3NSpPnwS9bNc=;
	b=moW/wAEZCaFLtjdUpFOMoJ9WaiKHMnl5DCAHKBbwhzFtxozg6YXnTOu4k6uLrU3L5/gUOO
	kSSPQUPJkuEVEEOiB+hgG7TbO/EK2e4hijkZ9a0WEfyh0JdOP/N0gYPDqb4i2hOm7Tb5pG
	PONy+kddjYGuSUmiSTOLClct66G9H4w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 14/16] KVM: arm64: Add S1 IPA to page table level
 walker
Message-ID: <aM3ZzSwdPsrz5wjI@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-15-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:49PM +0100, Marc Zyngier wrote:
> Use the filtering hook infrastructure to implement a new walker
> that, for a given VA and an IPA, returns the level of the first
> occurence of this IPA in the walk from that VA.
> 
> This will be used to improve our SEA syndrome reporting.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |  2 +
>  arch/arm64/kvm/at.c                 | 65 +++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index cce0e4cb54484..2be6c3de74e3d 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -353,6 +353,8 @@ struct s1_walk_result {
>  
>  int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		       struct s1_walk_result *wr, u64 va);
> +int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa,
> +			     int *level);
>  
>  /* VNCR management */
>  int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index c099bab30cb0d..117ce1ff5e767 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1578,3 +1578,68 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  
>  	return 0;
>  }
> +
> +struct desc_match {
> +	u64	ipa;
> +	int	level;
> +};
> +
> +static int match_s1_desc(struct s1_walk_context *ctxt, void *priv)
> +{
> +	struct desc_match *dm = priv;
> +	u64 ipa = dm->ipa;
> +
> +	/* Use S1 granule alignment */
> +	ipa &= GENMASK(52, ctxt->wi->pgshift);
> +

Bit 51 again

> +	/* Not the IPA we're looking for? Continue. */
> +	if (ipa != ctxt->table_ipa)
> +		return 0;
> +
> +	/* Note the level and interrupt the walk */
> +	dm->level = ctxt->level;
> +	return -EINTR;
> +}
> +
> +int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
> +{
> +	struct desc_match dm = {
> +		.ipa	= ipa,
> +	};
> +	struct s1_walk_info wi = {
> +		.filter	= &(struct s1_walk_filter){
> +			.fn	= match_s1_desc,
> +			.priv	= &dm,
> +		},
> +		.regime	= TR_EL10,
> +		.as_el0	= false,
> +		.pan	= false,
> +	};
> +	struct s1_walk_result wr = {};
> +	int ret;
> +
> +	ret = setup_s1_walk(vcpu, &wi, &wr, va);
> +	if (ret)
> +		return ret;
> +
> +	/* We really expect the S1 MMU to be on here... */
> +	if (WARN_ON_ONCE(wr.level == S1_MMU_DISABLED)) {
> +		*level = 0;
> +		return 0;
> +	}
> +
> +	/* Walk the guest's PT, looking for a match along the way */
> +	ret = walk_s1(vcpu, &wi, &wr, va);
> +	switch (ret) {
> +	case -EINTR:
> +		/* We interrupted the walk on a match, return the level */
> +		*level = dm.level;
> +		return 0;
> +	case 0:
> +		/* The walk completed, we failed to find the entry */
> +		return -ENOENT;
> +	default:
> +		/* Any other error... */
> +		return ret;
> +	}
> +}
> -- 
> 2.39.2
> 

