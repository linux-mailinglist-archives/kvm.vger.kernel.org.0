Return-Path: <kvm+bounces-41598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C74A6AEEC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 21:03:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB645423C25
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F3E227EB1;
	Thu, 20 Mar 2025 20:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PB7WEUNR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E42204F6A
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 20:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742500989; cv=fail; b=fd0hLf9qzYMQOS4DFy3fTOARP5i0iuUrLfVAiQHPrrSZjNw4M7FSBIDLB3yVKwdKKMpcgVkHALPy+Mwsbm745cOakYcwEqZOzWy2ndRNeAC9lrIVLnron6tRhZzuW9ZJNnrlip/aI7g+c6OLOf364c5SyGhOhPnxEWSSdBFNlxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742500989; c=relaxed/simple;
	bh=M2QIR4PPuFCkBMm2SRHMi8wAo7n32H5PN4h7Lx55Y38=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVOCLkQYgjJLGy8Ro9CktNQ7YyPO7KBdh280uuj0uOlwrWzlzi+8tOOjA1M+Kflt8lvpLCiZucFIs10gY1Hn2u1XPcaaRvahTc9zjuNWckfljbVbse5jh2AiSKlsa82Xxuzmh3dGbgDVndubTjZfk8l8Cew2fHe8v2MnIYHVyuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PB7WEUNR; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuUwWqjCevzOGXjyyqBj6ZVkTYRXOb37gHvmtuy8yP+u9fBTR8JFpCKDBJaXXFaVZaMTU8UIjYS2V3Y2h9ljSWUpeol0qiJmqSyTUr8ja/+t3UrASbbfLbViqhbWNPZ4gg9gwQUzJ8Jo0PwgIJE8mtbHhWZ3pKNJvlv5U0LVZjXU+0VruX0mVyWYtxYLgkBp/V45pg3/kN8PdPwxKNZstwaCsX3mYo+ZABbgNTNVr9bANH/c8SG6FhIKjQtxpNBuFiBrOvMsOMqHWmgjm7oDTrgme2Mu3rHGlaOBmSk4gph8zBANi0fp8H6qoTZ42LXanPiIW+ZmCdDrl9gJrRztrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFOZ/uiyoA6Pjl42EwRLDBxxArHtEFSgrmSYE0K5F2g=;
 b=pK7w/TWo7XqYpn5wdlE1p8J2lUWw5zKZ93+AeXVscBWyc2aMljiKzl81anlzuK8brrp+rCSmmGYFqwXWrXSyweLu0wd3t2cJs1tleYWaY/ZJ+1r55Oi+TCiHic3cCZSdvYLBLRqGFzScvM5AbVJNAPnGxiv4zuAd8MEsN4Yvfi5jxmMdk+hHKGqmUwA6WtSGSi2m0wkgpuA0A4CjF3APtwN3HoEKiSEEcA0zL12MFMt7H04vytqP08VNUxJJDhGS0VAJF+ah0J3KP/J4TFa0rY9zi4pPFwgpGJWV7jeq1oBlZZo+Sv/PnS24F0aJw2FnbolgYAYEqicaCGZ6Ke/wSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFOZ/uiyoA6Pjl42EwRLDBxxArHtEFSgrmSYE0K5F2g=;
 b=PB7WEUNRyFf/jtexGtQyJmZnmdkdAHft2/ViKbKtXG+1HBWqDPSvLBkwGUauYqS9UWPT18ZAmHi2jQM1CwGvkquHB3BGhThkqAvt5HKIETrk7FlG9P79trfLo4W5+bGymCKlbiANUZUw/buRm6vdJPhDTeEr9GbAwj/qtL/prVW/vQscp2846UuAjZtUZ98z1SewTcT57prVBI/w6eFX9k7s1b6hUsIrBUuJCh+ehod98ebbpOB0F+tuY3dCKSMr+PN2Mt/T/1mpIKLsoC72jcvRhJOJZkt7hnYZOw20Kghe0r5CHvVKXEK252ENK0BiG0x7DX2IRVC2/ZTOAsEetA==
Received: from CH2PR11CA0009.namprd11.prod.outlook.com (2603:10b6:610:54::19)
 by MN0PR12MB5810.namprd12.prod.outlook.com (2603:10b6:208:376::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 20:03:04 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::c8) by CH2PR11CA0009.outlook.office365.com
 (2603:10b6:610:54::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.36 via Frontend Transport; Thu,
 20 Mar 2025 20:03:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 20:03:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 20 Mar
 2025 13:02:57 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Mar 2025 13:02:56 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 20 Mar 2025 13:02:56 -0700
Date: Thu, 20 Mar 2025 13:02:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250320185726.GF206770@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|MN0PR12MB5810:EE_
X-MS-Office365-Filtering-Correlation-Id: 71423fb2-7bd9-44f5-427f-08dd67ea39b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7YINSxhxOlqX7pGCwNQgnaIIfw9XKDR+j5mei3oRJFSu4/CiKFlqpIOrD9ur?=
 =?us-ascii?Q?vx3wwc52deTdeT5XNE0JUs2R4zk5dyF3KRjDF+Y9/eG7mcd5Lrp+3pmQYjW+?=
 =?us-ascii?Q?zj/lSJYvxovNQZMuP7tElMDf77fT/1ZMKEuKDDd+CBn6/pvFGHLwrvqRFq6I?=
 =?us-ascii?Q?IvMjLyThlbxQKxB6CsC0d5i3hongy8EWsbJW+Foz24Dfo6rc6bNSsE5n1sKv?=
 =?us-ascii?Q?fOa41CHL4u07QXtsAAdPrVO6YWORJQSmJgFni4+sqpZli1i7Qb1skB9EBRSp?=
 =?us-ascii?Q?f/UeMHDSlzHsIdlWV/UOEozzsOsVglWRgqinpBMAanPo9aSz8lv/BwdJGENy?=
 =?us-ascii?Q?SPG+KQ8ssioi2k67zXcY4VFjyfNByEnZQJcIvbppUGmjQObgzpmUyrbuUFt9?=
 =?us-ascii?Q?QGBJkPWSiAyEYKELXYAF54AG242x4dpYlYXCv5hzGE85QQfrZkNEguQyEAEy?=
 =?us-ascii?Q?C+OUx1QeWFWezz0jtXU8/wNkqDBWkOh2pphdPAU0QSsISufgcr1NfnGHxXXx?=
 =?us-ascii?Q?x7JzngRwJGKzIrbdTThylLdCy4ViYb7aboTpq3DmrtglElNSxtacdeV82X7B?=
 =?us-ascii?Q?1O2VWu+GfVsm8rra6nisZz2ctq8n1f97FkvI+/35KhTwmgpH+RwTGwM9teYe?=
 =?us-ascii?Q?mHPAzTfFDxFIQHkhKDiefaaGrvGq9SfGbXxRbrPo/5iziaVH0ej7B63fLZcH?=
 =?us-ascii?Q?Scxhhgp3lYRH+bGsMTQIjqm6J9cjgAjPe9+iWhdLIuP9U5VZyR19xwuJyMbY?=
 =?us-ascii?Q?yvwsx2HtWo4SwyJxZDhBeIlGXqh8hmeeWQORVid0YsVX+h8MRhuN/MA1p6Bq?=
 =?us-ascii?Q?W1fTK4xQZcZWlLALHBIkxKSiJPXpEOTAR2kdAKIFkkJyjalskxILVuL8bEms?=
 =?us-ascii?Q?4aLFasm0wMp/ornR5ws8ozO2WCt/4PbgPyTBtCLfNTod2nVI9Lgp2arnF9ct?=
 =?us-ascii?Q?v4iLt7Ylwnj4AyCYFo8zHXm6J1ZMhvHyKKW7IBraV9lV2C5h4adXqMheWBSR?=
 =?us-ascii?Q?J1tiUUfdTHOoMVQlRQdoQz5S21p1URzD/p+Tvhkps7F5qEdhCgY6erx33F0h?=
 =?us-ascii?Q?0mnJb7iARGWUhRt5+yjodIjnl/7YBCccxoWjcdXfCK8rKOxFtngA0z6OtHUz?=
 =?us-ascii?Q?ygDBqzCdwGSuiFho2eb7t+7RQQpNWI8BWyE2AwP3Rm3eJTUQ23Fba4AtwCZx?=
 =?us-ascii?Q?3hmyN4QuIp2/BchHNhGw+WVk5JDsFij7qHd+XdnZjGbNFsJ3qEedivvEga02?=
 =?us-ascii?Q?Ifi583hBvQaUv+eJsnBmV9cPVPmGw2RxrQL9V3Qs0KCd2RV+frAktjjBmNOX?=
 =?us-ascii?Q?eorPHVqbc8fSfzHUKLzHEucXet9nJ/0HximFdYXhmsS7UhYgIMkb1iboJifs?=
 =?us-ascii?Q?mWRbzd49gf8fVDlFh15V9ODBIi+wGzoAUoS0EXwOly4ssTMx5DuM2f8n8SEi?=
 =?us-ascii?Q?Lxpxf8UNHaVPZ/pEJTOn3w0wHSe+HvDuldiqOi6zbQUagnaRxUT6vl+sAMkv?=
 =?us-ascii?Q?P0prAsb8/EPL+Bw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 20:03:04.3679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71423fb2-7bd9-44f5-427f-08dd67ea39b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5810

On Thu, Mar 20, 2025 at 03:57:26PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 20, 2025 at 09:47:32AM -0700, Nicolin Chen wrote:
> 
> > In that regard, honestly, I don't quite get this out_capabilities.
> 
> Yeah, I think it is best thought of as place to put discoverability if
> people want discoverability.
> 
> I have had a wait and see feeling in this area since I don't know what
> qemu or libvirt would actually use.

Both ARM and Intel have max_pasid_log2 being reported somewhere
in their vendor data structures. So, unless user space really
wants that info immediately without involving the vendor IOMMU,
this max_pasid_log2 seems to be redundant.

Also, this patch polls two IOMMU caps out of pci_pasid_status()
that is a per device function. Is this okay? Can it end up with
two devices (one has PASID; the other doesn't) behind the same
IOMMU reporting two different sets of out_capabilities, which
were supposed to be the same since it the same IOMMU HW?

Thanks
Nicolin

