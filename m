Return-Path: <kvm+bounces-30124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE309B7101
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 420461F21F3C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AC2156CF;
	Thu, 31 Oct 2024 00:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nyy1lUBC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527BDC133;
	Thu, 31 Oct 2024 00:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334071; cv=fail; b=jUZUSZ3SxK4cYyc1daXh3OGK7Wl/3bFfvbQ/Jf/uKLF3tbLBxFGUXgvQz08+KZnzYr3cqncZKJAeYkru0O2ASGJn2viADKazk2LjePXxF7Ni0EMR01tdCLl8eexz8At6W1/CpF1oB8MTcNR/ZAM7iQUvaHPVLvssUoYXOKjZdl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334071; c=relaxed/simple;
	bh=Pn2Fk3q6lzX72s5tZSTChTATx4uQsjihknsfptwNmuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C6gmDQEEu/U/v9vLNbwC/cCtU8WwTUsnrjed8eP9vR3F3/8ZWoHujkGY8fxGMuleFH+O8YRCinKhaIxT2vvZbnC4Ra5wqf+4HeeTsSMIoazT+1NU0PcbOAt1Bfp1HsxPPT8mHvvPWddPUsdHn0nrTA120cBYHKS35x+SeeqAt1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nyy1lUBC; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k4xNABLiYM9M9akB9PaD7GGJXX5lUte1MXoTjLxt0B6+TX6WPYZmq/Eerac8mxMg9/YHxZS9vaUxOYN23S+uqnpD263VIYD9e24u/DnoKhNLT61Js36U4a55Qw36NphoH12o6PHad2mM5uuGlRJr4gP4weL/c1ujE9CyFdvdBvS1RmChHCT9x59FCy9zhvxm6LBmg802RyrhMehqDUhf1lvVWvpCANZNHbMGl17L2jxPaC9IapYf33NINqSe32z/0IfebKC6qkCTP78RBZoJkqoO4E+9IbhX5LOlRmgBXyqaUXXtLexC/xEGn7fPl/uoVaIGWrkXi/5eBrKIWAIbjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgtrZp0GZD8YXtaMDFMqGui4OwFU+Isy7hBzLd+9vM0=;
 b=NtmfplZy/NK+OtMesu+N1y8j49PgNEM+lCJvytsvCIOpOp0edDUegPax1qK+szbusq2x6N2AZH9IgDgv59v8Pii8M5hNogyjB8qMrB6BBkYc5W2Ygq7cwdApS/IaPANEbjfEglQHQSXH08Nqd5a+Bdt7ntpSdhRuAlEbAe8dVM9fgciJztHSO7rRSlTWbuW3CXlRAk4U46N+ACMCE/rwkQucA1XYi1wiKv0cpumfLURVZeTu+ZF+M0jl324GQNxu4mwU29MpjTLRzgE2lNcoVa7vOqaMU8ynl97w0Qsp1J45wvKBUaBuxDsNUAecI+8OdEt26di3xZJuWSrEI1PEoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgtrZp0GZD8YXtaMDFMqGui4OwFU+Isy7hBzLd+9vM0=;
 b=Nyy1lUBCEic48I1dn6XMMgpb8e0UzlpsM1pNgQz9QF1Uy8odIyLhC4NExs6NrzAy7oQzJfpwykU41Yunuytx3vu2aRCnxsiLU6LfAd/smsvQr/w74Knb8c8YTqF0m8CbH9QD9ji79k34IbcPKuz+jgGHjQafNfyldbE8EdB2mr0GjGtKdHvQsxCqSN4PYPYtePhFff6ng+AO+J+IRsdSYWfdSuIoyoxUDDbXFZlSk+CeH3egDWd8PwXCCbYPxD8FlY/i3b6031SYFc9ROli15u/jWwR+tz5/dWESh2yoA/uvpSUyh8D35w+ccG7PTqL1NM4hdd1kZiuGVEigPhWxkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:58 +0000
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
Subject: [PATCH v4 08/12] iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
Date: Wed, 30 Oct 2024 21:20:52 -0300
Message-ID: <8-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::28) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 2163518a-4ab1-4c06-444d-08dcf941e402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bLfBIZ+V0JjfK0Oodefax4O9FxmkRvcyJtgiaZZNt+rE6qmRxlKFhx3ubHEv?=
 =?us-ascii?Q?KkSCWI+25UnkBuThpo4QkNFJ3U6OwSWGXH7+ip6loAgwJHTR83ygqN6Sxda6?=
 =?us-ascii?Q?ONPz/oUYLHfGXCLZIKkbGEQxfjkSFg5exmQde9336JiFGvwHeGzs+Cu6fgko?=
 =?us-ascii?Q?fYDzfqPziL69K7aObbVwDcBtdusN6HXtgJkxhr4H/+hsFlnK2GFtYKOCv+el?=
 =?us-ascii?Q?WQjCHox2srv3F7KO06oqBAnVXhATuIx8s75liWl2EKmHGEZN4o9AZwHe5vY9?=
 =?us-ascii?Q?ZhNv0tdPI9y861DiCYIg2iwGpNTCzPDcOJqLScPyj8367tkxI4bMW8tkzWWN?=
 =?us-ascii?Q?JIdaKOayvBG0obMTx++T6fRu138l37Ds3Sr4usBt8a54aY/zt4iqQVxuTabV?=
 =?us-ascii?Q?P2c1OFFPGNNOaJibjwz5x0BGVFZxVu1KgEC6IcMSHVMDOp9CFDVQi808XKN/?=
 =?us-ascii?Q?UqWMUioEkdcPaGM7mfp7qfe740KtJXXCMS5ZK9djIN6aqtFk0Q5WzVYagb5Z?=
 =?us-ascii?Q?zSzV36GdLIMvPmBYRJlI80EoCJlnjhd01cE59jtjXwSlZcrHRcKSOwDlY2rM?=
 =?us-ascii?Q?HMxL1SQCBs78O75Pvb7pPXt+MKTVOXnzfohJIdzQtioopm3ibrHTZXfbxR3/?=
 =?us-ascii?Q?8rotjibDwkFK3BV5/oEiH7jY7LNndbPZ1zQmzPTeF5CBo2IrotL6wIvMk89L?=
 =?us-ascii?Q?3OpJ+nxAi98pGf2Z55UsGG7FF0PDQXzhkYBWt4Kshm0QiWVhn/SuCQFX8ZY4?=
 =?us-ascii?Q?+2yeQZWou8PHdQwpLL97GL33QXyGw/2vuevLDW3xcjSJb60BKVHC5iatSpOo?=
 =?us-ascii?Q?tU89i+GqaY8Ect2fD0/ktHxnPcfiXO22szDMWR/a8N5ZP6vVBEvUK630dDr6?=
 =?us-ascii?Q?i3MiVmkE1FKkhiYjNCYmQW1z2G3nsHcnlRrA6wp9lFqf6aitGDXsl4LMlF76?=
 =?us-ascii?Q?i3lx+c6MrezHfMMP4tC2ObP6k19h14a6B3E5x2zICXgsRaI6U5VqVhEktYfl?=
 =?us-ascii?Q?a69YVSEb41gXyUzQc3vQatdUgiGjLdYPXvNVkK3HB16ocmXXrcwdsTXTJo9F?=
 =?us-ascii?Q?2IuzxmlV1Rt0u8/JfjpZnYVYFklxGJHO7G/7blMSMElvE175P+99SkZtz59c?=
 =?us-ascii?Q?j0JUgf8Z2XAV6LgoRZSbT2B5dU94euitVgqO4VKB+hTcmiaEVfm1XpsFDQKm?=
 =?us-ascii?Q?P5mX+ruokGM1BcJxmysYu2a+CI1W01fl9F8EuxyW2Umkmew/CvGjSvLASMkY?=
 =?us-ascii?Q?fnk3mIOT5nPnRj10UOp7hAmaYw2ccjCH31x6wifvWemKNNEs5tva5MEICe0W?=
 =?us-ascii?Q?outKo3hF+l1kRtCY/GK+74wWrvi9Hjs9yD7PqK8cQCzXeW5bm5DF0uMts75x?=
 =?us-ascii?Q?RRyAz3s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/4u/bo3JWd4ng6NGvpuWp1gbKX5koInL6Z/KWS17EpxXMVnEU25NuwuKOOgY?=
 =?us-ascii?Q?Y3pGfyOR/kZ1CBdQUsk/irIJiXJwlxu3SBvrYu43TR4NUBEJPlM4kP8hel67?=
 =?us-ascii?Q?QaZRb90kU/clH2QZl+rlhmPXN0gH0rH2+1Yit+DHRJgdvD2qoGXbvyG3f+vm?=
 =?us-ascii?Q?Hvkz19xt3BZbIh0xLhSWNrgBp5KXYEhf+/EWiIn2p1b0FM7tcjPQS7BuYAdk?=
 =?us-ascii?Q?HomhBjFQZp8V6IID2iKp3RperX/pYdXkFBtmRkTw1eg6W9vYNLH3d5o8GtE3?=
 =?us-ascii?Q?c8+pQvt96gdXRBVajKzKqommzmE/6tzT9u+lQzXijUiWQ4M/2M5mi/akiNT2?=
 =?us-ascii?Q?jUDbt0qY0wdV1T4PggnqsHKQEKxNvArKVmWAcOW2A914IRr8A/EpUkQ0juZp?=
 =?us-ascii?Q?Hiyt0cWoCCaIRB3L5+4R2ORAKLhQJelMpSlz1c5HvkkCJAkYXdLNqkxFBTeD?=
 =?us-ascii?Q?bv1/1dtUKcg7XCdKgEl3upkhH47n/ixbPsehhc5iZef7HUbwZ//6EMmeWxu6?=
 =?us-ascii?Q?N19gEChEUImaJR2rS1oBVX7ESUBxAdb7NAFCH5qmWchtlQo5zZbVLMIRScqL?=
 =?us-ascii?Q?5VjDqvMlA4thxjSGdUcaVeg/OhMpktNX6LwAPqiH48SwYvNvkWHkMRODKnU5?=
 =?us-ascii?Q?6xhLBzJp87xF8afpWlw5x/pkQD0lHe0eSZPY37MWPTPUkuCLvgoYUOnGAWbT?=
 =?us-ascii?Q?38CFVtHJQDcgUS8G/yiAUvT7m00LBhIU0fP0EM6y1rI6Q+BL3QEAVv9Spo9p?=
 =?us-ascii?Q?xsb83AqgNS2zBhtDaTS9OTIPu0OytGx4YZHmoT6/Es1q5ded1oB3/B0tcPqk?=
 =?us-ascii?Q?lxaOkMDAcyZG+GbjRbLm9h0FLoaKpUXRWAcWImTba3lLV2wpdH6dvMzShJEh?=
 =?us-ascii?Q?rSP/oo4TeqRQBq5pHDKQQ/KaGcbm8RHeZ2658VVXsJF4MlGGLGCVSx/bm2/+?=
 =?us-ascii?Q?vN7GBExU5L8o0ZO2Y81ADN7b4nyHfhW+oUvKk2gjCNdy7HTztD0iJyLZDhfq?=
 =?us-ascii?Q?6tUap7M0sNwMG4x+W73Mi6jD5n3ZZrpOqlZoDAa27JGSzvyvNZ4U6y2p6rAu?=
 =?us-ascii?Q?bLs8TVu+cReV93Tv7AUMtBFFiq6Xl7aN+6v/2+i0TRLQ4CMCtig9lOEj8lyU?=
 =?us-ascii?Q?CC6sSDPhJTUgfz+0knsWKQ2UF6qxSVd7N+R7LpB9Gi06JXXBoIgcIWLHd4b7?=
 =?us-ascii?Q?80+2kqCLiJ2a6iTdDrSgSObEa4uuHgvr5OGqj90CAJr8pZGiwAHRxx1uAGKO?=
 =?us-ascii?Q?ARJEXY+NpPFvuWaoqAnqvKxx6sStjKZMjyKZcrMOVF/CYz4VkA66oIrRusdI?=
 =?us-ascii?Q?REAkpqlbgzJIG9YlirN7w8K8niuGg7OGcMUmK6CAt/nz345Uf06Vwu9AxmUq?=
 =?us-ascii?Q?myzUH+94hOYFIhRPSieJfrLIMBtESmi5JKO3sJWNFuUASKywriUmKGClA/Lk?=
 =?us-ascii?Q?6BSNF4MVYMVFaecFB9Os5G1gqos0x7hnsDqkmzWX6WYNip6o/BvQFjhy7SKl?=
 =?us-ascii?Q?+BRo+SFvZ0JteezWWYTRcPg1Qi9UDouiGnhLNeqf9ZMNlIfrl60R96iveMws?=
 =?us-ascii?Q?ujuu0e9qEm0Td7RUy1g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2163518a-4ab1-4c06-444d-08dcf941e402
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8yttwODnMWc4tz6Fu2Rda7svi4LuNhtqeOtDcOtw08rP6V2xv7vxZ3yv5fq7N6z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

From: Nicolin Chen <nicolinc@nvidia.com>

Add a new driver-type for ARM SMMUv3 to enum iommu_viommu_type. Implement
an arm_vsmmu_alloc().

As an initial step, copy the VMID from s2_parent. A followup series is
required to give the VIOMMU object it's own VMID that will be used in all
nesting configurations.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 45 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 13 ++++++
 include/uapi/linux/iommufd.h                  |  4 ++
 4 files changed, 63 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 3d2671031c9bb5..60dd9e90759571 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -29,3 +29,48 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
 
 	return info;
 }
+
+static const struct iommufd_viommu_ops arm_vsmmu_ops = {
+};
+
+struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
+				       struct iommu_domain *parent,
+				       struct iommufd_ctx *ictx,
+				       unsigned int viommu_type)
+{
+	struct arm_smmu_device *smmu =
+		iommu_get_iommu_dev(dev, struct arm_smmu_device, iommu);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent);
+	struct arm_vsmmu *vsmmu;
+
+	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (s2_parent->smmu != master->smmu)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance. canwbs
+	 * indicates the device is fully coherent and no cache maintenance is
+	 * ever required, even for PCI No-Snoop.
+	 */
+	if (!arm_smmu_master_canwbs(master))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
+				     &arm_vsmmu_ops);
+	if (IS_ERR(vsmmu))
+		return ERR_CAST(vsmmu);
+
+	vsmmu->smmu = smmu;
+	vsmmu->s2_parent = s2_parent;
+	/* FIXME Move VMID allocation from the S2 domain allocation to here */
+	vsmmu->vmid = s2_parent->s2_cfg.vmid;
+
+	return &vsmmu->core;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b4b03206afbf48..c425fb923eb3de 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3517,6 +3517,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.dev_disable_feat	= arm_smmu_dev_disable_feature,
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
+	.viommu_alloc		= arm_vsmmu_alloc,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c9e5290e995a64..3b8013afcec0de 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -10,6 +10,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/iommu.h>
+#include <linux/iommufd.h>
 #include <linux/kernel.h>
 #include <linux/mmzone.h>
 #include <linux/sizes.h>
@@ -976,10 +977,22 @@ tegra241_cmdqv_probe(struct arm_smmu_device *smmu)
 }
 #endif /* CONFIG_TEGRA241_CMDQV */
 
+struct arm_vsmmu {
+	struct iommufd_viommu core;
+	struct arm_smmu_device *smmu;
+	struct arm_smmu_domain *s2_parent;
+	u16 vmid;
+};
+
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
+				       struct iommu_domain *parent,
+				       struct iommufd_ctx *ictx,
+				       unsigned int viommu_type);
 #else
 #define arm_smmu_hw_info NULL
+#define arm_vsmmu_alloc NULL
 #endif /* CONFIG_ARM_SMMU_V3_IOMMUFD */
 
 #endif /* _ARM_SMMU_V3_H */
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b227ac16333fe1..27c5117db985b2 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -400,10 +400,12 @@ struct iommu_hwpt_vtd_s1 {
  * enum iommu_hwpt_data_type - IOMMU HWPT Data Type
  * @IOMMU_HWPT_DATA_NONE: no data
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
+ * @IOMMU_HWPT_DATA_ARM_SMMUV3: ARM SMMUv3 Context Descriptor Table
  */
 enum iommu_hwpt_data_type {
 	IOMMU_HWPT_DATA_NONE = 0,
 	IOMMU_HWPT_DATA_VTD_S1 = 1,
+	IOMMU_HWPT_DATA_ARM_SMMUV3 = 2,
 };
 
 /**
@@ -843,9 +845,11 @@ struct iommu_fault_alloc {
 /**
  * enum iommu_viommu_type - Virtual IOMMU Type
  * @IOMMU_VIOMMU_TYPE_DEFAULT: Reserved for future use
+ * @IOMMU_VIOMMU_TYPE_ARM_SMMUV3: ARM SMMUv3 driver specific type
  */
 enum iommu_viommu_type {
 	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
+	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
 };
 
 /**
-- 
2.43.0


