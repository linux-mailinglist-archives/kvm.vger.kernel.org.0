Return-Path: <kvm+bounces-52056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06F3B00C49
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 21:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 864CA7B11E4
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAB22FE393;
	Thu, 10 Jul 2025 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c41rE/it"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D332FE379
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 19:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752176793; cv=fail; b=mk0TNjKgOUEL3/ZViePS7GLIPpdV5iLBUCzULwLlnArJdt5LVfTbx+NvqgMp1obxJaISFHFVlMX/HsYbsLDpT4/HOittl4Uwc8y8zyfhn82YEZ854I7pPUzJVB2xnscIJevNxTXDCvQWmseKJ0Coc91AS+YknS4TcX+LXWDk4w0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752176793; c=relaxed/simple;
	bh=7XIColn3plMEm71/RKtT86K4iYFLd418IaZheEM4laA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qU734NTtPvE5I3q7DYAG1VWCZy+BFzcfZSWKYSVNBcmg3tHjvQr2GJ27eQIRGGHUdnioEJi4eEyiuwxeLaxsBKuoIVd7d3gmoD3nvZ3t4kDzcB+yOkEQ8GyHcD1ANAx9L9TVusJ3P2AXr1QzEdsopuP8HkB9VBrw4ysGoqqEVFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c41rE/it; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fidfZIU28mtIonHMxg8dNmSkvawdTTKMOkd7OcGdNZSpSfa0JAVXFKZsDIyrTZmSAf3fH8uGgqn5bB5TGrhf3Zg1V/WzzNK/SqkdQZ5ymT5x6QtZUDY0LdO3TqZXptlZ9cwTp6DKxWFdVLjyWevEpvBjSbnptmxcsccFn4RNs5dIz2MQf5sKS1+KZEMqe1oy8hT9hveSJgzXU0W4TLj6D03kk2EGriy+MmD2JSA43e9JV2mXE48tZ+Z+oSboipUm+qtPbUdc4+kzy9ueQEQ+a3YY9bLdkkLkP9ZYJ+IyygOC3nlpx/yI9nEb2CkFkQt6QNRfFhf8kE928+eOUAIvgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQKIvGMWlrXVyHXWvUovt+An78NuP8mTeCdDBxmnfMc=;
 b=XIo9GwBJ5S3YtaJGxDVLDkSVPBflkAJdQsn9Co+ieXQWh9ljXi9jXCEXG/JCb23KZPQI4BY2gBl77mmCkyRh8UgdcUBG/XlzYXcbQ3FEhpORQRYXSfGoDDtwDmaHmSVQRMy7x4qruD5LcCnHujtNF1YhSubDAd2GQeL0wql4FpIi5PDxMuXRdH8zgCERQt1SArbBgUEK3B/p40D5SZn5oi5+hhufTOUxujH8o8bVDtY9WcTg0clE6Bw55TDt7e0+bMlb2q5agbOjdt3Q8dtp5kMSdY/J7asuVq0Hl7PcNe9o/9yCtFtsqlcBfkpIt6/Em3hnskgUrxGh5wa+NyTq+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQKIvGMWlrXVyHXWvUovt+An78NuP8mTeCdDBxmnfMc=;
 b=c41rE/it4Kt3Y9vBghE9oklVM40/zm8f23AJO8+vRqWAJgEMaqCqQ+lrkQq3CqKC5Ot2lW14H+1ckbAcDHuPrNDrFGBzMdcIaPIn6biw21HJYJJFw+NuyvR9z2fRnYw5E0uTnk46YMaFpMC2aLGPugkfrM0Q976i8KRMvMdJgJc=
Received: from BN9PR03CA0293.namprd03.prod.outlook.com (2603:10b6:408:f5::28)
 by DM4PR12MB5866.namprd12.prod.outlook.com (2603:10b6:8:65::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.25; Thu, 10 Jul 2025 19:46:26 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::51) by BN9PR03CA0293.outlook.office365.com
 (2603:10b6:408:f5::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Thu,
 10 Jul 2025 19:46:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Thu, 10 Jul 2025 19:46:25 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 10 Jul
 2025 14:46:25 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <bp@alien8.de>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <babu.moger@amd.com>
Subject: [PATCH v2 1/2] target/i386: Add TSA attack variants TSA-SQ and TSA-L1
Date: Thu, 10 Jul 2025 14:46:10 -0500
Message-ID: <12881b2c03fa351316057ddc5f39c011074b4549.1752176771.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|DM4PR12MB5866:EE_
X-MS-Office365-Filtering-Correlation-Id: ecde4bb2-0382-4aef-0237-08ddbfea74cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UY9zNWiSbA+2uL9jMee2aJH75WZn7vLC8F2qGhsqDTYHvGcxFYv+Yv4pOdsf?=
 =?us-ascii?Q?U+gRY80anLh4LZ0+rJ9MWpkgGnCoQEOJfWKXsTqFcuSBWNL6/3sn9YIDzTlJ?=
 =?us-ascii?Q?Y9Cdct21GXjW9oZqn5FIBxLiggGwynkIbKurzG7ndZm2oWx7m3ThgHc8RT3B?=
 =?us-ascii?Q?/LjxmyBRgsShSxaxM0vz7y/RO8R9Kr3H0fOOWGH52FCojwID4A02JqUo2yDI?=
 =?us-ascii?Q?tol3ou/OX2CZuhG4N3rN9pcNZxlCSNwq+JYSdi7w9bS90Ko48UTFaWv790ZF?=
 =?us-ascii?Q?iKfD1QIdmvmM5FNwfTHs4DYg9xK8vozrD7feREww7hb69N1jwdAJO7UHAAUC?=
 =?us-ascii?Q?VJQK5OwN69Wod/PJpb4OyZAXs1JVmvZWTaIhwzwh6dtSTT6ApQCf9ilfSoHT?=
 =?us-ascii?Q?HA36a6U1GCCDwk7HQcbEEod7Sqx6UmkiBiiSOg4Rk6E6DMcb2P9Cz5TpDgg0?=
 =?us-ascii?Q?JHvDCFQa8JEMaRa2euFEUBM0ava8HPA8EE2GK5wrNStwvqws+61LgVYGoVYY?=
 =?us-ascii?Q?AVVOdxSEYkaOiMby6Yy+Gtg4f74tRTOgkTUlwmDUd4dWfOgAmsunDWWTbyBx?=
 =?us-ascii?Q?CeVkIxYSsQ6gllJgVpsXf4rJK78Ju9AJxUw7Utu/FvMCjoB3/6MGiQna786s?=
 =?us-ascii?Q?/Lrl/vYehA/dRXYJ+qVjTpTlhkem6XBNqBJcAqKAn/rziixdDZ7z6vRII2Mg?=
 =?us-ascii?Q?4MLrxrdwlya36QCd36pv/ZjeJbja1cpI8ln0Z11sAh1ErwqXtp9U6vqeVRNt?=
 =?us-ascii?Q?us0X6oTmwxihes2+qAXuyj9+6xBZ0veyGsY2wdn6GEvGnqid0Mt6fQW4cq6Z?=
 =?us-ascii?Q?biLGtpSIuI7k1PJZV7TODKdB6RsyxeKjYnyGI5X0WdnGzPleAH7Wk/ivRdMC?=
 =?us-ascii?Q?pQU7eL729FaxtBF/V3xp4bDqBCLi6yHQKfrz/lQSQW8mubTOzZH7B+5netCk?=
 =?us-ascii?Q?KMaGZx7Of6Pi0CaNKK7FMRW9ezougSUrhyCeWKUemtHnJaYWU2hV6JXDdD21?=
 =?us-ascii?Q?3KS+hbxVzAjz9/vYCFDjdF91Hib+5mMKU+1gFXjmlaaDqwl44yu08UT0F3tx?=
 =?us-ascii?Q?DPpwFwIxpY3DelACUaVFjP8Dhnd14nmkYXLL+Oqcdhur9uGO/s68H/F7/IeX?=
 =?us-ascii?Q?QE6A0IwGiSwqwG2m1d8pqgcpZNx5z+32iz5xfPg0oI1KCkQda+4um7LmHr7G?=
 =?us-ascii?Q?mKrMdgT6gdOpINJuZa/FCe+yeczrI0gH3zYk/CSPzamB5JI4TqjCs8kqUo1N?=
 =?us-ascii?Q?5F9JdA+LGFsx2Smv8c1fK2e/tNh6IpNel7jyi0Kc+6C9RLBGbVo8aIMrO1ys?=
 =?us-ascii?Q?Kp0NFXltDvPta5OVij2eASfDxX5kIa7Q3Qqjaaihmh4GN25Mwd+tqNgsXH7Q?=
 =?us-ascii?Q?2h3FJl3K9n4MaDgXr1uxFamkAU0X8t3QwONl6fEoQWbcWs/kCg7ZvC7JFCOi?=
 =?us-ascii?Q?aLyx9CGyVoDgwHAdFOfa4RdDS2kWk6RSyC8kvdLWNcfiCxrybbYBi+K1iGvs?=
 =?us-ascii?Q?mEbNt1oNgNo89gOXpdR4jzTaem6ojx+PIXN71Z8irleRK/C5lH0bz2CXrw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2025 19:46:25.8822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecde4bb2-0382-4aef-0237-08ddbfea74cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5866

Transient Scheduler Attacks (TSA) are new speculative side channel attacks
related to the execution timing of instructions under specific
microarchitectural conditions. In some cases, an attacker may be able to
use this timing information to infer data from other contexts, resulting in
information leakage.

AMD has identified two sub-variants two variants of TSA.
CPUID Fn8000_0021 ECX[1] (TSA_SQ_NO).
	If this bit is 1, the CPU is not vulnerable to TSA-SQ.

CPUID Fn8000_0021 ECX[2] (TSA_L1_NO).
	If this bit is 1, the CPU is not vulnerable to TSA-L1.

Add the new feature word FEAT_8000_0021_ECX and corresponding bits to
detect TSA variants.

Link: https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technical-guidance-for-mitigating-transient-scheduler-attacks.pdf
Co-developed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v2: Split the patches into two.
    Not adding the feature bit in CPU model now. Users can add the feature
    bits by using the option "-cpu EPYC-Genoa,+tsa-sq-no,+tsa-l1-no".

v1: https://lore.kernel.org/qemu-devel/20250709104956.GAaG5JVO-74EF96hHO@fat_crate.local/
---
 target/i386/cpu.c | 17 +++++++++++++++++
 target/i386/cpu.h |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 0d35e95430..2cd07b86b5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1292,6 +1292,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .tcg_features = 0,
         .unmigratable_flags = 0,
     },
+    [FEAT_8000_0021_ECX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            NULL, "tsa-sq-no", "tsa-l1-no", NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .cpuid = { .eax = 0x80000021, .reg = R_ECX, },
+        .tcg_features = 0,
+        .unmigratable_flags = 0,
+    },
     [FEAT_8000_0022_EAX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -7934,6 +7950,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *eax = *ebx = *ecx = *edx = 0;
         *eax = env->features[FEAT_8000_0021_EAX];
         *ebx = env->features[FEAT_8000_0021_EBX];
+        *ecx = env->features[FEAT_8000_0021_ECX];
         break;
     default:
         /* reserved values: zero */
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 51e10139df..6a9eb2dbf7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -641,6 +641,7 @@ typedef enum FeatureWord {
     FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
     FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
     FEAT_8000_0021_EBX, /* CPUID[8000_0021].EBX */
+    FEAT_8000_0021_ECX, /* CPUID[8000_0021].ECX */
     FEAT_8000_0022_EAX, /* CPUID[8000_0022].EAX */
     FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
     FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
@@ -1124,6 +1125,11 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
  */
 #define CPUID_8000_0021_EBX_RAPSIZE    (8U << 16)
 
+/* CPU is not vulnerable TSA SA-SQ attack */
+#define CPUID_8000_0021_ECX_TSA_SQ_NO  (1U << 1)
+/* CPU is not vulnerable TSA SA-L1 attack */
+#define CPUID_8000_0021_ECX_TSA_L1_NO  (1U << 2)
+
 /* Performance Monitoring Version 2 */
 #define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
 
-- 
2.34.1


