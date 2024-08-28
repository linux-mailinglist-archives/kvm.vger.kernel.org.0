Return-Path: <kvm+bounces-25280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3ED5962E4C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 439C81F2545E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5742D1A706A;
	Wed, 28 Aug 2024 17:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZMbdv2wj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA73E1A4F26;
	Wed, 28 Aug 2024 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865303; cv=fail; b=iGE61bO7aJbHIw3klqnpAjlgfAlrs/wm8hgLFg6nm3avgHjx6LEPJTuihX23xg39EjWwmKi6YXypjwJfTZWoEe0P7h1O9Or4d408lyP2ABBsypXIj9NTq8SE53LWe12SldErX/DMs2XB7S1zr7/SEVU2008ZRF9i69vCmVBltVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865303; c=relaxed/simple;
	bh=AeKKHHQmVWX7EWovtmb0JyKkMMr0UZnW3ixiz3MbcNc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9QAHKUlfJpIICiYxeoSrz+05W330rplX5EU9VRoRUGHnbcjcAtaBTof82MXV32hnbH/9TZSWWMO1//BhGHGpYd/5v7zPIq2QipLLvcp4Xot+HcxYD7SSerzs63HTgyCxIo0qgNvu4HALrtM6onW5dZSUUch2KdHFr0jMgGZAdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZMbdv2wj; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jew+J/0AjJycqAk3dXWDLRu7qbTxUeMmqrT154YR38Xe/hK0GbV8Jh3dSnA9r3hqkJZ8fS2Mx+YzYvd8eJC/yNXUxCTXcjMxb9vACQxbs71k9HaHz9OArLM/q37SNInN2XVUy1ja9zLv58nn6aSVpJnN4eLTOgm04rn3fE97APsR4IGgq1uBOqhtXgVAJYWQTLc7B6jAq02kVD/RQXnpJ+/iYQ6Rr5CRhm14FCJy4uE5Bo42BGzRGLoaPJq6tex9X44CG93y2QonHvNNRpmGDGRB4nmPn0OmCkX8AQ0zYbwQkja6568wbFVkA6nQfJkj/cBfiUEhklZIQ9X0SyX41g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nNtkwOU+tu3OgDX154zW0XLjORC6rRaDZvqZ2P6J+Y=;
 b=orKK3aZ7BgLfBsT387/l19nJ8NXeOIUI9WXEo0BhgI2SIv2VL5kAbCITBZSeJR7/L12xaRX4WBAUfdi1m13kz27mAwiXWl2XTeRX0x06m2/P4wMtPUOUZSQgaaypnsnHkP2DitZmjHv8BFJFBfdscXgEBZqE5UZhBZYaYHbXG5brPL36t+Pi+GfnEc7My/ozlVo8TFpMch4BFPdxk1k02xEv25k/U/ksmsGCMmhZnU9CnlvOKMBbiGwoXd9H+vAvsPMc976WCgpxT+YkAr8A+rJc3cyj91exTQx6ZM3/2nfKqXUnQIDlKQWA/kgxsLnJtQWPP4Pjcn+y3OkE8Q409Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nNtkwOU+tu3OgDX154zW0XLjORC6rRaDZvqZ2P6J+Y=;
 b=ZMbdv2wjToNiGwDexpDSS2GUfVEe/nNv/j37mlp7mNDoa1aKECwaoeCx/GfFjZdlRkJX+yEQFpYp3ODNxRiuDb7nKk87YvX1VEE8DxpRUNTUohJRuDxbclGXf0XTDEteUgFWJLt/uJud0P+/B05B8Lvj4VIdvYcIUv9+SqhCuEauHKguOwMeh7AXxnt8YYdX5nW4mkR1i+j5C4cR7u7qRtYNsY+FNC2RFw3cTImUYe0rlLzowowkQgA1OZVKKRKfnT8Ny3/eNSWROPD/hAJhIa9fwYX0kapX8WlRbEIfBYubTWxeCKBMsGdXYDSogprTHHqYeQDKPhi1sDCK8VTDfg==
Received: from SA1PR02CA0004.namprd02.prod.outlook.com (2603:10b6:806:2cf::8)
 by CH3PR12MB9169.namprd12.prod.outlook.com (2603:10b6:610:1a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Wed, 28 Aug
 2024 17:14:56 +0000
Received: from SA2PEPF00003AE7.namprd02.prod.outlook.com
 (2603:10b6:806:2cf:cafe::5d) by SA1PR02CA0004.outlook.office365.com
 (2603:10b6:806:2cf::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Wed, 28 Aug 2024 17:14:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003AE7.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Wed, 28 Aug 2024 17:14:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 10:14:34 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 10:14:34 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 28 Aug 2024 10:14:32 -0700
Date: Wed, 28 Aug 2024 10:14:31 -0700
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
Message-ID: <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE7:EE_|CH3PR12MB9169:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a58c9f6-0c7c-4396-4a32-08dcc784f00f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IqvYqOgyRP/4qp/XI9n2DdOzeKDsZGmO8Vv0bOjkpRwQGxegjTyktvefHrCi?=
 =?us-ascii?Q?J7q4xm0XiN4GVQUsLFk+t0PV9WOJ4lZEdObJgIeEoPGnudpWVbmjCZoUSsT2?=
 =?us-ascii?Q?4E3DqhlDyZQrPDPav6pX3ZGb6iB+cGrbVhSt3igu2uOqvRfCKwrh2/rhbjN7?=
 =?us-ascii?Q?ZlzLPfW3rXRUbuTunVXYA5nmMCb+hkjbyI9JiDIA6EatKVKczR3o2FcgJPpP?=
 =?us-ascii?Q?4jrKaD9DWmrlDJC2d5ffK3/cs+mlZoCaDpKCl5+BK05Exg8GKOTLM6LcSUYm?=
 =?us-ascii?Q?0e5x9c0aO6jwk4YAvN1x6ur+OQ8CqMABW5eaHKIFdkk+5IyR94wUs1HmBGaD?=
 =?us-ascii?Q?zFHnEiyjViJyW/5vBiPhXnLzVvEv01tRsIfDaWyycdKzX74ODSUusI50iWhv?=
 =?us-ascii?Q?QAwOxT7CMOViwE8cLvA/JBE4KRRzhxriWyyHECOuiJOVnA2tTGGBtvJwflPd?=
 =?us-ascii?Q?EDhUevNzVpf7AuMuBQGl75fE8ph1hWviSldcS7FuvovAZ6lLi9ym9vx3dlLW?=
 =?us-ascii?Q?+6sCISMmsNO0aLe5XsSnN3TlrI1sAICL0tyQdN2pDhxfC+QmBTamBkNiKxts?=
 =?us-ascii?Q?X19FfUGKg8W+sv4cEVv4hcP9NgdC9+YABvtwkyrUA/Xt98FgWLmKgO9M/9R+?=
 =?us-ascii?Q?212zOKL+6STQetydDU2+iUn57mRsq8SHSFV7bCFJRbq026wzypDiH8qG7Vjt?=
 =?us-ascii?Q?gCm1q2x9DlFm/zYd070Z9rGQ/JrXCCsk3cuQbhtsq9xH0SF1K36W+DGWDM4X?=
 =?us-ascii?Q?TDRtVcO9qRWuRcrLOpP0rnMKzgEmK0qY3lLOAfLv/27NAdzKrcdQ4QWrS7Xi?=
 =?us-ascii?Q?g989/XrAMICiegVlGpc++Cicf/E+nu0REtyB1VXxxpQSLtby731obH+XIrJo?=
 =?us-ascii?Q?JM/go+e2Oail8YqfEhEliDMyy+8jUQVY9mtl5AGYn3TNj0QdyMFi3SzrCXCe?=
 =?us-ascii?Q?NWxSnZbp2Qnh4WAd1y9gntDaHi1Yv0MkSutz3wfVyBfo1UY0F+qGUAV1qxET?=
 =?us-ascii?Q?NhVch5RgYzkWM/z/eQL8m1asCrrSz32pQo0UDivTzTk9v/MVbgaCLpWH5YBt?=
 =?us-ascii?Q?AN1MUHnkXKCb4xCZXsh/pL+v7UIb3CDICQ4bBHoYJr2IUdcZU/G9pc40jI26?=
 =?us-ascii?Q?PLU0w5hA0ee/ME443v2Zjrj7ZQLu/queBSNusdla2jluZjjh0V7dN2l9tptU?=
 =?us-ascii?Q?Eb0svKy22SxjV6K172DBP+LK4teN1pedEMCVSOv7TUBQGGBqKGt2ZRB1EWwe?=
 =?us-ascii?Q?XnBOhLpBCeG8zmLoztLl5hUt3X8OV2D3jY4ZF1I8qrmWcWIxA5dJQ7Q2SP2v?=
 =?us-ascii?Q?tPo7hPB4XxVeT60BstN7vkay8ePrGSdik1nZ3weUA7dYG0im2y/d9ftBF/X2?=
 =?us-ascii?Q?Y9IQoyViYKdnEghO7nilaPxYUOUTFjwzFp5+NJTlr2rNiMHVVX6foYap7hEW?=
 =?us-ascii?Q?HhncubUzDRxncxr1qJH5MOGkOMSWWBJZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 17:14:55.5349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a58c9f6-0c7c-4396-4a32-08dcc784f00f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9169

Hi Shameer,

On Wed, Aug 28, 2024 at 04:31:36PM +0000, Shameerali Kolothum Thodi wrote:
> Hi Nicolin,
> 
> > -----Original Message-----
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, August 27, 2024 10:31 PM
> > To: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: acpica-devel@lists.linux.dev; Guohanjun (Hanjun Guo)
> > <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> > <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> > kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> > acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo Pieralisi
> > <lpieralisi@kernel.org>; Rafael J. Wysocki <rafael@kernel.org>; Robert
> > Moore <robert.moore@intel.com>; Robin Murphy
> > <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>; Will
> > Deacon <will@kernel.org>; Alex Williamson <alex.williamson@redhat.com>;
> > Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> > philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> > <mshavit@google.com>; patches@lists.linux.dev; Shameerali Kolothum
> > Thodi <shameerali.kolothum.thodi@huawei.com>; Mostafa Saleh
> > <smostafa@google.com>
> > Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
> >
> 
> > As mentioned above, the VIOMMU series would be required to test the
> > entire nesting feature, which now has a v2 rebasing on this series. I tested it
> > with a paring QEMU branch. Please refer to:
> > https://lore.kernel.org/linux-
> > iommu/cover.1724776335.git.nicolinc@nvidia.com/
> 
> Thanks for this. I haven't gone through the viommu and its Qemu branch
> yet.  The way we present nested-smmuv3/iommufd to the Qemu seems to
> have changed  with the above Qemu branch(multiple nested SMMUs).
> The old Qemu command line for nested setup doesn't work anymore.
> 
> Could you please share an example Qemu command line  to verify this
> series(Sorry, if I missed it in the links/git).

My bad. I updated those two "for_iommufd_" QEMU branches with a
README commit on top of each for the reference command.

By the way, I wonder how many SMMUv3 instances there are on the
platforms that SMMUv3 developers here are running on -- if some
one is also working on a chip that has multiple instances?

Thanks
Nicolin

