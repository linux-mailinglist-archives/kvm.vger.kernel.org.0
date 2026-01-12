Return-Path: <kvm+bounces-67763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E10F2D134C7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF9C430390EE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6161B2BE7DB;
	Mon, 12 Jan 2026 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cymrG1ZG"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED5D2BE057
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229168; cv=none; b=VI0zIl8x97xumF/0JnIZR9PoF9LL91YC14mdlg1NTrXMh80z8laID09EZOOIk3q55SXsRpWdNzIs/91umfjfEMyL0NYP0HnynXF+qLwgGj6iO9fsTL+ptunMMIvyUKqX9f8DkiLRTwnP9/KSviEGJZ+7tat1bm5lzM+HgfPIv+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229168; c=relaxed/simple;
	bh=XTb/z7XQHfqLK7sr7EOs9zX6RbyrCrneAOhhEaggHi0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9qvVqmBn8Ho5+XktYBNN03wF+zirBEkFkjYkImWeZzvG8UFVNBlMahFauJV8ZL22CVI5hYvclxQuQZIf68PZ5MKqteRrKhQbbpDkjvil4ujN0vACs0+0Yafap+q9bHkDvOLds2G4HBPLjtDLgeNaVsJ0OJEBzglUi1EChoNvOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cymrG1ZG; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wcfwhviD+3DU7mCwVMqId0aDxEX8Zf7Gb4cXQFIqiJE=;
	b=cymrG1ZGTAoPDiXOPvfmXEmEO3QuJDyHKc2mCo5XgFtXJvy3YkdKwXCnNOL2WCsFJF4d8cfNS
	ViQMtxAng/+5BPzJSCSU9viuiAANmEBrP8CCtCqONNB4Iqxz84Wdf6Vni566ISQlrLN7AY1mh+y
	CVcmEsMhCElbt3/ge2mtLmE=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqZr76Yr0z1P7Js;
	Mon, 12 Jan 2026 22:43:35 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZth3MXmzJ46Ck;
	Mon, 12 Jan 2026 22:45:48 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0049040539;
	Mon, 12 Jan 2026 22:46:00 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:45:59 +0000
Date: Mon, 12 Jan 2026 14:45:57 +0000
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
Subject: Re: [PATCH v3 09/36] KVM: arm64: gic-v5: Add Arm copyright header
Message-ID: <20260112144557.00005986@huawei.com>
In-Reply-To: <20260109170400.1585048-10-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-10-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:41 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This header was mistakenly omitted during the creation of this
> file. Add it now. Better late than never.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Thanks for splitting it out.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 2d3811f4e1174..23d0a495d855e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1,4 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025, 2026 Arm Ltd.
> + */
>  
>  #include <kvm/arm_vgic.h>
>  #include <linux/irqchip/arm-vgic-info.h>


