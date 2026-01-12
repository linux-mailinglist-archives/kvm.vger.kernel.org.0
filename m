Return-Path: <kvm+bounces-67779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 332B8D140ED
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 76FD63015145
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64BD369990;
	Mon, 12 Jan 2026 16:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AeMRjfEs"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F9B36C0DB
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235337; cv=none; b=UujDFavZHvbZUZGmxHDP424WUjgK0G6K1E2vajQz83mKZcUmvMi+u4vrZGlO8+49SgCjF/iZaPTcnol7Wy+rHhmcnPIanQ+MsUBnfaFHGaXJ2fFF4gyvW1VKwn8JezzPMCCswXnmTnjx12dCfHfJt1rylQnbbB6GVI5Zgp/Rlog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235337; c=relaxed/simple;
	bh=zW/6QXkoGhIQ0B9emspd1pf+7Ckj3VpZWETFkOGu+I8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilxaa42V/7Pxu6wB4dc3UPaDhnVx9FzTcUEz3W4qH8v8aIwSaJ+1HQ99Cd1LMBl9rQ9rX+d74zDwncuox0l9z9c5abbUBh1YWpUBdn7bUwcgt6m8TZtwAo1m+LEbDKsCeuA7OIeRLpredf38InspiD6IDG5UGQbDGusCuUfjIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AeMRjfEs; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=A9VektO+CAqvLnE0XPzoW3dtG8/MTTC0nCaZjXHsMNQ=;
	b=AeMRjfEsuuc2juhgk3xNdgTRVEM3ZYCBydzsqcnLjRTmLEhgy3FXeVtFQKl44yTTUynr6j74L
	V8HzsNjW77KU1TjGg/cE6SNqdz5B6vG6VqXqwP02Y0VXHwtlNI3hXJ9SokSTFS4+7tyWH8ilFOH
	pJw6RIT/JOkW3O9O1x0WzHo=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dqd6k0GDmzMpPg;
	Tue, 13 Jan 2026 00:26:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqd926PttzJ46DD;
	Tue, 13 Jan 2026 00:28:22 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8501640569;
	Tue, 13 Jan 2026 00:28:34 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 16:28:33 +0000
Date: Mon, 12 Jan 2026 16:28:32 +0000
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
Subject: Re: [PATCH v3 27/36] KVM: arm64: gic-v5: Mandate architected PPI
 for PMU emulation on GICv5
Message-ID: <20260112162832.00005a62@huawei.com>
In-Reply-To: <20260109170400.1585048-28-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-28-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:47 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Make it mandatory to use the architected PPI when running a GICv5
> guest. Attempts to set anything other than the architected PPI (23)
> are rejected.
> 
> Additionally, KVM_ARM_VCPU_PMU_V3_INIT is relaxed to no longer require
> KVM_ARM_VCPU_PMU_V3_IRQ to be called for GICv5-based guests. In this
> case, the architectued PPI is automatically used.
> 
> Documentation is bumped accordingly.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

