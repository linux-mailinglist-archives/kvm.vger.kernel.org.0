Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD084C9B7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 10:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfFTItE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 04:49:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:39500 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731250AbfFTItD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 04:49:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 01:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="scan'208";a="243566364"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by orsmga001.jf.intel.com with ESMTP; 20 Jun 2019 01:48:59 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com, tao3.xu@intel.com
Subject: [PATCH v5 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Date:   Thu, 20 Jun 2019 16:46:19 +0800
Message-Id: <20190620084620.17974-3-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190620084620.17974-1-tao3.xu@intel.com>
References: <20190620084620.17974-1-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UMWAIT and TPAUSE instructions use IA32_UMWAIT_CONTROL at MSR index E1H
to determines the maximum time in TSC-quanta that the processor can reside
in either C0.1 or C0.2.

This patch emulates MSR IA32_UMWAIT_CONTROL in guest and differentiate
IA32_UMWAIT_CONTROL between host and guest. The variable
mwait_control_cached in arch/x86/power/umwait.c caches the MSR value, so
this patch uses it to avoid frequently rdmsr of IA32_UMWAIT_CONTROL.

Co-developed-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---

Changes in v5:
	remove vmx_waitpkg_supported() to fix guest can rdmsr or wrmsr
	when the feature is off (Xiaoyao)
	remove the atomic_switch_ia32_umwait_control() and move the
	codes into vmx_set_msr()
	rebase the patch because the kernel dependcy patch updated to
	v5: https://lkml.org/lkml/2019/6/19/972
---
 arch/x86/kernel/cpu/umwait.c |  3 ++-
 arch/x86/kvm/vmx/vmx.c       | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  3 +++
 arch/x86/kvm/x86.c           |  1 +
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index 4b2aff7b2d4d..db5c193ef136 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -15,7 +15,8 @@
  * MSR value. By default, umwait max time is 100000 in TSC-quanta and C0.2
  * is enabled
  */
-static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLED);
+u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLED);
+EXPORT_SYMBOL_GPL(umwait_control_cached);
 
 /*
  * Serialize access to umwait_control_cached and IA32_UMWAIT_CONTROL MSR
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b35bfac30a34..0fb55c8426e2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1679,6 +1679,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
+			return 1;
+
+		msr_info->data = vmx->msr_ia32_umwait_control;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -1841,6 +1847,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_write64(GUEST_BNDCFGS, data);
 		break;
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
+			return 1;
+
+		/* The reserved bit IA32_UMWAIT_CONTROL[1] should be zero */
+		if (data & BIT_ULL(1))
+			return 1;
+
+		vmx->msr_ia32_umwait_control = data;
+		if (vmx->msr_ia32_umwait_control != umwait_control_cached)
+			add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
+				vmx->msr_ia32_umwait_control,
+				umwait_control_cached, false);
+		else
+			clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -4126,6 +4148,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
 
+	vmx->msr_ia32_umwait_control = 0;
+
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
 	kvm_set_cr8(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 61128b48c503..8485bec7c38a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,6 +14,8 @@
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
 
+extern u32 umwait_control_cached;
+
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3
@@ -194,6 +196,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u64		      msr_ia32_umwait_control;
 
 	u32 vm_entry_controls_shadow;
 	u32 vm_exit_controls_shadow;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd759846..4480de459bf4 100644
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

