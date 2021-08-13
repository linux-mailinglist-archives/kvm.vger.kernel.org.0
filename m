Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C223EBCEC
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 22:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhHMUBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 16:01:07 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:50258 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233942AbhHMUBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 16:01:07 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mEcw7-00041g-TX; Fri, 13 Aug 2021 21:33:47 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/13] KVM: Add "old" memslot parameter to kvm_arch_prepare_memory_region()
Date:   Fri, 13 Aug 2021 21:33:16 +0200
Message-Id: <9960235eee390289745ab1703076b3c0c77a8b60.1628871412.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871411.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

This is needed for the next commit, which moves n_memslots_pages
recalculation from kvm_arch_commit_memory_region() to the aforementioned
function to allow for returning an error code.

While we are at it let's also rename the "memslot" parameter to "new" for
consistency with kvm_arch_commit_memory_region(), which uses the same
argument set now.

No functional change intended.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/mmu.c       | 7 ++++---
 arch/mips/kvm/mips.c       | 3 ++-
 arch/powerpc/kvm/powerpc.c | 5 +++--
 arch/s390/kvm/kvm-s390.c   | 3 ++-
 arch/x86/kvm/x86.c         | 5 +++--
 include/linux/kvm_host.h   | 3 ++-
 virt/kvm/kvm_main.c        | 2 +-
 7 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..ed74d23970a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1434,7 +1434,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
@@ -1450,7 +1451,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * Prevent userspace from creating a memory region outside of the IPA
 	 * space addressable by the KVM guest IPA space.
 	 */
-	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
+	if ((new->base_gfn + new->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
 		return -EFAULT;
 
 	mmap_read_lock(current->mm);
@@ -1482,7 +1483,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 
 		if (vma->vm_flags & VM_PFNMAP) {
 			/* IO region dirty page logging not allowed */
-			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 				ret = -EINVAL;
 				break;
 			}
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 75c6f264c626..8587c260c6fb 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -233,7 +233,8 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index be33b5321a76..547a9e2b1f3a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -706,11 +706,12 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
-	return kvmppc_core_prepare_memory_region(kvm, memslot, mem, change);
+	return kvmppc_core_prepare_memory_region(kvm, new, mem, change);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4dc7e966a720..4bed65dbad5e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4990,7 +4990,8 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *memslot,
+				   const struct kvm_memory_slot *old,
+				   struct kvm_memory_slot *new,
 				   const struct kvm_userspace_memory_region *mem,
 				   enum kvm_mr_change change)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6bbfc53518d8..2ab0de7483ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11485,12 +11485,13 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
+				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(kvm, memslot,
+		return kvm_alloc_memslot_metadata(kvm, new,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d447b21cdd73..2d62581b400e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -832,7 +832,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				struct kvm_memory_slot *memslot,
+				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..207306f7c559 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1583,7 +1583,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
-	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
+	r = kvm_arch_prepare_memory_region(kvm, old, new, mem, change);
 	if (r)
 		goto out_slots;
 
