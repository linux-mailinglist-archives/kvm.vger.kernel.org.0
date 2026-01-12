Return-Path: <kvm+bounces-67760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3571D1346A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:47:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5081330D1205
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA10E25A34F;
	Mon, 12 Jan 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="XXqW77EI"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B14E259CAF
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768228775; cv=none; b=Bds/MOkSR8BGRIDbCNqMJNb2wX5W+FaYhdyiZCeaY3mQDwElUNuYO1QubKySirTFaDBHXV5ek2NICdA/D69IHMi93reVRZOza781+a6XHbDxVmMn439M+nSrq1KyGMYcHifRxZiqVlDC+h5v7PsrrlqTT4Q+N8wAc9Wvk0n4qXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768228775; c=relaxed/simple;
	bh=4QGIpd2556JBWc6uYugaED9VLvbemSO123/Mutbd40s=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHhiJHVaY6QRFnAYJWzt8F70ziyMOqcApiUJOPugRAfnzYdZvtgoI9iW7arFC6DBr4wJb6LNxvyfTBd2DDcsuBtDlWLk4GdxxeLpRgceK/+2Ljmv4lHzdmOWxvGN+7Y/ialR3Cyhw/w35ChdWunXOYuB1ZfpnqXE4pLjOKnWmAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=XXqW77EI; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UAy+C5sEfXpHk9jTElPcoZZz2H8yOU52jg7XT4/1ARQ=;
	b=XXqW77EI0cCltAZNyDTm3GDFWEvrwJMY1fuGWUeiV9OkUjcZuTQCVaMVhIt8o6aq0PZrF1PZA
	+5X0WjZAWjjVklkwovD2K8qsqKMNbuAvw/iKi1HdVwuYUeLTvQHNdhV5thXvNLtG+nDpkLRgbg9
	kZmNlpp7Ly8iTkCpie4afc0=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqZhb21jfz1P7Hv;
	Mon, 12 Jan 2026 22:37:03 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZl76D6bzJ46Dm;
	Mon, 12 Jan 2026 22:39:15 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 5FE5440570;
	Mon, 12 Jan 2026 22:39:27 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:39:26 +0000
Date: Mon, 12 Jan 2026 14:39:25 +0000
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
Subject: Re: [PATCH v3 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Message-ID: <20260112143925.00005226@huawei.com>
In-Reply-To: <20260109170400.1585048-6-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-6-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:40 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> The encoding for the GICR CDNMIA system instruction is thus far unused
> (and shall remain unused for the time being). However, in order to
> plumb the FGTs into KVM correctly, KVM needs to be made aware of the
> encoding of this system instruction.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

If it does make sense to clean up GICV5_GIC[R]_CDIA_...
to add the R that can happen separately.

Jonathan


> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b3b8b8cd7bf1e..97797761a07bf 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1059,6 +1059,7 @@
>  #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
>  #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
>  #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
> +#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
>  
>  /* Definitions for GIC CDAFF */
>  #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
> @@ -1105,6 +1106,12 @@
>  #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
>  #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
>  
> +/* Definitions for GICR CDNMIA */
> +#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
> +#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK, r)
> +#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
> +
>  #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
>  #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
>  


