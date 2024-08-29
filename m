Return-Path: <kvm+bounces-25383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED4EC964B1F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C5A1286DAE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768281B3F1F;
	Thu, 29 Aug 2024 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QzME5Mph"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8092AD18;
	Thu, 29 Aug 2024 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724947836; cv=fail; b=k+FOMFntVQ5qCsHhPeZ4DHmer/7oxSygMZ+frwmmQqS6CoYbW3QDIIha+Ztx32Cgn2MVZd2z20VdJNxt0s65KQrXzWWqpUn0ry3zlPHa5FeWHfMcdEDXbfVT4nuc7d8PX70ShxSEyS6i2UyXPEMMkzWa0C/u3+MJXK0RKJARX8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724947836; c=relaxed/simple;
	bh=IlnidsaEVJpbWfaajoJKByKlgEQwMqn0K18TmJh3fFY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3QZ4BJWHFMl92sJWjUxErEVm9FoHTihbCJZdx80tJr5W0bAR085l3q1/rqX1Dlzva/mpP2uJZ7TO+LIBiCvLMfaJp/AFuof6YRtd6Q/ydCfhYF2l18szZqYIuehU/JzojXYqeNb+juYLGyg12iQ9w0YS1P5vT9ldy4yy0O4LD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QzME5Mph; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5WaexmTKJeZZ0iaCtaPaQs5z9b6elC7Vfgex3USH/JaflDNDS256hhFmYcRpDaX9OL4KcuOzcUxh5qDhtruWbprXElqh6e/xhzi7UWtd/QvYOV2TgJc3q5651G9wWB4MOfjbHxU0DOk4iNpS2qYt7JDHx3a33GnMCMZFrGl89MM+OwxR6gyhGDqfcdboeoVG97aGziGJtU04yhcQeXYaL/KohwKKaAJAIBY9eoxDOEhlDNA/FMhtBUl9sRsunvHeCom2pAqg0Av3knnDRqB9D77CcNITUtNe3ekzFap/tfworiUgvnpoqmcCEoQuhAjkYEDqDKXgsfvqBxKUa1R6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0X5zeTS2WqgWuWC59E408gKpa+ayQeMHnHNvZ7OVn4=;
 b=XQ1um/DttWnXU48/GzY2q8V959xQVuQPxyFbxUOGa8kTyib/hJcZhL7SptSe5kT3pWWYeSRHndg50o9lZz716VVCck+crDpOqDuKVbdo70RXuw2ADi1NCRWQHmp9h6JkgonL3f/fxkvY5ZUhE/g57pvjEnUt1oMvCcVIoGeZICnyH6ro+71Yu2uYGpwUKmZmJpGpuBQ9zhmeGDS+Z/IfuhL82+4Ybnn4/McIOJWsbP/M6+w15ujIW+nkGusXIgH0RV+Ofmskc6M2QNSedvVEVzj11E9/D7o1fLCsoITHkjmUQr/F4LXSKrHEZDSh0SB5cQ8b2UBX7NoHBZbeafkvrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0X5zeTS2WqgWuWC59E408gKpa+ayQeMHnHNvZ7OVn4=;
 b=QzME5MphKWbnRPmnjEQUjOHiLSmqZ/KRe59NCxiDxmc5lS/QVf0BxK4+LE5biYiFZwhWZaWlTA8D0LRFws1LQbXRjDc7SyAesI/D36m8xgGehtbC2Ynx5Pljrq2zmj9enEbABroqKXvcehpmq4TTD5KgOG3pLGiXb0EAH1DPM6hw24mcNU7xYZKpqcifPT7Yn++uyDnXqrEnA3H+MzqdT3nB0xfiqo7OchaxwgVTDYQNlpjmHa3FbXV383hcAhRW62aedW1tajdwKYfNAubG+EGDxh2nhUKP44LEzL/kWFB0JQAZOHzK9tp7CSSagr8x2+vb4GRD3zY+TGnhCBvwDw==
Received: from SJ0PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:2c0::24)
 by BL3PR12MB6643.namprd12.prod.outlook.com (2603:10b6:208:38f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 16:10:26 +0000
Received: from SJ1PEPF000023D1.namprd02.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::4d) by SJ0PR13CA0019.outlook.office365.com
 (2603:10b6:a03:2c0::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19 via Frontend
 Transport; Thu, 29 Aug 2024 16:10:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D1.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 16:10:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 09:10:09 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 09:10:09 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 29 Aug 2024 09:10:07 -0700
Date: Thu, 29 Aug 2024 09:10:06 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
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
Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZtCdXjkzVbFMBJjy@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
 <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
 <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
 <d1dc23f484784413bb3f6658717de516@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d1dc23f484784413bb3f6658717de516@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D1:EE_|BL3PR12MB6643:EE_
X-MS-Office365-Filtering-Correlation-Id: 119f52ce-18e8-4ce2-5a94-08dcc8451764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ix7TIYIKlmpv/ZoQ+QVzrCai0bsrthbkzYvbLZqqhfYI0zuKh1MmEYwYJom6?=
 =?us-ascii?Q?+PDz3r6lBLHrjI81F1JycfyaxWyT2bcQaAvGe7A+KWOXF7PRtWsrzEdjX7B8?=
 =?us-ascii?Q?4aSM3r/gyPwb2kcoK1iGsrqd8LY3lP92g5Z5lSwwcTvd6KKLKugAJzkp5zsT?=
 =?us-ascii?Q?TtJHaC0DoDvrwNnf07ZUmkS+LJeEw2lWvFV178r/0wB9g/+f+GKJhK2veCWl?=
 =?us-ascii?Q?rBE8nclxzHri4EQhWUI1ZksHVCWEn5L/Qbgpx03Va50OW+1vDr4wIsseAm9A?=
 =?us-ascii?Q?AoOyFqY9N1r/tK/VK+YFZ4Nua2GjUrhvfjmaLFF/XmQ9JcmXg/TMLxnMEnlW?=
 =?us-ascii?Q?vRyeGSuYz0QU0gcBf5W0K+0FrMbUKE0MM43wVW5DE/Ej4aKgGWP/CNNyNNAA?=
 =?us-ascii?Q?I6b1i1qRKACDv2krRKejWjPVQqkhKdZYGDDyiX3hYPPCR4HQXVTVP+A60nEB?=
 =?us-ascii?Q?KXH3Ln/f0hn3bymIoFpRj1AY0xsFMBmezPIUE475mqTEJIIN+txx1lag17UA?=
 =?us-ascii?Q?KfAwnhBIyjwogWq0r31v9V902w+Kn8najLaIrdONUTEgVp2kY4OqjvNhCL4H?=
 =?us-ascii?Q?4VE+zsPVN/u4Q37797OJ1Msrgc0PrfokHPNmYTiI2FW/pfeQFFyvc3nKmPPo?=
 =?us-ascii?Q?quufctQVAVcPa0b3JA5qz6rjNjQO/X9LDtJpieazORuShl9hNa9j8jpiWotG?=
 =?us-ascii?Q?ZvWrBhUyGTle8jTLG5CQnYiv5UbNm9qYHUBcTj8ztp803zUL1Na/KjVo5DB5?=
 =?us-ascii?Q?1e/aoYyrUm646krgq3DiVzclQ4cTLAVrRF5lWf+Gj05HZM874CA/TqZuDC0r?=
 =?us-ascii?Q?AViaurhE16cpTH2hEb4//zMZvo+7Jen8nre8vXHb9i3br/ySRu7HWbgXSBce?=
 =?us-ascii?Q?3J8uNe5JpliYx/TGk2k5sqqdjThiaGPQvfxRH/5RuTXrOb1/GNo1wSFdkgul?=
 =?us-ascii?Q?iDLt5u35PVp9k3eeuo7FEthSk6H4M/gONZWUpqKHc0wrsf2DKnkAze9+v6Qv?=
 =?us-ascii?Q?LbDLWQe2Se3VQ/pEGsGiXqb4jPKFuVDfJfEk9FNtZjRD3JpY/bG1g1I7UqR2?=
 =?us-ascii?Q?2NVFk+Ub5wHRtry8zgBf2Ylfhtah8JHv8+iNWTuJFm3BoTCKgQBC/yuoWIbA?=
 =?us-ascii?Q?p3l+hkUPXJ8GVcHp0E9Hqe5whQTBoH++K+T0jRFy0vC3cw11ZeueJQS0sHbA?=
 =?us-ascii?Q?ixI52TwXFTHPwx65dOowytQ7s2C0FmufeUVLqmig6tl1buOBQh6JbUsuL40f?=
 =?us-ascii?Q?RC6gTEaJtcK/asJ6hfIHJVfdO+pMDOMj4GCq9cSTrQjEJJqNe/1VUJ4MI8Ol?=
 =?us-ascii?Q?Ie1QTHudRPK5CfFCgz+caar3yXIlH7PVCYGT5uN84NZiSlAl8gCe4Vo7Lv3N?=
 =?us-ascii?Q?8jdrtdM5D5kmwAvfK++ZkhdqG8WUKryXHa19oPvKnNmTWTV8iSu1I47SsYKN?=
 =?us-ascii?Q?iKcOGND4k90etOpDTqgDHL/v9ca80/VD?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 16:10:24.9269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 119f52ce-18e8-4ce2-5a94-08dcc8451764
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6643

On Thu, Aug 29, 2024 at 02:52:23PM +0000, Shameerali Kolothum Thodi wrote:
> > That makes some progress. But still I am not seeing the assigned dev  in
> > Guest.
> >
> > -device vfio-pci-nohotplug,host=0000:75:00.1,iommufd=iommufd0
> >
> > root@ubuntu:/# lspci -tv#
> >
> > root@ubuntu:/# lspci -tv
> > -+-[0000:ca]---00.0-[cb]--
> >  \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
> >              +-01.0  Red Hat, Inc Virtio network device
> >              +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
> >              \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge

Hmm, the tree looks correct..

> > The new root port is created, but no device attached.
> It looks like Guest finds the config invalid:
> 
> [    0.283618] PCI host bridge to bus 0000:ca
> [    0.284064] ACPI BIOS Error (bug): \_SB.PCF7.PCEE.PCE5.PCDC.PCD3.PCCA._DSM: Excess arguments - ASL declared 5, ACPI requires 4 (20240322/nsarguments-162)

Looks like the DSM change wasn't clean. Yet, this might not be the
root cause, as mine could boot with it.

Here is mine (I added a print to that conflict part, for success):

[    0.340733] ACPI BIOS Error (bug): \_SB.PCF7.PCEE.PCE5.PCDC._DSM: Excess arguments - ASL declared 5, ACPI requires 4 (20230628/nsarguments-162)
[    0.341776] pci 0000:dc:00.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
[    0.344895] pci 0000:dc:00.0: BAR 0 [mem 0x10400000-0x10400fff]
[    0.347935] pci 0000:dc:00.0: PCI bridge to [bus dd]
[    0.348410] pci 0000:dc:00.0:   bridge window [mem 0x10200000-0x103fffff]
[    0.349483] pci 0000:dc:00.0:   bridge window [mem 0x42000000000-0x44080ffffff 64bit pref]
[    0.351459] pci_bus 0000:dd: busn_res: insert [bus dd] under [bus dc-dd]

In my case:
[root bus (00)] <---[pxb (dc)] <--- [root-port (dd)] <--- dev

In your case:
[root bus (00)] <---[pxb (ca)] <--- [root-port (cb)] <--- dev

> [    0.285533] pci_bus 0000:ca: root bus resource [bus ca]
> [    0.286214] pci 0000:ca:00.0: [1b36:000c] type 01 class 0x060400 PCIe Root Port
> [    0.287717] pci 0000:ca:00.0: BAR 0 [mem 0x00000000-0x00000fff]
> [    0.288431] pci 0000:ca:00.0: PCI bridge to [bus 00]

This starts to diff. Somehow the link is reversed? It should be:
 [    0.288431] pci 0000:ca:00.0: PCI bridge to [bus cb]

> [    0.290649] pci 0000:ca:00.0: bridge configuration invalid ([bus 00-00]), reconfiguring
> [    0.292476] pci_bus 0000:cb: busn_res: can not insert [bus cb-ca] under [bus ca] (conflicts with (null) [bus ca])
> [    0.293597] pci_bus 0000:cb: busn_res: [bus cb-ca] end is updated to cb
> [    0.294300] pci_bus 0000:cb: busn_res: can not insert [bus cb] under [bus ca] (conflicts with (null) [bus ca])

And then everything went south...

Would you please try adding some prints?
----------------------------------------------------------------------
@@ -1556,6 +1556,7 @@ static char *create_new_pcie_port(VirtNestedSmmu *nested_smmu, Error **errp)
     uint32_t bus_nr = pci_bus_num(nested_smmu->pci_bus);
     DeviceState *dev;
     char *name_port;
+    bool ret;
 
     /* Create a root port */
     dev = qdev_new("pcie-root-port");
@@ -1571,7 +1572,9 @@ static char *create_new_pcie_port(VirtNestedSmmu *nested_smmu, Error **errp)
     qdev_prop_set_uint32(dev, "chassis", chassis_nr);
     qdev_prop_set_uint32(dev, "slot", port_nr);
     qdev_prop_set_uint64(dev, "io-reserve", 0);
-    qdev_realize_and_unref(dev, BUS(nested_smmu->pci_bus), &error_fatal);
+    ret = qdev_realize_and_unref(dev, BUS(nested_smmu->pci_bus), &error_fatal);
+    fprintf(stderr, "ret=%d, pcie-root-port ID: %s, added to pxb_bus num: %x, chassis: %d\n",
+            ret, name_port, pci_bus_num(nested_smmu->pci_bus), chassis_nr);
     return name_port;
 }
 
----------------------------------------------------------------------

We should make sure that the 'bus_nr' and 'bus' are set correctly
and all the realize() returned true?:

Thanks
Nicolin

