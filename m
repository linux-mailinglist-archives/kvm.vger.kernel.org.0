Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35DF2760E
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 08:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfEWGgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 02:36:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36661 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfEWGgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 02:36:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 458ft34WT8z9s9y; Thu, 23 May 2019 16:36:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558593403; bh=OtPqCQFgkkeo8E7gxrpj22y1pW8L1gICcBwHEo6K42Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDvcIaRGeC13dLxgpS0AvOJUmXlmcYTNa7fDhTgWmuW24r71f6v+rl5Z5YQeWEGPr
         fetupnCLDYnRJMZW71M2Yc6tm68w35c2qoHcRK64gYqdbxnDsdxBvDnvohM4hSbKB2
         d2t5LooC6VePfwFQOvow0rnSvzH5MS1Oc0OF5LNM+kS9xW2Im6tNSBoiLLi2LPn9Xu
         7IECpKQOoBNag947QNGanDyaxSXeHR8BLqM5UyDI+6fH3oxsTmZaoXE61J7Q7aqdCt
         ggu5nha77dpmtjt/1JVmafteCp+s0X3ButV7gy8Z5zcEVYtXKuVCMgW73T7IY6tnJ4
         8UvUFDNo4+dew==
Date:   Thu, 23 May 2019 16:35:07 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: [PATCH 1/4] KVM: PPC: Book3S HV: Avoid touching arch.mmu_ready in
 XIVE release functions
Message-ID: <20190523063507.GC19655@blackberry>
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

Currently, kvmppc_xive_release() and kvmppc_xive_native_release() clear
kvm->arch.mmu_ready and call kick_all_cpus_sync() as a way of ensuring
that no vcpus are executing in the guest.  However, future patches will
change the mutex associated with kvm->arch.mmu_ready to a new mutex that
nests inside the vcpu mutexes, making it difficult to continue to use
this method.

In fact, taking the vcpu mutex for a vcpu excludes execution of that
vcpu, and we already take the vcpu mutex around the call to
kvmppc_xive_[native_]cleanup_vcpu().  Once the cleanup function is
done and we release the vcpu mutex, the vcpu can execute once again,
but because we have cleared vcpu->arch.xive_vcpu, vcpu->arch.irq_type,
vcpu->arch.xive_esc_vaddr and vcpu->arch.xive_esc_raddr, that vcpu will
not be going into XIVE code any more.  Thus, once we have cleaned up
all of the vcpus, we are safe to clean up the rest of the XIVE state,
and we don't need to use kvm->arch.mmu_ready to hold off vcpu execution.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_xive.c        | 28 ++++++++++++----------------
 arch/powerpc/kvm/book3s_xive_native.c | 28 ++++++++++++----------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 4953957..f623451 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1859,21 +1859,10 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 	struct kvm *kvm = xive->kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
-	int was_ready;
 
 	pr_devel("Releasing xive device\n");
 
-	debugfs_remove(xive->dentry);
-
 	/*
-	 * Clearing mmu_ready temporarily while holding kvm->lock
-	 * is a way of ensuring that no vcpus can enter the guest
-	 * until we drop kvm->lock.  Doing kick_all_cpus_sync()
-	 * ensures that any vcpu executing inside the guest has
-	 * exited the guest.  Once kick_all_cpus_sync() has finished,
-	 * we know that no vcpu can be executing the XIVE push or
-	 * pull code, or executing a XICS hcall.
-	 *
 	 * Since this is the device release function, we know that
 	 * userspace does not have any open fd referring to the
 	 * device.  Therefore there can not be any of the device
@@ -1881,9 +1870,8 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 	 * and similarly, the connect_vcpu and set/clr_mapped
 	 * functions also cannot be being executed.
 	 */
-	was_ready = kvm->arch.mmu_ready;
-	kvm->arch.mmu_ready = 0;
-	kick_all_cpus_sync();
+
+	debugfs_remove(xive->dentry);
 
 	/*
 	 * We should clean up the vCPU interrupt presenters first.
@@ -1892,12 +1880,22 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 		/*
 		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
 		 * (i.e. kvmppc_xive_[gs]et_icp) can be done concurrently.
+		 * Holding the vcpu->mutex also means that the vcpu cannot
+		 * be executing the KVM_RUN ioctl, and therefore it cannot
+		 * be executing the XIVE push or pull code or accessing
+		 * the XIVE MMIO regions.
 		 */
 		mutex_lock(&vcpu->mutex);
 		kvmppc_xive_cleanup_vcpu(vcpu);
 		mutex_unlock(&vcpu->mutex);
 	}
 
+	/*
+	 * Now that we have cleared vcpu->arch.xive_vcpu, vcpu->arch.irq_type
+	 * and vcpu->arch.xive_esc_[vr]addr on each vcpu, we are safe
+	 * against xive code getting called during vcpu execution or
+	 * set/get one_reg operations.
+	 */
 	kvm->arch.xive = NULL;
 
 	/* Mask and free interrupts */
@@ -1911,8 +1909,6 @@ static void kvmppc_xive_release(struct kvm_device *dev)
 	if (xive->vp_base != XIVE_INVALID_VP)
 		xive_native_free_vp_block(xive->vp_base);
 
-	kvm->arch.mmu_ready = was_ready;
-
 	/*
 	 * A reference of the kvmppc_xive pointer is now kept under
 	 * the xive_devices struct of the machine for reuse. It is
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 6a8e698..da31dd0 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -973,21 +973,10 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 	struct kvm *kvm = xive->kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
-	int was_ready;
-
-	debugfs_remove(xive->dentry);
 
 	pr_devel("Releasing xive native device\n");
 
 	/*
-	 * Clearing mmu_ready temporarily while holding kvm->lock
-	 * is a way of ensuring that no vcpus can enter the guest
-	 * until we drop kvm->lock.  Doing kick_all_cpus_sync()
-	 * ensures that any vcpu executing inside the guest has
-	 * exited the guest.  Once kick_all_cpus_sync() has finished,
-	 * we know that no vcpu can be executing the XIVE push or
-	 * pull code or accessing the XIVE MMIO regions.
-	 *
 	 * Since this is the device release function, we know that
 	 * userspace does not have any open fd or mmap referring to
 	 * the device.  Therefore there can not be any of the
@@ -996,9 +985,8 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 	 * connect_vcpu and set/clr_mapped functions also cannot
 	 * be being executed.
 	 */
-	was_ready = kvm->arch.mmu_ready;
-	kvm->arch.mmu_ready = 0;
-	kick_all_cpus_sync();
+
+	debugfs_remove(xive->dentry);
 
 	/*
 	 * We should clean up the vCPU interrupt presenters first.
@@ -1007,12 +995,22 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 		/*
 		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
 		 * (i.e. kvmppc_xive_native_[gs]et_vp) can be being done.
+		 * Holding the vcpu->mutex also means that the vcpu cannot
+		 * be executing the KVM_RUN ioctl, and therefore it cannot
+		 * be executing the XIVE push or pull code or accessing
+		 * the XIVE MMIO regions.
 		 */
 		mutex_lock(&vcpu->mutex);
 		kvmppc_xive_native_cleanup_vcpu(vcpu);
 		mutex_unlock(&vcpu->mutex);
 	}
 
+	/*
+	 * Now that we have cleared vcpu->arch.xive_vcpu, vcpu->arch.irq_type
+	 * and vcpu->arch.xive_esc_[vr]addr on each vcpu, we are safe
+	 * against xive code getting called during vcpu execution or
+	 * set/get one_reg operations.
+	 */
 	kvm->arch.xive = NULL;
 
 	for (i = 0; i <= xive->max_sbid; i++) {
@@ -1025,8 +1023,6 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
 	if (xive->vp_base != XIVE_INVALID_VP)
 		xive_native_free_vp_block(xive->vp_base);
 
-	kvm->arch.mmu_ready = was_ready;
-
 	/*
 	 * A reference of the kvmppc_xive pointer is now kept under
 	 * the xive_devices struct of the machine for reuse. It is
-- 
2.7.4

