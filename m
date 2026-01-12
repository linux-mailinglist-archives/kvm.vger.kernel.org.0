Return-Path: <kvm+bounces-67765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E08D13491
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 15:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50D73301C56E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDB62BEC21;
	Mon, 12 Jan 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QAiceJv/"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39302BE033
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229263; cv=none; b=OC8ilxh4XlpzGt7z2a6F4H12KTLeiqaMa1LUbXNTFeWJaeEphbkfDIdOTr8Ou90E/BT5cLbOYqRDkvPwNjaVXKugaDHXkWotBgyLEV66p1FQD0Gi+772v3O+hjo4AEiV3J40J6RWQcuIQ3V2+RM/1yLFSIkOHQWp7ATOxolc+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229263; c=relaxed/simple;
	bh=Jv/u0k33wzaPQ6SM5Qs2hvmnx4c+3TJeKoG1dqzyhsI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPyjuNBEFOsKkroNGr6UCgUtafd2ZjOZMOSEbm/gcrqdCk+i/20yMdc6ak0/vU8ee5dghnkvymNf6fzPfbAAY/lIqBJxJZDs/1ap+l60JtcBzMeyc3zbu4gr42N/cCvqQZKINyTiDRtvOjD4ERB4UUfq3UBJa6YF7ZcH+uKuoS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QAiceJv/; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X9V8kCKH2+7bOq4qa+Cu4KZLBlKGxSHMNWwq6JKqvl4=;
	b=QAiceJv/y+TLuULGewcjmkmVZDv/mEnaE5VwjchiLEVU95VFGbof6QW5mcZ30DEXQHpBloDBZ
	UGz+M8tnMzfI/2kN8OXPhzFmnCngOa7F2Bi0ByOeiqZGDWYKbIzNchXKqJ8exm4v/Uz4ioQk/xN
	X/sYGtRtnU+beWvPfX6bqIQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dqZtC4WvTz1vnJM;
	Mon, 12 Jan 2026 22:45:23 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqZwW6qQNzJ467g;
	Mon, 12 Jan 2026 22:47:23 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A3E240086;
	Mon, 12 Jan 2026 22:47:35 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:47:34 +0000
Date: Mon, 12 Jan 2026 14:47:33 +0000
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
Subject: Re: [PATCH v3 11/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Message-ID: <20260112144733.000015a5@huawei.com>
In-Reply-To: <20260109170400.1585048-12-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-12-sascha.bischoff@arm.com>
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

On Fri, 9 Jan 2026 17:04:42 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Set the guest's view of the GCIE field to IMP when running a GICv5 VM,
> NI otherwise. Reject any writes to the register that try to do
> anything but set GCIE to IMP when running a GICv5 VM.
> 
> As part of this change, we also introduce vgic_is_v5(kvm), in order to
> check if the guest is a GICv5-native VM. We're also required to extend
> vgic_is_v3_compat to check for the actual vgic_model. This has one
> potential issue - if any of the vgic_is_v* checks are used prior to
> setting the vgic_model (that is, before kvm_vgic_create) then
> vgic_model will be set to 0, which can result in a false-positive.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

