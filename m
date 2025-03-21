Return-Path: <kvm+bounces-41714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0FBA6C265
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 539BD3B3CCA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBAE230BED;
	Fri, 21 Mar 2025 18:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E/8p9eOe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2048.outbound.protection.outlook.com [40.107.96.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A52309B2
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742581813; cv=fail; b=qHO6waQi29Qw7hw3KE8cMZ/MEFUSKGIFt8x051wfNiiNUzKbUNoiCJ8vLiS3qbZe4P7itbS5RBd/IvtAIiBcrawuSpiXLfIuSqqYdFCX+0TAQUod1if0pGJRNG7aJf4ZzI2aW4IZ3iBxjepNlV4BwHqtqbc2iuNQDIkL+rpCmtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742581813; c=relaxed/simple;
	bh=hck7BxPdcszizUqPsmuNZQGiqbPyjzK+hg3Fr1TQ4zM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdnbCrmPSWVV8lPWa9s899A/S5xYMVtu1KZm6IgP+TENWIGI3f2HzBX50w1WhCEUYKhzDAGI+6BuMAjbVB0StJPpOrImG4p+Vvi6H9Y6P1a+q53/YxjpQg5S85Pl7aSu9AXgYmC7Eav22S9oGLY6JsTe3DvLMotV7q7u5NpMvIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E/8p9eOe; arc=fail smtp.client-ip=40.107.96.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pe6xjoOI7ON9aQh3fCbsJsxMMAen2wGsdXUWg/EH/FGhulAysrcwQnC+Mp/fiwB+FBsbutnCtpjYy6xzdH6PkuclNI9YJZX817NjPa7yhC/1PYLHPL16OO+ihPgaoz6bxa0DuhEoWjpMP0WCWoz6L8oBzKO3PTMzc1OdBeGZZJuXa0rHzF0BResgHeacl1cUMWRWg0ErTXAFBtaDhFmJa+Uygz1Wh37O8hGNl6YxEu5ILmv+sv6NJrV1Klrq1jzgL/2HeumaQECaErc2Olc/XVscxFW+LjiuCKjHYUU5+Su0jMBPztly7+PX/NDO2Gu0sfrlrMrKrCYsRxpnLGU1TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmPCz0TJoxfk9lGreizPamQTu3fw6p3rhxm78HT0MBc=;
 b=XdTqCijlXaluLb3HMESXWd/9AvFF0L4clORCpqMdhiA/yBrtwD0LP1zeR/CCw8aNJk6i3IvbuQGVZcrGDicWw90BN2mO3RKkBescjJuVtLpARV5+zsBOPFiZ2i9l5Yg3UB48WaPhxYwvznRU54gcZAGaPtWauZ4IAEuf4Bz7G91T+lvvGSbcSr1xmD1uI9Yx4W14U/O4tlgcU3Zwoe3vZpf1jyZ5R0/l+pVOwjtUZo0E9IilrOrfumeeIflH6yiCRhrUEmBWEY2u+KHrE3BZ55AuI0nz8K1b7njVPhxR+nJXuwzKswI3fkxNhYisgNffVVG4zu/aJwxoEagsSphDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmPCz0TJoxfk9lGreizPamQTu3fw6p3rhxm78HT0MBc=;
 b=E/8p9eOemM12XGnM9JxdAT73kQ70onwJVjGjrD47Lc5aJl+qmzFhKDVyICsnAYeSZCfBe7l7WVP8s3osnR8mhIImhjFXyPPcV7jFSa1EAKBtV1Bsdm4yv8NOcy/SAmJKRiMIcUQ/U7fhneadA6EeBYSADMlvbA+rvAlNdkThTmkOalEm8MI2MPey2pTSABSfnuruIjQ9auSCFmL17drUtetXZCGYaHqctd5ogeg6BSxiatxSogzyhyORQfjWGsFXRCNj7zSUp600S+b8DacvtI1bunAXGUvxqM7w7M0HVnSyttaL/uaSm4oi2bihCCezMlqV7o492VFbUBtj4ZquCw==
Received: from MW4P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::20)
 by PH7PR12MB8825.namprd12.prod.outlook.com (2603:10b6:510:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 18:30:06 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:303:8b:cafe::ce) by MW4P221CA0015.outlook.office365.com
 (2603:10b6:303:8b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.36 via Frontend Transport; Fri,
 21 Mar 2025 18:30:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 21 Mar 2025 18:30:05 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Mar
 2025 11:29:56 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Mar 2025 11:29:55 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Mar 2025 11:29:55 -0700
Date: Fri, 21 Mar 2025 11:29:53 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z92wIQGa8RcJb2T/@Asurada-Nvidia>
References: <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
 <20250320234057.GS206770@nvidia.com>
 <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
 <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
 <035649d0-5958-45f3-b26d-695a74df7c39@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <035649d0-5958-45f3-b26d-695a74df7c39@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|PH7PR12MB8825:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d14304-c6fa-42c8-200e-08dd68a666f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CJ4NY6HctuIUVwJ/K2HiQ3UPl3jl67R9NnkHo30Dq8AO5o4bCWqoWypLbCq8?=
 =?us-ascii?Q?q/7vzRwxNwy35K4bG/m0PNTnCOv5SMv4XTve3eXh4fy+VB9ZSIC1zzuckJ2c?=
 =?us-ascii?Q?TjrWERtirLuLEqtJO/hVbeOUDL+hivy/yNkVYgEr8r8cN557H3CzWZkt7vtb?=
 =?us-ascii?Q?FjZBuqxrr0n6BtASFhs1qs5Qu+GYDvCsyujOEQA+i+0qjX+aeB2a8U3BO/3I?=
 =?us-ascii?Q?8rXnngPr4dk1xfgDHWJrdHMZVR1FHA9ElebAMR59rvaXVxS8puQmPKfD8JJm?=
 =?us-ascii?Q?G6rC3LTgr6k6hs6zjpeSNlKvSP+rJ8IF0sv0G/mXs/FU5yshfTSRIaZFyTDr?=
 =?us-ascii?Q?FpkpHJT3C1Dkq6oULlb30XQ/gXGNjT/mphOIECHOMfkLr763waYcs9K6uKzh?=
 =?us-ascii?Q?JyO6rmCx8oAKtkla2XpPf06/kAdk0bMaSyG/NIGhqTFH2zjMsHkEHTYKe7kd?=
 =?us-ascii?Q?5DQkXSXu8LxY/VKHExo2FwVmnqljCEOkchTPEuHFod1OHePMvGVpuR+/WZOP?=
 =?us-ascii?Q?PVNU5lTUNhXpC1Y+/gIsQ3mkXp8ku+TDGNdseVr4s+VSqh5nJfwncU+VPJtE?=
 =?us-ascii?Q?F8avL0rstf0DJgtPE0tXAzYWA7QvoCcMh20IHk0tLrszoGqox2UeLJ9ZeNIK?=
 =?us-ascii?Q?B6iMqXsiygGwZUz1ll9uowCfqLbirIeCBS5/lDJnI4Js5W7zIw1noXrSnTCQ?=
 =?us-ascii?Q?gy9jDXuXdzQem9bRqRIAVrFTzgTH2Pmc0TzO+INquB3GyBrsJooU7nq+dNDE?=
 =?us-ascii?Q?2VGQpd/AmykTpwWTU7MIGIkT0h3HHGk3Jdl+RHwAAXPZkZ5bvV+lXCzNt5Fq?=
 =?us-ascii?Q?K2+ge+zWP2TxF//v8zeHEvi6/cRdJsF/kBWdLKpLy2g+eIsug6iX0jqNQ7Dp?=
 =?us-ascii?Q?TdgAkqHFHsp0u4VvAkLtCnRw82YNbqW9sw7lVrhyGTs6jq4zk/fkUlIiuNa5?=
 =?us-ascii?Q?ISvciOlxR0xncJSmc6X+erevD4RGdE4Ur3DIYZe1eEpMGBLkwBBfUKiabgFN?=
 =?us-ascii?Q?zGqcm4wXG58afcMEMPHlDTSU5DsOBHtVmD3TsNAIPklgALPDIlfBg16ixJI8?=
 =?us-ascii?Q?oHvDIZ5jbchyPT6o4QsgyBvvJpv1YFeDDfubWHaxuphyBtI6Getsu6KCePaU?=
 =?us-ascii?Q?UemCiYFYsp1Y/t0Lq7T3y4TZB5kdcdtXZHWI6H4bFqADdGmiphETFsq2u5ij?=
 =?us-ascii?Q?F+gOcSiP0WIhduiULNb0RhSt669/7krlIg84BSh5rutI7pbgZ8p/zaqV1Lg7?=
 =?us-ascii?Q?J4E01WbqN+2bhx/IXFfPzoQXSMfadLvS804NIJ5fmflQCQLzOPta36yGmC2V?=
 =?us-ascii?Q?IWa9jpe+kiunZFiv1JR6fY7HQBs59Ub9coSzcFnwicV1FP896dgP37xNntwY?=
 =?us-ascii?Q?TRoI/Fvv3xgXKMevow3lRE3n96yShIMAm8Ka/WDZ5VuigZtvx491wuvgtWuP?=
 =?us-ascii?Q?itno1Wf0XDMe8LKb+ayj0QGnxUXJveovPsNfW9KgCHJCqPA9jxjMn3M/LnbZ?=
 =?us-ascii?Q?D7nlrblllQE64r0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 18:30:05.6896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d14304-c6fa-42c8-200e-08dd68a666f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8825

On Sat, Mar 22, 2025 at 01:37:39AM +0800, Yi Liu wrote:
> On 2025/3/21 12:27, Nicolin Chen wrote:
> > On Thu, Mar 20, 2025 at 04:48:33PM -0700, Nicolin Chen wrote:
> > Reading this further, I found that Yi did report VFIO device cap
> > for PASID via a VFIO ioctl in the early versions but switched to
> > using the IOMMU_GET_HW_INFO since v3 (nearly a year ago). So, I
> > see that's a made decision.
> > 
> > Given that our IOMMU_GET_HW_INFO defines this:
> >    * Query an iommu type specific hardware information data from an iommu behind
> >    * a given device that has been bound to iommufd. This hardware info data will
> >    * be used to sync capabilities between the virtual iommu and the physical
> >    * iommu, e.g. a nested translation setup needs to check the hardware info, so
> >    * a guest stage-1 page table can be compatible with the physical iommu.
> > 
> > max_pasid_log2 is something that fits well. But PCI device cap
> > still feels odd in that regard, as it repurposes the ioctl.
> 
> PASID cap is a bit special. It should not be reported to user unless
> both iommu and device enabled it. So adding it in this hw_info ioctl
> is fine. It can avoid duplicate ioctls across userspace driver frameworks
> as well.

Yea, I get the convenience.

> > So, perhaps we should update the uAPI documentation and ask user
> > space to run IOMMU_GET_HW_INFO for every iommufd_device, because
> > the output out_capabilities may be different per iommufd_device,
> > even if both devices are correctly assigned to the same vIOMMU.
> 
> since this is a per-device ioctl. userspace should expect difference
> and. Actually, the userspace e.g. vfio may just invoke this ioctl
> to know if the PASID cap instead of asking vIOMMU if we define it
> in the driver-specific part. This is much convenient.

A PASID cap of an IOMMU's is reported by max_pasid_log2 alone,
isn't it? Only the PCI layer that holds the VFIO device cares
about these two PCI device PASID caps that will be reported in
its emulated PCI_PASID_CAP register.

Yes, this is a per-device ioctl. But we defined it to use the
device only as a bridge to get access to its IOMMU and return
IOMMU's caps/infos. Now, we are reporting HW info about this
bridge itself. I think it repurposes the ioctl.

And honestly, "userspace should expect difference" isn't very
fair. A vIOMMU could have been initialized by the first given
iommufd_device, as it could have expected the IOMMU info from
either the first device or the second device to be consistent.
Yet now how a vIOMMU to get finalized given "userspace should
expect difference"? Certainly, I don't see an issue with these
two PCI caps, since a vIOMMU would unlikely integrate them in
its registers, so long as we note it down clearly that these
two "IOMMU_HW" caps come from the bridging idev v.s. IOMMU HW.

Thanks
Nicolin

