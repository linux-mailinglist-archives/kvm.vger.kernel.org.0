Return-Path: <kvm+bounces-25284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C2B962F53
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37935282D02
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8020D1A7ADE;
	Wed, 28 Aug 2024 18:06:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBFD1A071B;
	Wed, 28 Aug 2024 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868406; cv=none; b=iH2CfkntTziivsD2hQECbtoY94OMqEzkZcHiC8LWkMYxoOWBqkeP7i+oMElrLiVPKCU07taL+8gDxN2ZZmVA+lDebV+BUMmTR9lebln+FE2iLQ8yycPN20yKX6uUbXRH8NvzzxIaUtJQt5Mg4vQ5N20QqXl937UcRHY5X2CUeDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868406; c=relaxed/simple;
	bh=w67xNAjthsSQ+48Jvvohao+Zq2bgRnT/FFrFz/z4Zb4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jF3HSmKan76uZptweywWlcZZVOB++v9U31Y+86I7KDrqwVw4sEIZ6HcpMfd5oXjIeCDpWo7L4HDfzrTE1K3T5BmLWSMQkYEFpzP+wnZP98utzp7HZgCNFS5gT7GSrRCmhCGy4/DW6UF5rqYvigUDwfhzxYD0G9Dp/cWnEf+RKjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WvC2H5yLlz1HHbh;
	Thu, 29 Aug 2024 02:03:19 +0800 (CST)
Received: from dggpemf200001.china.huawei.com (unknown [7.185.36.225])
	by mail.maildlp.com (Postfix) with ESMTPS id E89691400CB;
	Thu, 29 Aug 2024 02:06:39 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200001.china.huawei.com (7.185.36.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 Aug 2024 02:06:39 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 28 Aug 2024 19:06:37 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
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
Thread-Index: AQHa+JkQkcFFSAeDsUqyXyGP6/LaZLI7ju0AgAFNDID///2PgIAAHqvg
Date: Wed, 28 Aug 2024 18:06:36 +0000
Message-ID: <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
In-Reply-To: <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
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
> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, August 28, 2024 6:15 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; acpica-devel@lists.linux.dev;
> Guohanjun (Hanjun Guo) <guohanjun@huawei.com>;
> iommu@lists.linux.dev; Joerg Roedel <joro@8bytes.org>; Kevin Tian
> <kevin.tian@intel.com>; kvm@vger.kernel.org; Len Brown
> <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>;
> Robin Murphy <robin.murphy@arm.com>; Sudeep Holla
> <sudeep.holla@arm.com>; Will Deacon <will@kernel.org>; Alex Williamson
> <alex.williamson@redhat.com>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer
> <mdf@kernel.org>; Michael Shavit <mshavit@google.com>;
> patches@lists.linux.dev; Mostafa Saleh <smostafa@google.com>
> Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
>=20
> Hi Shameer,
>=20
> On Wed, Aug 28, 2024 at 04:31:36PM +0000, Shameerali Kolothum Thodi
> wrote:
> > Hi Nicolin,
> >
> > > -----Original Message-----
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, August 27, 2024 10:31 PM
> > > To: Jason Gunthorpe <jgg@nvidia.com>
> > > Cc: acpica-devel@lists.linux.dev; Guohanjun (Hanjun Guo)
> > > <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> > > <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> > > kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> > > acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo
> > > Pieralisi <lpieralisi@kernel.org>; Rafael J. Wysocki
> > > <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> > > Murphy <robin.murphy@arm.com>; Sudeep Holla
> <sudeep.holla@arm.com>;
> > > Will Deacon <will@kernel.org>; Alex Williamson
> > > <alex.williamson@redhat.com>; Eric Auger <eric.auger@redhat.com>;
> > > Jean-Philippe Brucker <jean- philippe@linaro.org>; Moritz Fischer
> > > <mdf@kernel.org>; Michael Shavit <mshavit@google.com>;
> > > patches@lists.linux.dev; Shameerali Kolothum Thodi
> > > <shameerali.kolothum.thodi@huawei.com>; Mostafa Saleh
> > > <smostafa@google.com>
> > > Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested
> > > translation
> > >
> >
> > > As mentioned above, the VIOMMU series would be required to test the
> > > entire nesting feature, which now has a v2 rebasing on this series.
> > > I tested it with a paring QEMU branch. Please refer to:
> > > https://lore.kernel.org/linux-
> > > iommu/cover.1724776335.git.nicolinc@nvidia.com/
> >
> > Thanks for this. I haven't gone through the viommu and its Qemu branch
> > yet.  The way we present nested-smmuv3/iommufd to the Qemu seems to
> > have changed  with the above Qemu branch(multiple nested SMMUs).
> > The old Qemu command line for nested setup doesn't work anymore.
> >
> > Could you please share an example Qemu command line  to verify this
> > series(Sorry, if I missed it in the links/git).
>=20
> My bad. I updated those two "for_iommufd_" QEMU branches with a
> README commit on top of each for the reference command.

Thanks. I did give it a go and this is my command line based on above,

./qemu-system-aarch64-nicolin-viommu -object iommufd,id=3Diommufd0 \
-machine hmat=3Don \
-machine virt,accel=3Dkvm,gic-version=3D3,iommu=3Dnested-smmuv3,ras=3Don \
-cpu host -smp cpus=3D61 -m size=3D16G,slots=3D4,maxmem=3D256G -nographic \
-object memory-backend-ram,size=3D8G,id=3Dm0 \
-object memory-backend-ram,size=3D8G,id=3Dm1 \
-numa node,memdev=3Dm0,cpus=3D0-60,nodeid=3D0  -numa node,memdev=3Dm1,nodei=
d=3D1 \
-device vfio-pci-nohotplug,host=3D0000:75:00.1,iommufd=3Diommufd0 \
-bios QEMU_EFI.fd \
-drive if=3Dnone,file=3Dubuntu-18.04-old.img,id=3Dfs \
-device virtio-blk-device,drive=3Dfs \
-kernel Image \
-append "rdinit=3Dinit console=3DttyAMA0 root=3D/dev/vda rw earlycon=3Dpl01=
1,0x9000000 kpti=3Doff" \
-nographic

But it fails to boot very early:

root@ubuntu:/home/shameer/qemu-test# ./qemu_run-simple-iommufd-nicolin-2
qemu-system-aarch64-nicolin-viommu: Illegal numa node 2
=20
Any idea what am I missing? Do you any special config enabled while buildin=
g Qemu?

Thanks,
Shameer

