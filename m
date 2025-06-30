Return-Path: <kvm+bounces-51090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E409AEDA30
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 12:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EF26189744D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8432586EB;
	Mon, 30 Jun 2025 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wYA4FrQq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C860A239E98
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751280296; cv=fail; b=nBcuraY7OLVrpOAtGGl5CwokC6IBVb6uHmnsbzbYyrU0KUOZoU2COl3I+T8hhiqLskF8vGEbFvWBDRznMAhLsaT+4wuDwdu3QF/9mZ8e4B7OCp/o8shcpZLtQo1pYYEKFj+4jIWgEm0ZhXqG8IQk7a3yRq1VH6BoiekRQY8JGXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751280296; c=relaxed/simple;
	bh=D4Z+OZY7gJeTyh2QxgPXDe3LAi//jhuClzMS38iHUn4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ti2Nrw4bOqOLuDlHi8d/L4AgS3V9t51Fy4LWW1dYPBuRu+reOa2Cqdq5DVdAlDNjS67Nv2GvaaE+R0mFNMUrZIHZLaKWo0jU7VWPkFeEPm7/kTx9vyqgAQflnOe1pFCQ/ox0dzTBGz3v/EoOee41nR1eZQsrr0G1bbNF8wEPKsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wYA4FrQq; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y66S40qTV8Uu6hKNJhpPyXfxXtUKLGrnl4Eta9SqScQ8FTWzVJdsgACzO8nWOlqIKm4yDzFQLH+O03utmQ1MbQtHcPJgtESGlFEBIMWrJIh0lz0WgO1ttIzpsFplaWkK/SNgiDZcY+Q5qNrwD/G66ylAPuoyf0c54vjKjuSEfwM03qh+YVwX3B3QHb/pRcMoarRCdBa6zp1L7rjUx7EsFIxkR1tWIGuZCnxMJ0XO+uzZZ1KVHZzWE0bb7dO5h7euCk0s8kHTzSkWSWUasWzZN2rMQ/1ylxr2DspOGLd8P97WDocRPXwciwVPL9tlecO9AALwN0tv6aqzfWNbxb4fOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77fpM5M6XQMx9C41PzZUafy0GGSM16Q/WekYjSiqDZQ=;
 b=sj6lAlXQxlsirjcTTCdDmB6x1hO1FVtoefD4lAP/cTfNS7gUhI+Wuqt6J92uSJr9CGLVjhVS06luq+n8v/yg1ZZoY2VrmmmfZI170Kdlu36WyvdAM0eURj9PVq1E2kKnOxzMkLyR36WvmiAV5ZmDA9M9VMd3r+Q9kRXBuC1Gb1Wp3L3wBfGFK+dp2/UKXK+XSiiUCmnfaeYrEekPJs7E0kHhQ8fG8j9wxxkeKzU+1Ravc3K4bTx+5KYIjm5gEvGBWs+HsxG3uKmrkKUiKYwI6IaMIGnqzpuMHLU5GtNqICcSzd+ehq8iBb6KmYhf/tQdFdTXk/HrvE8iGVPI6xBD3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77fpM5M6XQMx9C41PzZUafy0GGSM16Q/WekYjSiqDZQ=;
 b=wYA4FrQquWEdU5DLvh+L/U5kKHln4TJQ0du/vK53/9c9SyiY8je298AqzekM6YWm//pn+XWh6jOOw9FZTSjrwH15aVoOWTvpoFnFuG2oa0IEObM7zOOfChwtOAumPurhySIyd9P0irIpU+qEqui3wIB0DaA+GCG1Vqmx0OZIDwU=
Received: from CH0PR03CA0075.namprd03.prod.outlook.com (2603:10b6:610:cc::20)
 by CY3PR12MB9678.namprd12.prod.outlook.com (2603:10b6:930:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.28; Mon, 30 Jun
 2025 10:44:49 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::74) by CH0PR03CA0075.outlook.office365.com
 (2603:10b6:610:cc::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.30 via Frontend Transport; Mon,
 30 Jun 2025 10:44:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 30 Jun 2025 10:44:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Jun
 2025 05:44:46 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>
Subject: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 30 Jun 2025 16:14:26 +0530
Message-ID: <20250630104426.13812-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250630104426.13812-1-nikunj@amd.com>
References: <20250630104426.13812-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|CY3PR12MB9678:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e3c6468-9587-4093-b932-08ddb7c32340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TuNGaJuTe5QqIWHNpWkIAafJnCRTRhIpetb2oRJaz1gbDvc+U+mBCi7rfcw5?=
 =?us-ascii?Q?d+V3JWT7oHLs57aZVFZiaj7yCVCpn34FzvspQh6vuTr1X1yLCPTHeguDPTk9?=
 =?us-ascii?Q?mV+OnvtSd9U8ACE4tOkWBLnwYFGnRio3kMfnoO9iFZac+nmvh+EiqkEKldwE?=
 =?us-ascii?Q?bqCCBj1aDxp4iW2JqIwLG7mg+vLJ71MvpIZsqnPIZIynLpFFpJ8VOdjffmpE?=
 =?us-ascii?Q?0S0uSSR4cUUKoT12PKdMgXSse44ysIyoY2xmwvU3ISJqTDSX3IUNtEemZos4?=
 =?us-ascii?Q?hWUfqqWpN9oy1Fg2EfP+c8qUk4rOO/qLuGIEt84frcYV8ZWVT5czR7RuXfY4?=
 =?us-ascii?Q?twsPCQUlwmhIVYeAZbTy954J/3Ikl9vEuFjov+y/iezTVf2cx0V0RaH9VBmp?=
 =?us-ascii?Q?Hjv6um8WqKHXvyoPvHBuWgWATSNFU0ZgzSl75/bvYDjXtlmoqIDgMp4JCXA6?=
 =?us-ascii?Q?7X32EltbnLZYuQGgfcy6eJDuJxtqaLe1JH8SDFCAjkWnSz4CqVYu3qynTe7Q?=
 =?us-ascii?Q?XxjvKOSGJnHrPbGAYnGFXLDUooUJzqBhEM4HUGMQNhC4o0m2gThTQ0dL2Mv8?=
 =?us-ascii?Q?ROs33XwndhNlsQxIQ6boELoV2vBOQvagbrq62o7h6MvlioXTTtR4pdPtTFfX?=
 =?us-ascii?Q?cvgPOnP2Zn2alq6NZtqfEOJ1Y2CIOPpUAB1Ozn3KhCqSJfepuR0eqobK4KLR?=
 =?us-ascii?Q?Jojsl+M64ovtNnpfbm00SeR8oYJ8Epyx+ugcrafwK8+zGRuUBBagj41uZbkn?=
 =?us-ascii?Q?7IRASpIxSxvBXtpKHJdhrPQXBjh0QzyTfV8arsKRBVv447ZgWjG6oVQghOwp?=
 =?us-ascii?Q?7mIZKpJyBOUiz2a9huURMIPIYzAV9rQLISOn/A6KgD1JXt+CKpaH1yerAg4j?=
 =?us-ascii?Q?dVZiww7NQv27zhFEoNPP46bqr87jaHr4wSPQc8pm9JzHcz5f1E4841TxapjD?=
 =?us-ascii?Q?RYijYGGpkyT2do5JBrVGB/2AMQgZ9NDyYbMgFSM0hmGJaaJ+I9lV8yn6ilj3?=
 =?us-ascii?Q?cgPfn8MXYk9LvPvfrneH4Bv2MXRBE6Kv+pTPH3BafJgepCI12ef3N+K3VJwK?=
 =?us-ascii?Q?IUVKEeecpo3e5owDb95EhhmmtsG0rb3Wb532V6IcgIFyldrcoWHWvbP/FXWV?=
 =?us-ascii?Q?P277tSXGb0U11C4KOw+jdWhJ2yOBo1wy7RWFHdmr2wu7VXyzo1BgAE1vwPIN?=
 =?us-ascii?Q?hMSDmqpEk3KOrqDLILTF2hWmStbxNgA7FLkNUPHHigrscLxAa0Mt4iY/dbaE?=
 =?us-ascii?Q?SP7vsEmopSlYyFfa0OlCLd8B+jLwSPY0+/UJNdX5Au+VJU8TU4QUZx2X31JV?=
 =?us-ascii?Q?YrDuI1bDDlyHaASQIsvgepkDsZdZdEr7KoFXISqQ8FSJsUDdduZgwjo0vX1j?=
 =?us-ascii?Q?Q38yMRP33EpdXshxd0tXCt6IdCIRKNvqunlQ0D2y00f0PwG5wJPzBN4LsBat?=
 =?us-ascii?Q?hc+os/YDUm1xi2Npsz0MrpV7ITTnXCNibWqCZJPckBoLh1SvRULg96uvkl6z?=
 =?us-ascii?Q?/XKDVHTQedW7J1luE67BLIZR/T0/CKVbbzCW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 10:44:49.3884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e3c6468-9587-4093-b932-08ddb7c32340
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9678

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests.

As the frequency needs to be set in the SNP_LAUNCH_START command, userspace
should set the frequency using the KVM_CAP_SET_TSC_KHZ VM ioctl instead of
the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.

Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
guest's effective frequency in MHZ when Secure TSC is enabled for SNP
guests. Disable interception of this MSR when Secure TSC is enabled. Note
that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
hypervisor context.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
---

I have incorporated changes from Sean to prevent the setting of SecureTSC
for non-SNP guests. I have added his 'Co-developed-by' acknowledgment, but
I have not yet included his 'Signed-off-by'. I will leave that for him to
add.

 arch/x86/include/asm/svm.h      |  1 +
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 34 ++++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 4 deletions(-)

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
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 13da87c05098..4a36cda05f38 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -840,7 +840,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u8 pad0[2];
+	__u32 desired_tsc_khz;
 	__u64 pad1[4];
 };
 
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


