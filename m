Return-Path: <kvm+bounces-67216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD63CFD49E
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 11:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9CE583002534
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 10:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D897921257A;
	Wed,  7 Jan 2026 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VWJ+Pn74"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063772D8387
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767783495; cv=none; b=Rc7zc7bR9U1ngFXYYXf1i3JrkhqVWDCpLBB/V15OQNSgEahXU0sZjmNM2D9zNfHvUkaIizmda9Q36Iex/k8QtG3ruvxpCQ/KwwfeZfADk1WVG9d0DS87u6VcJOKmAQdsz+l+vEarn2QjwbUhFfQn+veE8dvX+tiK2F30x0wtTq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767783495; c=relaxed/simple;
	bh=Tc7IoBiq0CLhW/HNEeDsOCsmG5LwIxgG3/MVfsZSI3s=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KypZPq0u/4aiC/6pQbVPJfBajMwFHQdolHjLh9Jeff2JjJ/7ZKASRB+3d4luqnQelqFFK+j3kXA7VT/b7QtLWla8O0PcZhi7Hr/2u19vY69ZGwkJ1i6JBgCNQtUr7wwvvynm13E/08eLRp9e1Dbr7vCktBUPq+nT64RG3In1zSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VWJ+Pn74; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=o36XW1wZmQ5DnGANByjWTcEV1w3uIGgWcFre6wKHTSA=;
	b=VWJ+Pn74iZNKylK0KOVQP2zcJKnOG/BMu2GpLmwoxNHTkjh+urkMPHYTlHorTpbHUibT4gEak
	Bw4nkAnxf2zokTZemiqK+1jj3HeGBIraDevRp5A/x/IQGSsZGjXInCp/GctPZDAlbSiPc1tVsfd
	JI9q0aXMUxqKKVNd7vXGE/Q=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dmQ1q2chHzMvmj;
	Wed,  7 Jan 2026 18:55:59 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmQ474lXpzHnH7f;
	Wed,  7 Jan 2026 18:57:59 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A70D340569;
	Wed,  7 Jan 2026 18:58:05 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 10:58:04 +0000
Date: Wed, 7 Jan 2026 10:58:03 +0000
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
Subject: Re: [PATCH v2 10/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Message-ID: <20260107105803.000050be@huawei.com>
In-Reply-To: <20251219155222.1383109-11-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-11-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Set the guest's view of the GCIE field to IMP when running a GICv5 VM,
> NI otherwise. Reject any writes to the register that try to do
> anything but set GCIE to IMP when running a GICv5 VM.
> 
> As part of this change, we also introduce vgic_is_v5(kvm), in order to
> check if the guest is a GICv5-native VM. We're also required to extend
> vgic_is_v3_compat to check for the actual vgic_model. This has one
> potential issue - if any of the vgic_is_v* checks are used prior to
> setting the vgic_model (that is, before kvm_vgic_create) then
> vgic_model will be set to 0, which can result in a false-positive.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Hi Sascha, Timothy

The masking of val has me a little confused in the sanitize function.
Probably needs a slightly rewrite.

Jonathan

> ---
>  arch/arm64/kvm/sys_regs.c  | 39 ++++++++++++++++++++++++++++++--------
>  arch/arm64/kvm/vgic/vgic.h | 10 +++++++++-
>  2 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c8fd7c6a12a13..a065f8939bc8f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
>  
>  static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>  static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
> +static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
>  static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>  
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> @@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
>  		val = sanitise_id_aa64pfr1_el1(vcpu, val);
>  		break;
>  	case SYS_ID_AA64PFR2_EL1:
> -		val &= ID_AA64PFR2_EL1_FPMR |
> -			(kvm_has_mte(vcpu->kvm) ?
> -			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
> -			 0);
> +		val = sanitise_id_aa64pfr2_el1(vcpu, val);
>  		break;
>  	case SYS_ID_AA64ISAR1_EL1:
>  		if (!vcpu_has_ptrauth(vcpu))
> @@ -2024,6 +2022,20 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val)
>  	return val;
>  }
>  
> +static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{

The code flow in here seems confusing, so maybe needs a rethink even if it
works.  Feels like we need a mask first of everything the kernel understands,
then specific masking out / setting of parts for each feature.
I'm not sure if the initial mask is handled by the caller (didn't check but
it's in the register array structure).
Also I love crossing specs where the gicv5 spec says all the other fields are
reserved and they aren't any more.  Would have been better if that had
just said see arm arm for the other parts of this register.

> +	val &= ID_AA64PFR2_EL1_FPMR |
> +		(kvm_has_mte(vcpu->kvm) ?
> +			ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY : 0);

So this either masks out everything other than FPRM or masks out everything other
than EL1_MTEFAR, EL1_MTESTORE_ONLY and FPMR.

Hence...

> +
> +	if (vgic_is_v5(vcpu->kvm)) {
> +		val &= ~ID_AA64PFR2_EL1_GCIE_MASK;

This is doing nothing as that field isn't set anyway in either of the earlier
possible maskings of val.

> +		val |= SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
> +	}
> +
> +	return val;
> +}



