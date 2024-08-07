Return-Path: <kvm+bounces-23581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D32194B2E4
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EF4D2831DB
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A2C155325;
	Wed,  7 Aug 2024 22:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K6ImRLwZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A512FF7B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068963; cv=fail; b=K7la4cs4idEC99hd9KKiuI2QnvUIup15KdcLeRFHPH0FySBQBAxEv2KchNznaJqqBDdT2Khm4AFfo+fI+LQ1FLhxdFDJj5/Ct1woiHBz/4eZ0P3OirpT7XXqKLqgdSNq1ifuuF4QaQa2ogqsn1ZkCh6oqBC+p3kUKQZ3M8bHaoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068963; c=relaxed/simple;
	bh=dJ20PuxxKmC1YXXt02f2GmgpRaWeNpnLWJSGz2RB2fU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XG1eqoU32bd4tockxqGxqDFyaFrOsWeSOO1FdUtV9wfRR/w/lSj1YxPrzVHcV85r0z+NoFtcBQiGoZfYR6fd2AbVsLn6h2pkJOsP9KhZC6c/bdqRIUOTFB1dGM9z5tqi0CkyQNBhRh/0FPo3Ae4VjfVfvYtpUL8poS3ONoXrKRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K6ImRLwZ; arc=fail smtp.client-ip=40.107.220.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0j2tHiDvINEiohPhutPgb86Uyeiug1QDC03QdARRwHe2mb6NVwyeSI3oj2NDZnNqA2cRwPU4uCI6edU4suZ1ETseeMLIlctMygSlXbshq4pz/6AU00FtGFCSWvKEQueNinkPnE6dAmGC/NEV/L07AWAg9CvmhvYBlHdQM7AqO863t9s5pY0MxzDUd4aixfbNPfxka/uHB7YiQUWzTbXDXT1rLlfnDfaN8dvwyshV5+SGaFFWy07Q0RLmIcmZm5iv2mZu+t3Z5v7UKG3ma5frYBURSd6P8cQD46bDg/jWV0v8nmtsuBsou/lGkyU52/7Lc0y2AB4igaKOAPy0J+qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CofFptYar05/0RJpMgT1JgL9kX2pQSgZbcGMFlvVhWo=;
 b=vp8sN1zFkUDLJsStu7h+P0dcb798uu2DUC3M2rvvyKPNNBCiGZx8dN1sIps+zTl8W3pRA/UoYlwbNHi2Z0MH2HEJZMddHeH65UMXjaIcp33BGk1HIJcJ/loIvjc9eRY8Jlgv9e3/056HXdFRQWYjHdJdBqOg7P7lcN05ZB1JFfcOZEZcJGADE/JTDQbEJ38w8pf5SvEIU4GHzf7p6EtJzd8mxXyxTazb+13p0Myfjn2lw6KzUWTuydBAL9TTYUP6KygVH4gym8Mcq0IofHj23B5lVTr54Z+cm99E/N/UocWNgSXcEFmlS0s8YlErCBcln797300CkDj6Tzw2BQ4Ohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CofFptYar05/0RJpMgT1JgL9kX2pQSgZbcGMFlvVhWo=;
 b=K6ImRLwZ0WU3NNa3ZakdGokBuZoUQWm8Qib/otE9v5Nmekd9QVG+Ba8P/eqEOtKo8D49+RqAARwo5xypge8hS+zAhlpHSbSb+rY1vWGaGhFpU3MEiJThaKqrCEx6CDceXzdA1hr0SCP6A2X/oTu8wjkB/KYfv3p7uZhOkANsbjA=
Received: from CH0PR03CA0230.namprd03.prod.outlook.com (2603:10b6:610:e7::25)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 7 Aug
 2024 22:15:59 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::91) by CH0PR03CA0230.outlook.office365.com
 (2603:10b6:610:e7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29 via Frontend
 Transport; Wed, 7 Aug 2024 22:15:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 22:15:59 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 7 Aug
 2024 17:15:58 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <babu.moger@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 1/4] i386/cpu: Add RAS feature bits on EPYC CPU models
Date: Wed, 7 Aug 2024 17:15:43 -0500
Message-ID: <244f99ea203d026c5e41aea10614465e6daf5e87.1723068946.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1723068946.git.babu.moger@amd.com>
References: <cover.1723068946.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: 0452ad31-5bb9-45bd-cc63-08dcb72e8462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NyuHSVRHqL3Y5uBXB8GfWH1rZx7/klKq9QUQgj/zspsyLYPk37Z3rzoHYxDD?=
 =?us-ascii?Q?7Ua48CPj4avd02t8oa3LxgDRVam+HyQxThM2jzpFNakB/bj9t3cms3J50Xkp?=
 =?us-ascii?Q?9pFj7Z8SJaFwMBA2R46d87JsafCJPMZO0lNXcUtpJL6NP9DnTOgJSHIg16bm?=
 =?us-ascii?Q?nYAq+kQDi0OiC8jN0R8kr94/YGafI+LdoNydKlZr7oYXqYqp9kBPE5RyaIpG?=
 =?us-ascii?Q?7K2sFPx4F0fO4rjupKvXijQ0cYUSoFtxvSDb6o8TEQDV3Yncto1qOQnBbF71?=
 =?us-ascii?Q?VevrxoBWpz+RXvEEJ3uOED9IWzfG7Ub/8xMXlXOrc8aM/3z3cuwB2RUSfS00?=
 =?us-ascii?Q?dWS6tf4EmTO/98YMOygnRpDjNFVgsQAeYNLjbL6WoJrsVs1mbSnXcPq2GZ8S?=
 =?us-ascii?Q?mEVv4tVr5vIkl7rMO4RI1mRMh7ToabHd2tw5NGO8XCrTdiFbt+sJmk2FY/mb?=
 =?us-ascii?Q?+6AXZRMG+X21yV/jHxb6rzP/JytnAmJ1ZA8zTcEwRl0ZXBQpAbBGym/oUHvU?=
 =?us-ascii?Q?pINE+yJZ79dK14gkQbtaQQQxng55YPxTCzu1BMgzi0CdurVFprtAIEAXExVQ?=
 =?us-ascii?Q?2mEoj/MZA+UauMNOZt/6RjwZm31rWdi7kSkRq4zlQx2NoxvO3Y7uoMfR7w3p?=
 =?us-ascii?Q?i+zKsQhZQqbphX5SKm1MVSGVTaOYOjVS8hmUm64GEPD3WfAwdzHQWiwmbZyh?=
 =?us-ascii?Q?K9CU9TSDbvcXQ4AhjLxyRwktam7p79jcER7VKLxVntyWtJIMGDstZBJXpaHu?=
 =?us-ascii?Q?pK9T8OzyomMeTpgZSW+F8ZTBOwWM4HR9qSF/Nyv/EfnKc73CEatV1UGPN0E1?=
 =?us-ascii?Q?v3a5XAK2fzo9z93K48P0wDdkMPYn1Jp+/Q8c5wRi5BhO0NmQ0PzPpORL/Rj2?=
 =?us-ascii?Q?6A8keMT/r3hwq+pPvW548RUoa2bC07wHHx01bblfKUGj6jZoxkyk3eVenu7h?=
 =?us-ascii?Q?HLjsT19Let5du2fwWZA8qba9tX8v8wgTMaUeit28OCxJ4/Rx73qghfn/9dFT?=
 =?us-ascii?Q?+TLMKaK2iYE9FgOixomSxILn1sIGCZOhzySIZEkeBd6wDznvKVJc8E3ja0X3?=
 =?us-ascii?Q?ZR/YsgupSqkDZNCWktz4CHU9vsIvFjxXXQXP8plv3rpwIn9RpZb/lu5xqh7/?=
 =?us-ascii?Q?Zg662DTvEhbUJieJUcADo23b9obWQutMlex62kP+DpdeLNYoZPLBYrW682FK?=
 =?us-ascii?Q?IYFIiqx5j5dD7FQMlbLjqXSB9uam+A0q6lKeyKuImm1R3rOJ0LDvhY7+IzDE?=
 =?us-ascii?Q?7983BjQ9tH8qK0gjWoALuexnPUM97m0mvh0BLfhEtAyOVzWEC8ccTqv/XwUk?=
 =?us-ascii?Q?h3+t/u2wuXCu35uiT/FvrgMHbMe/78WPgR5xlO8jIu0JG1l/8B+g3H5yFQpT?=
 =?us-ascii?Q?P+oZ/rKgTkQR5t7RKXxPkTxcEwKpwzxQP35mhmnyVHslqi7XCRnCXeryfasM?=
 =?us-ascii?Q?1kL6DK6A08UaHID9nH4edgRU2IG6MVSm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:15:59.6432
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0452ad31-5bb9-45bd-cc63-08dcb72e8462
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374

Add the support for following RAS features bits on AMD guests.

SUCCOR: Software uncorrectable error containment and recovery capability.
	The processor supports software containment of uncorrectable errors
	through context synchronizing data poisoning and deferred error
	interrupts.

McaOverflowRecov: MCA overflow recovery support.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
v2: Just added reviewed by from Zhao.
---
 target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 85ef7452c0..19ea14c1ff 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4968,6 +4968,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_v4_cache_info
             },
+            {
+                .version = 5,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-v5 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
@@ -5106,6 +5116,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 },
             },
+            {
+                .version = 5,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-Rome-v5 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
@@ -5181,6 +5201,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_milan_v2_cache_info
             },
+            {
+                .version = 3,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "model-id",
+                      "AMD EPYC-Milan-v3 Processor" },
+                    { /* end of list */ }
+                },
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1


