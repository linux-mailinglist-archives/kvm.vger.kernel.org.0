Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E78DFA73
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfJVB7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbfJVB7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293794"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:39 -0700
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
Subject: [PATCH 12/45] KVM: PPC: Allocate vcpu struct in common PPC code
Date:   Mon, 21 Oct 2019 18:58:52 -0700
Message-Id: <20191022015925.31916-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move allocation of all flavors of PPC vCPUs to common PPC code.  All
variants either allocate 'struct kvm_vcpu' directly, or require that
the embedded 'struct kvm_vcpu' member be located at offset 0, i.e.
guarantee that the allocation can be directly interpreted as a 'struct
kvm_vcpu' object.

Remove the message from the build-time assertion regarding placement of
the struct, as compatibility with the arch usercopy region is no longer
the sole dependent on 'struct kvm_vcpu' being at offset zero.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  7 ++++---
 arch/powerpc/kvm/book3s.c          |  5 +++--
 arch/powerpc/kvm/book3s_hv.c       | 20 +++++---------------
 arch/powerpc/kvm/book3s_pr.c       | 18 +++++-------------
 arch/powerpc/kvm/booke.c           |  5 +++--
 arch/powerpc/kvm/e500.c            | 24 ++++++------------------
 arch/powerpc/kvm/e500mc.c          | 22 +++++-----------------
 arch/powerpc/kvm/powerpc.c         | 23 ++++++++++++++++++-----
 8 files changed, 49 insertions(+), 75 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ee62776e5433..a7795339df92 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -119,8 +119,8 @@ extern int kvmppc_xlate(struct kvm_vcpu *vcpu, ulong eaddr,
 			enum xlate_instdata xlid, enum xlate_readwrite xlrw,
 			struct kvmppc_pte *pte);
 
-extern struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm,
-                                                unsigned int id);
+extern int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				   unsigned int id);
 extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_check_processor_compat(void);
@@ -273,7 +273,8 @@ struct kvmppc_ops {
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 	void (*set_msr)(struct kvm_vcpu *vcpu, u64 msr);
 	int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
-	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned int id);
+	int (*vcpu_create)(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			   unsigned int id);
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	int (*check_requests)(struct kvm_vcpu *vcpu);
 	int (*get_dirty_log)(struct kvm *kvm, struct kvm_dirty_log *log);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ec2547cc5ecb..241ae3e114d2 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -814,9 +814,10 @@ void kvmppc_decrementer_func(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			    unsigned int id)
 {
-	return kvm->arch.kvm_ops->vcpu_create(kvm, id);
+	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 36abbe3c346d..103a7599c2d1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2257,22 +2257,16 @@ static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
 }
 #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
 
-static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
-						   unsigned int id)
+static int kvmppc_core_vcpu_create_hv(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				      unsigned int id)
 {
-	struct kvm_vcpu *vcpu;
 	int err;
 	int core;
 	struct kvmppc_vcore *vcore;
 
-	err = -ENOMEM;
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		goto out;
-
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_vcpu;
+		return err;
 
 	vcpu->arch.shared = &vcpu->arch.shregs;
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
@@ -2369,14 +2363,11 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
 
 	debugfs_vcpu_init(vcpu, id);
 
-	return vcpu;
+	return 0;
 
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
-out:
-	return ERR_PTR(err);
+	return err;
 }
 
 static int kvmhv_set_smt_mode(struct kvm *kvm, unsigned long smt_mode,
@@ -2431,7 +2422,6 @@ static void kvmppc_core_vcpu_free_hv(struct kvm_vcpu *vcpu)
 	unpin_vpa(vcpu->kvm, &vcpu->arch.vpa);
 	spin_unlock(&vcpu->arch.vpa_update_lock);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 static int kvmppc_core_check_requests_hv(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 3f6ad3f58628..1e6b83908668 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1708,21 +1708,16 @@ static int kvmppc_set_one_reg_pr(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
-						   unsigned int id)
+static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				      unsigned int id)
 {
 	struct kvmppc_vcpu_book3s *vcpu_book3s;
-	struct kvm_vcpu *vcpu;
 	int err = -ENOMEM;
 	unsigned long p;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu)
-		goto out;
-
 	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
-		goto free_vcpu;
+		goto out;
 	vcpu->arch.book3s = vcpu_book3s;
 
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
@@ -1771,7 +1766,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
 	if (err < 0)
 		goto free_shared_page;
 
-	return vcpu;
+	return 0;
 
 free_shared_page:
 	free_page((unsigned long)vcpu->arch.shared);
@@ -1783,10 +1778,8 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
 free_vcpu3s:
 #endif
 	vfree(vcpu_book3s);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 out:
-	return ERR_PTR(err);
+	return err;
 }
 
 static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
@@ -1799,7 +1792,6 @@ static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.shadow_vcpu);
 #endif
 	vfree(vcpu_book3s);
-	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 static int kvmppc_vcpu_run_pr(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index be9a45874194..047c9f707704 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -2114,9 +2114,10 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 	return kvm->arch.kvm_ops->init_vm(kvm);
 }
 
-struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
+int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
+			    unsigned int id)
 {
-	return kvm->arch.kvm_ops->vcpu_create(kvm, id);
+	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 00649ca5fa9a..96d9cde3d2e3 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -433,26 +433,18 @@ static int kvmppc_set_one_reg_e500(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static struct kvm_vcpu *kvmppc_core_vcpu_create_e500(struct kvm *kvm,
-						     unsigned int id)
+static int kvmppc_core_vcpu_create_e500(struct kvm *kvm, struct kvm_vcpu *vcpu,
+					unsigned int id)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500;
-	struct kvm_vcpu *vcpu;
 	int err;
 
-	BUILD_BUG_ON_MSG(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0,
-		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
+	BUILD_BUG_ON(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0);
+	vcpu_e500 = to_e500(vcpu);
 
-	vcpu_e500 = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu_e500) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	vcpu = &vcpu_e500->vcpu;
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_vcpu;
+		return err;
 
 	if (kvmppc_e500_id_table_alloc(vcpu_e500) == NULL) {
 		err = -ENOMEM;
@@ -477,10 +469,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_e500(struct kvm *kvm,
 	kvmppc_e500_id_table_free(vcpu_e500);
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
-out:
-	return ERR_PTR(err);
+	return err;
 }
 
 static void kvmppc_core_vcpu_free_e500(struct kvm_vcpu *vcpu)
@@ -491,7 +480,6 @@ static void kvmppc_core_vcpu_free_e500(struct kvm_vcpu *vcpu)
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 	kvmppc_e500_id_table_free(vcpu_e500);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
 }
 
 static int kvmppc_core_init_vm_e500(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index c51f4bb086fd..aea588f73bf7 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -301,28 +301,21 @@ static int kvmppc_set_one_reg_e500mc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static struct kvm_vcpu *kvmppc_core_vcpu_create_e500mc(struct kvm *kvm,
-						       unsigned int id)
+static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu,
+					  unsigned int id)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500;
-	struct kvm_vcpu *vcpu;
 	int err;
 
 	BUILD_BUG_ON(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0);
-
-	vcpu_e500 = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
-	if (!vcpu_e500) {
-		err = -ENOMEM;
-		goto out;
-	}
-	vcpu = &vcpu_e500->vcpu;
+	vcpu_e500 = to_e500(vcpu);
 
 	/* Invalid PIR value -- this LPID dosn't have valid state on any cpu */
 	vcpu->arch.oldpir = 0xffffffff;
 
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
-		goto free_vcpu;
+		return err;
 
 	err = kvmppc_e500_tlb_init(vcpu_e500);
 	if (err)
@@ -340,11 +333,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_e500mc(struct kvm *kvm,
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 uninit_vcpu:
 	kvm_vcpu_uninit(vcpu);
-
-free_vcpu:
-	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
-out:
-	return ERR_PTR(err);
+	return err;
 }
 
 static void kvmppc_core_vcpu_free_e500mc(struct kvm_vcpu *vcpu)
@@ -354,7 +343,6 @@ static void kvmppc_core_vcpu_free_e500mc(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.shared);
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 	kvm_vcpu_uninit(vcpu);
-	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
 }
 
 static int kvmppc_core_init_vm_e500mc(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3a77bb643452..1d9997ad2795 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -719,12 +719,23 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
-	vcpu = kvmppc_core_vcpu_create(kvm, id);
-	if (!IS_ERR(vcpu)) {
-		vcpu->arch.wqp = &vcpu->wq;
-		kvmppc_create_vcpu_debugfs(vcpu, id);
-	}
+	int err;
+
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu)
+		return ERR_PTR(-ENOMEM);
+
+	err = kvmppc_core_vcpu_create(kvm, vcpu, id);
+	if (err)
+		goto free_vcpu;
+
+	vcpu->arch.wqp = &vcpu->wq;
+	kvmppc_create_vcpu_debugfs(vcpu, id);
 	return vcpu;
+
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
+	return ERR_PTR(err);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -754,6 +765,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	}
 
 	kvmppc_core_vcpu_free(vcpu);
+
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.22.0

