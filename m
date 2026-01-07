Return-Path: <kvm+bounces-67214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A4ACFD3A0
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 11:40:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B355C3021FAD
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 10:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974DF2C21CC;
	Wed,  7 Jan 2026 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gDF2IkL2"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E523EA95
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767781860; cv=none; b=GWTU43ZE4aLDSdMsMzEORXo5kPViqJaK7QCTKDdMcAs9KI4zH75vXHuV6miiKq56D0Jpw4wpd2G4lWxA+ed2Ijj0oDq2aKbpA0AnTMQk859qzxr4v7HTE2iytVQQNuwYsaA2dMKws6MKirDGUWQtof7QGxS4Yp8MozMEvOOSAeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767781860; c=relaxed/simple;
	bh=y66d4ZsBbdgMNhfmUFwWifieGmqMWXkMURwj5GPCb/U=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZD0GwqU1FahW0GYX4JAxehubymd7wdqtM7vNoP03QtvvQ7YZVx7+RVum+2lc4TH2q5fJDne/LHn5OBgpTJWLLCOcTJKmo8YIV8NC9p+3OQ/x+ZPU4Ce3kXdKX+kx4jmutdDni+MWX9Pz0y3KpWfa6SaaHNOHD33aa3k6aVwrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gDF2IkL2; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wJh6sKL4QAS0b5S62m0cU+/CYmQY81urSbcRIZncouY=;
	b=gDF2IkL2fkPSOMme51XAPHStUfn6PruUAX6/XTpIPVF0kQcFxsaEcEtPgPgO5HSxHzSN1EMWF
	H5wpyqkB4h7bJKalruKXUh7EBPX+qt13LVkKRiEuxy5yLbmf664NBa7T1NlVZ4NYjjbm6h/5l8e
	z64WxAyj0kiJLM3fwqJhJKs=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dmPQL5KS1zN1J4;
	Wed,  7 Jan 2026 18:28:42 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmPSj6cKszJ46dr;
	Wed,  7 Jan 2026 18:30:45 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F2C6240565;
	Wed,  7 Jan 2026 18:30:48 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 10:30:45 +0000
Date: Wed, 7 Jan 2026 10:30:44 +0000
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
Subject: Re: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Message-ID: <20260107103044.00000df0@huawei.com>
In-Reply-To: <20251219155222.1383109-9-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-9-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:38 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> There are times when it is desirable to have more than one return
> value for a hyp call. Split out kvm_call_hyp_nvhe_res from
> kvm_call_hyp_nvhe such that it is possible to directly provide struct
> arm_smccc_res from the calling code. Thereby, additional return values
> can be stored in res.a2, etc.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
One question inline, mostly because I'm curious rather than a suggestion
to change anything

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b552a1e03848c..971b153b0a3fa 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1208,14 +1208,19 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
> -#define kvm_call_hyp_nvhe(f, ...)						\
> +#define kvm_call_hyp_nvhe_res(res, f, ...)				\
>  	({								\
> -		struct arm_smccc_res res;				\
> -									\
> +		struct arm_smccc_res *__res = res;			\

What's the purpose of the local variable? Type sanity check?
Feels like typecheck() would make the intent clearer.
Meh. Not used anywhere in arch/arm64 so maybe not.



>  		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
> -				  ##__VA_ARGS__, &res);			\
> -		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
> +				  ##__VA_ARGS__, __res);		\
> +		WARN_ON(__res->a0 != SMCCC_RET_SUCCESS);		\
> +	})
> +
> +#define kvm_call_hyp_nvhe(f, ...)					\
> +	({								\
> +		struct arm_smccc_res res;				\
>  									\
> +		kvm_call_hyp_nvhe_res(&res, f, ##__VA_ARGS__);		\
>  		res.a1;							\
>  	})
>  


