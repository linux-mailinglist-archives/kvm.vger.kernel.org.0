Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B7030CAF0
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbhBBTGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:06:36 -0500
Received: from mail-mw2nam12hn2208.outbound.protection.outlook.com ([52.100.167.208]:25697
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239455AbhBBTEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:04:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6lJLddrHWoW1v45Twi0oiskpLG5+D7lySkGYrVKMI0V8tZyDqWfpFl60ERUfCEMBW0Oj/khlaxawIo5B0kjXKS3hMy4qB/AhTqZ1ygVlq1EZlgInN+hEhonCGq2SlNqN78BxkirSVk3XTMT0EGV9/6b94BxqgCRPhNy2UcOatF8n+PHbDenkWxkfJttVfsd2G43KWfOLSPsOkq+bA9d+eMi7v7QMnvSo865w5Vb9+nugrFih3gr8zA/GI83E6j/qFMviSFBt3a6hYjCVJQJUlUYU8XMgAeHZ2xWdez2Hn+uCXecX96LdlJR9mKWjdAeuiQ6N6TwjhDNS8Cq3IYVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/nvFN+9HDd8e9cnsaaK312iiEHHWt9QGWrDYJ27H98=;
 b=akCp1VUhWTwTQAM9ipS6uoOIEus3U0S9QTLp57HK/KgHeufn8AitTQEcRXuRLs3g37OYCcKP8T+dFEh/Oni11NA8ows8dt5sse3ePGwKnWQ+O2NMlbFqUBttLVLgLqvSAoqd7WbyU11nDQg+kq2oMl6buLK5+bnj2A8Aj3zaBeomWuqde3WhcUls6Y2zPvfLMX0Q9C+NEI0OmdI6R9wX9EmdQVHNxf1b4jijkam8Fn3moAFv1ygPPKJDb7uCP3wojO+9L11kf+QAqAbbk+jJbVXWI+QjCyCXtzUodw0xzEKF2eZQpcFCRqK21/Cw2TSIl4+jB5kZgks7mSvbtVM7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/nvFN+9HDd8e9cnsaaK312iiEHHWt9QGWrDYJ27H98=;
 b=XM6PIyX2IS+un5vjzSy/CeWnDubg3zVHmll+1nlVns4h3vx5EKKYCvJdzdLdUccGU4iDZRqYyBD5pKvx5QN1nAOzAwvZvvh7TRM5wr/D5INZWECqceRJVBlcJh8mBe4Xv8kUpEy16Eqk6vupWP5idNUQB++Y9UMsHomdoQKCitQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Tue, 2 Feb
 2021 19:02:07 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::81f6:605c:f345:b99f%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 19:02:07 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] KVM: SVM: use .prepare_guest_switch() to handle CPU register save/setup
Date:   Tue,  2 Feb 2021 13:01:26 -0600
Message-Id: <20210202190126.2185715-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202190126.2185715-1-michael.roth@amd.com>
References: <20210202190126.2185715-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.78.25]
X-ClientProxiedBy: SN6PR2101CA0020.namprd21.prod.outlook.com
 (2603:10b6:805:106::30) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.78.25) by SN6PR2101CA0020.namprd21.prod.outlook.com (2603:10b6:805:106::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.2 via Frontend Transport; Tue, 2 Feb 2021 19:02:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df7caf47-4aba-4a49-865c-08d8c7ad08f9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4264:
X-Microsoft-Antispam-PRVS: <CH2PR12MB426403D02E982E7CAED9F0AD95B59@CH2PR12MB4264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7iJoJx65TTBBJW/5LuIgKxRLqnopUoPfXxHqzcHHhy1OXw4/aGC6sDADAW3o9iqs1q0Avb+xQ644JUVEFAYJy1rM4ctZaTQgK3yIBx/8iE0zXAbd1F0R/zhJ2DihKs455UM6YTUIsSl4jSNPTbLNGrgpUXJYG+X7vZK3vKZ7AhUdTBGJpFvh1yl/BXNQEvXGwW955pfmaF1vIm5iYScggWek0+cDxteassmSZxNrOWBFMg2nIIFHwXWAnScrz/0nkMbXao8S8zvuwoN0pLZnICc1PLwgGVLIT4kS01LqC3uxzLdVGOi5I0U0DQYsIoEgKuBzntAXsp2rqauNqmhHYPeVKdGdqMuHDsR1gWPkMeFw92W+zy2HUa+lSsg2MJ5NqvZSbT86bMLW+JiAc+HGJG3vd7utGOMtdoPlFvKLo99PCjMrKp1wk3AQIjYaliwgb1kmwftmnpYTHKDQ+fQCyqKJDdd6o4rfa0t7R/zZt+tK9eAHXBiqFqUMi2VcxFctXzSCGI5xXITs0k7orZUB7W8yUwPZalqEDKUyHG2AiYSdIiM1HxFF+AQ1TAeX8wRemwhP1PfiJsnzoryM2MzxOXohBSGR254zDAO946IE7QvssKu1w0Euo0VxH8I0hc4ubeqymDROKkiNBkjbENlNwF7fQWDClS8h+3FhiA66ZbU9VE+ee5aNjlKfoYflJSQDHwG1Uc051FmJErDV+4j06k4f1pSpue+FrmfwbJU/94r09LQOhr/8P3l7KmL8eWLWFZIAk4NqQQrYqaw/fg8z36u7FcFmpzl8PJbjw+WhxevgR+qTznhnt0F1uBiYfyZEhN7SoHv4lELJSSrQHFdh1r6XnKJ8ay29pK68kr4A28PT6hke66adTBPY9MD53Cj1hmUvgRdNdhKRyxMHjBK+GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(6666004)(16526019)(66476007)(66556008)(2616005)(956004)(36756003)(8936002)(44832011)(26005)(2906002)(54906003)(83380400001)(86362001)(478600001)(8676002)(6916009)(7416002)(1076003)(6486002)(52116002)(4326008)(5660300002)(66946007)(6496006)(316002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h13GY79nFHJtv7WpZ8wq3F6TeK172sgeAC6ApvaDwOQYiAIWVBZz67NnXeU6?=
 =?us-ascii?Q?64Bpg+f+fdEiyrBTotr4QWMsiW6ygnFXP/eubOg2X3Mfw3kJ9ScWBPxDiV34?=
 =?us-ascii?Q?4ijwHsqIZEE+/t+RCE4BUS33VtKedaU6/pVnzkSyi8exDR+r4AQAUn6oDP1z?=
 =?us-ascii?Q?s/zjHmBgRLSiPdxMUn4nTwrfnPefGk0lOrAJLDo283qmqYrls6xXNkgjKch2?=
 =?us-ascii?Q?cd9lsYORG7K97DtzFDoeQKb2AZSHeeqrZvmjtP7weixLhb2HFE61Z4dM7xrz?=
 =?us-ascii?Q?wDoJ6ppp3JChxcsl2iJUtAI5AsZ64ScyUnDuneug2AkAdK48IUJpGm/E7CpA?=
 =?us-ascii?Q?A65NVeECClXiNHQvLIa94MNapCxhCQWDi/uV+kys9oyHoVa0lksFqZwhmteL?=
 =?us-ascii?Q?9hQcUTsQPUHKHlBIT82XMBA/95s6BlO2Nvpizf/G6/DOtigGluwjFILXcXft?=
 =?us-ascii?Q?KCcicrej1FzZys6KmOwmdnWBzz1p6o1aFQsyLcoYQLaEO5xBPcIyygrZxY4G?=
 =?us-ascii?Q?Kwg4g3kXZsD8M4/WjfOCMUFPMVMzRyPvDQKFVLMfa/C3t6L0jwuFQbj7EXne?=
 =?us-ascii?Q?rAET7b88Hs0IirbRSCIhf+1zevRh4SPFsKMRD+KmLUUoEnwPh9PY/VWMxfcY?=
 =?us-ascii?Q?r7azLrNdpEGgezAAya7ioRsZMaSyOHzwrXNyWyaVfF4qm7Nii7YT93BQxuA/?=
 =?us-ascii?Q?ifVAmy28//m2QzdjubcV8sAfEFG22X8OHgGxSSyUr/lr9Z13FVspyoDVMJQi?=
 =?us-ascii?Q?J+wywKl8vYabbI4fAWDHi5o8IZsFvvbpf7gYDReJRSletFi5iV+3g64EKhWw?=
 =?us-ascii?Q?SISFLB7f5NbpXfqewGKkBySehmjopXjlzwDSpJpq0K9ZHXLCVWxnKPY4Xzl4?=
 =?us-ascii?Q?NHitSA1tPqpGcUHNxhyeRRbrPBLBcZJxg9C6CuL3qgsVRYteWPpfmxv+KbfA?=
 =?us-ascii?Q?LqMnz6A+Vpzs5GW0ZeR2R8uXb6t/qhvfuUwLRl6KBInYevEAnPjwqSctLmcE?=
 =?us-ascii?Q?qE8xTtsvTiEo/xAutLjuK3Cu6/t0Hf0AcIqDrNBqFKb2EJXvdKwL1CnhZDqn?=
 =?us-ascii?Q?Yw4FmUN8bOuH0ViYRKkC5FEcATf99pzX6RXgiUinbxKAH2jIPFv7bjCEoLmK?=
 =?us-ascii?Q?Aiu6Q9kEIKcyfDKeEAFA4nz/0Fxr34FFq6S3bQWusQsu7rxo+9ptssvGDW2o?=
 =?us-ascii?Q?43cyGe2s09QhZiVK/zY+Nb6OS9zJodGth3NKWgZ6nm9gq0x8i1jHxakiTqDw?=
 =?us-ascii?Q?T7ceE1x4bT6/+arC6MVmvJ5kx0ntzNkf8depvBhwIoclvz4gsiEfN2FMs1nr?=
 =?us-ascii?Q?YMa+pARm4PbIgbBDHC/vDUDD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7caf47-4aba-4a49-865c-08d8c7ad08f9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 19:02:06.8677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4FcxDf/I4LCHdzfto936nvKpnnl6x0diVbKEi07+1sGFMB4gTjEgV/QfrWbMfBV+K4M09rmvfz8UJ8gE83Zhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently we save host state like user-visible host MSRs, and do some
initial guest register setup for MSR_TSC_AUX and MSR_AMD64_TSC_RATIO
in svm_vcpu_load(). Defer this until just before we enter the guest by
moving the handling to kvm_x86_ops.prepare_guest_switch() similarly to
how it is done for the VMX implementation.

Additionally, since handling of saving/restoring host user MSRs is the
same both with/without SEV-ES enabled, move that handling to common
code.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 +-----------
 arch/x86/kvm/svm/svm.c | 76 +++++++++++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.h |  5 +--
 3 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 87167ef8ca23..874ea309279f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2066,11 +2066,10 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
+void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	struct vmcb_save_area *hostsa;
-	unsigned int i;
 
 	/*
 	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
@@ -2079,13 +2078,6 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
 	 */
 	vmsave(__sme_page_pa(sd->save_area));
 
-	/*
-	 * Certain MSRs are restored on VMEXIT, only save ones that aren't
-	 * restored.
-	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-
 	/* XCR0 is restored on VMEXIT, save the current host value */
 	hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
 	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
@@ -2097,18 +2089,6 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
 	hostsa->xss = host_xss;
 }
 
-void sev_es_vcpu_put(struct vcpu_svm *svm)
-{
-	unsigned int i;
-
-	/*
-	 * Certain MSRs are restored on VMEXIT and were saved with vmsave in
-	 * sev_es_vcpu_load() above. Only restore ones that weren't.
-	 */
-	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-}
-
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ae897aaa4471..0059f1d14b82 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1361,6 +1361,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		svm->vmsa = page_address(vmsa_page);
 
 	svm->asid_generation = 0;
+	svm->guest_state_loaded = false;
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
@@ -1408,23 +1409,30 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 }
 
-static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
-	int i;
+	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	unsigned int i;
 
-	if (unlikely(cpu != vcpu->cpu)) {
-		svm->asid_generation = 0;
-		vmcb_mark_all_dirty(svm->vmcb);
-	}
+	if (svm->guest_state_loaded)
+		return;
+
+	/*
+	 * Certain MSRs are restored on VMEXIT (sev-es), or vmload of host save
+	 * area (non-sev-es). Save ones that aren't so we can restore them
+	 * individually later.
+	 */
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
+	/*
+	 * Save additional host state that will be restored on VMEXIT (sev-es)
+	 * or subsequent vmload of host save area.
+	 */
 	if (sev_es_guest(svm->vcpu.kvm)) {
-		sev_es_vcpu_load(svm, cpu);
+		sev_es_prepare_guest_switch(svm, vcpu->cpu);
 	} else {
-		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-
 		vmsave(__sme_page_pa(sd->save_area));
 	}
 
@@ -1435,10 +1443,42 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
 		}
 	}
+
 	/* This assumes that the kernel never uses MSR_TSC_AUX */
 	if (static_cpu_has(X86_FEATURE_RDTSCP))
 		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
 
+	svm->guest_state_loaded = true;
+}
+
+static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned int i;
+
+	if (!svm->guest_state_loaded)
+		return;
+
+	/*
+	 * Certain MSRs are restored on VMEXIT (sev-es), or vmload of host save
+	 * area (non-sev-es). Restore the ones that weren't.
+	 */
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
+		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+
+	svm->guest_state_loaded = false;
+}
+
+static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+
+	if (unlikely(cpu != vcpu->cpu)) {
+		svm->asid_generation = 0;
+		vmcb_mark_all_dirty(svm->vmcb);
+	}
+
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
 		indirect_branch_prediction_barrier();
@@ -1448,18 +1488,10 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int i;
-
 	avic_vcpu_put(vcpu);
+	svm_prepare_host_switch(vcpu);
 
 	++vcpu->stat.host_state_reload;
-	if (sev_es_guest(svm->vcpu.kvm)) {
-		sev_es_vcpu_put(svm);
-	} else {
-		for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
-			wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-	}
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -3614,10 +3646,6 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 	invlpga(gva, svm->vmcb->control.asid);
 }
 
-static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
-{
-}
-
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 66d83dfefe18..cfc495c71fc1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -172,6 +172,8 @@ struct vcpu_svm {
 	u64 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	bool guest_state_loaded;
 };
 
 struct svm_cpu_data {
@@ -570,9 +572,8 @@ int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
-void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
-void sev_es_vcpu_put(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 
 /* vmenter.S */
 
-- 
2.25.1

