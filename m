Return-Path: <kvm+bounces-52057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C02F1B00C4E
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 21:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92B3E4E4954
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8B42FD86E;
	Thu, 10 Jul 2025 19:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pzZWTbzQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696C2FD867
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 19:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752176802; cv=fail; b=MI7mneaV0pha7n67Y9h+lcaV3NaYi7Q0Li394JLOjBM9BbyBnSt8ATAIpj97yV87h585M6v8Jppr7XrFxnTbJ3q/D+eLnJFKvjedxrd7W5+D9JAITgHd6M9bJ8HS5WB86d+g6nzONMBX/0qNj000+WxsmixaMr6vUpEL2PI9IS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752176802; c=relaxed/simple;
	bh=1q8K2Y+6zUUGvmorFzzIkhU9XSCA/W12j/F+fOB3w64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gMpNuUQMB7DXHC7gw91Yqtjg4c728jo+vb5V4nHzO0Q/w1qzkIVP+3cofq8EaJoZcLyu8gehiYKLHqgsZBE7CMTRrZMpTkvqLZFT4L43pQV7yf0T9FJzuv9knCkrcQOCYOoOC4wG8oW2/6/AYZs3ruLZZt/lpDdoZanFwJ8TIcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pzZWTbzQ; arc=fail smtp.client-ip=40.107.100.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DA2zvc2g3TL1AwOV7jUN70XgEsqpezevQWccYXk3kznrtpcziAaBbnvEnnwcjXqN3gKO5vkzMdZ+QG5hSNSjftBcNQWTzW1hakXvPri4/1elFynVH2OiKkSuRl3njjGUAomu3JwyIrT3O84B++GZwTqS+JyLChc0Cupn6dVusCSgx0UGwfCZ+H6bvB1hhcM4AzeqBbZZgSBJCj+WB8WiaOFuucPBuIz8zTvYXafMn42IYfu8FinbXG7pXOMqMImnflf0M9aRn9n1VlR74yBe3zCCqLeXbpTmoKSnGE0a5wNt9Belh6HvTye03cEGmoHWvQSr0eQKGYLKeusQo0PY0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkeMzhRGSkjcYK1bs3jN7gGoEvT6B92ZFk+pBfhcjv0=;
 b=jXHlEz2Osv61pqiRg0P2PewBoc2kT36lJzEZU5z7BLR6bk0XP9kxMql7jIwRldzyUc0/ajSNNRVEOS6l1G8uESQN0gdhZmjrBPcGlq5XPeDcQTdRUbG46vMwcDwRs8B5+qsHWTaVZPHl+aFDcQVBdFJ/Am+EO4pJrZx05NNNajGOSFeFDymi4WYFUoBdIaQZPzYXwyRIqd3JY3KbYPgrFE5L8nJo0gdWdYIPIA2/UHXIi7eV3ni/jCTTx0otSPNuvRSRHSCAsBsG3DFm0K+k8LexEKlFApbsu8v8CkdPIEzTxHX57p8BdMY91XC2lwn9PR+kUlEbU7YNslXp3Ns6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkeMzhRGSkjcYK1bs3jN7gGoEvT6B92ZFk+pBfhcjv0=;
 b=pzZWTbzQTJhh7fxMFSlScoTlVzOJt5LoBMDG2Kgv96oNUfpnZ6HnAOcfouWJGgoXnV+CnxDCjf0XR8UNcBhmRWksEJ4OXLuoOoOI4VGsW/U69ea/fPKe70LI3j+t6UaEcDyvOK/5+4W2uFGNsnjXc/zjlIsdZC63Kz3qI0DwPgM=
Received: from BN9PR03CA0683.namprd03.prod.outlook.com (2603:10b6:408:10e::28)
 by CY5PR12MB9056.namprd12.prod.outlook.com (2603:10b6:930:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 19:46:36 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:408:10e:cafe::70) by BN9PR03CA0683.outlook.office365.com
 (2603:10b6:408:10e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Thu,
 10 Jul 2025 19:46:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Thu, 10 Jul 2025 19:46:35 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 10 Jul
 2025 14:46:32 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <bp@alien8.de>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <babu.moger@amd.com>
Subject: [PATCH v2 2/2] target/i386: Add TSA feature flag verw-clear
Date: Thu, 10 Jul 2025 14:46:11 -0500
Message-ID: <e6362672e3a67a9df661a8f46598335a1a2d2754.1752176771.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
References: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|CY5PR12MB9056:EE_
X-MS-Office365-Filtering-Correlation-Id: bc3cef84-d780-4c3c-7ff2-08ddbfea7a49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?36vttF/Hd7wj8nxuYfHJCyJ6NtyUl/AzzPsUiv2LCf9AB6qc08caCR2zAtAo?=
 =?us-ascii?Q?P36cHa3V16VF0DKP4d1+cYx4NWnbI49uWeMMV4X3dcVFnA83n6Hbs5HXlAMR?=
 =?us-ascii?Q?mYrH5gNkxSUDhd6IX+QE0gNX5LIRzlvjAkFIL+UKvlUt/AfrQq1U7MdESo6H?=
 =?us-ascii?Q?nYrfzobGNLBfTCeZ109PogReAhM3br3YqPI4IPQOYm/se3K/KlWBwgtosXZu?=
 =?us-ascii?Q?paaz8oaHHMU3DXavTlf7RLjLwqjE1PBrLDHUo5ixFcti9khXjYaF4zn7FQAr?=
 =?us-ascii?Q?GyjRVtY1qHodJy+5SU1sRTveak4KFp/dClzhvDe+gwcXH+3m/P9HyAV47R4j?=
 =?us-ascii?Q?MpmF1eqNj+ftZ3G24OP+3IXZ1MJLbS2qRy03X7yE38WpXIgjnTbp3ETev0P7?=
 =?us-ascii?Q?UPDhDH6a69+UAEpNLCkDsNmCA25OiFldF39A9qm+sbaoc914RrSILgyK6CK+?=
 =?us-ascii?Q?yivOuaNRsf2gEvys42YLQp+2/bjU36QJDT+rOtzFJIdP4TjjVEj7H93UyY5f?=
 =?us-ascii?Q?Kmo3mEeKXsASyYPJQVHkweZk1g+2bEgLnjCOilf29bEhL0ELYv5eFnmXtMvO?=
 =?us-ascii?Q?UAcSB1H2pFkh3OOGl9+HuDXWspoHNI1UcLe9MV2iB5jbdp12j3bsMIhyebSe?=
 =?us-ascii?Q?kH7hWlqVsLOka4Idu+E4o1LCxm8LC1I2Q6u1puZOUDMRWBnzJEyuMoZ1tcXv?=
 =?us-ascii?Q?zlH4XZsUJmsc2FNF3lHLpAcWMVMMEs9uIO+IQE8+zidU/CHubaycA4ZjWVqY?=
 =?us-ascii?Q?8NzkLlT0HvUe97jPZ0Dof1F9Lh3FyXhzpv+Gw3Y3Hh28m5fjclbmCPhkC1HB?=
 =?us-ascii?Q?eac+I5QkkdwV9qx+S+/LTTgfUIkZefbL1gyPBExKAvS5uw1Qn9aDr/rA5fq2?=
 =?us-ascii?Q?QLvkux1IbSTix4b05Hr7S0r0Y0Yox1cb4SN8ZANRYap/m96oL1g1oarc21rQ?=
 =?us-ascii?Q?BRpE41sQ/wl0B/CvOxcsYRok8N2tdPAbYGK3ubhGhsggqltjdvC7bkbSVafT?=
 =?us-ascii?Q?rK/ekkKgcJbUFBWURUqB/eXz8CRpyaHHCNQtRKFLdwncpdcGIy1OmnYZ+5yU?=
 =?us-ascii?Q?aIPyyrl50RjJ1RP+//bvGpbc0F69WxLQClwNO9134xNnW2nIjRBxWootfAbU?=
 =?us-ascii?Q?UwPrKBvYcPCl6roz8ABlwvXOrA1o0X3omYtdnnqQSQVMGhlJE3iEmqQU/2xn?=
 =?us-ascii?Q?Qf0QskiB/j64Kc7Yuop9jKJQoP8JHPIN2F/aXepfjWlOrbhDi2gY2As2KS5K?=
 =?us-ascii?Q?vCptVf25FrbegK6Gp3ceyi2BwGhxMMTnpRKah11nQ5VySFp6E8d4gzBHENap?=
 =?us-ascii?Q?6LIVOIxZQYm64AikqTWbRenCo6iEeqVZrUa74d4e6zGLAxVNZCJ7liEaxAGI?=
 =?us-ascii?Q?Jr+ElWzCkTJBedMdHwRCHtV7+xmYpDNL2LA11paLFRXC2+ubNOrSqxlXBAVt?=
 =?us-ascii?Q?HXKamVs1jmg9og4UJ/SKz3OdMxIGcESPf0O9/BbYpyyd5HDKR/fzd23vyR+q?=
 =?us-ascii?Q?V98PXbg0vmWD4Z5N/U0Q4jfGaeDW2wujn0qBp9oU8lEfvwDAeLfyg+zAQA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 19:46:35.0927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3cef84-d780-4c3c-7ff2-08ddbfea7a49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9056

Transient Scheduler Attacks (TSA) are new speculative side channel attacks
related to the execution timing of instructions under specific
microarchitectural conditions. In some cases, an attacker may be able to
use this timing information to infer data from other contexts, resulting in
information leakage

CPUID Fn8000_0021 EAX[5] (VERW_CLEAR). If this bit is 1, the memory form of
the VERW instruction may be used to help mitigate TSA.

Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v2: Split the patches into two.
    Not adding the feature bit in CPU model now. Users can add the feature
    bits by using the option "-cpu EPYC-Genoa,+verw-clear".

v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
---
 target/i386/cpu.c | 2 +-
 target/i386/cpu.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2cd07b86b5..d46bc65e44 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1274,7 +1274,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             "no-nested-data-bp", "fs-gs-base-ns", "lfence-always-serializing", NULL,
-            NULL, NULL, "null-sel-clr-base", NULL,
+            NULL, "verw-clear", "null-sel-clr-base", NULL,
             "auto-ibrs", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 6a9eb2dbf7..4127acf1b1 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1102,6 +1102,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_8000_0021_EAX_FS_GS_BASE_NS                (1U << 1)
 /* LFENCE is always serializing */
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
+/* Memory form of VERW mitigates TSA */
+#define CPUID_8000_0021_EAX_VERW_CLEAR                   (1U << 5)
 /* Null Selector Clears Base */
 #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
 /* Automatic IBRS */
-- 
2.34.1


