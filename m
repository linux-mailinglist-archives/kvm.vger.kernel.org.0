Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130BB27612
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfEWGgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 02:36:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42601 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfEWGgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 02:36:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 458ft33wcNz9s9T; Thu, 23 May 2019 16:36:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558593403; bh=kui+3K3xhU9wSNTXYHthRqjWMp0R/dcN2Dkp/OTAGU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEZVbThwUsV3Pr79sfWQYMVThqnJqoHJb70TN8ALD1ArumS1WnbBLxNt4SjA+Cx9S
         3RaYhwPS2Nf/dUnQ3Nxao0pOPO3QHivUPEWQhhyXXRfeBTpQ3lM81ANYa8R9+Em0Uv
         4ac1QIGXUBXp/dKLTbYLERgtU3EnjzZP1sFJPXAkJrfkVqGauGBYRZC2oPOO2H1ZUu
         rjtBtbbBLZzyw8NXElzVdG5LWjp5EwgIyb8uR6ZlEnND3jLW/QHug+9u/4iJ+pSySx
         WVM7VX36TY05jE5h6XovxCMR266EOtAngiOqaj5sP0dq/XMhBBcI+AuYU6gcRGl0sQ
         N8bsZQk3nvBEA==
Date:   Thu, 23 May 2019 16:35:34 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: [PATCH 2/4] KVM: PPC: Book3S HV: Use new mutex to synchronize MMU
 setup
Message-ID: <20190523063534.GD19655@blackberry>
References: <20190523063424.GB19655@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523063424.GB19655@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the HV KVM code uses kvm->lock in conjunction with a flag,
kvm->arch.mmu_ready, to synchronize MMU setup and hold off vcpu
execution until the MMU-related data structures are ready.  However,
this means that kvm->lock is being taken inside vcpu->mutex, which
is contrary to Documentation/virtual/kvm/locking.txt and results in
lockdep warnings.

To fix this, we add a new mutex, kvm->arch.mmu_setup_lock, which nests
inside the vcpu mutexes, and is taken in the places where kvm->lock
was taken that are related to MMU setup.

Additionally we take the new mutex in the vcpu creation code at the
point where we are creating a new vcore, in order to provide mutual
exclusion with kvmppc_update_lpcr() and ensure that an update to
kvm->arch.lpcr doesn't get missed, which could otherwise lead to a
stale vcore->lpcr value.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 36 ++++++++++++++++++------------------
 arch/powerpc/kvm/book3s_hv.c        | 31 +++++++++++++++++++++++--------
 3 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 013c76a..26b3ce4 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -325,6 +325,7 @@ struct kvm_arch {
 #endif
 	struct kvmppc_ops *kvm_ops;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	struct mutex mmu_setup_lock;	/* nests inside vcpu mutexes */
 	u64 l1_ptcr;
 	int max_nested_lpid;
 	struct kvm_nested_guest *nested_guests[KVM_MAX_NESTED_GUESTS];
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index ab3d484..5197131 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -63,7 +63,7 @@ struct kvm_resize_hpt {
 	struct work_struct work;
 	u32 order;
 
-	/* These fields protected by kvm->lock */
+	/* These fields protected by kvm->arch.mmu_setup_lock */
 
 	/* Possible values and their usage:
 	 *  <0     an error occurred during allocation,
@@ -73,7 +73,7 @@ struct kvm_resize_hpt {
 	int error;
 
 	/* Private to the work thread, until error != -EBUSY,
-	 * then protected by kvm->lock.
+	 * then protected by kvm->arch.mmu_setup_lock.
 	 */
 	struct kvm_hpt_info hpt;
 };
@@ -139,7 +139,7 @@ long kvmppc_alloc_reset_hpt(struct kvm *kvm, int order)
 	long err = -EBUSY;
 	struct kvm_hpt_info info;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (kvm->arch.mmu_ready) {
 		kvm->arch.mmu_ready = 0;
 		/* order mmu_ready vs. vcpus_running */
@@ -183,7 +183,7 @@ long kvmppc_alloc_reset_hpt(struct kvm *kvm, int order)
 		/* Ensure that each vcpu will flush its TLB on next entry. */
 		cpumask_setall(&kvm->arch.need_tlb_flush);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return err;
 }
 
@@ -1447,7 +1447,7 @@ static void resize_hpt_pivot(struct kvm_resize_hpt *resize)
 
 static void resize_hpt_release(struct kvm *kvm, struct kvm_resize_hpt *resize)
 {
-	if (WARN_ON(!mutex_is_locked(&kvm->lock)))
+	if (WARN_ON(!mutex_is_locked(&kvm->arch.mmu_setup_lock)))
 		return;
 
 	if (!resize)
@@ -1474,14 +1474,14 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 	if (WARN_ON(resize->error != -EBUSY))
 		return;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	/* Request is still current? */
 	if (kvm->arch.resize_hpt == resize) {
 		/* We may request large allocations here:
-		 * do not sleep with kvm->lock held for a while.
+		 * do not sleep with kvm->arch.mmu_setup_lock held for a while.
 		 */
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&kvm->arch.mmu_setup_lock);
 
 		resize_hpt_debug(resize, "resize_hpt_prepare_work(): order = %d\n",
 				 resize->order);
@@ -1494,9 +1494,9 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 		if (WARN_ON(err == -EBUSY))
 			err = -EINPROGRESS;
 
-		mutex_lock(&kvm->lock);
+		mutex_lock(&kvm->arch.mmu_setup_lock);
 		/* It is possible that kvm->arch.resize_hpt != resize
-		 * after we grab kvm->lock again.
+		 * after we grab kvm->arch.mmu_setup_lock again.
 		 */
 	}
 
@@ -1505,7 +1505,7 @@ static void resize_hpt_prepare_work(struct work_struct *work)
 	if (kvm->arch.resize_hpt != resize)
 		resize_hpt_release(kvm, resize);
 
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 }
 
 long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
@@ -1522,7 +1522,7 @@ long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
 	if (shift && ((shift < 18) || (shift > 46)))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	resize = kvm->arch.resize_hpt;
 
@@ -1565,7 +1565,7 @@ long kvm_vm_ioctl_resize_hpt_prepare(struct kvm *kvm,
 	ret = 100; /* estimated time in ms */
 
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return ret;
 }
 
@@ -1588,7 +1588,7 @@ long kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
 	if (shift && ((shift < 18) || (shift > 46)))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 
 	resize = kvm->arch.resize_hpt;
 
@@ -1625,7 +1625,7 @@ long kvm_vm_ioctl_resize_hpt_commit(struct kvm *kvm,
 	smp_mb();
 out_no_hpt:
 	resize_hpt_release(kvm, resize);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return ret;
 }
 
@@ -1868,7 +1868,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 		return -EINVAL;
 
 	/* lock out vcpus from running while we're doing this */
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	mmu_ready = kvm->arch.mmu_ready;
 	if (mmu_ready) {
 		kvm->arch.mmu_ready = 0;	/* temporarily */
@@ -1876,7 +1876,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 		smp_mb();
 		if (atomic_read(&kvm->arch.vcpus_running)) {
 			kvm->arch.mmu_ready = 1;
-			mutex_unlock(&kvm->lock);
+			mutex_unlock(&kvm->arch.mmu_setup_lock);
 			return -EBUSY;
 		}
 	}
@@ -1963,7 +1963,7 @@ static ssize_t kvm_htab_write(struct file *file, const char __user *buf,
 	/* Order HPTE updates vs. mmu_ready */
 	smp_wmb();
 	kvm->arch.mmu_ready = mmu_ready;
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 
 	if (err)
 		return err;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d5fc624..b1c0a9b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2338,11 +2338,17 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 			pr_devel("KVM: collision on id %u", id);
 			vcore = NULL;
 		} else if (!vcore) {
+			/*
+			 * Take mmu_setup_lock for mutual exclusion
+			 * with kvmppc_update_lpcr().
+			 */
 			err = -ENOMEM;
 			vcore = kvmppc_vcore_create(kvm,
 					id & ~(kvm->arch.smt_mode - 1));
+			mutex_lock(&kvm->arch.mmu_setup_lock);
 			kvm->arch.vcores[core] = vcore;
 			kvm->arch.online_vcores++;
+			mutex_unlock(&kvm->arch.mmu_setup_lock);
 		}
 	}
 	mutex_unlock(&kvm->lock);
@@ -3859,7 +3865,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 	int r = 0;
 	struct kvm *kvm = vcpu->kvm;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (!kvm->arch.mmu_ready) {
 		if (!kvm_is_radix(kvm))
 			r = kvmppc_hv_setup_htab_rma(vcpu);
@@ -3869,7 +3875,7 @@ static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 			kvm->arch.mmu_ready = 1;
 		}
 	}
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return r;
 }
 
@@ -4478,7 +4484,8 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
 
 /*
  * Update LPCR values in kvm->arch and in vcores.
- * Caller must hold kvm->lock.
+ * Caller must hold kvm->arch.mmu_setup_lock (for mutual exclusion
+ * of kvm->arch.lpcr update).
  */
 void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned long mask)
 {
@@ -4530,7 +4537,7 @@ void kvmppc_setup_partition_table(struct kvm *kvm)
 
 /*
  * Set up HPT (hashed page table) and RMA (real-mode area).
- * Must be called with kvm->lock held.
+ * Must be called with kvm->arch.mmu_setup_lock held.
  */
 static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 {
@@ -4618,7 +4625,10 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 	goto out_srcu;
 }
 
-/* Must be called with kvm->lock held and mmu_ready = 0 and no vcpus running */
+/*
+ * Must be called with kvm->arch.mmu_setup_lock held and
+ * mmu_ready = 0 and no vcpus running.
+ */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
 	if (nesting_enabled(kvm))
@@ -4635,7 +4645,10 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	return 0;
 }
 
-/* Must be called with kvm->lock held and mmu_ready = 0 and no vcpus running */
+/*
+ * Must be called with kvm->arch.mmu_setup_lock held and
+ * mmu_ready = 0 and no vcpus running.
+ */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
 	int err;
@@ -4740,6 +4753,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 	char buf[32];
 	int ret;
 
+	mutex_init(&kvm->arch.mmu_setup_lock);
+
 	/* Allocate the guest's logical partition ID */
 
 	lpid = kvmppc_alloc_lpid();
@@ -5265,7 +5280,7 @@ static int kvmhv_configure_mmu(struct kvm *kvm, struct kvm_ppc_mmuv3_cfg *cfg)
 	if (kvmhv_on_pseries() && !radix)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.mmu_setup_lock);
 	if (radix != kvm_is_radix(kvm)) {
 		if (kvm->arch.mmu_ready) {
 			kvm->arch.mmu_ready = 0;
@@ -5293,7 +5308,7 @@ static int kvmhv_configure_mmu(struct kvm *kvm, struct kvm_ppc_mmuv3_cfg *cfg)
 	err = 0;
 
  out_unlock:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.mmu_setup_lock);
 	return err;
 }
 
-- 
2.7.4

