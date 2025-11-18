Return-Path: <kvm+bounces-63497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7946C67CA5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 2AE112A170
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8627C2F49F4;
	Tue, 18 Nov 2025 06:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b2kycD9p"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012062.outbound.protection.outlook.com [40.107.200.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1B2F25FA;
	Tue, 18 Nov 2025 06:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763448834; cv=fail; b=Q/OG5y8GM7fKy6MVu1ZHyeYCxms98EAM67rEaSe+p8Zlm2C5+oVJkvCpau796qGAoL1YbL71Yzqn294NO9h24EL1hFCEOWI3JBGbiOiJ1IDDfP9skVtV34Be0AqLyWtzzT8JJG+xH8rzGr06vCnNo/ymrKIr+1NqaW8AapuwWq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763448834; c=relaxed/simple;
	bh=P0H+Yqcmwr3oqZKWWDsq90sqGKTIdsPG404Fm23WxK8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NluBHUvt00r1m8e/FNzEeBo0Bs/mOJZDed8j6qDyTC1qWihdMiQ02/NOx1HrWf/XxcgduvaCrjZJi4qq3Cqsjc5gpjfeW4mRWl1F0fJCCDDqny4e4t7sNp2uSlX4rzeARHaorV2Q3+x0MLahcpJXzSIH4C1lT0dKrUNzbeLavgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b2kycD9p; arc=fail smtp.client-ip=40.107.200.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nw6bB5w+NDH4to3wYg83jkh7IZhy16CTYcvLeJ5TJ26u7cpXEyMKLn0m1esMUOIylpjeNFJcEMYHKXjKo3fAwH1YX3s4XlDZt5cMOagqAzNIl58Oj0kD7ZB7WI0ui7ph/kjkAPUT7dVKmC0Mim1c9fILyeCWbWoPOpCqPd3+sqeYDkj8P0L0I7/wKxAWMG3kTCelsJL1FvWOkILZKYtrz58LWhDHl0zyLDi2P1AbZkgwJWI2awa/FQU8YQMlH8QYX/XIV1v5N/f3CH1QCT697mmcwAolZFmNapPfnW/qKiFNoIybv/84wadd0jyNlyiQ5SCSpBbNCtB8xmBKs0ZKqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Osjqj8V1FDppRyv1k4z6s36nOM8ym2tk+tZRpFrgiTk=;
 b=BlllSa5MSlbe2ggVELCnzvetjUgFZAvI7LP9KxXNMQ8lb1oVPaMRXvhKmZ+kmvnk6zLaVK/Bc95oEpIxpq3+FpvqJL8X7OdU7QQiHZGqLel6c59X+s0nq/OAeYxIgC6XmCiTFbpnwiZ//lxtfrIqby55YchHwox0V3MmFSaiYUHiY9XyZ8aKo7HELQcIqjcHo7lChYgADK+y4OGMkU2prX3UTRq0zaqEnhb5RD03FX0yLXrZQRKy1CZGLt1RDdc534OZhf2yGaRdQEcKH4xpb/5AM0NzzeIpE1Q6YS3jKGS5ET5nzTdlrReRUETgloGxjL1Q5dO1iE4DLi91sZocRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Osjqj8V1FDppRyv1k4z6s36nOM8ym2tk+tZRpFrgiTk=;
 b=b2kycD9pVubNet3HQ98+MIRWk+HRcjDg/T9o9yyY/uREAUMACsEmNF8MzqT/adn82TC3GSTHYI1edx1+wSqLHkxkFBwqSrGtCxp/cnP/U/f7zuDg1Sa4fnw6jH/Vpzd3XYRKkqNdvBMF+rFs0Ipt9g3QnF4cfeZTUPDGP7PW2KsSGfXBzztZo3pnIlKeabpBFITDGcfoP+duZO6dsEZi4DrlEn0v/G0BPWPbE09EsNikI/JS7I++ZTKZLnuatfqu/hxvgHBeJCresnQdNoViSUtAfxlTaWZ1BpiHg7q+magV8QvR9Drg6CcG4FcCDyKAjOwC3GRVqY7CByABTnKw/Q==
Received: from SJ0PR05CA0136.namprd05.prod.outlook.com (2603:10b6:a03:33d::21)
 by LV3PR12MB9268.namprd12.prod.outlook.com (2603:10b6:408:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.23; Tue, 18 Nov
 2025 06:53:48 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::be) by SJ0PR05CA0136.outlook.office365.com
 (2603:10b6:a03:33d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 06:53:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 06:53:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 22:53:31 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 22:53:30 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 17 Nov 2025 22:53:29 -0800
Date: Mon, 17 Nov 2025 22:53:28 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"afael@kernel.org" <afael@kernel.org>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "linux-arm-kernel@lists.infradead.org"
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
Message-ID: <aRwX6B7kEMj2i9mm@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <a166b07a254d3becfcb0f86e4911af556acbe2a9.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB52762516D6259BBD8C3740518CCAA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRduRi8zBHdUe4KO@Asurada-Nvidia>
 <BN9PR11MB52761B6B1751BF64AEAA3F948CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRt2/0rcdjcGk1Z1@Asurada-Nvidia>
 <BN9PR11MB527649AD7D251EAAFDFB753A8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRvO9KWjWC5rk/Vx@Asurada-Nvidia>
 <4eeda61a-c71d-4ad1-8ac7-a14942f7a864@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4eeda61a-c71d-4ad1-8ac7-a14942f7a864@linux.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|LV3PR12MB9268:EE_
X-MS-Office365-Filtering-Correlation-Id: f2de03f8-b0ce-41f4-4208-08de266f38fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PqDQaSPC8TBaQhDOo/r19KkLolg07dQOQkj+kbqLRSsW10UzM8IcypT5Tt8Z?=
 =?us-ascii?Q?2Zy0FIEeo32dXhCtGKJQXrUre3rZgtl2DQUbgcYrfH0DR7+FJPJ7jNk3ltbg?=
 =?us-ascii?Q?6j7mfkWZ5bTbR3N6tMglpBo753mFXaapROeL1ow0mcEHr5pXg6JerPmvLtvy?=
 =?us-ascii?Q?6ocksc5REf4SxMqyzNW3R91uz1IIKe93pW3cpoFznV2FFywOW/Chl2na8dTf?=
 =?us-ascii?Q?OoSTUSceynM7855r2xv04wOBusUL6nrCWP9gokrQb2DMsoKM1MW7eqTg/qIm?=
 =?us-ascii?Q?nO3UnrvsWErPYesNp7YmDdW3nJPkkqCSp2xCx/48JHYLG7P4bEsyfWd7c3PK?=
 =?us-ascii?Q?4h/7sRyb3csNp+Pz2jRHfTr/JNnoncRzjKIGwA+cgEDw/8kAtJD/yA03DkM0?=
 =?us-ascii?Q?qAz0ChmBft1mXPIwmiLT/p20VgNXaYEHpCIUdZvnB4XnL+lPdU67RrJxpRsL?=
 =?us-ascii?Q?ep1obFs/zUj9qvPqBd4zS7JqEfqdZ11JAX60/HrT0hPVExwsSOXPF13hvTGq?=
 =?us-ascii?Q?UOjZbxCBmsMbcqwiJy6tkMN/6N9+ZPoNGh4yY5Ir63u4Ei6FjHdolGH8zbWx?=
 =?us-ascii?Q?YSaC9jnSgi/KGFCl9NnWOlVVyaTfb3Q+B/w8Jco+/qI8jN/KW9SZ8+vyqoqN?=
 =?us-ascii?Q?wFLCsbJfhWBUmOhKSJeuQmTKmahOmWKjoP4Ngyi3tFVHaTfCFjSXEEGHNllL?=
 =?us-ascii?Q?rdJ1XOEp7Z//EDCYAtZU98FhvRxRe1GcUBv2VxLIY2oN+sf8/MP5VYLmbR+7?=
 =?us-ascii?Q?Hoxrlpz4SXyBO41JDSedbjG39JpnHNgeSytGV4zUlBTw89y5YbocsBTDKJEu?=
 =?us-ascii?Q?dVFlBRNDjd9lFfmR7VrOSP4U+bSE9hZXzUMMo6whKdxtBPAd7NN7lrhfNQb/?=
 =?us-ascii?Q?5Gttp83wyIR7uIJoJvLt+x4f1uOi7T7L/IICWuN/1GbHVlUjZo5Eis/XFg8g?=
 =?us-ascii?Q?E6D8ZqnoxI0IpyOlEjQ1Uo2JQ8CXlFp8/w/vB6pJQCjWuaviSETFNd+34Cbr?=
 =?us-ascii?Q?pmGUKjNcHNMlDY48b252VXTKTP7R6FBsXWLiTgSiAdjzhDsA+1O3uKiN157V?=
 =?us-ascii?Q?cCKmfnaudN/hhpLWitlWu1q/w55g/cDG8yp85dhpLgkonWnePlhpsTdYXE2H?=
 =?us-ascii?Q?i08+nausG7ioaZuWgc3zZ0+LQFD0j7CxeJ9r8xlfOLWx3cHLXTtdfgmds1os?=
 =?us-ascii?Q?8/y03Kl/oGXGaljC5zmJroGNF3NgQ0lB0PwevyvwjUx57qJVlr4tL3JzCiBj?=
 =?us-ascii?Q?qOfAIrX646uaFCKISffivg68YwkhiuwFIXk1BDI5CdChWhVELvlCPK6YwIEz?=
 =?us-ascii?Q?K/XeM1BbZ4DdzJ1RC4tOKOdEJZOOHAh8ZKDFAYcdZhVSHVuaAStC7xl/oMkk?=
 =?us-ascii?Q?VQPvGJ9NETffMO22x5NE/TZT/lQnC5EDhb6pqzqnaBb7dT3lvboKRNUQVofE?=
 =?us-ascii?Q?vJmckB62F02ZWSaBDrM8M2v5/cm0LEEOeIVKa9ea+P+buBkW1XEnb4FWxc8g?=
 =?us-ascii?Q?xycEr1fj2JHadVWp6mELu/6wVkFOaO9qoN6gKYtz5MLhxse/iNbnE1FGtwyV?=
 =?us-ascii?Q?v28JJK7P4EO8eiCVJqM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 06:53:47.1575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2de03f8-b0ce-41f4-4208-08de266f38fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9268

On Tue, Nov 18, 2025 at 01:38:40PM +0800, Baolu Lu wrote:
> The VT-d driver enables ATS in the iommu probe_finalize() path (for
> scalable mode).
.. 
> iommu_enable_pci_ats() will eventually call pci_enable_ats() after some
> necessary checks.

Oh, I missed that one.

Thanks!
Nicolin

