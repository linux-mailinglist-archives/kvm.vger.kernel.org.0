Return-Path: <kvm+bounces-41509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE3CA69743
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72D148A3115
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28D0209F4D;
	Wed, 19 Mar 2025 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cd9LyKmw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8491F872A
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407111; cv=fail; b=ZoQKFU1em/GKrUHASKRE5Ud/Ua9yLaPofJC68zBElBuBGCNNP9R1GrALKSoouwdydEeNazX1P7xZ3AMr3n0NjwoyG+0cFa6YeWkC6GPzteg54e3GT84JDFDcjmrLY4+mQ2THUiz8DA/EDhJsNDq26ofq50ij9nhWlj94XUgwFDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407111; c=relaxed/simple;
	bh=Gz2tRZkzWiMnslvMSTYS81S9man+BxIUb0+ZJNxcXig=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y71ZjuKvJbgkB2S7ij5vpIIWSCdbZTyzWCMHwXDlMp90ttIwsmFOlQ/JfIQk6NA1qtLfgdVz/IDj9MEFEdrodcpsJnOu61EXDhKQ7m2l886uVSGm11EMEwvbTfJ5k6CmERXUBgGBeVJECw9dQycwfWBc0JSPq2Rsykrus+UGT/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cd9LyKmw; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I6xqohVYOYJQ0UZ7TfkzAWVbeG/O9/3lmmi8gzpRjKgY/TZncDegT28emhgA9PWyzTMhxRbqH0HissJl8kQZhELBly+kemmReE23umnBrGtbdMNfs8ArwPUElH4Cwxv1b4jGUbwDIcI4R2P4+buW91p/EVHGiwaRuvxHb5kbxZvfa7OOisSv9PekS8+HRz4OdEiS96BJa18SR7dhl7lL+HSeA7expVqUZ3kcBA9i7ZiPN2w3TNJtMyVOAJU4z5HqZx1W7NTI5eCZP784pMY27KTIF1MkmsDp3T6TFDjZlwshpqqHqrEhfTpX+5wvNttETNTeg6k/E2xR7jT30lLlLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DR9Kgj4QceZ1hduFFlu5LrxiAiI3ZsNrJEVEjtHHF9s=;
 b=Si+v3MtbmCUPEEvP8sl4/xTKesTQDaWLOIuVFPxiNxhlN+XV+Cl4Q3hTt3+WdulfScyCabczb7bmLd/XVd1sY7j1d9XBaBs6IGrA0g2Ce5zgzUGFMpG/GhCeldLvlDH/c2N3DhhjsbnTuhr5lZtVVujx1ooJi1/ddY0X54wGvkY/zj14WTYq53n+/uaXr8VjrhstiDAR5fgl5wr7p4XRUzLrZ3oTtlZ45EBcDwbPB48Ws8uzRihX3Yf0aKsGi5g2Bra5c38UptUC13n4wkDe4gJ1u11LQGZbBv7Xl4rJn1jagApdtFdXOYXtSwhW36qb4fltfsOczyWNhIsLYS5yIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR9Kgj4QceZ1hduFFlu5LrxiAiI3ZsNrJEVEjtHHF9s=;
 b=cd9LyKmwU+KCgV3IWdgPnl5FjNZ4atZEFjzCPc1iUdKSR8lOa1aP2AySyef3qyMpQtAWw9jH3+PkU70rKvl438QLhsz6Gy34AMdL1tQJjTzmFF7MG2as5z5ZJAIItBGyJefmcDd0kDRrjwCYb7rekhJZI7Q9WJeLTdF0WsB+8S/UFNOj5f+7YeqiriYwkEkGYn1Tcgo1/wUjdEdd06ZxPVNbBg/FnkyCeYVDPAE1SLS/FGwOeRl2ovFCLiPc0iF2UoIPk2gavt6Iq2U7IvhOWrnG8LxifBtnzBjuqGGRLqBOGsWkd0vHZfmB89f/bSZXqKv6YsChCctuzU0defPnOA==
Received: from PH8PR07CA0003.namprd07.prod.outlook.com (2603:10b6:510:2cd::17)
 by DS5PPF6BCF148B6.namprd12.prod.outlook.com (2603:10b6:f:fc00::652) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Wed, 19 Mar
 2025 17:58:25 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:2cd:cafe::4c) by PH8PR07CA0003.outlook.office365.com
 (2603:10b6:510:2cd::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Wed,
 19 Mar 2025 17:58:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 17:58:24 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 10:58:16 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 19 Mar 2025 10:58:16 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 10:58:15 -0700
Date: Wed, 19 Mar 2025 10:58:13 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z9sFteIJ70PicRHB@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313124753.185090-5-yi.l.liu@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|DS5PPF6BCF148B6:EE_
X-MS-Office365-Filtering-Correlation-Id: f5584d45-dfd0-444b-37f3-08dd670fa4ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/D/CvmKmoW8dZ1IbRD+a7YUEswBbFsRTs5aGwVl1HqF0eDDfn3elDqJYMW1m?=
 =?us-ascii?Q?S9YLoAjEmQqNuiy9iuW1dTQWjqcV//dWUY/9x+LtbuHpCE6cyXe274EOlghm?=
 =?us-ascii?Q?w9KdMuN/KKhGAGV3iJFKtbtrN73tGuTf1gubiXO8QgwLaFL/tesH0tVg2WdR?=
 =?us-ascii?Q?3YzDa18JvtGS/+oR1mfUSHkRWpmUT4rKn0OlJT3AoNTPyzjKwJvOlmioOSok?=
 =?us-ascii?Q?2dgVM/XGOzuzvGGpKWpdELGED2ut8C6kIXzrVbT0/8JWpB65QUiSmZFT565G?=
 =?us-ascii?Q?5f28c0O6jXlAQCNT2Mmvjmp44IuFIClDXtE7Y9MUUqeL6d7uGsEyiyOZ9k0O?=
 =?us-ascii?Q?esFRT9Qgj3GRiLF3M8/zSlrfMttIy9b18hcxSupbrllMnlyB6/FYZcL5XBjX?=
 =?us-ascii?Q?eIKb2vqcr3N9CyBlB4LvTmPf7AceLnDwXjniqv5yvDOlKJgnK3sXueIhdnUf?=
 =?us-ascii?Q?lBQVmHcxnEjcXSx60EZIAurgwVBRyEoMXNQXFBu+Wyeb5j3TfVeQIr/lJVaK?=
 =?us-ascii?Q?7EAjFkZ2sW7amJAcOYFmE0j+Tob4DZpvEbZdI6+LlDTkzZ9jddpNgYyBCNgz?=
 =?us-ascii?Q?SfNiz/dWem8lYWMHkI375ak+MnsJPEyNAnJ5PO6m1nvPGi3iHxY7EuEsF2yz?=
 =?us-ascii?Q?gcBdYQ3xki1s8OlAvwrfn0gZPPiwRLrZBfXUWIbtV1Ar7m0zJs2iGAVYuAZS?=
 =?us-ascii?Q?MUNIRrkwUHE0bzpOs4eQUxMz3wzO4SzkRrOEXQi5IXM3MSKNtaHjjotGk13H?=
 =?us-ascii?Q?VbEZmUdiWYg/kjeEFw7FbLNnHVL+N51u9dFvw1nnVORrTfr1WCwU4JWm9Luj?=
 =?us-ascii?Q?Me/HAy71QU3eUWAISU6w1DW0S+t6MrLPyrlwFyZz67i1h38yJjPRF0pt3v0t?=
 =?us-ascii?Q?d2R41OYcMySvVGJupWThZbBY2c3ltP3wdLWfSuS4phR1iGnarg9NXyefZsmo?=
 =?us-ascii?Q?OBlmQmBvsPp6svM4xavvpOSzfz58WZn2nb39JCWsHpOiRTuTMkDYMI+fliLi?=
 =?us-ascii?Q?N62+X9XhPL4KTKgPtHl7SOt8maLOoYP6jG5mpweAqz0meyk9TfCZURQIyp0L?=
 =?us-ascii?Q?oSAPq6nWBHWWaXFrbwf1fnfZe29wKeEQWnuLKrvLkTvpu3OkdDK0/YwDSsxk?=
 =?us-ascii?Q?VmBZDIUgZbaFvOzcPN5EPik0okZxT3bOaX7EaffWgH7sY5kwzvUdXTQFqAPC?=
 =?us-ascii?Q?oT9bKl0CVAwzkIyQbTvWUviDk3sPuXCCoA9/3H0EfO9g8MdRf57JBkv4dsLw?=
 =?us-ascii?Q?w3vxxCxwzbxK/BVdlOcA2VRFpMOpTmq8bxzwVMRYdb4Cq/Q0MLSL27Nwi9l9?=
 =?us-ascii?Q?bKa8eatm+SusWHlwWmKWooRJh020JM98eDRGXHn7FFX4+kgJlplhRhKjOGd8?=
 =?us-ascii?Q?RJO5qJAX4EAKYnCknHMsXDdS+ow2yyp+tjGepyEJ83rcAklaVTeZW1wwxm66?=
 =?us-ascii?Q?gYnuJKMfIsQyxE80ib8x8kiMU+sNm/L6SKc3LALDcvZed7hqLrxJJj6yqvKN?=
 =?us-ascii?Q?MO2YVJwhZzNPAR8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 17:58:24.4539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5584d45-dfd0-444b-37f3-08dd670fa4ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF6BCF148B6

On Thu, Mar 13, 2025 at 05:47:52AM -0700, Yi Liu wrote:
> PASID usage requires PASID support in both device and IOMMU. Since the
> iommu drivers always enable the PASID capability for the device if it
> is supported, this extends the IOMMU_GET_HW_INFO to report the PASID
> capability to userspace. Also, enhances the selftest accordingly.

Overall, I am a bit confused by the out_capabilities field in the
IOMMU_GET_HW_INFO. Why these capabilities cannot be reported via
the driver specific data structure?

E.g. we don't report the "NESTING" capability in out_capabilities
at all and that works fine since the iommu driver would reject if
it doesn't support.

Mind elaborate the reason for these two new capabilities? What is
the benefit from keeping them in the core v.s. driver level?

(sorry for doubting this at such a late stage...)

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org> #aarch64 platform
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 35 +++++++++++++++++++++++++++++++++-
>  drivers/pci/ats.c              | 33 ++++++++++++++++++++++++++++++++
>  include/linux/pci-ats.h        |  3 +++
>  include/uapi/linux/iommufd.h   | 14 +++++++++++++-
>  4 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 70da39f5e227..1f3bec61bcf9 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -3,6 +3,8 @@
>   */
>  #include <linux/iommu.h>
>  #include <linux/iommufd.h>
> +#include <linux/pci.h>
> +#include <linux/pci-ats.h>

"pci-ats" includes "pci.h" already.

Thanks
Nicolin

