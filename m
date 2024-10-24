Return-Path: <kvm+bounces-29675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB949AF538
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:19:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05926B22439
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180DE218D63;
	Thu, 24 Oct 2024 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B1VVvlaq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2059.outbound.protection.outlook.com [40.107.212.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4D2185A3
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808345; cv=fail; b=uLDQPNmxsU7E5a1SiTgLiYWJsbl3ugHKbsyQHMXQ22LPrZN0KnVInCe9EtqMxn10EFbZ6Mazynat7x0Y4Tgr91jswP2qlgFarO3nV6crvEvn5GyscD5RuECseYnVSH4RFCvsdzAHWN4g+guVHZZdZIGSJveProZTTOX6ikX1IDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808345; c=relaxed/simple;
	bh=CkWyD73YUxU34AW+EhJhyjiPeUTb0qVS7bZH+Q2R4PE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJqTfEPE/u8gyFj32iKaDRc4Byqw5XOwNuEyBt/OXjWoE3vNaBflOPKRLT/0v0HxY/ondCOeBBSLSaWX+bhNEb2JoxB5loWauAQznYZDQP3R9Poou5twUd6xIaebSRnJvipj/xJsYzhz9SrcBjBzbuUG6aq5owpveY4GSR0thYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B1VVvlaq; arc=fail smtp.client-ip=40.107.212.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8sDL0PL8I8j9NvYqUM1lPmf6NHSeESsEsfeJitDrK/NC+sQU2aO5o/3ufLyxMPJS9MIyMTFcvx0Niv+M8s+oF2zJpl3X2Z4/+JacpwpKp4MvuwVsBicXV2zs6WNuqwCxUPAYYP8dDkLYDQExXiSBMwlsgYfccc7wF5qRSSEIYhvk1V8MdfVil3toCGKENQa0lvp8sT48GRnNWrUMWFCyDzLGdOXJARMf/Sqqni2/g8OC8zYg+V0rL+kg5NCwrI7DTabyWSd0ZOQHSS+LJr/1KG/bhVZ1JPXxh3d6VeHUBC4oJxYUzIC1Hm8aDUE85IKiLqSY4/NBCXyIWslhdvkjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B79pSLGe/ZHk/W54Zrr6u2PxKpGyTcndw1UnwIu1ZKM=;
 b=pay4FPuEDnh+vRsUf5b4eEyVN8s1dC9OOVco101lbg0TK64IMjbiYf15gyiyezLraW+nsiQrnWTy5qK3UHbmJiMzEe9Bn0OP44CzlB7fe/9+gOBux2Wp6x4tS9qKZRYqCIGrnpltsrf5y307iIH85OiekQtH9Foh26nxEa7DpzRQ93DFP2lUVgwAkL1u5kHThjHAveQFVF2jEgYBCKByybOhOHGr9rWtuRh0GKWxjFRlA3XgguCDdee9rOCbUQBbHevQqC7KZjcn7PkAF1VGZoA6TOFOEcz6QBsJXMH8lBAfL07Fm9kKRrOCESsu8ubPOrzO5yBTEp+hvEdnSghQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B79pSLGe/ZHk/W54Zrr6u2PxKpGyTcndw1UnwIu1ZKM=;
 b=B1VVvlaqG1J0PMjSfAZp20dsOd8fpbLn8fFpYo7tH+KtqtxCFFqDMVe618GExVNv+8L8hjiTLx9vtFksRTAviyaQeRT7nih+k7tOBHr78n4emH1N8SmDF7xF3+W34+9jHEWZezjsJ0GoIG9YKKyIfliPFueNBkbumjL2eZetftg=
Received: from BN9PR03CA0786.namprd03.prod.outlook.com (2603:10b6:408:13f::11)
 by DM4PR12MB5772.namprd12.prod.outlook.com (2603:10b6:8:63::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20; Thu, 24 Oct
 2024 22:18:59 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:13f:cafe::e3) by BN9PR03CA0786.outlook.office365.com
 (2603:10b6:408:13f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20 via Frontend
 Transport; Thu, 24 Oct 2024 22:18:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:18:59 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:18:58 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 4/7] target/i386: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
Date: Thu, 24 Oct 2024 17:18:22 -0500
Message-ID: <71d46b307975cd036ed04737aeb2a779823b1781.1729807947.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1729807947.git.babu.moger@amd.com>
References: <cover.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|DM4PR12MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: f6adcfda-aa31-45a8-4622-08dcf479dbb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hx/F/VvnUXKgl/L2X0klcXPcJlRB6F9IdOBWZTyBl4btfhqJqVEwl3qmm3XG?=
 =?us-ascii?Q?FKhZKvmt7X09fmszh39KiLMeE9KKK14bQEsi4A8NFCE4p4p/LcRz2qTx014P?=
 =?us-ascii?Q?UzlRYS/iTgmH5uuZIh69N6Oy97xlORTuMwUmKAZh3kmsPdns0WaR3A2KhKba?=
 =?us-ascii?Q?ZUIdeccUQhKCQJWtOHRPGtcDdEeHiYC+YuMUAn8uLYo3DC6LKQvfnaX9vAxM?=
 =?us-ascii?Q?1Q7C90PkCZGn1XKxOEqqCw5dunORrHM/zfCpmEd0yDIU8rcTCzV02tPPjFYQ?=
 =?us-ascii?Q?qrnCeV0J4+o4/nZNbYmbPH5MVIy0cVF/cvhKYteC9jHiUxnJ0k91uOqf3uUG?=
 =?us-ascii?Q?vrfrVlDJymJixb2nPRWyRnPUftvLV7XeBcuVoLQqLoF2YnVU+aXaS6AEI4nd?=
 =?us-ascii?Q?ov8O+RF4j603S2su2dOEz/xyN2DdOZp94U2bLAx62EVJCn7BO6J6MdfyWRO2?=
 =?us-ascii?Q?PKzdXXzxJQQXnfjJy+nOmcnEANGBJaF8avEbUEH0Qu9vZMciA9bHUEYXypht?=
 =?us-ascii?Q?wZ3Q+Flkis/hBmeBh97UagyhcDmpKs5Rujlyr9xqqydSnVgNcoGsHfzOJs42?=
 =?us-ascii?Q?1R3H8ARhB6KFERX8oNX30BVLmFIvB5WXhKMchmV2lbdkl3ZtQziXLmu/nej4?=
 =?us-ascii?Q?M6NJzJvlBANyvXTzc9Up3EBuC+MB6iGbEP1TFR0frPpHc1PSGRIHaQPI5Evf?=
 =?us-ascii?Q?ZwIs4cXBERAGrqa4tCNiM2qUH43VeQvg/ndLkZsdg5sPe3LAHG4UcyPY3Lo5?=
 =?us-ascii?Q?7Gike5TkLO1424GtcR5XxYz15ygw7nG50l6uWxrn4goOezd1LVelAQ3Ml6B6?=
 =?us-ascii?Q?uhXLFnmZp5UrRN8h2HI8S71aR1v1DP1dJtYXjlCSr/ZWZUsnXI/wPJdj+rFe?=
 =?us-ascii?Q?LMOEk+nLsR2anYbuFYKG+kh03xMYrihyYyOfME4cXnIaE3FHTz1NzbXcsTQ5?=
 =?us-ascii?Q?htT2DTgWtgK3Yq8ILOfu97RCMwuXJ3KuKG2/MhLQ3bEM3kQx2A+GLtTT6gs+?=
 =?us-ascii?Q?gz7sZQnD/0oRKgHOLob/PsoNA1CyYPYtOLxGrhZfZAk/4pcx5ffJITvEH3mp?=
 =?us-ascii?Q?JEir3XimaibCRhPP4YEaObfBU6HFFzTL2gdHqlG0yxrbqPfk7hTBu6G1YHmJ?=
 =?us-ascii?Q?x3p1eBcz4PXE0YQVW32Ih58UkbLTwtvFekKNSuDFfbkGvz+moin/uIEhSAAI?=
 =?us-ascii?Q?9GtDwF0tsFwLnw74lZ3vFWhjHo7osrloXu9PqFy38mR2D0R/I0UkjPJQiU9Y?=
 =?us-ascii?Q?p/2cQ2DOiKV5Ww8m5Mwsd2A+Yj9FZkOnfL36HvxtKuBw0Bq/0eEaUdebT0xK?=
 =?us-ascii?Q?6MU8gOVTTjhhwcHZoujdIOxYl2HFkdgFfYLggDXpFgrGpLxTtce43J9LRab3?=
 =?us-ascii?Q?awHUWoa9tDDLGkEp6yHBeV7CENGDpGksYru3pycvcOviIDBPyw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:18:59.3322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6adcfda-aa31-45a8-4622-08dcf479dbb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5772

Following feature bits are added on EPYC-Genoa-v2 model.

perfmon-v2: Allow guests to make use of the PerfMonV2 features.

SUCCOR    : Software uncorrectable error containment and recovery capability.
            The processor supports software containment of uncorrectable errors
            through context synchronizing data poisoning and deferred error
            interrupts.

McaOverflowRecov: MCA overflow recovery support.

The feature details are available in APM listed below [1].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v3: No changes

v2: Minor typo.
    Added Reviewed-by from Zhao.
---
 target/i386/cpu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d697c8ea6e..690efd4085 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5307,6 +5307,21 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


