Return-Path: <kvm+bounces-67783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A402D141CB
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 72825301AB2A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBFC366DC9;
	Mon, 12 Jan 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gLxAo69j"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F30366DC1
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235925; cv=none; b=pumgQKLguKZugbOLE5K0v5Vb98mUXNNk7il1K4qX8TIt+0Y5JmalgohSXfhajt/BxhLIDvfmvDHUB/nnzwzwgTzGzrLWLkOpFybzhQOqolSjO8WYuCDiGg1S7+zCa3Gn865BIXcgI2RWsSmv9KYqM8PuJAhrMBLm9c6MOZAlgAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235925; c=relaxed/simple;
	bh=XfAuL2dCdn2RpuQ+Rms3Fx9OCnsWD7uLFdUSYHSJDvE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hOTwx1TNFfXZe0BYdLGBY/AT+BycwFlFpwAZIqf7CinP1n2376Ma5bHQFpHT5wtbitBiK0bNxNNoLRYjPjI+8hDNHbV60gHthsw34BaaNx1xSwrd0AKOewopJhtsPfVWFI3JxvWpp89+mWifA1BFx47PP3O5AeYx870bt4AldZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gLxAo69j; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IbXnMIQGDSMe3CUzyP4d/D+XKUJ3dpEcTHwGfhwklso=;
	b=gLxAo69jl4k+gFuf0Q2WQdDDe9i2IvGBM3ZzAKN3P7RvuWtwEKi4mYM9STxEN7VRrVLJBqDjB
	+jmAYoy99cnZ2c0gji1n/XiNnn13PJzIDpBgp0zDuiXquRbAsZUtjInpl1TAqCr/Al3zSojdVYX
	u6SXNzYSrFBPHKgdqtHcPn8=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqdL54GfPz1P7hd;
	Tue, 13 Jan 2026 00:36:13 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqdNd6zt7zJ46BR;
	Tue, 13 Jan 2026 00:38:25 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B01B40086;
	Tue, 13 Jan 2026 00:38:37 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:38:36 +0000
Date: Mon, 12 Jan 2026 16:38:35 +0000
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
Subject: Re: [PATCH v3 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Message-ID: <20260112163835.00004b2d@huawei.com>
In-Reply-To: <20260109170400.1585048-36-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-36-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:50 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> This basic selftest creates a vgic_v5 device (if supported), and tests
> that one of the PPI interrupts works as expected with a basic
> single-vCPU guest.
> 
> Upon starting, the guest enables interrupts. That means that it is
> initialising all PPIs to have reasonable priorities, but marking them
> as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
> interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
> to receive interrupts. The architected SW_PPI (64) is enabled and
> KVM_IRQ_LINE ioctl is used to inject the state into the guest.
> 
> The guest's interrupt handler has an explicit WFI in order to ensure
> that the guest skips WFI when there are pending and enabled PPI
> interrupts.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Seems fine to me, but I'm not that familiar with the self test elements, so
hopefully someone who is will review as well.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

