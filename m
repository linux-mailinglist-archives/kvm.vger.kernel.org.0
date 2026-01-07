Return-Path: <kvm+bounces-67223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB92CFDAEB
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 13:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B742B309AD96
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 12:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A23831196C;
	Wed,  7 Jan 2026 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="q9N3uFMY"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F8530C361
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788944; cv=none; b=gDHSbUkg8B/joyJ+Pwau0T/8ck3sX/lCK/XwrPHar4U0XbvW3fKI3g7SLXONVVvAJs4C1tNxAIVeguDwRqoiA/6Q2LXoj/xBZWN7yZQRoXNUVpY5tPbwEdp5WMHBwhGwDzHCamDKV/7BqHUaXn7zP8p2OIysD7k8cnAP/xoQkMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788944; c=relaxed/simple;
	bh=FFCdQvw4G/Pjf64xgqggp0TD4BOQcvLgeB3ZH6bO+oQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cM7MY4Arkvgcw6TB9UDtG2+D481M1gFeu83QJrZfVi6iUlougyFqNpm2RW+pmh8L/NF/gnZ5NpQuIBfEWD2HkpqFlAdyu2jZNVYQ8hkdLvF+P3C//jsnsr4qHdDTro3BcQxFAss86I2Yk97qBywn8sVV03q/jT+OEupVBplO+fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=q9N3uFMY; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Dj6UfPJfB6pGRAhSwf9NayQstkd63pLUii227xs7tgU=;
	b=q9N3uFMYnsif4vSvN4HobhRe4RqLxBvrzgOayPb1BqFgTC5hvm/lInUjmr4agrRAElQ2fJMDN
	BN66A4ozyvMKXlQZy6jh1vDVtSL2MOT95MGpqMb1BUtHemdvBoPa7aBMoqDYqwIyrIXV1LGt+7V
	TtRrKkv085GuIKf6n4frqMk=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmS2K2Gqlz1P6ht;
	Wed,  7 Jan 2026 20:26:33 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmS511pmFzJ46Zl;
	Wed,  7 Jan 2026 20:28:53 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E03440570;
	Wed,  7 Jan 2026 20:28:56 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 12:28:55 +0000
Date: Wed, 7 Jan 2026 12:28:53 +0000
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
Subject: Re: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Message-ID: <20260107122853.0000131c@huawei.com>
In-Reply-To: <20251219155222.1383109-16-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-16-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:41 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This change introduces GICv5 load/put. Additionally, it plumbs in
> save/restore for:
> 
> * PPIs (ICH_PPI_x_EL2 regs)
> * ICH_VMCR_EL2
> * ICH_APR_EL2
> * ICC_ICSR_EL1
> 
> A GICv5-specific enable bit is added to struct vgic_vmcr as this
> differs from previous GICs. On GICv5-native systems, the VMCR only
> contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
> the priority mask (PCR).
> 
> A struct gicv5_vpe is also introduced. This currently only contains a
> single field - bool resident - which is used to track if a VPE is
> currently running or not, and is used to avoid a case of double load
> or double put on the WFI path for a vCPU. This struct will be extended
> as additional GICv5 support is merged, specifically for VPE doorbells.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>


> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 1fe1790f1f874..168447ee3fbed 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1,4 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 Arm Ltd.
> + */

Why in this patch?  It's trivial enough that maybe it doesn't need to be
on it's own, but the first patch touching this file seems like a more
logical place to find it.






