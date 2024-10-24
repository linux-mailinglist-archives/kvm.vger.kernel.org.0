Return-Path: <kvm+bounces-29673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E50069AF533
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A57FB220AF
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C661218316;
	Thu, 24 Oct 2024 22:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ScWtA/WY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2087.outbound.protection.outlook.com [40.107.212.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6C622B674
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808333; cv=fail; b=cR3L1i7eRg62D0lWa5l3VmwKKw+k7PCpZCH98iM/Z8Y0lNI42izh5Mr0f7OsZE513QV20KRY6azQ9Acab37BRm9T/jtuF0x9FGwrF4WdD7FX0E4khTJR/EDp2cAD9Wiclqgvm/GTJW5AQZa0wsyM/KYjW5gDILd7Hyqc3sC/8Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808333; c=relaxed/simple;
	bh=YY0kFRqqvLPfu/QByhe5BLSJpXcRQOUYJBJBTaC0vAQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwbLu3Qjq6bprbmaWjZ7Ua7i8djm8UxPQcIq/JhPjqwIFByKU2vB0phuuvHuvELPmTPJBoA4mVJY+42lHPx6WN8QYv3LU4bDKA+mwBW0/93PoWqqEYjMMBRjfzkNY5pwta/XkN0Sm6Si5oVwc6W4L+tRbyg6NrsbpgTtcUrrtIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ScWtA/WY; arc=fail smtp.client-ip=40.107.212.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyXYGVgLSIMtvDDaTkXkkYab6AKPVEkFcAAtuDGbMu2nBuPpwEjq9pyA90SeNvxxljgUA+PKb+spkIMFCIzeKt7nrql1nwY3FyISJWnSjgY83hV2Ijchi7r+FixF96u4ITHiHGqY0nMgnd3PvtXdAco38msF0bsiYF5uduRPJiiKIxRfXNeS943J+tmmEL36Rac6Q9LZdfTehXj/XpyXCM2HdsMsKTdBm0kW/dZEx5tZW8mJjpP4yltCVxo91intAKZ4biD3V0HdlnIpLrfUMN71GtmRTLSsZkv/vXJ5FxLb4Hz92tFgFuUCmNHY8rcoG5FCrHCKMvAGK6B4NyxnlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJxL3D/CIS42ofcUAq4sOG7znmn3Ca0nIeSCEzAQcR8=;
 b=Lg+fnF30Kf4bIQO5O6M3fu8CH8ChRDit39yldSvwuQyugszuFqjVEeYxQBW9CMtVWGrA0ljxeusHBCybBU6ggyzr6xsLtdDd5f0sIzUfvCxbyWj0dru6TQH528KBo4YdoatFag1hJSsUXnfMetOSGtgaxjYpxaYPW8byGBqRM85hUU4/rP5/o2K8+TbSmcei/puZiIOznwQzh8laH/VtxizPdBiddK+5bE82YCoTC3b1n2ujF5QGhXz/oq390OAcudQ++dUevwTZ1Jd8U3VrSybuZjgyVyLmeg7+rrsnGQo3XbWnS/+0YUmFvnSy9gu8PDzwj96YBiWbpHF9UfVNgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJxL3D/CIS42ofcUAq4sOG7znmn3Ca0nIeSCEzAQcR8=;
 b=ScWtA/WYZWFxlglA6c1fJsmBJJa2BNsqsWgzofjJhkJzkW/unZrvxVfkuFMbAoFA1wMscj/QzmEIqVHIm3pd253ENEzCxflWLeq3I96jt74plx/QROPn4wEJJ5KMeOX3qnbwl2iAmYaeuPuimqr2ZN5bmWdIQD2InEjM54/SJUc=
Received: from BN9PR03CA0906.namprd03.prod.outlook.com (2603:10b6:408:107::11)
 by MN0PR12MB6152.namprd12.prod.outlook.com (2603:10b6:208:3c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 22:18:46 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:408:107:cafe::6e) by BN9PR03CA0906.outlook.office365.com
 (2603:10b6:408:107::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18 via Frontend
 Transport; Thu, 24 Oct 2024 22:18:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:18:45 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:18:45 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 2/7] target/i386: Add RAS feature bits on EPYC CPU models
Date: Thu, 24 Oct 2024 17:18:20 -0500
Message-ID: <63d01f172cabd5a7741434fb923ed7e1447776ee.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|MN0PR12MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: fb4b7468-c2a0-419e-89f1-08dcf479d392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UsBrU5YkdhYury1W3E465AD8PcG1I9G6hOQNx0hWK5On/hdpcpuFGNlHhP5h?=
 =?us-ascii?Q?7wBG+jdoLVZj3hTpFgrYgrrk9lD1h/5Qkh0FOc8I9ZWqwcTvg3NcTQdY1EJ9?=
 =?us-ascii?Q?aAFPAMnB8wLCmysH87KbXqHduFW1+DQzQiUhE1OGUfp3W1PcU1ugpyOeVOq8?=
 =?us-ascii?Q?Wr/AT2MaD96RO323ZmqDTtj0i1rOvYRIqMua6O5OS7gjP/2aQzpbj/FQ19pY?=
 =?us-ascii?Q?7E1MAA4IHmxVfMuD6yFmiLLx7EGgAZxC/V1l9Wnhc8+4+85/uRPCX1EJA0NT?=
 =?us-ascii?Q?FUAjNtfbbZAoEeC24E8Y4NC8lNFYc57Od+yt1MqkcGyrjjqRtiKkIYls5zmJ?=
 =?us-ascii?Q?vm3m96EMOh4aAIgmjVVZgTypv5cTM5Bp6aVict1mckjaeww3vTIPCJDUdwGg?=
 =?us-ascii?Q?y6OnBDySj3VhhCvepqtGZQHExoVPUvyg7SLO8nKMKem1hrs/qeQWNmbapv4K?=
 =?us-ascii?Q?gOD9rR0Tl+Jg4InHXumKJ8aExJuXbPRIKB7a8WILPug9UKkvFvjLx2XXgjEv?=
 =?us-ascii?Q?STcYHUS9ZS3Y9Vv4RUNS1qMBH+3nE8TOcUFMjL6VyhqvfMjgK/kfArfZ9bEc?=
 =?us-ascii?Q?HVA2/f2uAhVHPjZTbqaZOjH1TmmrNzLVOLo+iotE7Bs+bsGEoJ1xwpUfe6Ei?=
 =?us-ascii?Q?2tTADWfFkCWPtnu95BT7d3+KZfSOajtK5eUGbcL7rezMy4F+jzatRdXyK1lu?=
 =?us-ascii?Q?PPY0mA73e97ITwWERAF4+q8fH2qi7ScnZYr+gGSJFdEV/HEsBvyAheA/oSxU?=
 =?us-ascii?Q?+DoyN6p8gJzisLN3bnA2g06ZPqEjONi5jsYcB3DLB+AuN4o6NEWlmrIX6hRf?=
 =?us-ascii?Q?8mlUqrp/ZqlCQ1q6NlZsPxlSpFPujalBeDJh3JBkirg4HAWOwUaHf6hFPVZJ?=
 =?us-ascii?Q?98+UlsLEVni5Svez6JvRQkdhmQ8XpkzrdPaN+9emAfj//648dGT5TSkEf0Ii?=
 =?us-ascii?Q?kb9wXWS0XFqd7BvQMiiPm9NLK2xBK1nyVvyU+q9yJvz5npCFvrFdRKLEPMd0?=
 =?us-ascii?Q?IIoBhEf5DO2WpK+6vSmFT0FViHiM+qxGfv7vS2/VAO68+fe/OmmQRv89/4nK?=
 =?us-ascii?Q?/uEDZCdf/VNgKJTx5ebPsOMyu2gUxe8aeh1TBpPXPM1S5p+GbYhROamoJAJK?=
 =?us-ascii?Q?p2/G14VPaXtjAQ1oLrnLsdZtvD6kgqg4B7obLYWl0G+u63LvfWMRot4NlWvm?=
 =?us-ascii?Q?1Yqw4aYzsu6mJhTSwx1+/epgragfcUEvX1uOZU+ARjjLI8VkKTh6UIrlC4YO?=
 =?us-ascii?Q?5fyJ856GlEqM65tOFI715i+Z2bLr79n76686V7rCw2ssC+V/VBvbBLYbCd4f?=
 =?us-ascii?Q?gp2Am+L22UTL3m+czx/qrSzgr9/Y8pPhzPVfowkBkCLfHpsrvBarLOOnnAmT?=
 =?us-ascii?Q?CgKiI9iJ+W+XoztQ2i49u7DHJ6IsNLXldgdqT8LDiq0N8yrOBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:18:45.6959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4b7468-c2a0-419e-89f1-08dcf479d392
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6152

Add the support for following RAS features bits on AMD guests.

SUCCOR: Software uncorrectable error containment and recovery capability.
	The processor supports software containment of uncorrectable errors
	through context synchronizing data poisoning and deferred error
	interrupts.

McaOverflowRecov: MCA overflow recovery support.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v3: No changes

v2: Added reviewed by from Zhao.
---
 target/i386/cpu.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 94faff83cd..e88859056a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -4974,6 +4974,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
@@ -5112,6 +5122,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
@@ -5187,6 +5207,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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


