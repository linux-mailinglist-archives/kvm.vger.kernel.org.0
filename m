Return-Path: <kvm+bounces-67761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4AECD13599
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7C43230499D1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B6EA24BBFD;
	Mon, 12 Jan 2026 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="MMHPZ50S"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064FF26F2B9
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768228869; cv=none; b=XFZHkIoYbXEC75Gl9MCYxANLrXFcj8TP9kAWoo9WVipi0TXQbP6yf4+c1sx1L93MqbN0D2xSnpacFYm2CkbYTeOpU2l/eC+TbOF1m64nr9v3VvCETlfpZDSm1aI1OtKhSHI2fS/a3HT2TEWb2s0qea8SQ4n3TrDxQUy9V3YlUKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768228869; c=relaxed/simple;
	bh=6UKMqyK90yAWNvvXvu5Wkmuf2i8c9iHwuYZLkjvBtu4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNurHum4qPNhmgEvi/hnh26t+/v7f79TeGSGfVJ+fUJLDkW84JqhS1hdv+D7INpcXtHjkzB8yYPyHK/GeX4g5w99gPxwunQFrRcC1MHme6vdC0W9zsKrP7cbhy07cWSX9UdBrXZhAcP+AlCPPiUEtemfLIUhKkXE6b6JMT0grR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=MMHPZ50S; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sQenP0CxwuCsGNI/69y3lS7YAYOZsk9pBINwUTYU7PI=;
	b=MMHPZ50SetuI/WO9k9oFpO5oheOMvKWMguXiiaA445jiamZTZBYbwwj0W8KG69uAd4f8B/Zot
	Q0cH3R3s/oDcM5NrOjeIY9pFvHmEFPFR0DCnzlyPXppHLofDpTgUMunPHS5HWfX+29H1MO0PTlz
	gUMPbBCv4ueCI75t1ZawqrM=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqZkQ1hlrz1P6nM;
	Mon, 12 Jan 2026 22:38:38 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZmy5YBjzJ46BH;
	Mon, 12 Jan 2026 22:40:50 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4950A40563;
	Mon, 12 Jan 2026 22:41:02 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:41:01 +0000
Date: Mon, 12 Jan 2026 14:41:00 +0000
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
Subject: Re: [PATCH v3 07/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Message-ID: <20260112144100.00007cda@huawei.com>
In-Reply-To: <20260109170400.1585048-8-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-8-sascha.bischoff@arm.com>
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

> This is the base GICv5 device which is to be used with the
> KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Mostly so I don't bother reading it in a potential v4 and because it's
obviously fine.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

