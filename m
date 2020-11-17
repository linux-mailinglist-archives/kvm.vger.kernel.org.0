Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4C32B6B2B
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgKQRIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:52 -0500
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:24897
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727413AbgKQRIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hutrcnryru7O6H6/zNqlx+LNI3WXXRm4fruAEaNQM0g3fTDsG6NrZvEFUav7HwIY+J00bdb76Hs6Q0fTsyRKcfJxNYO6JDcPuMfqOuTSaKQqOCNFPq1jKlupTcxoWGgy9J37M7BuwPy/9PudbpNN13f/tDHt5y/IOtiU5eIVlgDNbwzPpVWeQ8MhZUZ0JJ864iqI+uC6V/zWDVCIGJVqmz75o9J6VBz0iDDwbH8vjGM9Z/ufbiyxTgqg/zCN+SN7xVqU1PnAj7r6sWxRopc7nFJCy3+L7k/uRj1rEg3N/EN7e9YM/wQYIZEZbedNKdZSvWyGWfS+GImeTKlEDEnOIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LYxUv95Wv7fCTQWpSrdTT6dtuinvzUijgNCJCuTA/w=;
 b=Wm1bwyixckfqllSmoL9KL/yTHDO3pHI4TimSpxJvm2QgOB5WGp8kTuJHVDRIGXRG/3MrzDJ85nL0VCl0Kpx6lyLAMh5tpFILXWC9CvcpL/VxOlBfUAVQhoWN9d4lTVF4A4HoF34rv262fhNK4wqSQZhQ+SrAxkzyhi45DX/YfX1gYFriA7LXfN4qTDV0c4kzte1KrSNERYLTFS7foGEVxoaAre7CSe3hd6ARNyO7l6MQyZv2XraF6zApyQT/evDPGW8xA1lLdV5AM+2e5EAILLJhwDhwx7iEqJh3oRn8mSLHzQpewt8F/qezucAd3W1Q6wlNCEA/gUQxTLwBpHdAFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LYxUv95Wv7fCTQWpSrdTT6dtuinvzUijgNCJCuTA/w=;
 b=lGXqpotZvHgxmRLEdJY+r0tlPkD5nlFZHwv/ZNcwW+zMUf+mWl2z7Xytxz42zz7txiWMIEtX0LPK6lXkNyoADf4+IWnKD9F9pSToTUUzkPhp2XVkcSy+lWz8RqL099TcWKjs0XfPeKfQURe6HZkyrLH21jDIP3VEyrNGdivhFYo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:43 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:43 +0000
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
Subject: [PATCH v4 07/34] KVM: SVM: Add required changes to support intercepts under SEV-ES
Date:   Tue, 17 Nov 2020 11:07:10 -0600
Message-Id: <562864056654085dd1e12ebb07f513e7d12f8ce0.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR19CA0006.namprd19.prod.outlook.com
 (2603:10b6:3:151::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR19CA0006.namprd19.prod.outlook.com (2603:10b6:3:151::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:08:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09ff8999-4d3e-44eb-a0aa-08d88b1b7001
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772A78DD1AB29E51BB9CF29ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5EmcRTB5zhzrjm8OprJ9IU1mlLAXSHZE591Fsr8vLdcJoV34Bdn4613aDEb286u0ycYCE8fg84Q3Tw1tRPvMXvyuFGijKDHNxt4N2Ga+hSHJN9xDTHbRKxfp91juAFehKOUVg8DoIpYCTp+FAV20armr7L4DaUbTgSBcvYXfz1nb1MgsVJA4WBoObgZe2wljBG10XZoHTqbP7ngxsOGnpLz/i55RKY+FW+KVUNE4uYzeNtqIpozTIoV0ZM7keVkdhQUMyFLDSgymKo+oVtrNufsW07Brqf/uMxVNmQyB6pDoeKi8pR87FKHAkgpkk1QIjLv9ey9pP74Xc9U7pQ9Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ekE0CSuL0Xju2+3BXQCcM84rp1E4kXHa3leRtbaLO0KcddbH1gf6FgznqoicmEMxFfUxczAp8L/3cHvntXaUIzelFXkdrMZXLtChfXcPGpO9jkL63cYVVDH0H0s7MX3PBFEYEXbF98+OwS1f11nb+NaNrYflAuoTV8/JGBZdBYhIfEdTWvYJHKInVoWnEd735RrQ7DYRyxsc7D6LZ9hR1wIA9cE00Jb78EW2tUiVqlNszKvk6stvLPrBRrDZ6ny0CtaiFMU2FZpXDLzXQhDKYXiorPahyHnWZDDVFx675KKGt76MjCXCa1P2Y0KKbySTD4lVnFhoLff9Liab/5fMPy98iJxlP6rvlIwBkUNqvklBy3Xy9WQtRiQD2xeOF+7NQC7k22/nwiU3flls9QPmS96/Rl4XKmA5DU6/2uRkxX37WmvYxEnoU4MpsKYr+zKApLg38OFCxbh6bH7t9ALJdn+fXid0n18xQQreLwU2xDXC0R0qqNs8TMMirM/wK4Fq2TS7oPZsCwuY89VK+asVWifHtjFIWLY8xFwk+znJxmqlDUK3HTbNsU9I8U7dBAa+/jv8pQVByIRr5IFui7yGJ4c/TrNH5xkL8m2EEjlpoxomg9MAeSG+GgsCXoB5ri/79X2D14VQR6guEhAPBYbpeg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ff8999-4d3e-44eb-a0aa-08d88b1b7001
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:43.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D31D43sWcoqkm3c/9LOW1ssoS4LiklRDhujPSd8s2Tq9kww1/JPFssZL7oTPr0ksIMPnUG6ydFMkJbC4KkQl9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

