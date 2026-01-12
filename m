Return-Path: <kvm+bounces-67759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 53251D133EC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E052D30776F0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98B72BEFFB;
	Mon, 12 Jan 2026 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ODq7LQDw"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A327380A
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768228647; cv=none; b=UvahrzYIvAm9l9eCxsG06CtNu6atC4sPvwEnTxbNDRTHI2QbGSUSHdTgsPNL1Vh9Z8oFego5OHbkhdhOOjOSvS1MF41vKlLay8PGq96MLG/J9AKyoAYjLJpGTFtE0+rKhvS91BO7By1Ak7XQ0+X2Ks4CAy9QDx/z3GzB9uBtJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768228647; c=relaxed/simple;
	bh=QDDzo4ESjp7jFEvLWQnH6YUSWce7ImYeXfTjgDxTimQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlChl05PY3CfSaT+RXlVautm8QCR87kibIZ8hh+xrJkqG6+KzkllOtcMEShvDGxZ0quFiGfQa4+49ZQuMLSG0pWM/pNzg1xd5ONclklhvCh2bZ/iI+gHLUV+ZSQEga9jsSmiUOt+bOwJrLEkJO9XxRvd1bnHnoqlqN1AdiTWAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ODq7LQDw; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x0QhXSCaxvz44BA0HsV/IQ3kwCARdbhUj53s3V+cfH4=;
	b=ODq7LQDwD5asnR14b4xgrukojHgVeMiNcxUTB4BPmL2RlzuPp9D5X6Rf7FGsQEF+gLMeF8z8m
	bVcRrDpiuZBpgXFGH3NTi7+lxqlsgWvRk9eNwUTpy611wY4I9+4IuAOMiu5Zy0uRAJrADAFBGtM
	PxRAuOktYFOMPVg0JFaOxe8=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqZf041Xhz1P6jN;
	Mon, 12 Jan 2026 22:34:48 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZhY11CmzJ467X;
	Mon, 12 Jan 2026 22:37:01 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A20F040086;
	Mon, 12 Jan 2026 22:37:12 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:37:11 +0000
Date: Mon, 12 Jan 2026 14:37:10 +0000
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
Subject: Re: [PATCH v3 06/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Message-ID: <20260112143710.00007f9d@huawei.com>
In-Reply-To: <20260109170400.1585048-7-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-7-sascha.bischoff@arm.com>
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

> Different GIC types require the private IRQs to be initialised
> differently. GICv5 is the culprit as it supports both a different
> number of private IRQs, and all of these are PPIs (there are no
> SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
> encode the type, the intid also needs to computed differently.
> 
> Up until now, the GIC model has been set after initialising the
> private IRQs for a VCPU. Move this earlier to ensure that the GIC
> model is available when configuring the private IRQs. While we're at
> it, also move the setting of the in_kernel flag and implementation
> revision to keep them grouped together as before.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

