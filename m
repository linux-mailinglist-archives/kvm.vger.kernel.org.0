Return-Path: <kvm+bounces-10002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 814AB86832D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 22:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB855B24F6D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD2C133430;
	Mon, 26 Feb 2024 21:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CFfkN3Nx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD1132479;
	Mon, 26 Feb 2024 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708983204; cv=fail; b=bOkWZKrLXa5UPs/cqEduMdaoK86ZAYmyaMQdW+XPlI9RI+xrVzUsCfcy5vT9OHvJa3sqEGVtp2Y4YuE2S2jN8KNKqKm3BMXtndj8QfG2W5G7Gsg8ps7Ayt/F3004Xxq7U/8+GPtKnv+sak4vF1r2876Xp9OSoR55VmTc8kMY9eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708983204; c=relaxed/simple;
	bh=a7Kbeq917FP2okWrYaow0qB+Q/vr8rDFLGffwC3qleM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aF6pZ2QMKJHq0cn7dnn4bHLK4vIY7i8U4R/KlI07alh2STpKelSIBVM+VOnsn49+szWR8M1yhqh/LifCo5Ik8pwb+r4peHCKrkSrcyR7rJqIcotbQq8gr5IxG4zYbBu3w/1mufdslXHcxGeDzv06A0xISzbdyq6qVxd4+kIWeeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CFfkN3Nx; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHfL3HFv9rVzlXUAdVe9J7tKv3cNFl3ayQFR7eEkGezS/zEgbXjpkIpt5Km/ZRWdkuO1lLyPlIAfjpUM5QSayLZ8JbnnvdjUKUtaH+4eR+My6QDxILAIET9nmnP0HeTyHdE9i/TkOFJP/DTR7mZBjwInSGwkuEAeJ1HMJXZ6eNiIvo5KKOvUZT31w6OxbPpVXX1iqIKW5x5zTeL7qg9KQSfCaTTX8EVDAcP07pK/lzgpWtXZ8iip9rakSvm8Ih+R2DrjjA4BhwH/5PwbNpN4tttGa4/NaLKBV4lNHa6lSGlBf2fJO/ODX3cHsQal0MelF2bbCYTuyg1lwlUiNkKVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dq11PjNVqbSlbn1JHP40LqVBB2E8p6flh/dFIJHaq6A=;
 b=OMFyPGKDuYfx6vvKaOkkS3f/EMFbSnt7wxDmrFboplK6Ra3XJi+G9DAr4whreyMJTwLolXRx6+XSxhp4gIUB2475QMA9c9U/9yon/crDNIBBTNBbFy3uiEohvKKJmhDcZw3veSy9QAroyme1gG1DKlJ90QFms6rn/9ZrOC5W5V1xii7EbGquY4BNq5pKzCYapHLPm/Ip2k1IxU1sWG3DXxBxHv+/v3y5dBHV4eSpgIVcWk1MtlqLXAxFWz6Oa9Z/ns96u6ewBmiuy58GvXmN1QM+2PovLVCuFnfExiN9x3o+w4pjeZ+3Q/iYjw0Zc8DmMnQw3bKvyn5tB+b0SIYLPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dq11PjNVqbSlbn1JHP40LqVBB2E8p6flh/dFIJHaq6A=;
 b=CFfkN3NxOo7+eogRhSiL7AQcEJ9JsZvWC1Ru7u/8w4Oh+bFQdlSzbMjPNbGkL2hIrVtpUZiPE+gxhBFteJIbvciDpWfuXI4lIH9v5Lkoj6roth8hFrLTtaMFJkxiXc2JP7HCsd8pgNx8M5y/rDoN5oFwxzNxKclLJF6UHptZqTk=
Received: from CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 21:33:20 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::59) by CH2PR14CA0050.outlook.office365.com
 (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Mon, 26 Feb 2024 21:33:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Mon, 26 Feb 2024 21:33:20 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 26 Feb
 2024 15:33:19 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<pbonzini@redhat.com>, <mlevitsk@redhat.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH v2 4/9] KVM: x86: SVM: Pass through shadow stack MSRs
Date: Mon, 26 Feb 2024 21:32:39 +0000
Message-ID: <20240226213244.18441-5-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240226213244.18441-1-john.allen@amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|MN2PR12MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 783fdb48-ce6d-4481-4a60-08dc37128d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OtqxsUH5YjcjlHUDyH2TUpPH2AXizzedbTe19lmMzMAc2D3GRxJKdkAr0dV+9EfGhkxk60Q1KhWQURtBpo4xfutd1tdzBIm64bG9IluxjlXQfnTr3U/xc3KFSNtXp358xx385PLvhOHRiJ4+/4bITYXoYvbWgc77yizj4pC2Pb6TXr7BCcg7qnmjxwSCQaJvoE7Cib1YQCIugEzP3dSSN+KNFenjSIbiajjFCGffJxHFO6sPCEHZuJBguvb/Q7/Wjcnal2KhBKZOxEs4/woRJXCkn1azGJuWenpNRvUVvdmz0mPbm6NXDtOtf2zoF/0LKK0AAsqaga5BkRS60w3Ga89ZYD499w2ZRVAKVGdA4sGa9AfSy7odrixCqPkPiY+/HkK8bkrla7Umu5XfXAQWDGiF9cgIP0b+oGRf8PQuZ5JTVTL017TqxjmxR3sQ+qpN6kJyQ67RusVn4Gn3SQv1vqPAof0cg16tnCm9NvMjVsoxLpHrpvWe2LkEv4/NRreDGvu7czspP5GdFfFDA7eEyWpj5zrVzGDTuq99RE3cNMsd3LW77CUuWqcl9MPB+SAJKZyZ5n41P3gLi0IB+ICycwjrWXgJnrHqCAboeWvTCxC7q1jD43DjlBrhf6zEQPNnbgD/YZxWJBtQvvchHZDsQhuA6Jk0qcTDgRjgox1DxSo8AYUVmH8hM7BzlAaLBF77SLL4aAvrnUDnAhIcA+AY+zg4WcAVxejpTEzlA4VGdP1W4MZEIYGNlo7nMCNNqkl1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 21:33:20.3715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 783fdb48-ce6d-4481-4a60-08dc37128d99
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0b8b346a470a..68da482713cf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -140,6 +140,13 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_IA32_U_CET,                      .always = false },
+	{ .index = MSR_IA32_S_CET,                      .always = false },
+	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
+	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1222,6 +1229,25 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP,
+				     shstk_enabled, shstk_enabled);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..0741fa049fd7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	47
+#define MAX_DIRECT_ACCESS_MSRS	54
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.40.1


