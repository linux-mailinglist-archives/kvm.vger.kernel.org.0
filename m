Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FEE46407C
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344325AbhK3VqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:46:25 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56172 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344339AbhK3VqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 16:46:17 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msAtT-0005zh-Ju; Tue, 30 Nov 2021 22:42:31 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/29] KVM: PPC: Avoid referencing userspace memory region in memslot updates
Date:   Tue, 30 Nov 2021 22:41:21 +0100
Message-Id: <843bd884f3a72d2ecce5becf0ac645763668fc27.1638304315.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

For PPC HV, get the number of pages directly from the new memslot instead
of computing the same from the userspace memory region, and explicitly
check for !DELETE instead of inferring the same when toggling mmio_update.
The motivation for these changes is to avoid referencing the @mem param
so that it can be dropped in a future commit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  4 ----
 arch/powerpc/kvm/book3s.c          |  6 ++----
 arch/powerpc/kvm/book3s_hv.c       | 12 +++---------
 arch/powerpc/kvm/book3s_pr.c       |  2 --
 arch/powerpc/kvm/booke.c           |  2 --
 arch/powerpc/kvm/powerpc.c         |  4 ++--
 6 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index b01760dd1374..935c58dc38c4 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -200,12 +200,10 @@ extern void kvmppc_core_destroy_vm(struct kvm *kvm);
 extern void kvmppc_core_free_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *slot);
 extern int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 extern void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
@@ -275,12 +273,10 @@ struct kvmppc_ops {
 	int (*get_dirty_log)(struct kvm *kvm, struct kvm_dirty_log *log);
 	void (*flush_memslot)(struct kvm *kvm, struct kvm_memory_slot *memslot);
 	int (*prepare_memory_region)(struct kvm *kvm,
-				     const struct kvm_userspace_memory_region *mem,
 				     const struct kvm_memory_slot *old,
 				     struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
 	void (*commit_memory_region)(struct kvm *kvm,
-				     const struct kvm_userspace_memory_region *mem,
 				     struct kvm_memory_slot *old,
 				     const struct kvm_memory_slot *new,
 				     enum kvm_mr_change change);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 8250e8308674..6d525285dbe8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -847,21 +847,19 @@ void kvmppc_core_flush_memslot(struct kvm *kvm, struct kvm_memory_slot *memslot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				      const struct kvm_userspace_memory_region *mem,
 				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *new,
 				      enum kvm_mr_change change)
 {
-	return kvm->arch.kvm_ops->prepare_memory_region(kvm, mem, old, new, change);
+	return kvm->arch.kvm_ops->prepare_memory_region(kvm, old, new, change);
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
+	kvm->arch.kvm_ops->commit_memory_region(kvm, old, new, change);
 }
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d7594d49d288..2b59ecc5f8c6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4854,15 +4854,12 @@ static void kvmppc_core_free_memslot_hv(struct kvm_memory_slot *slot)
 }
 
 static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
-
 	if (change == KVM_MR_CREATE) {
-		new->arch.rmap = vzalloc(array_size(npages,
+		new->arch.rmap = vzalloc(array_size(new->npages,
 					  sizeof(*new->arch.rmap)));
 		if (!new->arch.rmap)
 			return -ENOMEM;
@@ -4874,20 +4871,17 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 }
 
 static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
-
 	/*
-	 * If we are making a new memslot, it might make
+	 * If we are creating or modifying a memslot, it might make
 	 * some address that was previously cached as emulated
 	 * MMIO be no longer emulated MMIO, so invalidate
 	 * all the caches of emulated MMIO translations.
 	 */
-	if (npages)
+	if (change != KVM_MR_DELETE)
 		atomic64_inc(&kvm->arch.mmio_update);
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 6a94831487ae..34a801c3604a 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1899,7 +1899,6 @@ static void kvmppc_core_flush_memslot_pr(struct kvm *kvm,
 }
 
 static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
@@ -1908,7 +1907,6 @@ static int kvmppc_core_prepare_memory_region_pr(struct kvm *kvm,
 }
 
 static void kvmppc_core_commit_memory_region_pr(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 47f691387171..06c5830a93f9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1821,7 +1821,6 @@ void kvmppc_core_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvmppc_core_prepare_memory_region(struct kvm *kvm,
-				      const struct kvm_userspace_memory_region *mem,
 				      const struct kvm_memory_slot *old,
 				      struct kvm_memory_slot *new,
 				      enum kvm_mr_change change)
@@ -1830,7 +1829,6 @@ int kvmppc_core_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvmppc_core_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index cf0422c41359..e207de17958d 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -703,7 +703,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, mem, old, new, change);
+	return kvmppc_core_prepare_memory_region(kvm, old, new, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
@@ -712,7 +712,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	kvmppc_core_commit_memory_region(kvm, mem, old, new, change);
+	kvmppc_core_commit_memory_region(kvm, old, new, change);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
