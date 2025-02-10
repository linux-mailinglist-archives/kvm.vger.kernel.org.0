Return-Path: <kvm+bounces-37686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F5CA2E78E
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF75B163755
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0A41C54A2;
	Mon, 10 Feb 2025 09:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TVn9VmnW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3591C2DB4
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179385; cv=fail; b=ivFXZ7pelslx58tqFxKhLSyl/94TfFF+VwuosMkUhmzpT8vgSGEfJIxKmXZaol/T97IxgNCxPO246ZJfFYE5q5phYn7gtK5iRqM+mB2CghKxfVwBhwv8tqAcCbHC2IIun/mNRTQmRCBFYwOQl0rbW6uZIZD0NhIsbKL8Ot1Q17Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179385; c=relaxed/simple;
	bh=bwOvIHlmi24/nDW7fOz0kCsVaoTCROHLh6w6mMolEeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9Dwh/NmeWGnGrJO3Ysvtt15KS9XTlgRaK5TcuuUGoFGZKqMTQEEg0N03ovarUAUndQaVfCpbmynSuvc/LATuR7p7zRGig++X2ihdwKIRbVgs5w98YA17vW7QUI2iFzOfMWiKPIr2Ts3bI4IE5MaFgudDNL9tL2lEVd/mfxnlrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TVn9VmnW; arc=fail smtp.client-ip=40.107.94.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBUSfxcW/KXc1aFmZuD0lAJXJN5wP3UQXoLbbeE65WnypiKkBFjP+7TRXIjODX3A8roit/1+lQRUSlcFbUs3BisWOV3/+Q8ULEs9odIFp25eAYI+rbX2sTFplWqJex9vo+iBqlNcI0nSgJBrRHk9j9TQ3Hru4w+hXIOsyJaDhFjr5hMfqRiXp4T1943tKAZjLf1H1Mdmzfv6Cdbli3CFrMADUBQNx71/P4mq3mJbbDyhjQwGkdW2FT0PVya98FF9DLlzgHa4BUEBHbRFJO9suP3hQKbZBKABK+RqUhvOYIzbINzL5N8fwEQaqTXLsszyPjsff5c/ZeVxRjYXgjWqAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1SbuF9/gJKIs8T4JEEjbonioNx7y3Pu4NYO1pSsUqY=;
 b=Ap25BICABVdVDghmgDXC4pvwSD7aAv8tBEH/mchmqlbQHQVA6JZ6Rr1RYjnlmX1ZJyqM8QWPu9DJEnPjkxonW/1guu9GUAAGHLvTEksruUnWmaOpa6slcOdsiyIixaR5AnIWRZTVTngXBEpRvqzxmxofIaULPk0OPiG8ZSwW8hAmb7/i5lQ4GA6Mk8pd81KB1ke0qOguLDUnV60zzzEvQ//Odhe7Nma06D7TJNfpyOi28LQjxQgdKmIsivm8vlV4aOdlM2QjCXsH+df1oHU0R/AJ0YU9UXf/1M05VVHH4p4+a6aFRId4b3t1QyZnj1sxQ0u01zCeTt13MeUYSBPASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i1SbuF9/gJKIs8T4JEEjbonioNx7y3Pu4NYO1pSsUqY=;
 b=TVn9VmnWYXdUVlW41oLHove2533SkCaBaajtOjVd4l4a1JfVdzKDMoN4Bk6oggGF+hDzdYUkacVUz1HXAyG1ajJla0ur9+JWvqqCsSqvqiCW5mWDI+G1VTtkGv32fis32VSDc3/1apLxWOkjP5gLf0xxtAZIBFQpxYUyF8hiztA=
Received: from MW4PR04CA0152.namprd04.prod.outlook.com (2603:10b6:303:85::7)
 by MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 09:22:59 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:303:85:cafe::8e) by MW4PR04CA0152.outlook.office365.com
 (2603:10b6:303:85::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Mon,
 10 Feb 2025 09:22:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 09:22:59 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 03:22:55 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v2 4/4] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 10 Feb 2025 14:52:30 +0530
Message-ID: <20250210092230.151034-5-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250210092230.151034-1-nikunj@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|MW6PR12MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: facbd363-8aaa-49c2-6901-08dd49b482dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i/p1Yt4N/4wmDClqCLqN2kZkNqB0AwyncURMxWSoAt2KpKJCDONuMJ+lcKiu?=
 =?us-ascii?Q?31aMDSE97nDgr/wx0BLXH/jL+erpAHbrbxm5AYyC5lnVqLhLr6sC9gCY3Pg5?=
 =?us-ascii?Q?KsKuLrd5yuqNEUixPvV+rlYJcKBgvzEDTX/2VJ5vOQ05x3u5BkuUUAqVEHeH?=
 =?us-ascii?Q?TRbkFYGcKcdQLX9H99h8k581VWFtARHAZ87pb/EEyVx6KWkwHRU+Tff++zEA?=
 =?us-ascii?Q?ejP55JOiucMuiLCbVEwpJlHaMoqD1Sq4dFLOIlyPPTt/L4ZwBx2xFQlq8Arm?=
 =?us-ascii?Q?4nXgoxpd9krX3MpnbnOmc/t6kJW1BzFeJwuYJ7KEWP8FbcFO4XHyrlbQP90o?=
 =?us-ascii?Q?SRJCesEO6MYROTRtLKbPMRIluSybmvkHMiOr1+E1mn0D2zvptsvOAit2mep5?=
 =?us-ascii?Q?t3uz4oK51Tekkso3/hr6W2z4PMAJuBQtTfGciHm3fmvrwvse+0QSWnE7uZr/?=
 =?us-ascii?Q?XDBvBtstHnam34+cnNJ4nwtKfJ7RGORZ1TA0XWCwICPrGXTuodmK653G4bL+?=
 =?us-ascii?Q?UJ5VOeQ5SnyhM7PZ0cbdMoM2jt2WqQmWOe1vk6NCbU/ZX14eflKYPsadmZF7?=
 =?us-ascii?Q?CxzmMJYeTgtS0X/yQLyKXKLpi86FDOPtAP+mp3yG1sOgzIE9be6/mGlnvUQR?=
 =?us-ascii?Q?j8vCaBwONJslN4HMwT+VcfWxAQnxETrSjL7DG6VYj0KGaCMdNCoPy+t3NopU?=
 =?us-ascii?Q?P0SUmviySJtJ28c69I7jrUtvgcZbFsDapj4iLlJAgkUcvU2gBSzB+6J6T11A?=
 =?us-ascii?Q?8SUNb8goJtHTz0Mn/YfQYih5tVOsG2fLuzKvjniChLnwc0ALTBl3XY7tm+gp?=
 =?us-ascii?Q?U7iCthuIkQJ8+IpqY/XSk5b8Pj3x2LCzX2erU9sl1KlIlVhcTNU0lnIBLXtS?=
 =?us-ascii?Q?jHPLQBR7z5x7gzj7xrpb4ADfIzjCJz4MPmjkVO5c43SQywH7XQqFrB6E64bj?=
 =?us-ascii?Q?9D+kKqwDlf7+DTLE4G5wveG+8wxETcKtkWf1tMQFpQfBBDl5dRoDmd3f+nb2?=
 =?us-ascii?Q?jGxcHC6tyY5WciWQF3j5KEBho9HbHxXL840H2ucsvgJgSqm9t/tAc4ac01dQ?=
 =?us-ascii?Q?iQVbbYeNLMhodVQVq/BN6nb5T0P1rX+BftMLf0qV3cxj9pvSya+z57ZYS9lJ?=
 =?us-ascii?Q?fXersY4Tg+jVNLLhGnMCf/KlyK5zBwiaaSRa0uIEOOyZciyN1Mllz1+2zgDq?=
 =?us-ascii?Q?HRbH/HfZwdzPAQoJ2x0I1Sb9ccnFN4YTEdJzED0a9vZK6OdDnOhMB/eNYbrl?=
 =?us-ascii?Q?V1B3FmsNWtnw6TWFdYg5ym3Xf5+N71tKrP++W1/n4PcXLWaoPX2TLFJdWSYK?=
 =?us-ascii?Q?HA9/vKXnrUpq51RYGjQunn8QDyZWFsO/6kEo2ZklJDYbvhQNLXw1UHR3m5j5?=
 =?us-ascii?Q?R7wN7+zZXSkWFxKPuFyCcW3mOz+8RHMBlHyHofqVIvU8pHLlBfmn23VBSZ4/?=
 =?us-ascii?Q?z9LuiFc3nMaXIVRvxgVyyGs6Tn0/Z1FFA8AAdhfzQB4RGWVpIaOVKWQR5iyf?=
 =?us-ascii?Q?VKmE5F4jeg/rrME=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 09:22:59.3405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: facbd363-8aaa-49c2-6901-08dd49b482dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests. If the frequency is not
specified by the VMM, default to tsc_khz.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 20 ++++++++++++++++++++
 include/linux/psp-sev.h         |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..8e090cab9aa0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u32 desired_tsc_khz;
+	__u8 pad0[2];
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0a1fd5c034e2..0edd473749f7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2228,6 +2228,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		u32 user_tsc_khz = params.desired_tsc_khz;
+
+		/* Use tsc_khz if the VMM has not provided the TSC frequency */
+		if (!user_tsc_khz)
+			user_tsc_khz = tsc_khz;
+
+		start.desired_tsc_khz = user_tsc_khz;
+
+		/* Set the arch default TSC for the VM*/
+		kvm->arch.default_tsc_khz = user_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -2949,6 +2963,9 @@ void __init sev_set_cpu_caps(void)
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
 	}
 }
 
@@ -3071,6 +3088,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..613a8209bed2 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_khz;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 
-- 
2.43.0


