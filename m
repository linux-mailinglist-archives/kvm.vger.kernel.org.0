Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E258DFAA6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbfJVCAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:00:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:61609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387753AbfJVCAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 22:00:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 19:00:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293976"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 19:00:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 43/45] KVM: Drop kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit()
Date:   Mon, 21 Oct 2019 18:59:23 -0700
Message-Id: <20191022015925.31916-44-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_arch_vcpu_init() and kvm_arch_vcpu_uninit() now that all
arch specific implementations are nops.

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
index cc414de5acd3..d0d84a4c8165 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -330,7 +330,6 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 static inline bool kvm_arch_requires_vhe(void) { return false; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 static inline int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 92d7c384a4ed..7b46725f1bdb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -53,7 +53,6 @@ int kvm_arm_init_sve(void);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 98abc4278f42..c683364cc84b 100644
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
 int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
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
index 3078231bd384..3215ebce0ed9 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -797,16 +797,6 @@ static enum hrtimer_restart kvmppc_decrementer_wakeup(struct hrtimer *timer)
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
index abe60268335d..e0a542fd5559 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -913,7 +913,6 @@ extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c3c855fd909c..1ee64352440f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2703,11 +2703,6 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
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
index d8d3079af2c5..07b43cdc4d0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9403,16 +9403,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
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
 	vcpu->arch.l1tf_flush_l1d = true;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b8b0f0ab4d7..e5b4198cd267 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -845,9 +845,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
 
-int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b38088415cde..9079f7412379 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -328,11 +328,6 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	kvm_vgic_v4_disable_doorbell(vcpu);
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
index 1ae98c1f12b0..b1f4ee9c2c76 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -290,7 +290,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
-	int r;
 
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
@@ -304,10 +303,8 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
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
@@ -316,15 +313,7 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
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
@@ -335,7 +324,6 @@ static void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 	 * descriptors are already gone.
 	 */
 	put_pid(rcu_dereference_protected(vcpu->pid, 1));
-	kvm_arch_vcpu_uninit(vcpu);
 	free_page((unsigned long)vcpu->run);
 }
 
-- 
2.22.0

