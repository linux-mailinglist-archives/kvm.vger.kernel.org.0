Return-Path: <kvm+bounces-67244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 65391CFF055
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 18:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 06D643061939
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1A336C5BC;
	Wed,  7 Jan 2026 16:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="uSP1mgVR"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B99836A025
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802922; cv=none; b=I3zbyOMPK8SD4mTJ1I19+auFZvSR8rWFf+etp3QujDutfILgKcxrK4D0Gd6W+HGTd5bcwqUtaj8Rx0dMLE/gVvMKXB4lpsHCLPAdVo8IE324JWRLsDTfedvzm9vCTb8+9G2UD5Zl+J/baUaZmS6gBA/Lm8yakjBmGhxvW9rF6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802922; c=relaxed/simple;
	bh=tLxl9sIb3ZFFyAMkX2pgiVXJWCk+uwqY54exwbJe1NU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSn9vg/f77xNI5PSvdTP1yMSlC7Sgivs/W51Wdd9kI1OuyHDg23fMF3rjJ/Dq1tTdwDz+TW5/wau0KQkPm5zhgH1chsKfMk54VEIGR7O233VUo+SGh/gF6cvKd375uWDyzk0G5vLUxX9YlRzalDWLdcFoe9kFKC//jeiqXpzvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=uSP1mgVR; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xadTztksFTVn2im+cWJVadEdaf24OWXXzLmCMbGLiYQ=;
	b=uSP1mgVRHj/kzZz0H4vCQq9XlMlnL+FmkErAnpAs/AI5ghQbDYpaKf3JSj0yYG+yrbQzNAmwW
	0QzGK2CW5s07CmWq8VhqZ5VN+qoWoPS2JRBD4iOh0zSOtXD2OZkj3d/n5NPeu5Vgza0G1hnibJY
	45d7Syw8q/i2CekMc8KCU+M=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmYBx6y0rz1P7Kb;
	Thu,  8 Jan 2026 00:19:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmYFZ4vwszHnGfP;
	Thu,  8 Jan 2026 00:21:38 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 222D440086;
	Thu,  8 Jan 2026 00:21:45 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:21:44 +0000
Date: Wed, 7 Jan 2026 16:21:42 +0000
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
Subject: Re: [PATCH v2 32/36] irqchip/gic-v5: Check if impl is virt capable
Message-ID: <20260107162142.00007e3f@huawei.com>
In-Reply-To: <20251219155222.1383109-33-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-33-sascha.bischoff@arm.com>
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

> Now that there is support for creating a GICv5-based guest with KVM,
> check that the hardware itself supports virtualisation, skipping the
> setting of struct gic_kvm_info if not.
> 
> Note: If native GICv5 virt is not supported, then nor is
> FEAT_GCIE_LEGACY, so we are able to skip altogether.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

