Return-Path: <kvm+bounces-67245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E80DDCFF327
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9F8533BD4C0
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00C23A1CF0;
	Wed,  7 Jan 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0ja7sbtc"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E337C117
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767803160; cv=none; b=K6qIkTWD/dMtgWh5tcf3azJdQNUVN1ujWZP3jdBSWSbuYL9jf7ODT0GMCqhVHYVKc0Hyav8DgbW8H4V/PjaZbQ85ov28XmfMwW/K550ZF8GW7TlNXclgHuFp3qLlzZMvucXgI2feSx/JO+hjKfxqpcWvNVAeop9MoqADGncTgFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767803160; c=relaxed/simple;
	bh=fSPF9IlIyjzaMgppohCl9o2oOq+AgM8luMTEX4opW2k=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=roPNc/PkNdE1TjkoYPusZmHTeJ8dAtGHB+5333jbfIn6XKzS2jh7QbVJzGx8e5ZmbLUDAEMeU8zid/ga7xofVasxpG0FTxhAlY+fTN1hnP1UTvkSkxceInOVl9JiyDFm7epSWhSQYy3gW1xjKD+jSB16jz4bFpmoYaIO4U9vIrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0ja7sbtc; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GKC2PIbTfL1+/Lg5YBUCPNE5yOZPBHZcI8KCohpPjBA=;
	b=0ja7sbtclUUDZpJAn5WFnmGFr5ZxWTYf8tWulGeNZmLrMssydcJFHCy9cAUclNP9vYLEov6zU
	3dyCHiEH+MNQ4Yw35iKlGoehL0BTl9xCAZ6YQ+vKSjrotsfCBsFyb26CBUsYXv6tSMy6iTittIe
	vq9z7b9BF9OYa0sk/lkDUgU=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmYHL34fYz1P7MX;
	Thu,  8 Jan 2026 00:23:10 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYKy3sb8zHnGd2;
	Thu,  8 Jan 2026 00:25:26 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 00C5140569;
	Thu,  8 Jan 2026 00:25:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:25:32 +0000
Date: Wed, 7 Jan 2026 16:25:30 +0000
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
Subject: Re: [PATCH v2 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Message-ID: <20260107162530.0000263d@huawei.com>
In-Reply-To: <20251219155222.1383109-34-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-34-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:47 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> The basic GICv5 PPI support is now complete. Allow probing for a
> native GICv5 rather than just the legacy support.
> 
> The implementation doesn't support protected VMs with GICv5 at this
> time. Therefore, if KVM has protected mode enabled the native GICv5
> init is skipped, but legacy VMs are allowed if the hardware supports
> it.
> 
> At this stage the GICv5 KVM implementation only supports PPIs, and
> doesn't interact with the host IRS at all. This means that there is no
> need to check how many concurrent VMs or vCPUs per VM are supported by
> the IRS - the PPI support only requires the CPUIF. The support is
> artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.
> 
> With this change it becomes possible to run basic GICv5-based VMs,
> provided that they only use PPIs.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

