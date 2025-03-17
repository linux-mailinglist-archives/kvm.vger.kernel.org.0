Return-Path: <kvm+bounces-41163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C57A63F8A
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 06:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1A6B16E279
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E62D219315;
	Mon, 17 Mar 2025 05:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P6pG6ksN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA012192FE
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 05:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189017; cv=fail; b=XrvcFI72+u2al/GsQEid+gcri19GteXRYlpSdYEUJ4frCaiwSix7hxsGHa7RR6frwnpz7kfftNnNa/Q1SO0nY/k4K1Ze5FzCXDpkLpfl0jHky2uyJziWGlYkAl7x/iBfz5hmb1SKOH+Yr55qpS3ujedzD44HPCbSOjNH2HlAS4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189017; c=relaxed/simple;
	bh=L+j0mICvho2cH89udWEvNx3OeDCj4z0Iys34gCGJugc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCNZ+at7Vyxwck20ZX58EIJ/2ATGUiIAb9vrjBru32vFktxeeUkusB4Zo6rFW6+oOv4yz+qbF7vXoBN0VlHj5puzFOgRVzpHAlP2W03ge4BVHdIaKIQqz+ejM6qHhNLR/ZDP+L1cdpac+8BPqInHlujvPNpLFaSu5jjxCuA7B7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P6pG6ksN; arc=fail smtp.client-ip=40.107.244.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XOOHI53MfMNAzhxplbSmrbCq3cALcowNaQhsZGmtKZWnnGmEa9fn17dIZgowEvTIi8bpbPW0Hf1h4/dkDHDC/Yt1hWThCFWFUtWwuixblX/JARDA0KOJQSsMWUnbn9EV6mevPn9HIqcBrsxffeXh5pOPV4l9DyDq3ytLH8n3YzY2qZZ65xxNUuekYEyfrl7CXtVM3AQ1EgzEa7EItorVOOKHBr3zl3BQkZYMvAM+PLtlaVoA9sg0y5Gd4EEvMu6gvEw7LWl5jlNssXmvJh5PF9peMeQTmIwHaxKNjgcL3KuMza9tsNgVLV3cO1Ady7jQZ7JXGzuwB14O6SyOg6Zhyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvN5ncm/qCjwOIIdRNldezf/Pfmlh/JE2XxX5tGiZVI=;
 b=SGYfd2O2nwrc/EoAm9/OmtVlDdHEY+2UeYtmMXATCTYeAM/urbTI6P0Uwc7N2JYvr6t2g2/xMvHILuAnDHMC3bxgzvYEz+LRRfFcPuSgRDcLNFjvlb31br1lwwH0B3M5JXadUiZgi7Md95wW2gJ2/WDhq6K4Mh7QZ19UoUos2XpQyVUP0Jlipu9pUuVBlXcavjOtTD5a/pmUfLPeAl/+T/yHLwSMIJZz4oSx0Q2RN41mw2AbBe5dI/2V/AeZNGUMemyshNgqYbUYopDyvsvqXcuOp68BU9sETWzYRuyOBoKMMG4PS809JJCHdxsYc1J7FGcz/kXrPUzrQTOQd21JQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvN5ncm/qCjwOIIdRNldezf/Pfmlh/JE2XxX5tGiZVI=;
 b=P6pG6ksNCoDWv1mJyL+1GoLz60EMvFQwRe7s+k3bmq/EddbiDI05W07H3CCJuMbR6RfD6VVJF59riM0HAzMvZe3iyX3Ef9X2SgZjJkyPMYRRoKZ+rZCFUkznaMbXZ4kN2WM3CNQ+SOxRsyp+1mNaGhGSsezNCsrPNjGelBILebA=
Received: from BL1PR13CA0282.namprd13.prod.outlook.com (2603:10b6:208:2bc::17)
 by CH1PPF0B4A257F6.namprd12.prod.outlook.com (2603:10b6:61f:fc00::605) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 17 Mar
 2025 05:23:33 +0000
Received: from BN1PEPF00006002.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::62) by BL1PR13CA0282.outlook.office365.com
 (2603:10b6:208:2bc::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.30 via Frontend Transport; Mon,
 17 Mar 2025 05:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006002.mail.protection.outlook.com (10.167.243.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 17 Mar 2025 05:23:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Mar
 2025 00:23:30 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v5 4/4] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 17 Mar 2025 10:53:08 +0530
Message-ID: <20250317052308.498244-5-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250317052308.498244-1-nikunj@amd.com>
References: <20250317052308.498244-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006002:EE_|CH1PPF0B4A257F6:EE_
X-MS-Office365-Filtering-Correlation-Id: 60249786-cc8f-4cfc-fb73-08dd6513dc7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s8G+QPx9bH5bmS07BI2WHrkvZuptnMYKicHzQGg7sKIMfHaGfh5+UZQ56Vlb?=
 =?us-ascii?Q?IjAm5Nez3HgLU40B0kL94AXiZ+ehgr70F5aCKZzuvwCOPxQUWusH67blwuMU?=
 =?us-ascii?Q?pFjzmqM5e0q7DDztlikfacmfS6DtLcj8w6RBWw1UaHzFxe7m+O5ygPL/XwcT?=
 =?us-ascii?Q?4vrvPr/4Fs5cKXTCbFCVq8E1BxLxNvZ0T9yNLp2Cnxgw0DHEbPCGZaqATcUY?=
 =?us-ascii?Q?rR0R63imwZnFhH4HBH2ZhGk9qcn8Zv3aMi40MqLNckeBAkZVS0HCUjc1kF4/?=
 =?us-ascii?Q?6utuD4HIQT7TtsxWJDF66sm2RYfsSpFzIm2exDDVxtxAhrgfxhI3oXJtaCcW?=
 =?us-ascii?Q?93gxH1VwcC4VwTFaX+U4TW/Y3HVU+OnoL3uxeUHPfKtPptghu0UMEmaSeCUE?=
 =?us-ascii?Q?JAZRyQv9mvANqdfe+eie+l2mdeuIe/4WNweRC4acIjo6cX+mPVTItIbSoBxy?=
 =?us-ascii?Q?gfvA16JFEp0E9WJHk6W++Xhamo7j/FDA/iZR7c/uPEJ0oCByYVCDJH6btmYV?=
 =?us-ascii?Q?kgtALKNiE99HdjKZ8Bt7/rIQGAiPgdSETPIYfKU6b2Rn3ObDrugEInC1xO+T?=
 =?us-ascii?Q?BX41vMzVrkI3Wt3mCRuF1ukxnxtW/bIQ39GE8q77rtxxUMtLBTyvV3bKcGun?=
 =?us-ascii?Q?KAolNfQTQWOIr10IDSK6ZK4CRN3I669byM4Iv8oU2gvYGh0yUFtdfY5Ai7J0?=
 =?us-ascii?Q?OlOOvMXwxfAMOMHyl9Zwl+kmx8z/2+bA1kF6N3bIHFzEHNUr2b8ZabuD0ObX?=
 =?us-ascii?Q?0yEcB6lVllFnpiVJwkYsQjKPRBNsuI7IDYbFfK4aVfcxhi1Ymm+U1qeebH8P?=
 =?us-ascii?Q?xaz8+hRyNPBNPX/BylYA33EqYmmB3VufgYuRxmh555+fA1sFAfFWnEJYyG0O?=
 =?us-ascii?Q?dIvsEuzIpbKi0cSu0EIZzV10uc2FW8grJC7nMgqTy+auuRTKDZcLwZSqjML1?=
 =?us-ascii?Q?GJwSiwjjM0mQopf8kzCQdytLlvELB6hI0jDNe5ZoyUj45AmeJnwj9ABJ9QH4?=
 =?us-ascii?Q?WK/uS9YH5Punp/re8C2RWk+3tkEA1gaDZBmEv1XvojPaI5zPQsBLX4fWQCeX?=
 =?us-ascii?Q?PgCzHy51ZEjnVpBRhcdtqfebld7mWhU1cUF0sN+1viQ/wYi8AV+DgMrnrS9f?=
 =?us-ascii?Q?T6HzNV7S8+BT0fLG0EKaMFtf2N6AnzXv3ic1FabNdnYobd9pPFBQTxneTNIQ?=
 =?us-ascii?Q?sRERtz4ZFbDP9qmVHhsaPYyONGn8Kzjb2j4uvhPBwBLt8ery721YWifwJwy5?=
 =?us-ascii?Q?Hc8z2ampWiOJZYPiTrhzrKUMo/oF8Lai/Otez9p+ptsDZj5pz7IXjQ4pdwQQ?=
 =?us-ascii?Q?/UsGLuS2qxrDvhuTZ3kGOYBQp3RgISz44T1hIFwEz2q78IfN0fOzyw504lsk?=
 =?us-ascii?Q?tm0xfEKmbcd+Z9WwkqDPEEyU6mkv/pOf1gTrfHUwM3BYWMR97Wt2beLg2PEs?=
 =?us-ascii?Q?NCsnc+kFCGEClPyWqMVfYwG7UUHfVGi+FCCaHRcKz+cAOb/VgcZLC0C+CQXY?=
 =?us-ascii?Q?SbfprjYEz8PA+m4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 05:23:33.3906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60249786-cc8f-4cfc-fb73-08dd6513dc7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF0B4A257F6

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
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

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
index 80a80929e6a3..4ee8d233f61f 100644
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
@@ -2467,6 +2475,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		svm->vcpu.arch.guest_state_protected = true;
+		if (snp_secure_tsc_enabled(kvm))
+			svm->vcpu.arch.guest_tsc_protected = true;
+
 		/*
 		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
 		 * be _always_ ON. Enable it only after setting
@@ -3079,6 +3090,9 @@ void __init sev_hardware_setup(void)
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


