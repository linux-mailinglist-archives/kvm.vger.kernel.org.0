Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315E618ABD0
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 05:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgCSEdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 00:33:10 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36817 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCSEdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 00:33:10 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48jYtV5Ly0z9sSM; Thu, 19 Mar 2020 15:33:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584592386; bh=QAywpI3JOjIIEUTy46Gfhm93J1pIzZ8maKY0VqoIB8k=;
        h=Date:From:To:Cc:Subject:From;
        b=q3+vPPVHAr7M76upYnV+slNMg4FMb0q3It1nUOv0AXZln4DYvSJLAEfoCkkzo+6kQ
         984QRjlUMIAfhAAcI+tnYupptPT5aEMY2TLgI9qh9xgyhARFfkUwXlhElphX8UHgeC
         aCTyDbyQYzf3OJT4bosANZmvKI9jdxSvmmFKlJ6ycT4jbJcjijAUzCqlv122ahbxPw
         UMpzcNwvx2HNw7wPjkXgavG7E7Rk0MtxO6wJVNLA07i7L5Gix7J/wAKOZpFB6J9Clv
         SW2gtCB2aQwJAfOfRkO6lF5DwJhjgaiwmXVDMGeZQdJdA00OabsWCrq2ctVaOpHINu
         V7o5tb8rHCpxg==
Date:   Thu, 19 Mar 2020 15:33:01 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling secure
 guests
Message-ID: <20200319043301.GA13052@blackberry>
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
Note, only compile-tested.  Ram, please test.

 Documentation/virt/kvm/api.rst      | 17 +++++++++++++++++
 arch/powerpc/include/asm/kvm_host.h |  1 +
 arch/powerpc/include/asm/kvm_ppc.h  |  1 +
 arch/powerpc/kvm/book3s_hv.c        | 13 +++++++++++++
 arch/powerpc/kvm/book3s_hv_uvmem.c  |  4 ++++
 arch/powerpc/kvm/powerpc.c          | 13 +++++++++++++
 include/uapi/linux/kvm.h            |  1 +
 7 files changed, 50 insertions(+)

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
index 406ec46..0733618 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -316,6 +316,7 @@ struct kvmppc_ops {
 			       int size);
 	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
 			      int size);
+	int (*enable_svm)(struct kvm *kvm);
 	int (*svm_off)(struct kvm *kvm);
 };
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index fbc55a1..36da720 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5423,6 +5423,18 @@ static void unpin_vpa_reset(struct kvm *kvm, struct kvmppc_vpa *vpa)
 }
 
 /*
+ * Enable a guest to become a secure VM.
+ * Called when the KVM_CAP_PPC_SECURE_GUEST capability is enabled.
+ */
+static int kvmhv_enable_svm(struct kvm *kvm)
+{
+	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
+		return -EINVAL;
+	kvm->arch.svm_enabled = 1;
+	return 0;
+}
+
+/*
  *  IOCTL handler to turn off secure mode of guest
  *
  * - Release all device pages
@@ -5543,6 +5555,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.enable_nested = kvmhv_enable_nested,
 	.load_from_eaddr = kvmhv_load_from_eaddr,
 	.store_to_eaddr = kvmhv_store_to_eaddr,
+	.enable_svm = kvmhv_enable_svm,
 	.svm_off = kvmhv_svm_off,
 };
 
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 79b1202..2ad999f 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -216,6 +216,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
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
index 62ee66d..c32e6cc2 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
 		break;
 #endif
+#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
+	case KVM_CAP_PPC_SECURE_GUEST:
+		r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);
+		break;
+#endif
 	default:
 		r = 0;
 		break;
@@ -2170,6 +2175,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = kvm->arch.kvm_ops->enable_nested(kvm);
 		break;
 #endif
+#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
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

