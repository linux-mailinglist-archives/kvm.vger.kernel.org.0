Return-Path: <kvm+bounces-67167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79714CFA81D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B0A743266D0D
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F8434D932;
	Tue,  6 Jan 2026 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xUjcjuxo"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout02.his.huawei.com (sinmsgout02.his.huawei.com [119.8.177.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEDE2FE59C
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767724137; cv=none; b=qAYTXifjOrAZCO/dsPW9LLVrv/4Iz+FaqHMNzjoqqZksqX3WtwpVKCd1/6Y43mrbKxVtZNwpLTCruayVXxZWfVoMDMLW3rnlv6gYahwOe8Zpk0CwtHGmY9hqMo28cDyNc116KLJiwWNmxDlh11aV+9ZGqA+pfIiND+7DkcRCJQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767724137; c=relaxed/simple;
	bh=ckdT7pgH7/+7S+X6lSUS/XuT28CwUKduIPo1uQZgRUI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cp2Fv3HIpGcY6rQ+KQ+jQzgtjVka/dplIFvlZDwQXC+3LL+NtwR6/diDy+WXf8azSLOb0EBa+wNEmi65eofM6LhIxIMXYNPuHri4luweZXZSjjnt/v3w7iLZWHJf3TLSdLIashXNnYH4BtUpZp81fJEjTg7FKgBHs4Zodqf1s4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xUjcjuxo; arc=none smtp.client-ip=119.8.177.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QnQ5/Urqfr9YKuKs/IRps0KCWlkQB4EijjkAqCxsU7k=;
	b=xUjcjuxopIHH3KVTbsSAQv+fomn95qAr/mBFTYBubggILi/UpHWlowPAwKbCbMAMy1+nZj1v8
	7YxDa6W/TEV9Vuw7smgYaO6xqJvF7P3D7wA+zn7jTrDWCRZ/4LbIkwqu3uegLfGToxm3J+hq/3j
	GDOe7QOSu8Jqb6u2uVORjgQ=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dm04K4K35z1vnHl;
	Wed,  7 Jan 2026 02:26:41 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dm06g0FKrzHnH6Y;
	Wed,  7 Jan 2026 02:28:43 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A7D5D4056F;
	Wed,  7 Jan 2026 02:28:47 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 18:28:46 +0000
Date: Tue, 6 Jan 2026 18:28:43 +0000
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
Subject: Re: [PATCH v2 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Message-ID: <20260106182843.00001c67@huawei.com>
In-Reply-To: <20251219155222.1383109-5-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-5-sascha.bischoff@arm.com>
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

On Fri, 19 Dec 2025 15:52:37 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Add the GICv5 system registers required to support native GICv5 guests
> with KVM. Many of the GICv5 sysregs have already been added as part of
> the host GICv5 driver, keeping this set relatively small. The
> registers added in this change complete the set by adding those
> required by KVM either directly (ICH_) or indirectly (FGTs for the
> ICC_ sysregs).
> 
> The following system registers and their fields are added:
> 
> 	ICC_APR_EL1
> 	ICC_HPPIR_EL1
> 	ICC_IAFFIDR_EL1
> 	ICH_APR_EL2
> 	ICH_CONTEXTR_EL2
> 	ICH_PPI_ACTIVER<n>_EL2
> 	ICH_PPI_DVI<n>_EL2
> 	ICH_PPI_ENABLER<n>_EL2
> 	ICH_PPI_PENDR<n>_EL2
> 	ICH_PPI_PRIORITYR<n>_EL2
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Matches spec as far as I can spot.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

