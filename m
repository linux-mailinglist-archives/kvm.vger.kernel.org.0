Return-Path: <kvm+bounces-53298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8877AB0F9D0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02E4AA7543
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA25824C664;
	Wed, 23 Jul 2025 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DRwfDCM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6F4243387;
	Wed, 23 Jul 2025 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293282; cv=none; b=g8ZTpomRHM5J9O1hl3hY9vFI6M152tfdcKd5qNKAMtPu/kTn8njhe3T1zSrr40IQ61e4BHoIRjdiWZ3ketokVKWydCY3xNdnG5eFyhhmW3DsBBXlR6k5PnXLcfK6hHvYKTt3wvwZzE/AN0Szux/vBdsPUzDo0MWFp/xCkPOAhl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293282; c=relaxed/simple;
	bh=Y9dXsRrgWme/Psx4ALMo1EVrCJB0pqVZzUs8S2+582s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd9Fu3C6vh3nF07sgnyGPqQVkvTFsfd3lLoLy5XZBw7EDXGj9BnqATBg7KRmmgpFQGzWpX0teUERLDquO/c8fMTOumdBPTUMIvfUdiS1eI+4zY8Bg3VZo4oozvHPuRgxZ0Z8GPGEqWPW4FYj6OcgeGGeKEnQIWO2Kv6bATHdGho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DRwfDCM/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxs1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxs1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293229;
	bh=zWmv1h33/Y4aVP2ROh/ukXxbHw+ez10mA/TACx32Rmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRwfDCM/WYq6OI6VfHvrw4cIROJug08++6mq8FURDipFVJ5evAXpi6BVW+QtSlFdl
	 9+KeKxjXAsxmAVXzPHiJTvw5ELxUOymXSn51j91dhRzG5wKBmw6w8UYv/q5oa+KDqt
	 qPis5HOztDddWxe+NMb6LBa04e0pgaT5pO7tEk75zxCYeX5O6mp4lM/Ld+FqdW4BMG
	 hrSSXNTZJqqwNKXPU89ANb+K4pCNqqyuhndVpo4nainZ9WOsQjZYuUKfIzajdD6GQw
	 1fx1DoncpOnylhL8G2O3TKE54qNJ3J26PpNnPsPssB0w4r5PjMlsA4DQ8KusB2qWoy
	 OxnyampBwMZ3A==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 04/23] x86/cea: Export an API to get per CPU exception stacks for KVM to use
Date: Wed, 23 Jul 2025 10:53:22 -0700
Message-ID: <20250723175341.1284463-5-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FRED introduced new fields in the host-state area of the VMCS for
stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
corresponding to per CPU exception stacks for #DB, NMI and #DF.
KVM must populate these each time a vCPU is loaded onto a CPU.

Convert the __this_cpu_ist_{top,bottom}_va() macros into real
functions and export __this_cpu_ist_top_va().

Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Export accessor instead of data (Christoph Hellwig).
* Add TB from Xuelian Guo.

Change in v4:
* Rewrite the change log and add comments to the export (Dave Hansen).
---
 arch/x86/coco/sev/sev-nmi.c           |  4 ++--
 arch/x86/coco/sev/vc-handle.c         |  2 +-
 arch/x86/include/asm/cpu_entry_area.h | 17 ++++-------------
 arch/x86/kernel/cpu/common.c          | 10 +++++-----
 arch/x86/kernel/fred.c                |  6 +++---
 arch/x86/kernel/traps.c               |  2 +-
 arch/x86/mm/cpu_entry_area.c          | 21 +++++++++++++++++++++
 arch/x86/mm/fault.c                   |  2 +-
 8 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/coco/sev/sev-nmi.c b/arch/x86/coco/sev/sev-nmi.c
index d8dfaddfb367..73e34ad7a1a9 100644
--- a/arch/x86/coco/sev/sev-nmi.c
+++ b/arch/x86/coco/sev/sev-nmi.c
@@ -30,7 +30,7 @@ static __always_inline bool on_vc_stack(struct pt_regs *regs)
 	if (ip_within_syscall_gap(regs))
 		return false;
 
-	return ((sp >= __this_cpu_ist_bottom_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
+	return ((sp >= __this_cpu_ist_bottom_va(ESTACK_VC)) && (sp < __this_cpu_ist_top_va(ESTACK_VC)));
 }
 
 /*
@@ -82,7 +82,7 @@ void noinstr __sev_es_ist_exit(void)
 	/* Read IST entry */
 	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
 
-	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
+	if (WARN_ON(ist == __this_cpu_ist_top_va(ESTACK_VC)))
 		return;
 
 	/* Read back old IST entry and write it to the TSS */
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index 0989d98da130..a6e274f2a135 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -851,7 +851,7 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 
 static __always_inline bool is_vc2_stack(unsigned long sp)
 {
-	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
+	return (sp >= __this_cpu_ist_bottom_va(ESTACK_VC2) && sp < __this_cpu_ist_top_va(ESTACK_VC2));
 }
 
 static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 462fc34f1317..8e17f0ca74e6 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -46,7 +46,7 @@ struct cea_exception_stacks {
  * The exception stack ordering in [cea_]exception_stacks
  */
 enum exception_stack_ordering {
-	ESTACK_DF,
+	ESTACK_DF = 0,
 	ESTACK_NMI,
 	ESTACK_DB,
 	ESTACK_MCE,
@@ -58,18 +58,15 @@ enum exception_stack_ordering {
 #define CEA_ESTACK_SIZE(st)					\
 	sizeof(((struct cea_exception_stacks *)0)->st## _stack)
 
-#define CEA_ESTACK_BOT(ceastp, st)				\
-	((unsigned long)&(ceastp)->st## _stack)
-
-#define CEA_ESTACK_TOP(ceastp, st)				\
-	(CEA_ESTACK_BOT(ceastp, st) + CEA_ESTACK_SIZE(st))
-
 #define CEA_ESTACK_OFFS(st)					\
 	offsetof(struct cea_exception_stacks, st## _stack)
 
 #define CEA_ESTACK_PAGES					\
 	(sizeof(struct cea_exception_stacks) / PAGE_SIZE)
 
+extern unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack);
+extern unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack);
+
 #endif
 
 #ifdef CONFIG_X86_32
@@ -144,10 +141,4 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
 
-#define __this_cpu_ist_top_va(name)					\
-	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
-
-#define __this_cpu_ist_bottom_va(name)					\
-	CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
-
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fb50c1dd53ef..6fedd1b30e99 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2306,12 +2306,12 @@ static inline void setup_getcpu(int cpu)
 static inline void tss_setup_ist(struct tss_struct *tss)
 {
 	/* Set up the per-CPU TSS IST stacks */
-	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(DF);
-	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
-	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
-	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
+	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(ESTACK_DF);
+	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(ESTACK_NMI);
+	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(ESTACK_DB);
+	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(ESTACK_MCE);
 	/* Only mapped when SEV-ES is active */
-	tss->x86_tss.ist[IST_INDEX_VC] = __this_cpu_ist_top_va(VC);
+	tss->x86_tss.ist[IST_INDEX_VC] = __this_cpu_ist_top_va(ESTACK_VC);
 }
 #else /* CONFIG_X86_64 */
 static inline void tss_setup_ist(struct tss_struct *tss) { }
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 816187da3a47..06d944a3d051 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -87,7 +87,7 @@ void cpu_init_fred_rsps(void)
 	       FRED_STKLVL(X86_TRAP_DF,  FRED_DF_STACK_LEVEL));
 
 	/* The FRED equivalents to IST stacks... */
-	wrmsrq(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
-	wrmsrq(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
-	wrmsrq(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
+	wrmsrq(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
+	wrmsrq(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
+	wrmsrq(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 36354b470590..5c9c5ebf5e73 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -954,7 +954,7 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 
 	if (!get_stack_info_noinstr(stack, current, &info) || info.type == STACK_TYPE_ENTRY ||
 	    info.type > STACK_TYPE_EXCEPTION_LAST)
-		sp = __this_cpu_ist_top_va(VC2);
+		sp = __this_cpu_ist_top_va(ESTACK_VC2);
 
 sync:
 	/*
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 575f863f3c75..eedaf103c8ad 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -18,6 +18,27 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage)
 static DEFINE_PER_CPU_PAGE_ALIGNED(struct exception_stacks, exception_stacks);
 DEFINE_PER_CPU(struct cea_exception_stacks*, cea_exception_stacks);
 
+/*
+ * FRED introduced new fields in the host-state area of the VMCS for
+ * stack levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively
+ * corresponding to per CPU stacks for #DB, NMI and #DF.  KVM must
+ * populate these each time a vCPU is loaded onto a CPU.
+ *
+ * Called from entry code, so must be noinstr.
+ */
+noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
+{
+	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
+	return base + EXCEPTION_STKSZ + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
+}
+EXPORT_SYMBOL(__this_cpu_ist_top_va);
+
+noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
+{
+	unsigned long base = (unsigned long)&(__this_cpu_read(cea_exception_stacks)->DF_stack);
+	return base + stack * (EXCEPTION_STKSZ + PAGE_SIZE);
+}
+
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
 static __always_inline unsigned int cea_offset(unsigned int cpu)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 998bd807fc7b..1804eb86cc14 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -671,7 +671,7 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 		 * and then double-fault, though, because we're likely to
 		 * break the console driver and lose most of the stack dump.
 		 */
-		call_on_stack(__this_cpu_ist_top_va(DF) - sizeof(void*),
+		call_on_stack(__this_cpu_ist_top_va(ESTACK_DF) - sizeof(void*),
 			      handle_stack_overflow,
 			      ASM_CALL_ARG3,
 			      , [arg1] "r" (regs), [arg2] "r" (address), [arg3] "r" (&info));
-- 
2.50.1


