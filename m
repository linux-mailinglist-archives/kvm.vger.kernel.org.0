Return-Path: <kvm+bounces-41717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 629EFA6C2EB
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 804043B4125
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A86B1E570B;
	Fri, 21 Mar 2025 19:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pl3cQAzk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020D22FF2D
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 19:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742583653; cv=fail; b=tm99UXNtsc+PnqssDIYCP7k08kX3EviVcG1HEmUZcVDKhrLvrnJs8jnEu3wyXjVcNDGRtBoNsFjR0XOG1e1UclSkZaxoFVqTlam7R1+QPIrjfss/n9J1OMQBIAaeHD6ZbvcjpFPRZqhoUrbPZMdyArG1ZiOLOy4TlYBOVBU/sYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742583653; c=relaxed/simple;
	bh=RFOxcYqhbSthZTtQunwcLHf46N1wThHyh2VMs2LsZl8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osHgNFnaMhhCJYf9Oofg3DYTSt1BGiMTm5USmq9xVLB7NqPupKSOlVtVt6xaeDHTqDqmgyFc1BgKiu/S8LhaARkl+4cS5XpMpi1vG4XgE6vSmk/Olcr2zjWoHL4B5YJFZq1YLPfE87eDpkmQ90dvd7+04n02Y3u5tMR9jtenprE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pl3cQAzk; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q18YikuEky3jzmrVu9HMKe4D/F1kLtOLscyxFnX8Enp03TiEMrTAVoQMUertKeuKcs6OGAyc6w3OXIiGT0z7EnRp9hbmmpzeaeqrNUDjnBT7oNHzU5DgDAWch3fClvikQqz6FbXUoHVKJhb1E6/YuBqSczQeTZbgAkYSNzyh7xIfX4WQMG6q20px57pAPpMIfkTC5HSdMYvtAUVgjZciy0YalVnTeBk4Efjy5otXou0KhtFt/knWMawYrmrzcOaL36NwZawq/kTycz1wAAdtBEMAPb9Mr3aKrLJ0RjKROfOmGofHrRr0MDEBfqRZURcxW4+4ymeXnMev3HJ1keX/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taFy8zBraLxibrNfR551pbBinY5LcRK4dxhk6cfloRY=;
 b=m+D+hLBK+3sCSwPnnwhPDAQVudF9Tbget9AwbMzkT4CiOAb7fWTWUyVTBNaRrDCyR8BuPnETus18rM3ngMx8/eR8uQKK0UZMX23tAp4eONKE3qq3II0D1Q3+Qr1iJ9mK0f4Rf2B9ifLh69FT4NtA26SlYmJwyGLkZWY2cqKkHduLUD3R7PCRXs+nPCjjBlM5EGZQkemMGtZImpxnHVNGT+MIphzB1At2dq677TzZLm/Iy7MTN+SwzGDhq/gSOP7nhs/svPJTSaERLXvUI3LDxafuHnF4GBgj037Ygio2UuEN7m1s9O9O7lN6yFi3mV9h6MhNEx49XHDBdtOa+esM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taFy8zBraLxibrNfR551pbBinY5LcRK4dxhk6cfloRY=;
 b=pl3cQAzk6hOquxswWD5DSwVOcXsFSZ/z2sGriw4yLjweeZ184YzARjj73Ij3h8niv5ukT/Asc9NuOiv56YQ9iQAvt8aSlLh3pvv3tgPJ//O81rV6lqQL+lJ03zbDyGKMJasaz3aBCDyWzmdWhpL+qO7AuL0Lz2zTOyYn88CfKFGfmtgfTyfLPjle4NEbwZQvvPowEcWt8+L/a5ues2JN3VzVvzCbpMcI7mPKLMBrtE4tD3IgzUSM0IqEsgD+hqCS9oYpwSoSWA2I3QecDL4cF6W9xioNgaWsa+cZIPtYapX+qBLSg2xEFPNyvrXnuelGtofLQ4fqlFUq44RyH72mqg==
Received: from MW3PR06CA0010.namprd06.prod.outlook.com (2603:10b6:303:2a::15)
 by MN0PR12MB6200.namprd12.prod.outlook.com (2603:10b6:208:3c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.35; Fri, 21 Mar
 2025 19:00:47 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:303:2a:cafe::ce) by MW3PR06CA0010.outlook.office365.com
 (2603:10b6:303:2a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.36 via Frontend Transport; Fri,
 21 Mar 2025 19:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.2 via Frontend Transport; Fri, 21 Mar 2025 19:00:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Mar
 2025 12:00:23 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Mar 2025 12:00:23 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Mar 2025 12:00:22 -0700
Date: Fri, 21 Mar 2025 12:00:20 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z923RAy4CjgqUNFM@Asurada-Nvidia>
References: <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
 <20250320234057.GS206770@nvidia.com>
 <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
 <Z9zqtA7l4aJPRhL2@Asurada-Nvidia>
 <035649d0-5958-45f3-b26d-695a74df7c39@intel.com>
 <Z92wIQGa8RcJb2T/@Asurada-Nvidia>
 <20250321184205.GB206770@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250321184205.GB206770@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|MN0PR12MB6200:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dcf7141-46e2-4bd1-e159-08dd68aab006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bb34jReVSZVqs2LuWqKupJzw86jr4NAnaCzRZYzMNXzx3keLKKDEw6ydY2i/?=
 =?us-ascii?Q?w6ulCE1oP3rCG8WIKClAoficuDM/Bzo0bb6BKs2/L2fZQ2mH/2cCgeQHnZ7h?=
 =?us-ascii?Q?bEj1JBljXtTf3JZ+cuHJKNkQoGShYH+fb4nCZRghavQ4dX7kgRIYJViAQnZW?=
 =?us-ascii?Q?6LlJ80gX0Wk43ViMb46BCopmeNzX0lok6/azDyhp25wu/wAol5rPTgsdtUuj?=
 =?us-ascii?Q?sCp6OOby+lTkZ+Dl8a0YIZShKeZVZH5EtQCZA3/mVgJZKxGsGVnZwCWY0m6D?=
 =?us-ascii?Q?sklTJCzzcmofBxJw800R9J46Md4jvSybtQ0Ni3BP/Kg86bZsZH9yIjambh5t?=
 =?us-ascii?Q?ZSnPVTdECKKJX8XtQlLI/7Y0c3d6G+vwJGVuSx/ubuctnbxj+gD6mBX5as3R?=
 =?us-ascii?Q?BCg8dZ5x6VyJkHFkpRkdQP7OvxjGJ4uoX5CuljKizMSVvF+rZmLAjag1wY5w?=
 =?us-ascii?Q?omHRpdsS2SKUESxQ3pO7uiSHzL8YgkqZrvRCq1fDM/50uxgBtcNM7/YAcXpu?=
 =?us-ascii?Q?dSSkEsTPC5cAt2jMVTUsI5qVdzuqGYlWE1kXI/GjVwEotRE0wF0DmZCVUcYB?=
 =?us-ascii?Q?DmoD75/h/dYAXn761JpC3iToY55MHFFjXo3DrYOzOD+DTfvI7x9oph8Nq8Vf?=
 =?us-ascii?Q?O7DQn1Wn0jLsZl9x9ZGYCJkpTUjDq2cvXzgFVIvJHPx2LKdw6ND2eVu0MUVb?=
 =?us-ascii?Q?50o6Ym+ShvETqEb4yIsHNq2tH9h+YAfXlNwwt7LkJr1EW/dXr8BlPEDylkFS?=
 =?us-ascii?Q?IiDkw0FzG73yGPysnxG5lmQKIScTNLNzYfoe0GBKt7fyQgRq0ONis3pf5Cgq?=
 =?us-ascii?Q?muTKFU5tKDpv2+VshTereOVFcMyDG72URiHHiVcAgaguMv5Cx+RwgaL+USyP?=
 =?us-ascii?Q?EwBmWNZFfdpZhZQyAFFaeYnz7jra6TSZcE1kVo46dI7UN5UWhC2L96nKC7PK?=
 =?us-ascii?Q?7MU9fScoCyuGzY7sLMyO0E7qaz/X89hxZ/lVRAwuwxqCZELk68pmr31U7aWs?=
 =?us-ascii?Q?B1T6DidTV5i31h285LGTRaDJcYDIrOm+KP006+FIbI7l/TgyaJMxxvloiCsN?=
 =?us-ascii?Q?bjEi5NEQGPNuo1szKELP1C7iiw5FNEyKJN+og9HVwhn2B1BfcWnYQSDdp9EK?=
 =?us-ascii?Q?kGaJHoBH0uqeAhKsjpyrxMs51SWt0BTnVdV56rWqGjs00lJtmHaXxG5WO3J6?=
 =?us-ascii?Q?RiQKgqiHZDG1XijMYmHGfRlqhx+f5eei+jE/f0oFAzEH/ZdQF82gFCFP5iEU?=
 =?us-ascii?Q?2QWHUi0RruVSDkjl7EthG6kMi8M3Dk3NJoOAKjfLA4MuceMrGKhV0s99wpwK?=
 =?us-ascii?Q?EHnfoXOeX8GWJax7J2IVMB+iTzjsRyfXKH02FciBXGXuNkVora3UxSlQBlSt?=
 =?us-ascii?Q?tLcTo+9aOkDSynsdu98FKy55fG91ChwdSsJerH0Fw2Iqjhy2t3dzmdihSvSl?=
 =?us-ascii?Q?E60566oIT4cs5L3DLC1tyCAPUFk8iVhOBYuVNjK7RsU7jokz+4VmlroTgf63?=
 =?us-ascii?Q?IvTUC3V6rga3RB4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 19:00:46.3134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dcf7141-46e2-4bd1-e159-08dd68aab006
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6200

On Fri, Mar 21, 2025 at 03:42:05PM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 21, 2025 at 11:29:53AM -0700, Nicolin Chen wrote:
> 
> > Yes, this is a per-device ioctl. But we defined it to use the
> > device only as a bridge to get access to its IOMMU and return
> > IOMMU's caps/infos. Now, we are reporting HW info about this
> > bridge itself. I think it repurposes the ioctl.
> 
> I had imagined it as both, it is called GET_HW_INFO not
> GET_IOMMU_INFO..
> 
> Maybe all that is needed is a bit of clarity in the kdoc which items
> are iommu global and which are per-device?

Yea, that's my point after all.

Thanks
Nicolin

