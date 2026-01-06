Return-Path: <kvm+bounces-67163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8808BCFA59C
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 19:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 618F13401D40
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C753B339B5B;
	Tue,  6 Jan 2026 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="b1uDB+j5"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61562D7810
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722917; cv=none; b=dF8Jg17SXsdeGJMxN0IB06E8m1gFkWsX5RFCnj6lGEHc7eXmnuwAYlOuUV5fnXzzb04VTuon6DuN7uH9j/hFP6h+MB4S1LMN1lXM4EARVwUW5ZQw6fYNGu+Ied4ZqsY6HRxOmN+A6ibNF7nRhzMVDnUYcpJWxVGCRhpsoEyP4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722917; c=relaxed/simple;
	bh=6kcghfu5O79TqLucQGZBy8XqbwXkYYTb6Hqta1vf5fY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8+1f7HRPnv0raOJzayyPE4I9e3sET64zRH94bxu/rXcRIskBLWICcpwcOc9OYTlFlOMiwY2z5cQA3DumTcX7ktwd5k44IIhqIb1wSOLIVBERyKeocdyNiChP70kxdWBp0ZSTNzSrbXKRdTTQqUR163r7/7mf0pd3FCXC8s8Z6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=b1uDB+j5; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sDv1QnnUOF68a8kXkDA6TOieF24PvJ5g67KKk/Nk94o=;
	b=b1uDB+j52vLbyZwJVrpn81CB1AaJzX5AG703pfb11++Y9qfjni/sDs4GEy96hc6Y3ejo5rKcK
	nRU4D95rdDFuVDtv2E9HSSbZu9d0/rbxVkg5Q+uRqHyySlsm1OQP8Qpf8hTEggQNtqCsTk0XOgE
	uUPQQWqtOnkerh/YbP7LPy8=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dlzcs1hvmz1vns1;
	Wed,  7 Jan 2026 02:06:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlzgB4sp9zHnGhr;
	Wed,  7 Jan 2026 02:08:22 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A6374057E;
	Wed,  7 Jan 2026 02:08:27 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 18:08:26 +0000
Date: Tue, 6 Jan 2026 18:08:24 +0000
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
Subject: Re: [PATCH v2 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Message-ID: <20260106180824.00005516@huawei.com>
In-Reply-To: <20251219155222.1383109-6-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-6-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:37 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> The encoding for the GICR CDNMIA system instruction is thus far unused
> (and shall remain unused for the time being). However, in order to
> plumb the FGTs into KVM correctly, KVM needs to be made aware of the
> encoding of this system instruction.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b3b8b8cd7bf1e..e99acb6dbd5d8 100644
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
> +#define GICV5_GIC_CDNMIA_VALID_MASK	BIT_ULL(32)
> +#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GIC_CDNMIA_VALID_MASK, r)

Why the R for just this one?

There is precedence with GICV5_GICR_CDIA_VALID() but I've no idea
why that one got the R (and not the field definitions next to it)
either!

Lorenzo, guessing that was in your main gicv5 series?

Given it's GICR CDIA (and here GICR CDNMIA) in the spec, I think
all the definitions should have the R but maybe I'm missing something.

Jonathan


> +#define GICV5_GIC_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
> +#define GICV5_GIC_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
> +
>  #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
>  #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
>  


