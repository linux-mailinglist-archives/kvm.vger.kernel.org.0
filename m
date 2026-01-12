Return-Path: <kvm+bounces-67771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8655ED13CCE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 51C7D3043535
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF6E2FF150;
	Mon, 12 Jan 2026 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="n0Ej22H0"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557FC346AE6
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768232968; cv=none; b=bhKTIJApFUhBpyDgMd0MI/ePRA09yyOeJ+AulXsgxVLoUctU6OxSZGtYMBNna/XWG7dKkQYv3K6qwzHPUA13j0FvfB5e7tgo/rEPAe0/xpbzUvXOfYT1/QTqMXw3i0vZjjSge3p/huNhd0CIJ+fdrKnHzgZo4cKwK6paCVeiU8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768232968; c=relaxed/simple;
	bh=qFAIew+HUj0pBGxwb69/YJUK9UUI0gZ1h/a+ey4adlA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sq9s4mr7nsnKbOMKqF2hxXTS3k2s5qBV6r9DpBSv2vWxobDdmVyS8oMJITNtIvUehkSvb5L1EpqfAfIjS4gKfMmjxk7z7W/RPN7c+Lg1JfSul0LtmUadP+PHGNE0aS6OJCbVfskApzTzvMrEtZwqBWPJxir1NXmzIBlwvMtIiRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=n0Ej22H0; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gGHKU85DairNbTDDv7Ab60aqAsyqXE7EFloTuAjpO/w=;
	b=n0Ej22H00J33qfh407SWOPTM61+OAowv9/At5KF0/kWraryv/06LOzmkt7ZE0nZqV5dPmxmMd
	a7dOXW38JKkWo7vnm+mHSotDI8KTyoAa1Wj1+j+F933Rp6RcFinnswhGRN3AZjdidhh6zQdTnii
	/Nu1BYLtKveggoL5/KbB27E=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqcFB5qGJz1P7cm;
	Mon, 12 Jan 2026 23:46:54 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqcHl1kTZzJ467Y;
	Mon, 12 Jan 2026 23:49:07 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id CF0FA40569;
	Mon, 12 Jan 2026 23:49:18 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 15:49:18 +0000
Date: Mon, 12 Jan 2026 15:49:16 +0000
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
Subject: Re: [PATCH v3 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Message-ID: <20260112154916.00002911@huawei.com>
In-Reply-To: <20260109170400.1585048-16-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-16-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:44 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change introduces GICv5 load/put. Additionally, it plumbs in
> save/restore for:
> 
> * PPIs (ICH_PPI_x_EL2 regs)
> * ICH_VMCR_EL2
> * ICH_APR_EL2
> * ICC_ICSR_EL1
> 
> A GICv5-specific enable bit is added to struct vgic_vmcr as this
> differs from previous GICs. On GICv5-native systems, the VMCR only
> contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
> the priority mask (PCR).
> 
> A struct gicv5_vpe is also introduced. This currently only contains a
> single field - bool resident - which is used to track if a VPE is
> currently running or not, and is used to avoid a case of double load
> or double put on the WFI path for a vCPU. This struct will be extended
> as additional GICv5 support is merged, specifically for VPE doorbells.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

One comment below.

> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
>  arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
>  arch/arm64/kvm/vgic/vgic.h         |  7 +++
>  include/kvm/arm_vgic.h             |  2 +
>  include/linux/irqchip/arm-gic-v5.h |  5 ++
>  7 files changed, 141 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c23e22ffac080..bc446a5d94d68 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  /* Save VGICv3 state on non-VHE systems */
>  static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
>  {
> +	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5) {

Why can't you use the helper? e.g

	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
Whilst kvm/arm_vgic.h isn't directly included here other stuff from that header
is in use like kvm_vgic_global_state.


> +		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
> +		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
> +		return;
> +	}
> +
>  	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
>  		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
>  		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
> @@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
>  /* Restore VGICv3 state on non-VHE systems */
>  static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
>  {
> +	if (kern_hyp_va(vcpu->kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5) {
> +		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
> +		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
> +		return;
> +	}
> +




