Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00A82AC860
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgKIW1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:27:16 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:13708
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730556AbgKIW1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:27:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvhqubRZVPnyWLaES/SJ2CQsJHXGsVjdu8AcgJHzpjtO+WSPx/ab+vWw9cnCtgDq5vd/L3H2RahycY36xIDElETrLnsbo+lbXFChSKrHRT+TtsMJNUJBt1iRF5IVqT5saFIGkUkuXvE5Sc1T7cfrPWyXD9RtZe4UO2sGCBJJcNBcl/OfBPiFkAf67HOg/hovDEHxOv1tF7ZZViuj8NEBPG9WOLcMSRv4qAFpJCPW39uGVTeTVzzbxzjomieGL2lEDc0BS070S8S7jI3mdduiT/13j/qcTMf2dPC+SHboIcTLzPwKu15yTmoM8kbRcnY1HnvZlt4fCGeh7qW4o9NzYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LYxUv95Wv7fCTQWpSrdTT6dtuinvzUijgNCJCuTA/w=;
 b=PX+wYhujHbn8XpK/Y/3Peqof9CrDjA+yRtVdDPh03rn+UggPtz+Ytgei2bUY/OP3yts63MPpanSNece1a+nhwxTYa4Qht8WG6hShhyEdpWxFwEN4pD7117TPayABBYZaqW2E2wJ/x+6l3BJpbqpTx+ZAMjU4fw3McmWaH3UXHAruqWnGHId2UDCX7qGO6PbVjOJVNbV5czrYA1R06wPcWLMgS2c5oVzfpx18r4EmAK2XjN5uSQm2Yig9nZ/UQ+8xhrXEwzgOWCmEg1sv28LxJ+5KwQBKEmThvOc23XmgtSkT0XlYmjpLCThxahiLAelsCZrrbqFqaZghYohhNjQ/rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LYxUv95Wv7fCTQWpSrdTT6dtuinvzUijgNCJCuTA/w=;
 b=kbRiI7WFXzqmuA3cCjmsdfyOrNl07EFbPqm7s4k/QzgSAtgp68dc5iGeSJTqp15tmxUcskqW2UHjJbWJgw6K820HlEh2WTHnlWkwAeH5aNUPBQl90pR5PH8+YJqrXmK1ruszQzuegMuDpBMqpzJR2kPtwXj9wk2ohSJ5ptfDzeQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:27:12 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:27:11 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 07/34] KVM: SVM: Add required changes to support intercepts under SEV-ES
Date:   Mon,  9 Nov 2020 16:25:33 -0600
Message-Id: <6d21d1d7d0e650217d948b4602a8be8ebc1aa57b.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0132.namprd07.prod.outlook.com
 (2603:10b6:3:13e::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR07CA0132.namprd07.prod.outlook.com (2603:10b6:3:13e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:27:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff2fc439-50ea-47d7-22fc-08d884fe9a3b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058F6FBD99E2D7F58A19335ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSW681KH1WpmdkzgVGdoq9K9V+KB8QoALf63SFEKapAjojs/VNJkNNnPLGR/2va/8o6iz1RUU9oh6IlKsiAJ3cerFs7SEGB2HYORDqqZSYwriqEkl2cRnWVXTawg6M49vYmOmB80kRZIHna9DDYJ45PNNZ6Q7FHpwPoFW2+m/BT9VZsksUqBHkHnJAK/7fEBPQ2bETKTXha6eRPbc6McWsUsvSqwpGQMW0e4Or8oM0TjjjJJKb/7g9h9jdsWNppVoNhcYyIt2f/E0YDhwK2E6ntoDP2AhNEkxCPXruuDa0q90cdL2nrm4gst9/o70LcqV9iyytfPvPxTGdh8D6tOxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6JIhzFNqn/u5lECxJ6BMLs5Uiw6knbTjsl9AsDBbXltpQEiTieDTYEcLeQLAEmUnhaFMYh5ngUoqTtosx4T07JPJlTUO6GNQrhJxFRcSie7b/34NWFwH2TxtHHIv2FtwsOpKMhPE/F/fNfkAN0SEpJUstabOVug/oO4e8HGrWxanduk7C+iowMFh/3GFNx9BAkfIhXucUnTNl0zx/fxu+XuUWf0I6kQlQcxIRSQAjJYNGmfuM5dqg6K58f1GaYOzwxTvuoVyramlZ15RORzNj1yzqtK5wW8azRDqNEiuvXH+l/ya/Emtf5BpKZSOqwJDNK4iclo/TbN1QoP0PYTTyJVTul+rw8JiKccY3OOfS6xCJXamyD6OCd/LRz5YtLkyCWGv6Qh1crXZRaDC7eR90hOY80w5rO/LjQJn7OGaajFGNN+oyxAuPT+XXsgvZp7J7UbBdm6xnNv/VNWWoZd5G5CVydZEuPzxh4cKtYsolovI5uF81bt+9pzEvcWPMzlxAm1AR5aVDTEMCs8S1ekWrF94DFkQCZI0UZr7YEIBjut4Fb9YPWpglNeQ7Y9eRGU0K0LaeIuVsrNnPb4+N/mXkM85PUrwftwZ/+aEQW5EfTCcHzPSdNNc2iIdt0bZqklpHaTDuhZtOh7Wi1Fg4AztTw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff2fc439-50ea-47d7-22fc-08d884fe9a3b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:27:11.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntnY/M6HMC9W8Q7uqNaXF/uIlu6ExSAQw3QiRK0Mpd04hig2KlTd/Zn5rz0Sw6T+yuD8I+o6u81O+143Z0qL5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest is running under SEV-ES, the hypervisor cannot access the
guest register state. There are numerous places in the KVM code where
certain registers are accessed that are not allowed to be accessed (e.g.
RIP, CR0, etc). Add checks to prevent register accesses and add intercept
update support at various points within the KVM code.

Also, when handling a VMGEXIT, exceptions are passed back through the
GHCB. Since the RDMSR/WRMSR intercepts (may) inject a #GP on error,
update the SVM intercepts to handle this for SEV-ES guests.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h |   3 +-
 arch/x86/kvm/svm/svm.c     | 111 +++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c         |   6 +-
 3 files changed, 107 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1edf24f51b53..bce28482d63d 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -178,7 +178,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
-#define SVM_INTERRUPT_SHADOW_MASK 1
+#define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
+#define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
 #define SVM_IOIO_STR_SHIFT 2
 #define SVM_IOIO_REP_SHIFT 3
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d45b2dc5cabe..9a3d57ed997f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -36,6 +36,7 @@
 #include <asm/mce.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
+#include <asm/traps.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -340,6 +341,13 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * SEV-ES does not expose the next RIP. The RIP update is controlled by
+	 * the type of exit and the #VC handler in the guest.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		goto done;
+
 	if (nrips && svm->vmcb->control.next_rip != 0) {
 		WARN_ON_ONCE(!static_cpu_has(X86_FEATURE_NRIPS));
 		svm->next_rip = svm->vmcb->control.next_rip;
@@ -351,6 +359,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
+
+done:
 	svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
@@ -1651,9 +1661,18 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
-	ulong gcr0 = svm->vcpu.arch.cr0;
-	u64 *hcr0 = &svm->vmcb->save.cr0;
+	ulong gcr0;
+	u64 *hcr0;
+
+	/*
+	 * SEV-ES guests must always keep the CR intercepts cleared. CR
+	 * tracking is done using the CR write traps.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return;
 
+	gcr0 = svm->vcpu.arch.cr0;
+	hcr0 = &svm->vmcb->save.cr0;
 	*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
 		| (gcr0 & SVM_CR0_SELECTIVE_MASK);
 
@@ -1673,7 +1692,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.efer & EFER_LME) {
+	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
@@ -2604,7 +2623,29 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static int rdmsr_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_rdmsr(&svm->vcpu);
+	u32 ecx;
+	u64 data;
+
+	if (!sev_es_guest(svm->vcpu.kvm))
+		return kvm_emulate_rdmsr(&svm->vcpu);
+
+	ecx = kvm_rcx_read(&svm->vcpu);
+	if (kvm_get_msr(&svm->vcpu, ecx, &data)) {
+		trace_kvm_msr_read_ex(ecx);
+		ghcb_set_sw_exit_info_1(svm->ghcb, 1);
+		ghcb_set_sw_exit_info_2(svm->ghcb,
+					X86_TRAP_GP |
+					SVM_EVTINJ_TYPE_EXEPT |
+					SVM_EVTINJ_VALID);
+		return 1;
+	}
+
+	trace_kvm_msr_read(ecx, data);
+
+	kvm_rax_write(&svm->vcpu, data & -1u);
+	kvm_rdx_write(&svm->vcpu, (data >> 32) & -1u);
+
+	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
 static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
@@ -2793,7 +2834,27 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 static int wrmsr_interception(struct vcpu_svm *svm)
 {
-	return kvm_emulate_wrmsr(&svm->vcpu);
+	u32 ecx;
+	u64 data;
+
+	if (!sev_es_guest(svm->vcpu.kvm))
+		return kvm_emulate_wrmsr(&svm->vcpu);
+
+	ecx = kvm_rcx_read(&svm->vcpu);
+	data = kvm_read_edx_eax(&svm->vcpu);
+	if (kvm_set_msr(&svm->vcpu, ecx, data)) {
+		trace_kvm_msr_write_ex(ecx, data);
+		ghcb_set_sw_exit_info_1(svm->ghcb, 1);
+		ghcb_set_sw_exit_info_2(svm->ghcb,
+					X86_TRAP_GP |
+					SVM_EVTINJ_TYPE_EXEPT |
+					SVM_EVTINJ_VALID);
+		return 1;
+	}
+
+	trace_kvm_msr_write(ecx, data);
+
+	return kvm_skip_emulated_instruction(&svm->vcpu);
 }
 
 static int msr_interception(struct vcpu_svm *svm)
@@ -2823,7 +2884,14 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 static int pause_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	bool in_kernel = (svm_get_cpl(vcpu) == 0);
+	bool in_kernel;
+
+	/*
+	 * CPL is not made available for an SEV-ES guest, so just set in_kernel
+	 * to true.
+	 */
+	in_kernel = (sev_es_guest(svm->vcpu.kvm)) ? true
+						  : (svm_get_cpl(vcpu) == 0);
 
 	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
@@ -3086,10 +3154,13 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
-	if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
-		vcpu->arch.cr0 = svm->vmcb->save.cr0;
-	if (npt_enabled)
-		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+	/* SEV-ES guests must use the CR write traps to track CR registers. */
+	if (!sev_es_guest(vcpu->kvm)) {
+		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
+			vcpu->arch.cr0 = svm->vmcb->save.cr0;
+		if (npt_enabled)
+			vcpu->arch.cr3 = svm->vmcb->save.cr3;
+	}
 
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
@@ -3201,6 +3272,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/*
+	 * SEV-ES guests must always keep the CR intercepts cleared. CR
+	 * tracking is done using the CR write traps.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return;
+
 	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
@@ -3269,6 +3347,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
+	/*
+	 * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
+	 * bit to determine the state of the IF flag.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return !(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
+
 	if (!gif_set(svm))
 		return true;
 
@@ -3454,6 +3539,12 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 		svm->vcpu.arch.nmi_injected = true;
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT:
+		/*
+		 * Never re-inject a #VC exception.
+		 */
+		if (vector == X86_TRAP_VC)
+			break;
+
 		/*
 		 * In case of software exceptions, do not reinject the vector,
 		 * but re-execute the instruction instead. Rewind RIP first
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447edc0d1d5a..3aafbd2540be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3997,7 +3997,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
 	/*
@@ -8156,7 +8156,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
-	kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
+	kvm_run->if_flag = (vcpu->arch.guest_state_protected)
+		? kvm_arch_interrupt_allowed(vcpu)
+		: (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
 	kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
 	kvm_run->apic_base = kvm_get_apic_base(vcpu);
-- 
2.28.0

