Return-Path: <kvm+bounces-26131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53DD971DED
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F13251C23375
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A146E136E28;
	Mon,  9 Sep 2024 15:20:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC3C13635D
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725895203; cv=none; b=utttfre/0q8OYCxijZK5npqIRveEt2GuLMECx3cpHwC75EssR08yzBRTIYpbvgUxuaM0y09o0LxgELZ3rREuK83U+6Z6WSXKUBJaoLjatgibNpZEyQN1GsBDVjF/y6C2GNbKdX9HsLWOotIUs2nCGcF7Dk/0ABFe+iiK3p0fLdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725895203; c=relaxed/simple;
	bh=NbCI0cPkIwWDZXrCjRlTBDISd5Iah3+OZSNz5k11OEY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cnqS6HQxyMJyk/atByZN5hdXOxJ6CZBqawgfxTxNO5LAgUArg0DEqk9z7AdWP9o5cHAcc9zaJ5ow+g0Hw1cUUMNFW7YQ807VA0W8NaB8dqBfTRdKR/k8xsERELsR9IUrPVZQb6xE0XsLP+Sj+cHtmEP9H/VNqDcRUb0wYUjdgpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X2Vnl2PdpzfbwL;
	Mon,  9 Sep 2024 23:17:47 +0800 (CST)
Received: from kwepemd100010.china.huawei.com (unknown [7.221.188.107])
	by mail.maildlp.com (Postfix) with ESMTPS id 08B6318010A;
	Mon,  9 Sep 2024 23:19:57 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemd100010.china.huawei.com (7.221.188.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Mon, 9 Sep 2024 23:19:56 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 9 Sep 2024 16:19:54 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Sebastian Ott <sebott@redhat.com>
CC: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shaoqin Huang
	<shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>
Subject: RE: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Topic: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Index: AQHawm/0TP9B4WSU3kSdeZvzR1wQjLJQDNGg
Date: Mon, 9 Sep 2024 15:19:54 +0000
Message-ID: <0db19a081d9e41f08b0043baeef16f16@huawei.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
 <20240619174036.483943-8-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-8-oliver.upton@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Oliver/Sebastian,

> -----Original Message-----
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Wednesday, June 19, 2024 6:41 PM
> To: kvmarm@lists.linux.dev
> Cc: Marc Zyngier <maz@kernel.org>; James Morse
> <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> yuzenghui <yuzenghui@huawei.com>; kvm@vger.kernel.org; Sebastian Ott
> <sebott@redhat.com>; Shaoqin Huang <shahuang@redhat.com>; Eric Auger
> <eric.auger@redhat.com>; Oliver Upton <oliver.upton@linux.dev>
> Subject: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
> register

[...]=20
=20
> @@ -2487,7 +2490,10 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D
> {
>  	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
>  	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
>  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown,
> CSSELR_EL1 },
> -	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
> +	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
> +			     CTR_EL0_IDC_MASK |
> +			     CTR_EL0_DminLine_MASK |
> +			     CTR_EL0_IminLine_MASK),

(Sorry if this was discussed earlier, but I couldn't locate it anywhere.)

Is there a reason why we can't make the L1Ip writable as well here?
We do have hardware that reports VIPT and PIPT for L11p.

The comment here states,
https://elixir.bootlin.com/linux/v6.11-rc7/source/arch/arm64/kernel/cpufeat=
ure.c#L489

" If we have differing I-cache policies, report it as the weakest - VIPT."

Does this also mean it is safe to downgrade the PIPT to VIPT for Guest as w=
ell?

Please let me know.

Thanks,
Shameer



