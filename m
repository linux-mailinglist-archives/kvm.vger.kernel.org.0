Return-Path: <kvm+bounces-67217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A82CFD571
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 12:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54C5230198DB
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 11:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18ECB2F6931;
	Wed,  7 Jan 2026 11:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="R+TlE2+S"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB103019A4
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 11:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767784272; cv=none; b=ZGpk+Jxrtw4SQx3/MZtQNoYA2BZtZa8gSUKJJ+0A69vSCs6GSJRNDrfVkR+kDfCv9A2IY3E2M+eClb3KNyrUmaYB/y8tVc7o2oNeapxOsCH6iL8MuSyeHZCWbKhiOg4F5hLbmJoanE/966lqSEQDsT3/X432WmWZlslSZ5W10oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767784272; c=relaxed/simple;
	bh=EnvJGByDqeiFBbu7DEg8dusA2fTc9RCGsJA366hLzDc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ht7H5EcW3712kwLXwhh6unMthbM7MY9pvk325oIJxgyKgnlwqMv0XyIAWWwjTMqu+JhpXkxLlQpmUClfXLYYDN6OW3ApY12JfH7Z5F38l5kWSvX7grJOSfVudih17Yeeqsed5wPthCLdWS43seeh/8WhsGqjwmc2NNmtDIFOV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=R+TlE2+S; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SecVP7WSpBlgq5ksX73HzQ5ZfwvqEhbeL+mWtqsiWsQ=;
	b=R+TlE2+S/oCgwtDElh0W38XuMeV+6i8FvpekgRV5Wr9eK1/8GiqHB5OPzWj/8XzX0BdyyCAA2
	Gq7qCOWQ/eZfcYUEFikO9luztbMEcVvhqryh9Ef/p1ESgfnyIPNEcmywNitIMlrg8+BAlQs0/NB
	QjcT5fW9P3m6THkVZbA5G+w=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmQJk27pgz1vp9w;
	Wed,  7 Jan 2026 19:08:54 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmQM61hMKzJ46F9;
	Wed,  7 Jan 2026 19:10:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 544F740539;
	Wed,  7 Jan 2026 19:11:01 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 11:11:00 +0000
Date: Wed, 7 Jan 2026 11:10:56 +0000
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
Subject: Re: [PATCH v2 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Message-ID: <20260107111056.0000670d@huawei.com>
In-Reply-To: <20251219155222.1383109-13-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-13-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
> providing the IAFFID to the guest. A guest access to the
> ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
> guest accessing the host's ICC_IAFFIDR_EL1.
> 
> The virtual IAFFID is provided to the guest when it reads
> ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
> rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
> the vcpu_id as the same, and so the vcpu_id is returned.
> 
> The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
> context.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Way out of my normal domain of expertise, so comments that follow might
be completely invalid for some reason that is obvious to KVM folk.

> ---
>  arch/arm64/kvm/config.c   | 10 +++++++++-
>  arch/arm64/kvm/sys_regs.c | 16 ++++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 5f57dc07cc482..eb0c6f4d95b6d 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1582,6 +1582,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
>  		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
>  }
>  
> +static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
> +{
> +	__compute_fgt(vcpu, ICH_HFGRTR_EL2);

The other cases where there is a __compute_xxxxx that adjusts output
of __compute_fgt are seem to be about things that are optional.

I wonder a bit if a more generic solution (in __compute_fgt()) makes sense
for any thing that must always be trapped?

> +
> +	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
> +	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &= ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
> +}
> +
>  void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  {
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> @@ -1607,7 +1615,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
>  		return;
>  
> -	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
> +	__compute_ich_hfgrtr(vcpu);
>  	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
>  	__compute_fgt(vcpu, ICH_HFGITR_EL2);
>  }
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fbbd7b6ff6507..383ada0d75922 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +				const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	/*
> +	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
> +	 * is the same as the VCPU's ID.
> +	 */
> +	p->regval = FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
> +
> +	return true;
> +}
> +
>  static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
> @@ -3411,6 +3426,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
>  	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
>  	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
> +	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
>  	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
>  	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
>  	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },


