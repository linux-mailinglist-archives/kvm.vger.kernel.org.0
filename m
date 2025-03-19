Return-Path: <kvm+bounces-41506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 096BDA696BB
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2780423375
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF68B204F8D;
	Wed, 19 Mar 2025 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HFBjwms0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDA21E131A
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742406131; cv=fail; b=gQQdi8NDsWw/EynuR8SI1SadK21cHfgmr6OTJf5ESASG3iOjdtURpKnJ/lXih9egUB3/Ugbs0NqEsdcHQUhIh7ArTlP2dJMwJQNUn5mH68sk/uqU489u3HANNohx4k3ah/YnijfvaJiBGjm5Hs4TIsLNhiM5fWaIUWqY1nxpykY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742406131; c=relaxed/simple;
	bh=Hzow2ejjpliZquhKuxB6yt/9Fuh35Rkj0h+zX08A0sU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UH7hI8qbS6Afyo+X7dOcgGJlj8f6KmoortI7Q3PC7g/+wxcCa+9ptxzLSiUjV6ZLSNwZRueUf/YMsbZGnKcr+enGg/7/zu/BYHIKDWVnb31e3dY7ov84ZJT5pGgedkhzcFGGVxXpC3ne1UxAziK2/FiHNyFm+TG5NfEpf2b2/n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HFBjwms0; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkvMQ2ChMvjKksxpIq+9hOskj89e+wXafNggtG1K69k9XGefDDpI2I+Bkp0TEhHFeDq3WHKBK+slxuTpMBjqi+V32ppnHlPsAu+UotXXbzfIBwipEhJQl5nZdgThHmvkqyKBhuIp8OL8nTPzfky4Opb0yibTKLLqwnlay9IjhW3EF00Azi06P9AvKUGK50ximVMQnMtUU1WhsrVdRACNE3UsyDygPhBay6eAsjskI5bzEiDxzLoV7TWQWcMmNJKRvmAnnn2GRsFPW7pJ9I5GUR7kMK9c4FplhlEFf67uGwK0w7IoPPxUm3SZXOP5dfAIMe5EjeK3c5/dEoaTnsTYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPUEG7K8AJeHhBGSk4vP8WQTCdVJyOJegXIovHYDSDo=;
 b=rWuhBgktkwAUxkLarHz3+pB+GqsQX5gA8VqJ4vx51of4ysV1S26dw0gUzaxpyF7wvScK6qt8sBVfRYIRVILJ0BvcO8TS3+vqBDJUeDhbafWa+ZFjJz8KIGhc+LVJFpLVJscVr7316m1PIL+h6873z32ljXJJNs3CDp4aPWfK1PqxcpdhR8S2RAa2k5Zu9S9Fz0JcU4G1Z2XSmArk29tjsOmHMa1qosf/IpgyG2cNo99hDc1fqeUmC4DmRJ8iNCleBfYquqcQgnJaQxPV9Vta5AFSGLuu+eCsRZY3VtN//NQXIPT3jwrb4Yh4KHSPuBuigxycrpVdyEL/yTLmEt2ZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPUEG7K8AJeHhBGSk4vP8WQTCdVJyOJegXIovHYDSDo=;
 b=HFBjwms0uZm5UwolC+nZKl7KcCIC9c7s2wKs4gPiFcKkF9vXcGbg5sRqXL2NqnwS/BbtLNxSMbjDWRdUXZpEPx0MBuk6aUYeZ4GxFpvXQdiWBefQeqQDV/5kYUYACYxPcSIFXlMFM0f5Pjtd6JjeeJsGhvAN7T2JfHyYa9fYpe5IbUN8SyjkmSYmrDW4qNLmnyMemYU+XbjJ3W+O4PFjWaIJ8gbzqVZs4H2gDBmrfYFpdBh7RIIflcHzzXZO5jDYQsK3/Sj2TdJlmwpqRmW2Pjsf2+Nl3A6Lqr0NFruGNNAlSAgL22WYfaEPuqqU5vDlrddTAQ5Kihho+KLLfqirgg==
Received: from MN2PR08CA0029.namprd08.prod.outlook.com (2603:10b6:208:239::34)
 by SA3PR12MB7921.namprd12.prod.outlook.com (2603:10b6:806:320::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 17:42:04 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::af) by MN2PR08CA0029.outlook.office365.com
 (2603:10b6:208:239::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.34 via Frontend Transport; Wed,
 19 Mar 2025 17:42:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 17:42:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 10:41:43 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Mar
 2025 10:41:42 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 10:41:41 -0700
Date: Wed, 19 Mar 2025 10:41:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Message-ID: <Z9sB1Ncudc13jATq@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-4-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313124753.185090-4-yi.l.liu@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|SA3PR12MB7921:EE_
X-MS-Office365-Filtering-Correlation-Id: b50d34fc-b05d-43bb-37ec-08dd670d5c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oRem97roXmJvWYX0dIfv8J8r5UvMy2MeDWZ1RMzWAN5x541HqA23VtjTs4yL?=
 =?us-ascii?Q?oGUX6Ge+b31Dp4+p+Q5wtNNgdi+C0oDYClI3EHVVVEsPWPHCVGi5Kz4M9I/S?=
 =?us-ascii?Q?mAAZsIT1y6hOXNa0qKYn9zms74p6a6MrNZO6vL4Si2ztuvbTJcFTUslDwY2N?=
 =?us-ascii?Q?RJVYpGsgjUepg8B76elvanSKCZDbOA9WbpJ4Y6o0lahMi+gGoexrKRUJacAx?=
 =?us-ascii?Q?0cCEXdDRuvdSyj5HAX2JspG6RV7qkdAPwHHYZOoWv7BIG36iQQIBLL1SreeO?=
 =?us-ascii?Q?W9l3sRBssEHWVK3mbX2RtInUJBI9lUNP4V1mHf/ud11kswfQZOhyO1qLcbxb?=
 =?us-ascii?Q?9NeFXYiKcmJlBkJZ+q3okUntiRGJO7vm9Qlef+VAfSu32kPzHyfgpSHxlFkC?=
 =?us-ascii?Q?CJaVllz6zWdciMcyYddPcPEoDFdAOESRbhfod4uCPWW24hkuvO1Kps6E6nJp?=
 =?us-ascii?Q?d8afVzhi2jtss0zkCsDz2R5VRsmIZ7zvuO77+AuyaRmH2vf7qsRfHd6RRXKT?=
 =?us-ascii?Q?dDKO3NvsYo1hSNBnI+wlFzIMR5Of1TgmhG+1ERoc+cOPYMFx3kp14gaM3SDv?=
 =?us-ascii?Q?M3I7ch17eqd/taXSdCcaugWq2A8Pzkw3alzEXg7qQ2Q2/yc+8n46JYq8fOqb?=
 =?us-ascii?Q?wcLfy1OgwgJrgtGGtNbg5xCqO5bpMFQeKsrQVhotN/I2s4x4Ejwuc8ZfDKp7?=
 =?us-ascii?Q?1xc1kaXuO4ru68t6W4hbocVgopnSWD7EMtdUg2vivZzgTKDtyfqf7pQcvxJr?=
 =?us-ascii?Q?XgNzxbeTOdcp05ySh99s8Ya5NWj4YsNFpTLMSPyvCa8L7Zo+GrnB4Xi6uGua?=
 =?us-ascii?Q?7HP8OszI/UJrQaWIGEuYPJmxlihRFXAm2trL8IgcKUKXpiBtUTy/agxHA/yF?=
 =?us-ascii?Q?P5B6Gk7MtxSLqC7Ar5eemGnTRozAf9//gIJSwOGdeNY6qtJMLHExRoAE4GNC?=
 =?us-ascii?Q?geM2OUDhdccxvMnH5gkztoRkStmHGG+/W97oMEPXA8kPo1JrnlY4FDF1MKhu?=
 =?us-ascii?Q?cjls+EdPKBiluxDn02xZobNq25YwbAVZTbOBe0iRlcWpCOk2zvJX3lSdCk90?=
 =?us-ascii?Q?0rkO4MXsuH+UfnDkMWbnGvtXg4JDt68w/frfXLYB2wB+UfM/cEu3c+44+jXZ?=
 =?us-ascii?Q?M+Xf64u/JDw/BajAt58MDKO6rEQin3RUDx6KmwkZtRHrL6XyveDumkIEWvUh?=
 =?us-ascii?Q?29u/0bNvuIaMWQb5EDAxls4xChxbIESCjECtEqaYYzc7wd3VY/iF10/H8EPq?=
 =?us-ascii?Q?Rb8ng1zOjILjtpv5tGx6lPaUyszpriG8FpxiyYl0F1/2DwBTW8NmmIuDIfVB?=
 =?us-ascii?Q?JqP0//4IUXFWwU21SvO26jy/ykfU/koDyF2uyuOCLFfg7aynmJSS1mqWXq03?=
 =?us-ascii?Q?+4vgdT6zDTbWT/Lyk7kEu77s7etR08orwdwiKfoHBpNP3PM3tHHkUZ9DmOYv?=
 =?us-ascii?Q?tONIds9H+cL5OhtBaohYVHdfkHZjLTiad13WUqW6SKNPIkFZmKBiiw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 17:42:04.0646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b50d34fc-b05d-43bb-37ec-08dd670d5c9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7921

On Thu, Mar 13, 2025 at 05:47:51AM -0700, Yi Liu wrote:
> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
> a given pasid of a vfio device to/from an IOAS/HWPT.
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With some nits below:

>  drivers/vfio/device_cdev.c | 60 +++++++++++++++++++++++++++++++++-----
>  include/uapi/linux/vfio.h  | 29 +++++++++++-------
>  2 files changed, 71 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..6d436bee8207 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>  int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_attach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_attach_iommufd_pt attach;
> -	unsigned long minsz;
> +	struct vfio_device *device = df->device;

It seems that the movement of this device line isn't necessary?

> +	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))

Any reason for the parentheses? Why it's outside the ~ operator?

I assume (if adding more flags) we would end up with this:
	if (attach.flags & ~(VFIO_DEVICE_ATTACH_PASID | MORE_FLAGS))
?

> @@ -198,20 +221,41 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_detach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_detach_iommufd_pt detach;
> -	unsigned long minsz;
> +	struct vfio_device *device = df->device;

Ditto.

> +	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
> +		return -EINVAL;

Ditto.

Thanks
Nicolin

