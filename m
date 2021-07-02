Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C603BA5B5
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhGBWJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:51169 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233076AbhGBWH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951900"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951900"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814731"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 19/69] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the VM
Date:   Fri,  2 Jul 2021 15:04:25 -0700
Message-Id: <0e8760a26151f47dc47052b25ca8b84fffe0641e.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
 arch/x86/kvm/x86.c     |  4 ++++
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e088086f3de6..25c72925eb8a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1526,7 +1526,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		KVM_BUG_ON(1, vcpu->kvm);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d73ba7a6ff8d..6c043a160b30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2360,7 +2360,7 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		KVM_BUG_ON(1, vcpu->kvm);
 		break;
 	}
 }
@@ -5062,6 +5062,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			return kvm_complete_insn_gp(vcpu, err);
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
+
 			err = kvm_set_cr3(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 4:
@@ -5087,14 +5088,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		}
 		break;
 	case 2: /* clts */
-		WARN_ONCE(1, "Guest should always own CR0.TS");
-		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
-		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
-		return kvm_skip_emulated_instruction(vcpu);
+		KVM_BUG(1, vcpu->kvm, "Guest always owns CR0.TS");
+		return -EIO;
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
+
 			val = kvm_read_cr3(vcpu);
 			kvm_register_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
@@ -5404,7 +5404,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 
 static int handle_nmi_window(struct kvm_vcpu *vcpu)
 {
-	WARN_ON_ONCE(!enable_vnmi);
+	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
+		return -EIO;
+
 	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -5960,7 +5962,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * below) should never happen as that means we incorrectly allowed a
 	 * nested VM-Enter with an invalid vmcs12.
 	 */
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
+		return -EIO;
 
 	/* If guest state is invalid, start emulating */
 	if (vmx->emulation_required)
@@ -6338,7 +6341,9 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	int max_irr;
 	bool max_irr_updated;
 
-	WARN_ON(!vcpu->arch.apicv_active);
+	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
+		return -EIO;
+
 	if (pi_test_on(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
 		/*
@@ -6421,7 +6426,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
-	if (WARN_ONCE(!is_external_intr(intr_info),
+	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc45b2c47672..9244d1d560d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9153,6 +9153,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
+			r = -EIO;
+			goto out;
+		}
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
-- 
2.25.1

