Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2AAF06ED
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfKEU37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 15:29:59 -0500
Received: from foss.arm.com ([217.140.110.172]:59992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbfKEU36 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 15:29:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ACCD986;
        Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6A5D3FE55;
        Tue,  5 Nov 2019 03:04:04 -0800 (PST)
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH v4 2/5] KVM: x86: Move mmu_memory_cache functions to common code
Date:   Tue,  5 Nov 2019 12:03:54 +0100
Message-Id: <20191105110357.8607-3-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191105110357.8607-1-christoffer.dall@arm.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are currently duplicating the mmu memory cache functionality quite
heavily between the architectures that support KVM.  As a first step,
move the x86 implementation (which seems to have the most recently
maintained version of the mmu memory cache) to common code.

We introduce an arch-specific kvm_types.h which can be used to specify
how many objects are required in the memory cache, an aspect which
diverges across architectures.  Since kvm_host.h defines structures with
fields of the memcache object, we define the memcache structure in
kvm_types.h, and we include the architecture-specific kvm_types.h to
know the size of object in kvm_host.h.

We only define the functions and data types if
KVM_ARCH_WANT_MMU_MEMORY_CACHE is defined, because not all architectures
require the mmu memory cache.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_types.h     |  5 +++
 arch/arm64/include/asm/kvm_types.h   |  6 +++
 arch/mips/include/asm/kvm_types.h    |  5 +++
 arch/powerpc/include/asm/kvm_types.h |  5 +++
 arch/s390/include/asm/kvm_types.h    |  5 +++
 arch/x86/include/asm/kvm_host.h      | 11 -----
 arch/x86/include/asm/kvm_types.h     |  9 ++++
 arch/x86/kvm/mmu.c                   | 60 ---------------------------
 include/linux/kvm_host.h             | 11 +++++
 include/linux/kvm_types.h            | 13 ++++++
 virt/kvm/kvm_main.c                  | 61 ++++++++++++++++++++++++++++
 11 files changed, 120 insertions(+), 71 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_types.h
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 arch/s390/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h

diff --git a/arch/arm/include/asm/kvm_types.h b/arch/arm/include/asm/kvm_types.h
new file mode 100644
index 000000000000..bc389f82e88d
--- /dev/null
+++ b/arch/arm/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_KVM_TYPES_H
+#define _ASM_ARM_KVM_TYPES_H
+
+#endif /* _ASM_ARM_KVM_TYPES_H */
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
new file mode 100644
index 000000000000..d0987007d581
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_KVM_TYPES_H
+#define _ASM_ARM64_KVM_TYPES_H
+
+#endif /* _ASM_ARM64_KVM_TYPES_H */
+
diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
new file mode 100644
index 000000000000..5efeb32a5926
--- /dev/null
+++ b/arch/mips/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_MIPS_KVM_TYPES_H
+#define _ASM_MIPS_KVM_TYPES_H
+
+#endif /* _ASM_MIPS_KVM_TYPES_H */
diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
new file mode 100644
index 000000000000..f627eceaa314
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KVM_TYPES_H
+#define _ASM_POWERPC_KVM_TYPES_H
+
+#endif /* _ASM_POWERPC_KVM_TYPES_H */
diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
new file mode 100644
index 000000000000..b66a81f8a354
--- /dev/null
+++ b/arch/s390/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_KVM_TYPES_H
+#define _ASM_S390_KVM_TYPES_H
+
+#endif /* _ASM_S390_KVM_TYPES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 50eb430b0ad8..e5080b618f3c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -179,8 +179,6 @@ enum {
 
 #include <asm/kvm_emulate.h>
 
-#define KVM_NR_MEM_OBJS 40
-
 #define KVM_NR_DB_REGS	4
 
 #define DR6_BD		(1 << 13)
@@ -231,15 +229,6 @@ enum {
 
 struct kvm_kernel_irq_routing_entry;
 
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 /*
  * the pages used as guest page table on soft mmu are tracked by
  * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
new file mode 100644
index 000000000000..40428651dc7a
--- /dev/null
+++ b/arch/x86/include/asm/kvm_types.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVM_TYPES_H
+#define _ASM_X86_KVM_TYPES_H
+
+#define KVM_ARCH_WANT_MMU_MEMORY_CACHE
+
+#define KVM_NR_MEM_OBJS 40
+
+#endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 540190cee3cb..abcdb47b0ac7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -40,7 +40,6 @@
 
 #include <asm/page.h>
 #include <asm/pat.h>
-#include <asm/pgalloc.h>
 #include <asm/cmpxchg.h>
 #include <asm/e820/api.h>
 #include <asm/io.h>
@@ -1018,56 +1017,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
-{
-	void *obj;
-
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
-		if (!obj)
-			return cache->nobjs >= min ? 0 : -ENOMEM;
-		cache->objects[cache->nobjs++] = obj;
-	}
-	return 0;
-}
-
-static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
-{
-	return cache->nobjs;
-}
-
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
-				  struct kmem_cache *cache)
-{
-	while (mc->nobjs)
-		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
-}
-
-static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
-				       int min)
-{
-	void *page;
-
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
-		if (!page)
-			return cache->nobjs >= min ? 0 : -ENOMEM;
-		cache->objects[cache->nobjs++] = page;
-	}
-	return 0;
-}
-
-static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
-{
-	while (mc->nobjs)
-		free_page((unsigned long)mc->objects[--mc->nobjs]);
-}
-
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -1094,15 +1043,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 				mmu_page_header_cache);
 }
 
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
-{
-	void *p;
-
-	BUG_ON(!mc->nobjs);
-	p = mc->objects[--mc->nobjs];
-	return p;
-}
-
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e15ea4..612922d440cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -788,6 +788,17 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+			   struct kmem_cache *base_cache, int min);
+int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache);
+void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+			   struct kmem_cache *cache);
+int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min);
+void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc);
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+#endif
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index bde5374ae021..ca7d3b3c8487 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -18,6 +18,7 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
+#include <asm/kvm_types.h>
 #include <asm/types.h>
 
 /*
@@ -49,4 +50,16 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+/*
+ * We don't want allocation failures within the mmu code, so we preallocate
+ * enough memory for a single page fault in a cache.
+ */
+struct kvm_mmu_memory_cache {
+	int nobjs;
+	void *objects[KVM_NR_MEM_OBJS];
+};
+#endif
+
+
 #endif /* __KVM_TYPES_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd68fbe0a75d..a4e8297152e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,6 +51,7 @@
 #include <linux/io.h>
 #include <linux/lockdep.h>
 
+#include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
@@ -288,6 +289,66 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+			   struct kmem_cache *base_cache, int min)
+{
+	void *obj;
+
+	if (cache->nobjs >= min)
+		return 0;
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
+		obj = kmem_cache_alloc(base_cache, GFP_PGTABLE_USER);
+		if (!obj)
+			return cache->nobjs >= min ? 0 : -ENOMEM;
+		cache->objects[cache->nobjs++] = obj;
+	}
+	return 0;
+}
+
+int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
+{
+	return cache->nobjs;
+}
+
+void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+			   struct kmem_cache *cache)
+{
+	while (mc->nobjs)
+		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
+}
+
+int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
+{
+	void *page;
+
+	if (cache->nobjs >= min)
+		return 0;
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
+		page = (void *)__get_free_page(GFP_PGTABLE_USER);
+		if (!page)
+			return cache->nobjs >= min ? 0 : -ENOMEM;
+		cache->objects[cache->nobjs++] = page;
+	}
+	return 0;
+}
+
+void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
+{
+	while (mc->nobjs)
+		free_page((unsigned long)mc->objects[--mc->nobjs]);
+}
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+{
+	void *p;
+
+	BUG_ON(!mc->nobjs);
+	p = mc->objects[--mc->nobjs];
+	return p;
+}
+#endif
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
-- 
2.18.0

