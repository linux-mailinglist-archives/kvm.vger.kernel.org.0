Return-Path: <kvm+bounces-67169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F21CFA920
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA9ED3073787
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 19:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAF0286890;
	Tue,  6 Jan 2026 18:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2KSl/TJP"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD372F745E
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767724478; cv=none; b=uN3iff+w1+IXUXT5t65JM4OiqjC8xAoT6twADRAnHjn7xd6L3XLJteRiJm0Dq83FNzBHfkXZofLBxXvq6UCW43d0ih3hdpIjdlG4jnDgrLaYaGPnZ/sD90QqGtxJ3sXRh/R8j/6AoWjCH1rO1EOO8kXJ6CrQqTdFuLac95WD4d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767724478; c=relaxed/simple;
	bh=oOk0XkNIm1AvnvmACSfD+JG2NwsWOnF38F7nrIS6EGg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usZUDzjJPSPZHkbSWFMyVHZXPDXALBlfzG+As11r8qSYLAwubxggF/I1p/fnoW5gKRWxYKn5zbm6KG3wN4zQmMm9g1V50sDxGzseVrzYyyyejKfxgKKDBO42BdU3Bsp/Kr5DCaSOmTVpFgb8xCMJTyO3KG9oXjYN7NSVU3oUQZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2KSl/TJP; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ul/5td8H1T0x+QBQqzJlZ3+F27WPL+8FDqm/WVZypV8=;
	b=2KSl/TJPDX29+8svmEC66f04S29aghk7Uv7DbwFp8cwfR1wWv1La8ecfxy0KA/dO5BYh3JBMr
	nZKZufxv6O+oKUdlwZOeVW0uNjHALJCwMYXspV6xhQHSJtfyxDv6gdVagjz2YrtQERtIb/Rm45Q
	lpH3EQ7YXW3xaD+rIuOiN3k=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dm0Bw1ty3z1vnHR;
	Wed,  7 Jan 2026 02:32:24 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dm0FJ3m2PzJ46bL;
	Wed,  7 Jan 2026 02:34:28 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 758FA40565;
	Wed,  7 Jan 2026 02:34:30 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 18:34:29 +0000
Date: Tue, 6 Jan 2026 18:34:28 +0000
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
Subject: Re: [PATCH v2 09/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Message-ID: <20260106183428.0000346b@huawei.com>
In-Reply-To: <20251219155222.1383109-10-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-10-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:38 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> It is expected that most GICv5 implementations will only implement a
> subset of the PPIs. GICv5 supports up to 128 PPIs in total, where the
> first 64 are architecturally defined, and the second 64 are
> implementation defined. This limitation applies to both physical and
> virtual PPIs as the same set is implemented in each case, and
> therefore KVM needs to determine a mask of implemented PPIs during
> early KVM init.
> 
> The check involves writing all of the ICH_PPI_ENABLERx_EL2 bits and
> reading those back again to determine which are stateful. If the bits
> are stateful, the PPIs are implemented. Else, they are not.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


