Return-Path: <kvm+bounces-29676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD3779AF539
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41F991F229F2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549B321733C;
	Thu, 24 Oct 2024 22:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zwwBxaa0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8749F21858F
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808352; cv=fail; b=q7rkP9RcRigek7PINFTrTxCvrCYyMu8KZW0pRgENiwCcOj9DPHNGBJSjTfYIlwHF6zZA3r58kSCDSrpWVovIrIMdk7J2FALVVlpFMu6OGYUNt4biMLNHfJsmuA4h3dBSd7b2bm4Ny++LypnDDI0htc8MBfi3s8LqVBa2mM4qJY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808352; c=relaxed/simple;
	bh=/MZB+xIew+9G2Qs1+i3CiACOY5uL3lNXEpzBeWEYm9c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ct0/oSFxbdsrUPFCiQl3+1Blgz0trWbtt+sj7rZIwyNEb0ZNWjoTOJ8W/lKYv0qqJnq5pDRaSH7EjiOEsniTJ4ZcAFvdsXGCM9kefeC2gOcbNMC2FFlIkkvHMPs6+ZquCOirHq7iG9TS4okca1RVzcaUXYiqvm57/lwZ5WWuVw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zwwBxaa0; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPs/U86DJJql0fzI1d+INPp2SfBTncscBqcM3KjPE+4/f4KWsCFXChtwISFEM8TsXNFEuBqCO0+WUsvmLN5PQJsYHY+lsxDKU49Vvv8WtJ4e3kuJIM1mgaCk4fTGBkWSPhPLu1vCe9zvfAm8pDy7+I1AVN8aUGb0CETK//XprObvtcDCM/ac+1WTrWp72eyFO8n8gVoSDQBhqpqat6HAefHohUNcjpO3imvNW+d/FAAXTffXr6y87gwBY3OOgPZFyTP5dmmNkFUb0VbxMy88ZxEbQqbeEYCcT16FF8tUnE+AQYea6fbEveujFESkRgsO8z3nmHB5F221eI1VnnTDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b1SjjznzIat6MsEagbZ6ZzslzfwCBDSQfWxfUc2bkhg=;
 b=Dif2LFb3eYwkRbR3rIXV73yo/KCDdnLaowwU8wuiDDvIMFheETEh762doHCL3BfcDsmjYY8o5zXsDg5NxZ9BZPQWh2Ftpqh1GWEtNAje7xNxIfvNRGRd8nd9Nn4t/VMCOmViDNp8uTKYqLgAKzvGm+nn8XY02xmriZXZzWXTyKh1qwzSsv1UsC2iVG1Alc6pk99EaAjItDoqRwrkihfgmb65NUB6o/6eqY9QK8IbpCse5qnhf3BpxqZGh0JnyaUEAb+M4oWzF2oaJk3QW9cXlayc+7xolpexMlmIp1Xl9uzOG5o6mJQ0GIyOqfWqTxHaSIqtIeKPFLSOdQ5ATFTElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1SjjznzIat6MsEagbZ6ZzslzfwCBDSQfWxfUc2bkhg=;
 b=zwwBxaa0j/eZw+0gMQK0bTRaQU7cZwZnWDhUt/TTBaVykAoKhVdJFF8ZryIqOiECh6MklTBEcs4u2Z6MdGWfEifFf0spvsZW+OaWDC/hANYy7JbL61lEnSSdiQpU+izOxmNL5MBtnJ4NcuC5HCh5di+9TKJAOwUoMD0FVIuwufo=
Received: from MN2PR04CA0013.namprd04.prod.outlook.com (2603:10b6:208:d4::26)
 by PH7PR12MB7871.namprd12.prod.outlook.com (2603:10b6:510:27d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Thu, 24 Oct
 2024 22:19:07 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:208:d4:cafe::5d) by MN2PR04CA0013.outlook.office365.com
 (2603:10b6:208:d4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Thu, 24 Oct 2024 22:19:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:19:06 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:19:05 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 5/7] target/i386: Expose bits related to SRSO vulnerability
Date: Thu, 24 Oct 2024 17:18:23 -0500
Message-ID: <dadbd70c38f4e165418d193918a3747bd715c5f4.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|PH7PR12MB7871:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c4f50f4-14d0-4e87-5055-08dcf479dfd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w9GxWcIsC+vWa7C+ulzX6hILDsGAMqKBqzUSW02W56x8DRLmqx7gzkVKrxLC?=
 =?us-ascii?Q?e0p3WvhufY9XbNLsTZHlyw64U1Cnkip/wchMMcRf0eaWyivvHYuzeknlsWaQ?=
 =?us-ascii?Q?/KeV8WOesVJg4i/Axu0b1Cwb9dn5uEInRLBxaDWPhcrlyGLmn2dAXCo9ibKT?=
 =?us-ascii?Q?TRA9s/9q9yVWzABd0IYkqf6l/xPXvSyMV6Svd0tIhPnLjzpSMAoDGQMz/H5U?=
 =?us-ascii?Q?6oh773zexh/i12TDhLMoT0RXpaDoZemzP7mBVEQA2Q0gYLc6OIqyKXQc8TVE?=
 =?us-ascii?Q?yYfbUT+TWx5aMA0wyePekz+WaifyqNeZAsy7sIGQPV7YOMaF2SnSelGCqgn6?=
 =?us-ascii?Q?FUoiVLmTZYJzRGjkoXJJVDUsvElLd5CLfZQuIdQmVB27LoGIElj7oJrEAuMb?=
 =?us-ascii?Q?T7sLrv8hOKT/3eOrY8ppfjzwNl8LIaBhe/5ruKhSSxpQcpFhwTg1KuyeRiEM?=
 =?us-ascii?Q?jKszuxLfDjqJ5q4LDwCRyegqbU7n6iaTAPv0mhwxBdPARUaoxkc7Ofv09jeJ?=
 =?us-ascii?Q?hK1pDl095IlgP9K7o83d6mKXdd9x9QJeiHfHU+9sEKhPv49nLVG/IM6pDYPX?=
 =?us-ascii?Q?Kb7qkQcjdFzBDTNLGvnLSCfhlMK2fOdFay3iAPs/yyeAuV8gTjYrlFATxMCc?=
 =?us-ascii?Q?bzhmZ7yYrLbENfiWLfK9L7uRfO6ZCYFGX8UdxCGP0uE4HSonfmMlIQ4iafWZ?=
 =?us-ascii?Q?R8jyK60hLCoLW/0Etr+0dPJ1TGjtEOJqR9aE1YDyaToIErOq3iQ6DRm1dFwG?=
 =?us-ascii?Q?QxgNbCiUamIIPq9q4DVw2vV9E2GrbP+kt4cpOYpljE7fwiQ2F4H5KJY7e7tb?=
 =?us-ascii?Q?6SnimH4zEtmDVD05HtP4y+6w+0FVfq/rehB9iLLKKgC3XxDS6U44UlIz6CCb?=
 =?us-ascii?Q?pzebM5lSvlN3z7SXdJBbZNSLRa8plxgT0hPA83TYuuxJAtFlLuP2MhLzRg4x?=
 =?us-ascii?Q?0eAJE8Wyx/TV4A7LSiRk3vkrtsM1ihwR1YqugxL7jyJEG8ZakObOs8SURKu9?=
 =?us-ascii?Q?l7jHheAuA1PMj5Rs6+d63VIJoSvkYSTZYonfTGlv0ngJ9rPX+QddtZs+rFfH?=
 =?us-ascii?Q?iE+Yfx5TSViGjaw0vmqpkBTYu4VPFB35a4Mz/4QmX1Ogzt53UvOQf2eF4w8D?=
 =?us-ascii?Q?7e64sTr3yrW5XhybKyKkV8rDYwe+1sHJbfazVObbYDULnlKq++ksNoisMdVY?=
 =?us-ascii?Q?iHjSC7iwqmfRoPkhssperz7UF7BfUuBI3QsGGCNP/r8R22r5gWzLyNxRhCNZ?=
 =?us-ascii?Q?vvW/LV7L70xUDZwLffg+IOjPJDXffxDjZbJwBt/yPqh7c7v7Q8cURBvhaKgG?=
 =?us-ascii?Q?WIpp8sLZlZc5dx9x//KwzpkGEFP3jneolYlhMfkUgODBj9xacbSS+083mXK2?=
 =?us-ascii?Q?KH+rZFVBvWqEMbHhQ5aCoSsl4035YKLd8QQP1B3j72yMttmScjEAofndxDbb?=
 =?us-ascii?Q?vNXE+i0n1f8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:19:06.2636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c4f50f4-14d0-4e87-5055-08dcf479dfd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7871

Add following bits related Speculative Return Stack Overflow (SRSO).
Guests can make use of these bits if supported.

These bits are reported via CPUID Fn8000_0021_EAX.
===================================================================
Bit Feature Description
===================================================================
27  SBPB                Indicates support for the Selective Branch Predictor Barrier.
28  IBPB_BRTYPE         MSR_PRED_CMD[IBPB] flushes all branch type predictions.
29  SRSO_NO             Not vulnerable to SRSO.
30  SRSO_USER_KERNEL_NO Not vulnerable to SRSO at the user-kernel boundary.
===================================================================

Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v3: New patch
---
 target/i386/cpu.c |  2 +-
 target/i386/cpu.h | 14 +++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 690efd4085..642e71b636 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1221,7 +1221,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, "sbpb",
-            "ibpb-brtype", NULL, NULL, NULL,
+            "ibpb-brtype", "srso-no", "srso-user-kernel-no", NULL,
         },
         .cpuid = { .eax = 0x80000021, .reg = R_EAX, },
         .tcg_features = 0,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e0dea1ba54..792518b62d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1015,13 +1015,21 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
 /* Processor ignores nested data breakpoints */
-#define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP    (1U << 0)
+#define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP            (1U << 0)
 /* LFENCE is always serializing */
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
-#define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE    (1U << 6)
+#define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
 /* Automatic IBRS */
-#define CPUID_8000_0021_EAX_AUTO_IBRS   (1U << 8)
+#define CPUID_8000_0021_EAX_AUTO_IBRS                    (1U << 8)
+/* Selective Branch Predictor Barrier */
+#define CPUID_8000_0021_EAX_SBPB                         (1U << 27)
+/* IBPB includes branch type prediction flushing */
+#define CPUID_8000_0021_EAX_IBPB_BRTYPE                  (1U << 28)
+/* Not vulnerable to Speculative Return Stack Overflow */
+#define CPUID_8000_0021_EAX_SRSO_NO                      (1U << 29)
+/* Not vulnerable to SRSO at the user-kernel boundary */
+#define CPUID_8000_0021_EAX_SRSO_USER_KERNEL_NO          (1U << 30)
 
 /* Performance Monitoring Version 2 */
 #define CPUID_8000_0022_EAX_PERFMON_V2  (1U << 0)
-- 
2.34.1


