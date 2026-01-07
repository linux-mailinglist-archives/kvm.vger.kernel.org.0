Return-Path: <kvm+bounces-67218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2B1CFD5F3
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 12:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 26EC93001BEF
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 11:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04B0308F05;
	Wed,  7 Jan 2026 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="RR2OQnXM"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB9308F3A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 11:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767784770; cv=none; b=QE2BL5Ps/oB3Wa0KL00VJUQyCfCDXIckZP7dHRVS53QtkKJJAs8S91fkrKlG94CAmem2XZHc3UoRvmCZZbJ6Q/QOUVzlac7neETWzpT7ZBpn5iLKnKwfmMAoUMzTZ9XsDJZQrjn5tpilWhfrdH0ig3jG0RCSk0/xVj8PZfnD4R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767784770; c=relaxed/simple;
	bh=p3upgpqcyPXcVAGuSKJJgmgj4MuGiUrvRQn8UCLNKC8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DK37HA2thkaG74EXwt5o18CzbjHvz4qjzZdAxVFrCvGz5AOUl5fDSY91qTkgadrxGxsw27dvtAUYkNZkI4zQKcVz02MPqzcp7fcdjTw6Yes/dbPM6eDCYjqnK//feO12RtLsZ3DUCi9A/SVi76cuawWgAsDJ6XEnhl6fMEoAMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=RR2OQnXM; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R2ekXdwkRaQOz3Sz8euHH7R8sRGKGoQ61Xj6VYJaUFo=;
	b=RR2OQnXMbTS/HVamxAIuS9XrpdZf8asUYRx9ouGYFlJ0jf+C0JB+qXwNh1m29HysXLAYNkZ9P
	y17RdxnYQm7UenfQxVnyMb+hjXIxUjgd7O2+NnJXTzW6fKu8Yufm7egOx8nfNLGw6Uxvot8WNBa
	flu/arIx3XDvKl0Z5dLw2SY=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dmQVL1HMVz1vp2G;
	Wed,  7 Jan 2026 19:17:14 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmQXk0SNczJ46mZ;
	Wed,  7 Jan 2026 19:19:18 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D57A40570;
	Wed,  7 Jan 2026 19:19:21 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 11:19:20 +0000
Date: Wed, 7 Jan 2026 11:19:18 +0000
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
Subject: Re: [PATCH v2 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Message-ID: <20260107111918.000037f7@huawei.com>
In-Reply-To: <20251219155222.1383109-12-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-12-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Extend the existing FGT/FGU infrastructure to include the GICv5 trap
> registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
> involves mapping the trap registers and their bits to the
> corresponding feature that introduces them (FEAT_GCIE for all, in this
> case), and mapping each trap bit to the system register/instruction
> controlled by it.
>=20
> As of this change, none of the GICv5 instructions or register accesses
> are being trapped.
>=20
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Hi Sascha,

Superficial stuff only on code flow to make it easier to extend next
time.

Jonathan


> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 3845b188551b6..5f57dc07cc482 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c

> @@ -1511,11 +1595,19 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  	__compute_fgt(vcpu, HAFGRTR_EL2);
> =20
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
> -		return;
> +		goto skip_fgt2;

Nicer to avoid more complex code flow and just make the next
block an if.

	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
		__compute_fgt(vcpu, HFGRTR2_EL2);
		__compute_fgt(vcpu, HFGWTR2_EL2);
		__compute_fgt(vcpu, HFGITR2_EL2);
		__compute_fgt(vcpu, HDFGRTR2_EL2);
		__compute_fgt(vcpu, HDFGWTR2_EL2);
	}
> =20
>  	__compute_fgt(vcpu, HFGRTR2_EL2);
>  	__compute_fgt(vcpu, HFGWTR2_EL2);
>  	__compute_fgt(vcpu, HFGITR2_EL2);
>  	__compute_fgt(vcpu, HDFGRTR2_EL2);
>  	__compute_fgt(vcpu, HDFGWTR2_EL2);
> +
> +skip_fgt2:
> +	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
Given the above shows this code sometimes gets extended I'd
be tempted to just go with
	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
		__compute_fgt(vcpu, ICH_HFGITR_EL2);
	}

=46rom the start and avoid future churn or goto nasties.

>=09
> +		return;
> +
> +	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
> +	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
> +	__compute_fgt(vcpu, ICH_HFGITR_EL2);
>  }




