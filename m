Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E78D46A639
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 20:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349094AbhLFT7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 14:59:46 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:50096 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349231AbhLFT7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 14:59:37 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1muK5R-0000rm-GK; Mon, 06 Dec 2021 20:55:45 +0100
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
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 12/29] KVM: Stop passing kvm_userspace_memory_region to arch memslot hooks
Date:   Mon,  6 Dec 2021 20:54:18 +0100
Message-Id: <aa5ed3e62c27e881d0d8bc0acbc1572bc336dc19.1638817640.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1638817637.git.maciej.szmigiero@oracle.com>
References: <cover.1638817637.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Drop the @mem param from kvm_arch_{prepare,commit}_memory_region() now
that its use has been removed in all architectures.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/arm64/kvm/mmu.c       | 2 --
 arch/mips/kvm/mips.c       | 2 --
 arch/powerpc/kvm/powerpc.c | 2 --
 arch/riscv/kvm/mmu.c       | 2 --
 arch/s390/kvm/kvm-s390.c   | 2 --
 arch/x86/kvm/x86.c         | 2 --
 include/linux/kvm_host.h   | 2 --
 virt/kvm/kvm_main.c        | 9 ++++-----
 8 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dd95350ea15d..9b2d881ccf49 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1463,7 +1463,6 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -1486,7 +1485,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index bda717301db8..e59cb6246f76 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -214,7 +214,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -223,7 +222,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e207de17958d..2ad0ccd202d5 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -698,7 +698,6 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -707,7 +706,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 573ade138204..7d884b15cf5e 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -462,7 +462,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
@@ -477,7 +476,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6947edf3da60..481789873c81 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5007,7 +5007,6 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -5035,7 +5034,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e657c238b642..1a598b0c3e36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11723,7 +11723,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				   const struct kvm_userspace_memory_region *mem,
 				   const struct kvm_memory_slot *old,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
@@ -11827,7 +11826,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1024b40b1567..9f984867c297 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -835,12 +835,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				const struct kvm_memory_slot *old,
 				struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
-				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67b081d477d8..b778b8ab1885 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1552,7 +1552,6 @@ static void kvm_copy_memslots_arch(struct kvm_memslots *to,
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
-			   const struct kvm_userspace_memory_region *mem,
 			   struct kvm_memory_slot *new,
 			   enum kvm_mr_change change)
 {
@@ -1638,7 +1637,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		old.as_id = new->as_id;
 	}
 
-	r = kvm_arch_prepare_memory_region(kvm, mem, &old, new, change);
+	r = kvm_arch_prepare_memory_region(kvm, &old, new, change);
 	if (r)
 		goto out_slots;
 
@@ -1654,7 +1653,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	else if (change == KVM_MR_CREATE)
 		kvm->nr_memslot_pages += new->npages;
 
-	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+	kvm_arch_commit_memory_region(kvm, &old, new, change);
 
 	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
 	if (change == KVM_MR_DELETE)
@@ -1739,7 +1738,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		new.id = id;
 		new.as_id = as_id;
 
-		return kvm_set_memslot(kvm, mem, &new, KVM_MR_DELETE);
+		return kvm_set_memslot(kvm, &new, KVM_MR_DELETE);
 	}
 
 	new.as_id = as_id;
@@ -1802,7 +1801,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &new, change);
+	r = kvm_set_memslot(kvm, &new, change);
 	if (r)
 		goto out_bitmap;
 
