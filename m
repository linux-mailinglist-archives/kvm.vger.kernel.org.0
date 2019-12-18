Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55C12555C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLRV4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:56:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:16969 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfLRV4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:56:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108191"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:51 -0800
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
Subject: [PATCH v2 43/45] KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
Date:   Wed, 18 Dec 2019 13:55:28 -0800
Message-Id: <20191218215530.2280-44-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit() now that all
arch specific implementations are nops.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm/include/asm/kvm_host.h   |  1 -
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/reset.c            |  5 -----
 arch/mips/kvm/mips.c              | 10 ----------
 arch/powerpc/kvm/powerpc.c        | 10 ----------
 arch/s390/include/asm/kvm_host.h  |  1 -
 arch/s390/kvm/kvm-s390.c          |  5 -----
 arch/x86/kvm/x86.c                | 10 ----------
 include/linux/kvm_host.h          |  3 ---
 virt/kvm/arm/arm.c                |  5 -----
 virt/kvm/kvm_main.c               | 16 ++--------------
 11 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index de81dd897a30..e26cad6d11b3 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -363,7 +363,6 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 static inline bool kvm_arch_requires_vhe(void) { return false; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b1de2b147729..7aef2e4114d8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -54,7 +54,6 @@ int kvm_arm_init_sve(void);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ff3512a0ca97..30b7ea680f66 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -204,11 +204,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-
-}
-
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.sve_state);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 879a7cbd5b54..2606f3f02b54 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1230,16 +1230,6 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
 	return kvm_mips_count_timeout(vcpu);
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-
-}
-
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 				  struct kvm_translation *tr)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 91cf94d4191e..80f2d1a3ca63 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -801,16 +801,6 @@ static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 #ifdef CONFIG_BOOKE
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 02f4c21c57f6..11ecc4071a29 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -914,7 +914,6 @@ extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bcdd542b96a2..c059b86aacd4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2700,11 +2700,6 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 /* needs disabled preemption to protect from TOD sync and vcpu_load/put */
 static void __start_cpu_timer_accounting(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 24671f487645..292f1e53a758 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9485,16 +9485,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 struct static_key kvm_no_apic_vcpu __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-
-}
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 792b122e44fa..aa28646d38be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -864,9 +864,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f6c641136501..ced72748802f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -360,11 +360,6 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f76b2155dfee..21533a472ead 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -324,7 +324,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
-	int r;
 
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
@@ -338,10 +337,8 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
-		goto fail;
-	}
+	if (!page)
+		return -ENOMEM;
 	vcpu->run = page_address(page);
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
@@ -350,15 +347,7 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
-	r = kvm_arch_vcpu_init(vcpu);
-	if (r < 0)
-		goto fail_free_run;
 	return 0;
-
-fail_free_run:
-	free_page((unsigned long)vcpu->run);
-fail:
-	return r;
 }
 
 static void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
@@ -369,7 +358,6 @@ static void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 	 * descriptors are already gone.
 	 */
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
-	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
 
-- 
2.24.1

