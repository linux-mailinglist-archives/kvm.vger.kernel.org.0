Return-Path: <kvm+bounces-63520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 540D5C682AC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 09:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id D8493297E5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C5E30DED4;
	Tue, 18 Nov 2025 08:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z/60bQr0"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87AC211A09;
	Tue, 18 Nov 2025 08:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453821; cv=fail; b=iP9gyEijngJLp4BfgwnqXXAzfrFNXVjuxehcNVP4GsHSfPDD+Jzo8RKdGVIaW9wJwGmG8oO7tasf/aXC98zMQhvOlQjIrELx5VBZ4xKAN1pBdE7cnahn3ekg4PzzyK3T0D4KdB7XBW0J2MxQYgnyrzWaAxAcNuOUDQbXfJLtWf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453821; c=relaxed/simple;
	bh=GDa5GKvt6BFLRIE6ZqLow94aJBwAY90cVZQLPW4ShEw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHVs2xkqNFNRWpW5quj9Wcmbr2biYFWVX+pLVd0psxcWuqmGw7HO4PebUYNo2xNjpUf4RoB1IIbcGv8+jky549WeEeD74lRzj+gWceTg6BSC6LPDdHbn8O1GKUOv/lozqlh0HN5dH61iPP87fxtmuNFN2iQ/8do98tp2ylgBAmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z/60bQr0; arc=fail smtp.client-ip=52.101.61.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QeYbo35YmQYfNE/TD7C9Eb2LgwaFRVKLE8G9q6Ox82KWDtaLWeoM/TqbhEZ6ZgS2JBy8baLXAWjUJlKxF4G7dvBUdrvT5V2PBTCstGwuhozdbGjgImUyh7VTNY6hBiNUa0i6US9p4O5O5JG1HFl8PmQ83IZr3hMAV2zWzT1wWGC/EgqNm1pWvT9z/zkIJtV1ilMeM4d3WnPgF1HXIBzzt8qXNvovgpWCTRiCdafhICdUbyaHElA9Y4rN2AivQQ03B5b58RVeQodaeArL9C+eDQSwKPw2m183p8Dk+YgReUUNtplJSirhByay9dp2go7aK+IXLWX/pWKl+WJEveF9Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKIy0Zw8foUTi/EzOmlJ9/jrTwYXtx+94pZ9FMA3zSQ=;
 b=ek3v7LtgEJIGjI5hGgRAcALsV6UkwyDUfFJve/BDn0gwx3m3s6F90PCE+Y5I8F2rmjgri9+DPqqXSo9VtsfBXDHI0nzupp2Y8W1Cdr28/PFWJCq0MlhdCltJ6b5/HWOz34ql12bLi03HtXVyDFACVpK/FoQNrc6VZ4U0q/vQM5AhLp9L9DZKsufAlniEFwRlybgi9XFZ1KYWujyaxVb5hdSvJftppgxvEK1HI0Ud/qdGtEDwGFxpCmYxpsetVVDMjL4SAl6sH91khQHNmUTP+S4uCDMQKe79LM2HMeHPKUm/Jpsj8XPixLdp0Qj8F7nxkDEbektIHWS3K1xJjtkciA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKIy0Zw8foUTi/EzOmlJ9/jrTwYXtx+94pZ9FMA3zSQ=;
 b=Z/60bQr0BoU24jxIccItDWyoNlMZEU93uDCr+NJx/Q7a8m3kDzRQmwJVJm/Ms8FRdcw1e+7Jxi9XEF1DU8z+pxe2gNYPrndBp3KTXoY324PLxZ/jacnUH9vvSI2v6SIkmGG4fayTLLewQOr0AlEeWLH+wn+KL6/+X8UqY/+JnSp94EkAwGAn7qZdgatjCrZ7rzh2ZXAIyhIo0IbqEIy1k60ji1V2bdaUTJKhuOdSP/Vr1zV7ZblafDkyfyAcKVD8hsB9z7m7ZQ8Lr+iWCqlcf7wBMyfz7uduZP0yS4q3xzu0Ap8NTAgxFLSrWRAlfnCPoWKwo1V7ivT1IGCf8ASphw==
Received: from BLAPR05CA0007.namprd05.prod.outlook.com (2603:10b6:208:36e::7)
 by MN2PR12MB4142.namprd12.prod.outlook.com (2603:10b6:208:1dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 08:16:56 +0000
Received: from BL6PEPF00020E61.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::54) by BLAPR05CA0007.outlook.office365.com
 (2603:10b6:208:36e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 08:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E61.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 08:16:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 00:16:45 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 18 Nov 2025 00:16:44 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 00:16:43 -0800
Date: Tue, 18 Nov 2025 00:16:41 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: <joro@8bytes.org>, <rafael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v5 5/5] pci: Suspend iommu function prior to resetting a
 device
Message-ID: <aRwraX2db2DPz7ez@Asurada-Nvidia>
References: <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <20251117225659.GA2536275@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251117225659.GA2536275@bhelgaas>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E61:EE_|MN2PR12MB4142:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fc3087d-9e52-4504-47fc-08de267ad6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7hHQjBhxxpd4IjrZXgywaRWWQvxHD8F0TGbFGGI98VWmXSbvJzRJdM1snR3X?=
 =?us-ascii?Q?LDZWgHgAOjM/x0IUlAF5/0eJM5WTpFfJcdaX2ZnYM4b8YKimzG46D2sjbZ/6?=
 =?us-ascii?Q?u6qeUmgA25tvQDdjByix804iwlHB6ZQh3jAVPqJWQkUk0BwoeekIp2DvzxFg?=
 =?us-ascii?Q?Wy7kDCKlxekr+1WzPVfOtPNcofd5EXWITplNEadEphn8xB/IN38FPcSf8YvG?=
 =?us-ascii?Q?dGOHomgWuSYMkLq+UpIVLAEHl/Ryib+aaHWJw37VIjXs8MtzwHP4qWRP6PI0?=
 =?us-ascii?Q?imi6z4PT6khhqEqwuss5tx6ZWYUQm/vlZvwZTSfRVgQRMKY7pB5h80P3HvXB?=
 =?us-ascii?Q?x40+5J2+WmYt/7tw/8PM8f3rVNJTRPykTPvLmc3sUB9jigLwFSlR67yn1BVs?=
 =?us-ascii?Q?yKTYTS4DkvwAEOUZyKUBcZ+7ZdkJHxK5CEh2RHeiOJ7i5PoVgEPJ/NlQY0oI?=
 =?us-ascii?Q?wyKZcsjaXyoshdW7aKMfD5zH4oPQEMcJy0CDu3qHMTTYcDT4i68eX3Ps7OJS?=
 =?us-ascii?Q?dz9i/mOmtoqBXP9Wswx9YDOhFy53Cwrn31qlxw1QU6kxUHweeUWtfovLdYMM?=
 =?us-ascii?Q?NVLEhEgo4loN0UzxS4VYVMN7iIhRwq2oF3js6mraiXoeItpysRATLdH7jE7k?=
 =?us-ascii?Q?u+uG4DHGXO7elaiF6KSv/1d643uExiR2R3CHIHhn8GQqOSgkT1ydj6ZZjhbJ?=
 =?us-ascii?Q?LmB5buLqiVjVd5guBgkIbPtIdnqbmRR5UXS5vVfkGtvY2Vh8Ki1Ad82L9dGM?=
 =?us-ascii?Q?L0DX/21dQTFBTM6M4dOylkiUpi2FsliKn5mCT5/rNQAdQx3OMQJKSHQLjO38?=
 =?us-ascii?Q?ur6xESatI/sHByp0r9+xYiVOZKF4Hk9yud4SieUHwpADhnK0+KPeM0f5VI1P?=
 =?us-ascii?Q?h99GXHHde/eXKKz1yw5SFGOMyUhSYMkjSQ8ZAZQoBrnb+7D618EjX+3D0mCT?=
 =?us-ascii?Q?kdtSZoYi91Tbi/ZCIFXtqQVBupvzEUNQSsWu1eAJvszVJUk/g98fnkwQrxnw?=
 =?us-ascii?Q?KN4Mjdc7wcfP3orx4rFVf6ANWOUiZV3IC5B/6ngfkOO9XC43q1tLZNph24jX?=
 =?us-ascii?Q?ag8yE6N3PrG0uZj4GLUoU2vRmOGi5faxZlj/1s4M8n12d72zFDdfCOOZh1fJ?=
 =?us-ascii?Q?fAF4tRPvGUdYNFLXzmMgAQnbbH0HnxNalgK9KDbK3bPxzK5jnr2GJC39XTjG?=
 =?us-ascii?Q?pIwDuVRdpMVbXUp0PKwDCwmZPiDnTRbuFhpJbhsYdbPWOICBNN8Qcuak67fK?=
 =?us-ascii?Q?bKxjCcnq9qsS6xmr+SssB5u667zZ9zlzsSjE07RTKQqEgSTY7BhGkg/htRyJ?=
 =?us-ascii?Q?VETP+CsRo23CvK8vKQ+Z+9pEjGFPqURS2yS+Ha+aQljKvMZjlFep+vpJqjDE?=
 =?us-ascii?Q?ZaTFZWAGX5bEBsJo3OzSnyCCffA3Lgi7lOIMY7d4X63cszL6aGOE3kcPj7/I?=
 =?us-ascii?Q?Twrx3CUcMHl8zybKe48cTeX8qxv6dbQ35t6U6BpEEVhhF1yYbzX0HVq2rELf?=
 =?us-ascii?Q?xBaSmWesrJckcRieVM9tLiNi6qD0GxPptY7v5CWX88nAFMZxp088Tdnla76C?=
 =?us-ascii?Q?RrLr9SfvpU2PlFUClxk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 08:16:56.3639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc3087d-9e52-4504-47fc-08de267ad6d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4142

On Mon, Nov 17, 2025 at 04:58:52PM -0600, Bjorn Helgaas wrote:
> On Mon, Nov 10, 2025 at 09:12:55PM -0800, Nicolin Chen wrote:
> > +int pci_reset_iommu_prepare(struct pci_dev *dev)
> > +{
> > +	if (pci_ats_supported(dev))
> > +		return iommu_dev_reset_prepare(&dev->dev);
> 
> Why bother checking pci_ats_supported() here?  That could be done
> inside iommu_dev_reset_prepare(), since iommu.c already uses
> dev_is_pci() and pci_ats_supported() is already exported outside
> drivers/pci/.

Ack. I will fix all of these.

Thanks for the review!
Nicolin

