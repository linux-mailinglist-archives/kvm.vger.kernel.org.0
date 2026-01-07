Return-Path: <kvm+bounces-67219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8370CFD63C
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 12:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 703F930021C8
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 11:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D5230AABC;
	Wed,  7 Jan 2026 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="U0iqRGZl"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097418FDDE
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 11:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767785105; cv=none; b=moH06W5aLHv2TjAtPBH9YLKjD+f7pzREpFFMLAFKPpfVLLlvvV0kwjfDzscN35HxEkrJbMZ5vCqlZcvcSjf+AMffwqu3oT5M1wQFOxMQukNPZaWNyYB7xaE6flObIUcwPrHpDxJXfEtrMmB87Fkzcu1IMuMdKABL/a8FvCjqtmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767785105; c=relaxed/simple;
	bh=SjBQYtf4n6nBNqiksTyT2WcvJ5cY7yVeRtu6eJRxcjI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+5kduiMxKkarXNjrNv4vH8DsbyPRZ4DSMRHfJ63GIOU3sqiKqGwYF7N3Cozo7zydU+jNQFFNoxc+YVRev4lOsT46/3EWHf/x69vz3p2m4AXSftZ5nJQZyerd22pxD0akVzUqrXZfC1BcTI1WC8sO3BtcBg9aN3TS68Z/RwdIa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=U0iqRGZl; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Mx4HxkvxS5+KY/vZ//YKmAqZ2BvXN0nyzwAdGObB9i0=;
	b=U0iqRGZl6n9h324NEVa8ZWn78Bdn60SKfDDxTUQ0R656dKatCNfUfi9kjB4S2w58iSU6/KGZe
	xK2hvfybERfeBxcFPBUEQ4d+i7VkdF8r/dbF6WDgB3GowSEpPmw06LttPFNEgv5ceAQFouC1jU/
	U3kb+jVKp05F+2cXl3Qh3wQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmQcn24vXz1vpDm;
	Wed,  7 Jan 2026 19:22:49 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmQg8449hzJ468L;
	Wed,  7 Jan 2026 19:24:52 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A9FED40539;
	Wed,  7 Jan 2026 19:24:55 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 11:24:54 +0000
Date: Wed, 7 Jan 2026 11:24:53 +0000
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
Subject: Re: [PATCH v2 13/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Message-ID: <20260107112453.00004fb9@huawei.com>
In-Reply-To: <20251219155222.1383109-14-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-14-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:40 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Different GIC types require the private IRQs to be initialised
> differently. GICv5 is the culprit as it supports both a different
> number of private IRQs, and all of these are PPIs (there are no
> SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
> encode the type, the intid also needs to computed differently.
> 
> Up until now, the GIC model has been set after initialising the
> private IRQs for a VCPU. Move this earlier to ensure that the GIC
> model is available when configuring the private IRQs.
Hi Sascha,

Good to mention you are moving a bit more than just the type
initialization. One question on whether it makes sense to move
vgic_dist_base inline.

> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index c602f24bab1bb..bcc2c79f7833c 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -140,6 +140,12 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  		goto out_unlock;
>  	}
>  
> +	kvm->arch.vgic.in_kernel = true;
> +	kvm->arch.vgic.vgic_model = type;
> +	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;

Moving these looks fine.

> +
> +	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;

Does this need to move?  The rest of the *base =
stuff is still where this code originally came from.
Might well be necessary but I'd expect a little in the patch description on why.

> +
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		ret = vgic_allocate_private_irqs_locked(vcpu, type);
>  		if (ret)
> @@ -156,12 +162,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  		goto out_unlock;
>  	}
>  
> -	kvm->arch.vgic.in_kernel = true;
> -	kvm->arch.vgic.vgic_model = type;
> -	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
> -
> -	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
> -
>  	aa64pfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
>  	pfr1 = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
>  


