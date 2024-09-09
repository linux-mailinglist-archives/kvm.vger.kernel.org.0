Return-Path: <kvm+bounces-26144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A573972028
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 19:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A0E9284558
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38EE175D2D;
	Mon,  9 Sep 2024 17:17:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101B91741CB
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 17:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725902227; cv=none; b=szyARGJxFabVYnWvpjrDjJOfQLOkGdn7ajOuzgqblNG3H93Nv0KTwpSvasUJjq4r37Iakpcu29RgeAiNiEZI++m02ST00jkYSQnQB/z+Enl3YWC4M8PmmJnY0gpBxnHOcggFTmekX/GVi6OLHUxowUEAGIWGgYbfLILvboA8gpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725902227; c=relaxed/simple;
	bh=Lzy8VwaaaIfiQ0x8fjxGw11wKkM0FKRVZg+X5HSfJrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a7lK3ooqf/ZH3N9z1P2vX2AEvwXEx7E6cSXMqi9fHbB2gAp45BKDWe3M6hFagMUARI2Rx5+57ghUVhD46LzuSe3z0kugkJNYMWgeQcQIHPE6uE52X6oI/MdCXWBu9+mbPBjcVXV/oTsdm9nWmzSlzBrH0sxPQEEwxCls+tCD0cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4X2YQ165Mhz1BJY4;
	Tue, 10 Sep 2024 01:15:53 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 2C79A1800D2;
	Tue, 10 Sep 2024 01:16:58 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 01:16:57 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 9 Sep 2024 18:16:55 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Sebastian Ott
	<sebott@redhat.com>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shaoqin Huang
	<shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>
Subject: RE: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Topic: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Index: AQHawm/0TP9B4WSU3kSdeZvzR1wQjLJQDNGggAAIPQCAAAfwgIAAEmkA
Date: Mon, 9 Sep 2024 17:16:55 +0000
Message-ID: <8e361ab82d6c4adcb15890cd3cab48ee@huawei.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
 <20240619174036.483943-8-oliver.upton@linux.dev>
 <0db19a081d9e41f08b0043baeef16f16@huawei.com> <864j6o94fz.wl-maz@kernel.org>
 <Zt8o6fStuQXANSrX@linux.dev>
In-Reply-To: <Zt8o6fStuQXANSrX@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: Oliver Upton <oliver.upton@linux.dev>
> Sent: Monday, September 9, 2024 5:57 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvmarm@lists.linux.dev; Sebastian Ott <sebott@redhat.com>; James Morse
> <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> yuzenghui <yuzenghui@huawei.com>; kvm@vger.kernel.org; Shaoqin Huang
> <shahuang@redhat.com>; Eric Auger <eric.auger@redhat.com>; Wangzhou
> (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature I=
D
> register
>=20
> On Mon, Sep 09, 2024 at 05:28:48PM +0100, Marc Zyngier wrote:
> > Hi Shameer,
> >
> > On Mon, 09 Sep 2024 16:19:54 +0100,
> > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> > >
> > > Hi Oliver/Sebastian,
> > >
> > > > -----Original Message-----
> > > > From: Oliver Upton <oliver.upton@linux.dev>
> > > > Sent: Wednesday, June 19, 2024 6:41 PM
> > > > To: kvmarm@lists.linux.dev
> > > > Cc: Marc Zyngier <maz@kernel.org>; James Morse
> > > > <james.morse@arm.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>;
> > > > yuzenghui <yuzenghui@huawei.com>; kvm@vger.kernel.org; Sebastian
> > > > Ott <sebott@redhat.com>; Shaoqin Huang <shahuang@redhat.com>;
> Eric
> > > > Auger <eric.auger@redhat.com>; Oliver Upton
> > > > <oliver.upton@linux.dev>
> > > > Subject: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM
> > > > feature ID register
> > >
> > > [...]
> > >
> > > > @@ -2487,7 +2490,10 @@ static const struct sys_reg_desc
> > > > sys_reg_descs[] =3D {
> > > >  	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> > > >  	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
> > > >  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown,
> > > > CSSELR_EL1 },
> > > > -	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
> > > > +	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
> > > > +			     CTR_EL0_IDC_MASK |
> > > > +			     CTR_EL0_DminLine_MASK |
> > > > +			     CTR_EL0_IminLine_MASK),
> > >
> > > (Sorry if this was discussed earlier, but I couldn't locate it
> > > anywhere.)
> > >
> > > Is there a reason why we can't make the L1Ip writable as well here?
> > > We do have hardware that reports VIPT and PIPT for L11p.
> > >
> > > The comment here states,
> > > https://elixir.bootlin.com/linux/v6.11-rc7/source/arch/arm64/kernel/
> > > cpufeature.c#L489
> > >
> > > " If we have differing I-cache policies, report it as the weakest - V=
IPT."
> > >
> > > Does this also mean it is safe to downgrade the PIPT to VIPT for Gues=
t as
> well?
> >
> > It should be safe, as a PIPT CMO always does at least the same as
> > VIPT, and potentially more if there is aliasing.
>=20
> +1, there was no particular reason why this wasn't handled before.
>=20
> We should be careful to only allow userspace to select VIPT or PIPT (wher=
e
> permissible), and not necessarily any value lower than what's reported by
> hardware.

VIPT 0b10
PIPT 0b11

Ok. Just to clarify that " not necessarily any value lower than what's repo=
rted by
hardware" means userspace can set PIPT if hardware supports VIPT?

Based on this,
" If we have differing I-cache policies, report it as the weakest - VIPT." =
, I was thinking
the other way around(see "safe to downgrade PIPT to VIPT"). But Marc also
seems to suggest PIPT CMO ends up doing atleast same as VIPT and more, so i=
t looks like
the other way. If that's the case, what does that "report it as the weakest=
" means for host?
=20
(I will send out a patch, once the above is clarified)

Thanks,
Shameer




