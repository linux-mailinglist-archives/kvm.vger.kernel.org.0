Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2F42923C
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 09:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbfEXH7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 03:59:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:62735 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388959AbfEXH7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 03:59:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 00:59:19 -0700
X-ExtLoop1: 1
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2019 00:59:12 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tao3.xu@intel.com,
        jingqi.liu@intel.com
Subject: [PATCH v2 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Date:   Fri, 24 May 2019 15:56:36 +0800
Message-Id: <20190524075637.29496-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524075637.29496-1-tao3.xu@intel.com>
References: <20190524075637.29496-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index E1H
to determines the maximum time in TSC-quanta that the processor can reside
in either C0.1 or C0.2.

This patch is to emulate MSR IA32_UMWAIT_CONTROL in guest and
differentiate MSR_TEST_CTL between host and guest.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 arch/x86/kvm/x86.c     |  1 +
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a65ee7ea47b4..49e107692aee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1676,6 +1676,14 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!kvm_enable_usr_wait_pause(vmx->vcpu.kvm) ||
+			(!msr_info->host_initiated &&
+			 !guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG)))
+			return 1;
+
+		msr_info->data = vmx->msr_ia32_umwait_control;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -1838,6 +1846,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_write64(GUEST_BNDCFGS, data);
 		break;
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!kvm_enable_usr_wait_pause(vmx->vcpu.kvm) ||
+			!guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
+			return 1;
+
+		if (!data)
+			break;
+
+		vmx->msr_ia32_umwait_control = data;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -4085,6 +4103,8 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		++vmx->nmsrs;
 	}
 
+	vmx->msr_ia32_umwait_control = 0;
+
 	vm_exit_controls_init(vmx, vmx_vmexit_ctrl());
 
 	/* 22.2.1, 20.8.1 */
@@ -4123,6 +4143,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
+	vmx->msr_ia32_umwait_control = 0;
+
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(vcpu, 0);
@@ -6327,6 +6349,24 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
+static void atomic_switch_ia32_umwait_control(struct vcpu_vmx *vmx)
+{
+	u64 host_umwait_control;
+
+	if (!kvm_enable_usr_wait_pause(vmx->vcpu.kvm))
+		return;
+
+	if (rdmsrl_safe(MSR_IA32_UMWAIT_CONTROL, &host_umwait_control))
+		return;
+
+	if (vmx->msr_ia32_umwait_control != host_umwait_control)
+		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
+				      vmx->msr_ia32_umwait_control,
+				      host_umwait_control, false);
+	else
+		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
+}
+
 static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
@@ -6435,6 +6475,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
+	atomic_switch_ia32_umwait_control(vmx);
+
 	vmx_update_hv_timer(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 63d37ccce3dc..7b779f8816fb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -194,6 +194,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u64		      msr_ia32_umwait_control;
 
 	u32 vm_entry_controls_shadow;
 	u32 vm_exit_controls_shadow;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38a89c878c5d..245ed4a63765 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1138,6 +1138,7 @@ static u32 msrs_to_save[] = {
 	MSR_IA32_RTIT_ADDR1_A, MSR_IA32_RTIT_ADDR1_B,
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
+	MSR_IA32_UMWAIT_CONTROL,
 };
 
 static unsigned num_msrs_to_save;
-- 
2.20.1

