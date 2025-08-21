Return-Path: <kvm+bounces-55420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBCBB30949
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79948586697
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13392EBDCE;
	Thu, 21 Aug 2025 22:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Z/+lZKYI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ECF29BD81;
	Thu, 21 Aug 2025 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815880; cv=none; b=NVZxiWz5n+pdw70fOkdE2R7135VlJWG1uQG7832MhwEk/eocUhhuBRQ0zSz8V/Vh0aFThEtUyijeU9RqkpA1R3z+avBrBjPKps0/qw18BeU8nVOx6+Hm4t4xzZMbYWxdbDPMa/mL9S1wIIpVmsgMZ57zXG293Bq507T1l07jBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815880; c=relaxed/simple;
	bh=MoQkVcflzI1KSO5aG3oyUTZzcoTiA69E2ysOVHQv+jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqyl8+JA6vQC1dsPOkIxRYNHpZW/llGel+GzNF48kPt4md7fDCTxEn1DqSvK9XKGfBR928QDL5TNADlMtA4PWWD5c7MGugBtCFETxcHCtzUGwB3SX2e3Sn6EjcmQ+giZ9FRLLlwTCUgmgcA5oxe2nmGPUb6IDhdhdHw+nEVCZrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Z/+lZKYI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOS984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:45 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOS984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815805;
	bh=TlDmkj83S7Z2ogLbA4FTouBBPSsxfAgEGoAgTZa+HGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/+lZKYIPWtB8rR+f/O3uHY8aO/N01JNvZEQXRcEYytTYJiVzI0/b1ykOIQTKYV3t
	 CgtRddoDPbl9JzujKJhjCwK2Qvqi+pbcknmyByZZRR6Uax6uSY3k4+MmGoMU2WZ1kY
	 uQEuYw3lYU7tFN2Y2o1NVzZa/w/jvK/k3f+OAcX8PO4v74A4N66ng2lBwVA6O5tOJI
	 S1B6sI3hzDg2cS9VXMm/uLaD0G4eGVXiWJQpaNV5rAKg0f+KFW0oS0nHtvjyiR+N64
	 6e/YUMfjaYyusiNrR3lbpLDAIlV1nbMBPvgre36zPTwdKUs78DkNzBpMP5qGtvokxU
	 tpJx2JnyyNDyw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 04/20] x86/cea: Export an API to get per CPU exception stacks for KVM to use
Date: Thu, 21 Aug 2025 15:36:13 -0700
Message-ID: <20250821223630.984383-5-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
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
index c3b4acbde0d8..88b6bc518a5a 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -859,7 +859,7 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 
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
index 34a054181c4d..cb14919f92da 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2307,12 +2307,12 @@ static inline void setup_getcpu(int cpu)
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


