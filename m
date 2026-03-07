Return-Path: <kvm+bounces-73227-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHl0H+0irGnulgEAu9opvQ
	(envelope-from <kvm+bounces-73227-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 14:06:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03BE222BD44
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 14:06:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B136730226A3
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 13:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1662439E6E3;
	Sat,  7 Mar 2026 13:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Pe4LzOid"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF139E6D1;
	Sat,  7 Mar 2026 13:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772888797; cv=none; b=Fmy+gvFhyRhp/K1iKQdBf+hOEGGE14l1mGKi7y4NzWxgFwNccuoQKl6DtuaveUzyJho0KTI+Ft9QH5yBrrpuxbemi3Y2goGLNXW3jGQMfdPtU9vTLxtv0Qioia56ibFjTkH0hxcR7DcEY7TxA/RleSUnisHHjaWfymRs33lcsM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772888797; c=relaxed/simple;
	bh=KZkqo/gwTPfqTTybik7wp5gryevOIICkbR06CP83SUU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jMjBNUfiCQPH80UZrXKQ46+Diy4L6yXgxjgJFThPUDoZ0yTDUh+O+MF4Tj2poEgRmxn2Z5RMR0ftex+oua51r68XZzl/C68DQm87Wv2SEgth8vEHpxTizZiisJJwayUKf/7Wsz6EUYc+ZNA7+u+/Hr0aFc1724fbwTAc8Nkcmlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Pe4LzOid; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2N
	nYf0TylnfesYJfPKbFSikhT8HSeI1rOTmDrhxI7/g=; b=Pe4LzOidB+y8SxKGp5
	NhkRI+7MjIz+nY6TDHnE64AePj1JGKqg8Yvfv2X/5VZ6swujgnDftKVKJos/yc6H
	+fmpHb7/B7y/p8M/nMP7SfjtNGlLIhw3Nu0igxU4AIh38JfQpM+0paKYP2GhhCzX
	eynHVXc29X4JEEyloJuGsFmnE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wCHbWl3IqxpV5Y+Pw--.38359S2;
	Sat, 07 Mar 2026 21:04:56 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH v1] RISC-V: KVM: Batch stage-2 remote TLB flushes
Date: Sat,  7 Mar 2026 21:04:52 +0800
Message-ID: <20260307130452.721375-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHbWl3IqxpV5Y+Pw--.38359S2
X-Coremail-Antispam: 1Uf129KBjvJXoWfJrWfAFWrAr47Ww45WFy3Jwb_yoWDKw43pr
	4DCryfur4fXrs7XF13tFWDZrn8uws7W3WrAry5CF90yFn0qr4fXr1vg34vvry5JryrXFW3
	ZFyDGF15Ar4IyFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piUGYdUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/xtbC8RgspGmsInj8EwAA3R
X-Rspamd-Queue-Id: 03BE222BD44
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[163.com,none];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[brainfault.org,linux.dev,kernel.org,sifive.com,dabbelt.com,eecs.berkeley.edu,ghiti.fr,oss.qualcomm.com,microchip.com,hotmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-73227-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[163.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tjytimi@163.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,163.com];
	NEURAL_HAM(-0.00)[-0.980];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

KVM RISC-V triggers a TLB flush for every single stage-2 PTE
modification (unmap or write-protect) now. Although KVM coalesces the
hardware IPIs, the software overhead of executing the flush work
for every 4K page is large, especially during dirty page tracking.

Following the approach used in x86 and arm64, this patch optimizes
the MMU logic by making the PTE manipulation functions return a boolean
indicating if a leaf PTE was actually changed. The outer MMU functions
bubble up this flag to batch the remote TLB flushes. This change makes 
the generic KVM MMU callbacks (e.g., `kvm_unmap_gfn_range()`) actually 
effective by returning the true flush requirement rather than `false`.

Consequently, the flush operation is executed only once per batch.
Moving it outside of the `mmu_lock` also reduces lock contention. 
For directory pages, we keep the synchronous flush to ensure safety.

Tested with tools/testing/selftests/kvm on a 4-vCPU guest (Host
environment: QEMU 10.2.1 RISC-V)
1. demand_paging_test (1GB memory)
	# time ./demand_paging_test -b 1G -v 4
   - Total execution time reduced from ~2m33s to ~2m25s
2. dirty_log_perf_test (1GB memory)
   	# ./dirty_log_perf_test -b 1G -v 4
	- "Clear dirty log time" per iteration dropped significantly from
     ~3.02s to ~0.20s

Signed-off-by: Jinyu Tang <tjytimi@163.com>
---
 arch/riscv/include/asm/kvm_gstage.h |  6 ++---
 arch/riscv/kvm/gstage.c             | 40 ++++++++++++++++++++---------
 arch/riscv/kvm/mmu.c                | 34 ++++++++++++++++++------
 3 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
index 595e21831..b003a07f1 100644
--- a/arch/riscv/include/asm/kvm_gstage.h
+++ b/arch/riscv/include/asm/kvm_gstage.h
@@ -59,13 +59,13 @@ enum kvm_riscv_gstage_op {
 	GSTAGE_OP_WP,		/* Write-protect */
 };
 
-void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
+bool kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 			     pte_t *ptep, u32 ptep_level, enum kvm_riscv_gstage_op op);
 
-void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
+bool kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 				  gpa_t start, gpa_t size, bool may_block);
 
-void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end);
+bool kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end);
 
 void kvm_riscv_gstage_mode_detect(void);
 
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d72..8e7a69d35 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -209,49 +209,59 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
 	return kvm_riscv_gstage_set_pte(gstage, pcache, out_map);
 }
 
-void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
+bool kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 			     pte_t *ptep, u32 ptep_level, enum kvm_riscv_gstage_op op)
 {
 	int i, ret;
 	pte_t old_pte, *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
+	bool flush = false;
 
 	ret = gstage_level_to_page_size(ptep_level, &page_size);
 	if (ret)
-		return;
+		return false;
 
 	WARN_ON(addr & (page_size - 1));
 
 	if (!pte_val(ptep_get(ptep)))
-		return;
+		return false;
 
 	if (ptep_level && !gstage_pte_leaf(ptep)) {
 		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
 		next_ptep_level = ptep_level - 1;
 		ret = gstage_level_to_page_size(next_ptep_level, &next_page_size);
 		if (ret)
-			return;
+			return false;
 
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		for (i = 0; i < PTRS_PER_PTE; i++)
-			kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
+			flush |= kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
 						&next_ptep[i], next_ptep_level, op);
-		if (op == GSTAGE_OP_CLEAR)
+		if (op == GSTAGE_OP_CLEAR) {
+			gstage_tlb_flush(gstage, ptep_level, addr);
+			flush = false;
 			put_page(virt_to_page(next_ptep));
+		}
 	} else {
 		old_pte = *ptep;
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		if (pte_val(*ptep) != pte_val(old_pte))
-			gstage_tlb_flush(gstage, ptep_level, addr);
+		if (pte_val(*ptep) != pte_val(old_pte)) {
+			if (gstage->flags & KVM_GSTAGE_FLAGS_LOCAL)
+				gstage_tlb_flush(gstage, ptep_level, addr);
+			else
+				flush = true;
+		}
 	}
+
+	return flush;
 }
 
-void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
+bool kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 				  gpa_t start, gpa_t size, bool may_block)
 {
 	int ret;
@@ -260,6 +270,7 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 	bool found_leaf;
 	unsigned long page_size;
 	gpa_t addr = start, end = start + size;
+	bool flush = false;
 
 	while (addr < end) {
 		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
@@ -271,7 +282,7 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 			goto next;
 
 		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
+			flush |= kvm_riscv_gstage_op_pte(gstage, addr, ptep,
 						ptep_level, GSTAGE_OP_CLEAR);
 
 next:
@@ -284,9 +295,11 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 		if (!(gstage->flags & KVM_GSTAGE_FLAGS_LOCAL) && may_block && addr < end)
 			cond_resched_lock(&gstage->kvm->mmu_lock);
 	}
+
+	return flush;
 }
 
-void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end)
+bool kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end)
 {
 	int ret;
 	pte_t *ptep;
@@ -294,6 +307,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
 	bool found_leaf;
 	gpa_t addr = start;
 	unsigned long page_size;
+	bool flush = false;
 
 	while (addr < end) {
 		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
@@ -305,12 +319,14 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
 			goto next;
 
 		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
+			flush |= kvm_riscv_gstage_op_pte(gstage, addr, ptep,
 						ptep_level, GSTAGE_OP_WP);
 
 next:
 		addr += page_size;
 	}
+
+	return flush;
 }
 
 void __init kvm_riscv_gstage_mode_detect(void)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 0b75eb2a1..075cc433e 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -23,6 +23,7 @@ static void mmu_wp_memory_region(struct kvm *kvm, int slot)
 	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
 	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 	struct kvm_gstage gstage;
+	bool flush;
 
 	gstage.kvm = kvm;
 	gstage.flags = 0;
@@ -30,9 +31,10 @@ static void mmu_wp_memory_region(struct kvm *kvm, int slot)
 	gstage.pgd = kvm->arch.pgd;
 
 	spin_lock(&kvm->mmu_lock);
-	kvm_riscv_gstage_wp_range(&gstage, start, end);
+	flush = kvm_riscv_gstage_wp_range(&gstage, start, end);
 	spin_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs_memslot(kvm, memslot);
+	if (flush)
+		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
@@ -88,6 +90,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 void kvm_riscv_mmu_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
 {
 	struct kvm_gstage gstage;
+	bool flush;
 
 	gstage.kvm = kvm;
 	gstage.flags = 0;
@@ -95,8 +98,11 @@ void kvm_riscv_mmu_iounmap(struct kvm *kvm, gpa_t gpa, unsigned long size)
 	gstage.pgd = kvm->arch.pgd;
 
 	spin_lock(&kvm->mmu_lock);
-	kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
+	flush = kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
+
+	if (flush)
+		kvm_flush_remote_tlbs_range(kvm, gpa >> PAGE_SHIFT, size >> PAGE_SHIFT);
 }
 
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
@@ -108,13 +114,18 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
 	struct kvm_gstage gstage;
+	bool flush;
 
 	gstage.kvm = kvm;
 	gstage.flags = 0;
 	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
 	gstage.pgd = kvm->arch.pgd;
 
-	kvm_riscv_gstage_wp_range(&gstage, start, end);
+	flush = kvm_riscv_gstage_wp_range(&gstage, start, end);
+	if (flush)
+		kvm_flush_remote_tlbs_range(kvm, start >> PAGE_SHIFT,
+			(end - start) >> PAGE_SHIFT);
+
 }
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
@@ -140,6 +151,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 	struct kvm_gstage gstage;
+	bool flush;
 
 	gstage.kvm = kvm;
 	gstage.flags = 0;
@@ -147,8 +159,10 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gstage.pgd = kvm->arch.pgd;
 
 	spin_lock(&kvm->mmu_lock);
-	kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
+	flush = kvm_riscv_gstage_unmap_range(&gstage, gpa, size, false);
 	spin_unlock(&kvm->mmu_lock);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 void kvm_arch_commit_memory_region(struct kvm *kvm,
@@ -253,10 +267,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	gstage.flags = 0;
 	gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
 	gstage.pgd = kvm->arch.pgd;
-	kvm_riscv_gstage_unmap_range(&gstage, range->start << PAGE_SHIFT,
+	return kvm_riscv_gstage_unmap_range(&gstage, range->start << PAGE_SHIFT,
 				     (range->end - range->start) << PAGE_SHIFT,
 				     range->may_block);
-	return false;
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -579,6 +592,7 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 {
 	struct kvm_gstage gstage;
 	void *pgd = NULL;
+	bool flush = false;
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
@@ -586,13 +600,17 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 		gstage.flags = 0;
 		gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
 		gstage.pgd = kvm->arch.pgd;
-		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size, false);
+		flush = kvm_riscv_gstage_unmap_range(&gstage, 0UL,
+					kvm_riscv_gstage_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
 	}
 	spin_unlock(&kvm->mmu_lock);
 
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
 	if (pgd)
 		free_pages((unsigned long)pgd, get_order(kvm_riscv_gstage_pgd_size));
 }
-- 
2.43.0


