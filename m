Return-Path: <kvm+bounces-25324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11ECC9639F6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3726C1C226CA
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A8014E2CF;
	Thu, 29 Aug 2024 05:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kbpq6CGB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C714D2A3
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909897; cv=fail; b=SS0ZsNupyCfnbCy2x+V58Yl3kxKg2Ogqn0XFEjVDWuooXFloFds+g/0ZZoW3vW4NRxnJ5O2oUodXjzyHkLJoCCPpBBoktG+cYmbaHaZMm0HVw50xEbBqukE3Rso702Jmr0TUXPni+mXPWihaVVmcBzYNhcr/d1vDaZufSnd2QaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909897; c=relaxed/simple;
	bh=2xR1besw5EoW1eMMuNHC7i90OGP4FFeTnqpYwRa/W0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFv7f2V5P1+mG91j7B7z9GQuE7f/b7H2SnXWImoLJ43Bnuv2SSiS7l2NaZTEdsFMfe2RYHqwd23fz5f/LU5unJyR1fbbro2/xM5iXl8A3bZa64uwcMHKMQaSr7FHXdM+BJkc0kHrVA2WomYp9w6nzUCuv2vxAcgXJyavxIO+UiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kbpq6CGB; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inIlllEeg3Ah5l/26w0b/meoq611zxhZ1sPqYEghlOgUckd3rV3ZFSkrlxsP+B2BST5Q7MzuiQH80N1E0IExdpbK3JkhruYF9BUoCpBq6tRxSjCv3Adk8LzEpR2t143SY9sW6iX4ItwedBSBEeF4tqEMHUYuiDyhmiz6psLYB536t5MmrxYUahoJ9xO/g6vkRBHHnq9/lYRzrSeWFQ9ezBTyTfJ7JL4yEdB3wdluNX4Gq/2xcVdEW7ar7erqIKcqIqFRekWgC4/jP0Ivjq39RWxKQovV0foEaNrckwGb/ARDUNiCyQnx55I4mD4PAW+OprfueLa2CYzBEI51XsntHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAsC8cD1AneYWipE6siadLzzF6D2JNgtCebvXFv5GDQ=;
 b=B5AlHs5JB0pKpgAPtaEe6CoiMx1GxX+1AS4AP5rmn95R0BP3sbN9cFi0NpMbBrSTJAl8VR+bfcFwoDen+/B54sQvbFwBS1RkWtgHPOJgAOA7fHGPLJvF4niAcJb9X+AgP3dPtOrsh+wM2FIlzQtya+R2+Zc6MzN6AXCdVqhhUS6PwvESV12/ZwaUocB+V2QnOQNg5cLvCYcBi0ERVc+wBLmr+aPIa1sfF8UaRKlg/D8xvQH3C+pbMRaDys4nNM2Id9YhAEM11fEwiUrJkJ05snUITH7MjfCBuoXlbvc2dWjAYfqxqzelFurGz6N7cyJgtlvnTz9GATOaaBYIJ8x+aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAsC8cD1AneYWipE6siadLzzF6D2JNgtCebvXFv5GDQ=;
 b=kbpq6CGBrpn2O+6JZ8unjDpnRWdYCTpnmK5B376nZrBT8NpUeVjt6U5S/UMDmOsnIsV4SChCkBgvEFMDVnjsGKK4Ya7RXfOZF08LDp8iUEWPGj//dga7tTsrcevHACLbOx1J72xdTDMyz8pMhWPDmOCTzf0E0WjjR5GI/hJoFY0=
Received: from SN7PR04CA0087.namprd04.prod.outlook.com (2603:10b6:806:121::32)
 by CH3PR12MB8934.namprd12.prod.outlook.com (2603:10b6:610:17a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Thu, 29 Aug
 2024 05:38:12 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:121:cafe::64) by SN7PR04CA0087.outlook.office365.com
 (2603:10b6:806:121::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:11 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:38:06 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 2/5] KVM: SVM: Set TSC frequency for SecureTSC-enabled guests
Date: Thu, 29 Aug 2024 11:07:45 +0530
Message-ID: <20240829053748.8283-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>
References: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|CH3PR12MB8934:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d04e5ec-ae0d-4888-78c9-08dcc7ecc554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e29pvxPdZcohNQPLDz+vx0ibNQ1cr8SYTQfeM/nH/c4Yreu5Ti6+/K9AqsKJ?=
 =?us-ascii?Q?CsBHmQYSIPjqTxffoXzAahz7xNZKNd8LL0Z98VLdAUFxQ5SYcMhSjU4ZTqhK?=
 =?us-ascii?Q?Dr5rnFRAwHxOAMRMNKKs9t2bvzIB9Il+0ol/J8nd2ns6RJJ4nR0woFWbnASG?=
 =?us-ascii?Q?Al3PPiwOxcJlOFUeDtbi4Cx9dm67xYxJKSS+NRJnmgdQFU0z6740wLFhMUq8?=
 =?us-ascii?Q?i5c7SAEfjTkEylhp/or+iN1ioWBXNFGKMHrXMp8J3Yco8WhAYRStdP9XC3V2?=
 =?us-ascii?Q?4jiv42Xh5XuPdzJehiBqt0JAA79OmTcvUEjZDe6AVHZIVw+vPvmf1c79PfNM?=
 =?us-ascii?Q?3s9I0iGtl2kowDq+UH2kVoeTCFtTq/OMdUHgWDTRnAfi9SgKLkC3dQnFIYGO?=
 =?us-ascii?Q?bXuTL4cQSPsPKc1EQHcUL54vU5Hgqig236BZK3FcewWDLx52jVVa+sS91g+I?=
 =?us-ascii?Q?l9ZZEuMJEUs8eWYYMJ+n0Ct7miq5wipRXuvTVzNQ4W+evPrVYCIKoyRvSTPT?=
 =?us-ascii?Q?/zQ9h1tv6KztMcLlzhvReS8kUMKfPtkauYHeGUqcumFGqBqQLNHqpH7imcIu?=
 =?us-ascii?Q?txZNqgdlQIByjFA+eVyQzC3amf6HwZQJh7ryFOknNZYNIz1a4HgVJP1BgdwL?=
 =?us-ascii?Q?2TV/BHYfD6UbpxwHqjW3XRlRnXl7WelkrSqtGHF6VcTtMZyo3JJ0l4N68g/U?=
 =?us-ascii?Q?6tzdqs9T+is/Jh2NepSAYi4OPRu9uaHoc0jMNVnkw9wfWAxfF/SneKhq5prI?=
 =?us-ascii?Q?/e/b+KP1gXQGq1TcpP1VJ23xeez/BAFlBp+LY2qDzm4qwjAV4wu75618tMM8?=
 =?us-ascii?Q?Rd0ffFFNHcfJxPdGfeB3rw30uS0mBQ34k/CPjXiA00B+3TZ4TExPaiJFhR7H?=
 =?us-ascii?Q?JLN2JKeM89UtPdjYIJJGu9xNK7mpkxMyOTLRSNDr2abTDp8cRB81p5W7s64/?=
 =?us-ascii?Q?KB/4iJj/voLlzplhHXs73kAlwRX7Q+pFwxy/RtTLpPAFPeB8RuO34tv9N9gk?=
 =?us-ascii?Q?Uh2vaGzRGpdnDx2MM6S6YslOhK9ZYoMA8YxGsAsAa+lK/7BjmuORXdIbKIie?=
 =?us-ascii?Q?m96xlNU/DPn8rPpwu/bye35R60Y7zR2vu9peExii1xgtKjuerNTH8AOCiuS9?=
 =?us-ascii?Q?ZXjwx+G/XJ/9ilDiunS4vWmlM9jDGLJxDXIdQHpSvBd5Pq3f06V0rDrPalRF?=
 =?us-ascii?Q?bKXmC9joOVqRzrDt6sxQiQBSSVFlFZneSlaKN69DpS7zxW94Vtn04GcHzuiR?=
 =?us-ascii?Q?vZFTYoebanV2603qGYwb3iUNx/kl7JbZrLFQwweMgqPZWDs/ko1mad1Ek8EW?=
 =?us-ascii?Q?X8B/an2c/VuNoAyeHSRY+WBCreEo7IpWrJxJULKLQRz32+d/cFoPdH0qvMCg?=
 =?us-ascii?Q?cMZOZ9BVuJQk8Zw812qsC+fvy839RpMiZ1yAQ1oDY4VMR4rJISzNupk7q4Hg?=
 =?us-ascii?Q?ME5lIQT+Ygj7sjD5jfYl0Zk0kzZUQR/H?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:11.4124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d04e5ec-ae0d-4888-78c9-08dcc7ecc554
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8934

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

The SNP specification provides a desired TSC frequency parameter that can
be set as part of the SNP_LAUNCH_START command. This field has effect only
in Secure TSC enabled guests and can be used by the hypervisor to set
desired mean TSC frequency in KHz of the guest.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/svm.h      |  1 +
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          |  7 +++++++
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 include/linux/psp-sev.h         |  2 ++
 5 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..2bb9be9b2d30 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -289,6 +289,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define SVM_SEV_FEAT_INT_INJ_MODES		\
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf57a824f722..c15d7c843bfd 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -834,7 +834,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u32 desired_tsc_freq;
+	__u8 pad0[2];
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 714c517dd4b7..ff82a644b174 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2212,6 +2212,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (sev->snp_context)
 		return -EINVAL;
 
+	if (snp_secure_tsc_enabled(kvm) && !params.desired_tsc_freq)
+		return -EINVAL;
+
 	sev->snp_context = snp_context_create(kvm, argp);
 	if (!sev->snp_context)
 		return -ENOTTY;
@@ -2232,6 +2235,10 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm))
+		start.desired_tsc_freq = params.desired_tsc_freq;
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..262b638dfcb8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -378,6 +378,18 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+	       !WARN_ON_ONCE(!sev_snp_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
 {
 	return svm->sev_es.ghcb_registered_gpa == val;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..fcd710f0baf8 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_freq: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_freq;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 
-- 
2.34.1


