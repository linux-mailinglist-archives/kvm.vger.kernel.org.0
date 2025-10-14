Return-Path: <kvm+bounces-59966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB35BD6EEF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 023B04E9B12
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BA72FF645;
	Tue, 14 Oct 2025 01:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="FkmCaAK+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823B82FE057;
	Tue, 14 Oct 2025 01:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404264; cv=none; b=jZhnCtDFmfgkR4mLXfIQwh234+NWcjcFHBwc70jfUx5xMi+/EyF+7LzXK+gNfSEUGIQULhwY83IruqHKXGN5KAKslEhTRjhOKkEgeUOhP0jiJs3uTQ2r8OQoffgTYYKtQJXAcBe207ErvjlmOnLZx0BgA0AUuHTKAXXPYx4RmF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404264; c=relaxed/simple;
	bh=boYL1l9xLWGo3/2NolmH1TULXM2fhR0/YNy1xNfKfLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mY9Yj5KkLx7tkjrlGtAOo6P18BYBAHklJZWHTtOLJcCkzC7+XQN7IclHdw4KmtINUxGuirJ7WMcIuh4vbIisnY9Dgf1vZh3HK7NDifSa+WQAY+55kjQcuMs0x6dvEAShgxjCgTVd29RLXXQjiZlq6LZJQpu1unmqlYAMliDpsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=FkmCaAK+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1S1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:09:59 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1S1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404200;
	bh=z2lJVqJT0UMdIkbScgCd4Til78kV6zueUTLcEHbIfcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkmCaAK+QQkEynwOnMuMw/VE18RBoJ5OeKBYrL5axbC072tZGLlZO4HHcIf5Q9RUd
	 LnPlv7VXqquyHAnzzZ+sJQapVgisFYiY4WM0lYcpGd/RjbdK7UH6mMP17GAp7/26U7
	 Pl0wICDGw/d+k+niKqNQQybMxy8grFThgsIm+Bo5Oti4bUpDBrf4RHMhFLrtyloQfd
	 MXZBK2OxW7S0NPU5FLTR7lGQhOLSrmbeVyULkKk620z9kEANhIePgDLDWIoOXbNWQR
	 eII0xJUVAb/fLol+w0dRg74IalKGxiXBYzTyGmwPTA3TdyjpTDB8vIPbEJn/k+44CI
	 Ltqk/7QWdcQQw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 05/21] x86/cea: Export API for per-CPU exception stacks for KVM
Date: Mon, 13 Oct 2025 18:09:34 -0700
Message-ID: <20251014010950.1568389-6-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the __this_cpu_ist_{top,bottom}_va() macros into proper functions,
and export __this_cpu_ist_top_va() to allow KVM to retrieve the top of the
per-CPU exception stack.

FRED introduced new fields in the host-state area of the VMCS for stack
levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
fields each time a vCPU is loaded onto a CPU.

To simplify access to the exception stacks in struct cea_exception_stacks,
a union is used to create an array alias, enabling array-style indexing of
the stack entries.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v7:
* Remove Suggested-bys (Dave Hansen).
* Move rename code in a separate patch (Dave Hansen).
* Access cea_exception_stacks using array indexing (Dave Hansen).
* Use BUILD_BUG_ON(ESTACK_DF != 0) to ensure the starting index is 0
  (Dave Hansen).

Change in v5:
* Export accessor instead of data (Christoph Hellwig).
* Add TB from Xuelian Guo.

Change in v4:
* Rewrite the change log and add comments to the export (Dave Hansen).
---
 arch/x86/include/asm/cpu_entry_area.h | 51 +++++++++++++--------------
 arch/x86/mm/cpu_entry_area.c          | 25 +++++++++++++
 2 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/cpu_entry_area.h b/arch/x86/include/asm/cpu_entry_area.h
index d0f884c28178..58cd71144e5e 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -16,6 +16,19 @@
 #define VC_EXCEPTION_STKSZ	0
 #endif
 
+/*
+ * The exception stack ordering in [cea_]exception_stacks
+ */
+enum exception_stack_ordering {
+	ESTACK_DF,
+	ESTACK_NMI,
+	ESTACK_DB,
+	ESTACK_MCE,
+	ESTACK_VC,
+	ESTACK_VC2,
+	N_EXCEPTION_STACKS
+};
+
 /* Macro to enforce the same ordering and stack sizes */
 #define ESTACKS_MEMBERS(guardsize, optional_stack_size)		\
 	char	ESTACK_DF_stack_guard[guardsize];		\
@@ -39,37 +52,29 @@ struct exception_stacks {
 
 /* The effective cpu entry area mapping with guard pages. */
 struct cea_exception_stacks {
-	ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
-};
-
-/*
- * The exception stack ordering in [cea_]exception_stacks
- */
-enum exception_stack_ordering {
-	ESTACK_DF,
-	ESTACK_NMI,
-	ESTACK_DB,
-	ESTACK_MCE,
-	ESTACK_VC,
-	ESTACK_VC2,
-	N_EXCEPTION_STACKS
+	union{
+		struct {
+			ESTACKS_MEMBERS(PAGE_SIZE, EXCEPTION_STKSZ)
+		};
+		struct {
+			char stack_guard[PAGE_SIZE];
+			char stack[EXCEPTION_STKSZ];
+		} event_stacks[N_EXCEPTION_STACKS];
+	};
 };
 
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
@@ -144,10 +149,4 @@ static __always_inline struct entry_stack *cpu_entry_stack(int cpu)
 	return &get_cpu_entry_area(cpu)->entry_stack_page.stack;
 }
 
-#define __this_cpu_ist_top_va(name)					\
-	CEA_ESTACK_TOP(__this_cpu_read(cea_exception_stacks), name)
-
-#define __this_cpu_ist_bottom_va(name)					\
-	CEA_ESTACK_BOT(__this_cpu_read(cea_exception_stacks), name)
-
 #endif
diff --git a/arch/x86/mm/cpu_entry_area.c b/arch/x86/mm/cpu_entry_area.c
index 9fa371af8abc..595c2e03ddd5 100644
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -18,6 +18,31 @@ static DEFINE_PER_CPU_PAGE_ALIGNED(struct entry_stack_page, entry_stack_storage)
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
+noinstr unsigned long __this_cpu_ist_bottom_va(enum exception_stack_ordering stack)
+{
+	struct cea_exception_stacks *s;
+
+	BUILD_BUG_ON(ESTACK_DF != 0);
+
+	s = __this_cpu_read(cea_exception_stacks);
+
+	return (unsigned long)&s->event_stacks[stack].stack;
+}
+
+noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
+{
+	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
+}
+EXPORT_SYMBOL(__this_cpu_ist_top_va);
+
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long, _cea_offset);
 
 static __always_inline unsigned int cea_offset(unsigned int cpu)
-- 
2.51.0


