Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1F4DFB09
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbfJVB7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 21:59:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbfJVB7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293810"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:42 -0700
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
Subject: [PATCH 15/45] KVM: PPC: Move kvm_vcpu_init() invocation to common code
Date:   Mon, 21 Oct 2019 18:58:55 -0700
Message-Id: <20191022015925.31916-16-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the kvm_cpu_{un}init() calls to common PPC code as an intermediate
step towards removing kvm_cpu_{un}init() altogether.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  3 +--
 arch/powerpc/kvm/book3s.c          |  5 ++---
 arch/powerpc/kvm/book3s_hv.c       | 17 ++++++-----------
 arch/powerpc/kvm/book3s_pr.c       | 13 +++----------
 arch/powerpc/kvm/booke.c           |  5 ++---
 arch/powerpc/kvm/e500.c            | 16 +++-------------
 arch/powerpc/kvm/e500mc.c          |  8 ++------
 arch/powerpc/kvm/powerpc.c         | 10 +++++++++-
 8 files changed, 28 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index a7795339df92..d84f273ea574 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -119,8 +119,7 @@ extern int kvmppc_xlate(struct kvm_vcpu *vcpu, ulong eaddr,
 			enum xlate_instdata xlid, enum xlate_readwrite xlrw,
 			struct kvmppc_pte *pte);
 
-extern int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
-				   unsigned int id);
+extern int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_check_processor_compat(void);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 241ae3e114d2..fd049ede2487 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -814,10 +814,9 @@ void kvmppc_decrementer_func(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			    unsigned int id)
+int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
+	return kvm->arch.kvm_ops->vcpu_create(vcpu);
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 103a7599c2d1..ecc0895fd76f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2257,16 +2257,16 @@ static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
 }
 #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
 
-static int kvmppc_core_vcpu_create_hv(struct kvm *kvm, struct kvm_vcpu *vcpu,
-				      unsigned int id)
+static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 {
 	int err;
 	int core;
 	struct kvmppc_vcore *vcore;
+	struct kvm *kvm;
+	unsigned int id;
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		return err;
+	kvm = vcpu->kvm;
+	id = vcpu->vcpu_id;
 
 	vcpu->arch.shared = &vcpu->arch.shregs;
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
@@ -2348,7 +2348,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	mutex_unlock(&kvm->lock);
 
 	if (!vcore)
-		goto uninit_vcpu;
+		return err;
 
 	spin_lock(&vcore->lock);
 	++vcore->num_threads;
@@ -2364,10 +2364,6 @@ static int kvmppc_core_vcpu_create_hv(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	debugfs_vcpu_init(vcpu, id);
 
 	return 0;
-
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
-	return err;
 }
 
 static int kvmhv_set_smt_mode(struct kvm *kvm, unsigned long smt_mode,
@@ -2421,7 +2417,6 @@ static void kvmppc_core_vcpu_free_hv(struct kvm_vcpu *vcpu)
 	unpin_vpa(vcpu->kvm, &vcpu->arch.slb_shadow);
 	unpin_vpa(vcpu->kvm, &vcpu->arch.vpa);
 	spin_unlock(&vcpu->arch.vpa_update_lock);
-	kvm_vcpu_uninit(vcpu);
 }
 
 static int kvmppc_core_check_requests_hv(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index a933ba60bc7c..12f23f0c4ece 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1708,22 +1708,17 @@ static int kvmppc_set_one_reg_pr(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
-				      unsigned int id)
+static int kvmppc_core_vcpu_create_pr(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_book3s *vcpu_book3s;
 	unsigned long p;
 	int err;
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		return err;
-
 	err = -ENOMEM;
 
 	vcpu_book3s = vzalloc(sizeof(struct kvmppc_vcpu_book3s));
 	if (!vcpu_book3s)
-		goto uninit_vcpu;
+		goto out;
 	vcpu->arch.book3s = vcpu_book3s;
 
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
@@ -1777,8 +1772,7 @@ static int kvmppc_core_vcpu_create_pr(struct kvm *kvm, struct kvm_vcpu *vcpu,
 free_vcpu3s:
 #endif
 	vfree(vcpu_book3s);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
+out:
 	return err;
 }
 
@@ -1787,7 +1781,6 @@ static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
 	struct kvmppc_vcpu_book3s *vcpu_book3s = to_book3s(vcpu);
 
 	free_page((unsigned long)vcpu->arch.shared & PAGE_MASK);
-	kvm_vcpu_uninit(vcpu);
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
 #endif
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 047c9f707704..dd7440e50c7a 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -2114,10 +2114,9 @@ int kvmppc_core_init_vm(struct kvm *kvm)
 	return kvm->arch.kvm_ops->init_vm(kvm);
 }
 
-int kvmppc_core_vcpu_create(struct kvm *kvm, struct kvm_vcpu *vcpu,
-			    unsigned int id)
+int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.kvm_ops->vcpu_create(kvm, vcpu, id);
+	return kvm->arch.kvm_ops->vcpu_create(vcpu);
 }
 
 void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 96d9cde3d2e3..942bfaa2d1d0 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -433,8 +433,7 @@ static int kvmppc_set_one_reg_e500(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static int kvmppc_core_vcpu_create_e500(struct kvm *kvm, struct kvm_vcpu *vcpu,
-					unsigned int id)
+static int kvmppc_core_vcpu_create_e500(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500;
 	int err;
@@ -442,14 +441,8 @@ static int kvmppc_core_vcpu_create_e500(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	BUILD_BUG_ON(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0);
 	vcpu_e500 = to_e500(vcpu);
 
-	err = kvm_vcpu_init(vcpu, kvm, id);
-	if (err)
-		return err;
-
-	if (kvmppc_e500_id_table_alloc(vcpu_e500) == NULL) {
-		err = -ENOMEM;
-		goto uninit_vcpu;
-	}
+	if (kvmppc_e500_id_table_alloc(vcpu_e500) == NULL)
+		return -ENOMEM;
 
 	err = kvmppc_e500_tlb_init(vcpu_e500);
 	if (err)
@@ -467,8 +460,6 @@ static int kvmppc_core_vcpu_create_e500(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 uninit_id:
 	kvmppc_e500_id_table_free(vcpu_e500);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 	return err;
 }
 
@@ -479,7 +470,6 @@ static void kvmppc_core_vcpu_free_e500(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.shared);
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 	kvmppc_e500_id_table_free(vcpu_e500);
-	kvm_vcpu_uninit(vcpu);
 }
 
 static int kvmppc_core_init_vm_e500(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index f2902e612150..3b37957fbfe5 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -301,8 +301,7 @@ static int kvmppc_set_one_reg_e500mc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu,
-					  unsigned int id)
+static int kvmppc_core_vcpu_create_e500mc(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500;
 	int err;
@@ -319,7 +318,7 @@ static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu
 
 	err = kvmppc_e500_tlb_init(vcpu_e500);
 	if (err)
-		goto uninit_vcpu;
+		return err;
 
 	vcpu->arch.shared = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!vcpu->arch.shared) {
@@ -331,8 +330,6 @@ static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu
 
 uninit_tlb:
 	kvmppc_e500_tlb_uninit(vcpu_e500);
-uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 	return err;
 }
 
@@ -342,7 +339,6 @@ static void kvmppc_core_vcpu_free_e500mc(struct kvm_vcpu *vcpu)
 
 	free_page((unsigned long)vcpu->arch.shared);
 	kvmppc_e500_tlb_uninit(vcpu_e500);
-	kvm_vcpu_uninit(vcpu);
 }
 
 static int kvmppc_core_init_vm_e500mc(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 1d9997ad2795..2bc5e9f592aa 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -725,14 +725,20 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	if (!vcpu)
 		return ERR_PTR(-ENOMEM);
 
-	err = kvmppc_core_vcpu_create(kvm, vcpu, id);
+	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
 		goto free_vcpu;
 
+	err = kvmppc_core_vcpu_create(vcpu);
+	if (err)
+		goto uninit_vcpu;
+
 	vcpu->arch.wqp = &vcpu->wq;
 	kvmppc_create_vcpu_debugfs(vcpu, id);
 	return vcpu;
 
+uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 free_vcpu:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 	return ERR_PTR(err);
@@ -766,6 +772,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvmppc_core_vcpu_free(vcpu);
 
+	kvm_vcpu_uninit(vcpu);
+
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
-- 
2.22.0

