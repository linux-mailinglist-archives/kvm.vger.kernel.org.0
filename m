Return-Path: <kvm+bounces-66076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89563CC4026
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE90D300EE66
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34605231A41;
	Tue, 16 Dec 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJLxC1Bd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A634DB4A;
	Tue, 16 Dec 2025 15:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765899664; cv=none; b=dDJ4PjWLxf6gbXIfeeMmFZRXZVeEb5ndmQ8VBe6LK9KK6M1byAbAyKC5d5rAJ4giOLBUEosJlWO5uWFv4zK5xu7+lPlec5tTqWN4+/+xlR6P7qBpHYfI2P/V4b8oKEGxiWLmGabzRumh3HpwPW+xJ8n843gcremntAACSzZL0Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765899664; c=relaxed/simple;
	bh=ZLMXB9W9lGKzctTWJArW9FEZ3LPiAiwdNGpWwjugkkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8cfA0GbJ25u/868T4oziym05e6AVvFNEf7zb0QyOvI0oOMin5gGiPazNyHV95VT026Z34Tpfn/y8Rgk7Bzz3oi4f8LcsmUOgw99g+144zLxVt4QeD9LuD6PDHsZJWVwOyNKTrTBE/L7BEEm6/W5VLg5rDn2DXBKIsAFXxBIDJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJLxC1Bd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF21EC4CEF1;
	Tue, 16 Dec 2025 15:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765899663;
	bh=ZLMXB9W9lGKzctTWJArW9FEZ3LPiAiwdNGpWwjugkkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJLxC1Bdsgt8eAlutveLdrhP3wGs0rsN+YFRYXv3XvWreXRzKo9MdKq10ncAaofdc
	 A8prOj31IGEMqg8RNNAOFM5+vSexABe4jHflH3sHPxkxNXBfRhVlTTpMGdfQ+K+2Lq
	 xhcs3nRKv6ICR7xJ1uWb6QU1uoe3TF4aWqsky8iylhfTbDQNJEBRCud3Ybr+aOYEkC
	 9igz92Awk8CYkiWBp/BNN4FArycWGjkn0W/ZtpfLyFB8bvYiQLD1p6I1S6KcRvNVqr
	 5ocVq307FzTcutXEWDbg2+MsTC2t6LZciQ1WWq4Ar0V/Tj8PdsygbbHpDl+v/1ntcG
	 lyTN57Ivr6oJg==
Date: Tue, 16 Dec 2025 16:40:55 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 29/32] irqchip/gic-v5: Check if impl is virt capable
Message-ID: <aUF9hwjBuUKA73U8@lpieralisi>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
 <20251212152215.675767-30-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212152215.675767-30-sascha.bischoff@arm.com>

On Fri, Dec 12, 2025 at 03:22:45PM +0000, Sascha Bischoff wrote:
> Now that there is support for creating a GICv5-based guest with KVM,

The only comment I have is - as discussed, this patch is not really
dependent on GICv5 KVM support - ie, if IRS_IDR0.VIRT == b0 there isn't
a chance GIC v3 legacy support is implemented either, maybe it is worth
clarifying that.

Otherwise LGTM:

Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

> check that the hardware itself supports virtualisation, skipping the
> setting of struct gic_kvm_info if not.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  drivers/irqchip/irq-gic-v5-irs.c   | 4 ++++
>  drivers/irqchip/irq-gic-v5.c       | 5 +++++
>  include/linux/irqchip/arm-gic-v5.h | 4 ++++
>  3 files changed, 13 insertions(+)


> 
> diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
> index ce2732d649a3e..eebf9f219ac8c 100644
> --- a/drivers/irqchip/irq-gic-v5-irs.c
> +++ b/drivers/irqchip/irq-gic-v5-irs.c
> @@ -744,6 +744,10 @@ static int __init gicv5_irs_init(struct device_node *node)
>  	 */
>  	if (list_empty(&irs_nodes)) {
>  
> +		idr = irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
> +		gicv5_global_data.virt_capable =
> +			!!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
> +
>  		idr = irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
>  		irs_setup_pri_bits(idr);
>  
> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index 41ef286c4d781..f5b17a2557aa1 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -1064,6 +1064,11 @@ static struct gic_kvm_info gic_v5_kvm_info __initdata;
>  
>  static void __init gic_of_setup_kvm_info(struct device_node *node)
>  {
> +	if (!gicv5_global_data.virt_capable) {
> +		pr_info("GIC implementation is not virtualization capable\n");
> +		return;
> +	}
> +
>  	gic_v5_kvm_info.type = GIC_V5;
>  
>  	/* GIC Virtual CPU interface maintenance interrupt */
> diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
> index 9607b36f021ee..36f4c0e8ef8e9 100644
> --- a/include/linux/irqchip/arm-gic-v5.h
> +++ b/include/linux/irqchip/arm-gic-v5.h
> @@ -45,6 +45,7 @@
>  /*
>   * IRS registers and tables structures
>   */
> +#define GICV5_IRS_IDR0			0x0000
>  #define GICV5_IRS_IDR1			0x0004
>  #define GICV5_IRS_IDR2			0x0008
>  #define GICV5_IRS_IDR5			0x0014
> @@ -65,6 +66,8 @@
>  #define GICV5_IRS_IST_STATUSR		0x0194
>  #define GICV5_IRS_MAP_L2_ISTR		0x01c0
>  
> +#define GICV5_IRS_IDR0_VIRT		BIT(6)
> +
>  #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
>  #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
>  
> @@ -280,6 +283,7 @@ struct gicv5_chip_data {
>  	u8			cpuif_pri_bits;
>  	u8			cpuif_id_bits;
>  	u8			irs_pri_bits;
> +	bool			virt_capable;
>  	struct {
>  		__le64 *l1ist_addr;
>  		u32 l2_size;
> -- 
> 2.34.1

