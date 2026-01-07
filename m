Return-Path: <kvm+bounces-67234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB69FCFEC53
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3E676316F80D
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D50F38FF1D;
	Wed,  7 Jan 2026 15:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="OH2ZZn+R"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C29438FEF8
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800967; cv=none; b=W/7DAcmcXtZo/ebqA3dxPDOx31Ka7s0BBdF8Gh83c4K02v7Lg3yGVda5xcw/DMAuSgk/8C8jczItkR2F5Tj4Il5xGFK5v86mHrNMd1toyJUNOEEbLznuMb5bSseFrqokyzRddlUxcByMppc9sg5Ns9z80x7B+QKFRpgDM8RAGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800967; c=relaxed/simple;
	bh=bdNjwxySHp/c9HGqMY0SpfRUCUoWy2WGTB5R1j7a+Og=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PllKtvDqz2lBqxEhSBNZE1EqbULAaP1vcCmwjZpPDYKrBvGwbRjmCVWBaK0R+zRZd93S1Z3Rrd4DdcaBIEd2nxLBhgUV5+kP5d8e5HkyxEPgnjmj/E7k/PbcE1Ah3AJl1HAoivxggW2JgG3xSiSMB2MAPiez4ae6a1/eAQmfBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=OH2ZZn+R; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uVBgNpVLtCmWFVMgzmmCZBw+Qm+BhTFnL/XjmyuzdCQ=;
	b=OH2ZZn+Ryu6QHhOwXn9byvA2m5lhzFW/ObX9HqrP6vZnIoyxCeWYo+Bw/tqlAkI3ukK26iJPU
	tuI8mpQWva20GSEyMg1morLq0uD0HOsJ00d8Xt2nWsOtfjKJUcZ6B1/eUjoASFjmoHFQ/vi5WlN
	Rf0Q/P94EyPUqYeZxfMj0AY=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmXTn46FQz1vnMb;
	Wed,  7 Jan 2026 23:47:09 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmXX625m1zHnGgq;
	Wed,  7 Jan 2026 23:49:10 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id ACE4540570;
	Wed,  7 Jan 2026 23:49:16 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:49:15 +0000
Date: Wed, 7 Jan 2026 15:49:13 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Message-ID: <20260107154913.00005193@huawei.com>
In-Reply-To: <20251219155222.1383109-25-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-25-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:44 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Update kvm_vgic_create to create a vgic_v5 device. When creating a
> vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
> guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
> exposed for a vgic_v5 guest.
> 
> When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
> support one. The current vgic_v5 implementation only supports PPIs, so
> no SPIs are initialised either.
> 
> The current vgic_v5 support doesn't extend to nested

Odd early wrapping of message.

> guests. Therefore, the init of vgic_v5 for a nested guest is failed in
> vgic_v5_init.
> 
> As the current vgic_v5 doesn't require any resources to be mapped,
> vgic_v5_map_resources is simply used to check that the vgic has indeed
> been initialised. Again, this will change as more GICv5 support is
> merged in.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Comments mostly on existing code, so
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 51 ++++++++++++++++++++++-----------
>  arch/arm64/kvm/vgic/vgic-v5.c   | 26 +++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h      |  2 ++
>  include/kvm/arm_vgic.h          |  1 +
>  4 files changed, 63 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 03f45816464b0..afb5888cd8219 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c

>  	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> @@ -420,20 +427,26 @@ int vgic_init(struct kvm *kvm)
>  	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
>  		return -EBUSY;
>  
> -	/* freeze the number of spis */
> -	if (!dist->nr_spis)
> -		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
> +	if (!vgic_is_v5(kvm)) {
> +		/* freeze the number of spis */
> +		if (!dist->nr_spis)
> +			dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
>  
> -	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
> -	if (ret)
> -		goto out;
> +		ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
> +		if (ret)
> +			goto out;

Not really related to this patch, but I have no idea why this function
doesn't just do early returns on error in all paths (rather than just some of them).
It might be worth changing that to improve readability.


>  
> -	/*
> -	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
> -	 * vLPIs) is supported.
> -	 */
> -	if (vgic_supports_direct_irqs(kvm)) {
> -		ret = vgic_v4_init(kvm);
> +		/*
> +		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
> +		 * vLPIs) is supported.
> +		 */
> +		if (vgic_supports_direct_irqs(kvm)) {
> +			ret = vgic_v4_init(kvm);
> +			if (ret)
> +				goto out;
> +		}
> +	} else {
> +		ret = vgic_v5_init(kvm);
>  		if (ret)
>  			goto out;
>  	}
> @@ -610,9 +623,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
>  		ret = vgic_v2_map_resources(kvm);
>  		type = VGIC_V2;
> -	} else {
> +	} else if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>  		ret = vgic_v3_map_resources(kvm);
>  		type = VGIC_V3;
> +	} else {
> +		ret = vgic_v5_map_resources(kvm);
> +		type = VGIC_V5;
> +		goto out;
This skips over the checking of ret which is fine (given it's just goto out)
but I'd add a comment to say why the next bit is skipped or a more complex
flow (maybe a flag to say dist is relevant that gates the next bit.

>  	}
>  
>  	if (ret)



