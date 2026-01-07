Return-Path: <kvm+bounces-67232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD27DCFE992
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 16:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D407B304929F
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FB7392B7C;
	Wed,  7 Jan 2026 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jMGy3VcV"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68877392B69
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767799759; cv=none; b=WDCjYRl4wlLFYgrPJXcZ4fVBnpbPF9Qmp2oWVUw0h/ishd6xA4d67GAy80a9X3Ck1zvSAQ6MnZpwJSHwEZMybBmz34yH01NJTxwB+HZgz4PeyJcCT5fgc3cqqqIbhzjN6U6xl2srW76UWxrMqkABXmNbJ3/du30GGlw86yHxBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767799759; c=relaxed/simple;
	bh=XLIGZ5SHU3D+sSaIf1FinSVBpaSiNdId+gE+gvhJwaE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/sxf0NqCSLg3QX6OlIr2N6tCrRIlmfU2BV7QIFjrLCsrtP44qj68WKamV3Whn7HOnd/mb6pDmA8NsE2ATldH3iLb/s1Agcq9XiB3LyvdAEkjUs3I9jZK+em8VteylgjiemYT57so/ommk8T4ryvSHpWZ44j86gwMG/4pZMQB20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jMGy3VcV; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zDlUnTvuZxuMrJIH4ow24pBUWtnNP7Q50L+kLUFzNWA=;
	b=jMGy3VcVOW7DZMezg6yQfxHIB5ezBtAWDxtwlBZ7b1sS2lDeS5emUJc7P7qX8r38BxoKITmIO
	IVuH+QudZI9wCGEngfd/zF6aW5ukpft+Hlx+0xmC0yGn+AMxjxTskUIEqxi5wfbYKX0gkygBB5T
	zw9Ut2QyiCwWyMHm8bdanHs=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmX2X22M9z1vnNY;
	Wed,  7 Jan 2026 23:27:00 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmX4r6R4FzHnGfP;
	Wed,  7 Jan 2026 23:29:00 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4510A40570;
	Wed,  7 Jan 2026 23:29:07 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:29:06 +0000
Date: Wed, 7 Jan 2026 15:29:05 +0000
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
Subject: Re: [PATCH v2 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Message-ID: <20260107152905.00001d81@huawei.com>
In-Reply-To: <20251219155222.1383109-24-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-24-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:43 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Interrupts under GICv5 look quite different to those from older Arm
> GICs. Specifically, the type is encoded in the top bits of the
> interrupt ID.
> 
> Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
> subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
> GICs, PPIs had to be in the range of 16-31, and SPIs had to be
> 32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
> guest support PPIs in the range of 0-127, and SPIs in the range
> 0-65535. The documentation is updated accordingly.
> 
> The SPI range doesn't cover the full SPI range that a GICv5 system can
> potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
> and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
> SPIs is more than would be reasonably expected on systems for years to
> come.
> 
> Note: As the GICv5 KVM implementation currently doesn't support
> injecting SPIs attempts to do so will fail. This restruction will

restriction

In general,  worth spell checking the lot. (something I always
forget to do for my own series!)

> lifted as the GICv5 KVM support evolves.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
One passing comment inline. Perhaps there isn't a suitable place to put
vgic_is_v5() though. I haven't checked.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  Documentation/virt/kvm/api.rst |  6 ++++--
>  arch/arm64/kvm/arm.c           | 21 ++++++++++++++++++---
>  arch/arm64/kvm/vgic/vgic.c     |  4 ++++
>  3 files changed, 26 insertions(+), 5 deletions(-)
> 

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 94f8d13ab3b58..4448e8a5fc076 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -45,6 +45,8 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_psci.h>
>  
> +#include <linux/irqchip/arm-gic-v5.h>
> +
>  #include "sys_regs.h"
>  
>  static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
> @@ -1430,16 +1432,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  		if (!vcpu)
>  			return -EINVAL;
>  
> -		if (irq_num < VGIC_NR_SGIS || irq_num >= VGIC_NR_PRIVATE_IRQS)
> +		if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5) {

Maybe it's worth moving the vgic_is_v5() helper to somewhere that makes it useable
here?


> +			if (irq_num >= VGIC_V5_NR_PRIVATE_IRQS)
> +				return -EINVAL;
> +
> +			/* Build a GICv5-style IntID here */
> +			irq_num |= FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
> +		} else if (irq_num < VGIC_NR_SGIS ||
> +			   irq_num >= VGIC_NR_PRIVATE_IRQS) {
>  			return -EINVAL;
> +		}
>  
>  		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);


