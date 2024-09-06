Return-Path: <kvm+bounces-26024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A061896FB7A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 20:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DC561F230DD
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 18:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DDB13D251;
	Fri,  6 Sep 2024 18:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K7Y6IHXe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D991B85C8;
	Fri,  6 Sep 2024 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725648570; cv=fail; b=f5qcHeQQwEFZxyrvJLqqUJjmHEUeaCD4o2KqNfx6Z4q4OxztH95rzUkIrG2eU2WY6no+5b12T6lWHXSTwhfgjPTJzP/ICtwG/o+eBX3noaDIz50vuxOrmFGbpucCrwaZaKnEPWx2y7cUfYAJ2VQzA8nIOWzN9QQIVbhslDPDun8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725648570; c=relaxed/simple;
	bh=kFYX4Q2aq+0Rda1aV7BoTN/Mrmsk2E3ULrk4x6J2YI8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcRmxl92nbwYAhCMmDrywR9lPj+EmfuQPD4YoWrGkSYxYKa5zAgSR9AKH50it/ZXsX1acRm6fadgcqdydRRm7scs10A9+NIfOG5sXsSIc3NIM+BWRXtzTpJYts8xQpP0T0b1r8L09H8KyvzbXSWSBT5b7tKjB/QSpMOjxIYPuX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K7Y6IHXe; arc=fail smtp.client-ip=40.107.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/C2/zwLXv9FWWAhhcUmNl4rQ1WQDNptB/5tmWTbaWckIEr+gp9EzLefYACK1j8gIIzcyQOsGiYrNA4ocTbzJRI6QVMPOR+8UepC/4ZKqGwiMAWJ13bILi39b0nx0YbETU+vmLCvZhEsqTwHT/8syJLlTaqC07Z+6BmiizejS79as4Ex7r2pwt8rrWMxq3ujKsQoao+LCkTJmPzz1/0jGPx22pFDtLyfVoUx4Okqgnk6GtVe9c7XjW9kkdoy5PDPdXf43rOcpUFcO5if8TB2Bd7YfBwty4jVjXjKOxFYkkNjWU+Cb+Vc3kQsdHamMGg4W/APVGiwoHd8cze1loBelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwYvIfvV2BI8CV4S9luNMuWCALYYWwyJCrX+c9tW0c8=;
 b=N9zNH7/prjyvBslS6mSg3vGWJYim9xpVMSPtZP7hbzg7Z7VhBOrgcOvtXMFFRx6l6+6tyTKta3frGs9QUR7aoRHgEJmVKueE3WgLq0MUBoHhOWZHfpMW6FZ4JQX1lSbYcEhqEoMYpPA1/WP8OspRLrx891YPPYmTETkuDaq+oCAzMpp9NTtrxeXPbCNiRjif3WQHjXs7VP5SknCRRnrQO/yLLTucRrYiQz41tpO/wsgZO3RqNOo7ec7vjyroPuY4BDuqT1aX3MugmNEg8QPvgPYgaa4Hd5rjQTdTq3lJKGt/YGRTfz8ct8/FptEweGCmO0NVZ6RjCXmKCdFDQicIOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwYvIfvV2BI8CV4S9luNMuWCALYYWwyJCrX+c9tW0c8=;
 b=K7Y6IHXeatNGqupM/E47gU0uM3R6MNv0irysWT5zLr2ViIgM+fI7jNvd0UusjFAGmfuOPms+tFMu86me9/py0xuZ31tkNRy5O55CVAc0QjRgSRBwRADafgOJ1wIbhzu00KVW8B0Yy5TA4+ywmjsTo827ZNcc9WnS1+8V1wCOrc7q0ClC60cxaPWgt+QCqKHxOd5IR92ByV0GiU3grv3mRSYm2wPSkpVDoOHN/j0wmoMqhMdMaf/atPnRouq6u7qYQBHYXMUmuBjJ3jRaydsP1BE16vYkb2v34ZhpH/lNHvsy220AIrdYPKft57Fx2AwNx0mFhBgVR5BDnPYXCY594w==
Received: from BN9PR03CA0955.namprd03.prod.outlook.com (2603:10b6:408:108::30)
 by MW4PR12MB5604.namprd12.prod.outlook.com (2603:10b6:303:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Fri, 6 Sep
 2024 18:49:24 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:108:cafe::1e) by BN9PR03CA0955.outlook.office365.com
 (2603:10b6:408:108::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.19 via Frontend
 Transport; Fri, 6 Sep 2024 18:49:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 6 Sep 2024 18:49:23 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 11:49:15 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 6 Sep 2024
 11:49:14 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 6 Sep 2024 11:49:10 -0700
Date: Fri, 6 Sep 2024 11:49:08 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Mostafa Saleh <smostafa@google.com>, <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <ZttOpB3lAPc2+RHv@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <20240906182831.GN1358970@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240906182831.GN1358970@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|MW4PR12MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 31b013a1-3899-4ddf-4f9b-08dccea4a071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VDR4KrSuI4C8VeZJsxgAhQByWbXpDiC0aIfXaHaDUnDK3dBWjcLeSOII65Wk?=
 =?us-ascii?Q?UN5ps9g4L98GBOnuVId+zbtXJpLPK9hiY9Gum2QuHJ0ihj+0AZotudxOYnfN?=
 =?us-ascii?Q?dlnDN6BhDJzjJU4EMegrxNtEC/lB1A8IfqyVc/X58gqgbOTntCLi/+3z9PUX?=
 =?us-ascii?Q?nV8Z7KgB4ya6yftawwzXQ80tjIonvj5NEuc2eEOGKObXvympI0J0XGM8LNlc?=
 =?us-ascii?Q?oyl3WlprV91OJPbr0rofYssFVGdUsD/fDh2WbGnKTK/4Ses7vH9pRtk0c1c8?=
 =?us-ascii?Q?XayAlu2FPOTmuhRrjZEjWr2vxf3ZMdA/jU8SN4Ia35E15S7HbQZD8ItljK+Q?=
 =?us-ascii?Q?KMxcabzCvIcv2JgOl390mwvzahoi1TAo92XG/1fTzczbgKLhUTc+awmmlHiX?=
 =?us-ascii?Q?cGtn44Q9iChPHy+dMkQfxUY1FtBU5TnqEDQEHM+KL3XHybws5merwAyYk5Er?=
 =?us-ascii?Q?z/qpwki2fGvSRd+P65GVp7911V/PANdIAh9pgEdG2MJ5xPHn4Be7rwEo7nKE?=
 =?us-ascii?Q?vdt9EQwS028yaYMfYImRVRRCeOSqYza4gHZT1yhMCkIHMg0FuSFnWpLSyQBp?=
 =?us-ascii?Q?aSWg4MzkecTacdK2jKYpBdFm62pDtn5au7WOr6m5HssfNSzJ16/N6P2Tv36K?=
 =?us-ascii?Q?iJsocoRSND36N0H07bDbtK+LgDLhGkU3N+WG7GuTlfBZVgpsnPbpSkFMi1PU?=
 =?us-ascii?Q?G3htVkdF6Qru+kjYXUyZuWiOj7ymmqvewhYI5cwl3mPFat6S69xu0n9Ww3gx?=
 =?us-ascii?Q?vVo805qkEu3Uzf4gxrWRXXe7oYfD2yWLub9GLvfVTSh/s+z3+ol4r8PAANu7?=
 =?us-ascii?Q?5zzQjht14p5widc6xmNCxVZFBG4IYkcAtCFp4X+qWgnfaaXIg4M/b1dAxcI0?=
 =?us-ascii?Q?nfIs+26mwYXIZP+j+J42jmrUc92j1pnQ/Z3mJoXEVAHH6tDbOgadFnX4Ur72?=
 =?us-ascii?Q?TcFxq8HY+3WbI+oKd6oo9IE3x59DP010+bw+3yODr3XjXBhS86VQ1I0NJN+F?=
 =?us-ascii?Q?wXZcQUSJV7pBdMIivs5O6q4i9yfuygWJEMbK5IjGV1ODBymJ4hFd3qpDB8hk?=
 =?us-ascii?Q?42f/nX2GXMZUufkx0N1FQQEuQCdksSyQtn29i1UeH0BFMchlstKYZft2ESij?=
 =?us-ascii?Q?xM06LIvgRcHJ7JUZvyfgQAkLMmMU5KhXvyel81zQlLqvso19GfAcAsWUcQnm?=
 =?us-ascii?Q?syhdcqElX3iveHupsyH8Ln6o1gG8wiAs4JraxEHTc8oPJGhm8ERoY2SIVbwD?=
 =?us-ascii?Q?3TLeZH9Sl4r1k22ojKBuh6SphSITRTzxA2L1ykXsaHouLAjk9npqJ4U47jQ7?=
 =?us-ascii?Q?pkIUGEsi2mTfANPNGTkIkQBXl8TcYZAm+3pbz8ETNIcgNOP8kpWdMJ9QbZ8F?=
 =?us-ascii?Q?1S1QC0xGqpzJDFJ6s4i8MSUgPV/0UFlTwciV2X47wQx4mCD5mGBGOVYqG+ur?=
 =?us-ascii?Q?fqqHRxqzT5hCyQsUtFsZiuWrRzt2y8Iz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 18:49:23.9319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b013a1-3899-4ddf-4f9b-08dccea4a071
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5604

On Fri, Sep 06, 2024 at 03:28:31PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 02:04:26PM -0300, Jason Gunthorpe wrote:
> 
> > Really, this series and that series must be together. We have a patch
> > planning issue to sort out here as well, all 27 should go together
> > into the same merge window.
> 
> I'm thinking strongly about moving the nesting code into
> arm-smmuv3-nesting.c and wrapping it all in a kconfig. Similar to
> SVA. Now that we see the viommu related code and more it will be a few
> hundred lines there.

+1 for this. I was thinking of doing that when I started drafting
patches, yet at that time we only had a couple of functions. Now,
with viommu_ops, it has grown.

> We'd leave the kconfig off until all of the parts are merged. There
> are enough dependent series here that this seems to be the best
> compromise.. Embedded cases can turn it off so it is longterm useful.

You mean doing that so as to merge two series separately? I wonder
if somebody might turn it on while the 2nd series isn't merge...

Thanks
Nicolin

