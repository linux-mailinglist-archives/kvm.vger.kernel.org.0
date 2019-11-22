Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38A9107AAA
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfKVWkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbfKVWkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029707"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] KVM: x86: Add variable to control existence of emulator
Date:   Fri, 22 Nov 2019 14:39:58 -0800
Message-Id: <20191122223959.13545-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a global variable to control whether or not the emulator is enabled,
and make all necessary changes to gracefully handle reaching emulation
paths with the emulator disabled.

Running with VMX's unrestricted guest disabled requires special
consideration due to its use of kvm_inject_realmode_interrupt().  When
unrestricted guest is disabled, KVM emulates interrupts and exceptions
when the processor is in real mode, but does so without going through
the standard emulator loop.  Ideally, kvm_inject_realmode_interrupt()
would only log the interrupt and defer actual emulation to the standard
run loop, but that is a non-trivial change and a waste of resources
given that unrestricted guest is supported on all CPUs shipped within
the last decade.  Similarly, dirtying up the event injection stack for
such a legacy feature is undesirable.  To avoid the conundrum, prevent
disabling both the emulator and unrestricted guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  7 ++++++-
 arch/x86/kvm/x86.c              | 18 +++++++++++++++---
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ed14b11063c..9078ace7e376 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1031,7 +1031,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	int (*check_processor_compatibility)(void);/* __init */
-	int (*hardware_setup)(void);               /* __init */
+	int (*hardware_setup)(bool enable_emulator); /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(int index);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bc57bd01c7b3..89eefe0a74eb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1307,7 +1307,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static __init int svm_hardware_setup(void)
+static __init int svm_hardware_setup(bool enable_emulator)
 {
 	int cpu;
 	struct page *iopm_pages;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a192a3da5fc2..f5af898d5b1f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7600,7 +7600,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.vmxon;
 }
 
-static __init int hardware_setup(void)
+static __init int hardware_setup(bool enable_emulator)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
@@ -7647,6 +7647,11 @@ static __init int hardware_setup(void)
 	if (!cpu_has_virtual_nmis())
 		enable_vnmi = 0;
 
+	if (!enable_emulator && !enable_unrestricted_guest) {
+		pr_warn("kvm: unrestricted guest disabled, emulator must be enabled\n");
+		return -EIO;
+	}
+
 	/*
 	 * set_apic_access_page_addr() is used to reload apic access
 	 * page upon invalidation.  No need to do anything if not
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4667a51b4f25..312dd5f8172c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -155,6 +155,8 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
+static const bool enable_emulator = true;
+
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
@@ -6384,6 +6386,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
+	if (WARN_ON_ONCE(!ctxt))
+		return;
+
 	init_emulate_ctxt(ctxt);
 
 	ctxt->op_bytes = 2;
@@ -6704,6 +6709,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	bool writeback = true;
 	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 
+	if (!ctxt)
+		return internal_emulation_error(vcpu);
+
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	/*
@@ -8633,7 +8641,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
-	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
+	if (vcpu->arch.emulate_regs_need_sync_to_vcpu &&
+	    !(WARN_ON_ONCE(!vcpu->arch.emulate_ctxt))) {
 		/*
 		 * We are here if userspace calls get_regs() in the middle of
 		 * instruction emulation. Registers state needs to be copied
@@ -8826,6 +8835,9 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
+	if (!ctxt)
+		return internal_emulation_error(vcpu);
+
 	init_emulate_ctxt(ctxt);
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
@@ -9164,7 +9176,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (IS_ERR(vcpu))
 		return vcpu;
 
-	if (!alloc_emulate_ctxt(vcpu)) {
+	if (enable_emulator && !alloc_emulate_ctxt(vcpu)) {
 		kvm_arch_vcpu_destroy(vcpu);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -9410,7 +9422,7 @@ int kvm_arch_hardware_setup(void)
 {
 	int r;
 
-	r = kvm_x86_ops->hardware_setup();
+	r = kvm_x86_ops->hardware_setup(enable_emulator);
 	if (r != 0)
 		return r;
 
-- 
2.24.0

