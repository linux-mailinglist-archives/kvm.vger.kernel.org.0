Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3475CB0438
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbfIKSv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 14:51:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:39426 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbfIKSun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 14:50:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 11:50:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="196980874"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 04/13] KVM: Drop kvm_arch_create_memslot()
Date:   Wed, 11 Sep 2019 11:50:29 -0700
Message-Id: <20190911185038.24341-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_arch_create_memslot() now that all arch implementations are
effectively nops.  Explicitly free an allocated-but-unused dirty bitmap
instead of relying on kvm_free_memslot() now that setting a memslot can
no longer fail after arch code has allocated memory.  In practice
this was already true, e.g. architectures that allocated memory via
kvm_arch_create_memslot() never failed kvm_arch_prepare_memory_region()
and vice versa, but removing kvm_arch_create_memslot() eliminates the
potential for future code to stealthily change behavior.

Eliminating the error path's reliance on kvm_free_memslot() paves the
way for simplify kvm_free_memslot(), i.e. dropping its @dont param.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       |  6 ------
 arch/powerpc/kvm/powerpc.c |  6 ------
 arch/s390/kvm/kvm-s390.c   |  6 ------
 arch/x86/kvm/x86.c         |  6 ------
 include/linux/kvm_host.h   |  2 --
 virt/kvm/arm/mmu.c         |  6 ------
 virt/kvm/kvm_main.c        | 28 +++++++++++-----------------
 7 files changed, 11 insertions(+), 49 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 1109924560d8..713e5465edb0 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -188,12 +188,6 @@ long kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl,
 	return -ENOIOCTLCMD;
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	/* Flush whole GPA */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8b723b164fe1..cf74bf8f921a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -686,12 +686,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvmppc_core_free_memslot(kvm, free, dont);
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
 				   const struct kvm_userspace_memory_region *mem,
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index f329dcb3f44c..e651ed80dc2c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4488,12 +4488,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72ec6272d7cb..7adde30c1305 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9482,12 +9482,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvm_page_track_free_memslot(free, dont);
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 static int kvm_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      unsigned long npages)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fcb46b3374c6..cce72f55ab76 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -679,8 +679,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 38b4c910b6c3..f264de85f648 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2358,12 +2358,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 {
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 {
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index daa5de5b3f88..ea8f2f37096f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -964,12 +964,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.base_gfn = base_gfn;
 	new.npages = npages;
 	new.flags = mem->flags;
+	new.userspace_addr = mem->userspace_addr;
 
 	if (npages) {
 		if (!old.npages)
 			change = KVM_MR_CREATE;
 		else { /* Modify an existing slot. */
-			if ((mem->userspace_addr != old.userspace_addr) ||
+			if ((new.userspace_addr != old.userspace_addr) ||
 			    (npages != old.npages) ||
 			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
 				goto out;
@@ -1004,27 +1005,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		}
 	}
 
-	/* Free page dirty bitmap if unneeded */
+	r = -ENOMEM;
+
+	/* Allocate/free page dirty bitmap as needed */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
 		new.dirty_bitmap = NULL;
-
-	r = -ENOMEM;
-	if (change == KVM_MR_CREATE) {
-		new.userspace_addr = mem->userspace_addr;
-
-		if (kvm_arch_create_memslot(kvm, &new, npages))
-			goto out_free;
-	}
-
-	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	else if (!new.dirty_bitmap) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
-			goto out_free;
+			goto out;
 	}
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
 	if (!slots)
-		goto out_free;
+		goto out_bitmap;
 	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
 
 	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
@@ -1072,8 +1065,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
 		slots = install_new_memslots(kvm, as_id, slots);
 	kvfree(slots);
-out_free:
-	kvm_free_memslot(kvm, &new, &old);
+out_bitmap:
+	if (new.dirty_bitmap && !old.dirty_bitmap)
+		kvm_destroy_dirty_bitmap(&new);
 out:
 	return r;
 }
-- 
2.22.0

