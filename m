Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFBC144758
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 23:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAUWcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 17:32:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:1733 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgAUWcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 17:32:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 14:32:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="244845122"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 21 Jan 2020 14:32:03 -0800
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
Subject: [PATCH v5 06/19] KVM: Drop kvm_arch_create_memslot()
Date:   Tue, 21 Jan 2020 14:31:44 -0800
Message-Id: <20200121223157.15263-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200121223157.15263-1-sean.j.christopherson@intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_arch_create_memslot() now that all arch implementations are
effectively nops.  Removing kvm_arch_create_memslot() eliminates the
possibility for arch specific code to allocate memory prior to setting
a memslot, which sets the stage for simplifying kvm_free_memslot().

Cc: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c       |  6 ------
 arch/powerpc/kvm/powerpc.c |  6 ------
 arch/s390/kvm/kvm-s390.c   |  6 ------
 arch/x86/kvm/x86.c         |  6 ------
 include/linux/kvm_host.h   |  2 --
 virt/kvm/arm/mmu.c         |  6 ------
 virt/kvm/kvm_main.c        | 21 +++++++--------------
 7 files changed, 7 insertions(+), 46 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2606f3f02b54..6d54e18ebdc1 100644
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
index 4e0f7a77920d..48abf1b9ad58 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -691,12 +691,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
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
index c059b86aacd4..743e09dd38b5 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4483,12 +4483,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
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
index 35a7e3d9b99a..b55bf2ecdd98 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9788,12 +9788,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvm_page_track_free_memslot(free, dont);
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
-{
-	return 0;
-}
-
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d5331b0d937..aa5cb2ff7a2b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -671,8 +671,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    const struct kvm_userspace_memory_region *mem);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index dc8254bf30ea..66f59c067bf6 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2356,12 +2356,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
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
index 8c9211182680..5e777ab02395 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1039,12 +1039,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
@@ -1079,22 +1080,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		}
 	}
 
-	/* Free page dirty bitmap if unneeded */
-	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
-		new.dirty_bitmap = NULL;
-
 	r = -ENOMEM;
-	if (change == KVM_MR_CREATE) {
-		new.userspace_addr = mem->userspace_addr;
 
-		if (kvm_arch_create_memslot(kvm, &new, npages))
-			goto out;
-	}
-
-	/* Allocate page dirty bitmap if needed */
-	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
+	/* Allocate/free page dirty bitmap as needed */
+	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
+		new.dirty_bitmap = NULL;
+	else if (!new.dirty_bitmap) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
-			goto out_free;
+			goto out;
 	}
 
 	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
-- 
2.24.1

