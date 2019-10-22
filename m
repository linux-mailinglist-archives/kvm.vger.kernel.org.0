Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11504DFB39
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388030AbfJVCDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:03:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbfJVB7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293766"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:36 -0700
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
Subject: [PATCH 07/45] KVM: x86: Allocate vcpu struct in common x86 code
Date:   Mon, 21 Oct 2019 18:58:47 -0700
Message-Id: <20191022015925.31916-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move allocation of VMX and SVM vcpus to common x86.  Although the struct
being allocated is technically a VMX/SVM struct, it can be interpreted
directly as a 'struct kvm_vcpu' because of the pre-existing requirement
that 'struct kvm_vcpu' be located at offset zero of the arch/vendor vcpu
struct.

Remove the message from the build-time assertions regarding placement of
the struct, as compatibility with the arch usercopy region is no longer
the sole dependent on 'struct kvm_vcpu' being at offset zero.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              | 28 +++++++++-------------------
 arch/x86/kvm/vmx/vmx.c          | 24 ++++++++----------------
 arch/x86/kvm/x86.c              | 16 ++++++++++++----
 4 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d8056ff7390..77581eeb02e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1014,7 +1014,7 @@ struct kvm_x86_ops {
 	void (*vm_destroy)(struct kvm *kvm);
 
 	/* Create, but do not attach this VCPU */
-	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
+	int (*vcpu_create)(struct kvm *kvm, struct kvm_vcpu *vcpu, unsigned id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2f66c52e1b5d..bbc5dac9d400 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2138,9 +2138,9 @@ static int avic_init_vcpu(struct vcpu_svm *svm)
 	return ret;
 }
 
-static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
+static int svm_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			   unsigned int id)
 {
-	struct kvm_vcpu *vcpu;
 	struct vcpu_svm *svm;
 	struct page *page;
 	struct page *msrpm_pages;
@@ -2148,22 +2148,15 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	struct page *nested_msrpm_pages;
 	int err;
 
-	BUILD_BUG_ON_MSG(offsetof(struct vcpu_svm, vcpu) != 0,
-		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
-
-	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!svm) {
-		err = -ENOMEM;
-		goto out;
-	}
-	vcpu = &svm->vcpu;
+	BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
+	svm = to_svm(vcpu);
 
 	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
 		err = -ENOMEM;
-		goto free_partial_svm;
+		goto out;
 	}
 
 	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
@@ -2176,7 +2169,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_svm;
+		goto free_guest_fpu;
 
 	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL_ACCOUNT);
@@ -2220,7 +2213,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	svm_init_osvw(vcpu);
 
-	return vcpu;
+	return 0;
 
 free_page4:
 	__free_page(hsave_page);
@@ -2232,14 +2225,12 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	__free_page(page);
 uninit:
 	kvm_vcpu_uninit(vcpu);
-free_svm:
+free_guest_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 free_user_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-free_partial_svm:
-	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
-	return ERR_PTR(err);
+	return err;
 }
 
 static void svm_clear_current_vmcb(struct vmcb *vmcb)
@@ -2268,7 +2259,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-	kmem_cache_free(kvm_vcpu_cache, svm);
 }
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70b8d15eb2c5..832d8e38acd4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6693,31 +6693,24 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
-	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
-static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
+static int vmx_create_vcpu(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			   unsigned int id)
 {
-	struct kvm_vcpu *vcpu;
 	struct vcpu_vmx *vmx;
 	unsigned long *msr_bitmap;
 	int cpu, err;
 
-	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
-		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
-
-	vmx = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
-	if (!vmx)
-		return ERR_PTR(-ENOMEM);
-
-	vcpu = &vmx->vcpu;
+	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
+	vmx = to_vmx(vcpu);
 
 	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
 						GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.user_fpu) {
 		printk(KERN_ERR "kvm: failed to allocate kvm userspace's fpu\n");
 		err = -ENOMEM;
-		goto free_partial_vcpu;
+		goto out;
 	}
 
 	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
@@ -6815,7 +6808,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	vmx->ept_pointer = INVALID_PAGE;
 
-	return vcpu;
+	return 0;
 
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -6830,9 +6823,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 free_user_fpu:
 	kmem_cache_free(x86_fpu_cache, vcpu->arch.user_fpu);
-free_partial_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vmx);
-	return ERR_PTR(err);
+out:
+	return err;
 }
 
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9a291693279..45b296a9fdbb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9012,26 +9012,34 @@ static void fx_init(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	void *wbinvd_dirty_mask = vcpu->arch.wbinvd_dirty_mask;
-
 	kvmclock_reset(vcpu);
 
 	kvm_x86_ops->vcpu_free(vcpu);
-	free_cpumask_var(wbinvd_dirty_mask);
+
+	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
+	int r;
 
 	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
 		printk_once(KERN_WARNING
 		"kvm: SMP vm created on host with unstable TSC; "
 		"guest TSC will not be reliable\n");
 
-	vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
+	if (!vcpu)
+		return ERR_PTR(-ENOMEM);
 
+	r = kvm_x86_ops->vcpu_create(kvm, vcpu, id);
+	if (r) {
+		kmem_cache_free(kvm_vcpu_cache, vcpu);
+		return ERR_PTR(r);
+	}
 	return vcpu;
 }
 
-- 
2.22.0

