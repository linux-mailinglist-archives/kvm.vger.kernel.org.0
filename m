Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D2465FDB9
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjAFJWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjAFJU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:28 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F4F6B5B4;
        Fri,  6 Jan 2023 01:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996827; x=1704532827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1btCS+fPGw4qMHA2rFFVqLI4KNR7oe9rgRpQWOSfK8A=;
  b=BlnbfU9HDCjb3RNiRJ0oXCo2umy7222c5xfLipNtQqLvq11hnm4VclZp
   UeqwtmbVQ/UR9mf6w2rOqHucBvbU8IP/bpH5an3yFIQ4G90kVJpTcHPOb
   txTbPSA4PuTyBI1Cjqiy9UEwoFCqrXEUlgJjkYhv7rhbS+sTs4UdEjeJP
   uOe2aGHaAzI/o0Faf2rhrdp7A8sDU+QaKWuxgn7khxLMdp76J8DLXOHam
   J8PiCG2+xN9W41MTmQG1Q1xXTR0iGQgEQ1Plm6S1yxqv2nB1vPtwNr4kg
   BUp4niZZTVYuGIk+Dyf58n9C1Qv0/6SSW+d4wC2M6VlXWDL/6L5uYfras
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511649"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511649"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139464"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139464"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:18 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 30/32] x86/fred: allow FRED systems to use interrupt vectors 0x10-0x1f
Date:   Fri,  6 Jan 2023 00:56:15 -0800
Message-Id: <20230106085617.17248-31-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

FRED inherits the Intel VT-x enhancement of classified events with
a two-level event dispatch logic. The first-level dispatch is on
the event type, and the second-level is on the event vector. This
also means that vectors in different event types are orthogonal,
thus, vectors 0x10-0x1f become available as hardware interrupts.

Enable interrupt vectors 0x10-0x1f on FRED systems (interrupt 0x80 is
already enabled.) Most of these changes are about removing the
assumption that the lowest-priority vector is hard-wired to 0x20.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/idtentry.h    |  4 ++--
 arch/x86/include/asm/irq.h         |  5 +++++
 arch/x86/include/asm/irq_vectors.h | 15 +++++++++++----
 arch/x86/kernel/apic/apic.c        | 11 ++++++++---
 arch/x86/kernel/apic/vector.c      |  8 +++++++-
 arch/x86/kernel/fred.c             |  4 ++--
 arch/x86/kernel/idt.c              |  6 +++---
 arch/x86/kernel/irq.c              |  2 +-
 arch/x86/kernel/traps.c            |  2 ++
 9 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index aec45611d79d..99d53fdabcc9 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -540,8 +540,8 @@ __visible noinstr void func(struct pt_regs *regs,			\
  */
 	.align IDT_ALIGN
 SYM_CODE_START(irq_entries_start)
-    vector=FIRST_EXTERNAL_VECTOR
-    .rept NR_EXTERNAL_VECTORS
+    vector=FIRST_EXTERNAL_VECTOR_IDT
+    .rept FIRST_SYSTEM_VECTOR - FIRST_EXTERNAL_VECTOR_IDT
 	UNWIND_HINT_IRET_REGS
 0 :
 	ENDBR
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 768aa234cbb4..e4be6f8409ad 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -11,6 +11,11 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+/*
+ * The first available IRQ vector
+ */
+extern unsigned int __ro_after_init first_external_vector;
+
 /*
  * The irq entry code is in the noinstr section and the start/end of
  * __irqentry_text is emitted via labels. Make the build fail if
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 43dcb9284208..cb3670a7c18f 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -31,15 +31,23 @@
 
 /*
  * IDT vectors usable for external interrupt sources start at 0x20.
- * (0x80 is the syscall vector, 0x30-0x3f are for ISA)
+ * (0x80 is the syscall vector, 0x30-0x3f are for ISA).
+ *
+ * With FRED we can also use 0x10-0x1f even though those overlap
+ * exception vectors as FRED distinguishes exceptions and interrupts.
+ * Therefore, FIRST_EXTERNAL_VECTOR is no longer a constant.
  */
-#define FIRST_EXTERNAL_VECTOR		0x20
+#define FIRST_EXTERNAL_VECTOR_IDT	0x20
+#define FIRST_EXTERNAL_VECTOR_FRED	0x10
+#define FIRST_EXTERNAL_VECTOR		first_external_vector
 
 /*
  * Reserve the lowest usable vector (and hence lowest priority)  0x20 for
  * triggering cleanup after irq migration. 0x21-0x2f will still be used
  * for device interrupts.
  */
+#define IRQ_MOVE_CLEANUP_VECTOR_IDT	FIRST_EXTERNAL_VECTOR_IDT
+#define IRQ_MOVE_CLEANUP_VECTOR_FRED	FIRST_EXTERNAL_VECTOR_FRED
 #define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
 
 #define IA32_SYSCALL_VECTOR		0x80
@@ -48,7 +56,7 @@
  * Vectors 0x30-0x3f are used for ISA interrupts.
  *   round up to the next 16-vector boundary
  */
-#define ISA_IRQ_VECTOR(irq)		(((FIRST_EXTERNAL_VECTOR + 16) & ~15) + irq)
+#define ISA_IRQ_VECTOR(irq)		(((FIRST_EXTERNAL_VECTOR_IDT + 16) & ~15) + irq)
 
 /*
  * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
@@ -114,7 +122,6 @@
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
 #endif
 
-#define NR_EXTERNAL_VECTORS		(FIRST_SYSTEM_VECTOR - FIRST_EXTERNAL_VECTOR)
 #define NR_SYSTEM_VECTORS		(NR_VECTORS - FIRST_SYSTEM_VECTOR)
 
 /*
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c6876d3ea4b1..1fbf6e3ed6c7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1621,12 +1621,17 @@ static void setup_local_APIC(void)
 	/*
 	 * Set Task Priority to 'accept all except vectors 0-31'.  An APIC
 	 * vector in the 16-31 range could be delivered if TPR == 0, but we
-	 * would think it's an exception and terrible things will happen.  We
-	 * never change this later on.
+	 * would think it's an exception and terrible things will happen,
+	 * unless we are using FRED in which case interrupts and
+	 * exceptions are distinguished by type code.
+	 *
+	 * We never change this later on.
 	 */
+	BUG_ON(!first_external_vector);
+
 	value = apic_read(APIC_TASKPRI);
 	value &= ~APIC_TPRI_MASK;
-	value |= 0x10;
+	value |= (first_external_vector - 0x10) & APIC_TPRI_MASK;
 	apic_write(APIC_TASKPRI, value);
 
 	/* Clear eventually stale ISR/IRR bits */
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 3e6f6b448f6a..1d7374fa8a1c 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -46,6 +46,7 @@ static struct irq_matrix *vector_matrix;
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct hlist_head, cleanup_list);
 #endif
+unsigned int first_external_vector = FIRST_EXTERNAL_VECTOR_IDT;
 
 void lock_vector_lock(void)
 {
@@ -800,7 +801,12 @@ int __init arch_early_irq_init(void)
 	 * Allocate the vector matrix allocator data structure and limit the
 	 * search area.
 	 */
-	vector_matrix = irq_alloc_matrix(NR_VECTORS, FIRST_EXTERNAL_VECTOR,
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		first_external_vector = FIRST_EXTERNAL_VECTOR_FRED;
+	else
+		first_external_vector = FIRST_EXTERNAL_VECTOR_IDT;
+
+	vector_matrix = irq_alloc_matrix(NR_VECTORS, first_external_vector,
 					 FIRST_SYSTEM_VECTOR);
 	BUG_ON(!vector_matrix);
 
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 827b58fd98d4..04f057219c6e 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -51,7 +51,7 @@ void __init fred_setup_apic(void)
 {
 	int i;
 
-	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR_FRED; i++)
 		set_bit(i, system_vectors);
 
 	/*
@@ -60,7 +60,7 @@ void __init fred_setup_apic(void)
 	 * /proc/interrupts.
 	 */
 #ifdef CONFIG_SMP
-	set_bit(IRQ_MOVE_CLEANUP_VECTOR, system_vectors);
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR_FRED, system_vectors);
 #endif
 
 	for (i = 0; i < NR_SYSTEM_VECTORS; i++) {
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index a58c6bc1cd68..d3fd86f85de9 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -131,7 +131,7 @@ static const __initconst struct idt_data apic_idts[] = {
 	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
 	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
 	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
-	INTG(IRQ_MOVE_CLEANUP_VECTOR,		asm_sysvec_irq_move_cleanup),
+	INTG(IRQ_MOVE_CLEANUP_VECTOR_IDT,	asm_sysvec_irq_move_cleanup),
 	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
 
@@ -274,13 +274,13 @@ static void __init idt_map_in_cea(void)
  */
 void __init idt_setup_apic_and_irq_gates(void)
 {
-	int i = FIRST_EXTERNAL_VECTOR;
+	int i = FIRST_EXTERNAL_VECTOR_IDT;
 	void *entry;
 
 	idt_setup_from_table(idt_table, apic_idts, ARRAY_SIZE(apic_idts), true);
 
 	for_each_clear_bit_from(i, system_vectors, FIRST_SYSTEM_VECTOR) {
-		entry = irq_entries_start + IDT_ALIGN * (i - FIRST_EXTERNAL_VECTOR);
+		entry = irq_entries_start + IDT_ALIGN * (i - FIRST_EXTERNAL_VECTOR_IDT);
 		set_intr_gate(i, entry);
 	}
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 7e125fff45ab..b7511e02959c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -359,7 +359,7 @@ void fixup_irqs(void)
 	 * vector_lock because the cpu is already marked !online, so
 	 * nothing else will touch it.
 	 */
-	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+	for (vector = first_external_vector; vector < NR_VECTORS; vector++) {
 		if (IS_ERR_OR_NULL(__this_cpu_read(vector_irq[vector])))
 			continue;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c9c96a4e982b..5f4e0b95e904 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1540,6 +1540,8 @@ DEFINE_IDTENTRY_IRQ(spurious_interrupt)
 	pr_info("Spurious interrupt (vector 0x%x) on CPU#%d, should never happen.\n",
 		vector, smp_processor_id());
 }
+
+unsigned int first_external_vector = FIRST_EXTERNAL_VECTOR_IDT;
 #endif
 
 /*
-- 
2.34.1

