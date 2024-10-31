Return-Path: <kvm+bounces-30133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1624A9B7113
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34FCE1C20FA2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A5AC8FE;
	Thu, 31 Oct 2024 00:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dOQNqpyZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBA7441A;
	Thu, 31 Oct 2024 00:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334082; cv=fail; b=RDNVeKAwiS5/BfbJxWRuY8fFW/HET78Qr+rBSpTmcXWDPcMfGqY9kXqzRGdQklRS1IyBIhhlGbq6Ts6dexhUXQ1C2gCuxw9WzGaCEgit84CaHgztiI0CAQw2Nt5hu8JolRKz05TXglkGPmcmOc7R9mbtOoD7oDb5jXG0dE1nmg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334082; c=relaxed/simple;
	bh=T8L6FzTN1sBIL9CIAJEAH7FcUZaYLgLcHnf6pgR8qxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MrDIkX219aNUS+OR5jIbBt0VyecyZn3z7LXh0RKW4B0J8JScbuoCpvxzxkUyixmj+WnEQ8l7F1TeoPp8US2OnbXovXozXaEke+XCFt05yAUJPs7dFr8PoQm2stJKO0DRxFfQjvcYNobIQhbBrKQm73tNdBitm/wKOWCp2tvfJo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dOQNqpyZ; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CTU8974aMn81PX2VgHpM0cXNouuePCiU3RGtfbtcOYs32xxI9J/TMfPMHrrgIgD+06lyXkSlQtiumKX1pDyKe3MPFiNfyGSobqCmAJbpR8k5A/AmX8tMbky1Hf4+cMbflf8sDoMwZEq2D6ZivbJs35nnSsfuWen7m7mBpcChcgTeULgTo94Op1kcrspML+KRZ3v57uNfdnK5I/NHi/kW+QJWJjf8hiLmkHVwfLkChOpJxlUYx0iyXfAieGmTZwJWmCEFROLn7dEQnKZtoPVTPAYmLgMqslJltxdvcWWv3aoq82Xe7+oa1Ik1XnVbzL7/TedCWwPy8izXEk8xHAFowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2PmPffYHJLvXuaE01mfAk9vOm8/Ayk+w3Px5GX9drI=;
 b=PC+bUC4PCK4Gkz8KLztWWX/F8xdKZx5npaW4hZm5IExKt3Qw8srFMLgknB9oxi5+hohd+CN/0GimB0tn7vIlcXyrgB4sfXoMI7wLSVCfnvI7buvvqJGJ7f7th52Q+xgBSakrhvCBVrs3iGTVKOJNGOKtxJg7bA8eBxyllSc1FICGgVr8/AZKPQjUncqu6c4db1xcW4RhYmBKuWRY/dYm+5jg/gkAtBbyxjvt3i7fvBaYg3kcTcXoBNT4wEXsjhVvKmAcUzO8ieeQvFOTkVWG+NjQ/opgt8E3hFpXRbwXReDbnhh6aEFRyFmAAiSClLVyIOegKGAPVvh1O8mtkSjEpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2PmPffYHJLvXuaE01mfAk9vOm8/Ayk+w3Px5GX9drI=;
 b=dOQNqpyZDkVcIKtOTa/d6dhpAnoyz3vYIFZz6eA9c9Zq+dpu9R3fVsig2JJIVLTWsNUtqQRp/nj2gKW7BRAqbX7gIn7EdL+xveTmTzX2WqEHt074EIgEuKhJ2oVo3VzWK21ZDL3QHC7X1AgyzWySJegexM2N2+g86YxHJlytORkKvfZPb9pHfTXjOgsTvr7T5Dyj9TZLH0tva0lJ5KMC6lXYzQm2cBByxuZGhEhNgj90KcXS+0j4tDfwKrXqixOvWRTszbZdaJ0Qp6xYkYHC/ncKhGtM6m/0Z1oW2PcpU0cbKY28vkWI37xHr52bEM6uQwnr1nlQNEh+pJi4d6tcEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:21:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:21:02 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 07/12] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
Date: Wed, 30 Oct 2024 21:20:51 -0300
Message-ID: <7-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 356e8918-9817-44c1-0aae-08dcf941e4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EdUtHnnjOj4XsU0qXOwUdqnwbzURYClAABOvdWB6h+hj4YCUz34SScp1eVYK?=
 =?us-ascii?Q?FyfOH1D8Jp5M6vxgS541P9aS6QR2v7v7mmqvx4Ypk+9+23X8Xo00ni78HD/R?=
 =?us-ascii?Q?rQk16qAiXy7kcBJAZDaC23qz4oQvbC3NjG9DAHZ5MdvkbU+BjxOOWsAHjOXS?=
 =?us-ascii?Q?QcTh+waXVjawISP6BPN2djxK6pLUwPZxn42RPOeaGKsqnLapnpY2+xcWE8Cf?=
 =?us-ascii?Q?NuGnN2GJTPFcVo3LNCze27/SaCVXzQhaW7j2JMRF6wjWihcmmplKA6lHCPrv?=
 =?us-ascii?Q?X+EwhKpiAhZ34/npSkLRA7iT31fHercBtuKKyRneCwinQIySDInqX/9GssK3?=
 =?us-ascii?Q?OfFbGqPT4h92rGryaz8vnf2o9CStPShcCsyD29OgNCSwy/8EY3xtnF4UI0U4?=
 =?us-ascii?Q?x0BTvlPBTQqtH0GteGKXMtulI8F+AVPpPrtBkeAHosFbQJk0f4iI3ENQpW4e?=
 =?us-ascii?Q?0lFm5DzmBtpkQqu/ArRh421reBrrUbDTc84dR6g5Fki6IS72EJdMD/aPGsQW?=
 =?us-ascii?Q?KEeZ2W/LYP+2vuFTKTO6QOq1MYW7F1f01LcVsZEavamt5EnlD7OOhM7hdehA?=
 =?us-ascii?Q?4U8c57Q3D3b3XeXGIw/S6/fsZR7QGapsm0P1RwZEnvFNdQaX/53apWSz98Ny?=
 =?us-ascii?Q?B9VBUKs3Tq4BChWgEsNHg21VhOg62deqakQhqk8lj9K8VvUZZBKQFtrM72Ed?=
 =?us-ascii?Q?uG2vkRU55JEDPmrdq1h0mISAHHp02TPkTn1zyMnIG8hGKbagKtR2IGQLkoF4?=
 =?us-ascii?Q?ey3tmCrlfaJp09mO0P7p0mjn7nSdzCIixz397Xl2EW9mw7LOiDakahDEQxyB?=
 =?us-ascii?Q?T0MBjzZWRGCfGGBlo/EGd0+TvoKDq3jEIb4fr8JLjEaBTEKHXXgPzDjoTNXR?=
 =?us-ascii?Q?eyafntSDai4Rei4vEFXuqE9tilcPV3ESWTKnAZTJRp4xAmnP7P5+8KaN1ss2?=
 =?us-ascii?Q?lUqFJgABppe7d6MJrRnGIv3M55xau9WgCOdpIhDbMMAzJVlJCuAhA24f55hI?=
 =?us-ascii?Q?Ri8npcGhzrkgv2ZE5N+r7TYOBEPlKrGrfgfQ/dF5c2y94zd/pz7v9TU8EmUu?=
 =?us-ascii?Q?CdE41xq26G3d602RMPZt6lgtjW1VepD4jTKsyZEj9325KtL5J8CZscnl7413?=
 =?us-ascii?Q?4etnY5FJgtBEu8NZU3uUwSZaT9GDLk1tpHQHO3g++kUwc1/v6X64dlBNGhBP?=
 =?us-ascii?Q?q+m8XYn20wxD3julEXNo9SFhjPckt2tYnmDYQpf3HbY5YKfB4wHRULuhRCA+?=
 =?us-ascii?Q?jZgi4/VvVysuZGnhsVouU476ByHjWLVPoDedCByRj+2/qDJ+0Yf14i5DCEQx?=
 =?us-ascii?Q?GMcAQ7hpmM5YJ/0vtlBFMoapSCL7zggGfdMjsSB6EjU6vQClgX287dkC/bww?=
 =?us-ascii?Q?nstdcHQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UGLYeOkybmjTrzN26Om4Z2Pr9XhGPnlnNKdtnmTbsNdv9UPxhfgYvlwiorV9?=
 =?us-ascii?Q?ta0w3pFVeCacLoYtCAYfriQl01AWyreaet/7sl1gA1F7NyCKlG7//YckXpC3?=
 =?us-ascii?Q?Vwtm9tnGbauc3SjfTAYdlVGrhEm8qC4jf/oz+xr+WmNVocOWIJVy7byOQdKC?=
 =?us-ascii?Q?7SHSADA4qB1zv+530dezykY5hS9Ihq86iu0RDN/gO+am0gsQfd3dG8lNsPOq?=
 =?us-ascii?Q?iY48MvZ3te5MkcrLmCGAdmxnndwIQfXEYwHjtcL/+IczI51FdPbL0v5cQvwj?=
 =?us-ascii?Q?0glJGwAQqJYCjbDnaC4itiJKHeteK2NPeZsJ31zOZlQ1kIPKaYvkudJ+B1x/?=
 =?us-ascii?Q?FmLkNba4npjhCW/xcjgWrvSeCrdBtRrpzBa4E6q/FkMhzNX8/WvuVga9zgBU?=
 =?us-ascii?Q?9sPGlQcubI3em22Yx0lQ1u0HjBR0AdhLUDllFOMPe5Z1b331nE9ILUOFvhG1?=
 =?us-ascii?Q?54e1MMr8e5NXBMVtPb6g7yJP9liT5uABkq4i5TN34rCL4w+SInB+ZPw62ubt?=
 =?us-ascii?Q?3Myby1VDhZnr9s6QRy/3r4iTOYlPuJoyBYJukUeIXs9kJ/cKIif4pcL3X1X4?=
 =?us-ascii?Q?T+8oTeP9M0jgC0rWrnqrErAB/JFhTeCRrpFWW7B3xWpYt0j2D4dNbkP4tOjL?=
 =?us-ascii?Q?lzm46oK6P8OP9XUMH6sROjaeVS2HSvdQ4LjErE2hF2vdDc7uyjIGif9PbcGg?=
 =?us-ascii?Q?3hczDgUfTh3wWqfcPXU1c5eqlGQYe1YNOEcKnFP03ZY+KAelFcxl1Ho0cafb?=
 =?us-ascii?Q?FkmUsE9f5RSbHKykYyIH8DTMw5K0+ZrY+/UIcGNVysImApZownL97C8Q7UPC?=
 =?us-ascii?Q?MMXIBy0SxNnUIc3orB8qeFElyPgRK/9oKfCrASAmYnO3j9O8sJUH9OI8juPs?=
 =?us-ascii?Q?hT7/LWmzQh3gMowDVlAvD91NL3nbugKzwtnGrqzTMyC2db/0d0Ydhadf9qXc?=
 =?us-ascii?Q?0QdtG21C2FskzlOdVwfpu5avuDj5uZAqiC0PjXzBum6iJYikyA3A3BrX5Twd?=
 =?us-ascii?Q?LRHE7JX4b3qNb0dpbff/YWEg7f2nTqrXDoY7YdnMwxQqEqKjKHN96jaZTyqs?=
 =?us-ascii?Q?l3kif5P7vppmAgvgIttKU+eDc4NTYPqb50L6o5t2SF08QO4vVW3ebAcmTLiy?=
 =?us-ascii?Q?KlLFutxF3Gjqc3NmEUp2RUfPdfHt37Y3BEXb5cAlAjQGONG9WUv1xT6TQP6K?=
 =?us-ascii?Q?bPFeAjNbt83Yj4ZYxSTBaoH5tpVm4eeiPXBEnDJ2v2JDOMUFK8KEtZ2G961g?=
 =?us-ascii?Q?mcBPXWrrarmygF8dVBqGeR8e0g0GrVKwJFql58Y/9YVtViH3eSgkjZCGRLsD?=
 =?us-ascii?Q?UJZlRJpP6wVOztFazE6wC2Ab9+lSlNT45vVO16Cq40Zdk8wrSRxwSeOwr5AB?=
 =?us-ascii?Q?v9Tgdmy89GQ/oJKmETWVLK01Dcsp5TmchOc3GuUHIrwj8atVVNFRNlDYlvz5?=
 =?us-ascii?Q?lmYsavCbse9eBkJT2/hJJpK2LLNB384UVTCnSGAJ0AxhNQ8eLLyBiG5zPCum?=
 =?us-ascii?Q?k4V7kdFfhGe+2YhvjnEHIH2Dwb+H7IqFSn+6eLMN0u0VefKQxLJcjPK+THQw?=
 =?us-ascii?Q?WYhrRbibgMrF5iNuCAY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356e8918-9817-44c1-0aae-08dcf941e4d5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:58.8560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7lt88V1vlsIskb2wxyCcg7tu9SBkvSpNbTd1N0Ce0B4bBaEWzJJmA9mD65pufcI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

The arm-smmuv3-iommufd.c file will need to call these functions too.
Remove statics and put them in the header file. Remove the kunit
visibility protections from arm_smmu_make_abort_ste() and
arm_smmu_make_s2_domain_ste().

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 ++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++++++++++++----
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 80847fa386fcd2..b4b03206afbf48 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1549,7 +1549,6 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
-VISIBLE_IF_KUNIT
 void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
 {
 	memset(target, 0, sizeof(*target));
@@ -1632,7 +1631,6 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 }
 EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 
-VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
@@ -2505,8 +2503,8 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	}
 }
 
-static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
-					 const struct arm_smmu_ste *target)
+void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+				  const struct arm_smmu_ste *target)
 {
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2671,16 +2669,6 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
-struct arm_smmu_attach_state {
-	/* Inputs */
-	struct iommu_domain *old_domain;
-	struct arm_smmu_master *master;
-	bool cd_needs_ats;
-	ioasid_t ssid;
-	/* Resulting state */
-	bool ats_enabled;
-};
-
 /*
  * Start the sequence to attach a domain to a master. The sequence contains three
  * steps:
@@ -2701,8 +2689,8 @@ struct arm_smmu_attach_state {
  * new_domain can be a non-paging domain. In this case ATS will not be enabled,
  * and invalidations won't be tracked.
  */
-static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
-				   struct iommu_domain *new_domain)
+int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+			    struct iommu_domain *new_domain)
 {
 	struct arm_smmu_master *master = state->master;
 	struct arm_smmu_master_domain *master_domain;
@@ -2784,7 +2772,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
  * completes synchronizing the PCI device's ATC and finishes manipulating the
  * smmu_domain->devices list.
  */
-static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
+void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 {
 	struct arm_smmu_master *master = state->master;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 66261fd5bfb2d2..c9e5290e995a64 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -830,21 +830,22 @@ struct arm_smmu_entry_writer_ops {
 	void (*sync)(struct arm_smmu_entry_writer *writer);
 };
 
+void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
+void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
+				 struct arm_smmu_master *master,
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled);
+
 #if IS_ENABLED(CONFIG_KUNIT)
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
 void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer, __le64 *cur,
 			  const __le64 *target);
 void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits);
-void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			       struct arm_smmu_master *master, bool ats_enabled,
 			       unsigned int s1dss);
-void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
-				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled);
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
@@ -902,6 +903,22 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
 	       IOMMU_FWSPEC_PCI_RC_CANWBS;
 }
 
+struct arm_smmu_attach_state {
+	/* Inputs */
+	struct iommu_domain *old_domain;
+	struct arm_smmu_master *master;
+	bool cd_needs_ats;
+	ioasid_t ssid;
+	/* Resulting state */
+	bool ats_enabled;
+};
+
+int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+			    struct iommu_domain *new_domain);
+void arm_smmu_attach_commit(struct arm_smmu_attach_state *state);
+void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
+				  const struct arm_smmu_ste *target);
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 bool arm_smmu_master_sva_supported(struct arm_smmu_master *master);
-- 
2.43.0


