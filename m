Return-Path: <kvm+bounces-67230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EA30ECFEC7A
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 632693000977
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1181C35A95C;
	Wed,  7 Jan 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ITmUrG3a"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DB5348880
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767798529; cv=none; b=a96uDppfSbdT3byqgiH6YWU63xsx3nP1GpvV0uB5I3QdDleDu65QVYhX81pQvMVBGtmgB/yyWw4ZGR8pZPotuI5oQ/MkK4Mn44bEwsxptSriAuaEvax6lNLILbfOQVzR1ennOFPk3LIVqF+cmzD8Zmphejt25Nux2FCQ/s1Lz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767798529; c=relaxed/simple;
	bh=rjjSF2GjLLnuTppckhQgvKZBsEngKusMJE2hNZFdC3c=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gv8Vss3Aw9YQ2z8zr4oVEyOBRV79t/ZSsvR9Ds4QSa1zGdTfj0C3fHNfIvtp4TY1Ng5/cpVR81+UIlrYGbvBppYLKbMRblftZ75/OaEM0ZKxx0GJo/251lAXpbiKzH7lD4gA49gKZBP3ygs7FxWy6KaCI8r/GOeDpNZgBt386iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ITmUrG3a; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2x/3meMA0G6VDYoHbJ4AHA6vDOYL4w15qQ/fKhtmMm4=;
	b=ITmUrG3aql95a+0mkqRCs4CkZs3jBo7KClazcloMblBygqzUg7YtcxiBH74AyvDsXD0trZ634
	LF228aRXerWBfkVnah2wGUfBd62jcd9epzFNMe3tihiQUsEjcJRZzzKYc5cttUJreN8tNXMdeX8
	7vjGmWX9qRilDkCfHfIwvj0=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmWZf0nrKz1P7MM;
	Wed,  7 Jan 2026 23:06:17 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmWdK6J81zJ469G;
	Wed,  7 Jan 2026 23:08:37 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EAF740539;
	Wed,  7 Jan 2026 23:08:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:08:40 +0000
Date: Wed, 7 Jan 2026 15:08:38 +0000
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
Subject: Re: [PATCH v2 21/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Message-ID: <20260107150838.00004e00@huawei.com>
In-Reply-To: <20251219155222.1383109-22-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-22-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:43 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> We only want to expose a subset of the PPIs to a guest. If a PPI does
> not have an owner, it is not being actively driven by a device. The
> SW_PPI is a special case, as it is likely for userspace to wish to
> inject that.
> 
> Therefore, just prior to running the guest for the first time, we need
> to finalize the PPIs. A mask is generated which, when combined with
> trapping a guest's PPI accesses, allows for the guest's view of the
> PPI to be filtered.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Minor suggestion inline. Either way

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index c7ecc4f40b1e5..f1fa63e67c1f6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -81,6 +81,66 @@ static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
>  	return priority_mask;
>  }
>  
> +static int vgic_v5_finalize_state(struct kvm_vcpu *vcpu)
> +{
> +	if (!ppi_caps)
> +		return -ENXIO;
> +
> +	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[0] = 0;
> +	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[1] = 0;
> +	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0] = 0;
> +	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1] = 0;
> +	for (int i = 0; i < VGIC_V5_NR_PRIVATE_IRQS; ++i) {
> +		int reg = i / 64;
> +		u64 bit = BIT_ULL(i % 64);
> +		struct vgic_irq *irq = &vcpu->arch.vgic_cpu.private_irqs[i];
> +
> +		raw_spin_lock(&irq->irq_lock);
> +
A little nicer perhaps with:
		guard(raw_spin_lock(&irq->irq_lock);
> +		/*
> +		 * We only expose PPIs with an owner or thw SW_PPI to
> +		 * the guest.
> +		 */
> +		if (!irq->owner && irq->intid == GICV5_SW_PPI)
> +			goto unlock;
and
			continue;
> +
> +		/*
> +		 * If the PPI isn't implemented, we can't pass it
> +		 * through to a guest anyhow.
> +		 */
> +		if (!(ppi_caps->impl_ppi_mask[reg] & bit))
> +			goto unlock;
and
			continue;
> +
> +		vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[reg] |= bit;
> +
> +		if (irq->config == VGIC_CONFIG_LEVEL)
> +			vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[reg] |= bit;
> +
> +unlock:
> +		raw_spin_unlock(&irq->irq_lock);
Then the label and unlock can go away.

> +	}
> +
> +	return 0;
> +}


