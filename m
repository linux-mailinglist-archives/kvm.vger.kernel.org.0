Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BAF16372F
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgBRXaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:38644 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgBRX36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936690"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:58 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/13] KVM: x86: Add variable to control existence of emulator
Date:   Tue, 18 Feb 2020 15:29:52 -0800
Message-Id: <20200218232953.5724-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
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
index 0dfe11f30d7f..c4baac32a291 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1050,7 +1050,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	int (*check_processor_compatibility)(void);/* __init */
-	int (*hardware_setup)(void);               /* __init */
+	int (*hardware_setup)(bool enable_emulator); /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(int index);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ae62ea454158..810139b3bfe4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1350,7 +1350,7 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
-static __init int svm_hardware_setup(void)
+static __init int svm_hardware_setup(bool enable_emulator)
 {
 	int cpu;
 	struct page *iopm_pages;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 09bb0d98afeb..e05d36f63b73 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7548,7 +7548,7 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.vmxon;
 }
 
-static __init int hardware_setup(void)
+static __init int hardware_setup(bool enable_emulator)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
@@ -7595,6 +7595,11 @@ static __init int hardware_setup(void)
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
index 7bffdc6f9e1b..f9134e1104c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -159,6 +159,8 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
+static const bool enable_emulator = true;
+
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
@@ -6474,6 +6476,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
+	if (WARN_ON_ONCE(!ctxt))
+		return;
+
 	init_emulate_ctxt(ctxt);
 
 	ctxt->op_bytes = 2;
@@ -6791,6 +6796,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	bool writeback = true;
 	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 
+	if (!ctxt)
+		return internal_emulation_error(vcpu);
+
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	/*
@@ -8785,7 +8793,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
-	if (vcpu->arch.emulate_regs_need_sync_to_vcpu) {
+	if (vcpu->arch.emulate_regs_need_sync_to_vcpu &&
+	    !(WARN_ON_ONCE(!vcpu->arch.emulate_ctxt))) {
 		/*
 		 * We are here if userspace calls get_regs() in the middle of
 		 * instruction emulation. Registers state needs to be copied
@@ -8982,6 +8991,9 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
+	if (!ctxt)
+		return internal_emulation_error(vcpu);
+
 	init_emulate_ctxt(ctxt);
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
@@ -9345,7 +9357,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 				GFP_KERNEL_ACCOUNT))
 		goto fail_free_mce_banks;
 
-	if (!alloc_emulate_ctxt(vcpu))
+	if (enable_emulator && !alloc_emulate_ctxt(vcpu))
 		goto free_wbinvd_dirty_mask;
 
 	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
@@ -9651,7 +9663,7 @@ int kvm_arch_hardware_setup(void)
 {
 	int r;
 
-	r = kvm_x86_ops->hardware_setup();
+	r = kvm_x86_ops->hardware_setup(enable_emulator);
 	if (r != 0)
 		return r;
 
-- 
2.24.1

