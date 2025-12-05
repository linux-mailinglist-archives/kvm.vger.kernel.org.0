Return-Path: <kvm+bounces-65313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A6828CA6312
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 07:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31F6530E7ADD
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 06:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 150D42586E8;
	Fri,  5 Dec 2025 06:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="K9x7KRnW"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF1398FB9
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 06:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764914583; cv=none; b=M9HNF9RvmOO//NlTKGHKneBbfriv1FVi6TzCenHTfxRxhC3rlsaTHYj6cih1ka7amHqp8GhYPKHRUnURXTGlF8CifZ5D2GUorb2axEtUY07rg89noCGsOZpMAL1rwqiySvIBiJWEW+Dp1uikpmaEen9H/ufNTR2k7BLMewIQOg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764914583; c=relaxed/simple;
	bh=L1CiO1rK2mXY9kEcjCfxk6MEVgo37ZeR+IQVh7VQlmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTU1EE8nRi4lf3EH3ruwrBrXaEqC05hOuhOkmWonWib4ADOzPOC1ODVVfwn674O4uqKhEW8JjvNZU3VDmo64utBPIX/RdSpaWNC7nr51W57syrdXMiH3QO3JhjT9OOc+SaxPbE+6OX2KZb/IqtHFYotSGNLZUQ8RkZ9++lASFZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=K9x7KRnW; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764914572; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=zIo92LZ9GBEyQzV+BFKrFnfKVkO6IQsZzGx3HuizYL0=;
	b=K9x7KRnWZEIJ5GC/6iD2bLn25ZlrWZcWTss+O/eb3QEnUiiVFWcJLX0yQBBLO0E7DMjuSdvT+kqP+fxiadbbDYIGne9znYCoSgqxehSThdQrqstnx1kj6dsxv+MzwQEJvmugpaGSojeomX51i5B+rdRSNj0tpcJ7EWMEH4uwELA=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wu6mAy7_1764914571 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 14:02:51 +0800
Date: Fri, 5 Dec 2025 14:02:50 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 6/9] KVM: arm64: Force trap of GMID_EL1 when the guest
 doesn't have MTE
Message-ID: <3v4gqr3eghu6gcruhhp2255pqq5s5nsaaowobaaqecpkp7an5v@vrntb3ggwecp>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-7-maz@kernel.org>

Hi Marc,
On Thu, Dec 04, 2025 at 09:48:03AM +0800, Marc Zyngier wrote:
> If our host has MTE, but the guest doesn't, make sure we set HCR_EL2.TID5
> to force GMID_EL1 being trapped. Such trap will be handled by the
> FEAT_IDST handling.
>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ae1e72df1ed45..2e94c423594eb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5558,6 +5558,8 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>
>  	if (kvm_has_mte(vcpu->kvm))
>  		vcpu->arch.hcr_el2 |= HCR_ATA;
> +	else
> +		vcpu->arch.hcr_el2 |= HCR_TID5;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  	/*
>  	 * In the absence of FGT, we cannot independently trap TLBI
> --
> 2.47.3

