Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3ACB125587
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfLRVzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:55:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:56974 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbfLRVzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108168"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 38/45] KVM: x86: Move all vcpu init code into kvm_arch_vcpu_create()
Date:   Wed, 18 Dec 2019 13:55:23 -0800
Message-Id: <20191218215530.2280-39-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold init() into create() now that the two are called back-to-back by
common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
immediately thereafter).  This paves the way for removing
kvm_arch_vcpu_init() entirely.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 198 +++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 98 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20f8ac086824..24671f487645 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9100,11 +9100,78 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	int ret;
+	struct page *page;
+	int r;
 
-	ret = kvm_x86_ops->vcpu_create(vcpu);
-	if (ret)
-		return ret;
+	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
+	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
+
+	kvm_set_tsc_khz(vcpu, max_tsc_khz);
+
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		return r;
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
+		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
+		if (r < 0)
+			goto fail_mmu_destroy;
+	} else
+		static_key_slow_inc(&kvm_no_apic_vcpu);
+
+	r = -ENOMEM;
+
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto fail_free_lapic;
+	vcpu->arch.pio_data = page_address(page);
+
+	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+				       GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks)
+		goto fail_free_pio_data;
+	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
+
+	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
+				GFP_KERNEL_ACCOUNT))
+		goto fail_free_mce_banks;
+
+	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.user_fpu) {
+		pr_err("kvm: failed to allocate userspace's fpu\n");
+		goto free_wbinvd_dirty_mask;
+	}
+
+	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
+						 GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.guest_fpu) {
+		pr_err("kvm: failed to allocate vcpu's fpu\n");
+		goto free_user_fpu;
+	}
+	fx_init(vcpu);
+
+	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+
+	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+
+	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
+
+	kvm_async_pf_hash_reset(vcpu);
+	kvm_pmu_init(vcpu);
+
+	vcpu->arch.pending_external_vector = -1;
+	vcpu->arch.preempted_in_kernel = false;
+
+	kvm_hv_vcpu_init(vcpu);
+
+	r = kvm_x86_ops->vcpu_create(vcpu);
+	if (r)
+		goto free_guest_fpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -9114,6 +9181,22 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_init_mmu(vcpu, false);
 	vcpu_put(vcpu);
 	return 0;
+
+free_guest_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+free_user_fpu:
+	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
+free_wbinvd_dirty_mask:
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+fail_free_mce_banks:
+	kfree(vcpu->arch.mce_banks);
+fail_free_pio_data:
+	free_page((unsigned long)vcpu->arch.pio_data);
+fail_free_lapic:
+	kvm_free_lapic(vcpu);
+fail_mmu_destroy:
+	kvm_mmu_destroy(vcpu);
+	return r;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -9146,6 +9229,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	int idx;
+
 	kvmclock_reset(vcpu);
 
 	kvm_x86_ops->vcpu_free(vcpu);
@@ -9153,6 +9238,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
+
+	kvm_hv_vcpu_uninit(vcpu);
+	kvm_pmu_destroy(vcpu);
+	kfree(vcpu->arch.mce_banks);
+	kvm_free_lapic(vcpu);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_mmu_destroy(vcpu);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	free_page((unsigned long)vcpu->arch.pio_data);
+	if (!lapic_in_kernel(vcpu))
+		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -9391,106 +9487,12 @@ EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct page *page;
-	int r;
-
-	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
-	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-	else
-		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
-
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
-
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		return r;
-
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
-		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
-		if (r < 0)
-			goto fail_mmu_destroy;
-	} else
-		static_key_slow_inc(&kvm_no_apic_vcpu);
-
-	r = -ENOMEM;
-
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
-		goto fail_free_lapic;
-	vcpu->arch.pio_data = page_address(page);
-
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
-				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
-		goto fail_free_pio_data;
-	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
-
-	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask,
-				GFP_KERNEL_ACCOUNT))
-		goto fail_free_mce_banks;
-
-	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.user_fpu) {
-		pr_err("kvm: failed to allocate userspace's fpu\n");
-		goto free_wbinvd_dirty_mask;
-	}
-
-	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
-						 GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.guest_fpu) {
-		pr_err("kvm: failed to allocate vcpu's fpu\n");
-		goto free_user_fpu;
-	}
-	fx_init(vcpu);
-
-	vcpu->arch.guest_xstate_size = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
-
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-
-	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
-
-	kvm_async_pf_hash_reset(vcpu);
-	kvm_pmu_init(vcpu);
-
-	vcpu->arch.pending_external_vector = -1;
-	vcpu->arch.preempted_in_kernel = false;
-
-	kvm_hv_vcpu_init(vcpu);
-
 	return 0;
-
-free_user_fpu:
-	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-free_wbinvd_dirty_mask:
-	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
-fail_free_mce_banks:
-	kfree(vcpu->arch.mce_banks);
-fail_free_pio_data:
-	free_page((unsigned long)vcpu->arch.pio_data);
-fail_free_lapic:
-	kvm_free_lapic(vcpu);
-fail_mmu_destroy:
-	kvm_mmu_destroy(vcpu);
-	return r;
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	int idx;
 
-	kvm_hv_vcpu_uninit(vcpu);
-	kvm_pmu_destroy(vcpu);
-	kfree(vcpu->arch.mce_banks);
-	kvm_free_lapic(vcpu);
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	kvm_mmu_destroy(vcpu);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	free_page((unsigned long)vcpu->arch.pio_data);
-	if (!lapic_in_kernel(vcpu))
-		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-- 
2.24.1

