Return-Path: <kvm+bounces-29334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8426F9A984A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 07:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153FB1F230F9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 05:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AC312E1D9;
	Tue, 22 Oct 2024 05:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MvBbQKY1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701715A79B
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 05:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729574728; cv=fail; b=Nbgll1cMvEzJe/ZWYk6r3AU/8eHIO68MZVWsp+PQeoLd4/Yzo0usOKlWv2Uoa6VpCve0ICi6RiWEk582XyTANER+wdnj6Nf255RTcbmwPcwqG2nxhI95FbUUFcnI0Rwf+yQsV6z3IJy0L0mjh28STDacUv3CsrQzUIEr5QoS6d0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729574728; c=relaxed/simple;
	bh=NbPXyW6QSMpwNh3BnpnZCEePyLQUN7vDtuQolZChJjs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZIofYXZOGr/D3Bmw2TzOoFG4riSSNIfGCdwEiM/RAWn4t0h+Gn3NMdw5qPtqnYBzUtgta/lnulJMxSBqPA/p3AiQPm/fuovzTz5ARtJQQz/QW/b22W7QRYarvBBPitqmVPYxVA8OLIjoKxwBglUqEfL1uP3sju8sQlqrP/+tqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MvBbQKY1; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDJeUiyBUkfa+FvxFgW54Kvh6NHjncoGop0n3Sg1E7JgVNIUC3SVqxj8EZcNXlX0zfKVXc251IEir9fAis2zNiUVrwodz/wJlEYxFziu8nFK0LXBtqEFRD0+5MSRi2Ox2xfK6MVpfTxMzGSpKRXpvKMj6u9czXdOcDH8aOUXAGlP6XzbcU7+xiAHCjAgd/0DGq7ROjM7GfiYjYTElRcOtdgs67bWL6y0yno+fHsebSEfGkw7BGDmnAPQDmZkiDKw/RLuMesTghHOhTzrLWhXNtLnSUZ3B4z2dwt+hWEg6ViJTWy6yc5aq+qEVzrVe8l+osYHCjUod5XlzQ5LaW3hqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9ezUp24tkFQEu/ltjBLkw1JgDtHzyu/lMrh++f2Wn8=;
 b=H+4hfWbe9FhP5SdhrOnd1v8VvXmqp6WVAxSAV8JUHfJYKmZfOfjMEMvJDkWPFCxK51BCwOnBsd21KqZIGjR1yItiYiIEbPM055+Nk/RPqaA44siyGnv6HI3nsTjimCzkHC+j+j5IbNJkXIhsLFjVy8OBUXPNYXLIZSE01Vx8SYMhAJQILmC8d1WlvHsEfHLP//9jyTzI1TD0M3rCLOx/FKTz23IVzuC17h9PzjROcpQqbZUtdOuptNLNRkhpoEqxRFODIuJe3x7/EqzeNokaNhPPScbxbwp19xujD9XnKCtlj/7Jo2Rc3l3ruRro/k+WC3/EZbfAWLcYo8X2eBHgvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9ezUp24tkFQEu/ltjBLkw1JgDtHzyu/lMrh++f2Wn8=;
 b=MvBbQKY1QxVj03vt+bgkmcX25r6zfBzWVR+nspgdEoAFBqIDQjds3UtSx7lNHGkyvlHUY0YwkB580L3aM6B1kK6nt+brhet6Wcxji+0rIWajvXja9NpVp4dE4yyzbntMppaWKyvm9XAdt81IbsZK1iIDnrgifjBNhWWYZumJf3oL8t3EcClHU6K7N5EjS6jrkVh8tS3wU0TgG/v8A8UjS0B+345jPCJYHOSCQu9q0XFcEIUe/HEQHkT2Ig44VrQhLNL6DA1sqRa6RVlf1/ijFjM04Y0qsIlbdkfJ84k8s4IdZSRFGexJDuV8k4eZPeWRWQKCwbuHlO9rdNbVsGemRQ==
Received: from BN9PR03CA0480.namprd03.prod.outlook.com (2603:10b6:408:139::35)
 by LV8PR12MB9081.namprd12.prod.outlook.com (2603:10b6:408:188::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 05:25:22 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:408:139:cafe::27) by BN9PR03CA0480.outlook.office365.com
 (2603:10b6:408:139::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Tue, 22 Oct 2024 05:25:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 05:25:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 21 Oct
 2024 22:25:12 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 21 Oct 2024 22:25:12 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 21 Oct 2024 22:25:11 -0700
Date: Mon, 21 Oct 2024 22:25:10 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <joro@8bytes.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <will@kernel.org>, <alex.williamson@redhat.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Make set_dev_pasid() op
 support replace
Message-ID: <Zxc3NqwiGau+2Ad9@nvidia.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-9-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241018055402.23277-9-yi.l.liu@intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|LV8PR12MB9081:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9aefe0-9301-4d20-81e1-08dcf259ecd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ttc2/7pC8K8dZsfDEX05zbrR6bdFa7m/nimpJRksL7fjRnxNU8oilrOHwW3/?=
 =?us-ascii?Q?6TZYd/EfnMtJPmINDf3DSz6Pdl6YR4WGD5WFhZcjDYROkI/UioW5ds4HoSGq?=
 =?us-ascii?Q?QDaNdFdNPUMPHHibaYlhiBWdPYkdZTQ2FyV57fAPKR73nrEjFvq3Y/fbbFwh?=
 =?us-ascii?Q?K6YY7f3xY9emKtdokZQ8twhCDvK0Cd7+TQPfuuYMcEnufWRf2D/m59DNRscu?=
 =?us-ascii?Q?dnnmMPM7kp8VAA5iBl+ktKtoV065+0RqhTLgb3kROpRsCX5b5IwwWnZKYCwp?=
 =?us-ascii?Q?ITTR+BCTPzT66RSTrouCjLS0nmXLIlZIXUVpW4T61LqZ4w41WJNhHTPvd+vS?=
 =?us-ascii?Q?9HBl8kZJlwPtrWWoiacIbgF6dva9rOkZprNCKzDFEqloadMeIat2NtWzuYGo?=
 =?us-ascii?Q?fvq/G6TLGoimc2jL6Nkfm8Jw2jvX407ThX5ge++ds9C0hfDiAiN378CnoJrj?=
 =?us-ascii?Q?BT+fWSCpkV8DDGT865zV5eesaefLsJAmspDHYT6hccOnnis8T6ZJef7tSB5Z?=
 =?us-ascii?Q?imjJO8AogDvra5JJ5MfNAHNhCtMbzUl2hJ+jQGBFQJfIuhAQeSx3wwR1GhPE?=
 =?us-ascii?Q?OxCE8EwtccTMb+t7FjU0sxM1nE7nMlC8SyO+2n729WJo1heDb6sVwXN6kY9N?=
 =?us-ascii?Q?1NLHpeWMi03R8LbtqrbIQYnMRIDZjN0Sh24uLYu6jwd1vYufd7r7+d/e+rDc?=
 =?us-ascii?Q?99D9yIngu49/3qWYTNbQc4bFuZUQT1fzo4gGE2tb01e4u81gMJOQZniTAhd7?=
 =?us-ascii?Q?r/QLBUJ707l4ymwfymLst9QI+yoDmZMTU+wh1Ifn+vtpw7GrxxksRt/K2GHZ?=
 =?us-ascii?Q?KvDo+LaUtbRAxV6FesvQBAXFeCiDsNJ1x1o8ONkUBeYdWFuu9m8G15VFHAvU?=
 =?us-ascii?Q?tZhDPGa3Z00A9Dgxe2ELw6fYlV2qiq8kekfgs4t9ExRaBNdhpbZ2PO/UKJ8Y?=
 =?us-ascii?Q?HqX0TEIgUOL+Mna3UqjONNlZmi1zeiilQCnsld56G0y32PASJjGLx7hyPh/A?=
 =?us-ascii?Q?6bJDFDdGYUOp7AKIwD6N/foeJKXW5087ttOCNJFuWJbXX0xoQRtAtxgZl1Nw?=
 =?us-ascii?Q?J7Or5cGrrhPtJByPoMNsVEiXNqLFsz0CwRxta5KT1ToSCVuMInz46iKviD6q?=
 =?us-ascii?Q?Buf/yUIRHDH7h9DqtoxmZDPKChqgLtHVPxxgRnXa0jML/IwTCu8wSQAtjQ7y?=
 =?us-ascii?Q?zcOMVjHE37YBfmr+SK3+UJpY/H6SxovbM1RgZGCNkEdjJUd5CMiWQc02FCvU?=
 =?us-ascii?Q?p8Y0+WTfqPyMxZrmuZVQJhFRsep8dG5ykiO5c1GMCl4LDyYKdqBTPqr3TwhY?=
 =?us-ascii?Q?YhmwlBYTq8VSQLrJofAwjqC+VnjiNiSsA8NsQc3hIGPOOluQlk7etNUO3B69?=
 =?us-ascii?Q?8dE3BDz5dkTVXnGEg7xQh13Kia32fuWPD543HN/Bf9/ylU4qQQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 05:25:21.7500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9aefe0-9301-4d20-81e1-08dcf259ecd3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9081

On Thu, Oct 17, 2024 at 10:54:01PM -0700, Yi Liu wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> set_dev_pasid() op is going to be enhanced to support domain replacement
> of a pasid. This prepares for this op definition.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With one thing:

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 737c5b882355..f70165f544df 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2856,7 +2856,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  }
> 
>  static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
> -                                     struct device *dev, ioasid_t id)
> +                                    struct device *dev, ioasid_t id,
> +                                    struct iommu_domain *old)

Seems that this should be squashed to PATCH-1. This function is
another set_dev_pasid op for the default domain, while the one
in the PATCH-1 is for sva domains.

Thanks
Nicolin

