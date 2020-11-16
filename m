Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2762B4FD7
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgKPSeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:34:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:20621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732812AbgKPS16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:58 -0500
IronPort-SDR: jcX0cotuB5DQ5I8DdzFEE0nFNLgHdTEhch9ldXNgnstGJ2gVYBKXo/erB5Jt4Hzc8WZCRD4Fj1
 pG6+8cqkjmJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410007"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410007"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:57 -0800
IronPort-SDR: kC8KfD5uJvEgMJtpQZuTeRjmkn+Gk271FtRgtnGPztFCTZd/U8DIXuVlnpow33FCaCP2p+uUUw
 x3BKuxLRC+nA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527840"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:57 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 11/67] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the VM
Date:   Mon, 16 Nov 2020 10:25:56 -0800
Message-Id: <57c00ce15fbf83118ebcc476f9728ebca6326178.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++++---------
 arch/x86/kvm/x86.c     |  4 ++++
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..e001e3c9e4bc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1452,7 +1452,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		KVM_BUG_ON(1, vcpu->kvm);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..1c9ad3103c87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2245,7 +2245,7 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		KVM_BUG_ON(1, vcpu->kvm);
 		break;
 	}
 }
@@ -5006,6 +5006,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			return kvm_complete_insn_gp(vcpu, err);
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
+
 			err = kvm_set_cr3(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 4:
@@ -5031,14 +5032,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
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
@@ -5377,7 +5377,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 
 static int handle_nmi_window(struct kvm_vcpu *vcpu)
 {
-	WARN_ON_ONCE(!enable_vnmi);
+	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
+		return -EIO;
+
 	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
 	++vcpu->stat.nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
@@ -5950,7 +5952,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * below) should never happen as that means we incorrectly allowed a
 	 * nested VM-Enter with an invalid vmcs12.
 	 */
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
+		return -EIO;
 
 	/* If guest state is invalid, start emulating */
 	if (vmx->emulation_required)
@@ -6300,7 +6303,9 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	int max_irr;
 	bool max_irr_updated;
 
-	WARN_ON(!vcpu->arch.apicv_active);
+	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
+		return -EIO;
+
 	if (pi_test_on(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
 		/*
@@ -6382,7 +6387,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
 
-	if (WARN_ONCE(!is_external_intr(intr_info),
+	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d999b57f21a..19b53aedc6c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8722,6 +8722,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
+			r = -EIO;
+			goto out;
+		}
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
-- 
2.17.1

