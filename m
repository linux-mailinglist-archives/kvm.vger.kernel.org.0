Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CC3281894
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388352AbgJBREJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:04:09 -0400
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:22494
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388286AbgJBREH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:04:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqAvSlXNREuGiLF8xvqOUxD0FHruSGn+pr72mfoKlKPPNicjmm604nTalCCks1UJ93su2qCcz9BBEOJoBVQhAiviNunkRjoNMg+kFvWVJux2g8bYKcs+dK3RL/P5e6z9VDaROOhe0rZ5L1mODqjD6GGeethv6Cszq+zPkOJW5PKQWFjBUGkg3oTSgMomRx7H9fAZ3ytfurmYY6Vq0jdfg8tvCjYbqWEuXCISCY+bdVkdQiJvgwbtj4mW7N4GG+NNc4mwpk20Zol2VNiMQBMmvKWE7KNuLzD84Wa0HCRfLvmYPXu8gaMwPbw+tWNAa/zA+y6A0MPxA7xH5/XWWJQ16Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORlbG9a7DJ+xKE6K2fhXzVwCkNcTcUEw3UAdmI1DUCY=;
 b=Np2mnAPHGVyR8yL8Hx6q81w8NDvq/KmVtiziIP7Z8jk5HZGnrfC5+VoqmrVTOrra1+GmQ7B7cQGbXDdl2+ivdSQpt5KAAXZMKCSh3LbidXGrNZwGL5E00+74Sk6ZShgVjf7uVFWkonyod6Eu+lGMN7TFeXeBwh1DDMiiyAOgCYV/eyn/9+M5J3Xu5S0M6kWF4Ny72iyDlqfgA2YlyBr10A6Dx3gFbdS3JxBkM2JYKbMRXen3Hg/XrGI2wlc3TQYb4QSX7VcGbA0cIyNubYFMq+N8U/lWOl/DPOUBYYsehSgW2nP0yIFEqrJn+1okhKDwuQP3fBlpGwBfA432q3lHKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORlbG9a7DJ+xKE6K2fhXzVwCkNcTcUEw3UAdmI1DUCY=;
 b=egYPmGdmVVmbe9AqUm39g3xUUoXFdqpd9en2SZyGcvD70GYR/H0HE6WQirjVdCAx/jdHX1jgT3VD4S2As2/sDXWxBUtDsEQWauj8R2Qrl3tRc9OrWEsngpOc+5qbCL2HMgOfeN7Su7grMyW9CrTbJl0H4cPERutBFh7K+4ugip8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:04:04 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:04:04 +0000
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
Subject: [RFC PATCH v2 06/33] KVM: SVM: Add required changes to support intercepts under SEV-ES
Date:   Fri,  2 Oct 2020 12:02:30 -0500
Message-Id: <11b5a8c1e9d8307db6ccf266c3f153715b24c3fd.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0008.namprd07.prod.outlook.com
 (2603:10b6:803:28::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0701CA0008.namprd07.prod.outlook.com (2603:10b6:803:28::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 17:04:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5278e9ec-3b2b-4708-42fe-08d866f52a95
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706D732CB021EB2334BAFCEEC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6P1YSdwa/wCjioX6wc9EG5wr9WoovoYZHMCGQojnH1G5XC7BMfaBWulQLcWfLpKQWLi2WsUiSK9AtMXh5TbMHtjVW7pXJvQcToygmmFgS6slZ1DuoJH0IHwMTCKHr9BsX7IKcs3xHlegO5FK7+6pHzg0+eL+lenfz1Cpyp9Ons3hUg8MM4/uwVvv3ObkBzCwBW/Uyd2tsVwdTIv0C7qRSuyx1Ug597Qe56T8094w67hIrU3+4CafkT7BQfZ3/8rFG0YtIOwW8mV4x/mQZNFXGZJTu9qFaNHtIDX58m/XWkiRe49JnpLLC5eYHFsKU1TEzAFsTZZu2eEbnEV6WMpsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: judeGBYL9kSxg91KgXpdnZ005PjgPZdY9faYAKBBO8GcQAYhyyZBw/WmvM5CxtL620Ir0hfYoHbcDeGkeedoEn5xyWGdHlGWBzWVHBYPl1qd1GkTkkFP3y4N1XVDPqYC5YwpPGWzSPbFuyZTvC+MA1IRW/yGINN/0lovYiQH/fEGaHKbkSDO68e51AamOei+CTEutWsqbo/E598F9Gv5rCwOfHK7PpxV5zDIFOfSw4OQgBLQwx8OUMoMrGCdCK4LFJinPNuVBHAubSci3uzss9hqisXsrQyU/1+ckSzIyaEP+BNV15MEajOYldJbJAFm7qCzwm+QWa8JXyYyfvzhYr7fz8qxQ/pumDD/DcMIgC2QRtEKO4nxeQSm3Lg/iCU+2f6QMFzB535dp2OKSR3YDzi56pT6f0a9vAap+Z6gdVsf847OFEr2QSWJQ5OQJP7z8RE+mzWbXQIvqs0KCDJRdGog3QH9OSukrGJUpwgLH4SNckTNQGPumWxz1TE8k3p1wAft4jg79iyo5NapI/JpUIT8vHfeQl7Xgwhr7/af/Ei5R9XPgB2if+AoPHO4J2fOdw5vsFdlOcwPB2pVWl+jrHimgbCkKtxhLwOdHDNmBJEvJdLku5mZHreizdoeQJ1H2wDLMoS1tT2xzgmzqcMg0Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5278e9ec-3b2b-4708-42fe-08d866f52a95
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:04:04.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPOXtluBKLCKNbX8OR2SfSbh7P/uPN5BGbrwL4k495Sk+KH5CcFviqdrVehlZjgk0MExJxUWVrHR2uALIgTxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
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
index 5bbdbaefcd9e..fb0e8a0881f8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -36,6 +36,7 @@
 #include <asm/mce.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
+#include <asm/traps.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -320,6 +321,13 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -331,6 +339,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	} else {
 		kvm_rip_write(vcpu, svm->next_rip);
 	}
+
+done:
 	svm_set_interrupt_shadow(vcpu, 0);
 
 	return 1;
@@ -1666,9 +1676,18 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
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
 
@@ -1688,7 +1707,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.efer & EFER_LME) {
+	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
@@ -2613,7 +2632,29 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -2802,7 +2843,27 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
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
@@ -2832,7 +2893,14 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
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
@@ -3095,10 +3163,13 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
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
@@ -3210,6 +3281,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
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
 
@@ -3278,6 +3356,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
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
 
@@ -3463,6 +3548,12 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
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
index c4015a43cc8a..08812eb0b73e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3909,7 +3909,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted)
+	if (vcpu->preempted && !vcpu->arch.guest_state_protected)
 		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
 
 	/*
@@ -8043,7 +8043,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
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

