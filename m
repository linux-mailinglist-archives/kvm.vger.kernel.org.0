Return-Path: <kvm+bounces-67229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8CECFE7DE
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 16:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 37E3A30010F2
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 15:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5370734B1AF;
	Wed,  7 Jan 2026 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ylo8m+NR"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC534A3D6
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767798294; cv=none; b=oGDdLyfIHL+wpPT2LambZYsXfYg6ITXpAicLMWW5yl179f2tbTnMxk1XsSRuN6n784MEM51pjvblABwwbAnv1pizspdWBqD6GxCem3U7tBTGlttqjJeqidHn/2zkkdlri5onPRxeAeOM9ZhwS7S8s5pmO0WPTpDW5JMLKF3POik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767798294; c=relaxed/simple;
	bh=x+BO7+g+ZJi6Bd2XAfDBggbsTUgpEyqIKApCkynG4bI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cyIbIoaCYTQnMthYdTJZVXXYStwWUaYROxzXDNDsOM+vRpn1OnpWW/w5EQHSl26b96mzTF1ukSMOMpmuPYK9iMR3yx8h1GDkSs6JFNSDvyDix10oaXN8mM68L762IrSrMn28aqILzcyN9E7lFUtU2jhnJI9V8Zza2XlaBA6pqBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ylo8m+NR; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ORgRBCEvHqF3ASwTkSpJbEavEYI/IdEmj28e0XJZgk0=;
	b=ylo8m+NR4VGDUUtfFrV00L9BCU/BsyRDLU+PD/LlKgOIAoCoGPwulnxrlY7QIJBwlwr6Z1kva
	5/TNF3rVuCJVnrIOLbIVHVLxVp/5Hs98GcBIX1BQ3bH/cWl85z5FK0kXV7z9TvMt82jRPtbBVFp
	g1x+0lAX7JWkZ1908ZyaNWA=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmWVQ6PNzz1vnMS;
	Wed,  7 Jan 2026 23:02:38 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmWXp4qKRzJ46D6;
	Wed,  7 Jan 2026 23:04:42 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 09E1B4056F;
	Wed,  7 Jan 2026 23:04:46 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:04:44 +0000
Date: Wed, 7 Jan 2026 15:04:42 +0000
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
Subject: Re: [PATCH v2 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Message-ID: <20260107150442.00004110@huawei.com>
In-Reply-To: <20251219155222.1383109-21-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-21-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:42 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Initialise the private interrupts (PPIs, only) for GICv5. This means
> that a GICv5-style intid is generated (which encodes the PPI type in
> the top bits) instead of the 0-based index that is used for older
> GICs.
> 
> Additionally, set all of the GICv5 PPIs to use Level for the handling
> mode, with the exception of the SW_PPI which uses Edge. This matches
> the architecturally-defined set in the GICv5 specification (the CTIIRQ
> handling mode is IMPDEF, so pick Level has been picked for that).

so Level has been

> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Trivial comment inline, which you can feel free to ignore if you like

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c    | 41 +++++++++++++++++++++++-------
>  include/linux/irqchip/arm-gic-v5.h |  2 ++
>  2 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index bcc2c79f7833c..03f45816464b0 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c

> @@ -280,22 +286,39 @@ static int vgic_allocate_private_irqs_locked(struct kvm_vcpu *vcpu, u32 type)
>  	 * Enable and configure all SGIs to be edge-triggered and
>  	 * configure all PPIs as level-triggered.
>  	 */
> -	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
> +	for (i = 0; i < num_private_irqs; i++) {
>  		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
>  
>  		INIT_LIST_HEAD(&irq->ap_list);
>  		raw_spin_lock_init(&irq->irq_lock);
> -		irq->intid = i;
>  		irq->vcpu = NULL;
>  		irq->target_vcpu = vcpu;
>  		refcount_set(&irq->refcount, 0);
> -		if (vgic_irq_is_sgi(i)) {
> -			/* SGIs */
> -			irq->enabled = 1;
> -			irq->config = VGIC_CONFIG_EDGE;
> +		if (!vgic_is_v5(vcpu->kvm)) {
> +			irq->intid = i;
> +			if (vgic_irq_is_sgi(i)) {
> +				/* SGIs */
> +				irq->enabled = 1;
> +				irq->config = VGIC_CONFIG_EDGE;
> +			} else {
> +				/* PPIs */
> +				irq->config = VGIC_CONFIG_LEVEL;
> +			}
>  		} else {
> -			/* PPIs */
> -			irq->config = VGIC_CONFIG_LEVEL;
> +			irq->intid = i | FIELD_PREP(GICV5_HWIRQ_TYPE,
> +						    GICV5_HWIRQ_TYPE_PPI);
Trivial:
I'd use FIELD_PREP() even for the ID part.  Makes no difference other than
making it explicit that it's a field that doesn't overlap with the type
one.


