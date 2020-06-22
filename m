Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ECD2043FE
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbgFVWpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:45:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:27425 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgFVWmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:54 -0400
IronPort-SDR: G6SSKvUj6zHHGtv7PjRMcnMXFEy8oKPMkQlbnxl37s19r/DZUdkAxmJ5MdxVV0dT3pqrY9G9Lv
 STxQo3RbZURg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303561"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303561"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:51 -0700
IronPort-SDR: Dl8zm+EQRZM85TtvD8EIwG92M6HXrFkskY7uvVjO5nZcuTdxX1e49dv9KEePjG6D9bqzoO5tr+
 UhJzx6KWATRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634901"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] KVM: x86: Rename "shared_msrs" to "user_return_msrs"
Date:   Mon, 22 Jun 2020 15:42:35 -0700
Message-Id: <20200622224249.29562-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the "shared_msrs" mechanism, which is used to defer restoring
MSRs that are only consumed when running in userspace, to a more banal
but less likely to be confusing "user_return_msrs".

The "shared" nomenclature is confusing as it's not obvious who is
sharing what, e.g. reasonable interpretations are that the guest value
is shared by vCPUs in a VM, or that the MSR value is shared/common to
guest and host, both of which are wrong.

"shared" is also misleading as the MSR value (in hardware) is not
guaranteed to be shared/reused between VMs (if that's indeed the correct
interpretation of the name), as the ability to share values between VMs
is simply a side effect (albiet a very nice side effect) of deferring
restoration of the host value until returning from userspace.

"user_return" avoids the above confusion by describing the mechanism
itself instead of its effects.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/vmx/vmx.c          |  11 ++--
 arch/x86/kvm/x86.c              | 101 +++++++++++++++++---------------
 3 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..65a2c442bad7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1656,8 +1656,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
 
-void kvm_define_shared_msr(unsigned index, u32 msr);
-int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
 u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08e26a9518c2..ea79a02d905c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -653,8 +653,7 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
 	msr->data = data;
 	if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
 		preempt_disable();
-		ret = kvm_set_shared_msr(msr->index, msr->data,
-					 msr->mask);
+		ret = kvm_set_user_return_msr(msr->index, msr->data, msr->mask);
 		preempt_enable();
 		if (ret)
 			msr->data = old_msr_data;
@@ -1146,9 +1145,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!vmx->guest_msrs_ready) {
 		vmx->guest_msrs_ready = true;
 		for (i = 0; i < vmx->save_nmsrs; ++i)
-			kvm_set_shared_msr(vmx->guest_msrs[i].index,
-					   vmx->guest_msrs[i].data,
-					   vmx->guest_msrs[i].mask);
+			kvm_set_user_return_msr(vmx->guest_msrs[i].index,
+						vmx->guest_msrs[i].data,
+						vmx->guest_msrs[i].mask);
 
 	}
 
@@ -8002,7 +8001,7 @@ static __init int hardware_setup(void)
 	host_idt_base = dt.address;
 
 	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
-		kvm_define_shared_msr(i, vmx_msr_index[i]);
+		kvm_define_user_return_msr(i, vmx_msr_index[i]);
 
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..098b10ab2993 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -160,24 +160,29 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
-#define KVM_NR_SHARED_MSRS 16
+/*
+ * Restoring the host value for MSRs that are only consumed when running in
+ * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
+ * returns to userspace, i.e. the kernel can run with the guest's value.
+ */
+#define KVM_MAX_NR_USER_RETURN_MSRS 16
 
-struct kvm_shared_msrs_global {
+struct kvm_user_return_msrs_global {
 	int nr;
-	u32 msrs[KVM_NR_SHARED_MSRS];
+	u32 msrs[KVM_MAX_NR_USER_RETURN_MSRS];
 };
 
-struct kvm_shared_msrs {
+struct kvm_user_return_msrs {
 	struct user_return_notifier urn;
 	bool registered;
-	struct kvm_shared_msr_values {
+	struct kvm_user_return_msr_values {
 		u64 host;
 		u64 curr;
-	} values[KVM_NR_SHARED_MSRS];
+	} values[KVM_MAX_NR_USER_RETURN_MSRS];
 };
 
-static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
-static struct kvm_shared_msrs __percpu *shared_msrs;
+static struct kvm_user_return_msrs_global __read_mostly user_return_msrs_global;
+static struct kvm_user_return_msrs __percpu *user_return_msrs;
 
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
@@ -266,9 +271,9 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
-	struct kvm_shared_msrs *locals
-		= container_of(urn, struct kvm_shared_msrs, urn);
-	struct kvm_shared_msr_values *values;
+	struct kvm_user_return_msrs *msrs
+		= container_of(urn, struct kvm_user_return_msrs, urn);
+	struct kvm_user_return_msr_values *values;
 	unsigned long flags;
 
 	/*
@@ -276,73 +281,73 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	 * interrupted and executed through kvm_arch_hardware_disable()
 	 */
 	local_irq_save(flags);
-	if (locals->registered) {
-		locals->registered = false;
+	if (msrs->registered) {
+		msrs->registered = false;
 		user_return_notifier_unregister(urn);
 	}
 	local_irq_restore(flags);
-	for (slot = 0; slot < shared_msrs_global.nr; ++slot) {
-		values = &locals->values[slot];
+	for (slot = 0; slot < user_return_msrs_global.nr; ++slot) {
+		values = &msrs->values[slot];
 		if (values->host != values->curr) {
-			wrmsrl(shared_msrs_global.msrs[slot], values->host);
+			wrmsrl(user_return_msrs_global.msrs[slot], values->host);
 			values->curr = values->host;
 		}
 	}
 }
 
-void kvm_define_shared_msr(unsigned slot, u32 msr)
+void kvm_define_user_return_msr(unsigned slot, u32 msr)
 {
-	BUG_ON(slot >= KVM_NR_SHARED_MSRS);
-	shared_msrs_global.msrs[slot] = msr;
-	if (slot >= shared_msrs_global.nr)
-		shared_msrs_global.nr = slot + 1;
+	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
+	user_return_msrs_global.msrs[slot] = msr;
+	if (slot >= user_return_msrs_global.nr)
+		user_return_msrs_global.nr = slot + 1;
 }
-EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
+EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
 
-static void kvm_shared_msr_cpu_online(void)
+static void kvm_user_return_msr_cpu_online(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	u64 value;
 	int i;
 
-	for (i = 0; i < shared_msrs_global.nr; ++i) {
-		rdmsrl_safe(shared_msrs_global.msrs[i], &value);
-		smsr->values[i].host = value;
-		smsr->values[i].curr = value;
+	for (i = 0; i < user_return_msrs_global.nr; ++i) {
+		rdmsrl_safe(user_return_msrs_global.msrs[i], &value);
+		msrs->values[i].host = value;
+		msrs->values[i].curr = value;
 	}
 }
 
-int kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
+int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	unsigned int cpu = smp_processor_id();
-	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	int err;
 
-	value = (value & mask) | (smsr->values[slot].host & ~mask);
-	if (value == smsr->values[slot].curr)
+	value = (value & mask) | (msrs->values[slot].host & ~mask);
+	if (value == msrs->values[slot].curr)
 		return 0;
-	err = wrmsrl_safe(shared_msrs_global.msrs[slot], value);
+	err = wrmsrl_safe(user_return_msrs_global.msrs[slot], value);
 	if (err)
 		return 1;
 
-	smsr->values[slot].curr = value;
-	if (!smsr->registered) {
-		smsr->urn.on_user_return = kvm_on_user_return;
-		user_return_notifier_register(&smsr->urn);
-		smsr->registered = true;
+	msrs->values[slot].curr = value;
+	if (!msrs->registered) {
+		msrs->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&msrs->urn);
+		msrs->registered = true;
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_shared_msr);
+EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
 	unsigned int cpu = smp_processor_id();
-	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 
-	if (smsr->registered)
-		kvm_on_user_return(&smsr->urn);
+	if (msrs->registered)
+		kvm_on_user_return(&msrs->urn);
 }
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
@@ -7465,9 +7470,9 @@ int kvm_arch_init(void *opaque)
 		goto out_free_x86_fpu_cache;
 	}
 
-	shared_msrs = alloc_percpu(struct kvm_shared_msrs);
-	if (!shared_msrs) {
-		printk(KERN_ERR "kvm: failed to allocate percpu kvm_shared_msrs\n");
+	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+	if (!user_return_msrs) {
+		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
 		goto out_free_x86_emulator_cache;
 	}
 
@@ -7500,7 +7505,7 @@ int kvm_arch_init(void *opaque)
 	return 0;
 
 out_free_percpu:
-	free_percpu(shared_msrs);
+	free_percpu(user_return_msrs);
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 out_free_x86_fpu_cache:
@@ -7527,7 +7532,7 @@ void kvm_arch_exit(void)
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
 	kvm_mmu_module_exit();
-	free_percpu(shared_msrs);
+	free_percpu(user_return_msrs);
 	kmem_cache_destroy(x86_fpu_cache);
 }
 
@@ -9664,7 +9669,7 @@ int kvm_arch_hardware_enable(void)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	kvm_shared_msr_cpu_online();
+	kvm_user_return_msr_cpu_online();
 	ret = kvm_x86_ops.hardware_enable();
 	if (ret != 0)
 		return ret;
-- 
2.26.0

