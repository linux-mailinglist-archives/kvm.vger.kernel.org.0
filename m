Return-Path: <kvm+bounces-51301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF31DAF5B25
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCB494E0217
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930422F5334;
	Wed,  2 Jul 2025 14:28:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6030F2F5326;
	Wed,  2 Jul 2025 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466503; cv=none; b=WYQJTcdNzF2By0pS1WrTrZxR7GBC32JW+HsLKyzNpDfLS2EYNIOPHpDQFOakPHeUQWYE+JjAG0zGLbckmF3orFbSo/RJl3L/b9j1vU6wU1i9oB+yeRrGaBsZG4LI40fJmdVEhw6mhTGlTZSpVjYf03/Ote1RwUVtkF5LPV8ZSWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466503; c=relaxed/simple;
	bh=NsFJdJ2JaJtHywUYIehF4YOfb8c7yEr59Tfk0oV3x1I=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPh33B5ad36F50cDsQ/J3KXH2W4mr6AtaGBCJUSZffVNLX6bpyAhbKaA4fhd1OT/5FCMAsOfnqAKUO5zVGRUrvNv7TWdVgp7xaQJTj4igNkuL9EKAMoisiMzmNgz7IZN45/BeAMSaABfsb4RnEwPpw/lrkm+KQMm9boK5bQTn0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bXMfy4N74z6M4tS;
	Wed,  2 Jul 2025 22:27:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 53C1F1402EA;
	Wed,  2 Jul 2025 22:28:18 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 2 Jul
 2025 16:28:17 +0200
Date: Wed, 2 Jul 2025 15:28:16 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 1/5] irqchip/gic-v5: Skip deactivate for forwarded
 PPI interrupts
Message-ID: <20250702152816.000010da@huawei.com>
In-Reply-To: <20250627100847.1022515-2-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
	<20250627100847.1022515-2-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 27 Jun 2025 10:09:01 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> If a PPI interrupt is forwarded to a guest, skip the deactivate and
> only EOI. Rely on the guest deactivating both the virtual and physical
> interrupts (due to ICH_LRx_EL2.HW being set) later on as part of
> handling the injected interrupt. This mimics the behaviour seen on
> native GICv3.
> 
> This is part of adding support for the GICv3 compatibility mode on a
> GICv5 host.
> 
> Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
> 

Trivial but no gaps in tag blocks.  So no blank line here.
Some scripting will moan about this and I think that will hit you if
this goes into linux next.

> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 7a11521eeeca..6b42c4af5c79 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -213,6 +213,12 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_type)
>  
>  static void gicv5_ppi_irq_eoi(struct irq_data *d)
>  {
> +	/* Skip deactivate for forwarded PPI interrupts */
> +	if (irqd_is_forwarded_to_vcpu(d)) {
> +		gic_insn(0, CDEOI);
> +		return;
> +	}
> +
>  	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
>  }
>  
> @@ -494,6 +500,16 @@ static bool gicv5_ppi_irq_is_level(irq_hw_number_t hwirq)
>  	return !!(read_ppi_sysreg_s(hwirq, PPI_HM) & bit);
>  }
>  
> +static int gicv5_ppi_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
> +{
> +	if (vcpu)
> +		irqd_set_forwarded_to_vcpu(d);
> +	else
> +		irqd_clr_forwarded_to_vcpu(d);
> +
> +	return 0;
> +}
> +
>  static const struct irq_chip gicv5_ppi_irq_chip = {
>  	.name			= "GICv5-PPI",
>  	.irq_mask		= gicv5_ppi_irq_mask,
> @@ -501,6 +517,7 @@ static const struct irq_chip gicv5_ppi_irq_chip = {
>  	.irq_eoi		= gicv5_ppi_irq_eoi,
>  	.irq_get_irqchip_state	= gicv5_ppi_irq_get_irqchip_state,
>  	.irq_set_irqchip_state	= gicv5_ppi_irq_set_irqchip_state,
> +	.irq_set_vcpu_affinity	= gicv5_ppi_irq_set_vcpu_affinity,
>  	.flags			= IRQCHIP_SKIP_SET_WAKE	  |
>  				  IRQCHIP_MASK_ON_SUSPEND,
>  };


