Return-Path: <kvm+bounces-67243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC787CFF25E
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 401AC3363609
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FB2368294;
	Wed,  7 Jan 2026 16:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gTJ/W7Z1"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110EB369223
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802770; cv=none; b=ZpuVSvPf4jxolgNfWCnepkqoNElynBw2+uSgg10rvCZxbQyYcrZe11xcfCSseiiE3PhXTstf7xNDQGdeVqg+LSMDlfloV5EnYzAmHvxV5vjPL0+KSnuwY5CPM6FeFmcjRzdWQp3f5HCiaA573MB03kvkMRl43GnDSUeJbH1pniU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802770; c=relaxed/simple;
	bh=t0FVsDqmJ46/wrnLgkMA2+e+/0SCAh8O8DDETnNPvD0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dc13JqhLeGTY2kjtj2/mjM2ouFQtQiq2NLmMv76zaepnBKsQDVBbDuj0ERvTboU8i1TB0yBvM0Ogcvb/YmckjvFuiPXP9TphyyGbrXvn3jJb1UR6OA6sKTKqrwtbCpBf79HvhZHBDwsPoi6cgChvzOjuWvwwh/QOOWcFhRlsec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gTJ/W7Z1; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aky2/51RduZBuBKf+FKa+EmDr7pgEdWUv3WBf9Rvpyk=;
	b=gTJ/W7Z1rc/sjLAinJV92HtJ1Z78MpXhjc67kXnqSkDd7IXHrkfF2LlP2+U09l5d+ArqvZM4X
	9BpMG+z5vmQ8gV3eMlCQzz1iE+HgoeluCk2KoYvUMVzoJAJWPSG8AjYY5DxmaxF6htbP4H/Vhsd
	gq3/2aWD9aqx0Ru3OzThdTc=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmY7y6thqz1P7Hn;
	Thu,  8 Jan 2026 00:16:46 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYBb42kSzHnGdq;
	Thu,  8 Jan 2026 00:19:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0489740086;
	Thu,  8 Jan 2026 00:19:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:19:09 +0000
Date: Wed, 7 Jan 2026 16:19:07 +0000
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
Subject: Re: [PATCH v2 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Message-ID: <20260107161907.000045d8@huawei.com>
In-Reply-To: <20251219155222.1383109-31-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-31-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:46 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
> currently supported. All other ops are stubbed out.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Trivial stuff only from me on this one.


> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 72 +++++++++++++++++++++++++++
>  include/linux/kvm_host.h              |  1 +
>  2 files changed, 73 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index b12ba99a423e5..78903182bba08 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -336,6 +336,9 @@ int kvm_register_vgic_device(unsigned long type)
>  			break;
>  		ret = kvm_vgic_register_its_device();
>  		break;
> +	case KVM_DEV_TYPE_ARM_VGIC_V5:
> +		ret = kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
> +					      KVM_DEV_TYPE_ARM_VGIC_V5);

I'd stick to existing style and have a break for last case as well.

>  	}
>  
>  	return ret;
> @@ -715,3 +718,72 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops = {
>  	.get_attr = vgic_v3_get_attr,
>  	.has_attr = vgic_v3_has_attr,
>  };
> +
> +static int vgic_v5_set_attr(struct kvm_device *dev,
> +			    struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR:
> +	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> +		break;
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> +			return  vgic_set_common_attr(dev, attr);
bonus space before vgic

> +		default:
> +			break;
> +		}
> +	}
> +
> +	return -ENXIO;

I'd do this where you have breaks above. Makes it easier to follow
code flow. (a tiny bit anyway!)
Similar for other cases. Style in the file is pretty random wrt to
errors in switch statements so up to you on which one to pick.

> +}

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae22..d6082f06ccae3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2368,6 +2368,7 @@ void kvm_unregister_device_ops(u32 type);
>  extern struct kvm_device_ops kvm_mpic_ops;
>  extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
>  extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
> +extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
>  
>  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
>  


