Return-Path: <kvm+bounces-31042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1809BF8C0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 22:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D3E1C21ABC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 21:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3B920C48B;
	Wed,  6 Nov 2024 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KizVLTiv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8738320C008;
	Wed,  6 Nov 2024 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730930015; cv=fail; b=Boh0sebQ5ecdt4EvHbixKBveyMpQ6KqLhQXaXydZx5oI8HdRi06IKdQKktOt4fFH+FPV5F8SDiQguGS9CaoVtwZtgIFsHa1E/XXhjb9JFl3rzmQGkf8x485g8PWieE0jkxbdXmLdQ3x989+lT8XQGBtCMRdtH16ikwq0NOePsPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730930015; c=relaxed/simple;
	bh=sbY1mUUl0mRsCygGqjnd1ersfTua6mNbznTxsZ7RXUU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERFc5ujI6OZtlcLdlmBs0qvEhliBlu5A9Dkyo5BdUeMvI5EaWCKmPGIcCx/P+tqN1Ubfh4uwhyyS4gDXaG0eWdxs3sA5A4zWhr1NHMLolVA8dH7alUb8pFOYtyIIdL0ZMY5+gFsK+QABNvJwDi0cZwO7UO0hqJcB1HLv1aWGRPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KizVLTiv; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNOS9lGqv22Bo1IWRI68p37sZnF35VFUgZRi0Nv0fCb7HqU66TW2z0Y2ugUEemv/HRyQF36aE/QiLUnEOU0NKn4OVyQ27EHpMeLQ+2VvlGaFcGsTrJpERBYc1+5tiVgF3iuEZKlepxiBalW3cCcjFsnRevySkheLgxjYWVHl7SPQQqNzpN/OY3OxTheWBjfmWhJWAbyH0J3TNiyO4+cUTplVLQDN/ayDpy2jqjc2ha87DcjXHAMOjRlPWCyy4+z6jCaASpVNASIVh63fXn2v1Azlios/Sz9TBSWPg9oEHt1C38VuHJP3qxuBF9305FE1KKnn+mxe3Hrbow1Z/VjjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeBrkSbmAmRJo7VDs4EymTa1Gnln7vU9FxxHjW2QMQU=;
 b=xOEq+voR8CVO2wd4QIDVud1hQfm0fzqDx0l93ZkDljhRDjQtT6N04kAHhys3DuBmtMs3hET6uVwZzZobvuhfViOLqXit16J0r3YQoDlCSSqN4tjOVA+kRRYOA3z5Ai8txU8FmIO/bPpVbfxyyO2Nv8Pk5vqHJkm3Fj9XPHBz2Joujl8i4euODgzfECzXBb1+gCSodjBWRmrmVysFmXJQ3yzgkPJR5iq6jIyZVWT1OE0EJ6wLaQrZ4mPpB9QhrDR3UALPzMv5wj+5BaCcUHPVviE/mXtMXGEQFXTd26bHaV2OQxpcBexHjUtiHxtNPCy3VEiUsBjVVCeJo5yvh8uQMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeBrkSbmAmRJo7VDs4EymTa1Gnln7vU9FxxHjW2QMQU=;
 b=KizVLTivxXOCe22WVAd48I6d9ZWncp0SpzUXQFK8IbI6FcoVGELHRB7kTSxkhnQiIH/KLu0pzBlgbYACNQ92fV6GZfdwr3O7phBVcgyMUCF/pDbvZaGQd8dzFq+MgDQTmuMajPvwGvhIzYMR/orDDh0BkjwtAofm76AKTgDOYwqUOn/qy2UkwpKPSOe3XHh7ZBw+WD8d+kA3apMCmkBfB34wYV7WeOEcZ3e46ZZWmE2aHgqS0H9NLogUOisK50LfBVbn4U4T7u0EigeRdhaPBBKRZpYpY5YJ8jyPD6SSlXSlu4oROVOjSegYQOGXfxRdZXauOMlK0kOElr52F3Nouw==
Received: from BY5PR13CA0004.namprd13.prod.outlook.com (2603:10b6:a03:180::17)
 by SA0PR12MB4494.namprd12.prod.outlook.com (2603:10b6:806:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 21:53:30 +0000
Received: from CO1PEPF000066E7.namprd05.prod.outlook.com
 (2603:10b6:a03:180:cafe::32) by BY5PR13CA0004.outlook.office365.com
 (2603:10b6:a03:180::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.16 via Frontend
 Transport; Wed, 6 Nov 2024 21:53:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000066E7.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Wed, 6 Nov 2024 21:53:29 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 13:53:13 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 6 Nov 2024
 13:53:12 -0800
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 6 Nov 2024 13:53:10 -0800
Date: Wed, 6 Nov 2024 13:53:08 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Will Deacon <will@kernel.org>,
	<acpica-devel@lists.linux.dev>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Sudeep Holla <sudeep.holla@arm.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar
	<jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, <patches@lists.linux.dev>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <ZyvlRFi6W9vK5IZj@Asurada-Nvidia>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
 <20241104124102.GX10193@nvidia.com>
 <8a5940b0-08f3-48b1-9498-f09f0527a964@arm.com>
 <20241106180531.GA520535@nvidia.com>
 <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2a0e69e3-63ba-475b-a5a9-0863ad0f2bf8@arm.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E7:EE_|SA0PR12MB4494:EE_
X-MS-Office365-Filtering-Correlation-Id: a9afa297-7052-44fb-44ed-08dcfead7361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O+OxZ18LkgHYRMoy2Clx9IHj0aqOtiI6ajxDREEePuvtE6Wkvj0gxtzErgRO?=
 =?us-ascii?Q?x8dGEPEHuiuMacPdiAHvrYuiRKviYUHTTu+qI4MINbctNnJnI2SCVsBJhm+c?=
 =?us-ascii?Q?2UPikwOAbaIbnB6LmpX/050WdCjkfyIR+hBhoECv3fJo1fZczesQDi3QC0ZK?=
 =?us-ascii?Q?Sfu0GwBnPu8PWHo80+XMZICVw+tR8RASUlGR94heCOGqEM6eH6rSI7+LJMHq?=
 =?us-ascii?Q?hTyIQOHkegTq7Sm/WQAGE4JR616TPOdRIoroi2R2XC7ITeoxz3uRx4oawu84?=
 =?us-ascii?Q?fMTc756oR7fx7ZDkc6ihOy6dWU2yUqj9PmYXlB7bwCa8b4LNgXkPpOHayhVX?=
 =?us-ascii?Q?slj0F92aWGPG9qj9E15qXVHs7YHeo1+JxIqjZC+/bR7AeCp26aG1dG9hqwKW?=
 =?us-ascii?Q?cZ8IEA7Vw058prdpZYZChqvcnNhAORYmJ+AdSCgfRKAuL1H3aYxtoFRlfhWU?=
 =?us-ascii?Q?Efe9pvsakMxFaACfpKoVRDBaTJnWkPz5kK44MDilXrfWhTipcE5bnDnkbM1j?=
 =?us-ascii?Q?pW/wl2Hqu/ThBEtCig0rDyHxKvyxmsjLQto7g/ay4CvkOzmI1daIx3PCM7f+?=
 =?us-ascii?Q?XT07ks6T8KwgrhE1nWWTOkA594ivotbQjgNlx3/R2iG/8qKy8WrDhatjFD8H?=
 =?us-ascii?Q?XeFk0NduaPAnSPLWa41xJaLDha+1XgeFbv5dMGRoaQORNxer0QLpuka8d1yn?=
 =?us-ascii?Q?u05i52Edc6Q+exX9Flb2osHEOG6NM8916sgwOF1q8StZ3bNpX9TmLmH0M3vr?=
 =?us-ascii?Q?58BU6/XcLdJ4TggF5GNQgTgTw+u16jOqNOzwc0K2n588NXl50jAWtAzKuVdR?=
 =?us-ascii?Q?OW/s0ZaMoPKSz3SsERVAP77VqH3ftKaDqSyhbl385PNvgeqPaf1EbIh26UcK?=
 =?us-ascii?Q?rY1iO46Kfs0em4IdoEILvL8P0ucAFFC5eQTdUJNh7mTvRcZcHDFaPiOldOnR?=
 =?us-ascii?Q?nF04CR+KLVCsEz4hbIEEBXWVRYHdReLzeILVKds1KgjFIO7H4Yf5IZWmognH?=
 =?us-ascii?Q?s+2Ov8k++S5M1c46OEdYQGx3/0OHTG8aJo+1Y0Q+Fqxtfs67v4AiJOBwyDLa?=
 =?us-ascii?Q?ROt1ebMTp+VIAN54jwuU9YtvZsHJP/gmpYnMrt8/y9aMu26anYByyWAOiCo0?=
 =?us-ascii?Q?Tl6/QPl+nVEPk2oMgvGqNiw7Big4EbVlTJXwltoeaXDkb/cO3WF/YRtN7vVR?=
 =?us-ascii?Q?sPZgDHOaguMmGgkLEsWUrQ4w+KfL8CbZ1tPelCnTYuGcLgI535BwxaeHOuTq?=
 =?us-ascii?Q?X8y9AmilcDfanmpXnwcfjqLS/GAzWhf2RFLVQfIov2eg/v6t/GNi5GetWL7i?=
 =?us-ascii?Q?o2xGtDe2kanbTLBS5mLnPV9bfjcWc/wkSQlz9wAfnON0NXflcPTJ96Nv83X8?=
 =?us-ascii?Q?hUmSnVYxu601Mk2AHMya2sNAgiUd5d0RIji3gI2YHGu9jGF6Bw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 21:53:29.7382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9afa297-7052-44fb-44ed-08dcfead7361
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4494

On Wed, Nov 06, 2024 at 09:05:26PM +0000, Robin Murphy wrote:
> On 2024-11-06 6:05 pm, Jason Gunthorpe wrote:
> > If you still feel strongly about this please let me know by Friday and
> > I will drop the idr[] array from this cycle. We can continue to
> > discuss a solution for the next cycle.
> 
> It already can't work as-is, I don't see how making it even more broken
> would help. IMO it doesn't seem like a good idea to be merging UAPI at
> all while it's still clearly incomplete and by its own definition unusable.

Robin, would you please give a clear suggestion for the hw_info?

My takeaway is that you would want the unsupported features (per
firmware overrides and errata) to be stripped from the reporting
IDR array. Alternatively, we could start with some basic nesting
features less those advanced ones (HTTU/PRI or so), and then add
then later once we're comfortable to advertise.

Does this sound okay to you?

Thanks
Nicolin

