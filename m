Return-Path: <kvm+bounces-67767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE2AD138D8
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:17:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BA8CB30EE66D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684601F3B87;
	Mon, 12 Jan 2026 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ImExJt/s"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AE02DB79C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229735; cv=none; b=d7NBkzxU0aYzAuzc3LjsVAgum2n52WrMpK4c9Pa8ceBPZ7oIvzjypr25KZsWp/e1ad+4V5Xm12fwIN4JOeW5t196NmN8FGomP1A4cvFLb890rh14XIis3WIw19wkoBcSaqwF0ImRS19YCE4uRJWyJmW5kw1aC5SYjXBC2lbal1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229735; c=relaxed/simple;
	bh=8uavkiVKE+qnmI89ydIhqq/zTw3NmneV7vtVM7A0+Io=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f20UR6AlbQrl3q8e+dWc0wQZnp1CawgPLgl44Ch86h9CnrUsNGfZW5crDZr9WtshhREmxP47QcOcCaxV+RAziMgf1M9zjd43AiKrKPkmWZOCQLIN73fxiuPgIPjn4qc3UGG9ZozVdPqaGNSOhgxbEAIZ7bj9C3bDgmxCs4OAQIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ImExJt/s; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wfnIzNSfkHDE44pyh3cGL1QPG+efZ7Gv5MuAyZB8E5M=;
	b=ImExJt/s6LNoNcA/vrSpxVVyUzmxGT3dJH5TmRqHgbYOrTZB7cPTesjGCDlW0IBmvoESs1EN7
	X21VS1YdH3O/wahIa0SPY3Q9sExaE/tBZ+PiHUjw7ayc+nMMnwDq0l2fzFfD90KuuWad6fUAkcR
	idV2Q8kAkJwL9gv3B7kuQrw=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqb322LRnz1P7Js;
	Mon, 12 Jan 2026 22:53:02 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqb5V2HJgzHnGh7;
	Mon, 12 Jan 2026 22:55:10 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B67640585;
	Mon, 12 Jan 2026 22:55:26 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 12 Jan
 2026 14:55:25 +0000
Date: Mon, 12 Jan 2026 14:55:24 +0000
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
Subject: Re: [PATCH v3 12/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Message-ID: <20260112145524.0000164c@huawei.com>
In-Reply-To: <20260109170400.1585048-13-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	<20260109170400.1585048-13-sascha.bischoff@arm.com>
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

> Extend the existing FGT/FGU infrastructure to include the GICv5 trap
> registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
> involves mapping the trap registers and their bits to the
> corresponding feature that introduces them (FEAT_GCIE for all, in this
> case), and mapping each trap bit to the system register/instruction
> controlled by it.
> 
> As of this change, none of the GICv5 instructions or register accesses
> are being trapped.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



