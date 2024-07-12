Return-Path: <kvm+bounces-21543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BFB92FEE8
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23D2E1F21C1E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40405178375;
	Fri, 12 Jul 2024 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Wjwa4mB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9342E178CE8
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803669; cv=none; b=dk3QY0UNwWVKU2UA16mBF8Z96gXZiPjTYgayEwixig2CNBUa8fD8r/ala0FE+XGd6zzmaunIurQuzDxRfW4FLyj7JdAD1Y48lgq0n9RJWV62iwOTV86oAcTRKaxA29KHZojCHyYE/4LjmUvjPzf9Kbxf1o6kKBldo0SZduszhoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803669; c=relaxed/simple;
	bh=4l/aFGSn0+cUe0grjkF9kj1YjmhkIf8eDVOhTK2vwB0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cUHUDbY6NN8uVjvymX5bgKJlp6ADUzd9wMCf//FQOfGjDkJ4SvOQPlv5K46s7hfRHS1ENliRdSrCGhc+hz8EoxlaXWB0G0WCgYSgubb4VOPQxHHt+bl+T44C+2rA8uAc9kIXKYBRDLX+gHs/Ol+Z0PUns8yAOKtpKliCMglNg9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Wjwa4mB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-36789def10eso1371706f8f.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803666; x=1721408466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A+jkQL2bLgnd1dA3asyFJ85yKqjjPIZgiPP4ZLm28ds=;
        b=4Wjwa4mBK3eZaHpx91r4Zb5MbwJMDC5svsczkvs185E9Lsy/6w6WqilsFw26SdWtDw
         M38ePalloGdDpKlufv4+9ZAEmpeE9/rJq3H4qS0ND3OrxqdyiFZzQnCDdW6PM0E5tKOh
         CqUmGPd/S5DjQAEP4ZYOpglDHmySAfOngWril1hO+8AJmUIrnGZKndidr55xGam3+LUC
         3UaFU2BO8oFT3i29506YWadZ7BYVKbylBrkhH2KTDUjAdU1e0nW8AsoPSeGyALFTuXUG
         KbJjhpjORIKWAfaItRXP73NQToPJK6/wfsbpv67n+4pdO25q3YpXgc+hqiTCWLg+H7Y2
         yFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803666; x=1721408466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A+jkQL2bLgnd1dA3asyFJ85yKqjjPIZgiPP4ZLm28ds=;
        b=Xakiy6DrUzqvyEhzlBZpFOAg+D4UUfpBnWmlbs2jiVuwBJaDeuvI68C4Tw4zqJj0GS
         uloFesRECOSOhD2yaZ9dUknm5IeB7YkLq5rNur+tj/63BgiPyZV0G0X0XPTb+XtnRfif
         vLk/T2CfvGr328L9Vie8EIIGtdi/V+OM9p5BOWUpNwrjTkQ9QnIQYUvrRkkvqUB+vkv1
         oJrVQH4+BQhanoTqA8PPRDl1Rw389LcAuo1abLewI2/Wzd54YXo6bYHSPktCIvgQe9LW
         xNyowR4f1w8Fj1AOh1GhNlRC/cFLhMW596KP4Jy7T5ECLJ55BoEovtfAcEu370LZprbN
         JPQg==
X-Forwarded-Encrypted: i=1; AJvYcCU2F412E8k6fyY6LVEec4ycHjn598wun2jjMg+IJkD02WyRPWwgx9lAJSH+Tay/+XfbWwWzoDXX0OvLb8ZARrBXyZVZ
X-Gm-Message-State: AOJu0YxpZzB9gsX/CPRS0e4Bfa5RNQMKZuiWKcs+GhPsfzHVb455QmyX
	+A5tSKltI+kBGflgyler8F4XfOacVqa1YwBgJmDWbkqR7aG6pv/hzqkcCMI1bvRVBITes/K0/Sw
	2INJ8JA88QA==
X-Google-Smtp-Source: AGHT+IHocE6UCQJXGH4jW5S1f1i1qM0rmNw/QM4OyMtcRUe5WUau/3oluaHQD6zUlZ5KVAkubOggLQncuc63kw==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:adf:ea0c:0:b0:367:8147:25c5 with SMTP id
 ffacd0b85a97d-367cea8ef32mr16488f8f.8.1720803665595; Fri, 12 Jul 2024
 10:01:05 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:23 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-5-144b319a40d8@google.com>
Subject: [PATCH 05/26] mm: asi: Add infrastructure for boot-time enablement
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Add a boot time parameter to control the newly added X86_FEATURE_ASI.
"asi=on" or "asi=off" can be used in the kernel command line to enable
or disable ASI at boot time. If not specified, ASI enablement depends
on CONFIG_ADDRESS_SPACE_ISOLATION_DEFAULT_ON, which is off by default.
asi_check_boottime_disable() is modeled after
pti_check_boottime_disable().

The boot parameter is currently ignored until ASI is fully functional.

Once we have a set of ASI features checked in that we have actually
tested, we will stop ignoring the flag. But for now let's just add the
infrastructure so we can implement the usage code.

Co-developed-by: Junaid Shahid <junaids@google.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig                         |  8 +++++
 arch/x86/include/asm/asi.h               | 20 +++++++++--
 arch/x86/include/asm/cpufeatures.h       |  1 +
 arch/x86/include/asm/disabled-features.h |  8 ++++-
 arch/x86/mm/asi.c                        | 61 +++++++++++++++++++++++++++-----
 arch/x86/mm/init.c                       |  4 ++-
 include/asm-generic/asi.h                |  4 +++
 7 files changed, 92 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ff74aa53842e..7f21de55d6ac 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2535,6 +2535,14 @@ config MITIGATION_ADDRESS_SPACE_ISOLATION
 	  This dependencies will later be removed with extensions to the KASAN
 	  implementation.
 
+config ADDRESS_SPACE_ISOLATION_DEFAULT_ON
+	bool "Enable address space isolation by default"
+	default n
+	depends on ADDRESS_SPACE_ISOLATION
+	help
+	  If selected, ASI is enabled by default at boot if the asi=on or
+	  asi=off are not specified.
+
 config MITIGATION_RETPOLINE
 	bool "Avoid speculative indirect branches in kernel"
 	select OBJTOOL if HAVE_OBJTOOL
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index a052e561b2b7..04ba2ec7fd28 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -6,6 +6,7 @@
 
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
+#include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <linux/sched.h>
 
@@ -64,6 +65,9 @@
  * the N ASI classes.
  */
 
+/* Try to avoid this outside of hot code (see comment on _static_cpu_has). */
+#define static_asi_enabled() cpu_feature_enabled(X86_FEATURE_ASI)
+
 #define ASI_MAX_NUM_ORDER	2
 #define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
 
@@ -101,6 +105,8 @@ struct asi {
 
 DECLARE_PER_CPU_ALIGNED(struct asi *, curr_asi);
 
+void asi_check_boottime_disable(void);
+
 void asi_init_mm_state(struct mm_struct *mm);
 
 int  asi_register_class(const char *name, const struct asi_hooks *ops);
@@ -124,7 +130,9 @@ void asi_exit(void);
 /* The target is the domain we'll enter when returning to process context. */
 static __always_inline struct asi *asi_get_target(struct task_struct *p)
 {
-	return p->thread.asi_state.target;
+	return static_asi_enabled()
+	       ? p->thread.asi_state.target
+	       : NULL;
 }
 
 static __always_inline void asi_set_target(struct task_struct *p,
@@ -135,7 +143,9 @@ static __always_inline void asi_set_target(struct task_struct *p,
 
 static __always_inline struct asi *asi_get_current(void)
 {
-	return this_cpu_read(curr_asi);
+	return static_asi_enabled()
+	       ? this_cpu_read(curr_asi)
+	       : NULL;
 }
 
 /* Are we currently in a restricted address space? */
@@ -144,7 +154,11 @@ static __always_inline bool asi_is_restricted(void)
 	return (bool)asi_get_current();
 }
 
-/* If we exit/have exited, can we stay that way until the next asi_enter? */
+/*
+ * If we exit/have exited, can we stay that way until the next asi_enter?
+ *
+ * When ASI is disabled, this returns true.
+ */
 static __always_inline bool asi_is_relaxed(void)
 {
 	return !asi_get_target(current);
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 3c7434329661..a6b213c7df44 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -470,6 +470,7 @@
 #define X86_FEATURE_BHI_CTRL		(21*32+ 2) /* "" BHI_DIS_S HW control available */
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* "" BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* "" Clear branch history at vmexit using SW loop */
+#define X86_FEATURE_ASI			(21*32+5) /* Kernel Address Space Isolation */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index c492bdc97b05..c7964ed4fef8 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -50,6 +50,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+# define DISABLE_ASI		0
+#else
+# define DISABLE_ASI		(1 << (X86_FEATURE_ASI & 31))
+#endif
+
 #ifdef CONFIG_MITIGATION_RETPOLINE
 # define DISABLE_RETPOLINE	0
 #else
@@ -154,7 +160,7 @@
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	(DISABLE_IBT)
 #define DISABLED_MASK19	(DISABLE_SEV_SNP)
-#define DISABLED_MASK20	0
+#define DISABLED_MASK20	(DISABLE_ASI)
 #define DISABLED_MASK21	0
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 22)
 
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index c5979d78fdbb..21207a3e8b17 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -4,7 +4,9 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 
+#include <linux/init.h>
 #include <asm/asi.h>
+#include <asm/cmdline.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 
@@ -28,6 +30,9 @@ int asi_register_class(const char *name, const struct asi_hooks *ops)
 {
 	int i;
 
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
 	VM_BUG_ON(name == NULL);
 
 	spin_lock(&asi_class_lock);
@@ -52,6 +57,9 @@ EXPORT_SYMBOL_GPL(asi_register_class);
 
 void asi_unregister_class(int index)
 {
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	BUG_ON(!asi_index_valid(index));
 
 	spin_lock(&asi_class_lock);
@@ -63,11 +71,36 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+void __init asi_check_boottime_disable(void)
+{
+	bool enabled = IS_ENABLED(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION_DEFAULT_ON);
+	char arg[4];
+	int ret;
+
+	ret = cmdline_find_option(boot_command_line, "asi", arg, sizeof(arg));
+	if (ret == 3 && !strncmp(arg, "off", 3)) {
+		enabled = false;
+		pr_info("ASI disabled through kernel command line.\n");
+	} else if (ret == 2 && !strncmp(arg, "on", 2)) {
+		enabled = true;
+		pr_info("Ignoring asi=on param while ASI implementation is incomplete.\n");
+	} else {
+		pr_info("ASI %s by default.\n",
+			enabled ? "enabled" : "disabled");
+	}
+
+	if (enabled)
+		pr_info("ASI enablement ignored due to incomplete implementation.\n");
+}
 
 static void __asi_destroy(struct asi *asi)
 {
-	lockdep_assert_held(&asi->mm->asi_init_lock);
+	WARN_ON_ONCE(asi->ref_count <= 0);
+	if (--(asi->ref_count) > 0)
+		return;
 
+	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
+	memset(asi, 0, sizeof(struct asi));
 }
 
 int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
@@ -77,6 +110,9 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 
 	*out_asi = NULL;
 
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
 	BUG_ON(!asi_index_valid(asi_index));
 
 	asi = &mm->asi[asi_index];
@@ -121,7 +157,7 @@ void asi_destroy(struct asi *asi)
 {
 	struct mm_struct *mm;
 
-	if (!asi)
+	if (!boot_cpu_has(X86_FEATURE_ASI) || !asi)
 		return;
 
 	mm = asi->mm;
@@ -130,11 +166,7 @@ void asi_destroy(struct asi *asi)
 	 * to block concurrent asi_init calls.
 	 */
 	mutex_lock(&mm->asi_init_lock);
-	WARN_ON_ONCE(asi->ref_count <= 0);
-	if (--(asi->ref_count) == 0) {
-		free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
-		memset(asi, 0, sizeof(struct asi));
-	}
+	__asi_destroy(asi);
 	mutex_unlock(&mm->asi_init_lock);
 }
 EXPORT_SYMBOL_GPL(asi_destroy);
@@ -178,6 +210,9 @@ static noinstr void __asi_enter(void)
 
 noinstr void asi_enter(struct asi *asi)
 {
+	if (!static_asi_enabled())
+		return;
+
 	VM_WARN_ON_ONCE(!asi);
 
 	asi_set_target(current, asi);
@@ -189,8 +224,10 @@ EXPORT_SYMBOL_GPL(asi_enter);
 
 inline_or_noinstr void asi_relax(void)
 {
-	barrier();
-	asi_set_target(current, NULL);
+	if (static_asi_enabled()) {
+		barrier();
+		asi_set_target(current, NULL);
+	}
 }
 EXPORT_SYMBOL_GPL(asi_relax);
 
@@ -199,6 +236,9 @@ noinstr void asi_exit(void)
 	u64 unrestricted_cr3;
 	struct asi *asi;
 
+	if (!static_asi_enabled())
+		return;
+
 	preempt_disable_notrace();
 
 	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
@@ -229,6 +269,9 @@ EXPORT_SYMBOL_GPL(asi_exit);
 
 void asi_init_mm_state(struct mm_struct *mm)
 {
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return;
+
 	memset(mm->asi, 0, sizeof(mm->asi));
 	mutex_init(&mm->asi_init_lock);
 }
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5b06d30dee67..e2a29f6779d9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -27,6 +27,7 @@
 #include <asm/text-patching.h>
 #include <asm/memtype.h>
 #include <asm/paravirt.h>
+#include <asm/asi.h>
 
 /*
  * We need to define the tracepoints somewhere, and tlb.c
@@ -250,7 +251,7 @@ static void __init probe_page_size_mask(void)
 	__default_kernel_pte_mask = __supported_pte_mask;
 	/* Except when with PTI where the kernel is mostly non-Global: */
 	if (cpu_feature_enabled(X86_FEATURE_PTI) ||
-	    IS_ENABLED(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION))
+	    cpu_feature_enabled(X86_FEATURE_ASI))
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */
@@ -757,6 +758,7 @@ void __init init_mem_mapping(void)
 	unsigned long end;
 
 	pti_check_boottime_disable();
+	asi_check_boottime_disable();
 	probe_page_size_mask();
 	setup_pcid();
 
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 3660fc1defe8..d0a451f9d0b7 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -48,6 +48,10 @@ static inline struct asi *asi_get_target(struct task_struct *p) { return NULL; }
 
 static inline pgd_t *asi_pgd(struct asi *asi) { return NULL; }
 
+#define static_asi_enabled() false
+
+static inline void asi_check_boottime_disable(void) { }
+
 #endif  /* !_ASSEMBLY_ */
 
 #endif /* !CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */

-- 
2.45.2.993.g49e7a77208-goog


