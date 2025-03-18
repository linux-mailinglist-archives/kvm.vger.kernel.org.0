Return-Path: <kvm+bounces-41346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6452CA667D8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2278F177380
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 03:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33211991A9;
	Tue, 18 Mar 2025 03:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wLUYTC7/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C684C6D
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742270052; cv=fail; b=ISgToPUI8bCEXbG+PVBZScvg2URRDTNzi3ikdR+zAFpGjV3JEpP2jXRupXnDI1mD+Qq4vel+IrSnWV7GZSTwn5C99KkfV1SewMQVun9c4y/6v//jEh4sshtNL3zSre/M606NajVSzGWgE54mI2yyVkcWJlb5gEDeOYwFdYlPMO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742270052; c=relaxed/simple;
	bh=On10WzwH3dYQAu71r1lrnDqPBUcDHM8jTvXfuoT9FUY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiddIMl8RaCOCz4QzjkDurBpoAnHKoyzAy3MUfPWjInjulQiCXlr2sn6YjuO7YiJfEoqe1CjRtpiDT50ILIaMCIiNcHycITdhrIgacrsGXtJFUa1VENArdnOEFsY4aAFWLboG0R4eFOCjeaqwjdkK5T36H05pHlKZrTemBQuHC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wLUYTC7/; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHiM4Hk/DdHg1gzuN3QKF1EldnBqOQAtUqtHrSY3jBlwDo5HGxr5vR6v4b+38f3B2a/zvut3x0nEqwBx8wGqjiv+dTv+CKRKFZ/c8KCNtNzSypNb+yEJDvlim/WcgIgH4uny3J4U5+WxeL30FNQzG6MdOqN+KVlBr+cEIDK73KbtXsKZm7tOJqcxoXIWBc69AXTuA7g6ECQm2eLg2O7ecB9CfVkjX81uIIa5wstMsxZPJUTCVaTOXhQLAyPx+63zUTdrT7Y8lX2rZGVFpvseVq/GU5m8yeD2U95TL4G11Feu4S/w53oi/ytRSppS78BnCyhCD3k29e25AqO85dowmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAjDt2x7pDWzmxmYzoUpNKPyYC+WUsZf1BSxl1Hub7I=;
 b=wJgaL6FtbHWYa9dzioRiRCnJhfOl5AiVtPQZcyhEIUMDlFH5RJo0210R82dNykuWCzryodnli0DLmtPcWVbUMdpE1a2t3l6QduYrHIAllSDmO8QpckkuzQxZ5uHUE4dgv2LpTXK7NPNG/gipf4e4q7cC3sYONB3ZLZS6HGvNl2eA/mWs5qX0e2GBCPT/IvpAEzeLo3w+1fpy/C8HuvmjB/bxyQH10ZwwqT4g21QB9zsR5gAB9sBYyDmBBlOs4x5mvNbOqOFdEE2UOa0AT3g4oX+0krpLPTziCosToZ/Gd/dq6HfB/tO7k0UADYTt2IuHY1WeIAFBccWZ6aVb9CCcmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAjDt2x7pDWzmxmYzoUpNKPyYC+WUsZf1BSxl1Hub7I=;
 b=wLUYTC7/HJa6H2T+kUM4pbVH1fALC7fdVE9o6M6OgRb236IYBOXxVYMpIb3qhvB32vBGUZkTPyf1nVj5K+H7o6lR9WR3StvuYkpVUnqAe2oiTHG/3ywKjOJL9V2xIhudRo1lhJ9TYui48v3k5TWVYDfxJu4ZgTUKqGV5FSIu2GU=
Received: from CH0PR08CA0024.namprd08.prod.outlook.com (2603:10b6:610:33::29)
 by SN7PR12MB7201.namprd12.prod.outlook.com (2603:10b6:806:2a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 03:54:06 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:33:cafe::ed) by CH0PR08CA0024.outlook.office365.com
 (2603:10b6:610:33::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Tue,
 18 Mar 2025 03:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Tue, 18 Mar 2025 03:54:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 22:54:03 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5.1] KVM: SVM: Enable Secure TSC for SNP guests
Date: Tue, 18 Mar 2025 09:23:51 +0530
Message-ID: <20250318035351.554191-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5a3e7266-30be-3549-ea53-ce5d885a13cd@amd.com>
References: <5a3e7266-30be-3549-ea53-ce5d885a13cd@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|SN7PR12MB7201:EE_
X-MS-Office365-Filtering-Correlation-Id: 525440bf-0928-40e0-5aa3-08dd65d087be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hmc/UwQSxX1oejBVO2b/aKJV1LfL6kgJJliMV3OJKK8WOHF/OxAjlNO7/GTF?=
 =?us-ascii?Q?u+pBrf7YsBbvmHKUFuoxCTRfZXKf8xyNNq3JNLHjM5pfrn9quyYCvOGarUrH?=
 =?us-ascii?Q?N1i185BCqW2ITBIc1TVb42Gv8ppj3i2jAkL9MnljrrSlKI/H688mlcn+lmph?=
 =?us-ascii?Q?A9p8dk/m0eWT9X7+Dd+Hrhv0uS5DY80E2lyQcqN6W93WEh/rxh2Rz8/9EPUn?=
 =?us-ascii?Q?nQ6KZolTor3//kQtKXRX4Pe4ViR+5QxVtu7o1JdR+EORoztH1KIzMDGAwNeJ?=
 =?us-ascii?Q?Oo3cJSv51mESKZaNcyYy5L4eXM3UAZsQ8kI7flKhM1rS1p1/BItTXGrUlSXT?=
 =?us-ascii?Q?pmFiS0OoB0XJFHWfyZw4LqwfpsIpwvlMOIJID71yuaNbNJLobWye4jpxODz3?=
 =?us-ascii?Q?2TUGs1ZgHz1xzAM2JDkTF6ZwYj2iCo/iA20lT1PBHdMfrL/ptgmJNdeoZlg2?=
 =?us-ascii?Q?JXG6hm+AJJl5iQiDNKmXpHVNbDtgNnTXUkHAsimUBFfX5sD34b2UaQapB72o?=
 =?us-ascii?Q?rVCWuqnZvGctz/LEYTexm/90oe2JfMIrgXe9IFxpvRpoypK+4SCRa3C/euhb?=
 =?us-ascii?Q?xkeAE7OxoYCVlJ0B29mCElATt0MueEGwM+8MWfVX6g6PCbUGuIPYVPFndu6Y?=
 =?us-ascii?Q?DjhLmqqmf6wD1kJLjXcFKWZbaKoJlXkSwsUrR+EwAwRuZrvDrAWLBudgASfD?=
 =?us-ascii?Q?6+SIggWKIBsp5UOM1Wfk5R3hVEERgXyRwZv5gKC4f1W0xeFEenBGmJ/COn40?=
 =?us-ascii?Q?5hCrMetfawPhcvt8psGA+rf/XfNDJOVU1G+4HvtS5EE32ZIooLv4hYtjbE/b?=
 =?us-ascii?Q?SKWMTHAL5G2pqg2LGfUPo93J4hqb/cjhZVs2ZqBJnGI34CQ+YuUAe0TwKCQ0?=
 =?us-ascii?Q?89ENV82lhShTt6uGgxGC3LEvFqxqudguqBSY5o3MvOOOHQY1HRujvTxa+MN4?=
 =?us-ascii?Q?/Mrn8UAYgOjcbGTwq3tHtS5Nj1dkazLhuClTcaT/yHmrUq3rQt77NFUZReNr?=
 =?us-ascii?Q?z6OopjtKh/W91SSyUmxUtsb96pe5zaY/g8/tE0/VwrLkQBTXc6J/njYdXpQY?=
 =?us-ascii?Q?ZF8DjZvd0Wr1awBQH5eZ8t8KCZ0vkOOz1IJGD218ci8B2V2eOoOvzI7wBz42?=
 =?us-ascii?Q?2iJo804ech+STwdxuc4ob4+N+ocddug5zLWsWZ0gd2gagKFn1x1JZZkFBgxz?=
 =?us-ascii?Q?9dS2699NOX7HgtSA+QdmV1gjSN0NK2/yvsoUkw2iqw/uHULJUR8FXiXBLKJe?=
 =?us-ascii?Q?0envn+HqXg4s1QOdW/FbMFL0mQABsV1gMAIvfNiN5KGsOAerOGOJIFNpcPUm?=
 =?us-ascii?Q?R2YlPZfiGRHhnnovJhEasvU+NclTnDEZ35p+4aF/k6EpeB1bnvPVwCdOMNvg?=
 =?us-ascii?Q?zfTkB1nXtHIs5K8ByVoQEyFOPGd8ZnvWM+myaGvn7OFVJ05IJ7Oh/1fEqLl6?=
 =?us-ascii?Q?cx2s5jVgIUUG/OLVy/kvGgC95WgjCvrIG5GgH9Md7Ag4ABP6XNHlCbJen8qG?=
 =?us-ascii?Q?KujnkUOJv24HCLE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 03:54:06.0855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 525440bf-0928-40e0-5aa3-08dd65d087be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7201

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 15 ++++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9e75da97bce0..87ed9f77314d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -836,7 +836,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u8 pad0[2];
+	__u32 desired_tsc_khz;
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 80a80929e6a3..c33b3bc598a7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2226,6 +2226,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		if (!kvm->arch.default_tsc_khz)
+			return -EINVAL;
+
+		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -2466,7 +2474,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 		}
 
-		svm->vcpu.arch.guest_state_protected = true;
+		vcpu->arch.guest_state_protected = true;
+		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
+
 		/*
 		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
 		 * be _always_ ON. Enable it only after setting
@@ -3079,6 +3089,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0


