Return-Path: <kvm+bounces-67756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27334D12FBA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 97C3B30019EA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20AA35CB9E;
	Mon, 12 Jan 2026 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="toi4ve4Z"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F435CB96
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226622; cv=none; b=oGYbinmE3FL5uQOObTncuRjh49HCaJy9xHlnxrRUx69r+vT1m8vj8+BMRBxq68WbBk8KrsahBdtOz0qTKZkg0ElaNhGzvYzkaFglDLUNSd9xM+V1RwZPkPSgSU3vIjjne+M5KeB5lcl3+dqx8GaKYHcVkb5gND+Vg9Vwvz70csE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226622; c=relaxed/simple;
	bh=seWUExliqHGtzHDDPvK7y3fwz1uenF5u/4fspeNr9Og=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbRpsIj/PIUoGMI96fadSpH/LBo5fbjidrE1NaOtp+R4ko6pacvWR/agt5UF6+DI/eB5k23YuLi9yb/oPWfesm3V1JThGt/1N1rwaB6fDQbjg+ecSnfQnP7cRPnwtwd0cgDP+Xr/X2b6XymqYfzpz0Bz7LT0zszjU5Kp7xrs0M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=toi4ve4Z; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sVORYiGzozd8PgS1TYW2hZdt+MykAODXljoXpk9UEaQ=;
	b=toi4ve4Z2YYpRNsPIV2dweYIRTGBe599kg+jTzANbb/ias1DEO500ep4ZgH1QtdPd3R49OT93
	u4G0RrtSgZGBzpuIcxHXFejABhcHZbs6RjM9MdjNuGPDKx8P3Ai7SzyNsSNdePXNE9nSG8/fSDt
	2I9owLIb/+SJ3CiCeaOSNWA=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dqYvN68Hkz1vnsZ;
	Mon, 12 Jan 2026 22:01:20 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqYxj63G8zJ46ZP;
	Mon, 12 Jan 2026 22:03:21 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 51C8340584;
	Mon, 12 Jan 2026 22:03:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:03:31 +0000
Date: Mon, 12 Jan 2026 14:03:30 +0000
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
Subject: Re: [PATCH v3 03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1
 and make RES1
Message-ID: <20260112140330.0000205c@huawei.com>
In-Reply-To: <20260109170400.1585048-4-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-4-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:39 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> The GICv5 architecture is dropping the ICC_HAPR_EL1 and ICV_HAPR_EL1
> system registers. These registers were never added to the sysregs, but
> the traps for them were.
> 
> Drop the trap bit from the ICH_HFGRTR_EL2 and make it Res1 as per the
> upcoming GICv5 spec change. Additionally, update the EL2 setup code to
> not attempt to set that bit.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
I'll take your word on it wrt to the spec change. For completeness.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/include/asm/el2_setup.h | 1 -
>  arch/arm64/tools/sysreg            | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index cacd20df1786e..07c12f4a69b41 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -225,7 +225,6 @@
>  		     ICH_HFGRTR_EL2_ICC_ICSR_EL1		| \
>  		     ICH_HFGRTR_EL2_ICC_PCR_EL1			| \
>  		     ICH_HFGRTR_EL2_ICC_HPPIR_EL1		| \
> -		     ICH_HFGRTR_EL2_ICC_HAPR_EL1		| \
>  		     ICH_HFGRTR_EL2_ICC_CR0_EL1			| \
>  		     ICH_HFGRTR_EL2_ICC_IDRn_EL1		| \
>  		     ICH_HFGRTR_EL2_ICC_APR_EL1)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8921b51866d64..dab5bfe8c9686 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4579,7 +4579,7 @@ Field	7	ICC_IAFFIDR_EL1
>  Field	6	ICC_ICSR_EL1
>  Field	5	ICC_PCR_EL1
>  Field	4	ICC_HPPIR_EL1
> -Field	3	ICC_HAPR_EL1
> +Res1	3
>  Field	2	ICC_CR0_EL1
>  Field	1	ICC_IDRn_EL1
>  Field	0	ICC_APR_EL1


