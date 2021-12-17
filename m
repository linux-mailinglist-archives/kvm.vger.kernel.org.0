Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92231478FCA
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbhLQPat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238255AbhLQPaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755009; x=1671291009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U3csfgTLbEXdbK8cw/YgoQNoInbEKp5oorFH3mqVag0=;
  b=oGwZ21HUIzb6QiNHFVrFGfLUtMmpaZMtTgTTIyG1at0HfVWpNS7bclNN
   VZm04JyAES6hGci8JeHnH+b/SvQ4xH/SDwTYfZXvUcbCDKVeGZZqU2sBq
   DR7ZZHQjBml/+C6Dqg+T/LuF8snznbt71tGQn2mMYhgIJykC/0AjE13F4
   S4hh21zKi3k9/3V47YO5Os+Nx3V0iYfRBXxV99mEs238FVtX0QpBINVES
   fTgKTRdrA6k4jWqOQaiSkfGkvwyoDHnJWrd6miWwugLV5GLndd1YiWx7A
   z3Zsr4p7DQ+ct4LG8yTYD3pPDL+YknrZAZuWWqvZzlsIcI+VB48vxt6SZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723478"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723478"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588478"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 22/23] kvm: x86: Disable interception for IA32_XFD on demand
Date:   Fri, 17 Dec 2021 07:30:02 -0800
Message-Id: <20211217153003.1719189-23-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Always intercepting IA32_XFD causes non-negligible overhead when this
register is updated frequently in the guest.

Disable r/w emulation after intercepting the first WRMSR(IA32_XFD)
with a non-zero value.

Disable WRMSR emulation implies that IA32_XFD becomes out-of-sync
with the software states in fpstate and the per-cpu xfd cache. Call
fpu_sync_guest_vmexit_xfd_state() to bring them back in-sync, before
preemption is enabled.

p.s. We have confirmed that SDM is being revised to say that
when setting IA32_XFD[18] the AMX register state is not guaranteed
to be preserved. This clarification avoids adding mess for a creative
guest which sets IA32_XFD[18]=1 before saving active AMX state to
its own storage.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 arch/x86/kvm/x86.c                 |  6 ++++++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..60c27f9990e9 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -30,6 +30,7 @@ KVM_X86_OP(update_exception_bitmap)
 KVM_X86_OP(get_msr)
 KVM_X86_OP(set_msr)
 KVM_X86_OP(get_segment_base)
+KVM_X86_OP_NULL(set_xfd_passthrough)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 860ed500580c..b513c12fa39e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -640,6 +640,7 @@ struct kvm_vcpu_arch {
 	u64 smi_count;
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
+	bool xfd_out_of_sync;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
@@ -1329,6 +1330,7 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*set_xfd_passthrough)(struct kvm_vcpu *vcpu);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 483075045253..97a823a3f23f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -162,6 +162,7 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+	MSR_IA32_XFD,
 #endif
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
@@ -1929,6 +1930,14 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 	return debugctl;
 }
 
+#ifdef CONFIG_X86_64
+static void vmx_set_xfd_passthrough(struct kvm_vcpu *vcpu)
+{
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
+	vcpu->arch.xfd_out_of_sync = true;
+}
+#endif
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -7664,6 +7673,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,
 	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_xfd_passthrough = vmx_set_xfd_passthrough,
 #endif
 
 	.setup_mce = vmx_setup_mce,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4df2ac24ffc1..bf9d3051cd6c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -340,7 +340,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	14
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 796a9f2d1f23..13ba1e066b55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3686,6 +3686,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
+
+		if (data && kvm_x86_ops.set_xfd_passthrough)
+			static_call(kvm_x86_set_xfd_passthrough)(vcpu);
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
@@ -10023,6 +10026,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, 0);
 
+	if (vcpu->arch.xfd_out_of_sync)
+		fpu_sync_guest_vmexit_xfd_state();
+
 	/*
 	 * Consume any pending interrupts, including the possible source of
 	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
-- 
2.27.0

