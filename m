Return-Path: <kvm+bounces-25278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8725A962DB0
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:31:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA526B214D1
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46191A257C;
	Wed, 28 Aug 2024 16:31:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8733CD1;
	Wed, 28 Aug 2024 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862704; cv=none; b=p2BtLmu99kli1szb30lP3MqgJqNJGchRBbifPeS7G6pgz1lP6M2vk4FHvszISzpO8jBqKdR5N0Gxpox+tDpclFcxCKFuG2kRWn4Gdbu859pWO5Yai4PZcRRXXuRf0Sj6lFXGqKto3lgcXx4VEUHvxGMMwod/cXugqIWcQcx7KV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862704; c=relaxed/simple;
	bh=T5Rpb8zKKotsQm3MEEritbdfOWxT0DR8Vst6B153q68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RWPCaMEkXYnyf9ccPg4VesiJYPrOIkQkZOtvR2DH95znMHcSAZC4s5gV2k+3o0jlOBcgOIu841QUBf+ffOCUI/H4LEF944zzTiPovRtL18l2pNWCI+BpmW87S9DDqxsz3fOOk7Aru+w7bRTN5kGKXRjIpwnUadU4wBWYmdJG1Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wv8zw3ng8zyR79;
	Thu, 29 Aug 2024 00:31:08 +0800 (CST)
Received: from dggpemf200003.china.huawei.com (unknown [7.185.36.52])
	by mail.maildlp.com (Postfix) with ESMTPS id 24166180AE6;
	Thu, 29 Aug 2024 00:31:39 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200003.china.huawei.com (7.185.36.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 Aug 2024 00:31:38 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 28 Aug 2024 17:31:36 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, "Guohanjun
 (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Mostafa Saleh
	<smostafa@google.com>
Subject: RE: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Topic: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Index: AQHa+JkQkcFFSAeDsUqyXyGP6/LaZLI7ju0AgAFNDIA=
Date: Wed, 28 Aug 2024 16:31:36 +0000
Message-ID: <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
In-Reply-To: <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
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

Hi Nicolin,

> -----Original Message-----
> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, August 27, 2024 10:31 PM
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: acpica-devel@lists.linux.dev; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo Piera=
lisi
> <lpieralisi@kernel.org>; Rafael J. Wysocki <rafael@kernel.org>; Robert
> Moore <robert.moore@intel.com>; Robin Murphy
> <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>; Will
> Deacon <will@kernel.org>; Alex Williamson <alex.williamson@redhat.com>;
> Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; patches@lists.linux.dev; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Mostafa Saleh
> <smostafa@google.com>
> Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
>=20
=20
> As mentioned above, the VIOMMU series would be required to test the
> entire nesting feature, which now has a v2 rebasing on this series. I tes=
ted it
> with a paring QEMU branch. Please refer to:
> https://lore.kernel.org/linux-
> iommu/cover.1724776335.git.nicolinc@nvidia.com/

Thanks for this. I haven't gone through the viommu and its Qemu branch
yet.  The way we present nested-smmuv3/iommufd to the Qemu seems to
have changed  with the above Qemu branch(multiple nested SMMUs).
The old Qemu command line for nested setup doesn't work anymore.

Could you please share an example Qemu command line  to verify this
series(Sorry, if I missed it in the links/git).

Thanks,
Shameer=20





