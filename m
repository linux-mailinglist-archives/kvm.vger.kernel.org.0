Return-Path: <kvm+bounces-67171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56604CFABF0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0AF5D3414B78
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 19:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD4B35B132;
	Tue,  6 Jan 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Ti/Cnbq3"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544A4359FA4
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725008; cv=none; b=cZ0rrwFRoOGemxsDybk+xGor4yO5TiWwAgqws3E8Py2lcnCcQjVoraYp/k2zB/2bLVAMh1UFJ1mlaKZpuYJuDcx5bdXolbRl8oBaLgXA7gfrmv94AVRjI1c2Ux17lk4EvFu6vFPASI45Ktjgou0Wl6nOaWxHkj5PWiEVLWSx9QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725008; c=relaxed/simple;
	bh=8AQMo2bKqiVJpCXgq53DOTeAVQHmYvXvePKtYRdRIvU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqeXioFQ+SNbvwp2UiFpPeX5F7SkhtpLbzBic3HHOVg3ltR59vih3sH5OwwAiBJEH7LYgAbzC89tfobipwyFIf8wbF5pj9/iU68bheeSrylV/8r5f1lOZlKJF85//rrJwQaU4mGhDCTD1axziRSanamL4zPKDDQ9lHD3mMpDGMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Ti/Cnbq3; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CPZANbv0STzLtH3a80Pr5HXtHvD2VOOOrggZl0/fcv8=;
	b=Ti/Cnbq3Wap4TdpoBsmDo7OUQ/W8DNZ1jPFaI8gBzFKMtHOud505NkRbTi0R0KmxwnFyDO1hI
	gcupkrbCdKSxjaM0xu278dJRfXk8wikYzs2p6Mgx8LTNmtx9qhJPS0QHAd6PyFECgAz4hVmlJZh
	1a9hvWXIT4m36vmfhBzN0kw=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dm0P45zMsz1vnvh;
	Wed,  7 Jan 2026 02:41:12 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dm0RS4LKXzJ4680;
	Wed,  7 Jan 2026 02:43:16 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 90B1C40565;
	Wed,  7 Jan 2026 02:43:18 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 18:43:17 +0000
Date: Tue, 6 Jan 2026 18:43:13 +0000
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
Subject: Re: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Message-ID: <20260106184313.00002a8c@huawei.com>
In-Reply-To: <20251219155222.1383109-8-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-8-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:38 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> GICv5 has moved from using interrupt ranges for different interrupt
> types to using some of the upper bits of the interrupt ID to denote
> the interrupt type. This is not compatible with older GICs (which rely
> on ranges of interrupts to determine the type), and hence a set of
> helpers is introduced. These helpers take a struct kvm*, and use the
> vgic model to determine how to interpret the interrupt ID.
> 
> Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
> helper is introduced to determine if an interrupt is private - SGIs
> and PPIs for older GICs, and PPIs only for GICv5.
> 
> The helpers are plumbed into the core vgic code, as well as the Arch
> Timer and PMU code.
> 
> There should be no functional changes as part of this change.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Hi Sascha,

A bit of bikeshedding / 'valuable' naming feedback to end the day.
Otherwise LGTM.

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index b261fb3968d03..6778f676eaf08 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
...

>  enum vgic_type {
>  	VGIC_V2,		/* Good ol' GICv2 */
> @@ -418,8 +488,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	((k)->arch.vgic.initialized)
> -#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
> +#define vgic_valid_nv5_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
> +#define vgic_valid_v5_spi(k, i)	(irq_is_spi(k, i) && \
> +				 (FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis))
> +#define vgic_valid_spi(k, i) (vgic_is_v5(k) ?				\
> +			      vgic_valid_v5_spi(k, i) : vgic_valid_nv5_spi(k, i))

nv is a little awkward as a name as immediately makes me thinking
nested virtualization instead of not v5 (which I guess is the thinking behind that?)

Probably just me and naming it v23 will break if we get to GIC version 23 :)
nv5 breaks when we get GICv6 ;)


>  
>  bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);


