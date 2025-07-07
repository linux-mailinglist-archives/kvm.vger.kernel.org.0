Return-Path: <kvm+bounces-51664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB269AFB0D2
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 12:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BA793BBEB6
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 10:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10B3293C4F;
	Mon,  7 Jul 2025 10:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WuYgXM5o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3376F1A9B24
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751883064; cv=fail; b=PW/vkI1Wnod2mR5NVQgr1eDZF/PPODxp02pp/QzXuC3gZqKeox4UFGJ9Y3IGlfg5TxBSjljJW+KxEB5W4yioBnbcU8dEMsYZUQ9Jnhv8XMSOXjXMD9+FS9xc6OdN3+2PgTSbVcHSRdUtf4olQoQhXn4GoBRin8RitMBWS3BVcaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751883064; c=relaxed/simple;
	bh=DTUvLMXx7mDhw6PAQvpFh1AeFTiQqEzDo2P9Nek//H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQpRsgjDSscvFdKnpg0yd+RT+/V9wR6TSt1c9CaRj3sainpJd0w2nTCxbXaeuhGEz4Fe6d4WmSVhRLR/rtd/6tUbNBa/RIFqYKmrFtMiAMlbld6yOXal7mGqtxIXv2cyAb8w/aXI1/fxfXDQ1eAeIFHPpmqMn0ffkVKqKJ7tWug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WuYgXM5o; arc=fail smtp.client-ip=40.107.101.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KwV09vhKYvXyYLKi9jLojHPJj4Zja/bL0jZ7yrAL8cmr7kqYuSXdOAAwsh/fIYQhdkAwrf152LwUyOZRZUCeHhf8H7v7PFYs7etlPzGg/EPg3Y7X4v9dbyDQZSHeycWmf0x1Hy76NHHe2lOXE270M34oqZFto8PZYzUOWRHRZEj84X59ZOub0KjrWKwrAreWKUDx9Z6/w6UvtTTdLCHV/cLZouPrw9xOecqYDMd6PKR33hec8naSPme+V2UyIrS4rIY7jSWmTaXwsahr6XcsoCNu6yqlsTnaaZpZ6zfWIPHaubs4fx6gMh1+CNbr2FXsu/e/ctnwT81rvb7Er1Tbgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7lLU+UIPy/ZQAG/uOba/oB/CMvTI8TpNEZYtOgYFnuk=;
 b=je6OutHftQPPkKNGqQLBw87gT9JFzoJ1TEuXZMbrv2BBKzep9nPiwqVnt+33uiJTCQPdPOmClW3ms7ApedN81uE3oj4BUrTuQZ6njyOxt25c9pz2JqjDsQ7rSdOK6im17kmO8G0MA6b71Iw+Dv1tDiazn9jK6oSpXQPxoKW4w8/+iqmliKiG6fE79KcPvmazK7b4rmuGnYM3tS6KRX50PEXqgfcU2MjtSYAlGgB0oWCf+JOjKuT5V6EWaI5XnjqBHcqL/succ7+6UCYoDZDmx14GUBEzPap98zqP4l3yEpP7KWA68dF80WyUr6kEF39fGPl88ZFIQg9J+ENad0bgWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lLU+UIPy/ZQAG/uOba/oB/CMvTI8TpNEZYtOgYFnuk=;
 b=WuYgXM5oYsW2CPmS1SeyKB6Rf0uCU9DZWjHGntbQ/Cb4sNJ8FRE5bj+LPCiajbAiyHkWHMmRcVAI8mfKeVbV1WQSxtwpY+aqRwLV69IooiqFQuU2t7U6ZB0XflyndzTR0+bLmNLceh6hXDDI4GmG2UkVBzZA3yeaCSrYddQTlx4=
Received: from BN9PR03CA0687.namprd03.prod.outlook.com (2603:10b6:408:10e::32)
 by CH3PR12MB8933.namprd12.prod.outlook.com (2603:10b6:610:17a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.21; Mon, 7 Jul
 2025 10:10:57 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:408:10e:cafe::bc) by BN9PR03CA0687.outlook.office365.com
 (2603:10b6:408:10e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.27 via Frontend Transport; Mon,
 7 Jul 2025 10:10:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 7 Jul 2025 10:10:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 7 Jul
 2025 05:10:54 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 7 Jul 2025 15:40:29 +0530
Message-ID: <20250707101029.927906-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707101029.927906-1-nikunj@amd.com>
References: <20250707101029.927906-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|CH3PR12MB8933:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8b0d17-c11d-4fc5-1bfd-08ddbd3e9102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O7UDiyDuZrsQWsOfVk3YoT1iafBSfOS+dLrQHAnma+bml8mKTQF3nhZmV+ZZ?=
 =?us-ascii?Q?RQJrMt3+mCWTMGU1EMutdDis40VZB401yG1rd2vCp1e6f7HFXi7Exsci+sL3?=
 =?us-ascii?Q?SRP5sLlWOQk5CFyVyMMIK4lJQQO1MJI/sTkpZMP795uQ25VjurLZyEWBlGRh?=
 =?us-ascii?Q?P622yX1caA1OpWRXrs6Pe6CP15c1phRwQ/s55EMrU1joX354nOOwu+B0P51y?=
 =?us-ascii?Q?xePphNn8Nt6q7ZojB8U7/t/AqZzDY8Zm/HwLuLgIrN4mcanwvC1dP9R9KJku?=
 =?us-ascii?Q?mNJ+uKs+xmvMNAVHQlzVtEj74890UiCTby7VBBiu5eMkHtMzpIg5GAdHF7pL?=
 =?us-ascii?Q?ZlC027WPHNV86fpIzBwgnkJ/mWicACzIXDLlM0cKfWWArBympbKZP6KIbZz2?=
 =?us-ascii?Q?opo4+sbPA0Xg0J8rOVPG25lj4anouREdv4XS+/D2cwQJkr0/E2AcUWf4NpYb?=
 =?us-ascii?Q?t51xn1RoPl7wm3LRz65Sw7CreabYgmALhgGU1C+ZejLhhDRFki1PplgPJnc8?=
 =?us-ascii?Q?pDt8jts9MHGy0vhR7blnyDvmOJe79ZfCJ/NNFJZP4hk6/+rl7fORCVGfBkek?=
 =?us-ascii?Q?W4eanpIXqSuBT1guzsQq3KGoqY3ZvuzTZ8+8O+X/gMi6DwNSun6WsreoVnnv?=
 =?us-ascii?Q?LOeTp0BWz37MFOSbTxiKUSLh1oRvmKvJhvbrsaGkWvM9g3OvAhzHT0l3ORl7?=
 =?us-ascii?Q?FQXNRbIyB/YtdWPfCzphBWsOK5NlgWQAG8eI7Vvr+eZ3jbQN5yrfkPCxpOmw?=
 =?us-ascii?Q?DuYb2NWYcIAZ7n9XRhO78yVfvfZ7cfzmyZLoHspKnR/dEtUW8s+uP7ASD5E6?=
 =?us-ascii?Q?rFb6R0fNvMLyqDNDnqltL144jGjeJhW46Kf6Yj/6/7vvNQJQH8iaAilFST18?=
 =?us-ascii?Q?WnJAImLEStePUxDeR61n43AH9BSArol7Hlz0u/qIDb/SiNKkUMEkwDLhROou?=
 =?us-ascii?Q?YUxKIzbMRnNrtnWGlr7n7NsypYh3vmZzVwYBz/YUPunuRDXFnAfRbFJJmK/h?=
 =?us-ascii?Q?XHLfzMBoUURrYM4Z3EBsL1s8XAAKa0edFixkBxSwaN+3VmVE6wnuOZ7wZUUI?=
 =?us-ascii?Q?ScfVLWkY05ukBE4lqYasJ0H6oBAlPb1c69gBPVDWL3huu4oU/lMCQ4zEZW0d?=
 =?us-ascii?Q?rbCVL1wtayIVckoHz8wvNcznaocX7sBa8YTSFM3LpZhPFpwo3+rZ8HYC7kV+?=
 =?us-ascii?Q?yIZHPxqD2QZpQPkMoPpVNDhzlVP2C3Gb1DJSBuRf/h2hOndvWyqchF04Dxsp?=
 =?us-ascii?Q?fImlV46hUv+/12PgEmuOUhU+qdm7J2WEZke7cYeXLCt5aGCA8Ae+1BGxPoRt?=
 =?us-ascii?Q?ENsyAFW6p7TTzyGQqLnPJ+NixghtY8mjS4Zuc4XcWbQ9XixL8y+ipjUDK+b6?=
 =?us-ascii?Q?P3uCjxfrQqt+Ebh7fvEIOJc7VgzrLQZXFa0SVlDf0KyldOAWKhyIeINqFsQW?=
 =?us-ascii?Q?3856mfwW8cuUhs5K4IVpxaY2ZRYZl1UR3kdC1SNWUsperRtJ/u4hfHEs4iCA?=
 =?us-ascii?Q?kYUkRBCm9/zOTpkZCX5EfRZKWj+++bMq6u6E?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 10:10:57.4484
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8b0d17-c11d-4fc5-1bfd-08ddbd3e9102
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8933

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
passed to SNP guests in the SNP_LAUNCH_START command.  The default value
is the host TSC frequency.  The userspace can optionally change the TSC
frequency via the KVM_SET_TSC_KHZ ioctl before calling the
SNP_LAUNCH_START ioctl.

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

I have incorporated changes from Sean to prevent the setting of SecureTSC
for non-SNP guests. I have added his 'Co-developed-by' acknowledgment, but
I have not yet included his 'Signed-off-by'. I will leave that for him to
add.
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..17f6c3fedeee 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fde328ed3f78..5ac4841f925d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -146,6 +146,14 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
+static bool snp_secure_tsc_enabled(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
+		!WARN_ON_ONCE(!sev_snp_guest(kvm));
+}
+
 /* Must be called with the sev_bitmap_lock held */
 static bool __sev_recycle_asids(unsigned int min_asid, unsigned int max_asid)
 {
@@ -405,6 +413,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_platform_init_args init_args = {0};
 	bool es_active = vm_type != KVM_X86_SEV_VM;
+	bool snp_active = vm_type == KVM_X86_SNP_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
 
@@ -414,6 +423,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->flags)
 		return -EINVAL;
 
+	if (!snp_active)
+		valid_vmsa_features &= ~SVM_SEV_FEAT_SECURE_TSC;
+
 	if (data->vmsa_features & ~valid_vmsa_features)
 		return -EINVAL;
 
@@ -436,7 +448,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (sev->es_active && !sev->ghcb_version)
 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
-	if (vm_type == KVM_X86_SNP_VM)
+	if (snp_active)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
 	ret = sev_asid_new(sev);
@@ -449,7 +461,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		goto e_free;
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
-	if (vm_type == KVM_X86_SNP_VM) {
+	if (snp_active) {
 		ret = snp_guest_req_init(kvm);
 		if (ret)
 			goto e_free;
@@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
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
@@ -2386,7 +2406,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 		}
 
-		svm->vcpu.arch.guest_state_protected = true;
+		vcpu->arch.guest_state_protected = true;
+		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
+
 		/*
 		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
 		 * be _always_ ON. Enable it only after setting
@@ -3036,6 +3058,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
@@ -4487,6 +4512,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
+
+	if (snp_secure_tsc_enabled(svm->vcpu.kvm))
+		svm_disable_intercept_for_msr(&svm->vcpu, MSR_AMD64_GUEST_TSC_FREQ, MSR_TYPE_RW);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.43.0


