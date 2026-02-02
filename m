Return-Path: <kvm+bounces-69809-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPgDKQ9ZgGns6wIAu9opvQ
	(envelope-from <kvm+bounces-69809-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:58:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB66C96B6
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 516123125881
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 07:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7060A30F7F2;
	Mon,  2 Feb 2026 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D5A9eCaq"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3891E320CAC
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 07:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770018433; cv=none; b=bqu6rs6V1KI8P96jMa0s0Hh+UBcp578I842OOT4QshFoVMV0g1sR/VEk03IAyXYSmvOEPXlxpS7/E5hnkrQ5AF5vE2O5NjlWq81hmatO9vRUk9U8/UNlYDQYBlhS6LE6qw8LPPVzPKT9ovk87XNwpVopWJwOriba1Km7vEnc2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770018433; c=relaxed/simple;
	bh=gRpj5c5STjQ9EGwM72DyBu7SzU/eVaaVklj1ux45W8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0C2n2U5lw68z27O3JSPmduVNFGetMPyLnJRG4b5Pq878EcITfByWcJu02U6BWkpMZscYz+3BeV5RZExDucg41gPKzeCySevBiWdtrZ6cEOQWzrjZ+DsZ2+M+QQeAxnuLVU30Qh4LGLRX6xRie1uJqF4UbrJorivMzuRAVC8zKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D5A9eCaq; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770018427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=isCUzTGbqG3bOQ3RuuUP2N5J/vxqd6Q7qV+0hYo+bgg=;
	b=D5A9eCaqnDwPfPlsPpp1aRvf1ZE+NM/c95SgXDrGmAR44MyygQktcjUSU8XXvyPNYQaWk9
	qcl8JQRK/IR1Ut1hUF03zTtPVT1QYpBajRDaL9tMaezJYNweSBRbD2uETbtApbcSOdWO/7
	emFfeNqqDRnsBQgk6p5oB0F0XfVXwP8=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI optimization support
Date: Mon,  2 Feb 2026 15:45:57 +0800
Message-ID: <20260202074557.16544-4-lance.yang@linux.dev>
In-Reply-To: <20260202074557.16544-1-lance.yang@linux.dev>
References: <20260202074557.16544-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,intel.com,linux.intel.com,redhat.com,google.com,gmail.com,infradead.org,linutronix.de,alien8.de,zytor.com,arndb.de,oracle.com,nvidia.com,linux.alibaba.com,arm.com,surriel.com,suse.com,lists.linux.dev,vger.kernel.org,kvack.org,linux.dev];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69809-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[38];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: 0DB66C96B6
X-Rspamd-Action: no action

From: Lance Yang <lance.yang@linux.dev>

When the TLB flush path already sends IPIs (e.g. native without INVLPGB,
or KVM), tlb_remove_table_sync_mm() does not need to send another round.

Add a property on pv_mmu_ops so each paravirt backend can indicate whether
its flush_tlb_multi sends real IPIs; if so, tlb_remove_table_sync_mm() is
a no-op.

Native sets it in native_pv_tlb_init() when still using
native_flush_tlb_multi() and INVLPGB is disabled. KVM sets it true; Xen and
Hyper-V set it false because they use hypercalls.

Also pass both freed_tables and unshared_tables from tlb_flush() into
flush_tlb_mm_range() so lazy-TLB CPUs get IPIs during hugetlb unshare.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/hyperv/mmu.c                 |  5 +++++
 arch/x86/include/asm/paravirt.h       |  5 +++++
 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 20 +++++++++++++++++++-
 arch/x86/kernel/kvm.c                 |  6 ++++++
 arch/x86/kernel/paravirt.c            | 18 ++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/xen/mmu_pv.c                 |  2 ++
 include/asm-generic/tlb.h             | 15 +++++++++++++++
 mm/mmu_gather.c                       |  7 +++++++
 10 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index cfcb60468b01..fc8fb275f295 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -243,4 +243,9 @@ void hyperv_setup_mmu_ops(void)
 
 	pr_info("Using hypercall for remote TLB flush\n");
 	pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
+	/*
+	 * Hyper-V uses hypercalls for TLB flush, not real IPIs.
+	 * Keep the property as false.
+	 */
+	pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = false;
 }
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 13f9cd31c8f8..1fdbe3736f41 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -698,6 +698,7 @@ static __always_inline unsigned long arch_local_irq_save(void)
 
 extern void default_banner(void);
 void native_pv_lock_init(void) __init;
+void native_pv_tlb_init(void) __init;
 
 #else  /* __ASSEMBLER__ */
 
@@ -727,6 +728,10 @@ void native_pv_lock_init(void) __init;
 static inline void native_pv_lock_init(void)
 {
 }
+
+static inline void native_pv_tlb_init(void)
+{
+}
 #endif
 #endif /* !CONFIG_PARAVIRT */
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..d8aa519ef5e3 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -133,6 +133,12 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);
 
+	/*
+	 * Indicates whether flush_tlb_multi IPIs provide sufficient
+	 * synchronization during TLB flush when freeing or unsharing page tables.
+	 */
+	bool flush_tlb_multi_implies_ipi_broadcast;
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..1e524d8e260a 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,23 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+#ifdef CONFIG_PARAVIRT
+	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
+#else
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+#endif
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +33,12 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * During TLB flushes, pass both freed_tables and unshared_tables
+	 * so lazy-TLB CPUs receive IPIs.
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 37dc8465e0f5..6a5e47ee4eb6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
 	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
+		/*
+		 * KVM's flush implementation calls native_flush_tlb_multi(),
+		 * which sends real IPIs when INVLPGB is not available.
+		 */
+		if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+			pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..1af253c9f51d 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,6 +60,23 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
+void __init native_pv_tlb_init(void)
+{
+	/*
+	 * Check if we're still using native TLB flush (not overridden by
+	 * a PV backend) and don't have INVLPGB support.
+	 *
+	 * In this case, native IPI-based TLB flush provides sufficient
+	 * synchronization for GUP-fast.
+	 *
+	 * PV backends (KVM, Xen, HyperV) should set this property in their
+	 * own initialization code if their flush implementation sends IPIs.
+	 */
+	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
+	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
+}
+
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
@@ -173,6 +190,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = false,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5cd6950ab672..3cdb04162843 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1167,6 +1167,7 @@ void __init native_smp_prepare_boot_cpu(void)
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 7a35c3393df4..b6d86299cf10 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2185,6 +2185,8 @@ static const typeof(pv_ops) xen_mmu_ops __initconst = {
 		.flush_tlb_kernel = xen_flush_tlb,
 		.flush_tlb_one_user = xen_flush_tlb_one_user,
 		.flush_tlb_multi = xen_flush_tlb_multi,
+		/* Xen uses hypercalls for TLB flush, not real IPIs */
+		.flush_tlb_multi_implies_ipi_broadcast = false,
 
 		.pgd_alloc = xen_pgd_alloc,
 		.pgd_free = xen_pgd_free,
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 40eb74b28f9d..fae97c8bcceb 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -240,6 +240,21 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 }
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
+/*
+ * Architectures can override this to indicate whether TLB flush operations
+ * send IPIs that are sufficient to synchronize with lockless page table
+ * walkers (e.g., GUP-fast). If true, tlb_remove_table_sync_mm() becomes
+ * a no-op as the TLB flush already provided the necessary IPI.
+ *
+ * Default is false, meaning we need explicit IPIs via tlb_remove_table_sync_mm().
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * This allows an architecture that does not use the linux page-tables for
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 76573ec454e5..9620480c11ce 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -303,6 +303,13 @@ void tlb_remove_table_sync_mm(struct mm_struct *mm)
 	bool found_any = false;
 	int cpu;
 
+	/*
+	 * If the architecture's TLB flush already sent IPIs that are sufficient
+	 * for synchronization, we don't need to send additional IPIs.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
 		tlb_remove_table_sync_one();
 		return;
-- 
2.49.0


