Return-Path: <kvm+bounces-2463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E58A57F9745
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 02:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60975B20A50
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 01:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C3110FC;
	Mon, 27 Nov 2023 01:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05481CB;
	Sun, 26 Nov 2023 17:44:15 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxJuhs9GNlYPg8AA--.62322S3;
	Mon, 27 Nov 2023 09:44:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bxrdxq9GNlHlJNAA--.39309S2;
	Mon, 27 Nov 2023 09:44:10 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Optimization for memslot hugepage checking
Date: Mon, 27 Nov 2023 09:44:10 +0800
Message-Id: <20231127014410.4122997-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bxrdxq9GNlHlJNAA--.39309S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3WFW5tF1Dtw47WFyrJr18WFX_yoW3Gr4UpF
	43ArsxCrW5Jr13ursrtw1Duw15Aws5Gw17Ga47t34FvFn0yr15Ja1kA3y8Jry5JrW8ZFW2
	qFWYyF4UW3yUt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXUUUUU=

During shadow mmu page fault, there is checking for huge page for
specified memslot. Page fault is hot path, check logic can be done
when memslot is created. Here two flags are added for huge page
checking, KVM_MEM_HUGEPAGE_CAPABLE and KVM_MEM_HUGEPAGE_INCAPABLE.
Instead for optimization qemu, memslot for dram is always huge page
aligned. The flag is firstly checked during hot page fault path.

Now only huge page flag is supported, there is a long way for super
page support in LoongArch system. Since super page size is 64G for
16K pagesize and 1G for 4K pagesize, 64G physical address is rarely
used and LoongArch kernel needs support super page for 4K. Also memory
layout of LoongArch qemu VM should be 1G aligned.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |   3 +
 arch/loongarch/kvm/mmu.c              | 127 +++++++++++++++++---------
 2 files changed, 89 insertions(+), 41 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 11328700d4fa..0e89db020481 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -45,7 +45,10 @@ struct kvm_vcpu_stat {
 	u64 signal_exits;
 };
 
+#define KVM_MEM_HUGEPAGE_CAPABLE	(1UL << 0)
+#define KVM_MEM_HUGEPAGE_INCAPABLE	(1UL << 1)
 struct kvm_arch_memory_slot {
+	unsigned long flags;
 };
 
 struct kvm_context {
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 80480df5f550..6845733f37dc 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -13,6 +13,16 @@
 #include <asm/tlb.h>
 #include <asm/kvm_mmu.h>
 
+static inline bool kvm_hugepage_capable(struct kvm_memory_slot *slot)
+{
+	return slot->arch.flags & KVM_MEM_HUGEPAGE_CAPABLE;
+}
+
+static inline bool kvm_hugepage_incapable(struct kvm_memory_slot *slot)
+{
+	return slot->arch.flags & KVM_MEM_HUGEPAGE_INCAPABLE;
+}
+
 static inline void kvm_ptw_prepare(struct kvm *kvm, kvm_ptw_ctx *ctx)
 {
 	ctx->level = kvm->arch.root_level;
@@ -365,6 +375,71 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_ptw_top(kvm->arch.pgd, start << PAGE_SHIFT, end << PAGE_SHIFT, &ctx);
 }
 
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				const struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
+{
+	size_t size, gpa_offset, hva_offset;
+	gpa_t gpa_start;
+	hva_t hva_start;
+
+	if ((change != KVM_MR_MOVE) && (change != KVM_MR_CREATE))
+		return 0;
+	/*
+	 * Prevent userspace from creating a memory region outside of the
+	 * VM GPA address space
+	 */
+	if ((new->base_gfn + new->npages) > (kvm->arch.gpa_size >> PAGE_SHIFT))
+		return -ENOMEM;
+
+	size = new->npages * PAGE_SIZE;
+	gpa_start = new->base_gfn << PAGE_SHIFT;
+	hva_start = new->userspace_addr;
+	new->arch.flags = 0;
+	if (IS_ALIGNED(size, PMD_SIZE) && IS_ALIGNED(gpa_start, PMD_SIZE)
+			&& IS_ALIGNED(hva_start, PMD_SIZE))
+		new->arch.flags |= KVM_MEM_HUGEPAGE_CAPABLE;
+	else {
+		/*
+		 * Pages belonging to memslots that don't have the same
+		 * alignment within a PMD for userspace and GPA cannot be
+		 * mapped with PMD entries, because we'll end up mapping
+		 * the wrong pages.
+		 *
+		 * Consider a layout like the following:
+		 *
+		 *    memslot->userspace_addr:
+		 *    +-----+--------------------+--------------------+---+
+		 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
+		 *    +-----+--------------------+--------------------+---+
+		 *
+		 *    memslot->base_gfn << PAGE_SIZE:
+		 *      +---+--------------------+--------------------+-----+
+		 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
+		 *      +---+--------------------+--------------------+-----+
+		 *
+		 * If we create those stage-2 blocks, we'll end up with this
+		 * incorrect mapping:
+		 *   d -> f
+		 *   e -> g
+		 *   f -> h
+		 */
+		gpa_offset = gpa_start & (PMD_SIZE - 1);
+		hva_offset = hva_start & (PMD_SIZE - 1);
+		if (gpa_offset != hva_offset) {
+			new->arch.flags |= KVM_MEM_HUGEPAGE_INCAPABLE;
+		} else {
+			if (gpa_offset == 0)
+				gpa_offset = PMD_SIZE;
+			if ((size + gpa_offset) < (PMD_SIZE * 2))
+				new->arch.flags |= KVM_MEM_HUGEPAGE_INCAPABLE;
+		}
+	}
+
+	return 0;
+}
+
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *old,
 				   const struct kvm_memory_slot *new,
@@ -562,47 +637,23 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 }
 
 static bool fault_supports_huge_mapping(struct kvm_memory_slot *memslot,
-				unsigned long hva, unsigned long map_size, bool write)
+				unsigned long hva, bool write)
 {
-	size_t size;
-	gpa_t gpa_start;
-	hva_t uaddr_start, uaddr_end;
+	hva_t start, end;
 
 	/* Disable dirty logging on HugePages */
 	if (kvm_slot_dirty_track_enabled(memslot) && write)
 		return false;
 
-	size = memslot->npages * PAGE_SIZE;
-	gpa_start = memslot->base_gfn << PAGE_SHIFT;
-	uaddr_start = memslot->userspace_addr;
-	uaddr_end = uaddr_start + size;
+	if (kvm_hugepage_capable(memslot))
+		return true;
 
-	/*
-	 * Pages belonging to memslots that don't have the same alignment
-	 * within a PMD for userspace and GPA cannot be mapped with stage-2
-	 * PMD entries, because we'll end up mapping the wrong pages.
-	 *
-	 * Consider a layout like the following:
-	 *
-	 *    memslot->userspace_addr:
-	 *    +-----+--------------------+--------------------+---+
-	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
-	 *    +-----+--------------------+--------------------+---+
-	 *
-	 *    memslot->base_gfn << PAGE_SIZE:
-	 *      +---+--------------------+--------------------+-----+
-	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
-	 *      +---+--------------------+--------------------+-----+
-	 *
-	 * If we create those stage-2 blocks, we'll end up with this incorrect
-	 * mapping:
-	 *   d -> f
-	 *   e -> g
-	 *   f -> h
-	 */
-	if ((gpa_start & (map_size - 1)) != (uaddr_start & (map_size - 1)))
+	if (kvm_hugepage_incapable(memslot))
 		return false;
 
+	start = memslot->userspace_addr;
+	end = start + memslot->npages * PAGE_SIZE;
+
 	/*
 	 * Next, let's make sure we're not trying to map anything not covered
 	 * by the memslot. This means we have to prohibit block size mappings
@@ -615,8 +666,8 @@ static bool fault_supports_huge_mapping(struct kvm_memory_slot *memslot,
 	 * userspace_addr or the base_gfn, as both are equally aligned (per
 	 * the check above) and equally sized.
 	 */
-	return (hva & ~(map_size - 1)) >= uaddr_start &&
-		(hva & ~(map_size - 1)) + map_size <= uaddr_end;
+	return (hva >= ALIGN(start, PMD_SIZE)) &&
+			(hva < ALIGN_DOWN(end, PMD_SIZE));
 }
 
 /*
@@ -842,7 +893,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	/* Disable dirty logging on HugePages */
 	level = 0;
-	if (!fault_supports_huge_mapping(memslot, hva, PMD_SIZE, write)) {
+	if (!fault_supports_huge_mapping(memslot, hva, write)) {
 		level = 0;
 	} else {
 		level = host_pfn_mapping_level(kvm, gfn, memslot);
@@ -901,12 +952,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
 
-int kvm_arch_prepare_memory_region(struct kvm *kvm, const struct kvm_memory_slot *old,
-				   struct kvm_memory_slot *new, enum kvm_mr_change change)
-{
-	return 0;
-}
-
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					const struct kvm_memory_slot *memslot)
 {
-- 
2.39.3


