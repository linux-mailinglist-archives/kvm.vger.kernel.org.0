Return-Path: <kvm+bounces-28286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CD2997183
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E00EB28318F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B151E285B;
	Wed,  9 Oct 2024 16:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N1LftJdH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DB31E284A;
	Wed,  9 Oct 2024 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491022; cv=fail; b=FoZB774xCFXl8cm/eKkj4PIdVDqriCT3avPjd6uUo57tMMZBQB4nV0MOpVzpLHvR2WcFNWPPOqKJvJwvXYoLjdxlOhxCEIlTZ+f/JKuIu2TLD/aBSNdJcyii2IvGFnOkYSO7DzM0hWdubMCnVFoUnQEQObItQIh5YZ4UWeETV2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491022; c=relaxed/simple;
	bh=W0bDaGzbM2yFHU/wV8ASZR5jFfzSvY1/pjJEzpw9BX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sXSNaVkjBPLgc9oEsHwmoOau7eIrTi2DiSPeL3ffYRaWvbJEJjcp7EMk732KOo/LL3k37FFCrY9jfjC/8cQSDRGa0Y4NBHoAZZzp0GkgdhXyD8k9S3ZvNjGhLh9/g8AHLgN+aETE8z/wJ4QzMNNrqW1JZFQOXY0NMyoW7Tl2sFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N1LftJdH; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4laIYW++xBmB1ZuVYycqqePTaLPdimffuByhiAsmWikmwM7byIIs2XISzFw7NoHEvttPD/sB2I+QFG3KBAsuAy+sGJ6qOKN/FpN81IMX61WDx4takrUA47HYJ6myY4Dl/Nci8AS3TU+j0MF+1Wpfyd9DvwQFPGd3kDGPIXUCQNC4SJwvKcVdA6etovFE99pebFQTHmxqXxudjK05PoaHhCuv06ZFe0fewCCtVDYghMcDGXWcMy6fQh2tHNG/lMj3SqFKjS2VX/sqXJVL/gpmNwh3CaChiYuotfIe/JFx3Cfx1jcLszr03PW/8cDn57l0zoMlA3OvWkAyAiBFj/A4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXoN2/k1t0N48cYu5/juISVNQw8ZQ6RwXIvLr02cO/A=;
 b=t657nu++99pNIW4ZSgnUBSr2Seylg12eEqnaa1C3oTwORaMINo4zBJetZZoSBILvO4KZWGWB7iXwtkzogl2Aeo9WS1WWPcZ3Lwl5WLwzOeoZa6KceCF9nQOWai/43qm31a6yHCHPHQM+gF9rbD8RWtHBbHGhv/F2sMi41z9gPbN0TK6GOWV+Y9qzXKC68CpmZMVAdp3/JR8w9pQICHmy4PH9pFEltfsjr5J0o0Sgzwx+1+LDqc94wPvBIimyarwzYzDnOg+ocyseVs84iOPfgHo0K3Ug01cdQCrZOIoP+JDQRbhN6SrSyyVzGBg7tKqtkAH18Boe5dTAv6MOPBMJyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXoN2/k1t0N48cYu5/juISVNQw8ZQ6RwXIvLr02cO/A=;
 b=N1LftJdHK0xFXrR2z1orUdYQqzBBL8hdZb7gfmEoh9Zdo1qaQ3mNT6JRBgQkBo9LHo+AD7ZfqgUEjGjCNodJTAMwcmFZpKTqJC2suDPuVtrpRY161gha/+657BoZB+pfCl9t01G84Ls4XtWdTZWc9xREPGKiBPFn/sDno16lmfuaHEqw83ziwX5QMoYGHdooFYp/MNELpM2szPi3ZBcA4pQrEuDQl+MsBYBu5DyoDTsUlvwM+eXKyygcTxdJwLlG4atCoaQd4zwCfbiPKtJ4aWwiHpvbMLbM3G4GWLS5qO2NgssSyFLx8tPjsT1Af1ExHZVO2IiqjHsNMB9o61+epw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB8768.namprd12.prod.outlook.com (2603:10b6:8:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 5/9] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
Date: Wed,  9 Oct 2024 13:23:11 -0300
Message-ID: <5-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016413.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:b) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB8768:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f519bf9-ff0f-4af3-392d-08dce87eaf9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n3kjIuG5U3fG/1tiOddWmxjlVbeuxQ4fZSVO1eZQdIZYnQ6pDzHrBx08pWVc?=
 =?us-ascii?Q?+xDmhv2k6ZIjftoDYaqiyhRlYyncmcblZTuww/TNycgB1xf+0VXzB27/LcSH?=
 =?us-ascii?Q?AZd8MTQOT97nsEOLf98Yb6es9HfUjK3mb1IYAe/odLyHFitiOGEyjS4KBiwe?=
 =?us-ascii?Q?bLqb2IfJyAsTb34oireEVKh1TvdsGTT78Zcy5pOrw4TYWTl2LDUmXWJrUvts?=
 =?us-ascii?Q?w94ZFpW+X2qHupqTbK6qG0wUBwTYDkp8mieY91FFg4VQM6HdhFY1XOad5RzO?=
 =?us-ascii?Q?ASjuQVYy24NrHsNyADy6/eWgfjHg2QA66Oem9QIJ+LwFVUFmkBQEGLIKBjBo?=
 =?us-ascii?Q?6+3PuwWhfPGJQSYr610U1WqP9AbTXpK76cY3dcsQ1j3Oqo6rju0hMYUXnY6x?=
 =?us-ascii?Q?JeXdtGS/ZNvG5X7RwH+SyvRjX9+rhtrAscowzCLpKuLo7e9FjSrBV2OKhNrE?=
 =?us-ascii?Q?Cb2PxAuqM7qb94elhNmX0aQev1xjFO28XHMiyM+D4RoKT2fyxXJEar92Rkgz?=
 =?us-ascii?Q?TBVqT+uG8EKBCGAbqeM/VdOWQ+oCUVYSTPvOsmVPht5OQUk+DcBVRBtrojxB?=
 =?us-ascii?Q?At3Rmkwo072FV3o/886u0bVNYP3QB8ULF+67KPdcGKMK5B6YcO2Wi+ihsMT+?=
 =?us-ascii?Q?Q3T8ClhvDtoh9tkZ15OsCDP97wWSbiRfX2GkvLHFbkiQb94AbSbXwL04pqA8?=
 =?us-ascii?Q?u+dJT3JHDZJ/y5gyhgtlLxWB9VebNPoLAQU8xGrzyceV4GFv0gugZh1FFNOL?=
 =?us-ascii?Q?omqlXnJlHGIEq/SxIQp2yXj7bUFX1Jo3htS7mIWAaBO3nQTDwwoATRTkVlAR?=
 =?us-ascii?Q?f2SbEhuT19L4z0WjQzcernoT3V3rOBudn77muV3Ko4ciC1WqJhI9dqHY9tuF?=
 =?us-ascii?Q?doO74ORmssDgf3ZT1Du4vv+/Zi4Mc0NusU/hQ3RQygMgQV+d08O1b7A0OSA4?=
 =?us-ascii?Q?4qGtWYTb5nHja6R/DUCEg4mcUQMMK/3IOUVjW/VqayM6q+VCvpH4M0hg+bEM?=
 =?us-ascii?Q?OTE6NIbe0MuqVMSLdGmnkhLq907G+z/nueJFkfUint1cRnhz80nByjnCZHCZ?=
 =?us-ascii?Q?laQXZFmxV8L1lj+psbXXv09EZV+xkifFpwSkya9GYw7ESHuGyrAYQf4Q99m9?=
 =?us-ascii?Q?tVhcPiW2+3qVrSUDGpb+F8L4vprB/SThSd+eS2Amqr+fzeMuWs/KvLjryaIW?=
 =?us-ascii?Q?L9d7lUY7IqZANXgWEi6lLwdoMf6mcjLu0HG8AgaxBXD+5XeutlywahDd+Rpu?=
 =?us-ascii?Q?bXk8e8JsPf0eyR77PRfRYB8jCjBNtAQR54gfIWfvDmgUp6mIJyOgPfq5cHdG?=
 =?us-ascii?Q?1vWHXGZ79paRWs9gnabwlVdN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Q2mOP1O3J2kZvsjlRE7zdyETcdPtaNs2Cn11wQQsb4eyIwz+lSc+cYrlupu?=
 =?us-ascii?Q?HW5n10xfBqcldF6TRqzRzppdOyDoHa9VnZ6AktGyHSy8pdGL/AtvJaIX4Iir?=
 =?us-ascii?Q?7pKyB1XXjOT0+rnz2gKwGk624eozq/w6QymRc+avguKX3n5zBRewI9A1jEQ3?=
 =?us-ascii?Q?zUetjofD2vh13p880OY6BVqAwCgchWp8WDPzmyfwHQkstEG1G7Pj26dUxGwH?=
 =?us-ascii?Q?2lpJzBk3HUV2Qv3EX9edgCX8Eqx2JOZID0WGKGDrKXw18er2FtbfgfHjypgl?=
 =?us-ascii?Q?TaDsUO/hjby12JfA5dLrEPJdV8Ee2H0y52wDrXuo732EAEqaeXHGq86XS3Ie?=
 =?us-ascii?Q?F9Jqpjbmaggh/2+IooQKeL2obpvcDiWp+Q0PQkcjQZLrNaolwBcdPA0GjFc7?=
 =?us-ascii?Q?lg9LG021akDgUJZf9dQgefoXZC3PSDpeGPOcke+WL1DO/WxnWdFBON/Ke892?=
 =?us-ascii?Q?7QuxLsOtJ+bqGUsuUEBqHeuaSK3Ji0/ND9WnzmWatoC3nTUeW3n1WFubuoj4?=
 =?us-ascii?Q?VpR1zucsGoA7/ojmA9RiEvw3y3m6jAMs7bepEMhH+3NrzSQdjKQevDEM+cYo?=
 =?us-ascii?Q?snfDcWRZaikqVUMuKQOxwEPS8j75ysQibrQ8rkQmPnGK0uc/+hrExBeKvlPP?=
 =?us-ascii?Q?1nU8fEVT0/z+QV1cmU47GECdiuB6wOHnYbpXZr7Ii7BhXCuc4VFfamoM/7Fz?=
 =?us-ascii?Q?xkgd1WIHEDmsHvLmYv4MvPiNVf8CEHl6IyEGUO8RRfy1Hwepj/mUlFWVNc+b?=
 =?us-ascii?Q?7+3IOF8nio/eWHC9n3mkCFAHtqwgf0cyur5aCvPE5WgbeikMuYdc5v/V8j5X?=
 =?us-ascii?Q?oDAaL0KV53y48+zoS7Y6M9fq7z2jiUl5hhaRHD00w4z7dQ6pXMcB33AjHBh8?=
 =?us-ascii?Q?4bdil7x/mRpkbje623aJTo8MQONlOCPIvlCdP4z/ZLgqZI9AXnWGZqAqXiDo?=
 =?us-ascii?Q?95ySfrbOJsDCKRzm78FAr5wLRc0ztrbVljizKnym37PNJAQ2lZrvgtwXLOsS?=
 =?us-ascii?Q?t2GBiGCYqm+6VXpX9vrxCJC4EUeN+uLhFj/Yo/l4dect5ZmSOyUpggpTJCGO?=
 =?us-ascii?Q?m+/1tZhsX4nxjEpgX3rSu+LxUjlCosa3Tf0Sn1DcaT4UWIWQutERXRFCIuPQ?=
 =?us-ascii?Q?fe1EDeiSeh9XmJJajWpTuu6z9S0P547Nxx9KE1bsXojn/adVFnsr5Il7KimU?=
 =?us-ascii?Q?GjJWPTJEnwBSYAGlfQSP0MuKMyM7FULz4gdBM9xwuHov3GLd4zYwMiQSnfNF?=
 =?us-ascii?Q?7LipgtOqK1MGMKHJICsA751bWFsRohrGHbyx479gsUdg5vV4zKP5opytdZeQ?=
 =?us-ascii?Q?Bxw7qiyQhwTFQLTgpcgpJhQ9Vvixrz5qAO2Qyb+tni8+/9Im+ZUzzxQg84B3?=
 =?us-ascii?Q?uaHA29y17B8wuBkvAGsm1gIvRYcoW6qDK/FUGC2PzNiKYmulIjczkrxEYWje?=
 =?us-ascii?Q?FVd/Gx64ve7qzzPLbHZZD3wzKgUeFy+ZJ+hNOQ1lSRMH+RHTJ+MlyNhoBYHy?=
 =?us-ascii?Q?Z36JBcUMdMgysVMZjjwtXVCVBwwR+2kVSAP/ceGxzlCDEW5KQE07RkGKa65m?=
 =?us-ascii?Q?zparTNJJJ9YmGyHm+3M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f519bf9-ff0f-4af3-392d-08dce87eaf9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:19.1540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zSpb3VB8aJ9YYsKUiAu4pXTbBV6w+NyEBRpqSdR4TXXQpWlAH1cGYOljTAB8Aun
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8768

From: Nicolin Chen <nicolinc@nvidia.com>

For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
instance need to be available to the VMM so it can construct an
appropriate vSMMUv3 that reflects the correct HW capabilities.

For userspace page tables these values are required to constrain the valid
values within the CD table and the IOPTEs.

The kernel does not sanitize these values. If building a VMM then
userspace is required to only forward bits into a VM that it knows it can
implement. Some bits will also require a VMM to detect if appropriate
kernel support is available such as for ATS and BTM.

Start a new file and kconfig for the advanced iommufd support. This lets
it be compiled out for kernels that are not intended to support
virtualization, and allows distros to leave it disabled until they are
shipping a matching qemu too.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Kconfig                         |  9 +++++
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 31 ++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++++
 include/uapi/linux/iommufd.h                  | 35 +++++++++++++++++++
 6 files changed, 86 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b3aa1f5d53218b..0c9bceb1653d5f 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -415,6 +415,15 @@ config ARM_SMMU_V3_SVA
 	  Say Y here if your system supports SVA extensions such as PCIe PASID
 	  and PRI.
 
+config ARM_SMMU_V3_IOMMUFD
+	bool "Enable IOMMUFD features for ARM SMMUv3 (EXPERIMENTAL)"
+	depends on IOMMUFD
+	help
+	  Support for IOMMUFD features intended to support virtual machines
+	  with accelerated virtual IOMMUs.
+
+	  Say Y here if you are doing development and testing on this feature.
+
 config ARM_SMMU_V3_KUNIT_TEST
 	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index dc98c88b48c827..493a659cc66bb2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-y := arm-smmu-v3.o
+arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
new file mode 100644
index 00000000000000..3d2671031c9bb5
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+
+#include <uapi/linux/iommufd.h>
+
+#include "arm-smmu-v3.h"
+
+void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_hw_info_arm_smmuv3 *info;
+	u32 __iomem *base_idr;
+	unsigned int i;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	base_idr = master->smmu->base + ARM_SMMU_IDR0;
+	for (i = 0; i <= 5; i++)
+		info->idr[i] = readl_relaxed(base_idr + i);
+	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
+	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
+
+	*length = sizeof(*info);
+	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
+
+	return info;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 38725810c14eeb..996774d461aea2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3506,6 +3506,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
+	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.domain_alloc_user	= arm_smmu_domain_alloc_user,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 06e3d88932df12..66261fd5bfb2d2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -81,6 +81,8 @@ struct arm_smmu_device;
 #define IIDR_REVISION			GENMASK(15, 12)
 #define IIDR_IMPLEMENTER		GENMASK(11, 0)
 
+#define ARM_SMMU_AIDR			0x1C
+
 #define ARM_SMMU_CR0			0x20
 #define CR0_ATSCHK			(1 << 4)
 #define CR0_CMDQEN			(1 << 3)
@@ -956,4 +958,11 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 	return ERR_PTR(-ENODEV);
 }
 #endif /* CONFIG_TEGRA241_CMDQV */
+
+#if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
+void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+#else
+#define arm_smmu_hw_info NULL
+#endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
+
 #endif /* _ARM_SMMU_V3_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 72010f71c5e479..b5c94fecb94ca5 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -484,15 +484,50 @@ struct iommu_hw_info_vtd {
 	__aligned_u64 ecap_reg;
 };
 
+/**
+ * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
+ *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
+ *
+ * @flags: Must be set to 0
+ * @__reserved: Must be 0
+ * @idr: Implemented features for ARM SMMU Non-secure programming interface
+ * @iidr: Information about the implementation and implementer of ARM SMMU,
+ *        and architecture version supported
+ * @aidr: ARM SMMU architecture version
+ *
+ * For the details of @idr, @iidr and @aidr, please refer to the chapters
+ * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
+ *
+ * User space should read the underlying ARM SMMUv3 hardware information for
+ * the list of supported features.
+ *
+ * Note that these values reflect the raw HW capability, without any insight if
+ * any required kernel driver support is present. Bits may be set indicating the
+ * HW has functionality that is lacking kernel software support, such as BTM. If
+ * a VMM is using this information to construct emulated copies of these
+ * registers it should only forward bits that it knows it can support.
+ *
+ * In future, presence of required kernel support will be indicated in flags.
+ */
+struct iommu_hw_info_arm_smmuv3 {
+	__u32 flags;
+	__u32 __reserved;
+	__u32 idr[6];
+	__u32 iidr;
+	__u32 aidr;
+};
+
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
  *                           info
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
+ * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE = 0,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
+	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.2


