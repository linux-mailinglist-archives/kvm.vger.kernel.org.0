Return-Path: <kvm+bounces-23002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD14945630
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 04:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3089E1C22FDC
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 02:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E7D1AACB;
	Fri,  2 Aug 2024 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nMPNMSQf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520EEEBB;
	Fri,  2 Aug 2024 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722564022; cv=fail; b=MOIg3dTJ+7NlpCOZV57kpXf7LwMnouLmNBrQqocR8U3ruNaMJ0XLQ4G1N2nJilWeY0Ax6VmafjKMg+UPdbtkU5Tb4HcCtCI4k4cYv5Be2ujjOmUlm+2DPkb0CKKBr1HCIbFQy7Dq/Kj7JSvKHiGVzFb4POShKhPytXH5jOEE4K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722564022; c=relaxed/simple;
	bh=lxWTVPTxDTEhNFketr7EqZKOnxFC4pnJFMFi7GWzCi4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JA74Us3atDSSmobHchIly+GGvDWRUnFOu7QK0Q2XcpbAnVb1N6yD3XcoMtG1AjFjYxNgCQtYrRNee4cshkkoIgf2agroeMUQErVPoedQXQrh58W3TlGEVb/doeL7tjCo5FGHvsbhh0h/sHLjSu25VCqZUU0qWVJGqcj9gxLC/Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nMPNMSQf; arc=fail smtp.client-ip=40.107.101.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdGreknSbYt0keqtITj9u+CZ387d3DvQc0hYTjwJKQB7gFoUkq6XogsGNjW/OXM0Ib47pprurOUfHYEaDBWi3E5llPzbZweOhcYc/QeTnLm7cH8vvH9GoC+CfmdQYZtQJgEKXV45woItUXvq4EQ0od+g+3syy2f8LOxsEwmiBhEKLpVKmdZMl7LSMNeGfQd+doAUjaRmqhCEXVy5Ki9BWj7WLEJ1TEsu5UYZgQsK+m88TF+lD8SHSwKAtlsdCe4WayaW6pRuTeUlV7n582VEaKk0mYxfV3TQOJJwXJJLR87eWhU1WOT8q0OiWKlDoVrWIJZgarb4wBJIEE43BSVT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm9acg39GUIoxE9bFbPAbEbKGPRva1b+6tGPtc4i3x0=;
 b=yyrqdOfg6KvHMOZA7K/CbZYjyYor7nw/HGZPRJ77rsA5cYx7CMkib0gLhk3ISkCPud6zpNSkVOea52E0dZWdJHQf2+p/6uDZ/tj2Wi+BS3sfynIwYiimXXAvmamocOtEJBfzgb9oFLJ93KVrsiRKV8ywd6D1LVOIy+JRUGPujWlFaSfRJ5K53YmJ9GTDCw/4s37059FNFBMOyQ4jxbPoss6rQ0Jtk7uzK+bVZX07yC3+OXeXLxTXLCAKssdHJHc9uY+nkwzqh4f8MCV84dZmNWgUtBp1eVDho4YiUuohFo/IeAcSTSe41Qn66WHJAJbX/9em0i0fRSmW2Sth5Fe9Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm9acg39GUIoxE9bFbPAbEbKGPRva1b+6tGPtc4i3x0=;
 b=nMPNMSQfROrbfIg+2pVHLOGwb62YCFNhsseq+fSeuEwSKjaaqHuehIJLk1SUYbYNIR6iqVOgPTWyIyTFsvt73isdj0D08RCRCJBd5YzFXOek1yHRlAOP6xsYdCPGmF2P5XT8zX0YMxasoYYB4RRPCUHbR5s4RlKmMh6jTWy8/0U=
Received: from BN9PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:fb::10)
 by LV8PR12MB9418.namprd12.prod.outlook.com (2603:10b6:408:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 2 Aug
 2024 02:00:16 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::ea) by BN9PR03CA0035.outlook.office365.com
 (2603:10b6:408:fb::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22 via Frontend
 Transport; Fri, 2 Aug 2024 02:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.11 via Frontend Transport; Fri, 2 Aug 2024 02:00:16 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 1 Aug
 2024 20:59:03 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kishon
 Vijay Abraham I" <kvijayab@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
Date: Thu, 1 Aug 2024 20:57:32 -0500
Message-ID: <20240802015732.3192877-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240802015732.3192877-1-kim.phillips@amd.com>
References: <20240802015732.3192877-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|LV8PR12MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: 079b120a-6d8f-4b8e-0d3d-08dcb296dab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UDjGmz9KnMSyK3e2W/nY/H1aaUkk8q8uZO/+suutWGCCmnk3FpWzyz3g77Jo?=
 =?us-ascii?Q?JAqCkCf6l6gDm6kmZvaVz3bOpSxqOZxjUM0Ibo3KQfW2hPA3iPsuT1B8/nJM?=
 =?us-ascii?Q?WLAFTQqpets28+feS8gW785cvBfSrpHNl6FlAtgcL0LEv/Nj+Qikmbrzdg22?=
 =?us-ascii?Q?yWmcQSXuxzjlyrS/NzSOuU3cdsNbU6wpdexyrNxpamCoBRuSVMQrTlXfD4VK?=
 =?us-ascii?Q?wPRybttzv4UlyPj7aMCMCH9qOSEZj90Zj/FfRwfGqlRrmWWVZdHefkbtFYdk?=
 =?us-ascii?Q?r7dUExgMmFSpDu6iSv7/n+vnhPdER7jk+0k6mRIEE8GkL6yGYYxCD4Nat2zS?=
 =?us-ascii?Q?i45vf0kb9ijRxPbYvlNFB++IXU+rSxlfdPEqLhQ2zUsAG88SQyeXjUBT28Ka?=
 =?us-ascii?Q?TlzToBk1fHVgmM+2o06bFT6CwsImHsc8FN1NYa5DciIlFE+FrK4hZuLifl5x?=
 =?us-ascii?Q?fscBzT7NNcG7EyZRoHywoRqJl88rcRZVQ/xfBaRN/Uo8pwvI58wZKxfPV4qa?=
 =?us-ascii?Q?Xl/AF7dnUZvBEvMoT6EB8V4NmXu74+TM/7skBBM/xH0/VA0+6+vt4rO2Kkd5?=
 =?us-ascii?Q?UqhAOmTITsmXV4nChr+JBMCu7DHY5XA+0AyqgtDtEyShPaLadw+Pdm/uTZrT?=
 =?us-ascii?Q?Nm4mHCukFy1M7CUHSaxfiqZupgKuRtiY1G2BPqrVoI1K6xSRHlLt48FJJA18?=
 =?us-ascii?Q?ImLeAvq9/g5yZY/0HJZKA7c7z3v05OxC8cc4AgP1p9OpCug86mvEIIIoXFqV?=
 =?us-ascii?Q?xMneNED2vZoPLaqcBhYVYUat8epaBZwXMwu166yufXgn8VHhtvPBORnWzqWK?=
 =?us-ascii?Q?ac8FPYBTX0NBsJMEeREF7+aL2baapYd/pfUoGNvaFSDhk+F3Z6UyCiOj3Dbq?=
 =?us-ascii?Q?BvHQA/wCMY8vkHFHCKH4gFA+12Br4LHMdJTa+s8RNZq5Z88QAPKqdoZxTTnN?=
 =?us-ascii?Q?CsOaU2ALhlTahJ2aHC6YSsyogvP3IwDcJvsUgMnr36+BtnYEjNRjjEPmou3T?=
 =?us-ascii?Q?xB8Javhe8g/uLjOxi2I+BP/OiM+kKt3pH5h8I2S9hkyeinE892UOr9aToGzJ?=
 =?us-ascii?Q?yCkkfhevsTIgKC6iSFnhkj9p5zASKCLowdmwA9vM8qFreqhoaOUenn6/ISKL?=
 =?us-ascii?Q?0owSHOl8WUIdGdJM2OFXSr1GgntFMu6kDnPkp1I/ey0Cx+YK8yF+rTU54P83?=
 =?us-ascii?Q?8SbGHgxL+2KfPBRVlZxeIfDnahPuEfcptXuBZzU4PvBila1skhTr2cVT1ftE?=
 =?us-ascii?Q?P9gUVVuA3mgM6w5XYGsw1sOM8LEZFA9AYUwIx1lzTBh9Nj0dHvz4m8s6vIpA?=
 =?us-ascii?Q?3AizBh6/UE7fXEwV/yXMUyVcbar4t8EKf9dgEzakPKMUa+x6SnI88U/32jSv?=
 =?us-ascii?Q?suWxHTfxRGLqisY46AAK6wzEG0qU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 02:00:16.2720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 079b120a-6d8f-4b8e-0d3d-08dcb296dab6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9418

From: Kishon Vijay Abraham I <kvijayab@amd.com>

AMD EPYC 5th generation processors have introduced a feature that allows
the hypervisor to control the SEV_FEATURES that are set for or by a
guest [1]. The ALLOWED_SEV_FEATURES feature can be used by the hypervisor
to enforce that SEV-ES and SEV-SNP guests cannot enable features that the
hypervisor does not want to be enabled.

When ALLOWED_SEV_FEATURES is enabled, a VMRUN will fail if any
non-reserved bits are 1 in SEV_FEATURES but are 0 in
ALLOWED_SEV_FEATURES.

[1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
    Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
    https://bugzilla.kernel.org/attachment.cgi?id=306250

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/svm.h | 6 +++++-
 arch/x86/kvm/svm/sev.c     | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..59516ad2028b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -158,7 +158,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 avic_physical_id;	/* Offset 0xf8 */
 	u8 reserved_7[8];
 	u64 vmsa_pa;		/* Used for an SEV-ES guest */
-	u8 reserved_8[720];
+	u8 reserved_8[40];
+	u64 allowed_sev_features;	/* Offset 0x138 */
+	u8 reserved_9[672];
 	/*
 	 * Offset 0x3e0, 32 bytes reserved
 	 * for use by hypervisor/software.
@@ -294,6 +296,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
 	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
+#define VMCB_ALLOWED_SEV_FEATURES_VALID		BIT_ULL(63)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a16c873b3232..d12b4d615b32 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -899,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    int *error)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa vmsa;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -908,6 +909,10 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
+		svm->vmcb->control.allowed_sev_features = VMCB_ALLOWED_SEV_FEATURES_VALID |
+							  sev->vmsa_features;
+
 	/* Perform some pre-encryption checks against the VMSA */
 	ret = sev_es_sync_vmsa(svm);
 	if (ret)
-- 
2.34.1


