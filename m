Return-Path: <kvm+bounces-67231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1926BCFEC80
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3BE5A30779FA
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4269136C5BC;
	Wed,  7 Jan 2026 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="elUV80mu"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F436C0C0
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767799067; cv=none; b=AGOLYRtqJSrY5oeU5cpFwwZ1QWz+GgbNbiiJmsE9ShdRGSxDY1FiNZKxLG0OAyOkKNNwF+V6R/GR0jwfaE0o+a5WyGpnGr0qaZqYD/yOLJJy4rv+4n2VlwCBAXLZses8oxFpnbQ0BKCjO6HTrFDGhPcTqoviJC9MFcpvlszKRls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767799067; c=relaxed/simple;
	bh=72aqjGByciRxNun/Ak8UlAY9Vd26yC8sPkaYoCCtQAg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFLgbt2YXJW3VQ0N2awc9arfZox6fHQOOgvbwxZURld17+3E1M5d1td+XIF8ShDWCIWT3k+3riPntUOonaBG/fs8SA75zLiezpXoacq+YuilfO6WSxsbu8cb2veNxFfWgUogLvldq4cFwfl0NQ1PYzNgwO3X9SHPg/a82x2hUDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=elUV80mu; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m0m6qrjM++EX1JPQbt0U+H0JDa6SDyotsLzRZmvjPOI=;
	b=elUV80muaVjrHBusOw+FMQaH2tX6IiLXEtBLQWqkUHmRO1e+Lb5UDdL6SOUBfDhWHyB29mAcz
	QdoCY90ABhQDw2JvnkXuIlkvajdrN+gptLwU1tJP1Fk8tiPqSoxqEpTdxB4rAZqWAfw16nnNEen
	fvHAtc4P82QYqGcQ4W9s09o=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmWmx1QPQz1P7sc;
	Wed,  7 Jan 2026 23:15:13 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmWqc6FxGzJ46Cj;
	Wed,  7 Jan 2026 23:17:32 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 40AAA40539;
	Wed,  7 Jan 2026 23:17:36 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 15:17:35 +0000
Date: Wed, 7 Jan 2026 15:17:33 +0000
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
Subject: Re: [PATCH v2 22/36] KVM: arm64: gic-v5: Trap and mask guest PPI
 register accesses
Message-ID: <20260107151733.00003028@huawei.com>
In-Reply-To: <20251219155222.1383109-23-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-23-sascha.bischoff@arm.com>
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

> A guest should not be able to detect if a PPI that is not exposed to
> the guest is implemented or not. If the writes to the PPI registers
> are not masked, it becomes possible for the guest to detect the
> presence of all implemented PPIs on the host.
> 
> Guest writes to the following registers are masked:
> 
> ICC_CACTIVERx_EL1
> ICC_SACTIVERx_EL1
> ICC_CPENDRx_EL1
> ICC_SPENDRx_EL1
> ICC_ENABLERx_EL1
> ICC_PRIORITYRx_EL1
> 
> When a guest writes these registers, the write is masked with the set
> of PPIs actually exposed to the guest, and the state is written back
> to KVM's shadow state..

One . seems enough.

> 
> Reads for the above registers are not masked. When the guest is
> running and reads from the above registers, it is presented with what
> KVM provides in the ICH_PPI_x_EL2 registers, which is the masked
> version of what the guest last wrote.
> 
> The ICC_PPI_HMRx_EL1 register is used to determine which PPIs use
> Level-sensitive semantics, and which use Edge. For a GICv5 guest, the
> correct view of the virtual PPIs must be provided to the guest, and
> hence this must also be trapped, but only for reads. The content of
> the HMRs is calculated and masked when finalising the PPI state for
> the guest.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
A few bits inline but nothing significant so I'll assume you tidy those up
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/kvm/config.c   |  22 ++++++-
>  arch/arm64/kvm/sys_regs.c | 133 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 153 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index eb0c6f4d95b6d..f81bfdadd12fb 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1586,8 +1586,26 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
>  {
>  	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
>  
> -	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
> +	/*
> +	 * ICC_IAFFIDR_EL1 and ICH_PPI_HMRx_EL1 *always* needs to be

need to be

> +	 * trapped when running a guest.
> +	 **/

*/

>  	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &= ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
> +	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &= ~ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1;
> +}

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 383ada0d75922..cef13bf6bb3a1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -696,6 +696,111 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_gicv5_ppi_hmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +				 const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	if (p->Op2 == 0) {	/* ICC_PPI_HMR0_EL1 */
> +		p->regval = vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0];
> +	} else {		/* ICC_PPI_HMR1_EL1 */
> +		p->regval = vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1];
> +	}

No {} as single line statements in all legs.

However, I'd be tempted to use a local variable for the index like you've
done in many other cases
	
	unsigned int index;

...

	index = p->Op2 == 0 ? 0 : 1;
	p->regval = vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hrm[index];

Or use the p->Op2 % 2 as you do in ppi_enabler.


> +
> +	return true;
> +}
> +
> +static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
> +				     struct sys_reg_params *p,
> +				     const struct sys_reg_desc *r)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	u64 masked_write;
> +
> +	/* We never expect to get here with a read! */
> +	if (WARN_ON_ONCE(!p->is_write))
> +		return undef_access(vcpu, p, r);
> +
> +	masked_write = p->regval & cpu_if->vgic_ppi_mask[p->Op2 % 2];
> +	cpu_if->vgic_ich_ppi_enabler_entry[p->Op2 % 2] = masked_write;
> +
> +	return true;
> +}
> +
> +static bool access_gicv5_ppi_pendr(struct kvm_vcpu *vcpu,
> +				   struct sys_reg_params *p,
> +				   const struct sys_reg_desc *r)
> +{
> +	struct vgic_v5_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v5;
> +	u64 masked_write;
> +
> +	/* We never expect to get here with a read! */
> +	if (WARN_ON_ONCE(!p->is_write))
> +		return undef_access(vcpu, p, r);
> +
> +	masked_write = p->regval & cpu_if->vgic_ppi_mask[p->Op2 % 2];
> +
> +	if (p->Op2 & 0x2) {	/* SPENDRx */
> +		cpu_if->vgic_ppi_pendr_entry[p->Op2 % 2] |= masked_write;
> +	} else {		/* CPENDRx */
> +		cpu_if->vgic_ppi_pendr_entry[p->Op2 % 2] &= ~masked_write;
> +	}

No {} wanted in kernel style when all legs are single line statements.
Same applies in a few other cases that follow.

> +
> +	return true;
> +}
> +


