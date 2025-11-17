Return-Path: <kvm+bounces-63411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CD269C65F8B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B351B4E9579
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4718A285406;
	Mon, 17 Nov 2025 19:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W+YUQTDf"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E2D258ED9;
	Mon, 17 Nov 2025 19:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763407645; cv=fail; b=Tj36UfQG7h2WP9RHMEue2oSkOaGcNMMIXrZDnYLWSFQKaYP3Hv+KghavL3Tu6WhsIHa/fbQaE2UZzN4bAC1wP2m8sJ1V4PUvUwl1PKuwAeROFt9xujij5ETLf/r1PrcPnXH5SqEB4GOhQZ5kjujWJrtYZeEoT9LDAnOcv3hU+Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763407645; c=relaxed/simple;
	bh=EPSIyBqYsftrWN33pDg61Z4PFYHFFnxUorBgocMRYYE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQuFaF9194m0HdhKZ9ZGNrNO36S9Ct7yRHkdDR67LWw25X4d9MHxaUNUdTO8JsE64AVXmceVCD2trpqLngZCfQETd6JPz7aTP9pow/5om9Rl3ruEi4WSZOdTaKShlfm5v4E0UQQSZqG0/nlp4eB00wFk1PHobTvvWWyztD9vrbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W+YUQTDf; arc=fail smtp.client-ip=52.101.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8BDpNYWjTXKDy8wKFuDDMrXh/cOZ5lGKcwzRExAc9DJFsUvbz3qMyRA4SKrP1vlRUYlQDmYVwbBlONQOPv5aBZJROFdV0XZP8FWYxCZn9UdBxGhhDVR1RIlbT5irjMN74knY3EwH/yFP8egSKNj5EJ0JhalBJ47foPI7uzC5YDd2Ujv8KUZAF7VYxBnfs37cLjXyed3oPJMNJ6wK5LK5pA+GMwrb7egvRoAoI3QZOduLH6m0TRsVyh84Wx0pE6R24Qb1TkrN5vMMcmqd2nx3K6Ma03kLz7I2wrjHlcm0K9rmBX6gMffM828WuaUxAB0Runia3OzMFeQ41n2keELmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pc2gODHOkDCmzRlqjNChMCK6ROV75bm4nGrj9TqD1Tk=;
 b=D5dgPg435YR3gNcHzkA588UPpyaMNqwIk6Hq/K4uMIKY1WULTDTwG8wuqsP3RpcrOqfwpNkhEKtn6JjElTOOkUr3Ff0mOTcCWeV1247cDI2S7O8+WT3eRhrws02G9coHG+SSbP2Y8nC7WiymKUshdx84GQNeZqEwaX2PKS/fVfIkGJr/yBepasH41NxyTFABdAdDDmNUb1k5ESXkqFrY0FVwvpEKy+UF9KDkmZD644GNkEma1FM3eZ1EZ1+Ms2KFjHdOnka0q1+ay2sqxbdXbjWEsJDsGM76iWuLgU6DZSYS9ETIoVII2AcConcoW2qq7oUi2OoGXShpzpUbAybubg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pc2gODHOkDCmzRlqjNChMCK6ROV75bm4nGrj9TqD1Tk=;
 b=W+YUQTDf0Mm1cnYgoWyg9nW9Y/hv1xWOjPpP+JWFrXWqkao5f1OoDkbaptwOcAsAin90QW6sYpQcrf4hrCiM4azSgnQ5lbbjkhmjqtNNzpPcnYfKc8VCp+KfvoIo8hw/l1/cM/2xeoGPaXHiVtLL/WTIt3YZ+J32OlH9Wr3T0gXDEX6mkmWuNA5o4A2p0KJ4fU45gUiOx+kd9xjhIS3yD32dUOQ04N+AIjpMt4MXL2YBi1SfFYf/Eew8l4oMQB954ufMUJcSBd3W+4lbBhWAzoQFq2EvDI8Uhq/IBHP9yKrUJsdA9bgxK+ZGPAcEMxnHhcTdPIDhCbP/5fMuwhWUxw==
Received: from MN2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:208:236::35)
 by DM4PR12MB5985.namprd12.prod.outlook.com (2603:10b6:8:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 19:27:18 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:236:cafe::85) by MN2PR05CA0066.outlook.office365.com
 (2603:10b6:208:236::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Mon,
 17 Nov 2025 19:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Mon, 17 Nov 2025 19:27:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 11:26:58 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 17 Nov 2025 11:26:57 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 17 Nov 2025 11:26:56 -0800
Date: Mon, 17 Nov 2025 11:26:55 -0800
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
Message-ID: <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DM4PR12MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: 4740cea3-8bac-4327-f97c-08de260f526d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zlKmCZlFMjyPES8pVu6Jpx6je4Xc0qQAPE9OnBe3bpQ2isCNGdVVB1V/pFT8?=
 =?us-ascii?Q?lLQHvchk+eZfcc9WETDAsgtv9FEvp2FV/3zBHF1zn0zaTXMW/NLrax4PdfMq?=
 =?us-ascii?Q?vSuWazjNi0MZhkHT1DQycgxrn64IG56rsO/xOUY+luP09auDq0bqd1YQViTi?=
 =?us-ascii?Q?QvXo2SMqwbNK6YxHlSsfFOUHNIURPSyzOl5NXKzsrKMEn4dKn0bSu7Xge3hX?=
 =?us-ascii?Q?kJ2d7fOTwcEg8i9blLdTw9Vka+5nvWkYUOLT/GP6rAAGqcbJdUNrWYICNVwp?=
 =?us-ascii?Q?5wwP3uqxYpyJaaAkW5DxvnzXMBupaFqw0TNcdk5LdpFyqeO1RgXypH6Ag1ug?=
 =?us-ascii?Q?lm86SZ4Gs+Z9w+89YKOsUZNFUTiIcECiUy68PSzzS5YuZ+ED2dEqqvseQ+tZ?=
 =?us-ascii?Q?a0gxP1puZKcjz2pRbFNyj8caQRYmySS5M+hzM1uAFX/yFzHmdT+hSn/FTccC?=
 =?us-ascii?Q?mPiE3X8VfmDKmPiy8CAsVMP+eDRqJckCkjZ5G/+vb9cRzl3kgD7rR9VgaZUF?=
 =?us-ascii?Q?1rSmIknxnug/fMg/NBD6UNU1A+w/9kg9BdiqD4zG/cOkdTuko0OCYZpo1HqP?=
 =?us-ascii?Q?QtAFZDZmRrXCX+YuHQlttXm27fTYcgCgcfJfYNRNn8gcwRm6dM+wOwhXxdzC?=
 =?us-ascii?Q?Xwz1kGS+Xr4vwACPxTwkY67laQ0aN0DkC3XCsG3Fb2ko787JX6M3v1TQgQnK?=
 =?us-ascii?Q?6Enmt/E7dkfd8ddwdex4g4CGv3A54Kz46uva1VHo/r3y7s4K7bwiqTZMbACe?=
 =?us-ascii?Q?0x8hBNHv+BjImgOtww6kIqFKHBG2Vi9vEckbAHVaZD+cEadVqxbbTDtpWAVa?=
 =?us-ascii?Q?36JAC1AbQ7meJH5juNe6285HN4UQLYlO3oxpXd23I2aNc9MceWvqJY44dJay?=
 =?us-ascii?Q?zW1X+EY2BSG+5ov3815ol38VA6sr0vioXxNKIscWiXFLao+EX3oS/0Yc874h?=
 =?us-ascii?Q?27ZOyJHCmK8YQZtqyU63Sj26hOWb6GoOK8428tXIptJSBLGBidWPPTKcCQNy?=
 =?us-ascii?Q?0JP/6g92uSuSF67p80SO/hV2ldDXhQBDXJ2Rgz2sLAhsPnFuOzlfO2M1zJXB?=
 =?us-ascii?Q?8Bav2feVvYq78RF7w/SBynnPfx+n1rPv3sRxZR3vMOLxVzy51schgpgIQyAg?=
 =?us-ascii?Q?uIJZA9rv3PoFtSSXsRu8+/0gqS0S7mAkNW4RcBMVU99LTgw2BumIg5Ql09o0?=
 =?us-ascii?Q?uvN8xky5zL04YDZ2Jt/9pUB+Pb9C8hFB/08I6sTdGtoZcB7VAwcgBwyG6/PD?=
 =?us-ascii?Q?Z/xRRIK74U7gb5cRCthT9FrRHKQa3q7StmGZ+nklXI/N5hTvOgk96DByOCzs?=
 =?us-ascii?Q?qlyBRheNCoD2vppsAne6PJya/f4sQ9RXLTTx+JH6jGEi7mnwtyMzD8BnrrIU?=
 =?us-ascii?Q?3isogBXY28rPIPJgp8YM0SspV+Zza3ivWZqPuj5zpoCmDRypbG4sQypTho8Q?=
 =?us-ascii?Q?bujHRouDKRNIAVRwM+bAoCA1EhwCClAP/s3UIlXGSuE3wfb/rtg4DcMeEu8A?=
 =?us-ascii?Q?sBmmqDjM0jS3ZT6N1ti9s9bbMuP3wduNceZzxKqe/Jlqgg/7kPoxUlUKu91i?=
 =?us-ascii?Q?kMOfLGCu12NsdKMWhis=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:27:18.0713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4740cea3-8bac-4327-f97c-08de260f526d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5985

On Mon, Nov 17, 2025 at 04:52:05AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Saturday, November 15, 2025 2:01 AM
> > 
> > On Fri, Nov 14, 2025 at 09:45:31AM +0000, Tian, Kevin wrote:
> > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > > Sent: Tuesday, November 11, 2025 1:13 PM
> > > >
> > > > +/*
> > > > + * Per PCIe r6.3, sec 10.3.1 IMPLEMENTATION NOTE, software disables
> > ATS
> > > > before
> > > > + * initiating a reset. Notify the iommu driver that enabled ATS.
> > > > + */
> > > > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > > > +{
> > > > +	if (pci_ats_supported(dev))
> > > > +		return iommu_dev_reset_prepare(&dev->dev);
> > > > +	return 0;
> > > > +}
> > >
> > > the comment says "driver that enabled ATS", but the code checks
> > > whether ATS is supported.
> > >
> > > which one is desired?
> > 
> > The comments says "the iommu driver that enabled ATS". It doesn't
> > conflict with what the PCI core checks here?
> 
> actually this is sent to all IOMMU drivers. there is no check on whether
> a specific driver has enabled ATS in this path.

But the comment doesn't say "check"..

How about "Notify the iommu driver that enables/disables ATS"?

The point is that pci_enable_ats() is called in iommu drivers.

> > > > +	/* Have to call it after waiting for pending DMA transaction */
> > > > +	ret = pci_reset_iommu_prepare(dev);
> > > > +	if (ret) {
> > > > +		pci_err(dev, "failed to stop IOMMU\n");
> > >
> > > the error message could be more informative.
> > 
> > OK. Perhaps print the ret value.
> > 
> 
> and mention that it's for PCI reset.

OK.

Thanks
Nicolin

