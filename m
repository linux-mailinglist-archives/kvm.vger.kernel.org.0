Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4E81447B5
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 23:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAUWdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 17:33:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:1735 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgAUWcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 17:32:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 14:32:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="244845112"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 04/19] KVM: PPC: Move memslot memory allocation into prepare_memory_region()
Date:   Tue, 21 Jan 2020 14:31:42 -0800
Message-Id: <20200121223157.15263-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
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
index bc2494e5710a..d162649430ba 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -202,12 +202,10 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
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
index d07a8e12fa15..e9149a815806 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -810,12 +810,6 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
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
@@ -823,9 +817,11 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
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
index f4b72cef09d5..c3d4abae5a4d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4453,20 +4453,20 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *free,
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
 
@@ -5525,7 +5525,6 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.set_spte_hva = kvm_set_spte_hva_hv,
 	.mmu_destroy  = kvmppc_mmu_destroy_hv,
 	.free_memslot = kvmppc_core_free_memslot_hv,
-	.create_memslot = kvmppc_core_create_memslot_hv,
 	.init_vm =  kvmppc_core_init_vm_hv,
 	.destroy_vm = kvmppc_core_destroy_vm_hv,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index d88f708d5be3..d507bbf7a685 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1927,7 +1927,8 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
 					struct kvm_memory_slot *memslot,
-					const struct kvm_userspace_memory_region *mem)
+					const struct kvm_userspace_memory_region *mem,
+					enum kvm_mr_change change)
 {
 	return 0;
 }
@@ -1947,13 +1948,6 @@ static void kvmppc_core_free_memslot_pr(struct kvm_memory_slot *free,
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
@@ -2098,7 +2092,6 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.set_spte_hva = kvm_set_spte_hva_pr,
 	.mmu_destroy  = kvmppc_mmu_destroy_pr,
 	.free_memslot = kvmppc_core_free_memslot_pr,
-	.create_memslot = kvmppc_core_create_memslot_pr,
 	.init_vm = kvmppc_core_init_vm_pr,
 	.destroy_vm = kvmppc_core_destroy_vm_pr,
 	.get_smmu_info = kvm_vm_ioctl_get_smmu_info_pr,
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 9cb8257b4118..05cf548f172c 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1776,15 +1776,10 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
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
index 1af96fb5dc6f..4e0f7a77920d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -694,7 +694,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
-	return kvmppc_core_create_memslot(kvm, slot, npages);
+	return 0;
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -702,7 +702,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, memslot, mem);
+	return kvmppc_core_prepare_memory_region(kvm, memslot, mem, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-- 
2.24.1

