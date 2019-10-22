Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB491DFADC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbfJVCBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:01:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:61607 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387636AbfJVB7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293870"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:53 -0700
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
Subject: [PATCH 30/45] KVM: Move vcpu alloc and init invocation to common code
Date:   Mon, 21 Oct 2019 18:59:10 -0700
Message-Id: <20191022015925.31916-31-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all architectures tightly couple vcpu allocation/free with the
mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
common KVM code.

Move both allocation and initialization in a single patch to eliminate
thrash in arch specific code.  The bisection benefits of moving the two
pieces in separate patches is marginal at best, whereas the odds of
introducing a transient arch specific bug are non-zero.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       | 33 ++++++---------------------------
 arch/powerpc/kvm/powerpc.c | 27 ++++-----------------------
 arch/s390/kvm/kvm-s390.c   | 31 +++++--------------------------
 arch/x86/kvm/x86.c         | 28 ++--------------------------
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/arm/arm.c         | 29 ++---------------------------
 virt/kvm/kvm_main.c        | 21 ++++++++++++++++++---
 7 files changed, 38 insertions(+), 133 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8546bc6e09e7..92c9321b3f95 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -285,25 +285,14 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	int err, size;
 	void *gebase, *p, *handler, *refill_start, *refill_end;
 	int i;
 
-	struct kvm_vcpu *vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-
-	if (!vcpu) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-
-	if (err)
-		goto out_free_cpu;
-
-	kvm_debug("kvm @ %p: create cpu %d at %p\n", kvm, id, vcpu);
+	kvm_debug("kvm @ %p: create cpu %d at %p\n",
+		  vcpu->kvm, vcpu->vcpu_id, vcpu);
 
 	/*
 	 * Allocate space for host mode exception handlers that handle
@@ -318,7 +307,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 
 	if (!gebase) {
 		err = -ENOMEM;
-		goto out_uninit_cpu;
+		goto out;
 	}
 	kvm_debug("Allocated %d bytes for KVM Exception Handlers @ %p\n",
 		  ALIGN(size, PAGE_SIZE), gebase);
@@ -397,19 +386,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	vcpu->arch.last_sched_cpu = -1;
 	vcpu->arch.last_exec_cpu = -1;
 
-	return vcpu;
+	return 0;
 
 out_free_gebase:
 	kfree(gebase);
-
-out_uninit_cpu:
-	kvm_vcpu_uninit(vcpu);
-
-out_free_cpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-
 out:
-	return ERR_PTR(err);
+	return err;
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -421,9 +403,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 69a1a1c36909..b14e1314f020 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -721,32 +721,17 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
 	int err;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		return ERR_PTR(-ENOMEM);
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
 	err = kvmppc_core_vcpu_create(vcpu);
 	if (err)
-		goto uninit_vcpu;
+		return err;
 
 	vcpu->arch.wqp = &vcpu->wq;
-	kvmppc_create_vcpu_debugfs(vcpu, id);
-	return vcpu;
-
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-	return ERR_PTR(err);
+	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
+	return 0;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -776,10 +761,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	}
 
 	kvmppc_core_vcpu_free(vcpu);
-
-	kvm_vcpu_uninit(vcpu);
-
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2c965f11c276..1e4f3b9ad031 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2533,9 +2533,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
 	free_page((unsigned long)(vcpu->arch.sie_block));
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 static void kvm_free_vcpus(struct kvm *kvm)
@@ -3017,29 +3014,15 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
-				      unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
 	struct sie_page *sie_page;
 	int rc;
 
-	rc = -ENOMEM;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		goto out;
-
-	rc = kvm_vcpu_init(vcpu, kvm, id);
-	if (rc)
-		goto out_free_cpu;
-
-	rc = -ENOMEM;
-
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
 	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
 	if (!sie_page)
-		goto out_uninit_vcpu;
+		return -ENOMEM;
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
 	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
@@ -3090,15 +3073,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		 vcpu->arch.sie_block);
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
-	return vcpu;
+	return 0;
+
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
-out_uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-out_free_cpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(rc);
+	return rc;
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c72b104deaca..4d0cc3c9432f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9019,30 +9019,9 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
-						unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu;
-	int r;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!vcpu)
-		return ERR_PTR(-ENOMEM);
-
-	r = kvm_vcpu_init(vcpu, kvm, id);
-	if (r)
-		goto free_vcpu;
-
-	r = kvm_x86_ops->vcpu_create(vcpu);
-	if (r)
-		goto uninit_vcpu;
-	return vcpu;
-
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-	return ERR_PTR(r);
+	return kvm_x86_ops->vcpu_create(vcpu);
 }
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
@@ -9094,9 +9073,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f38d75f60c8c..8559d0448d0b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -857,7 +857,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id);
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index deb8a540538f..1ab151d43fd7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -264,32 +264,9 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	return 0;
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	int err;
-	struct kvm_vcpu *vcpu;
-
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		goto free_vcpu;
-
-	err = create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
-	if (err)
-		goto vcpu_uninit;
-
-	return vcpu;
-vcpu_uninit:
-	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(err);
+	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -304,8 +281,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
-	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dc6c721348dd..fb526bd55664 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -344,6 +344,9 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_arch_vcpu_destroy(vcpu);
+
+	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_destroy);
 
@@ -2663,12 +2666,20 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_decrement;
 
-	vcpu = kvm_arch_vcpu_create(kvm, id);
-	if (IS_ERR(vcpu)) {
-		r = PTR_ERR(vcpu);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu) {
+		r = -ENOMEM;
 		goto vcpu_decrement;
 	}
 
+	r = kvm_vcpu_init(vcpu, kvm, id);
+	if (r)
+		goto vcpu_free;
+
+	r = kvm_arch_vcpu_create(vcpu);
+	if (r)
+		goto vcpu_uninit;
+
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
 	r = kvm_arch_vcpu_setup(vcpu);
@@ -2711,6 +2722,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	debugfs_remove_recursive(vcpu->debugfs_dentry);
 vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
+vcpu_uninit:
+	kvm_vcpu_uninit(vcpu);
+vcpu_free:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
 	mutex_lock(&kvm->lock);
 	kvm->created_vcpus--;
-- 
2.22.0

