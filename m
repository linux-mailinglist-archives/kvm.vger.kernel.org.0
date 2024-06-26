Return-Path: <kvm+bounces-20554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 658D391829C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 15:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E79721F25CEB
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5F21849C1;
	Wed, 26 Jun 2024 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q6wyiFEB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D5D181B86;
	Wed, 26 Jun 2024 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719408934; cv=fail; b=NznvAmGbliAlkin1aVSFZG9fFEyzPiH3SubUpFMZ3Q3Noefec8JNsIJXr1h/rKdVZl3EuX6g+cfkoIEfIvLnXVb9D9rbySLF7+Qicfm3b0DHy9dolAVor2xmi4N4e+fm/6S7uHutRH5ArPHww2CP1rmmT62kEwG6YDi3SYFn1GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719408934; c=relaxed/simple;
	bh=wX2hhuMHMcAtK2Nz66m2b9sUEoe4YWPCg2As08AaOXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rznwXAkvjjnaIN59G+pFgIHYbYi88G14H3+qzEesKbnWb0XOTBlNY5dW6peZBcnBuuIxjnIM4wqBRaTLMjl86ETIrAiQtNfijxzSs+oov3wgeHGRqvA0h9BtlM+yARRs9lRJCv1DuVUdeie9EAyH2+oX+P46KEEiD5TzA/BHz/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q6wyiFEB; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfAiZws/GgBULZ934Zp+u9lL6nL7uaCt1JiEdqt3iL8h8DkxSfU6VxXAKpGdcydYTqX+E8aMGjh57t6Ph0WEhLLm/LNGETtotDT5LnUizHua/sYPxl8JW99x9SFTAkivO4K6OxITZr22+UIMKshZkLmj8KIdTwZsWLs6b5eG1W9GVeCpcUpb5KNekoQz6i4AwuI+fBApEz2+RJtHWsrlBr0+9zmYMbOLuLXEKpM4wbOqWdwRhUeHz4m3ijBojFXromvhlrW71xbhVTNXlRNj6SkkdKIqSVNpddgwf163e69mYkBXLmtcHmjnpTsBMAY2EQPV5Kp5gkgNUBEYQyxRfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nud52S3pzfDLJS9zWYiXzSxBemqkPRj/SPns7r9I9j4=;
 b=guYM3EIY+oCwOHpY48YQGoMwS+dcfnHXiPbKSvTWFiDg5kr1lRFcmiQF5oRs7mR6AHS2ToaqdeSKLXWmzwb7BTIPB6f9oFDazGg1SGS++yJqBtpxdIDLVotcYsKM9y1IcmGBUfIV92DqMv+q6CGj5iBjkYqI9Zds2KN5vqwQl/bq7f8ef3tacmbATNWD4Q0tQADt7DRbk4of4jFhUvjHnwh6mqW/roHshTUZxr7Qpg4gVIoDReiMlHVq3Evn/XqoJ7WyJC/Ijc8qxZnExdSuq8lhNGj3W2i7ARidJSFDwTJuwE/pYTDXXSa2cQAtS1Lz7dmlY9vKa5LdV9Z/0lkVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nud52S3pzfDLJS9zWYiXzSxBemqkPRj/SPns7r9I9j4=;
 b=q6wyiFEBbIQROV3qB+JeuY/Vtc6bwdRfJbj1qBcA2QocXiqLfZIm557fAUpm1lyBtczoYRke/G6efUUsLVMVnnpz+FyRi2DrAOVuFlFcA8qqszqH2rOAZrjBAABlwKRuvx/BmahcaqBUfWZJO+O/KbENoiUnSjbqaQQIfhpvFdjfnaypa0YMipSwV3xqvgJ6/0WXcSel7oqce5M2ojLxc1cWVA+3oucCN3Hiwz48VHs8HRlfWEp+E+kNJqkx21rbBZahMHH6PN1Kdnt7l7cvlh3eWQtXELYtz7vIwT7tMnJA/eRUD9TRQDZbL5EOW7Lz00HW440IpocTIGHv8y0iSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA0PR12MB8906.namprd12.prod.outlook.com (2603:10b6:208:481::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 13:35:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 13:35:29 +0000
Date: Wed, 26 Jun 2024 10:35:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, peterx@redhat.com,
	ajones@ventanamicro.com
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <20240626133528.GE2494510@nvidia.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617095332.30543-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MN2PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:c0::22) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA0PR12MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d2380b-e295-4056-5c08-08dc95e4d86c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|1800799022|366014|376012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6qWxGeRf+Y0kyNV3PdH3Wm7OTHOyx2gbJM1zYaHkmH/L+m3EVy+hws8z0J05?=
 =?us-ascii?Q?D2rSsls4XPdACHiV37QVjkHySqS/PxuehDAsz8ePmmbehnUAItJXqoMqzyaw?=
 =?us-ascii?Q?8is3IGMVKiA8LW/qFwTc++E1NpK4W3zqAvt78glHfOfcLqSelDGPQ9DnNrjh?=
 =?us-ascii?Q?85Ocmy4GLmwlgnnvN1VhtIW+Wci7GrscbeNYCNbykJ4X1/xNg2usocjUBGMF?=
 =?us-ascii?Q?oP6inj14e05F9P3QLBL5yy4yFUeuDUXa3zxzmy32RlXL4betgUpuleUXIigo?=
 =?us-ascii?Q?ne6bm0A0pbUo1cVQCAw2hWxmADX7SToCxkjs4skwuwAimCnXtIZLpa8tvucb?=
 =?us-ascii?Q?9IoZLIhv/gX0MEwNz997tatQapEoRg6mmFbJU7vv1dIcQA+oSHqwkRuT/QRX?=
 =?us-ascii?Q?v6bWdqmaXZtQrjzdn9l2c82tqkgTw5mqsU2opC+tzUCCyZZqfm95U29MENSE?=
 =?us-ascii?Q?aYtRtzVlDBIUMW41RA45VB+yVVqAQkFlwlYBrMskqMs6+VfW5SIJXimojXmc?=
 =?us-ascii?Q?f2nSij3/uzUCNVV5qJVltcJsIfJJVziv93SHr8JmjZy9ChRt7Faub3MiEnkk?=
 =?us-ascii?Q?X6Nox7Jy45H+KiSSx1G+3fhdS6II6bqnwQd0HJSL8PlHhgMlGLetywpPdB1x?=
 =?us-ascii?Q?Fs47x2WgVchR0U7ngjesfo7bAoJb5FDLqnAQAwJvSetepAlQzS4q0GShOvzJ?=
 =?us-ascii?Q?ZP5cg+P3u+Cdii8dInGMtPyFV2aJNGZTq8DH8xEinSV7p7P2jlbqJtWGMadU?=
 =?us-ascii?Q?dHCFIEcDA2Ewt1vlR0RUPx1HafPHvWke/NjjvV6GRRHZ7Q9MOa5IrCI7f0Zq?=
 =?us-ascii?Q?+tIaClvICDmFMcEADZ+rz4mI88HitZx9avmj4KpEbtxN1wLMeNZ5fb/jzkCj?=
 =?us-ascii?Q?JLbQr2fPHyHwjVrn9piu9TL7/M9NbXkJZwCCp08dWQBS5s9SlgTzJsHmaZ25?=
 =?us-ascii?Q?6Sx3v/c3v8hDx/OuAgttVIvSaQYb6nRwO/Ihp6VyNQnEegRVenVDBtCieLny?=
 =?us-ascii?Q?sHbBaYteGNa7ww+KmzF+18JS8ddzjRl8r20EkdlPEkhBaMtLNVtlA2sYBkId?=
 =?us-ascii?Q?xtNd9p7xU7N6cI+VXDVB1W7NVADkrmuL8i9h+38PJQWezFiJmbIVUFSINN3j?=
 =?us-ascii?Q?RdEJ1q/SF7O4sC52rQvwoKuJMdKGVWuY2Zdv1wTreRpx8wirMDY+5KcT/Ck6?=
 =?us-ascii?Q?je3B4tvH0gouPMDpSyTIaRLxp7/xgPSAhsxLXY0b2b+9e630wiI1m2JPIjfJ?=
 =?us-ascii?Q?0b7YolOiRldy6us0m8oBi70Q8HY1yrFX7ntGAKHB3fmgsyOBZXNN8pbDjs+h?=
 =?us-ascii?Q?mHU5enKoelhFzjZysNilA2m1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7vQpccRlpqqqX4roaYZ3YhYJYti6/x8GlSF+FeiKSL6VkHR0DTl4q327FWU/?=
 =?us-ascii?Q?4Z3csjZ1V80mrU7oKl9klxtih62l7MGZ0NL5EiYJzG0XXTTSskQdwO7Nwlow?=
 =?us-ascii?Q?AMa5iGL9OQfeTjfQdgcEVroZQ5FrVIIoviAZ6POhflLsIGvB1gZ7KTUTx/F0?=
 =?us-ascii?Q?HUiV29133yhegHG4bBj/N3yO91PG8Ag4K25tFQk0THBdw4GMvCl9rE4nzcec?=
 =?us-ascii?Q?S51VuHMHKpEHJss8JXMOSFaCcaSnwIIiIho4xl4+ARTQ0moOju94hgC5Ht6X?=
 =?us-ascii?Q?YY8qpcA3Hshf/86xTh7OvLedGGcW20iZfkLmNK6kNtpTHxCtkIRrmrBKqkv4?=
 =?us-ascii?Q?cEllFL7P6DDFbsRp5PbGGTWxipPZlbsWehfyhCCLRx08RZ1bNbCLmFIPBcb2?=
 =?us-ascii?Q?gQ2ytCC+N6Lp0sJSvnsoFruiHrnHy8Q96uvcPdU48QnkUYRcPBE5NKhQmmml?=
 =?us-ascii?Q?igqlckX8FWtgl/WOvbCclMk6VaMJwdNTrCLSQc1dwZNjWq30qcXiiVnQ9iAe?=
 =?us-ascii?Q?qN2OXN6G6C49V3/wKkPDzccpRlToQ41S0gBZmvQnSxCjXZPGpAXuyJ+RrCem?=
 =?us-ascii?Q?C08Nz0QjzzW0z5/cJ5Gs3dpmL9ifL6LKEwrmldRMeuWxae1cNh2SWpzRrbyX?=
 =?us-ascii?Q?JYqhco+Ysj8ITs/87ENXl3pXOcZ9MEXp/7ySCsNf8/1J/wXdZ7KJccHGj0eZ?=
 =?us-ascii?Q?E1dc42xN1UJ4pG1Xr2Mss7JZQRWJfPaVUapxl0Q5g41tzRsOjH4NDuZsrf2/?=
 =?us-ascii?Q?m+L0IQRQkeDynLo1Bzyv3ulVkOB4hEh+rFZDh2hCy0zUriYqpyCaasUw8v4S?=
 =?us-ascii?Q?aAogOgYDTRJIqG9svJGtS8a5pCkxmkJ9WF5aWoS+aVMw93QU9ujblAx49E+g?=
 =?us-ascii?Q?vIUkFJwM1JCMuoPKdxjox7XvQ/WuTtc6f9CfMu64YiZwun30W1PbQAYYWVDf?=
 =?us-ascii?Q?yAoVqPBSOrOD6jXBrTQ3ZdNjGbVj3T3nP+arMc81M3k2PVNaFBZzLQNQ2R4C?=
 =?us-ascii?Q?WZxPnWCc2gwblegbbAxcu8LJm2fzLsl7vB9z738gQLeUYrpbH83NdHXCSt1A?=
 =?us-ascii?Q?a2f8Zk9hLjEypjBOqjFd75RSXX1Dg+cY5mo4l9f+qOKqMqMvPZhd8gqdavTB?=
 =?us-ascii?Q?0aHsziWQcei6YxYuV06DKDKaa+zhVMhlpD1i4Cpy6RG633XOsfBaDH015s52?=
 =?us-ascii?Q?kXHUXI7moS34dmD9/VzvPCWHfMePeyMMvtwZfrAkSJvicGh9XBClzHmK7V60?=
 =?us-ascii?Q?u8c6k55ud19q1KB1/E2bN2J0p1a6NHyLdMw4HQBykmJP/Qpqi/7gMWVzBB1X?=
 =?us-ascii?Q?Ct4JK20Sl5tonYdF2t27t9Uo2s/s7pn4l/k7U+atilP+52f3yKTFw/VBKd1y?=
 =?us-ascii?Q?shT1qF7KnzSZNRNpY+V9Ri5iGM8wOh+mWyumAfZYNzNgIZ1riCpeJwM4j6NJ?=
 =?us-ascii?Q?ofoVbednAbh0bc50Q1es9upT0gMzC24Dxkfw2U28Qt3nVpMH0yEGVSu5MX3e?=
 =?us-ascii?Q?aafGr5JWeEvXHAOPAZJmHw0PTa7nG2nRDuSjjaWC1k7IWiWFmZQmvIwjIubF?=
 =?us-ascii?Q?5svLp8PJPWKCgDfZ23yP9CN+MtSjMhe0kW978egP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d2380b-e295-4056-5c08-08dc95e4d86c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 13:35:29.7383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix0+W1Nhrxqrlo4xWW4M/wG8bTQD5ZXC5PfOPT7ItaLAeqGG6VDJW05Zwfwh+kqV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8906

On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> Reuse file f_inode as vfio device inode and associate pseudo path file
> directly to inode allocated in vfio fs.
> 
> Currently, vfio device is opened via 2 ways:
> 1) via cdev open
>    vfio device is opened with a cdev device with file f_inode and address
>    space associated with a cdev inode;
> 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
>    vfio device is opened via a pseudo path file with file f_inode and
>    address space associated with an inode in anon_inode_fs.
> 
> In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per device"),
> an inode in vfio fs is allocated for each vfio device. However, this inode
> in vfio fs is only used to assign its address space to that of a file
> associated with another cdev inode or an inode in anon_inode_fs.
> 
> This patch
> - reuses cdev device inode as the vfio device inode when it's opened via
>   cdev way;
> - allocates an inode in vfio fs, associate it to the pseudo path file,
>   and save it as the vfio device inode when the vfio device is opened via
>   VFIO_GROUP_GET_DEVICE_FD ioctl.
> 
> File address space will then point automatically to the address space of
> the vfio device inode. Tools like unmap_mapping_range() can then zap all
> vmas associated with the vfio device.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/device_cdev.c |  9 ++++---
>  drivers/vfio/group.c       | 21 ++--------------
>  drivers/vfio/vfio.h        |  2 ++
>  drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
>  4 files changed, 43 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..a4eec8e88f5c 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	filep->private_data = df;
>  
>  	/*
> -	 * Use the pseudo fs inode on the device to link all mmaps
> -	 * to the same address space, allowing us to unmap all vmas
> -	 * associated to this device using unmap_mapping_range().
> +	 * mmaps are linked to the address space of the inode of device cdev.
> +	 * Save the inode of device cdev in device->inode to allow
> +	 * unmap_mapping_range() to unmap all vmas.
>  	 */
> -	filep->f_mapping = device->inode->i_mapping;
> -
> +	device->inode = inode;

This doesn't seem right.. There is only one device but multiple file
can be opened on that device.

We expect every open file to have a unique inode otherwise the
unmap_mapping_range() will not function properly.

Jason

