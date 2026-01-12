Return-Path: <kvm+bounces-67773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E274D13E09
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8740D301786F
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492923644BB;
	Mon, 12 Jan 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hrV8v8yW"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE593612E8
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768233699; cv=none; b=kNGFDkPMCqwGoWZReTtocfb2P64lQiRSR7GzXJTgRy5ajALsd4jaOjyeM/h2GhjACdptjflT5ngXCB3J2xrO391/NCi49OuE/RsmejaC6+X9DNHc6Pp/KWKJUOF+kpVbYAX+gkSOyUkCtUO+19qUe2D6UQrUqhbcJCCQ44YN94w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768233699; c=relaxed/simple;
	bh=6MF92TvasTIdr3GIdsu59m2q747zJ/WqCYaYH/J02xI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7xkARkTbOgEe6eZEfDwThVh44SMBLS3ijWxnRDSProbuYE93+lNVZfZzFXZBjcK2Pv8iEuQVqVF45SNBqCgRQivCA+9u2dZpIU23EgQaVVvPVoJAioZtSS2kgWZEPySFy/85+yhrsd1PihWx7yA59ntkjy9jwYTimt4ma23XZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hrV8v8yW; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Uzdhc/5bjAQXTXTPZi/QQirOrHAvE9iAR7tdve+8Jig=;
	b=hrV8v8yWqGNh6CIrkr0yxWAsCjFBQm8+RAbVkFulD4Rxec3q7ksTCMZbj/oZHzZoUidUNNz8m
	2DepDKKEvqN4m0NC4BNJCCFFxYMA4wzz5HxvqW/F5RyyocsB4RgSTKq9NMFW57OFfTcCQ70hFHc
	7AOZBxzlqJQIqJP/ynXDFHE=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dqcWT3l3Vz1vnsC;
	Mon, 12 Jan 2026 23:59:17 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqcYp2KfgzJ46F9;
	Tue, 13 Jan 2026 00:01:18 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E5D2540573;
	Tue, 13 Jan 2026 00:01:29 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:01:29 +0000
Date: Mon, 12 Jan 2026 16:01:27 +0000
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
Subject: Re: [PATCH v3 19/36] KVM: arm64: gic-v5: Implement PPI interrupt
 injection
Message-ID: <20260112160127.00005f84@huawei.com>
In-Reply-To: <20260109170400.1585048-20-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-20-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:45 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change introduces interrupt injection for PPIs for GICv5-based
> guests.
> 
> The lifecycle of PPIs is largely managed by the hardware for a GICv5
> system. The hypervisor injects pending state into the guest by using
> the ICH_PPI_PENDRx_EL2 registers. These are used by the hardware to
> pick a Highest Priority Pending Interrupt (HPPI) for the guest based
> on the enable state of each individual interrupt. The enable state and
> priority for each interrupt are provided by the guest itself (through
> writes to the PPI registers).
> 
> When Direct Virtual Interrupt (DVI) is set for a particular PPI, the
> hypervisor is even able to skip the injection of the pending state
> altogether - it all happens in hardware.
> 
> The result of the above is that no AP lists are required for GICv5,
> unlike for older GICs. Instead, for PPIs the ICH_PPI_* registers
> fulfil the same purpose for all 128 PPIs. Hence, as long as the
> ICH_PPI_* registers are populated prior to guest entry, and merged
> back into the KVM shadow state on exit, the PPI state is preserved,
> and interrupts can be injected.
> 
> When injecting the state of a PPI the state is merged into the KVM's
> shadow state using the set_pending_state irq_op. The directly sets the
> relevant bit in the shadow ICH_PPI_PENDRx_EL2, which is presented to
> the guest (and GICv5 hardware) on next guest entry. The
> queue_irq_unlock irq_op is required to kick the vCPU to ensure that it
> seems the new state. The result is that no AP lists are used for
> private interrupts on GICv5.
> 
> Prior to entering the guest, vgic_v5_flush_ppi_state is called from
> kvm_vgic_flush_hwstate. The effectively snapshots the shadow PPI
> pending state (twice - an entry and an exit copy) in order to track
> any changes. These changes can come from a guest consuming an
> interrupt or from a guest making an Edge-triggered interrupt pending.
> 
> When returning from running a guest, the guest's PPI state is merged
> back into KVM's shadow state in vgic_v5_merge_ppi_state from
> kvm_vgic_sync_hwstate. The Enable and Active state is synced back for
> all PPIs, and the pending state is synced back for Edge PPIs (Level is
> driven directly by the devices generating said levels). The incoming
> pending state from the guest is merged with KVM's shadow state to
> avoid losing any incoming interrupts.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Trivial naming thing inline. Either way
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 160 ++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c    |  40 +++++++--
>  arch/arm64/kvm/vgic/vgic.h    |  25 ++++--
>  3 files changed, 209 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index bf2c77bafa1d3..c1899add8f5c3 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -139,6 +139,166 @@ void vgic_v5_get_implemented_ppis(void)
>  		ppi_caps->impl_ppi_mask[0] |= BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
>  }
>  
> +static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
> +					  struct vgic_irq *irq)
> +{
> +	struct vgic_v5_cpu_if *cpu_if;
> +	const u32 id = FIELD_GET(GICV5_HWIRQ_ID, irq->intid);
See below. This seems like reasonable naming choice where I suggest
adding a local variable. 
> +	unsigned long *p;
> +
> +	if (!vcpu || !irq)
> +		return false;
> +
> +	/*
> +	 * For DVI'd interrupts, the state is directly driven by the host
> +	 * hardware connected to the interrupt line. There is nothing for us to
> +	 * do here. Moreover, this is just broken!
> +	 */
> +	if (WARN_ON(irq->directly_injected))
> +		return true;
> +
> +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +
> +	p = (unsigned long *)&cpu_if->vgic_ppi_pendr[id / 64];
> +	__assign_bit(id % 64, p, irq_is_pending(irq));
> +
> +	return true;
> +}

>  /*
>   * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
>   */
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index c465ff51cb073..1cdfa5224ead5 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -105,6 +105,18 @@ struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
>  	if (WARN_ON(!vcpu))
>  		return NULL;
>  
> +	if (vgic_is_v5(vcpu->kvm)) {
> +		u32 int_num;
> +
> +		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
> +			return NULL;
> +
> +		int_num = FIELD_GET(GICV5_HWIRQ_ID, intid);

I'd use an extra local variable to avoid int_num changing meaning like this.
Perhaps 
		u32 int_num, hwirq_id;

		hwirq_id = FIELD_GET(GICV5_HWIRQ_ID, intid);
		int_num = array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);

or just id = FIELD_GET() given use above.


> +		int_num = array_index_nospec(int_num, VGIC_V5_NR_PRIVATE_IRQS);
> +
> +		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
> +	}
> +



