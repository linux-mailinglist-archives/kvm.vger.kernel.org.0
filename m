Return-Path: <kvm+bounces-29674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F27099AF536
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C33A1F22AE5
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8D52185B2;
	Thu, 24 Oct 2024 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LxxK5fir"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC752170B9
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808342; cv=fail; b=WWZNf+MclrX6VAkCPPewNr5yl6YwgqLHxc87bJNaUjPsX7iR0XUFNllu9X1AD/Xijd+hWTRvn+Fw1uBj7hPHZhTBTKLOQs14UYycgbUmYegLpNkT3D015KDWQf2I0qmKYNF2kj51EavJl5b20vGCsScuq8KAV5A+JSTc/3Pc4Ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808342; c=relaxed/simple;
	bh=1bA+hMeTVV/4ja+1EQe6/bfKLFmaMvIivDiuia7dp1U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAhi1DsJeLN49vtKtIo5UOz6Yo6yiQzHv+gqNOs7nvZjbHmIToW3gi+RBxgQ2wW6W/+XdzreMr7SP6AlKnbLs6or8ItIpOLLfTQnakERt8/On75HeaOMYaIRTtQdBgZ54aYA5bSd1qqLSOlZIpLohf2W3htioCrJLykEXxnCnzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LxxK5fir; arc=fail smtp.client-ip=40.107.96.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tr1Um7USf7e0kuv2xkD9aMfh4WUjn4zzJ7A05PZfd9nXvIPnqYIpsnqRXzk+21qs+6OkQAgDAq4bCL+wwYIi7TuS/BR9pQx/7MkrOKpNhlynxGAhQxch4rg+ZKpVvjJrG+UGPjozga6SrFjYi55YstoGBhFTOX7Ua/MxNl6TwgxA0D2U1z/cDMims2RFW/KwkrvoU+noESY70fujMQeWQbAr8bWr35wPo15AdpIFfswcJqE15se7qAuq/EWPXW7NkwVb54VCIENcWNZyYuZkb2o98LOWKWCSLqKQRfPoanzMnUqn7GLlaXjmujVKI4jlPWanPSMLBnsnp7FtvHGW2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lC/nWSHfr2KubAxQ1G96BsinYFLfMdavq+HNjo7NNy0=;
 b=SVyPtsw0tAvgFU7sJvESGuqLsKsbGLP7iE7yGqu5i69Eh5O1Ohcs66JdlqzwVcveoa+RyIt61oM8gVqGiKanR7x2QpCDuSr/MQNDTOtTgyBP1ob2dyro/unOySSRYKaLRKhnMElavgIoEoXAejZeW3FdNBUz2UVcEKVg6Qt160Y5NU9XLnckFd092AMvX2W94sm+sF8lcrbanRMhC1nzpnQJ075HFBRjFKQBYH17ShwRH58qOQIQTYe8hTHtC7f7i7Hs7aNxEKelwYnmHu4c0PRUbUrrKIbq8JRsc7w/kFFgE2b+xxtKxq/BdDMDNgzfws6ziO5LpuKCJAuhvsa8Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lC/nWSHfr2KubAxQ1G96BsinYFLfMdavq+HNjo7NNy0=;
 b=LxxK5firww6THxNnwl+up7wP386Yy2teJs4lmdlrnSm6Q024V+6DcK5YOS9cX90F9b2me6TzGyNw1qPVDRboLWejBwAC6CJI9bhnluTILosvs4q1ZOUk/EqICTb6wjgy4ySzoTLH7l43snloHHCHfDPxOTCQGpxxuvX/HioxHtg=
Received: from SJ0PR03CA0342.namprd03.prod.outlook.com (2603:10b6:a03:39c::17)
 by CH3PR12MB9145.namprd12.prod.outlook.com (2603:10b6:610:19b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Thu, 24 Oct
 2024 22:18:56 +0000
Received: from SJ1PEPF00002322.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::a3) by SJ0PR03CA0342.outlook.office365.com
 (2603:10b6:a03:39c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18 via Frontend
 Transport; Thu, 24 Oct 2024 22:18:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002322.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Thu, 24 Oct 2024 22:18:56 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:18:51 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 3/7] target/i386: Add PerfMonV2 feature bit
Date: Thu, 24 Oct 2024 17:18:21 -0500
Message-ID: <a96f00ee2637674c63c61e9fc4dee343ea818053.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002322:EE_|CH3PR12MB9145:EE_
X-MS-Office365-Filtering-Correlation-Id: b532df2d-f0f4-450a-4224-08dcf479d9f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UiRHepItkd1moQg8MqryX3vTQGuOnepRiRlijYks4yl8090xV8WYmVXUo3BI?=
 =?us-ascii?Q?ImpzK65Gg5Dtdc93QgqnfrkgBKiS/obV69mYzdZRmD2EecFpGpC4yOSz1/21?=
 =?us-ascii?Q?xaGAi3qiv9rAcADELc+l1RL6U8X2xkGVk5Nm7hTa4rcJU4PM1z0FmWRTXGAR?=
 =?us-ascii?Q?rIqPzziFl8Dg6ySBhOGx/ffgyL0bgJZlm+rY1UrWN3qIHiFxN4kIJu+jwNkE?=
 =?us-ascii?Q?fitWBdk8v58GRDAstrbpCJU12hcyA9c7/zy6z+KNiSMRsYKOvEvPYdb8rzDv?=
 =?us-ascii?Q?V8pLVmknurhB5gD8S+UIIukbRpfqgfg9O4sTkUKGHv/MTDuUJDrGScMoBQL3?=
 =?us-ascii?Q?Vz1GAMaZOyIpWkefyGKJyVIl60BRZBXC9WFM5LABywmGtGzWrQuimHWbeym8?=
 =?us-ascii?Q?6eKpxqUNakxLClWqk6WdwEBPMNCY4J8fkTVsZJhIT0Ij9VBrqyBRIK4m8RqA?=
 =?us-ascii?Q?gRHCfnTf9aEZn/PB2XhsiVSBIaPQ3st6Pl04m9DpZG3070+5ZeruO/+d91K7?=
 =?us-ascii?Q?v3FVxaDRYmLGqfyNjONaQB9eyoe+BQtN/XvpOMJVmnaQhEuJCpOnh4qoKqB0?=
 =?us-ascii?Q?QWnz1c77x5fiqKuu5Uu36HXgCiY1+sDglMTun6GXNYvPg4I0q3LGYJKCRf2S?=
 =?us-ascii?Q?9sDwSF+g08ieErRm3YHTTfNGSza4IQUU8TfSlnPAQWCF6idlqXt8Xp9PJFen?=
 =?us-ascii?Q?HEPb3i4JWIFmv8EB09qE8Yi6hmli5+Xw9uetEGBcRcUHHpVbCudBhpX5WaJM?=
 =?us-ascii?Q?Wo5bweM8EnhTAsHUoPda2usG8KOhIjJnfZHs15meGEupUWdZURizrygPLT3y?=
 =?us-ascii?Q?vejWUhK/w7A4+8KMa2trbB1Myc9S9AL1uLBFv+kseNPfgq21ydStNeW+Rykp?=
 =?us-ascii?Q?rD1MAYtQb+BP0bZxcC0JwvKSZGsdDBhENm5hDcSQbwicz7I/xWAjN/sZW9ko?=
 =?us-ascii?Q?Id/hCW5fW5Tu0Jdq8cniXJod9hUXzzMYuSM9F1XSP4FZJ6r8cNq9djTtn8Rq?=
 =?us-ascii?Q?5q5ixX5Z+qvALqIMa5Mq9B0lBZykty5A5OeAfPoEHi1WTwb2zppfpThrKuvM?=
 =?us-ascii?Q?UqmFwtWYtDfdQSojMGGYVAXuo/4KLHpJ7RHNtMy9OQcFbmilJGPygijmLrbU?=
 =?us-ascii?Q?ayeUds4rM4RESHV9DvRJdMrUYh3b2+urpDOlfqYxEWLZmc7Q69QGQKlPQXIv?=
 =?us-ascii?Q?o5j3HWUcuDm1YX1JBMDIVyzQw2vteLEKmd0FGWoUyxdDTk6QQLAvRKfNJrUZ?=
 =?us-ascii?Q?3BKk66LK1o8hiv1HupYGDLOtAscIiqeI+Hmnp0Fx7eBpyaV551NI7kNHYsvo?=
 =?us-ascii?Q?G3UjFEMtfHzoqr5m1rSTDknInatBYOCOZY0e47AWMRb06l5YVj+/8ObC9yjs?=
 =?us-ascii?Q?2YzYwx3j+/0mnCSvEHULYOABjm+D5kfSQhV1pd/qXjR35FoKaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:18:56.3245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b532df2d-f0f4-450a-4224-08dcf479d9f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002322.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9145

From: Sandipan Das <sandipan.das@amd.com>

CPUID leaf 0x80000022, i.e. ExtPerfMonAndDbg, advertises new performance
monitoring features for AMD processors. Bit 0 of EAX indicates support
for Performance Monitoring Version 2 (PerfMonV2) features. If found to
be set during PMU initialization, the EBX bits can be used to determine
the number of available counters for different PMUs. It also denotes the
availability of global control and status registers.

Add the required CPUID feature word and feature bit to allow guests to
make use of the PerfMonV2 features.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
v3: No changes

v2: Used OR instead of overwrite for eax and ebx.
    Added Zhao's Reviewed-by.
---
 target/i386/cpu.c | 26 ++++++++++++++++++++++++++
 target/i386/cpu.h |  4 ++++
 2 files changed, 30 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e88859056a..d697c8ea6e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1227,6 +1227,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .tcg_features = 0,
         .unmigratable_flags = 0,
     },
+    [FEAT_8000_0022_EAX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            "perfmon-v2", NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .cpuid = { .eax = 0x80000022, .reg = R_EAX, },
+        .tcg_features = 0,
+        .unmigratable_flags = 0,
+    },
     [FEAT_XSAVE] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -7040,6 +7056,16 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *edx = 0;
         }
         break;
+    case 0x80000022:
+        *eax = *ebx = *ecx = *edx = 0;
+        /* AMD Extended Performance Monitoring and Debug */
+        if (kvm_enabled() && cpu->enable_pmu &&
+            (env->features[FEAT_8000_0022_EAX] & CPUID_8000_0022_EAX_PERFMON_V2)) {
+            *eax |= CPUID_8000_0022_EAX_PERFMON_V2;
+            *ebx |= kvm_arch_get_supported_cpuid(cs->kvm_state, index, count,
+                                                 R_EBX) & 0xf;
+        }
+        break;
     case 0xC0000000:
         *eax = env->cpuid_xlevel2;
         *ebx = 0;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 9eb45faa65..e0dea1ba54 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -634,6 +634,7 @@ typedef enum FeatureWord {
     FEAT_8000_0007_EDX, /* CPUID[8000_0007].EDX */
     FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
     FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
+    FEAT_8000_0022_EAX, /* CPUID[8000_0022].EAX */
     FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
     FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
     FEAT_KVM_HINTS,     /* CPUID[4000_0001].EDX */
@@ -1022,6 +1023,9 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 /* Automatic IBRS */
 #define CPUID_8000_0021_EAX_AUTO_IBRS   (1U << 8)
 
+/* Performance Monitoring Version 2 */
+#define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
+
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
 #define CPUID_XSAVE_XGETBV1    (1U << 2)
-- 
2.34.1


