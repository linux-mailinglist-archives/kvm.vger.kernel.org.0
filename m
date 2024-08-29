Return-Path: <kvm+bounces-25368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C74D2964919
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8262B284C53
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2571B14F0;
	Thu, 29 Aug 2024 14:52:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940A11B1428;
	Thu, 29 Aug 2024 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943151; cv=none; b=I7jYFRMbSlFdXrasg32v1nszNiGsp/l08iLV9oF9PaaqX5HyR2RlSrYtzL1M9EkdwnZ+NHx2d+nHGDdZjS4PjpCAYVBtj+elkGuSJ3WDcXBoZXiLn1rBf7Of62mdhwWvJyitypVjPHlTCnIMGIHMY9dybX6idjyM16FwpFhf/c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943151; c=relaxed/simple;
	bh=uS6ZUGkMELokJhjp5dBYR6LbnxF19SksPUR5GdIllFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cbMAp4AxESOLxLwhbbHstube1b7QUa6XGp1yTN6RvAXY4wqgbd0kj+hS/k5HGfUmH9fAcJqCAvmHDaFPc2EpLyOg7fTZ1ESIxxdEAd9y7DeoIIK+mgkNPuZZuDuLMGxvteB7e3HaL17oHR9H3eCprnUflUDLQbZIekmzASjOt7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wvkdy6wLJzQr6Y;
	Thu, 29 Aug 2024 22:47:34 +0800 (CST)
Received: from dggpemf500003.china.huawei.com (unknown [7.185.36.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 108351401E0;
	Thu, 29 Aug 2024 22:52:26 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500003.china.huawei.com (7.185.36.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 29 Aug 2024 22:52:25 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 29 Aug 2024 15:52:23 +0100
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
Thread-Index: AQHa+JkQkcFFSAeDsUqyXyGP6/LaZLI7ju0AgAFNDID///2PgIAAHqvg///xn4CAAU4tEIAAHHjg
Date: Thu, 29 Aug 2024 14:52:23 +0000
Message-ID: <d1dc23f484784413bb3f6658717de516@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
 <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
 <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
In-Reply-To: <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
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
> From: Shameerali Kolothum Thodi
> Sent: Thursday, August 29, 2024 2:15 PM
> To: 'Nicolin Chen' <nicolinc@nvidia.com>
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
> Subject: RE: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
>=20
> That makes some progress. But still I am not seeing the assigned dev  in
> Guest.
>=20
> -device vfio-pci-nohotplug,host=3D0000:75:00.1,iommufd=3Diommufd0
>=20
> root@ubuntu:/# lspci -tv#
>=20
> root@ubuntu:/# lspci -tv
> -+-[0000:ca]---00.0-[cb]--
>  \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
>              +-01.0  Red Hat, Inc Virtio network device
>              +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
>              \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge
>=20
> The new root port is created, but no device attached.
It looks like Guest finds the config invalid:

[    0.283618] PCI host bridge to bus 0000:ca
[    0.284064] ACPI BIOS Error (bug): \_SB.PCF7.PCEE.PCE5.PCDC.PCD3.PCCA._D=
SM: Excess arguments - ASL declared 5, ACPI requires 4 (20240322/nsargument=
s-162)
[    0.285533] pci_bus 0000:ca: root bus resource [bus ca]
[    0.286214] pci 0000:ca:00.0: [1b36:000c] type 01 class 0x060400 PCIe Ro=
ot Port
[    0.287717] pci 0000:ca:00.0: BAR 0 [mem 0x00000000-0x00000fff]
[    0.288431] pci 0000:ca:00.0: PCI bridge to [bus 00]
[    0.290649] pci 0000:ca:00.0: bridge configuration invalid ([bus 00-00])=
, reconfiguring
[    0.292476] pci_bus 0000:cb: busn_res: can not insert [bus cb-ca] under =
[bus ca] (conflicts with (null) [bus ca])
[    0.293597] pci_bus 0000:cb: busn_res: [bus cb-ca] end is updated to cb
[    0.294300] pci_bus 0000:cb: busn_res: can not insert [bus cb] under [bu=
s ca] (conflicts with (null) [bus ca])

Let me know if you have any clue.=20

Thanks,
Shameer


