Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AD719031A
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 01:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCXAzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 20:55:49 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51929 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgCXAzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 20:55:48 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48mXqP38C5z9sQt; Tue, 24 Mar 2020 11:55:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1585011345; bh=orGAd6AY4uP0sBwXn2BYvY+3dd++PXcSgm0Dyj3lsJo=;
        h=Date:From:To:Cc:Subject:From;
        b=BWY6fHO8gP8t5apiErS8ghU7MI+IBGHy+OyBTlqaoABB/0jifktVge1epVsYNG7Ef
         sqJd9AkCs7yNBS4pea3ymYyAtESkr19B4zIutJKOGKdED+xWtMBCDLaHjuhyDqWrvm
         R+VS2FmYbUJqCDmYtP2bGKu0igZwPKKYgqZ8nrvBaVoaxg580sxPGuaW3vXMLsYLjA
         hP58yvm92pbXpMXL1EGMSckVgO5b0QVuo/rYq3vEul/nPyhk/a67s8RjvDd8BmOBH3
         eIyabyCDV6BbKnZTSSeOFcXJWOsD5KG5ozBkLMuEMtkzq2xODAOpwqMzW7IEu3XSD9
         y/Xu6X+7jwPUQ==
Date:   Tue, 24 Mar 2020 11:55:39 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v2] KVM: PPC: Book3S HV: Add a capability for enabling secure
 guests
Message-ID: <20200324005539.GB5604@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At present, on Power systems with Protected Execution Facility
hardware and an ultravisor, a KVM guest can transition to being a
secure guest at will.  Userspace (QEMU) has no way of knowing
whether a host system is capable of running secure guests.  This
will present a problem in future when the ultravisor is capable of
migrating secure guests from one host to another, because
virtualization management software will have no way to ensure that
secure guests only run in domains where all of the hosts can
support secure guests.

This adds a VM capability which has two functions: (a) userspace
can query it to find out whether the host can support secure guests,
and (b) userspace can enable it for a guest, which allows that
guest to become a secure guest.  If userspace does not enable it,
KVM will return an error when the ultravisor does the hypercall
that indicates that the guest is starting to transition to a
secure guest.  The ultravisor will then abort the transition and
the guest will terminate.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
v2: Test that KVM uvmem code has initialized successfully as a
condition of reporting that we support secure guests.

 Documentation/virt/kvm/api.rst              | 17 +++++++++++++++++
 arch/powerpc/include/asm/kvm_book3s_uvmem.h |  6 ++++++
 arch/powerpc/include/asm/kvm_host.h         |  1 +
 arch/powerpc/include/asm/kvm_ppc.h          |  1 +
 arch/powerpc/kvm/book3s_hv.c                | 16 ++++++++++++++++
 arch/powerpc/kvm/book3s_hv_uvmem.c          | 13 +++++++++++++
 arch/powerpc/kvm/powerpc.c                  | 14 ++++++++++++++
 include/uapi/linux/kvm.h                    |  1 +
 8 files changed, 69 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 158d118..a925500 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5779,6 +5779,23 @@ it hard or impossible to use it correctly.  The availability of
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
 Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
 
+7.19 KVM_CAP_PPC_SECURE_GUEST
+------------------------------
+
+:Architectures: ppc
+
+This capability indicates that KVM is running on a host that has
+ultravisor firmware and thus can support a secure guest.  On such a
+system, a guest can ask the ultravisor to make it a secure guest,
+one whose memory is inaccessible to the host except for pages which
+are explicitly requested to be shared with the host.  The ultravisor
+notifies KVM when a guest requests to become a secure guest, and KVM
+has the opportunity to veto the transition.
+
+If present, this capability can be enabled for a VM, meaning that KVM
+will allow the transition to secure guest mode.  Otherwise KVM will
+veto the transition.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
index 5a9834e..9cb7d8b 100644
--- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
+++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
@@ -5,6 +5,7 @@
 #ifdef CONFIG_PPC_UV
 int kvmppc_uvmem_init(void);
 void kvmppc_uvmem_free(void);
+bool kvmppc_uvmem_available(void);
 int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot);
 void kvmppc_uvmem_slot_free(struct kvm *kvm,
 			    const struct kvm_memory_slot *slot);
@@ -30,6 +31,11 @@ static inline int kvmppc_uvmem_init(void)
 
 static inline void kvmppc_uvmem_free(void) { }
 
+static inline bool kvmppc_uvmem_available(void)
+{
+	return false;
+}
+
 static inline int
 kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 {
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6e8b8ff..f99b433 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -303,6 +303,7 @@ struct kvm_arch {
 	u8 radix;
 	u8 fwnmi_enabled;
 	u8 secure_guest;
+	u8 svm_enabled;
 	bool threads_indep;
 	bool nested_enable;
 	pgd_t *pgtable;
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index e716862..94f5a32 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -313,6 +313,7 @@ struct kvmppc_ops {
 			       int size);
 	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
 			      int size);
+	int (*enable_svm)(struct kvm *kvm);
 	int (*svm_off)(struct kvm *kvm);
 };
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 85e75b1..8b8e1ed 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5419,6 +5419,21 @@ static void unpin_vpa_reset(struct kvm *kvm, struct kvmppc_vpa *vpa)
 }
 
 /*
+ * Enable a guest to become a secure VM, or test whether
+ * that could be enabled.
+ * Called when the KVM_CAP_PPC_SECURE_GUEST capability is
+ * tested (kvm == NULL) or enabled (kvm != NULL).
+ */
+static int kvmhv_enable_svm(struct kvm *kvm)
+{
+	if (!kvmppc_uvmem_available())
+		return -EINVAL;
+	if (kvm)
+		kvm->arch.svm_enabled = 1;
+	return 0;
+}
+
+/*
  *  IOCTL handler to turn off secure mode of guest
  *
  * - Release all device pages
@@ -5538,6 +5553,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.enable_nested = kvmhv_enable_nested,
 	.load_from_eaddr = kvmhv_load_from_eaddr,
 	.store_to_eaddr = kvmhv_store_to_eaddr,
+	.enable_svm = kvmhv_enable_svm,
 	.svm_off = kvmhv_svm_off,
 };
 
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 79b1202..da454e2 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -113,6 +113,15 @@ struct kvmppc_uvmem_page_pvt {
 	bool skip_page_out;
 };
 
+bool kvmppc_uvmem_available(void)
+{
+	/*
+	 * If kvmppc_uvmem_bitmap != NULL, then there is an ultravisor
+	 * and our data structures have been initialized successfully.
+	 */
+	return !!kvmppc_uvmem_bitmap;
+}
+
 int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 {
 	struct kvmppc_uvmem_slot *p;
@@ -216,6 +225,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	if (!kvm_is_radix(kvm))
 		return H_UNSUPPORTED;
 
+	/* NAK the transition to secure if not enabled */
+	if (!kvm->arch.svm_enabled)
+		return H_AUTHORITY;
+
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e229a81..c48862d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -669,6 +669,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
 		break;
 #endif
+#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE)
+	case KVM_CAP_PPC_SECURE_GUEST:
+		r = hv_enabled && kvmppc_hv_ops->enable_svm &&
+			!kvmppc_hv_ops->enable_svm(NULL);
+		break;
+#endif
 	default:
 		r = 0;
 		break;
@@ -2167,6 +2173,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = kvm->arch.kvm_ops->enable_nested(kvm);
 		break;
 #endif
+#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE)
+	case KVM_CAP_PPC_SECURE_GUEST:
+		r = -EINVAL;
+		if (!is_kvmppc_hv_enabled(kvm) || !kvm->arch.kvm_ops->enable_svm)
+			break;
+		r = kvm->arch.kvm_ops->enable_svm(kvm);
+		break;
+#endif
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e6234c..428c7dd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1016,6 +1016,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
+#define KVM_CAP_PPC_SECURE_GUEST 181
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4

