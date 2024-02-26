Return-Path: <kvm+bounces-9920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2943786793A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BAC31F27212
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C49412AAFF;
	Mon, 26 Feb 2024 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVB9AbnQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9C712F36A;
	Mon, 26 Feb 2024 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958300; cv=none; b=LWfSxdPljejcs5mYH/tuH9aPUDbUM/Tyfoj0+C75QAWaDF7M1AG9SLff3Kukxd4ja/5dojonDP5Kvqk9XN3ciE8pEK7TGfU8MqdoVlRXHbXv4r2fstChYQcp2gyFVlbl0IZW9sntdsNQmQRxfUzeHT4X6Cu7ZJsBkKvmWD5UgMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958300; c=relaxed/simple;
	bh=wQWJDRe13cC/lAPr09l+aehtvQPpP+T7S4UcqUaG0oM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kN1KBNUUp58lHx0Xyc8I03vA0luST7lV6BzYhgywUAfhFJ/UeDffwiynTr4cyf8IyA2weCDOb3puqrnHNCXSNeUWHJlyp3T0PKgxUV9R+4naqHLervOw/W4jaYGZxEKz3qpJFvdolmcyKNmNWmv3lyt7UxJoXcX9FDqQV1CTWRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVB9AbnQ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5c6bd3100fcso2387589a12.3;
        Mon, 26 Feb 2024 06:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958298; x=1709563098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+RiTkMvyx33Aqiv75PkY1cAw5jxjHAa5YAVlUH/MwnE=;
        b=BVB9AbnQhzoWZYiW2pKJcB+Ah+Jgn1j1IluP9iWWRzUZH/UrL6wTMndJtEvJBU0j+w
         oUO9tN09s9x5MHAYrvgyGKkKa4rJrQVirm1jHhanH83reBlqljxN88DMCGT4CDhPK+WJ
         qPcdjF4+IFEp+SXhdA5SH6voduX3SAO6G8OYrkiyF2k4XsfbsPoD8hcmyw0M5sq8a0kM
         clqoYsOE9ZGlcOfRTwwof27AgkCAQ2T4bRWvvUc8XMKB4lCwZImxBfNlSkiT8TmvL3Gy
         yXRPUKEfhTXByDlSnsZ1MOS+aRnP0CZVulRfnHFp6qORSMFM7K9bwbBKKGVJvRO5VBZ9
         RTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958298; x=1709563098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+RiTkMvyx33Aqiv75PkY1cAw5jxjHAa5YAVlUH/MwnE=;
        b=ElefZ8huafonUv/Bh9GE44aRKeTXva33cN9akYm68Kkq6C5Nf4GlIzo6EQSZQd81L/
         NnbTrbwwrZavPYZ/hG5l6dSzBZOoN8+vqV2drG8rq9r1OqCAuE6eBZAKaLrEcq3As2mf
         yA5gvmOYciA+HcZ1etBIbL8kEPeSDOtgbJ5nCgCtAkgbK0ao0NdrABVqYN3roqcDy1qy
         DgYX0LXv1IIjz5p4DFxzA+QeZZp6tfLyERux5F9si2SEIN1L8+rCepSpFbUkxnR3xB5m
         TkCuz/L+IXMvT49sWEvqQ3wcm473Krs3yUgh3bOM43eWN4gGqKSHmSVsGy/504wvvR8c
         TdJw==
X-Forwarded-Encrypted: i=1; AJvYcCXkNPHbNSvNdSgpicPZGVUxcw9mPnCR7zDfsYgf03soHroCLkb38gz1ZNAdpEAp2x3HrihyNEZuo0i+RiqpMNFr3qNe
X-Gm-Message-State: AOJu0YzIfuRSolwoiRBk2AOOVf8O/ODjpPrfLRXjBlNu+fd03FjfAvju
	pPainCMWRg7Z4BZNW5fVYjDPEg8FxkDU9MkolkPEiHpJ5ipKnCl56vfCPuYf
X-Google-Smtp-Source: AGHT+IGS7+CQrWPm6z5nP1RqkHXHHk4aPrrGAQAjzn0ILkLtPs+kVghGUmCwm0mOuOTFyjaUkqS3Ww==
X-Received: by 2002:a05:6a20:12cb:b0:1a0:e089:e25e with SMTP id v11-20020a056a2012cb00b001a0e089e25emr6228306pzg.46.1708958297873;
        Mon, 26 Feb 2024 06:38:17 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id g11-20020a63e60b000000b005dbd0facb4dsm3930417pgh.61.2024.02.26.06.38.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:17 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Yuntao Wang <ytcoode@gmail.com>,
	Wang Jinchao <wangjinchao@xfusion.com>
Subject: [RFC PATCH 57/73] x86/pvm: Make cpu entry area and vmalloc area variable
Date: Mon, 26 Feb 2024 22:36:14 +0800
Message-Id: <20240226143630.33643-58-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

For the PVM guest, the entire kernel layout should be within the allowed
virtual address range. Therefore, establish CPU_ENTRY_AREA_BASE and
VMEMORY_END as a variable for the PVM guest, allowing it to be
modified as necessary for the PVM guest.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/page_64.h          |  3 +++
 arch/x86/include/asm/pgtable_64_types.h | 14 ++++++++++++--
 arch/x86/kernel/head64.c                |  7 +++++++
 arch/x86/mm/dump_pagetables.c           |  3 ++-
 arch/x86/mm/kaslr.c                     |  4 ++--
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index b8692e6cc939..4f64f049f3d0 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -18,6 +18,9 @@ extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
 
+extern unsigned long cpu_entry_area_base;
+extern unsigned long vmemory_end;
+
 static __always_inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
 	unsigned long y = x - KERNEL_MAP_BASE;
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 6780f2e63717..66c8e7325d27 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -140,6 +140,7 @@ extern unsigned int ptrs_per_p4d;
 # define VMEMMAP_START		__VMEMMAP_BASE_L4
 #endif /* CONFIG_DYNAMIC_MEMORY_LAYOUT */
 
+#ifndef CONFIG_PVM_GUEST
 /*
  * End of the region for which vmalloc page tables are pre-allocated.
  * For non-KMSAN builds, this is the same as VMALLOC_END.
@@ -147,6 +148,10 @@ extern unsigned int ptrs_per_p4d;
  * VMALLOC_START..VMALLOC_END (see below).
  */
 #define VMEMORY_END		(VMALLOC_START + (VMALLOC_SIZE_TB << 40) - 1)
+#else
+#define RAW_VMEMORY_END		(__VMALLOC_BASE_L4 + (VMALLOC_SIZE_TB_L4 << 40) - 1)
+#define VMEMORY_END		vmemory_end
+#endif /* CONFIG_PVM_GUEST */
 
 #ifndef CONFIG_KMSAN
 #define VMALLOC_END		VMEMORY_END
@@ -166,7 +171,7 @@ extern unsigned int ptrs_per_p4d;
  *              KMSAN_MODULES_ORIGIN_START to
  *              KMSAN_MODULES_ORIGIN_START + MODULES_LEN - origins for modules.
  */
-#define VMALLOC_QUARTER_SIZE	((VMALLOC_SIZE_TB << 40) >> 2)
+#define VMALLOC_QUARTER_SIZE	((VMEMORY_END + 1 - VMALLOC_START) >> 2)
 #define VMALLOC_END		(VMALLOC_START + VMALLOC_QUARTER_SIZE - 1)
 
 /*
@@ -202,7 +207,12 @@ extern unsigned int ptrs_per_p4d;
 #define ESPFIX_BASE_ADDR	(ESPFIX_PGD_ENTRY << P4D_SHIFT)
 
 #define CPU_ENTRY_AREA_PGD	_AC(-4, UL)
-#define CPU_ENTRY_AREA_BASE	(CPU_ENTRY_AREA_PGD << P4D_SHIFT)
+#define RAW_CPU_ENTRY_AREA_BASE	(CPU_ENTRY_AREA_PGD << P4D_SHIFT)
+#ifdef CONFIG_PVM_GUEST
+#define CPU_ENTRY_AREA_BASE	cpu_entry_area_base
+#else
+#define CPU_ENTRY_AREA_BASE	RAW_CPU_ENTRY_AREA_BASE
+#endif
 
 #define EFI_VA_START		( -4 * (_AC(1, UL) << 30))
 #define EFI_VA_END		(-68 * (_AC(1, UL) << 30))
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 0b0e460609e5..d0e8d648bd38 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -72,6 +72,13 @@ unsigned long kernel_map_base __ro_after_init = __START_KERNEL_map;
 EXPORT_SYMBOL(kernel_map_base);
 #endif
 
+#ifdef CONFIG_PVM_GUEST
+unsigned long cpu_entry_area_base __ro_after_init = RAW_CPU_ENTRY_AREA_BASE;
+EXPORT_SYMBOL(cpu_entry_area_base);
+unsigned long vmemory_end __ro_after_init = RAW_VMEMORY_END;
+EXPORT_SYMBOL(vmemory_end);
+#endif
+
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
 {
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index d5c6f61242aa..166c7d36d8ff 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -95,7 +95,7 @@ static struct addr_marker address_markers[] = {
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
 	[LDT_NR]		= { 0UL,		"LDT remap" },
 #endif
-	[CPU_ENTRY_AREA_NR]	= { CPU_ENTRY_AREA_BASE,"CPU entry Area" },
+	[CPU_ENTRY_AREA_NR]	= { 0UL,		"CPU entry Area" },
 #ifdef CONFIG_X86_ESPFIX64
 	[ESPFIX_START_NR]	= { ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 #endif
@@ -479,6 +479,7 @@ static int __init pt_dump_init(void)
 	address_markers[MODULES_VADDR_NR].start_address = MODULES_VADDR;
 	address_markers[MODULES_END_NR].start_address = MODULES_END;
 	address_markers[FIXADDR_START_NR].start_address = FIXADDR_START;
+	address_markers[CPU_ENTRY_AREA_NR].start_address = CPU_ENTRY_AREA_BASE;
 #endif
 #ifdef CONFIG_X86_32
 	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 37db264866b6..e3825c7542a3 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -38,7 +38,7 @@
  * highest amount of space for randomization available, but that's too hard
  * to keep straight and caused issues already.
  */
-static const unsigned long vaddr_end = CPU_ENTRY_AREA_BASE;
+static const unsigned long vaddr_end = RAW_CPU_ENTRY_AREA_BASE;
 
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
@@ -79,7 +79,7 @@ void __init kernel_randomize_memory(void)
 	 * limited....
 	 */
 	BUILD_BUG_ON(vaddr_start >= vaddr_end);
-	BUILD_BUG_ON(vaddr_end != CPU_ENTRY_AREA_BASE);
+	BUILD_BUG_ON(vaddr_end != RAW_CPU_ENTRY_AREA_BASE);
 	BUILD_BUG_ON(vaddr_end > __START_KERNEL_map);
 
 	if (!kaslr_memory_enabled())
-- 
2.19.1.6.gb485710b


