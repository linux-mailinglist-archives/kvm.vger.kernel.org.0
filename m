Return-Path: <kvm+bounces-23702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEB794D333
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38AC3B227F2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85761DFE1;
	Fri,  9 Aug 2024 15:15:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF8817548;
	Fri,  9 Aug 2024 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723216535; cv=none; b=k0udmo4E85L042Ek5QyCWbP1hFDQDkIVgkNrSZ8k85F61yd4TJrnhmA73HDrxqo2nfRR0YraCtI+4gKvPXF7lcwCmqGy1dainIdYbJUWU1mG4RBEa49gwxUSHyewPjoniv7EZ+hburYIA649ovf4IVoamnldAB1WksqhoEIK2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723216535; c=relaxed/simple;
	bh=Sv4OQmdpn3Gu3oDJ/ErEeKBV+jpQaKCimhh1f8omE7w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mMNEKAe4VAAvE0XTwiKFyRSeHZBNHQT+9vEiP/AxSdiSOUSbMRpShA6wbNeaL1LaNmA5mFfXSdv1OyBRnJnaYbubaNxom1/jYR2MFmYek5kNf4ZFYIrPftR+FXdfO/DXO3dQ6MCFwn1XrwJxwlDPor/gNxQxOY/jDr7s8rz37S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WgS660pztzQpTk;
	Fri,  9 Aug 2024 23:10:54 +0800 (CST)
Received: from dggpemf200003.china.huawei.com (unknown [7.185.36.52])
	by mail.maildlp.com (Postfix) with ESMTPS id 3859914011A;
	Fri,  9 Aug 2024 23:15:23 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200003.china.huawei.com (7.185.36.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Aug 2024 23:15:22 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 9 Aug 2024 16:15:20 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, "Alex
 Williamson" <alex.williamson@redhat.com>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"Nicolin Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHa6FotpRfMo8Wi40urDv/LZ+pM/rIfAPiQ///2/wCAABHcwA==
Date: Fri, 9 Aug 2024 15:15:20 +0000
Message-ID: <8ccabbffaae042a9b9c727272fd352e6@huawei.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
 <20240809145922.GH8378@nvidia.com>
In-Reply-To: <20240809145922.GH8378@nvidia.com>
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
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, August 9, 2024 3:59 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: acpica-devel@lists.linux.dev; Alex Williamson
> <alex.williamson@redhat.com>; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>; kvm@vger.kernel.org=
;
> Len Brown <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> Murphy <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>;
> Will Deacon <will@kernel.org>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer <mdf@kernel.o=
rg>;
> Michael Shavit <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev
> Subject: Re: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
>=20
> On Fri, Aug 09, 2024 at 02:36:31PM +0000, Shameerali Kolothum Thodi wrote=
:
> > > @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
> > >
> > >  #define ACPI_IORT_MF_COHERENCY          (1)
> > >  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> > > +#define ACPI_IORT_MF_CANWBS             (1<<2)
> >
> > I think we need to update Document number to E.f in IORT section in
> > this file. Also isn't it this file normally gets updated through ACPICA=
 pull ?
>=20
> I don't know anything about the ACPI process..
>=20
> Can someone say for sure what to do here?

From past experience, it is normally sending a PULL request to here,
https://github.com/acpica/acpica/pulls

And I think it then gets merged by Robert Moore and then send to LKML.

Thanks,
Shameer


