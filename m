Return-Path: <kvm+bounces-67224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3242ACFDB57
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 13:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9E3973002143
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 12:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD41315D23;
	Wed,  7 Jan 2026 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="fphM9sz7"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45CC3090D7
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 12:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767789244; cv=none; b=oTgv4R34Nd8uDmdcoRaHQ4UxvYEuUzS6OK111/SXFUuoXRVImJdOKlOMRt9VJ5Gy7nvH+bUlsSnc3bZaS5CxIQIHsRyqgkvsiwfHKZpCU4BnWqIRGwqWoxu5gXWe4t7sGWE8WaPNmXVbaibz2+BNE6FaN2cVTIReOl/zSMy3sdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767789244; c=relaxed/simple;
	bh=/wmbG8E71eAN12r4lBeknEL5wNQYSlmOIuvkOGB9wzI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9D8UIsFULPo9cCt+PTO3ZiEq85Fc/iDLMkGqfu/oJaqnurWSMTZjQxMMf+AFAEtwz8UYghLeyFNN+DvgH6w4vXNHotbdrgbf1Xjqs36tmwFLmAMvnzPfYKNbW3QKKaADZrq/jDjKDB/ArQq+8O40Xxj5DASDM+cqDP1VZMxuH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=fphM9sz7; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2/k7aRIMSsRlFmo4uSbFPpMf5BgB8CzmDNkN1SVEfQc=;
	b=fphM9sz76LXP1qBy6IXllFB6u1bhkKCguaF4iI1BUY5jX8pxr0FW6FtNb0STaafF/R6Gn6gMT
	1lEk6xHr3nhSZfUDWhrRco7JB8BBaKCQprCpVopAER8fQv0U5oOnVh3z1HutxdGIXy+utraf4O+
	+p6oqJp4hiZTGHiRBzAl+t0=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmRm63xNTz1P7S0;
	Wed,  7 Jan 2026 20:14:14 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmRpn6007zJ46Df;
	Wed,  7 Jan 2026 20:16:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 01D6A4056F;
	Wed,  7 Jan 2026 20:16:37 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 12:16:35 +0000
Date: Wed, 7 Jan 2026 12:16:34 +0000
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
Subject: Re: [PATCH v2 16/36] KVM: arm64: gic-v5: Implement direct injection
 of PPIs
Message-ID: <20260107121634.00000c13@huawei.com>
In-Reply-To: <20251219155222.1383109-17-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-17-sascha.bischoff@arm.com>
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

> GICv5 is able to directly inject PPI pending state into a guest using
> a mechanism called DVI whereby the pending bit for a paticular PPI is
> driven directly by the physically-connected hardware. This mechanism
> itself doesn't allow for any ID translation, so the host interrupt is
> directly mapped into a guest with the same interrupt ID.
> 
> When mapping a virtual interrupt to a physical interrupt via
> kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
> PPI or not. If it is, and the host's interrupt ID matches that used
> for the guest DVI is enabled, and the interrupt itself is marked as
> directly_injected.
> 
> When the interrupt is unmapped again, this process is reversed, and
> DVI is disabled for the interrupt again.
> 
> Note: the expectation is that a directly injected PPI is disabled on
> the host while the guest state is loaded. The reason is that although
> DVI is enabled to drive the guest's pending state directly, the host
> pending state also remains driven. In order to avoid the same PPI
> firing on both the host and the guest, the host's interrupt must be
> disabled (masked). This is left up to the code that owns the device
> generating the PPI as this needs to be handled on a per-VM basis. One
> VM might use DVI, while another might not, in which case the physical
> PPI should be enabled for the latter.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



