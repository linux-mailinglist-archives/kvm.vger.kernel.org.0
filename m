Return-Path: <kvm+bounces-30127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B68B89B7107
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34033B21835
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7885E42A9D;
	Thu, 31 Oct 2024 00:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mxTpaVCQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA24C1DA32;
	Thu, 31 Oct 2024 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334074; cv=fail; b=dR74RmiWt6P4VeJMJplhVpCI/CuW7Ld5pC0t3+0Ebe9J/HBGa2f9CZe3wDHdgnHsGq8GJoXUKSSCpqV2BwBuc6HQZ9Hnr40y0MT0oI/CV9vZfxbrY0p6gRZnZz6/IT+dIfcoomeGyegAc51aOndMvcqlGHwgmQK/Y9cbdW8xiVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334074; c=relaxed/simple;
	bh=4gnVYg0A50ewjHLsVmVpLCJH5jqeQzLZuw5gxfHHa6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SB09lEtYRGkboDufFdQkpmYjA1320Am61YZUggqNgRg0C2aKdXkEiwjX6rESq2UUxmla3pk2YU195FlOYkpVl6SP9J31t8Xdye0gEvwEPg9VtwPPEVM32ciOC8sQzc25ZlfmhJAVlncfuzKtJab8CHGPTu8czU7Ez9bQU8QJLIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mxTpaVCQ; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l7coIbGxOpfZYyDaXGB8roXiMofuxrutgvi+E4huCNzNHRg6s3TtKAwOd6/KuVnyxuvDDyFJ+7yOW4PLjKFi5TYtyNBhlo0AZ3df0R/zOmqSKN2M/6ClCjOP22hPZ8Crhd6yULErdZ48JpQT22HNF2wVX+Qw3ln21RQqKFl6kRdIipMn2QQbiPT8e1wt8rE2r3Fa9XKvaXvcCEH74imMQ0oNmjpzZsDQbcgqLpwMU4iRhh3ORAaUohj8gED5cS4AyueI1Vak4EB86Ffjau4C2ln5wbdUR0non2E+1dusZzqlFhCSPedvwrpx+DuTExFr8hTvEUIXJ4+DHqx4rmObew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEirjwDWpVAo/uB4HBcpYrUlvEoqnTQaJ16GVCbR8aw=;
 b=cOVrgEPi06esqPDmv9c/GEQi9y5ImGM9eLxEo9GSTlCmib+dgOs9o/N6GBJLR4WNHZh7Er3YTxiPl7sfcnyFdZal1GDPJiXuqeA5blM26XfbFUojECtB6oegYtmMZAWE+lyqtUvA5s7K+7NjVeICwJpF/boQEsdK4X1q0MbSS+C6ZHuXL7Ca6r7OrlXziwRzOfOFZXF3jngngxtFUm2LkW+Fp2MK0Uo/5QSAn/GNDAyp4bkaHDigwDka5CeVHTxe14zrWTo4A17T7czleY3Ao0/phRHCeRFOWDp54Z04q1pWgSD/le1QOz0HFicDhNCtfL8DZSFM/G4jjJal0T6iQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEirjwDWpVAo/uB4HBcpYrUlvEoqnTQaJ16GVCbR8aw=;
 b=mxTpaVCQSdok+ec++OgmWeLf68Dp3dArIbsPD1R4ahCCMcZH/LU55SggsqnqY0easCRCy7N/DoJ/iKOepEXL7bSQzJmlwd+sqGQW9KzefVPMGh3XX19pdGfqyGP1BA555WSCCj5rWk5+wDbmXkgY5rmdzHfNSIbP37CyIjHwfZmSVmv9HIrIcuaodAvpDj6D1Js7GdSl0ffdBPD+O4gxjg0MTz3mzSLFMpnAVJOoTtX7yWn/wB2qQMi1olj9602y1rOk4p2Jwb3z0A68mF4CgrnRNLhLTLafGGc331uEFKTg6B4e7aj5PX1+2Qne002GurRzt29FYXu7f8pGXPTb/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:59 +0000
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
Subject: [PATCH v4 09/12] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Date: Wed, 30 Oct 2024 21:20:53 -0300
Message-ID: <9-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b96003-75de-42bf-cff9-08dcf941e401
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KECJ3rE2fVNiq0f4HNcDYgWQOa6xim8dwakBcfonvyyfkNdhCdbhzK4GocSw?=
 =?us-ascii?Q?vTJ5V6X1pU8n0w+MKDLtilhPj++7dKI3dXpLc1eEKzL95MOVheBQ4RkRHuHK?=
 =?us-ascii?Q?GodPqwtogINlTaz3PxembAsADl0Gla/03MDqMDGoh+D4LS1r+Hm8hEPwTB8G?=
 =?us-ascii?Q?7UGk4rxI3eA3bRn/li4+B/cs5U8+gxWYikmpEV7CPbbBRrYrgqn04uUywL3C?=
 =?us-ascii?Q?jfny6RuqeDh69hrVX731ESxZd7520WWreenBpuG4fNq5IRet0Y7aYUOWY29O?=
 =?us-ascii?Q?msw/K9DMBhpHFgMzdJ2drJmojxZ3RBN225Ds0xTU0UaMeZM+CslMewwngWmb?=
 =?us-ascii?Q?zTpckV7x+WQ/gj2MOLpPNEhtuxy3MZSWWKztM+1y7VO2/W7pXuQZCidFUseT?=
 =?us-ascii?Q?XUEWCx7SRAfe1q/Hapzy1zsRTBqhljQ6jCGU9A8GsX7RC3n+gOY6kYfUipla?=
 =?us-ascii?Q?tmkWYwcypPG4O3NjVbEja8kC6wdgGf8kqbt//ij/7aKcSehB5rmzkhMk+n67?=
 =?us-ascii?Q?Zd7KRJDUNmXzl2x6hzSxqqQ12ylyxxR5LVjgJIDa6zOTAg7zVF05T77PDrsc?=
 =?us-ascii?Q?ECeJp8QnuQ0uAP4K5wOdX4+aISdm+6DKAxmbiH0oPh+MDMAqRDsPjexUlM1c?=
 =?us-ascii?Q?ApmU/fMhk6j2PVZOcQZK9TfMKc7HieJVy7MKHHysBUoYXf5mKuM9JXTPV/jX?=
 =?us-ascii?Q?4hqfRv74QovQoTMAYZNDjdG6sxPlYNTdQmEU0OvrKg1x8pIaD0PLG80hO5HP?=
 =?us-ascii?Q?9yFOTiag43wpdfxSieqY65n/hVarwjthCCGBmIwaagPVZ7vHntJvTI7weaDx?=
 =?us-ascii?Q?T3O6eyqr/B38u49wzvC2YpFnQ2ZQpYXdA1WGNF5PtsfzmbR7fCDJqmkkNa96?=
 =?us-ascii?Q?hC5ys+y7lUORR3M0IYGbxgpxvJdEW76XVmQWH02HMBBju84Ny72ouAO8JANB?=
 =?us-ascii?Q?AutVPxWCt6yoJQFaGhz67gzfMv62JuVehLYjYI0Y8UlVLOEb572qVrjKGS4U?=
 =?us-ascii?Q?y5hTzawWxCZLOLxT5tehY2H8jQqD0UVo+xHrJ66OhFlsfD9kr24VlwQMmkq4?=
 =?us-ascii?Q?WKBYWHXleHfaXmX+jhleX3WmxSTi3BGNQEakHItM32g04tiXx/iV1KnvDJ35?=
 =?us-ascii?Q?PB3NTJNOsnnyLVE2OzDgEW1htEzA5ul/8fcguGOVHsheeA9Ia71pHRXZwVCa?=
 =?us-ascii?Q?PoNfclLo7O//ba9mw5FUFkTGGXiZ8kemnSdfE7NDdwKUHat4PvCBptOZDHEj?=
 =?us-ascii?Q?+ewiWzNgQKyH3jtIrmxHh5/AT7UL7wXqxPNdGrwwZ9qEEa2YicXNCOipPefJ?=
 =?us-ascii?Q?P4QexK2/KpMKsIwWU3t8gb6WsegTPNTUwVtOeb5VPgX88BhaRID/hfJJQt6/?=
 =?us-ascii?Q?qILCcJ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dRfK25YT9rnyP1orPrzEPz/1tAuc9R43coLhuFYVeH55nrKLk04XDQFBEacq?=
 =?us-ascii?Q?0/Apo1reZ5YDonKGPnROn1sgF4L1qkTCNwO/qEIIfAlRsg/60+IRWcx2eaEl?=
 =?us-ascii?Q?JwFlnov7Dl3PY6i/eKTXbacKZ+4uE94dUj8WnghZMhiBrGzmI5hWv82uXkIO?=
 =?us-ascii?Q?xI/f4JSwOW2PwTbQnSvrThFbI8lE2Rk+LT5fM7ZvzeWvmVRIHILIhlkZTbET?=
 =?us-ascii?Q?ylh3J6G/BrkTusV/9GO/fjhjXXJ0wHRZrmrt/IOkZe4BVnNaEKYT9OSFHwM9?=
 =?us-ascii?Q?Hy5yw4k+Sz3J23Y9k5gxRrK571u3GkWXHTB6cgipOsrc5wUkqeRi+lFuYAeS?=
 =?us-ascii?Q?dW+PeUE5F5Badh4C1onh1w6/XlbS7nZa5Sw0JUYF+MqJS6TBimm9NT/wU37x?=
 =?us-ascii?Q?0q2vMcQMi8+TRiRu2EgptxdyaU+gQ8pXLqVeLWoh6HXsVGKWI6liXSzzGUnV?=
 =?us-ascii?Q?PuhWupm6agVkb/jAoQueeVybisGsETYjmMBXkow/BXM9FyM4SUh0R/78muUQ?=
 =?us-ascii?Q?ed0tUCdFJbRELjbtdPsLyI5Wrch5fbiK8GvHWJluNP1/zchNFtraasGYOkDs?=
 =?us-ascii?Q?Wcv3x8HGQn3hUZ1sbxogFBNucCTMGZ0jkeY9YO47PZZISqK0XU3LX9ZqxHd4?=
 =?us-ascii?Q?U3P/Csw9dW3rmAUBZfJVfBrb6fFLKpSxOHHB4BM8HY5fDPmZFdqSggEy9Fu1?=
 =?us-ascii?Q?yyEIQqEGyu3zJckTN3YDwxzBn6P9BdOcIzX+rvFaoPc6CIxPC4qgZaj4uFwG?=
 =?us-ascii?Q?ZzablaLvdu24T/H1+bxORgmCwI7E6E3M/zWoec6X9yXWVrxC7+NhEKtNpNlv?=
 =?us-ascii?Q?z6PLYw58KP/YmBXE0/w/yIXDVCFSrCWSKFZKGG8Ln5Psi5F4erwb5aOV1Jhd?=
 =?us-ascii?Q?vuTjM8X/pSxi5KvfQmq5+ok+r/gRoXfSHYeGZORSzDbdjCmV0HRtJJvjA2qk?=
 =?us-ascii?Q?mkE+yC0JIuZeOLBZQJQBLE0880Gb2jOTtM/Q4V8Ly/nhFm7xB27h+ZRgry1Q?=
 =?us-ascii?Q?HdnD0zt3PDHAN4GGXQhAa0fX8GGmm+hLurZqsQ0kfAz9t26QCD6JlgV1In0h?=
 =?us-ascii?Q?bneyceGR8qgoyLhpXTOO1QRt1ixWPPqM1kAQ1lmG6lLBD4T9Gzmx5QcGnc2r?=
 =?us-ascii?Q?4Ar/0AYgtwOUr8Cjv8RkQ95/4Bg8lST6DB696QwbHVAECevmfQarJYRTbZ+Y?=
 =?us-ascii?Q?sMypOXBuudltcknxi/4CoooX9+ssiZP5xDgG/Gcu4YFDgPCO5O+Vfk9k8xoy?=
 =?us-ascii?Q?qlW11+7+/Hr9/xCf8zuSPdvpr2v2kEklTV/ekojvRJVFxQ2fij9icpghHBS5?=
 =?us-ascii?Q?rNY6dY0Pr0aaiEp7fFh5yb6UD7Evu8PDGLBP1S13J/x/lKJyA2/Wmm8r6jri?=
 =?us-ascii?Q?UQFZeU3YRmF5OKL9j5vddksKlQ5aSUXKm7qtqcdDgf959wY+4fc2RHPd5NeV?=
 =?us-ascii?Q?MIvaPT1KQweSqrJk7iOPYFAg/FMC/duut8m5TkaI3XGFP23JzeB9RHeRiyzU?=
 =?us-ascii?Q?ldNE7j+bZ5+rmAiXKwJL22/Yt8my9S9efRQYq6C+6AVTR7y3ZurdpRlOE7Bv?=
 =?us-ascii?Q?I6c596xhCcixbVCbN4s=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b96003-75de-42bf-cff9-08dcf941e401
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.5479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNXxoFccfusp84Nf5mkyTqjz/4rGGJiFI5D70KNUIHRuB1XeIbWNvgvKVm0iki0I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
as the parent and a user provided STE fragment that defines the CD table
and related data with addresses translated by the S2 iommu_domain.

The kernel only permits userspace to control certain allowed bits of the
STE that are safe for user/guest control.

IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
translation, but there is no way of knowing which S1 entries refer to a
range of S2.

For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
flush all ASIDs from the VMID after flushing the S2 on any change to the
S2.

The IOMMU_DOMAIN_NESTED can only be created from inside a VIOMMU as the
invalidation path relies on the VIOMMU to translate virtual stream ID used
in the invalidation commands for the CD table and ATS.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 157 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  17 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  26 +++
 include/uapi/linux/iommufd.h                  |  20 +++
 4 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 60dd9e90759571..0b9fffc5b2f09b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -30,7 +30,164 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
 	return info;
 }
 
+static void arm_smmu_make_nested_cd_table_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	arm_smmu_make_s2_domain_ste(
+		target, master, nested_domain->vsmmu->s2_parent, ats_enabled);
+
+	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
+				      FIELD_PREP(STRTAB_STE_0_CFG,
+						 STRTAB_STE_0_CFG_NESTED));
+	target->data[0] |= nested_domain->ste[0] &
+			   ~cpu_to_le64(STRTAB_STE_0_CFG);
+	target->data[1] |= nested_domain->ste[1];
+}
+
+/*
+ * Create a physical STE from the virtual STE that userspace provided when it
+ * created the nested domain. Using the vSTE userspace can request:
+ * - Non-valid STE
+ * - Abort STE
+ * - Bypass STE (install the S2, no CD table)
+ * - CD table STE (install the S2 and the userspace CD table)
+ */
+static void arm_smmu_make_nested_domain_ste(
+	struct arm_smmu_ste *target, struct arm_smmu_master *master,
+	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+{
+	unsigned int cfg =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
+
+	/*
+	 * Userspace can request a non-valid STE through the nesting interface.
+	 * We relay that into an abort physical STE with the intention that
+	 * C_BAD_STE for this SID can be generated to userspace.
+	 */
+	if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
+		cfg = STRTAB_STE_0_CFG_ABORT;
+
+	switch (cfg) {
+	case STRTAB_STE_0_CFG_S1_TRANS:
+		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
+						  ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_BYPASS:
+		arm_smmu_make_s2_domain_ste(target, master,
+					    nested_domain->vsmmu->s2_parent,
+					    ats_enabled);
+		break;
+	case STRTAB_STE_0_CFG_ABORT:
+	default:
+		arm_smmu_make_abort_ste(target);
+		break;
+	}
+}
+
+static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
+				      struct device *dev)
+{
+	struct arm_smmu_nested_domain *nested_domain =
+		to_smmu_nested_domain(domain);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+		.ssid = IOMMU_NO_PASID,
+		/* Currently invalidation of ATC is not supported */
+		.disable_ats = true,
+	};
+	struct arm_smmu_ste ste;
+	int ret;
+
+	if (nested_domain->vsmmu->smmu != master->smmu)
+		return -EINVAL;
+	if (arm_smmu_ssids_in_use(&master->cd_table))
+		return -EBUSY;
+
+	mutex_lock(&arm_smmu_asid_lock);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
+
+	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					state.ats_enabled);
+	arm_smmu_install_ste_for_dev(master, &ste);
+	arm_smmu_attach_commit(&state);
+	mutex_unlock(&arm_smmu_asid_lock);
+	return 0;
+}
+
+static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
+{
+	kfree(to_smmu_nested_domain(domain));
+}
+
+static const struct iommu_domain_ops arm_smmu_nested_ops = {
+	.attach_dev = arm_smmu_attach_dev_nested,
+	.free = arm_smmu_domain_nested_free,
+};
+
+static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
+{
+	unsigned int cfg;
+
+	if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
+		memset(arg->ste, 0, sizeof(arg->ste));
+		return 0;
+	}
+
+	/* EIO is reserved for invalid STE data. */
+	if ((arg->ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
+	    (arg->ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
+		return -EIO;
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
+	if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
+	    cfg != STRTAB_STE_0_CFG_S1_TRANS)
+		return -EIO;
+	return 0;
+}
+
+static struct iommu_domain *
+arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
+			      const struct iommu_user_data *user_data)
+{
+	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+	struct arm_smmu_nested_domain *nested_domain;
+	struct iommu_hwpt_arm_smmuv3 arg;
+	int ret;
+
+	if (flags)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	ret = iommu_copy_struct_from_user(&arg, user_data,
+					  IOMMU_HWPT_DATA_ARM_SMMUV3, ste);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = arm_smmu_validate_vste(&arg);
+	if (ret)
+		return ERR_PTR(ret);
+
+	nested_domain = kzalloc(sizeof(*nested_domain), GFP_KERNEL_ACCOUNT);
+	if (!nested_domain)
+		return ERR_PTR(-ENOMEM);
+
+	nested_domain->domain.type = IOMMU_DOMAIN_NESTED;
+	nested_domain->domain.ops = &arm_smmu_nested_ops;
+	nested_domain->vsmmu = vsmmu;
+	nested_domain->ste[0] = arg.ste[0];
+	nested_domain->ste[1] = arg.ste[1] & ~cpu_to_le64(STRTAB_STE_1_EATS);
+
+	return &nested_domain->domain;
+}
+
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
+	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 };
 
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c425fb923eb3de..53f12b9d78ab21 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -295,6 +295,7 @@ static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 	case CMDQ_OP_TLBI_NH_ASID:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
 		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
 	case CMDQ_OP_TLBI_S12_VMALL:
 		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
 		break;
@@ -2230,6 +2231,15 @@ static void arm_smmu_tlb_inv_range_domain(unsigned long iova, size_t size,
 	}
 	__arm_smmu_tlb_inv_range(&cmd, iova, size, granule, smmu_domain);
 
+	if (smmu_domain->nest_parent) {
+		/*
+		 * When the S2 domain changes all the nested S1 ASIDs have to be
+		 * flushed too.
+		 */
+		cmd.opcode = CMDQ_OP_TLBI_NH_ALL;
+		arm_smmu_cmdq_issue_cmd_with_sync(smmu_domain->smmu, &cmd);
+	}
+
 	/*
 	 * Unfortunately, this can't be leaf-only since we may have
 	 * zapped an entire table.
@@ -2644,6 +2654,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
 	if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
 	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
+	if (domain->type == IOMMU_DOMAIN_NESTED)
+		return to_smmu_nested_domain(domain)->vsmmu->s2_parent;
 	return NULL;
 }
 
@@ -2716,7 +2728,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * enabled if we have arm_smmu_domain, those always have page
 		 * tables.
 		 */
-		state->ats_enabled = arm_smmu_ats_supported(master);
+		state->ats_enabled = !state->disable_ats &&
+				     arm_smmu_ats_supported(master);
 	}
 
 	if (smmu_domain) {
@@ -3122,6 +3135,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+		smmu_domain->nest_parent = true;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
@@ -3518,6 +3532,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
 	.viommu_alloc		= arm_vsmmu_alloc,
+	.user_pasid_table	= 1,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3b8013afcec0de..3fabe187ea7815 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -244,6 +244,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -295,6 +296,15 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 
 #define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
 
+/* These bits can be controlled by userspace for STRTAB_STE_0_CFG_NESTED */
+#define STRTAB_STE_0_NESTING_ALLOWED                                         \
+	cpu_to_le64(STRTAB_STE_0_V | STRTAB_STE_0_CFG | STRTAB_STE_0_S1FMT | \
+		    STRTAB_STE_0_S1CTXPTR_MASK | STRTAB_STE_0_S1CDMAX)
+#define STRTAB_STE_1_NESTING_ALLOWED                            \
+	cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |   \
+		    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |   \
+		    STRTAB_STE_1_S1STALLD)
+
 /*
  * Context descriptors.
  *
@@ -514,6 +524,7 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
+		#define CMDQ_OP_TLBI_NH_ALL     0x10
 		#define CMDQ_OP_TLBI_NH_ASID	0x11
 		#define CMDQ_OP_TLBI_NH_VA	0x12
 		#define CMDQ_OP_TLBI_EL2_ALL	0x20
@@ -815,10 +826,18 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
+	bool				nest_parent : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
 
+struct arm_smmu_nested_domain {
+	struct iommu_domain domain;
+	struct arm_vsmmu *vsmmu;
+
+	__le64 ste[2];
+};
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
@@ -863,6 +882,12 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
+static inline struct arm_smmu_nested_domain *
+to_smmu_nested_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct arm_smmu_nested_domain, domain);
+}
+
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
@@ -909,6 +934,7 @@ struct arm_smmu_attach_state {
 	struct iommu_domain *old_domain;
 	struct arm_smmu_master *master;
 	bool cd_needs_ats;
+	bool disable_ats;
 	ioasid_t ssid;
 	/* Resulting state */
 	bool ats_enabled;
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 27c5117db985b2..47ee35ce050b63 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -396,6 +396,26 @@ struct iommu_hwpt_vtd_s1 {
 	__u32 __reserved;
 };
 
+/**
+ * struct iommu_hwpt_arm_smmuv3 - ARM SMMUv3 nested STE
+ *                                (IOMMU_HWPT_DATA_ARM_SMMUV3)
+ *
+ * @ste: The first two double words of the user space Stream Table Entry for
+ *       the translation. Must be little-endian.
+ *       Allowed fields: (Refer to "5.2 Stream Table Entry" in SMMUv3 HW Spec)
+ *       - word-0: V, Cfg, S1Fmt, S1ContextPtr, S1CDMax
+ *       - word-1: S1DSS, S1CIR, S1COR, S1CSH, S1STALLD
+ *
+ * -EIO will be returned if @ste is not legal or contains any non-allowed field.
+ * Cfg can be used to select a S1, Bypass or Abort configuration. A Bypass
+ * nested domain will translate the same as the nesting parent. The S1 will
+ * install a Context Descriptor Table pointing at userspace memory translated
+ * by the nesting parent.
+ */
+struct iommu_hwpt_arm_smmuv3 {
+	__aligned_le64 ste[2];
+};
+
 /**
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
-- 
2.43.0


