Return-Path: <kvm+bounces-41645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D37EA6B3AA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 05:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F8DF3AAF59
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDB91E7C0B;
	Fri, 21 Mar 2025 04:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SEODApSB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D80B664
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 04:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742531264; cv=fail; b=iWduDxb8KXl4C5HfJPxZjhykmjeyGg56yzArskFNq/hCyvz/fRq2EGzvmCvfwky4tgh3TZLiORfyucfCkBHHDw8hI/7khtkxSa67tDsoqVdXMM7TxKJHze7ox7zB/6gbgVwO8lFBkLMd84NuQt0RQLqewoJ51P/lreKVdCjeIHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742531264; c=relaxed/simple;
	bh=sxY02XxyB88e/YCuiVDBu2AoJchP/FpKA2dfuXvcApI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/U3yzwmN9JOgC/YIm8PKb1JqRyrQAUn8Rtat98tMoJ16RiaN1j+tnMAH4cH+6VZcd4yLI1x4YiOhow5v2v7RFbNMZlXl8J/Hh7Vzv8u8MudMfqfMpNiZGUvUP6+I8kMoJcNdeyQEHiVlywIR5bKtu1peSKY54+4o/lqfpdKgIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SEODApSB; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORY9q7+XIw65Eg+49WeQH3qEei03GFLPbO2T8NEK94jFrc0wPN7VzruGwwq52hgxJCXBxUqncMju54tKSd2ZP+XTYQmKygh1k2vd93zmtgjO2EzjMoFylPqe+fgv8gFPBL/7CKNP1BN9MvQ5oJGfibAwXOmTFVHifFypeZ/Li9g33nRk0emzE4dCb9RXch2poGKAnS7jjikkxiCPhyiq2NsZhToL9B1J4LhAFfv9MKN0/60h40jHuCZblalLc+NHc2B25B6/ROYXqPAnzKhtq8EVV68OKlHbnK/o7MXHVFvz60v3aoIIKpOnnPSAo/NWe3Gg5zURQPSXjYjXb/b1oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSnVlVSN6/MGN0WfsI04Qx88uow+UwZ9kgkqBXVBqzc=;
 b=ginGWeyfJXox8rLebm7Jzn5dtbG3eWZsQpBwsbdJcOg94HVubSk4ZdBmh/mO06BQbG4MbswdSn3RVQ+1crNAEFVdSfessZ1PEhEjxa7GbVk7JSY6lwDeHI/KdtwPgCGwfw5NHvvMIqAnTS6mH+WyoOQghKlaL4Mlw9xKZiYIBebkwcb4GfOFkq+RDROLPwHvrGFEZHi692SUo6/GtMqzpGPhY3k7La/FKbbUCCz5PwNWrHR6i5YqS2MSJVQvCN9Rct//jCI5jRr+vpIkdRg/5rCTaRUcklFL+Bc2x3K8JI8j0h4mmtDw2TXsWH2OQR+3ARFRFmif+fikmOcf2vtc1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSnVlVSN6/MGN0WfsI04Qx88uow+UwZ9kgkqBXVBqzc=;
 b=SEODApSBlMASmgf4EKe3mtO0ty/g4PxbxMncVMKr6EASg2Md6BuVeiFJEZjFjSIw0GeaT/ESWI0cfHexYCSi4XgIqB5s7iBXHB/qwboCScqIjVMnMrEU1s3w2q92hGG0F9iDwoOca/EW/HRB/wKhHYSR//s7aDpBO8w8vRy0quDmeWxKwoTI7xu09VeZOvqrWoaK6VUHkztHlezyXqElh64zukL6kg6CN+RLEMU1cViQF6bebaJOVttK6PkHWNbhYnafcW6Uf8TmL08MgPUjfrQ4W1W0+Ai50y2Avk6HHXl4uUNWmUElbPNs9GebQUZnkQp2zRrHiikj70StezshHQ==
Received: from MW2PR2101CA0009.namprd21.prod.outlook.com (2603:10b6:302:1::22)
 by LV8PR12MB9419.namprd12.prod.outlook.com (2603:10b6:408:206::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 04:27:38 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:302:1:cafe::be) by MW2PR2101CA0009.outlook.office365.com
 (2603:10b6:302:1::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.20 via Frontend Transport; Fri,
 21 Mar 2025 04:27:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 21 Mar 2025 04:27:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 20 Mar
 2025 21:27:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Mar 2025 21:27:34 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 20 Mar 2025 21:27:33 -0700
Date: Thu, 20 Mar 2025 21:27:32 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
 <20250320234057.GS206770@nvidia.com>
 <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|LV8PR12MB9419:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b273cde-cbc2-4e19-b92b-08dd6830b5d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MSbIo3F4+5PyIbCcwQn2C7yaCwuMXhjgSrCT2WKQ/w0FPrINzRKrTmKQELQv?=
 =?us-ascii?Q?tXJgzapgT3P2Lj1j09HyyDDvXzSH683KUTRRLRRyNYUKpkIdi6ABOUxpfejk?=
 =?us-ascii?Q?JuAtloapCMLHKoYFqyxD+trpvap/PBs8EN3rdw7K0T9fn1E8TE0iLdEk36zU?=
 =?us-ascii?Q?NeFDklhaoX7e7B7f9xDr2eXmstLmOJWoCu6rfCILMgbB6H24pK1r+RqG0AgN?=
 =?us-ascii?Q?9zw6Y9OxccEterv1/gwsjZrYVm11bl5yuaZN7cLLcdJ/zlnD56YMH00X/m1E?=
 =?us-ascii?Q?K2yZ4TdmnXQ2RQaeWTzcZ+EX4qmUC/8qXCSLQPo4SBoIGujmRkh7fbPbJLf5?=
 =?us-ascii?Q?X9iPnUqh2+ItPmamVlPjBD5Pbb4HNejJJH7fP6vz0yb1w6wkZFZ1G7y4AJAX?=
 =?us-ascii?Q?rGVs8OXiX6X4Gv7TkMQ21D3pwBPMD3rwP4XGZidbYoYliT0KuCBZ7KaC6lVh?=
 =?us-ascii?Q?C1qQi1qLSDrJoAHqAeZMiAHvwdZDlfPU395lllEkn3p3ZDJqxxEhf+cwViXH?=
 =?us-ascii?Q?/wfj8lCOJjqD3EJnKH7ba7ciTHHICcEyLmKVn3bRCAfcBVt7HlSCHQWQXvxb?=
 =?us-ascii?Q?ORPH0IPsuTElJeePCekIW7Zhy03ZPlFawN0ZtcnlFYzIhko9SS+VyujcwXxH?=
 =?us-ascii?Q?MmVwpIdrZre5RNZnhz6ZuxowCC7p9z1mxkMLy/kLll4il2y1TQR4i/kCCQj7?=
 =?us-ascii?Q?R35qYzuQJEnrsgSz97wMDAhMaYTRpQWw3zxn58olmbeg+C1ECMNhcrwYhMXD?=
 =?us-ascii?Q?ackYsO34/Xjqdiuj2SwZ6YyIuOlgcC63N1LzSOjr+CsfdIYzDF02uivO26Kt?=
 =?us-ascii?Q?rpzPZLtWivx/VwOEjrNpJ9kMYjO8C9/fTGjHvg57PA5mCUke73fEwemDGgxJ?=
 =?us-ascii?Q?BCKbXKlQ+EeDs6TXJy+zgzb7z0cvo2sbjmGuEo/yB4JucFCX1RXFoaiP9KFb?=
 =?us-ascii?Q?xXY4vYHUENo7rxZ5EI1sw3ltlp0iX34Sgy/jorVmXxxr6iFiRlikiS3e3x/2?=
 =?us-ascii?Q?z4aR6jJ0LJ4d7QTC9TNdep84aNkvimPwyfUPHgXh6++CqahEykmPuxMC6Hqm?=
 =?us-ascii?Q?smSxFJs1GTh14cjG+CG0BQLkqs2Z3bQfyFDF4I1NPlgIBdr+0G5YeW0IaT/3?=
 =?us-ascii?Q?V0njIxB2XNyeSJ1JEeRFosnKQLIdOx/DcS9GdJWFdJqhTm33rzwzybAtxou6?=
 =?us-ascii?Q?7SwLnHL+alt+JBbtX0Ui3CeLNf7m9EqhvGWzz/j73jqL+b99/5WOT+BB62Xj?=
 =?us-ascii?Q?iH+uKfSPM1z+VmLtX4fQmB8IMfgkNGMmCm1IMv8TPQH42+KdrAiUK0Vday1Y?=
 =?us-ascii?Q?C3ECx+3tuIdxknqoxb0f9AITtbINJ29LKozZ6XMMn+7ooHXVX66rV1wf/oBo?=
 =?us-ascii?Q?OC4oJghCZtETatvjNMWqnnZNwBMiKgGrNYHN7Fid97vlo/C/ZWiE5MwWOyKJ?=
 =?us-ascii?Q?hNbYqrmLxoDASIng2kNemmBQ2GZuV1kvQFsm90ejco/s0OUOXkSArdgET7ey?=
 =?us-ascii?Q?jTsn+Yr60xWO71s=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 04:27:37.4396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b273cde-cbc2-4e19-b92b-08dd6830b5d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9419

On Thu, Mar 20, 2025 at 04:48:33PM -0700, Nicolin Chen wrote:
> > > Also, this patch polls two IOMMU caps out of pci_pasid_status()
> > > that is a per device function. Is this okay?
> > 
> > I think so, the hw_info is a per-device operation
> > 
> > > Can it end up with two devices (one has PASID; the other doesn't)
> > > behind the same IOMMU reporting two different sets of
> > > out_capabilities, which were supposed to be the same since it the
> > > same IOMMU HW?
> > 
> > Yes it can report differences, but that is OK as the iommu is not
> > required to be uniform across all devices? Did you mean something else?
> 
> Hmm, I thought hw_info is all about a single IOMMU instance.
> 
> Although the ioctl is per-device operation, it feels odd that
> different devices behind the same IOMMU will return different
> copies of "IOMMU" hw_info for that IOMMU HW..

Reading this further, I found that Yi did report VFIO device cap
for PASID via a VFIO ioctl in the early versions but switched to
using the IOMMU_GET_HW_INFO since v3 (nearly a year ago). So, I
see that's a made decision.

Given that our IOMMU_GET_HW_INFO defines this:
  * Query an iommu type specific hardware information data from an iommu behind
  * a given device that has been bound to iommufd. This hardware info data will
  * be used to sync capabilities between the virtual iommu and the physical
  * iommu, e.g. a nested translation setup needs to check the hardware info, so
  * a guest stage-1 page table can be compatible with the physical iommu.

max_pasid_log2 is something that fits well. But PCI device cap
still feels odd in that regard, as it repurposes the ioctl.

So, perhaps we should update the uAPI documentation and ask user
space to run IOMMU_GET_HW_INFO for every iommufd_device, because
the output out_capabilities may be different per iommufd_device,
even if both devices are correctly assigned to the same vIOMMU.

Thanks
Nicolin

