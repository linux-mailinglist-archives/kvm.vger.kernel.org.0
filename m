Return-Path: <kvm+bounces-63241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F359AC5EC42
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B51A54A01A7
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6ED2D838E;
	Fri, 14 Nov 2025 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UmIXN1Id"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010004.outbound.protection.outlook.com [52.101.201.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB872D8367;
	Fri, 14 Nov 2025 18:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763143275; cv=fail; b=t90F7nPxn8m6F8PswGenDgdmpnXNaxBpCsx9UoM8PTp0m7CE771puvYnbUmXRmg3ND4bo4wqESDpp+ts7hBNVDECKAqZz+skpaqZoom5jy7CYkF6R+MYZy0hgZHgQCy5evlOhleHvZInS7ln/EYUCjo3MqDxrqH6ZVzJbFrEpkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763143275; c=relaxed/simple;
	bh=dtth237SYBtmUoIOqVIaWBRtIhZ3TLKL5zBUYaI7H2Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlFOiOQDGKfSkbFsAefIYsuI1xqN485I2nyGHU25+GM/SiEDgYty5Y/x1vGessAiH2ikrxTcbJpE9EPojbo/llPDYt/Ss/L7PolaV9VXxApOk88gEnyxfou+gtzhkXF2zsPn8dGv0N6yo7URq4lysYv3K94Iwc19VQiGrFBuR3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UmIXN1Id; arc=fail smtp.client-ip=52.101.201.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g5Vg0WOlLO9QnVvpNoVyzBb5Q2LZMhi1DZBd/dmCysjgW+wjXPA87RjwCXPC4bd693t1CpiVaqfq+Nd1aIAv+ddfRdX/VXdbSwo5tIux3MJ4tl766XKqrVbhVUKEWlv75yXcLS0N1QP5qwjt4qnlYCFLBLzd/YbOGUcw41YbM9GMPcsl/QBF1YJxEuiWhpkcQFPAN12DEQiHf8qn2m40Zpdhj0sg3FsUOZu0kRQ5SCcIp7EuH0lk4X9jLLBYsnIdgcUqI3xWcZiH/epNe2rMNYq2i5U4w+80lxwDwpLryCRVBCy+eSpqe5whunGPOVOUGzddLTB4ClKRej3W2zixFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fei2MTGWh2LdRoR3ef1akYdXBQVwcktqvwyxc7Hwx4s=;
 b=aMeF44ozu1YYvO2gsRPmVtmTkOpEwie8nJQthCAowLBsvT/m2+DeHFIqJYgIpVfgUqK8Z6VUxjPhA7xDuNR2/bjvg++asfjIZlCQqBiQJYsKTiuLysNdiTK5BEp6/rdVtCaBzy3D72Psg+0r31xMESMayHo5J6ppwTXoQQfv0sU3Am0sJWQSMsneeTaOjEhH85EnomonEWeexm8ztqd/G/Ah7wKHMapIwIvs0ZOxxQV2lo6YtDKNprZZGL7ANYSSyirkNdZTsL7ouF3z3NNoU+sYsiWsJuksd6B4rkusJYA1BXUsuN3PSyTZ1ctUbGSMnYii+w+5Q7mkvNpcO6MY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fei2MTGWh2LdRoR3ef1akYdXBQVwcktqvwyxc7Hwx4s=;
 b=UmIXN1Idh+MN1dHulHjI7RvMaAfEK500+LPrU+88FeSI1JSoamIo/7mD+o3fRjAAnMb1Vqvm6IGDnn5eY/mGsm9A6q40FgAMs88v4+MyNTX7Yw7o0R6LJK2lF0B6++0HBwZVHCN8pxO/EBgX6+lcd1ux/KbidigQso/AgM7ri5nIMMuDNdxVHJEV+01LilNOjkbvnp88hc8g1us3Rb9YQ2dw4EmcC9lNE2FEkl3GKSvRiQjNa8NnCtXdQ+vJbhtaQn/bTRt/yDO5SUp1Wu7cRknpfk7AoXISytMCnCSF7/4aK9nuCn7ZUzGE/QA44v2MGd4WNCiT2eFCfGKde9HE2w==
Received: from SA9PR13CA0072.namprd13.prod.outlook.com (2603:10b6:806:23::17)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 18:01:06 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:806:23:cafe::46) by SA9PR13CA0072.outlook.office365.com
 (2603:10b6:806:23::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Fri,
 14 Nov 2025 18:01:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 18:01:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 10:00:42 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 14 Nov
 2025 10:00:41 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 14 Nov 2025 10:00:40 -0800
Date: Fri, 14 Nov 2025 10:00:38 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Message-ID: <aRduRi8zBHdUe4KO@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b01a55-7513-4668-6b8b-08de23a7c85b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GC06iAck6zBl1Sz+YupLcRx2MHbSkkaxyu9R3/ugVzyDesKYrQfjLmYiUdcE?=
 =?us-ascii?Q?lhydIqSkPT6k5iRjsw8+gXbjasOUqkzpNterO9C88gBTbsOWv0JxIj4/z+qM?=
 =?us-ascii?Q?1UnPru33+nbO8uc6EaxsQNsIVvUP9c78J2IrMMVORQQhjVQmzqtPm6fcyzWZ?=
 =?us-ascii?Q?zksGe1dZEmojjUEWIlXD5gl5rP1S9aliKYiz7qmJqk+jMr0PcWpa4fxL2BEY?=
 =?us-ascii?Q?WZoMuCKncFgEkzMX9b3Pz8Syb2FmRIyvCgBsoJ3YuLvddEYXxtKPJlKK4BYA?=
 =?us-ascii?Q?MAlS1y/QgHOpcrzrfhcYMYlGQbCFM0pB3/2rqmHptsEwqCqYgpbbCC8dT8zb?=
 =?us-ascii?Q?/k0DEwebbjnuw6DPjXZPL+vZN6v6qJfy5/fKho7pWnfNpNu6wCUmBYlzb+vT?=
 =?us-ascii?Q?kzDaez9oVvK1WApjdCEhisNj3fkKcau7pcc5QPnl8DRJZ7SZCkMAnqVYilGX?=
 =?us-ascii?Q?8wPI1oc7Y+VcGl9WHN9SACN0eouAvtWMzG0NhzDdOPH5GQQIRhFMDR7mzXNE?=
 =?us-ascii?Q?QrfzSVpKkjyHwW37oE2HbND2llFFCJ9xI7+JyFRy5s4Ow+6G9cdk62yr42zL?=
 =?us-ascii?Q?B6A81AKApKS9KGLiXMd+Wbk1Z/dbbU6sRFGKvrGupj8WBO2RHegbtIl6825t?=
 =?us-ascii?Q?oCzP2qR92z5x39lQ8101sroCpoimZZTlJEi89rIweHnBMrRm5tXdWGfwmeSd?=
 =?us-ascii?Q?x8GUYYZ2MwRvsWkv1mLoN56YQkIJdZ95WQLz5RmCsnvLCfp+GJJ+a3v7RhbD?=
 =?us-ascii?Q?XMnSPBhyZnvIPS5atVKYvGjhKJbxvVFrwHtl1UiWG6AiwqTmwiqbHz3XM+B0?=
 =?us-ascii?Q?8A25VPdweIkX8qI9OUfrWL1p3E1YRQEfgZF7Kh11VTEsllR1lBkBfgIuZ1rG?=
 =?us-ascii?Q?d6QG827lFpAbai7qU7CbcyvdWeEuu/ypzpfclyudZ83zoBDPyapz+cNmnjqe?=
 =?us-ascii?Q?gFPJKH6vO6ybwCevln175/GoUfriscVW8F9+9Hr7JiE0O6JVWmlG6TlycCru?=
 =?us-ascii?Q?Ne0Xu6uTJv6Jwrml4zQSxSkZsQ0tGJ62peYs9TK8LGV3tqW1tVLFxpvDngNn?=
 =?us-ascii?Q?lHHQE35DpsIC/lGUXPClPhHgTZh95+v+eV4baWQPUCRNJld7TM342BaHJrmP?=
 =?us-ascii?Q?ANJCvGFkXIiYvKmxP1mjFBuO0B21hrNEMVfR0T1wJoTjW8dIF5Xwy9KUg8eG?=
 =?us-ascii?Q?n1zOqQyMV9CKS/WJx5FjrVtxegPFDI0igZZAFx4dHDTDGwjo1trhBPPS6tdU?=
 =?us-ascii?Q?wkx2mFsEnAgMhLPuvRpRtuY+fsKk8uo8lbNWrBS5yTRTbmvjCxZWl9U4jZiU?=
 =?us-ascii?Q?voYOjlhRHYYMJu7B7DbOBg0aU/TXFaf7BwFFj2LcCJBCPZ7uhMQQpC8WXagS?=
 =?us-ascii?Q?uwX+o4HerEo/i+QTYAOk+xqJj/MkAvb2hEKsbWHV3SqRZdWMChwNk4zKcbNV?=
 =?us-ascii?Q?GIoZAsX/5Ue19Ao+21eQCRO5T6bIs1m5mi/qzBkA/bJe7ZoE3MzaGVEiZ4sz?=
 =?us-ascii?Q?ou0p2PJSGc3OL2N+dLmTxqKtoaV+Gh1gct+gLXV4Q2BJmYYiAvFqdzC+vgpx?=
 =?us-ascii?Q?m69wpYNK75zt/K5ZGiw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 18:01:05.9688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b01a55-7513-4668-6b8b-08de23a7c85b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412

On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, November 11, 2025 1:13 PM
> > 
> > PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> > reset. This creates a problem visible to the OS where an ATS invalidation
> > command will time out: e.g. an SVA domain will have no coordination with a
> > reset event and can racily issue ATS invalidations to a resetting device.
> > 
> > The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable
> > and
> > block ATS before initiating a Function Level Reset. It also mentions that
> > other reset methods could have the same vulnerability as well.
> > 
> > Now iommu_dev_reset_prepare/done() helpers are introduced for this
> > matter.
> > Use them in all the existing reset functions, which will attach the device
> 
> looks pci_reset_bus_function() was missed?

Will add that.

> > @@ -971,6 +971,7 @@ void pci_set_acpi_fwnode(struct pci_dev *dev)
> >  int pci_dev_acpi_reset(struct pci_dev *dev, bool probe)
> >  {
> >  	acpi_handle handle = ACPI_HANDLE(&dev->dev);
> > +	int ret = 0;
> 
> no need to initialize it. ditto for other reset functions.

Ack.

> > +/*
> > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables ATS
> > before
> > + * initiating a reset. Notify the iommu driver that enabled ATS.
> > + */
> > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > +{
> > +	if (pci_ats_supported(dev))
> > +		return iommu_dev_reset_prepare(&dev->dev);
> > +	return 0;
> > +}
> 
> the comment says "driver that enabled ATS", but the code checks
> whether ATS is supported.
> 
> which one is desired?

The comments says "the iommu driver that enabled ATS". It doesn't
conflict with what the PCI core checks here?

> > +	/* Have to call it after waiting for pending DMA transaction */
> > +	ret = pci_reset_iommu_prepare(dev);
> > +	if (ret) {
> > +		pci_err(dev, "failed to stop IOMMU\n");
> 
> the error message could be more informative.

OK. Perhaps print the ret value.

Thanks!
Nicolin

