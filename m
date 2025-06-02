Return-Path: <kvm+bounces-48184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51770ACBA32
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 228443AAE65
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 17:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAD022541B;
	Mon,  2 Jun 2025 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0rLGLYsh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA051FDD;
	Mon,  2 Jun 2025 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748885078; cv=fail; b=Jf8TLFEkN6+/suup4geWvX4VHMXy/2+8aBk2VuQZA0kykUE3nc1C9mfxAm4g0Jnd0fIs/RA0PqJMx1HJ4FABTyLrLghEBNie3PJcmGPGWfAUbC86rD8HMXKOpxTFconZhyZhqwos8iiJzfTVVukKut6urOPJHC8opwhHK1YCT/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748885078; c=relaxed/simple;
	bh=DRNqqY/4AbwEXk39Qpozbu8P5EAIZabKiLzaa9WA7b4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fgb+qXMjGVDHQnSel2BoP9ERCdD5EqD8oqMBtWAcaNOQnTtQh3n0bUwpfzmDlmvOXokNnyQEDC4IEJGLJoiK3InZY4queCqAZ44qAwKuxHRJo7dlZnizyiEl4EbOPvlQ0Uo25v+bEOmTkgKRD0qRTrQ9l1tQCD0iLgboUsj1+v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0rLGLYsh; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oiKRVJ+qgX7wPALitek08DjdQnMmQlfVnqq6gHbUfrO5M5IWWWo1X+cXXLdBQfwL1fmiOLuebMsDgjB2AwAvbjVujY7bfxaC2NCtaTnp6lD7vELc77MPGAHixj+v7Tj/sQuRPmqysz7B4wdS7dY6tqqMBmqMAVe4oQBwITMdSZwPLOXReaT45K+pcG05K7x11N0bhkW82/sEkenYKuvIYN7YwCJeW0SPcocUm/J6BTK+W5IvLpGXGMFR432IWT5cDs8NeGB0PXHohYiKI/2bPPe6iEyjtDNSxJr8Vi+FLc0o6/MQ0chMHYGcoiwsuzDjmShn94y8JzZjpLP/Fh1csw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BT2T0QlTF8VdJkmgsjHsUXxMZ+xsLLu8f1BG8wh9onM=;
 b=pNazwb8ezWvwQ7gvlE9SsXDobxsRSBOL7k3OHLQHwVafrPLj4y9138Ex6sG0/70szI4Tqth/vhYDKrCvP0HNNbWPIe+5+yg+HqDDHMPTJIOx9cEfwcB8ui0hZLHZdD4lhykRxJ2tKr+DRlh01JkFtiK2jjOeel/zAkCmR7Vf30YxTJo236z+vcd5JbmYkgRJn2r5L19IoA6NpNy+KWIVzWerywd2rTL0tUXx/0kp+rNupRUpBEuUT+i02MeiKBZ8O0+hlIamUOfD1UjSylEwoRloJjdieV5vYs56MstYpQwlpn/CXgT031GT60NV52HjV/54lzw+BJvMF1nmu3q8JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BT2T0QlTF8VdJkmgsjHsUXxMZ+xsLLu8f1BG8wh9onM=;
 b=0rLGLYsh8zpAIsfJTUpnpwzcoeYlWjXtuvMpT20k93xEZsXOL/McJRkVHRsq+lvzj18SawsnT96NnhVuxuI276U39yZwxwqPHD1tfyA1maWYZHU6wcj8GNuc+26sHM9f34H30CrDh+20uVxwjYI0DfA/EeO63sjdWEqn2sukFx8=
Received: from DS7PR03CA0069.namprd03.prod.outlook.com (2603:10b6:5:3bb::14)
 by CY8PR12MB8412.namprd12.prod.outlook.com (2603:10b6:930:6f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Mon, 2 Jun
 2025 17:24:11 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3bb:cafe::fa) by DS7PR03CA0069.outlook.office365.com
 (2603:10b6:5:3bb::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Mon,
 2 Jun 2025 17:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 17:24:11 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 12:24:08 -0500
From: Shivank Garg <shivankg@amd.com>
To: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shivankg@amd.com>, <bharata@amd.com>, <tabba@google.com>,
	<ackerleytng@google.com>
Subject: [PATCH] KVM: guest_memfd: Remove redundant kvm_gmem_getattr implementation
Date: Mon, 2 Jun 2025 17:23:18 +0000
Message-ID: <20250602172317.10601-1-shivankg@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|CY8PR12MB8412:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e46b5c8-88d3-4507-14af-08dda1fa4a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DJSt4GIP9nrbh8XvMHuaOXw+QyRDy+JPvNpH+zvrO2ove7IXXF9vXlYo0e0N?=
 =?us-ascii?Q?Yyv19/T50oOyeWnGetyC6JKLT1eBWPluBx42Bkr7KVH6BS7H9ZmIhbA33BbQ?=
 =?us-ascii?Q?T4W56M29lZcV3RWiPSBsD9Kyb6FAGYvq/X6VVrFlABdzxC99tPyrDJ8Xvjyg?=
 =?us-ascii?Q?EClcqVnmK2pQD+e5ECIJxLRUlC6ob+q9hYG9+wSmAaeH0WVcpD4hwl9VPwHv?=
 =?us-ascii?Q?upt2o9h57lc2d/LiPOdx9l7t0ePWooaUpx6UrZZ4+ZPvEsQYSVyXGr4L4oR+?=
 =?us-ascii?Q?LkjlwE6q6L1C6EbxuTnRF4DoB5UZ+iNV6hTyGfGGsEOP9z8rOqXOgSSARv/O?=
 =?us-ascii?Q?1cFDqyrzRhYt14ucagppzfJaG0BvtWkQ9vHfbVRm31JYgfsyDzcUwGlsndp2?=
 =?us-ascii?Q?FJCx8imPX8YB0WElPHRARXm1hc/UBT+gK5iMmOqayZ6kctWRR1KyVda3U95X?=
 =?us-ascii?Q?QNTyrHCwnf9W4QpsaaVaeFOVUQH/ea1LkZ3M5iJaz/xGJzKNTnBpll3iWtFn?=
 =?us-ascii?Q?nrwnq27ohVfet7Bq9f+/3hougrgndUEy0aDOZjcYo3XS4Y5+nWk0gd8snmkN?=
 =?us-ascii?Q?qdzzi4YPedvpDrC78gis2KvZsJr57zhHPcXt0Qrtc7StDVnVrccqfwXbSSQO?=
 =?us-ascii?Q?z8uHw0iLdH/52ce42imYj32QCr924UZfGGiEso9SSAqx5DWwQx78heAdK3kh?=
 =?us-ascii?Q?ZN6+zNb1etpj6orrsFfO5fpyl+Vw7ED4lijJjIBr5cKdl+gKdEJPRgnhDX2B?=
 =?us-ascii?Q?q+sVUyiv8AzQy8wNwlofIzQh6U5udqnqGpeYbSmwZFbSZXc5WHcv+clla0Kf?=
 =?us-ascii?Q?QtgXgnrp7CZyYZjqti6lv7AD8PKT4oJiWZSCJkd6BpYynr1CvTDkEuaP/m9T?=
 =?us-ascii?Q?MMgW/fO4xUD+m9NqaY+iscyL1F3EIPfcqHmX9D0W+Dar/wj+A6yyleeSj+lj?=
 =?us-ascii?Q?1iEcUGg42CBREKys6y8BE2m5UxzGXKXFuSuEHXILRk65rCEx3IeqqQ6DB9pR?=
 =?us-ascii?Q?/JUdRQGrjark2cNfKZwINc+ieMZ3ZS5htmnzdBfkunwEeYS1paXdWPkqT8nd?=
 =?us-ascii?Q?xsVqtsNdu+FfK76Z/qd7EUITlVWAIJXsWekdCQwUvKRaY/dqR2mjoIePULED?=
 =?us-ascii?Q?oodXnx1B+ddIwF50DHJ19Xopng1cjYjDByWi5RrFLbdu9yNHUS3w3tlwAsvB?=
 =?us-ascii?Q?Rytg0g6wsnOZ83lI61YER0vUqMqzO/TKz47Hy9DY1WFxX29hYLj8BVxp9iUQ?=
 =?us-ascii?Q?fkK7sU6NbWsl6hccYOYu+Hka8waCP+BJtrYUecYgoRmuJOu2ozrmf5BzIF2D?=
 =?us-ascii?Q?O85EgSx6aMyj2UK6IwAXVu89Vc1uVnVf1xqzv8nP5C84TZW5yP1IoLGotfmw?=
 =?us-ascii?Q?eC7lRrmDekKKZBGph9JhnDE1jUbHNBSoiDh2iZdlzDDjg9M9z7AzRAJ5aPPC?=
 =?us-ascii?Q?tOYS8wxqeEPmWjcXvqwXn/AD9bFyw/fi6Bm7BaXz7iBrD2AlPTmvB3QEv10A?=
 =?us-ascii?Q?vpcQ6vmPiEV7279bvsFR4vkYsIrd8eK39Cbg?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 17:24:11.3702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e46b5c8-88d3-4507-14af-08dda1fa4a28
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8412

Remove the redundant kvm_gmem_getattr() implementation that simply calls
generic_fillattr() without any special handling. The VFS layer
(vfs_getattr_nosec()) will call generic_fillattr() by default when no
custom getattr operation is provided in the inode_operations structure.

This is a cleanup with no functional change.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..7d85cc33c0bb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -382,23 +382,12 @@ static const struct address_space_operations kvm_gmem_aops = {
 #endif
 };
 
-static int kvm_gmem_getattr(struct mnt_idmap *idmap, const struct path *path,
-			    struct kstat *stat, u32 request_mask,
-			    unsigned int query_flags)
-{
-	struct inode *inode = path->dentry->d_inode;
-
-	generic_fillattr(idmap, request_mask, inode, stat);
-	return 0;
-}
-
 static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			    struct iattr *attr)
 {
 	return -EINVAL;
 }
 static const struct inode_operations kvm_gmem_iops = {
-	.getattr	= kvm_gmem_getattr,
 	.setattr	= kvm_gmem_setattr,
 };
 
-- 
2.34.1


