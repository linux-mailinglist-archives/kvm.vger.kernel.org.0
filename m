Return-Path: <kvm+bounces-67781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E470CD14126
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49C62304292A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A1D369207;
	Mon, 12 Jan 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="W6pHH4qs"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF862FA0DD
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235410; cv=none; b=Qxli2GCO3/vuaUwyMlkoyHpCyPYLcsu9IGpNwEPJCBWvKSok/4MYFhTqiCcffQHdi3rdGPPCfFH2ofRk4VZtbXxoWHKeJ7//dMxQQjA/si+YgDnYGEhtfy6ehLJCn6VPErbZzThYL/RuZxtk5Sife4WSz40DhuhjuN9bOkVO5zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235410; c=relaxed/simple;
	bh=vuE7L+1uXxM/QNh0tjk6FPVUYyh8IZQbH/76jG+2pf8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hA0YbvoQGRnPmkA2qXKxMSthjWSWi81gUEf0blv0fC12d6F06clhZIgRE6NKrrri0TlgqW0bq0k3iPqn0pSlofEofzhQRUULGf6FhSdFRmiXPKpgidtoH7+RcaxkTEyovCVTTzd8eNPl09R4g1Kr2jGiNbTTZZ4mkVUPJ0AbuFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=W6pHH4qs; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iumCkYZyOeqq6qA1Zq+gU2yZ5NWDLFCQDfxsLa8JXpo=;
	b=W6pHH4qsg6b29YAavzGeAAMkopao0UbaBSN1XIMkAOrRDLQVPGo39SIphHV6p6s1K8ykyunYn
	ur2TEBelhEkRjE/8KA2W+G/ySQTAJ00ieinUVu/SBgKTVvJYRgOjWEMDWH/B9x0V5lu5FmqX/rE
	8nCEO5kg3wQWX2S5kqW0H60=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqd8H2Jp1zMpPg;
	Tue, 13 Jan 2026 00:27:43 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqdBW449PzHnGfQ;
	Tue, 13 Jan 2026 00:29:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D766E40569;
	Tue, 13 Jan 2026 00:29:55 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:29:55 +0000
Date: Mon, 12 Jan 2026 16:29:54 +0000
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
Subject: Re: [PATCH v3 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Message-ID: <20260112162954.00002020@huawei.com>
In-Reply-To: <20260109170400.1585048-31-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-31-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 9 Jan 2026 17:04:48 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
> currently supported. All other ops are stubbed out.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

