Return-Path: <kvm+bounces-61118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FFA9C0B263
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 304441886DE4
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0C9302746;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aug6c38y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6F2FE04F;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510033; cv=none; b=EI/bJUybvFi/AiTiLO+qXFPJ+7LgNT/al8RjGXyLsTyltsqfQ96rQoAPNolr/24iO9C+Lix9IK1Wr/mRgiQowM8AWKgyZwnr/mX1iLw1f2cA5++tzvl8QBjaujrw8qiRkOns0oyU287Z9jeXA8cjTkNg04Sv2ttYw703FK4McRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510033; c=relaxed/simple;
	bh=6slAdzPRx8VEf+NryPxdm03GtWMJKJrWGa3NU8vujLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv1klAmi46xVLR0UulaIHghyk7X9/BvXeRV9n5Jqo0iOAWeogZlk0HQHz3tUP6lg8mtV6gdWLlx70fgcil2KekofvnkNMfTxnBkV9lwkee6M5y2qVO6BUdTOuo0Vd21qF89lgRwQ9cWA4PaDODCSKAi9jGvkU4lyxdoBNhmB2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aug6c38y; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkL505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkL505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509963;
	bh=vT84OOWG2Ddx2HJsQreFn9+fFEcZJ2YryT3xCA0tRTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aug6c38y/HtwJw14jF69yO58r2qZxMk0nA5B32+T2sWxKumbG5KgADVgf3TghQ3ff
	 t0hVQ3A0vmp56znGZTUGL2b7y7kIjWpRdFKgj1v1Ywz4OP0SYgun7cLyvbCaMc8tsM
	 TAONtNS3hECSqCkXZpVu0DHdODElUiv3m+Si7MmbZNL+vUlVFeXpY+gbX1EbyPBqGX
	 JdzbXYsSlyrtrWm/d/zEax5wqP1qNO/b5vPBjPE9jHkb+dhKGFx91JhQjcpyhJrohB
	 blb12s7cXcoA0c29MmEwZEUvHHz/evISdgC7w6xtjVSwp8nt6JsNoE3zcofZgU5Q3F
	 aMHRJgiPu2zmg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 04/22] x86/cea: Prefix event stack names with ESTACK_
Date: Sun, 26 Oct 2025 13:18:52 -0700
Message-ID: <20251026201911.505204-5-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ESTACK_ prefix to event stack names to improve clarity and
readability.  Without the prefix, names like DF, NMI, and DB are too
brief and potentially ambiguous.

This renaming also prepares for converting __this_cpu_ist_top_va from
a macro into a function that accepts an enum exception_stack_ordering
argument, without requiring changes to existing callsites.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Changes in v7:
* Move rename code to this patch (Dave Hansen).
* Fix a vertical alignment (Dave Hansen).
---
 arch/x86/coco/sev/noinstr.c           |  4 ++--
 arch/x86/coco/sev/vc-handle.c         |  2 +-
 arch/x86/include/asm/cpu_entry_area.h | 26 +++++++++++++-------------
 arch/x86/kernel/cpu/common.c          | 10 +++++-----
 arch/x86/kernel/dumpstack_64.c        | 14 +++++++-------
 arch/x86/kernel/fred.c                |  6 +++---
 arch/x86/kernel/traps.c               |  2 +-
 arch/x86/mm/cpu_entry_area.c          | 12 ++++++------
 arch/x86/mm/fault.c                   |  2 +-
 9 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/coco/sev/noinstr.c b/arch/x86/coco/sev/noinstr.c
index b527eafb6312..c3985c9b232c 100644
--- a/arch/x86/coco/sev/noinstr.c
+++ b/arch/x86/coco/sev/noinstr.c
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
index 7fc136a35334..1d3f086ae4c3 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -871,7 +871,7 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 
 static __always_inline bool is_vc2_stack(unsigned long sp)
 {
-	return (sp >= __this_cpu_ist_bottom_va(VC2) && sp < __this_cpu_ist_top_va(VC2));
+	return (sp >= __this_cpu_ist_bottom_va(ESTACK_VC2) && sp < __this_cpu_ist_top_va(ESTACK_VC2));
 }
 
 static __always_inline bool vc_from_invalid_context(struct pt_regs *regs)
diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index 462fc34f1317..d0f884c28178 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -18,19 +18,19 @@
 
 /* Macro to enforce the same ordering and stack sizes */
 #define ESTACKS_MEMBERS(guardsize, optional_stack_size)		\
-	char	DF_stack_guard[guardsize];			\
-	char	DF_stack[EXCEPTION_STKSZ];			\
-	char	NMI_stack_guard[guardsize];			\
-	char	NMI_stack[EXCEPTION_STKSZ];			\
-	char	DB_stack_guard[guardsize];			\
-	char	DB_stack[EXCEPTION_STKSZ];			\
-	char	MCE_stack_guard[guardsize];			\
-	char	MCE_stack[EXCEPTION_STKSZ];			\
-	char	VC_stack_guard[guardsize];			\
-	char	VC_stack[optional_stack_size];			\
-	char	VC2_stack_guard[guardsize];			\
-	char	VC2_stack[optional_stack_size];			\
-	char	IST_top_guard[guardsize];			\
+	char	ESTACK_DF_stack_guard[guardsize];		\
+	char	ESTACK_DF_stack[EXCEPTION_STKSZ];		\
+	char	ESTACK_NMI_stack_guard[guardsize];		\
+	char	ESTACK_NMI_stack[EXCEPTION_STKSZ];		\
+	char	ESTACK_DB_stack_guard[guardsize];		\
+	char	ESTACK_DB_stack[EXCEPTION_STKSZ];		\
+	char	ESTACK_MCE_stack_guard[guardsize];		\
+	char	ESTACK_MCE_stack[EXCEPTION_STKSZ];		\
+	char	ESTACK_VC_stack_guard[guardsize];		\
+	char	ESTACK_VC_stack[optional_stack_size];		\
+	char	ESTACK_VC2_stack_guard[guardsize];		\
+	char	ESTACK_VC2_stack[optional_stack_size];		\
+	char	ESTACK_IST_top_guard[guardsize];		\
 
 /* The exception stacks' physical storage. No guard pages required */
 struct exception_stacks {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c7d3512914ca..5f78b8f63d8d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2332,12 +2332,12 @@ static inline void setup_getcpu(int cpu)
 static inline void tss_setup_ist(struct tss_struct *tss)
 {
 	/* Set up the per-CPU TSS IST stacks */
-	tss->x86_tss.ist[IST_INDEX_DF] = __this_cpu_ist_top_va(DF);
-	tss->x86_tss.ist[IST_INDEX_NMI] = __this_cpu_ist_top_va(NMI);
-	tss->x86_tss.ist[IST_INDEX_DB] = __this_cpu_ist_top_va(DB);
-	tss->x86_tss.ist[IST_INDEX_MCE] = __this_cpu_ist_top_va(MCE);
+	tss->x86_tss.ist[IST_INDEX_DF]	= __this_cpu_ist_top_va(ESTACK_DF);
+	tss->x86_tss.ist[IST_INDEX_NMI]	= __this_cpu_ist_top_va(ESTACK_NMI);
+	tss->x86_tss.ist[IST_INDEX_DB]	= __this_cpu_ist_top_va(ESTACK_DB);
+	tss->x86_tss.ist[IST_INDEX_MCE]	= __this_cpu_ist_top_va(ESTACK_MCE);
 	/* Only mapped when SEV-ES is active */
-	tss->x86_tss.ist[IST_INDEX_VC] = __this_cpu_ist_top_va(VC);
+	tss->x86_tss.ist[IST_INDEX_VC]	= __this_cpu_ist_top_va(ESTACK_VC);
 }
 #else /* CONFIG_X86_64 */
 static inline void tss_setup_ist(struct tss_struct *tss) { }
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6c5defd6569a..40f51e278171 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -73,7 +73,7 @@ struct estack_pages {
 	 PFN_DOWN(CEA_ESTACK_OFFS(st) + CEA_ESTACK_SIZE(st) - 1)] = {	\
 		.offs	= CEA_ESTACK_OFFS(st),				\
 		.size	= CEA_ESTACK_SIZE(st),				\
-		.type	= STACK_TYPE_EXCEPTION + ESTACK_ ##st, }
+		.type	= STACK_TYPE_EXCEPTION + st, }
 
 /*
  * Array of exception stack page descriptors. If the stack is larger than
@@ -83,12 +83,12 @@ struct estack_pages {
  */
 static const
 struct estack_pages estack_pages[CEA_ESTACK_PAGES] ____cacheline_aligned = {
-	EPAGERANGE(DF),
-	EPAGERANGE(NMI),
-	EPAGERANGE(DB),
-	EPAGERANGE(MCE),
-	EPAGERANGE(VC),
-	EPAGERANGE(VC2),
+	EPAGERANGE(ESTACK_DF),
+	EPAGERANGE(ESTACK_NMI),
+	EPAGERANGE(ESTACK_DB),
+	EPAGERANGE(ESTACK_MCE),
+	EPAGERANGE(ESTACK_VC),
+	EPAGERANGE(ESTACK_VC2),
 };
 
 static __always_inline bool in_exception_stack(unsigned long *stack, struct stack_info *info)
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
index 6b22611e69cc..47b7b7495114 100644
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
index 575f863f3c75..9fa371af8abc 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -151,15 +151,15 @@ static void __init percpu_setup_exception_stacks(unsigned int cpu)
 	 * by guard pages so each stack must be mapped separately. DB2 is
 	 * not mapped; it just exists to catch triple nesting of #DB.
 	 */
-	cea_map_stack(DF);
-	cea_map_stack(NMI);
-	cea_map_stack(DB);
-	cea_map_stack(MCE);
+	cea_map_stack(ESTACK_DF);
+	cea_map_stack(ESTACK_NMI);
+	cea_map_stack(ESTACK_DB);
+	cea_map_stack(ESTACK_MCE);
 
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
 		if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)) {
-			cea_map_stack(VC);
-			cea_map_stack(VC2);
+			cea_map_stack(ESTACK_VC);
+			cea_map_stack(ESTACK_VC2);
 		}
 	}
 }
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
2.51.0


