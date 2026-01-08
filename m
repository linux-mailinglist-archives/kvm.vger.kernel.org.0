Return-Path: <kvm+bounces-67417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16052D052B9
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F57532FAA87
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69442E03E3;
	Thu,  8 Jan 2026 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="A5h/5rvL"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145222DB7A0
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891179; cv=none; b=tJQPj+BqYW4hE5yJEFAu043DcQRYELTo9x0xBGo+PdZKvsMESlxtMIoMAMsdwee00JoTjW6l2gb5gkTxQyIiL84l6MqOpqmykYIEFWQOFtOPoP8gKlAAcpJkj0Fyj6Z7cx+q+bLyaoXm+PNP5krtKCC+3MgklYxmAhKHWgdMvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891179; c=relaxed/simple;
	bh=44p26uOp441C9PMPxrL4lXFb07DDQUjblsp7wAFa1XI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVNoLvGc/ONenmgQXo5MLRhBwZc59KjMbaeTSxBaVtPu0VFr7H1Fm+Ksl6pzAq+54DNUl56pDBtSi+F3iL5pI5ASWk2roUv6VwzT8R/Mzzz4HNWoZ3uQeAIPNaQSnaL0n/ekl1X2CtG1aATvjPA5LnHuZomKHwM60umDk2KqgRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=A5h/5rvL; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=II167pzCsbhjN5TOjj4CQ0NIpHKkpvrf/kifcZQTHBY=;
	b=A5h/5rvLd+kC++bcaxicFm6aogjaeuE7BzIbJBYncalWYr5m7fLQILnx/0J1WS1TTx3CK8bHI
	TZ125i2Y8ZOT5Z1Wlfa1QMLnDZFat8lW6nENgCfaeBW92KRMc5CNsnAOHZFsjmEF1Rb2UFR4JQB
	88T6wa9cNd9CXAuPHzcBdKo=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dn9rF56Zmz1P7K9;
	Fri,  9 Jan 2026 00:50:21 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn9tv6ngyzJ467w;
	Fri,  9 Jan 2026 00:52:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1023C40584;
	Fri,  9 Jan 2026 00:52:45 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 16:52:44 +0000
Date: Thu, 8 Jan 2026 16:52:42 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, "Suzuki
 Poulose" <Suzuki.Poulose@arm.com>, nd <nd@arm.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Message-ID: <20260108165242.00001ed7@huawei.com>
In-Reply-To: <7d0defd915db9ca1a3fcb4dce70697d97622aeac.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-16-sascha.bischoff@arm.com>
	<20260107122853.0000131c@huawei.com>
	<7d0defd915db9ca1a3fcb4dce70697d97622aeac.camel@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Thu, 8 Jan 2026 13:40:48 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> On Wed, 2026-01-07 at 12:28 +0000, Jonathan Cameron wrote:
> > On Fri, 19 Dec 2025 15:52:41 +0000
> > Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
> >  =20
> > > This change introduces GICv5 load/put. Additionally, it plumbs in
> > > save/restore for:
> > >=20
> > > * PPIs (ICH_PPI_x_EL2 regs)
> > > * ICH_VMCR_EL2
> > > * ICH_APR_EL2
> > > * ICC_ICSR_EL1
> > >=20
> > > A GICv5-specific enable bit is added to struct vgic_vmcr as this
> > > differs from previous GICs. On GICv5-native systems, the VMCR only
> > > contains the enable bit (driven by the guest via ICC_CR0_EL1.EN)
> > > and
> > > the priority mask (PCR).
> > >=20
> > > A struct gicv5_vpe is also introduced. This currently only contains
> > > a
> > > single field - bool resident - which is used to track if a VPE is
> > > currently running or not, and is used to avoid a case of double
> > > load
> > > or double put on the WFI path for a vCPU. This struct will be
> > > extended
> > > as additional GICv5 support is merged, specifically for VPE
> > > doorbells.
> > >=20
> > > Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> > > Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> > > Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com> =20
> >=20
> >  =20
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v5.c
> > > b/arch/arm64/kvm/vgic/vgic-v5.c
> > > index 1fe1790f1f874..168447ee3fbed 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v5.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> > > @@ -1,4 +1,7 @@
> > > =A0// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright (C) 2025 Arm Ltd.
> > > + */ =20
> >=20
> > Why in this patch?=A0 It's trivial enough that maybe it doesn't need to
> > be
> > on it's own, but the first patch touching this file seems like a more
> > logical place to find it. =20
>=20
> I wholeheartedly agree, but it was unintentionally omitted when the
> GICv5 compat mode changes were introduced. It was originally in the
> first commit in this series to touch the file, but then things got re-
> worked so it became the second. I'll make sure that it lives in the
> first commit of this series to touch the file.
I'd just throw in a trivial commit that only does this.
Then any reorders that occur before this merges don't move it.

J
>=20
> Sascha
>=20


