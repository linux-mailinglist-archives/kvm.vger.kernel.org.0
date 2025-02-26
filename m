Return-Path: <kvm+bounces-39395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73429A46C27
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6FF27A6D48
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A36256C78;
	Wed, 26 Feb 2025 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UPSTkNXJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5573319DFB4;
	Wed, 26 Feb 2025 20:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601009; cv=fail; b=d7sppwhhNPzlPttdQfnPNwvi6JA0gfVDV8JRaSRuZbP1KpTyt/Gz7cnV6yYqJA/L4LPfi3U28k8+LqmDgEzlyWhrvS/4Maiwb0x89+rfXDG2sdx5zHELgfMHhnsV+iYUrb6JYYp2B2r098cM/ro9c8026BxWohq9YLjHcxAE/u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601009; c=relaxed/simple;
	bh=O0/CZPKsQe1q+HZGk9hKCKEc8juT3GjQFN+mIasFscM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+8qngPgpo1BE+TBT8ebzzs9RLKOGyDwDYE4qnnZC0DuPBA1CB8ZCLK7GMZRxNLEQZq3/rQ1G3aWADbSdZwJGQcgzgg38uFwGYN7N2zDadSg4muAG5w4rVzyWUqagPefxA60vU9XYONBHguptVGbT0ai/dCrniMe1bbhpZCqfdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UPSTkNXJ; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RFfXpl69pmLZLwLiPIUyc/43XhuA9UewrNtIu4SfHo8HkoWqukb0Kcg/JJhOx/8xN+Pj8MU5oBKDnSYl5gwjaM5eABrVvTYwR/1T1FGleQmiY2taeGW9WqjSIp9gIQKuf95+ajPzyTFyrJ+Q1beOOKkcPF4fSRwCyQCxJl6R8OQFKLklrDMClyX2JXEJsxyBaD6SZI3emFIBVv/0JEO0RIpxwZKC2RfXABWnH8QcfG+FJEM0iozgV083BTTQBDWubVrlMVy5s3GV1GT+eD3ZgYHVxzyjMO2VoBtfPE63mutZ77hSIfHWtzbCtz/PUOKZtyb6FVnTKQKoUDRe0gRPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV8j3AOZezxMWr73G6xKlG4+lB5e6qYPPTfJFAAGcsQ=;
 b=Ae1Wy4NW8odb2vfCGEX8yu7+/NTT5IFXMTL3emMnkNkSi/IIFs9QCscmiGeRJeXKmR6k8ksU6AqYb5nm2jafqaUrpokwgjK3MARtp4Ldg7UxJsJyrwS5gjVPoxr/MtPwctfJQUchBs+B7dSrxV2cQ6LcSCyEj9YIAzqBsjwB2WWuHrhR77fLp3i0qnxqVrFvWu4DUM4f8QywY677TPmvzJoSJ2Tt/CX7NlVZmL+dkWpDYwsiluJ1RCWF+ORSirPw2w1MG7YPfWpBLQ5aZEQKxVXrOAcQ1bd0YW4xwRQ3XNM6Qu3lPb39d2krWnJb3fB2HXtNdaoxmTKRFT1UDXthiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MV8j3AOZezxMWr73G6xKlG4+lB5e6qYPPTfJFAAGcsQ=;
 b=UPSTkNXJHrnP/9Xo6eMsaZ9i918gESV/PefVsTgXNDd4LG2luHy2WtWxwjYFISIP1BEEGHnO89bdzl8SWMmau49gVRpPN21WAWcODcVHeR0q5gHCQU6x+6KirbMRG1EjWBJycC6s4uHZXlBVkvVQfs8WZtaRN5BJX88dF4ZXn47Pw4LSZLHsJMaNOku07HOgqL9DF7w/VROmkp43E9HumEaIn9G07T4trUs3RDmL3byLam9Kn2Ib7xboJVbcDQvfVDfeAaeUkPKnKIy9UuHLnCOS67k055WCHvSFuHpnJiFCfEI5Gc0Y4aOVjLqKpJp6DbHaEbe/clKQOUeDeBbvqg==
Received: from MW4PR03CA0360.namprd03.prod.outlook.com (2603:10b6:303:dc::35)
 by BN5PR12MB9511.namprd12.prod.outlook.com (2603:10b6:408:2a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 20:16:42 +0000
Received: from SJ1PEPF000023D5.namprd21.prod.outlook.com
 (2603:10b6:303:dc:cafe::14) by MW4PR03CA0360.outlook.office365.com
 (2603:10b6:303:dc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.20 via Frontend Transport; Wed,
 26 Feb 2025 20:16:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D5.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Wed, 26 Feb 2025 20:16:41 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Feb
 2025 12:16:28 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 12:16:28 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Feb 2025 12:16:28 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
Date: Wed, 26 Feb 2025 12:16:05 -0800
Message-ID: <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1740600272.git.nicolinc@nvidia.com>
References: <cover.1740600272.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D5:EE_|BN5PR12MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: b5db1c09-5ab9-423b-e6cb-08dd56a27b6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zjeiOxvmpetNorgBnBGm/n2mgX2KtZ6EbslzU8tEaE7kJVzGaItZ+MftDVvv?=
 =?us-ascii?Q?2v9m2Q251kXzb4k4nJd36k6BmZxVdWnnpyTPBM5C/KH6o1YMh83j4AVYd+B3?=
 =?us-ascii?Q?RmebrK+13469SUyxh32zEEqM2YEo/23ZVKR+CWkMwGR/HjQoA/5ttJjVhfE/?=
 =?us-ascii?Q?xyzTfk6yfe1bX2iKy2Ye5KQBW84xEu37Kxu7B9jrgeZ5E0g9f1ehpYCk9UI0?=
 =?us-ascii?Q?Ojmn512uXrGiPTkGURi7LVvk4LqOtP30Y+UwOEGrMwZrCyyfOylau0nj6gA0?=
 =?us-ascii?Q?KcOAAFIOxO622LoJfah98HEaaZmugHlGKAo71D25jcvlAOE9Fgd9wGf2+asH?=
 =?us-ascii?Q?t8uCBg8KdGLfQ5DFxDxBmNxAVsjKpdERuTqMeuJqB8U6nXIy0I5yYE+w8hU6?=
 =?us-ascii?Q?bU0cphR4UZpiRsyWrGjKKlwXRoQVoUTkywT47YJj6H8XrnfWMsMuPSvl+J2a?=
 =?us-ascii?Q?OEEE6aqQPc2d8rpMDGccEX8pvHwEwyA1n/unoXeAoEUYwRrBWQjRF0/92Oj0?=
 =?us-ascii?Q?lFq+vwZaEnfJYPRqK1XN1HWeBNnnbHVeDxVXKTtIhO7D5lybPzISmwEPkPOz?=
 =?us-ascii?Q?RTdx/iowYrDSM3TCzAgtYB6IvQdBm2YeJS0UdWet8vD0QPxK2iz2JbEN2wW+?=
 =?us-ascii?Q?0mpzJhA51ZOYte3T7kgnG7eLwdLM86Kbz/FnKYCX6Tod2fVB0lXJB76ZTQvv?=
 =?us-ascii?Q?GPRJ3KMXBIyUre416Gw7sg8I7PwDsRwK6HlOvUCKL9Ig4oxXc0LDHn5WG78n?=
 =?us-ascii?Q?9ca0s0Lx6urfS5Bm+c6VBgi2xrcflqL8vQcOh9VnMK9G/O0LyI+3hDQxvX7c?=
 =?us-ascii?Q?8PZZV4hnVSsvRCOc4g6eJVYIeJvR2KjGEX8wTXfFA7+pkRUoFtnGRRcop7FT?=
 =?us-ascii?Q?yq4WOHQsOnbOK2EMXAYTvqlYm8w1vbU7T7JqNGHJEsuVU193smsJKY7aWgZP?=
 =?us-ascii?Q?5UwNFRNSmlq3JlmSwndgYMfZIbtPmum69SWCi3yDFH7YdMk4hD2UNpfrIAWA?=
 =?us-ascii?Q?dHYVA4W6pMipC9nBVSAqa1GNAs/BZW221gVZAMH8Wd5O0u3iP8s19mztRN+A?=
 =?us-ascii?Q?GPMViyIa/sutRIaDLuhzyVqZvviW9dDzuwZD0zYAXmZTnDqo4qUPB+9mWRQ1?=
 =?us-ascii?Q?+TtSbuiy12upwOn3hgYJEkWkBKgA2bvPr5D1DLXJ7oWGF3Ihp7+P5ONriRit?=
 =?us-ascii?Q?qpmwV3M5zVVBhOb4P6jE/az38B1UbFd6nGHm64UGlMsMgTgfpYg74Gf4h98f?=
 =?us-ascii?Q?xFQyhLjSvx8yBoUd3pUHsF3EQM1PpeFWzH1KCON4lfUgilrsZIl5j+6k8jYv?=
 =?us-ascii?Q?Tpw7k0Q9LvFIldwjw2PJfT26a39pZsMUFjjJ5Kl6GHuHa/0aSehKfVuOLBjI?=
 =?us-ascii?Q?3fblQ7xQ7nS41UHbc2yxxGsqr7gAvqQ5F2uWsPVcRpL1QXW4E0jBPbZV6UV8?=
 =?us-ascii?Q?h+HikD8Kq7WuNnzKjHpN8Hxb+DpjJMis5DEpwVZW9x01x7iZ8/nFAditz2Cr?=
 =?us-ascii?Q?QY2nXoBXbrZdLUY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 20:16:41.1409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5db1c09-5ab9-423b-e6cb-08dd56a27b6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D5.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9511

The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
default domain, iommu_put_dma_cookie() can be simply added to this helper.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 022bf96a18c5..28cde7007cd7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -456,6 +456,11 @@ static int iommu_init_device(struct device *dev, const struct iommu_ops *ops)
 	return ret;
 }
 
+static void iommu_default_domain_free(struct iommu_domain *domain)
+{
+	iommu_domain_free(domain);
+}
+
 static void iommu_deinit_device(struct device *dev)
 {
 	struct iommu_group *group = dev->iommu_group;
@@ -494,7 +499,7 @@ static void iommu_deinit_device(struct device *dev)
 	 */
 	if (list_empty(&group->devices)) {
 		if (group->default_domain) {
-			iommu_domain_free(group->default_domain);
+			iommu_default_domain_free(group->default_domain);
 			group->default_domain = NULL;
 		}
 		if (group->blocking_domain) {
@@ -3000,7 +3005,7 @@ static int iommu_setup_default_domain(struct iommu_group *group,
 
 out_free_old:
 	if (old_dom)
-		iommu_domain_free(old_dom);
+		iommu_default_domain_free(old_dom);
 	return ret;
 
 err_restore_domain:
@@ -3009,7 +3014,7 @@ static int iommu_setup_default_domain(struct iommu_group *group,
 			group, old_dom, IOMMU_SET_DOMAIN_MUST_SUCCEED);
 err_restore_def_domain:
 	if (old_dom) {
-		iommu_domain_free(dom);
+		iommu_default_domain_free(dom);
 		group->default_domain = old_dom;
 	}
 	return ret;
-- 
2.43.0


