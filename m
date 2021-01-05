Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AE92EAD7F
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 15:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbhAEOj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 09:39:59 -0500
Received: from mail-bgr052100133013.outbound.protection.outlook.com ([52.100.133.13]:23221
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726306AbhAEOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 09:39:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTF2ieNNvNJgPKpmaJlzB7idAg4srA+ora5JtPwgRuD9Jv9JQ6H/GUnUnwSIuEP1Tfp2Z5vrHaxQzkB/R2MacECXAVOkqks78QEJX/0NhN7660KIyr1fiH+z5I/AmKp7Szr/B9X3yKDCLN6/HAWsmI0oj6CuiLKb+EpRZ2m2Wx6zL7uJ66ZC//FCDhPcjxP4ATxO2sGde1cSpwqhNELBJ5N9rUMK4LV38qIRnY7s8+cBtUOBmRPM/rfWtg7KcQ0hBvijQc9ArrvpDmxRh7om92zZnidrS5QjQ9qYrRjYKOoJPX8xY/6rSUkGNCBr8EUJyigSPFG7BteH997KefiLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWmtXyeDvdenIHo7jonu6FVstVSnTi5ke72Mn65Onzg=;
 b=eeCexQObmKcR4bjWFQUCU862Pv5YkqwgygAQ2UBYWJaJPy9v76MgSp0NpTIBQLIs6+3l3s8JG82gT6YSHv6SVU+FYcCKMUJFrfItYFfEnUyYVx6IzJAefJKirxt9cDKyABU1rotZlmHZyYtN2vPUJpYlZqG/aQFw+YFAm8MVnTyrFqLhScky28bufsC4QQ35w6L+1o//EOTVG/9f466Ppf1KNZgKocoZTymPEC/zZIrCERL7A4ezadU3ME2P8+SU+rGDu3pkGY4PXzQtCuAzP6xJ23JXkHNAzxNyIMM0YYWy+DWyKY236/UJteHRLvkEVCcokKLGx1DUhaqq/7vRHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWmtXyeDvdenIHo7jonu6FVstVSnTi5ke72Mn65Onzg=;
 b=hodJkFUF1lBRdTxwRrygXwhu+urH/rSZb1k1AxW28Uyp6w5JpkZ+PhPa8L+PLoKDjoWBffpcdQqhpDbLeIapkVTDMc9bEzFXLr9LlR6XqoPSEphoRRwjh9b2WdiKLBAo/cBZyMLHRucbOU786WxLgtG4Ow0phHcMVMqyC9r1Jk4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 5 Jan
 2021 14:39:01 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:39:01 +0000
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
Subject: [PATCH v3 3/3] KVM: SVM: use .prepare_guest_switch() to handle CPU register save/setup
Date:   Tue,  5 Jan 2021 08:37:50 -0600
Message-Id: <20210105143749.557054-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105143749.557054-1-michael.roth@amd.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.54.211]
X-ClientProxiedBy: YT1PR01CA0129.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::8) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.54.211) by YT1PR01CA0129.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 5 Jan 2021 14:39:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66648cd1-8b70-43ab-c824-08d8b187a4dd
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:
X-Microsoft-Antispam-PRVS: <CH2PR12MB50010348D6042CA18326A2E495D10@CH2PR12MB5001.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOCAkyBzJRLIqE6cbjf0GSAgCnCPtQuH1dxnFdCDRRhCXDGjYKAeu32VPM10OQriygoBdMaNOaFbResdDGI5eYpQpQxTKdLcL7gfxTfYodWLk9u/91+rDOwf+gnObF+4INXKa2SDPYuRcKMDBNB0ZweYE0My7RsARiFkBCK0mZDm5Gh+SL2t+ypmEhspB37xazfT2BGUT4Um6t46mzW0xVrib9kOTNOVPInkGe14HxaWKB43c0Ua4FdCKFh5iYbt04eJ+yUi2Y1L6E+4/bI27wZlCv354mKOqCQxCBUUezT0l87nybeDPTjggRzPo3vAY6kUH+VAe3y8PC2cpvmXFl8+FQswxS5r1MljY2iGgde5DM3b0RqCN5AibYLmv5o9zyb5HLjKkBV8O2POJ7UAUClC6T8TLZ+v4vtq4TzLSRXdU3F8fwSuMNFcaG9p94hISnlE/XN4buteujdF7+MdN5yb3XDd8r3eH1qM4xnscoBswYRg3YvTfR993ZEPYxAeHr85kALVbFuEJ6n8NCOrkhv8K92IhnW+YsrIQngZXhpGDoxiVFuzRRMXUsjP/5sTCt5+5ejMvYdhaL1aiinhaElfO9tX3/1Q2DZOfOyWfPD95HNIfLEUirDy/FESTWl8wmCMlfUIq6tYabbYKuJbCDj1SXEKqo+c9MeSSt67bR1dAp034pc1tYrq855cIcceoWXsPlDpbIzD9mWnqPOT0VrIhg1W896q8fxxGrdBnTBnW1S0zqqAMQhqfcwH4kM0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(2616005)(956004)(36756003)(186003)(6666004)(2906002)(44832011)(6486002)(478600001)(8936002)(54906003)(7416002)(8676002)(316002)(1076003)(6496006)(26005)(4326008)(66476007)(6916009)(66556008)(52116002)(86362001)(83380400001)(16526019)(66946007)(5660300002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HIyTkghe3R5KOwLoY3Km+0masD3airYmbb4J8QoaZl1eLNGLGIC/WOqgEtxQ?=
 =?us-ascii?Q?h1aHw6ZPFx0YoC4xwYofzkpqY5e7X+oIBYy8i+zhp0fp8Zmss73P9QDCN7wa?=
 =?us-ascii?Q?gI+DNhG8aOYuNLVuKIDA+BxtKUz5JB4yJ2Fzw05dvsuFv0untDWoFdBupA6C?=
 =?us-ascii?Q?OQA8+pYwcKHYdMMu1t6nJyN4k5CYAM0StCfc4ZKNjWr3Cx7GXOymZvZEWfA0?=
 =?us-ascii?Q?o+tc1gBGeufedmyNqdG3mCo+pBC7Ho1xL4oZYd6r2vSGoTcEnOQGFGWY1kZv?=
 =?us-ascii?Q?wMLvEsiRIHStHglp6lEuiTGREVnSjUNHVNe+5Es1K8hJjLEfYTc7hjyTMov4?=
 =?us-ascii?Q?lToM8qetW0BY+Uwr5nuqwXoFKhnjH6CfTPLMOK8NR8MhozSQdLpViUMirmG5?=
 =?us-ascii?Q?nC6naPdch1Gn41VeWftKZLm2bzKJtlqJswfw87JK/OIGz9+0n+6wj4bPYDT4?=
 =?us-ascii?Q?xnIMcLw1vlDdA1fuK34LfHONUeH/Br7Qz9UAjOQDW0w7fai4+OVzqRvMmME5?=
 =?us-ascii?Q?lu7Zg6qdTkmWkm2QvjRwmci4G1B2M1vMQVgCDYA8QQdMK89UiaxxWA1rD3co?=
 =?us-ascii?Q?Iqtqpm6jJCcaQHqx6DEpisQ1S1A7rovcpUkrx2lOCHNsfdOrYlDGREe5sSma?=
 =?us-ascii?Q?aRNVmeuRrGi1/jdyDUcNc4GTrB4LUkIVVO7JQ1dA68gowP1zImx/DUHCp+7t?=
 =?us-ascii?Q?vGz3waAykil8CHia9jaH45g5xRhnftIc7OhueakNYAX8siDVI/KRowtzhojO?=
 =?us-ascii?Q?Ik6e8tjlSmLPQrGgdrL2lN45Iq2Gh0hjPXviuA0IawrYxYICF4V22c/FHpND?=
 =?us-ascii?Q?qqU2WoewcUdkPkOkg5E7WPsba5iW+JMpV2oSM04KSTmZayYWLzv5rLHvKmdH?=
 =?us-ascii?Q?wBTp9vswDebMlj2CxhbBBWDL6BRVpU90JBE5owexAWymgWgSnOHnIBpPinUj?=
 =?us-ascii?Q?ll0/DMn1zqxD2DTMAAsRf8l3XfcpUlP9T093xQtFe838rsGCt2LeGUsw+EWt?=
 =?us-ascii?Q?mkST?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 14:39:01.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 66648cd1-8b70-43ab-c824-08d8b187a4dd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++TBYmOZ0V0i9/Sk65JTxs57InrsF1lL+/JcyWSQanYMfN+tcrQ4lPuZAlN3vPE0FC6643YYXiguZWHsTumnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
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
index 2a93b63322f4..9e7272adf861 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1990,11 +1990,10 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
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
@@ -2003,13 +2002,6 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
 	 */
 	asm volatile(__ex("vmsave") : : "a" (__sme_page_pa(sd->save_area)) : "memory");
 
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
@@ -2020,15 +2012,3 @@ void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu)
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
 }
-
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e1b5b452244..8f16402019e7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1359,6 +1359,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		svm->vmsa = page_address(vmsa_page);
 
 	svm->asid_generation = 0;
+	svm->guest_state_loaded = false;
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
@@ -1406,23 +1407,30 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
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
 		asm volatile(__ex("vmsave %%"_ASM_AX)
 			     : : "a" (page_to_phys(sd->save_area)) : "memory");
 	}
@@ -1434,10 +1442,42 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -1447,18 +1487,10 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
@@ -3536,10 +3568,6 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
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
index a476449862f8..52d30a6e879c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -171,6 +171,8 @@ struct vcpu_svm {
 	u64 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	bool guest_state_loaded;
 };
 
 struct svm_cpu_data {
@@ -569,8 +571,7 @@ int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
-void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
-void sev_es_vcpu_put(struct vcpu_svm *svm);
+void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 
 /* vmenter.S */
 
-- 
2.25.1

