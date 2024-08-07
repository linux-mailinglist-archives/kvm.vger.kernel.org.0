Return-Path: <kvm+bounces-23583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 880A294B2E6
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18DE01F21507
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 22:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9002915531B;
	Wed,  7 Aug 2024 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="14NBM+a6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D54E12FF7B
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 22:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068978; cv=fail; b=ZKLLP7Hiy42udYh8YMR/V8niKII499YenwgYLoyZyW7ra/uhnIopL46wI614054QoNm/zKchTpPrX+2UwBKlU0LIyWBt68/7lsu2W0kpmxiQfr4csQnP4YJshMBqE7VECl4ZR4lcNB3pYRZkN9PVVFXGA9cinhI5DRA4qatyz00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068978; c=relaxed/simple;
	bh=T9by0NPPgfEbFdzRatzRN/2dA+hM+42Y/E/VrUogIK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VH/nXRlvMf5pYxc1+LYHRxh6X09pl4l8t7jJ7arDQ1egQ6eX9k/sfC21WsgEBmikN0oGl7K50/76QgdAdP4gRpHgo2WFc+vF+M8s42MDxHXXyj8Hwg5N74cyRRcplVT4CbGCw/X8kjFGPQCFYW2nGB6RFksA8J6ftxZLb6FfAJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=14NBM+a6; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sVA61muqgpcRlR9gWT5VFOQSBG1XTvVBsJYUCoxYXMicoDsYey9LaGu5Q/lx6YHb6bw9vMU/zfJb5Rof4Bg84KJ1iZZ27dXYwujCFPdtUQzpNzUn2n6EAHE/l3WjHO+r6lQxSgGpzexq2XdP6j89VmSPgZRiuxUYzX3Kl46s5nfl96N+A4fZJjk7ROkHcC5YlWaLVa54arYKzJPyG8RQS3pf6ngpDZNgjdSjERMm37jlBXP8vb988e07n8JCRd6myEisv1/yUh/bUd84VCctUCC6ENvmiIqt2Y18l+5iKUtt8J+dxeWrmvO059ZnuG21XRPNexkt7dWxMLZ8iGT+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLTiqC5Bq9HZGR14SYU5la/g17V+9G1cI/VpQaJ0uV0=;
 b=qD0A7SsXer9AarjvvF5xHvBiaqHh3qx7eqclaI5YFosVyOgXQ001QVYHHg3z0sjOq/AXyTgoE//BzsB3HY2IUYQyAQd8kKHi2LfUNmo2Qotr+f+1W+eY97Y36xCH9yrsro9j1Ocb3pvJPuz2lMyR53OSHW9a8xRVhRHGocO0a5DIV6Uy49or0UNcStE0Mlk1saVGwWZO4xkDuAir1k/QT/ukrQeFAychdh5fXwHNa/UB1w9n+B24aS+MqEoum13AXCkDif4TWIjHz9dVt4zKKmfY2+pJ5wohrgdVrMs1QiTchtiXfUtfUk/3fc3GlOuU5yRy09oChl0EWJADl7EHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLTiqC5Bq9HZGR14SYU5la/g17V+9G1cI/VpQaJ0uV0=;
 b=14NBM+a674EoMYZOF8WlonBpA0j+P/YwYcfiaXeG9V6KJ+50w4dxGVAzpxAYms+kueRNEQq6+fJEwl6NQqGn2YVrWbq+fE4n3xC17I2pVNsvShCiXSeQUiOm0we4EaTI0TJimVc4e2a0atTLYjWE9H42NqulvflimbNtfKXXWks=
Received: from CH0PR03CA0293.namprd03.prod.outlook.com (2603:10b6:610:e6::28)
 by SA3PR12MB9130.namprd12.prod.outlook.com (2603:10b6:806:37f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Wed, 7 Aug
 2024 22:16:13 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:e6:cafe::65) by CH0PR03CA0293.outlook.office365.com
 (2603:10b6:610:e6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Wed, 7 Aug 2024 22:16:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Wed, 7 Aug 2024 22:16:13 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 7 Aug
 2024 17:16:12 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <babu.moger@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 3/4] i386/cpu: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
Date: Wed, 7 Aug 2024 17:15:45 -0500
Message-ID: <07c14906a65db5ef0d0c89846b0cd36f3b9ede54.1723068946.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|SA3PR12MB9130:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e4e7092-a49a-43df-cbe6-08dcb72e8c7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1dGsx4vIx2Rb3mkG1F2hMWZigM7xj20iv0zc0YoKK1hJa09dKsNCbMowwRjZ?=
 =?us-ascii?Q?rxeBXllyIf78Xa76KQpOO4B3Ey0RkwQbsMjyOX+1x1N8axa2SCbcjC/vPnLp?=
 =?us-ascii?Q?Cr3NRA7pxK26qjwysJ0Wc8lN/2rKXRJVO/5Pu+psRECMWgomIPLaVS9cWgmB?=
 =?us-ascii?Q?pEyV+GclBQUMGOlfoAjnSrcvN+FprpNI9WKtXwYgD/hPiF5O7peJ/xYrSfRE?=
 =?us-ascii?Q?6BUsh4PtPnv3ZiI+lCQfn+AsHcqmTvtT/mFCsyvsou7C/kj8Qu9fL+i2ou9g?=
 =?us-ascii?Q?Vp1Nr0BWhYWLOLbAWRH7satIRRPfnpjQuYEVeGpSk1LazHJYvS0FjpRtRsL3?=
 =?us-ascii?Q?bQC6fnA31SBPyRpxKM+v1s6a7/uWJfPoVgG7mkl+QQpj0HLGK3idIAt4M9xH?=
 =?us-ascii?Q?RO35qZf9snH61m5eVkBkGJBS3cuWwUoUfjc9+94PAqp7JX68sxXrrCg24Jb0?=
 =?us-ascii?Q?SztgNdJ6Bl6UdlzbhhkIXQuTonPep4iicbUARh8Es0gric2gE6ZTtctLjwvB?=
 =?us-ascii?Q?3o5bWNV6TjOBZIc8LqHCswjaZEjkm17tRkeOfKvDyM1XfByTeC/kWE9W6sCO?=
 =?us-ascii?Q?JCBNyQAApQucIihWzfSnIkVo5y8wvm2A6j0OkO3nEiYAqJ/OLFRuQNYPisqe?=
 =?us-ascii?Q?c9y8ph+/GA//BVvm7XtD4NRDpQBNKqUfBA1UV7Aoq23SZsoqkNbTTmp9fFQJ?=
 =?us-ascii?Q?KAJb7hfFFzY4QstiV3foASxIZEooJvAqWw0xXqMtC5AB35hh3upi+Dw0s6M0?=
 =?us-ascii?Q?hh8d+kZr6OZrH+kEoDoM7wggsTsUhscZSxzB9eiYve4kyTk6/kaUdusHAxLx?=
 =?us-ascii?Q?fM7GOzR1tfAJol04FLhRi6qEF+LS88hMbpRZI9GLjmV6XA7nqGumH7fErQi/?=
 =?us-ascii?Q?nyTWPz7Paj2ZrF4dS3+rQinP4Bsrzug8dxA4+YDOhxXK2DaSx6Ak7UGOVQe0?=
 =?us-ascii?Q?19o9U/eFgjXr/ZDQlKw0ldCJ83+pWA994uErsh1BarGoUwbtnptU1KHl6goU?=
 =?us-ascii?Q?E9UIBm9gNkoyz2tvPr3VuWxviAiRQZhdlapXwlCkUZ3zvdZwDbmKSB8O60Ih?=
 =?us-ascii?Q?j6XK+tOlw95Gwzj6q8DOOMRu4qk8q5KVeEg8mPeSspy1KPiTbVyv5fRaaTOp?=
 =?us-ascii?Q?vL7R6SwRMIdJKFEstnrIzGDn3flUd2+suo+eNxwmesOyGi8wtqNMJ2bSNW1Y?=
 =?us-ascii?Q?9qw+NVt4lfri7tmEPlNLn74fVj8Pywj71PqRYKMcYcgYQFj5cYDrEAGtzpw8?=
 =?us-ascii?Q?bVDD2SM2Gf+fHgK92hF92T6s9yLcTs6ehmKuEPL1k5eiv8Bbrx+InkrLaSfb?=
 =?us-ascii?Q?D1mM8vU6uEQBf/ASCefRYbfX9ysVaWKHsp9DDjeuNgrY+1tA0Wj9JPlDvvUp?=
 =?us-ascii?Q?Xr8PexfhkgtRxYC/VnsKs/m5x0Wj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 22:16:13.2550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4e7092-a49a-43df-cbe6-08dcb72e8c7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9130

Following feature bits are added on EPYC-Genoa-v2 model.

perfmon-v2: Allow guests to make use of the PerfMonV2 features.

SUCCOR: Software uncorrectable error containment and recovery capability.
            The processor supports software containment of uncorrectable errors
            through context synchronizing data poisoning and deferred error
            interrupts.

McaOverflowRecov: MCA overflow recovery support.

The feature details are available in APM listed below [1].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
v2: Minor typo.
    Added Reviewed-by from Zhao.
---
 target/i386/cpu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 44cac5fdc9..d88a2e0e4c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5301,6 +5301,21 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x80000022,
         .model_id = "AMD EPYC-Genoa Processor",
         .cache_info = &epyc_genoa_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
+                .props = (PropValue[]) {
+                    { "overflow-recov", "on" },
+                    { "succor", "on" },
+                    { "perfmon-v2", "on" },
+                    { "model-id",
+                      "AMD EPYC-Genoa-v2 Processor" },
+                    { /* end of list */ }
+                },
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.34.1


