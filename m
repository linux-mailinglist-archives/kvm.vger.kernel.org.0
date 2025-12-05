Return-Path: <kvm+bounces-65314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F3BCA634F
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 07:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BA0BF3011FB9
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 06:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B862C1586;
	Fri,  5 Dec 2025 06:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b4HE+62V"
X-Original-To: kvm@vger.kernel.org
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C0F1FFC48
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 06:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764915032; cv=none; b=kxpOwk4bF3Es9zCLcqwiwUeRmx0kbrLKL4AJeq3cQqqi+eF5kmJ0465rYpj07N9uLCifitEG9Wh/YHsljJnN8adQMbPJlKmlDh7vwq6rOycFkra/LPWmYpLjaIbEkDIeILpD4xlh/yGFiBHSe/SfRg1vsO90wNSrrAeMKOIIF3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764915032; c=relaxed/simple;
	bh=OU0S8YxleBHSgQnrSpVHmmaGGmAL/50DwDKlESDCA/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2XmV1hg4JDosVCiO3eUg+V14pgXUyz4CuyjFyn4CZYQWM+2lwgo694GDMVVqoGAM/v8jkYb62ke59bfbPIGOtog9i1BHv2nDBCL1UMyE6pKOoo1y5kYsMVqUuxEYFSoBt/dbeWjMIFDP7rFtE79stTX5c4HWpd69objWo9Zi7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b4HE+62V; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764915024; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=UEapCQ/YexkXbHbXZi0Iom6o7Nizx7gI9KIuPyEGjHs=;
	b=b4HE+62VEmtFXaXNTupTaK/n2q0VuKunVCj4NTEopLWo4X0kmWajWmPQyX5jwqko5+jhQVMxBIcP+cXzbhqoyFfsJlCkXk+AiZF6/GNrKTLgPvUy23qV47VKpS4r+8jL5TU4VS7Ck1QwWAi/xUtMuNfDx66qGDe5ZCIyNXxnnuA=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0Wu6v20O_1764915024 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 14:10:24 +0800
Date: Fri, 5 Dec 2025 14:10:23 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 4/9] KVM: arm64: Handle FEAT_IDST for sysregs without
 specific handlers
Message-ID: <ibifd2p7fkwjmyfgfaerjdbzlmrabfdpepmn7zhure3s7k2aj7@wgqa7druilzt>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204094806.3846619-5-maz@kernel.org>

On Thu, Dec 04, 2025 at 09:48:01AM +0800, Marc Zyngier wrote:
> Add a bit of infrastrtcture to triage_sysreg_trap() to handle the
> case of registers falling into the Feature ID space that do not
> have a local handler.
>
> For these, we can directly apply the FEAT_IDST semantics and inject
> an EC=0x18 exception. Otherwise, an UNDEF will do.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 616eb6ad68701..fac2707221b47 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2588,6 +2588,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>
>  		params = esr_sys64_to_params(esr);
>
> +		/*
> +		 * This implements the pseudocode UnimplementedIDRegister()
> +		 * helper for the purpose of fealing with FEAT_IDST.
> +		 *
> +		 * The Feature ID space is defined as the System register
> +		 * space in AArch64 with op0==3, op1=={0, 1, 3}, CRn==0,
> +		 * CRm=={0-7}, op2=={0-7}.
> +		 */
> +		if (params.Op0 == 3 &&
> +		    !(params.Op1 & 0b100) && params.Op1 != 2 &&
> +		    params.CRn == 0 &&
> +		    !(params.CRm & 0b1000)) {

Hi Marc,

May give a macro/inline function or local variable w/ name like "is_feat_id_space()"
can simplify the long comment here. Others LGTM:

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> +			if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, IMP))
> +				kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +			else
> +				kvm_inject_undefined(vcpu);
> +
> +			return true;
> +		}
> +
>  		/*
>  		 * Check for the IMPDEF range, as per DDI0487 J.a,
>  		 * D18.3.2 Reserved encodings for IMPLEMENTATION
> --
> 2.47.3

