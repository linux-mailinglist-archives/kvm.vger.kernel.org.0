Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13680E4024
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbfJXXHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:07:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:23483 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387421AbfJXXHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:07:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 16:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202445838"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 16:07:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v3 03/15] KVM: PPC: Move memslot memory allocation into prepare_memory_region()
Date:   Thu, 24 Oct 2019 16:07:32 -0700
Message-Id: <20191024230744.14543-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191024230744.14543-1-sean.j.christopherson@intel.com>
References: <20191024230744.14543-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the rmap array during kvm_arch_prepare_memory_region() to pave
the way for removing kvm_arch_create_memslot() altogether.  Moving PPC's
memory allocation only changes the order of kernel memory allocations
between PPC and common KVM code.

No functional change intended.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/include/asm/kvm_ppc.h | 11 ++++-------
 arch/powerpc/kvm/book3s.c          | 12 ++++--------
 arch/powerpc/kvm/book3s_hv.c       | 25 ++++++++++++-------------
 arch/powerpc/kvm/book3s_pr.c       | 11 ++---------
 arch/powerpc/kvm/booke.c           |  9 ++-------
 arch/powerpc/kvm/powerpc.c         |  4 ++--
 6 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ee62776e5433..8fe59be4d180 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -203,12 +203,10 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *free,
 				     struct kvm_memory_slot *dont);
-extern int kvmppc_core_create_memslot(struct kvm *kvm,
-				      struct kvm_memory_slot *slot,
-				      unsigned long npages);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem);
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change);
 extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
@@ -280,7 +278,8 @@ struct kvmppc_ops {
 	void (*flush_memslot)(struct kvm *kvm, struct kvm_memory_slot *memslot);
 	int (*prepare_memory_region)(struct kvm *kvm,
 				     struct kvm_memory_slot *memslot,
-				     const struct kvm_userspace_memory_region *mem);
+				     const struct kvm_userspace_memory_region *mem,
+				     enum kvm_mr_change change);
 	void (*commit_memory_region)(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region *mem,
 				     const struct kvm_memory_slot *old,
@@ -294,8 +293,6 @@ struct kvmppc_ops {
 	void (*mmu_destroy)(struct kvm_vcpu *vcpu);
 	void (*free_memslot)(struct kvm_memory_slot *free,
 			     struct kvm_memory_slot *dont);
-	int (*create_memslot)(struct kvm_memory_slot *slot,
-			      unsigned long npages);
 	int (*init_vm)(struct kvm *kvm);
 	void (*destroy_vm)(struct kvm *kvm);
 	int (*get_smmu_info)(struct kvm *kvm, struct kvm_ppc_smmu_info *info);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ec2547cc5ecb..111b39a5250d 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -840,12 +840,6 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvm->arch.kvm_ops->free_memslot(free, dont);
 }
 
-int kvmppc_core_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       unsigned long npages)
-{
-	return kvm->arch.kvm_ops->create_memslot(slot, npages);
-}
-
 void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	kvm->arch.kvm_ops->flush_memslot(kvm, memslot);
@@ -853,9 +847,11 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
-				const struct kvm_userspace_memory_region *mem)
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change)
 {
-	return kvm->arch.kvm_ops->prepare_memory_region(kvm, memslot, mem);
+	return kvm->arch.kvm_ops->prepare_memory_region(kvm, memslot, mem,
+							change);
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 709cf1fd4cf4..4e5664379329 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4461,20 +4461,20 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *free,
 	}
 }
 
-static int kvmppc_core_create_memslot_hv(struct kvm_memory_slot *slot,
-					 unsigned long npages)
-{
-	slot->arch.rmap = vzalloc(array_size(npages, sizeof(*slot->arch.rmap)));
-	if (!slot->arch.rmap)
-		return -ENOMEM;
-
-	return 0;
-}
-
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
-					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem)
+					struct kvm_memory_slot *slot,
+					const struct kvm_userspace_memory_region *mem,
+					enum kvm_mr_change change)
 {
+	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
+
+	if (change == KVM_MR_CREATE) {
+		slot->arch.rmap = vzalloc(array_size(npages,
+					  sizeof(*slot->arch.rmap)));
+		if (!slot->arch.rmap)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -5416,7 +5416,6 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.set_spte_hva = kvm_set_spte_hva_hv,
 	.mmu_destroy  = kvmppc_mmu_destroy_hv,
 	.free_memslot = kvmppc_core_free_memslot_hv,
-	.create_memslot = kvmppc_core_create_memslot_hv,
 	.init_vm =  kvmppc_core_init_vm_hv,
 	.destroy_vm = kvmppc_core_destroy_vm_hv,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index cc65af8fe6f7..5fceb1da5fde 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1903,7 +1903,8 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
 					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem)
+					const struct kvm_userspace_memory_region *mem,
+					enum kvm_mr_change change)
 {
 	return 0;
 }
@@ -1923,13 +1924,6 @@ static void kvmppc_core_free_memslot_pr(struct kvm_memory_slot *free,
 	return;
 }
 
-static int kvmppc_core_create_memslot_pr(struct kvm_memory_slot *slot,
-					 unsigned long npages)
-{
-	return 0;
-}
-
-
 #ifdef CONFIG_PPC64
 static int kvm_vm_ioctl_get_smmu_info_pr(struct kvm *kvm,
 					 struct kvm_ppc_smmu_info *info)
@@ -2073,7 +2067,6 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.set_spte_hva = kvm_set_spte_hva_pr,
 	.mmu_destroy  = kvmppc_mmu_destroy_pr,
 	.free_memslot = kvmppc_core_free_memslot_pr,
-	.create_memslot = kvmppc_core_create_memslot_pr,
 	.init_vm = kvmppc_core_init_vm_pr,
 	.destroy_vm = kvmppc_core_destroy_vm_pr,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_pr,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index be9a45874194..cf2845e147c5 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1806,15 +1806,10 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 {
 }
 
-int kvmppc_core_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			       unsigned long npages)
-{
-	return 0;
-}
-
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot,
-				      const struct kvm_userspace_memory_region *mem)
+				      const struct kvm_userspace_memory_region *mem,
+				      enum kvm_mr_change change)
 {
 	return 0;
 }
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3a77bb643452..95b4a766b6cb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -690,7 +690,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	return kvmppc_core_create_memslot(kvm, slot, npages);
+	return 0;
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -698,7 +698,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, memslot, mem);
+	return kvmppc_core_prepare_memory_region(kvm, memslot, mem, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.22.0

