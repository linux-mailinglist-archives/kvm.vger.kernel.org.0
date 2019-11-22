Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18689107AB7
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKVWkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfKVWkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029685"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] KVM: x86: Dynamically allocate per-vCPU emulation context
Date:   Fri, 22 Nov 2019 14:39:54 -0800
Message-Id: <20191122223959.13545-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the emulation context instead of embedding it in struct
kvm_vcpu_arch.

Dynamic allocation provides several benefits:

  - Shrinks the size x86 vcpus by ~2.5k bytes, dropping them back below
    the PAGE_ALLOC_COSTLY_ORDER threshold.
  - Allows for dropping the include of kvm_emulate.h from asm/kvm_host.h
    and moving kvm_emulate.h into KVM's private directory.
  - Allows a reducing KVM's attack surface by shrinking the amount of
    vCPU data that is exposed to usercopy.
  - Allows a future patch to disable the emulator entirely, which may or
    may not be a realistic endeavor.

Mark the entire struct as valid for usercopy to maintain existing
behavior with respect to hardened usercopy.  Future patches can shrink
the usercopy range to cover only what is necessary.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/x86.c                 | 62 ++++++++++++++++++++++++++----
 3 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 77cf6c11f66b..844e833609db 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -289,6 +289,7 @@ enum x86emul_mode {
 #define X86EMUL_SMM_INSIDE_NMI_MASK  (1 << 7)
 
 struct x86_emulate_ctxt {
+	void *vcpu;
 	const struct x86_emulate_ops *ops;
 
 	/* Register state before/after emulation. */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dec643f4ac78..eab45340eb2f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -671,7 +671,7 @@ struct kvm_vcpu_arch {
 
 	/* emulate context */
 
-	struct x86_emulate_ctxt emulate_ctxt;
+	struct x86_emulate_ctxt *emulate_ctxt;
 	bool emulate_regs_need_sync_to_vcpu;
 	bool emulate_regs_need_sync_from_vcpu;
 	int (*complete_userspace_io)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd6f010345d1..9092990d57ad 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -79,7 +79,7 @@ u64 __read_mostly kvm_mce_cap_supported = MCG_CTL_P | MCG_SER_P;
 EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
 
 #define emul_to_vcpu(ctxt) \
-	container_of(ctxt, struct kvm_vcpu, arch.emulate_ctxt)
+	((struct kvm_vcpu *)(ctxt)->vcpu)
 
 /* EFER defaults:
  * - enable syscall per default because its emulated by KVM
@@ -226,6 +226,19 @@ u64 __read_mostly host_xcr0;
 struct kmem_cache *x86_fpu_cache;
 EXPORT_SYMBOL_GPL(x86_fpu_cache);
 
+static struct kmem_cache *x86_emulator_cache;
+
+static struct kmem_cache *kvm_alloc_emulator_cache(void)
+{
+	return kmem_cache_create_usercopy("x86_emulator",
+					  sizeof(struct x86_emulate_ctxt),
+					  __alignof__(struct x86_emulate_ctxt),
+					  SLAB_ACCOUNT,
+					  0,
+					  sizeof(struct x86_emulate_ctxt),
+					  NULL);
+}
+
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
 
 static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
@@ -6324,6 +6337,23 @@ static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt;
+
+	ctxt = kmem_cache_zalloc(x86_emulator_cache, GFP_KERNEL_ACCOUNT);
+	if (!ctxt) {
+		pr_err("kvm: failed to allocate vcpu's emulator\n");
+		return NULL;
+	}
+
+	ctxt->vcpu = vcpu;
+	ctxt->ops = &emulate_ops;
+	vcpu->arch.emulate_ctxt = ctxt;
+
+	return ctxt;
+}
+
 static void init_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
@@ -6350,7 +6380,7 @@ static void init_emulate_ctxt(struct x86_emulate_ctxt *ctxt)
 
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
 	init_emulate_ctxt(ctxt);
@@ -6669,7 +6699,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			    int insn_len)
 {
 	int r;
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	bool writeback = true;
 	bool write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 
@@ -7251,10 +7281,16 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	x86_emulator_cache = kvm_alloc_emulator_cache();
+	if (!x86_emulator_cache) {
+		pr_err("kvm: failed to allocate cache for x86 emulator\n");
+		goto out_free_x86_fpu_cache;
+	}
+
 	shared_msrs = alloc_percpu(struct kvm_shared_msrs);
 	if (!shared_msrs) {
 		printk(KERN_ERR "kvm: failed to allocate percpu kvm_shared_msrs\n");
-		goto out_free_x86_fpu_cache;
+		goto out_free_x86_emulator_cache;
 	}
 
 	r = kvm_mmu_module_init();
@@ -7287,6 +7323,8 @@ int kvm_arch_init(void *opaque)
 
 out_free_percpu:
 	free_percpu(shared_msrs);
+out_free_x86_emulator_cache:
+	kmem_cache_destroy(x86_emulator_cache);
 out_free_x86_fpu_cache:
 	kmem_cache_destroy(x86_fpu_cache);
 out:
@@ -8602,7 +8640,7 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 		 * that usually, but some bad designed PV devices (vmware
 		 * backdoor interface) need this to work
 		 */
-		emulator_writeback_register_cache(&vcpu->arch.emulate_ctxt);
+		emulator_writeback_register_cache(vcpu->arch.emulate_ctxt);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 	}
 	regs->rax = kvm_rax_read(vcpu);
@@ -8784,7 +8822,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
 	init_emulate_ctxt(ctxt);
@@ -9109,6 +9147,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	if (vcpu->arch.emulate_ctxt)
+		kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	kvm_x86_ops->vcpu_free(vcpu);
 	free_cpumask_var(wbinvd_dirty_mask);
 }
@@ -9124,6 +9164,13 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		"guest TSC will not be reliable\n");
 
 	vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+	if (IS_ERR(vcpu))
+		return vcpu;
+
+	if (!alloc_emulate_ctxt(vcpu)) {
+		kvm_arch_vcpu_destroy(vcpu);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	return vcpu;
 }
@@ -9176,6 +9223,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 
+	if (vcpu->arch.emulate_ctxt)
+		kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
@@ -9418,7 +9467,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int r;
 
-	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
-- 
2.24.0

