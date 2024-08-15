Return-Path: <kvm+bounces-24307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 569F195380C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A3C71F216E2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201C71B3F05;
	Thu, 15 Aug 2024 16:14:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC29D4C69;
	Thu, 15 Aug 2024 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738472; cv=none; b=Ve+/oPe2bfByCUdNIurt/qJXHedSMTeyXxw+XiHdOMLLEcf35kOBF3j8whXKpeN19FNnLqau5+yGp8vOED7oXaOh2WQ7k7BtC3p78dzPc71UlGqlnxA+wLl1j/vh6wg3eAW1b4g+7ikd5z3FZSImKtaZRL9UB21DXzg60E6+taY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738472; c=relaxed/simple;
	bh=gPchBBERwQRYrCuAXZl7Gyhndv8iuj1REUcRueHpANU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FHfw5ohqZrtws1gb6OPZ/yZOOBTy71UPPnjm6IDYRoy5LvXwDRYBUekJgV1ZMHTp3+zSheBwoz5ncz22Cgw17tKWko/yQn2YXrDf2Wwxq0MkrHlMoTb/PT/Q0KYI5LiJSqpe9CIwKebAfHJdJIKBDMnpG8UIikL2uoHMyGyWw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Wl9BT73g2z1xvH2;
	Fri, 16 Aug 2024 00:12:33 +0800 (CST)
Received: from dggpemf500001.china.huawei.com (unknown [7.185.36.173])
	by mail.maildlp.com (Postfix) with ESMTPS id E8CDB1A0188;
	Fri, 16 Aug 2024 00:14:25 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500001.china.huawei.com (7.185.36.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Aug 2024 00:14:25 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 15 Aug 2024 17:14:23 +0100
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
	<patches@lists.linux.dev>, Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa6FotZjxW0m4zQk+YUXvVQrNfTbIe/kcw///9ToCACYxdcA==
Date: Thu, 15 Aug 2024 16:14:22 +0000
Message-ID: <d902b4045443465db6dc5c6ceee1e589@huawei.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <5af45a0c060c487fb41983c434de0ec6@huawei.com>
 <20240809151219.GI8378@nvidia.com>
In-Reply-To: <20240809151219.GI8378@nvidia.com>
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
> Sent: Friday, August 9, 2024 4:12 PM
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
> Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
>=20
> On Fri, Aug 09, 2024 at 02:26:13PM +0000, Shameerali Kolothum Thodi wrote=
:
> > > +		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> > > +			pgtbl_cfg.quirks |=3D IO_PGTABLE_QUIRK_ARM_S2FWB;
> >
> > This probably requires an update in arm_64_lpae_alloc_pgtable_s2() quir=
ks
> check.
>=20
> Yep, fixed I was hoping you had HW to test this..

Let me see if I can get hold of a test setup that supports S2FWB.

I do have another concern with respect to the hardware we have which doesn'=
t
support S2FWB, but those can claim CANWBS. The problem is, BIOS update is n=
ot
a very liked/feasible solution to already deployed ones. But we can probabl=
y add=20
an option/quirk in SMMUv3 driver for those platforms(based on=20
ACPI_IORT_SMMU_V3_HISILICON_HI161X).  I hope this is fine.

Thanks,
Shameer



