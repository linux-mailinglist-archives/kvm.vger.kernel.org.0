Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228621B527B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgDWC0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:26:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:43423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbgDWCZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:56 -0400
IronPort-SDR: nrQqXwYFV/ErWlbNz4IlEj2p0bcbgwnKQhQvk/5JtQYs/qn8aQiciKLRWkfcxAK/2HBE5l4ry6
 GCr0LtxBh4rg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: yc5y/LBg8ss/whbeXqY+VOPxyY2Vfp3zmkfOzH2qDM24ETc0W/jl7ED60fbXcenVMheRiXOJb3
 3I2b6JfUoDEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273942"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 04/13] KVM: x86: Make return for {interrupt_nmi}_allowed() a bool instead of int
Date:   Wed, 22 Apr 2020 19:25:41 -0700
Message-Id: <20200423022550.15113-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return an actual bool for kvm_x86_ops' {interrupt_nmi}_allowed() hook to
better reflect the return semantics, and to avoid creating an even
bigger mess when the related VMX code is refactored in upcoming patches.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm/svm.c          | 9 +++++----
 arch/x86/kvm/vmx/vmx.c          | 8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 65dc2c88d8b2..787636acd648 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1139,8 +1139,8 @@ struct kvm_x86_ops {
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
-	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
-	int (*nmi_allowed)(struct kvm_vcpu *vcpu);
+	bool (*interrupt_allowed)(struct kvm_vcpu *vcpu);
+	bool (*nmi_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
 	void (*set_nmi_mask)(struct kvm_vcpu *vcpu, bool masked);
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb95283ab68d..f21f734861dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3062,11 +3062,12 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 		set_cr_intercept(svm, INTERCEPT_CR8_WRITE);
 }
 
-static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
+static bool svm_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
-	int ret;
+	bool ret;
+
 	ret = !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
 	      !(svm->vcpu.arch.hflags & HF_NMI_MASK);
 	ret = ret && gif_set(svm) && nested_svm_nmi(svm);
@@ -3094,14 +3095,14 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	}
 }
 
-static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
+static bool svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
 	if (!gif_set(svm) ||
 	     (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK))
-		return 0;
+		return false;
 
 	if (is_guest_mode(vcpu) && (svm->vcpu.arch.hflags & HF_VINTR_MASK))
 		return !!(svm->vcpu.arch.hflags & HF_HIF_MASK);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b31949..7dd42e7fef94 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4511,21 +4511,21 @@ void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 	}
 }
 
-static int vmx_nmi_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
-		return 0;
+		return false;
 
 	if (!enable_vnmi &&
 	    to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
-		return 0;
+		return false;
 
 	return	!(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
 		  (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI
 		   | GUEST_INTR_STATE_NMI));
 }
 
-static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
+static bool vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
-- 
2.26.0

