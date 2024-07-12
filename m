Return-Path: <kvm+bounces-21552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A4C92FEFA
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BA1C1F21A5F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8199F17623E;
	Fri, 12 Jul 2024 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GK3cxh/A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E917BB23
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803695; cv=none; b=mR0UBU6tp2GbFR+rIQ6vRZ7y0THi16hvzLlK3Su0c1tXoHZ2R7HNG1fuH4cT30n+f5UszN4qwmIvkt2Gf3VhNgrupP1CvKazadEBOlRLWgrrZNsBFIBOJFl1GSj4htFr8XDxyx99AsIq1amyXdp/rys48t5geeOryetfIfnlAik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803695; c=relaxed/simple;
	bh=Pq52Q/QpIzshTMsDJJlCxL0sB1Cq1Huhd06MZnjx5cY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W+iB4qmQWJWdC6AvzLc5a/gMX5c9manL5ndXalJ2m8Np0M74flREKpzFRNqCOe7tT+08VDBnQhhsgvVUDE0CCpL+407U5m/274Nr1r82eQ6XnzM7xDuNalNBWUHjVtjDzgiu+bOS4yEgqh0PiEzOBGxPxOTJUb5CKXTOWhaFuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GK3cxh/A; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-64b2a73ad0bso35291947b3.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803693; x=1721408493; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3PoEMkqequy1KWINMIJVW/1gdvscCRasMo3UATAb/nU=;
        b=GK3cxh/AjB6FWdSPKdeITlJVfDdZPAJbSBVQoW77cvR/dS8Bhmhqi9OpFtoNebNjci
         cJlBQHihDUk6bnC203s/ZGbEQi8jGe9edxjRyDd2H1LhrSHChKx+IiLFfmmLaJu1gb2E
         v9PA78gfkQrkxc9tHHkcjI/q1YOmnJ+T1UtDpHSmDXyQY8E9lpNXE289YC02dHKfo0mf
         SCTC7Jlmx+1fRiq5w/XnMk5PSIctdCyzg4YhALk98ocMRhbYyvqRfUALdoTubyTgHNga
         yWcAvcujYw8P0EnoMmD6/iUpig3B8tIKnjaGFBTusWMYusVicrxGCe6T3skOal2P7RsL
         aY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803693; x=1721408493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3PoEMkqequy1KWINMIJVW/1gdvscCRasMo3UATAb/nU=;
        b=PTVrlgllee/MaXBEBbl7Zfkx/RceFh8Lnfpl8gyGtc0VFHZi5xR2baZdsNSkK3BZit
         GuOKUBrkn7xQcqiornr+QEX9H7Xgfp/qteWSJMK69f7SplTsnSQ1sayQNnKcLp67MQjv
         0iXS5wMjNt+X1tQtXOFTew6ZvgNhDATdxuoQWqg2QvAvPUSaZsz+0u6N3qP4CADU1J2E
         nfKHV+D8I1WTM3EZGPCnUdZwy9eOV1qulX/0k38neyFc7/J7pzwj81E4l8k4xq0LyZBY
         xkRMJ0sgKS3i2pQ2CO6/Ux9NqGdAmgXs92LhTU+rAoOn9S5fFeN5EIRUUxBLNvxTv7aj
         WRSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUosX8eIeEFq3ILUyOMOshINn6ocOvZct0A3yNOi+uYmofPfuUTpPyrWbaOyW32GuIGa3s2T+v3TS3LzTjth+1np05
X-Gm-Message-State: AOJu0YwOM71IZG+Bz0c7L0M6DiVPV1E8ElBAlrkDeNDVVNSo/7lYXKqP
	/wD7vHHiFb8JhqY6ZX/boguroB2PgX6pHjUakR1FwZRlCkZ4Xcwlh+6ABEnYL3Tn3Z/WwHeMFaZ
	PAQ6BpUcPXA==
X-Google-Smtp-Source: AGHT+IGAsyCLoTSPrJ2N91yIZy7N9XYfi0+vS82VtwZTogujGpm4xok4sUQDdphNDQnjhHnIeN3tEJvaUVoySQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:690c:488a:b0:62c:ea0b:a447 with SMTP
 id 00721157ae682-658ee69b8aemr3280537b3.2.1720803693133; Fri, 12 Jul 2024
 10:01:33 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:32 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-14-144b319a40d8@google.com>
Subject: [PATCH 14/26] mm: asi: Add basic infrastructure for global
 non-sensitive mappings
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

From: Junaid Shahid <junaids@google.com>

A pseudo-PGD is added to store global non-sensitive ASI mappings.
Actual ASI PGDs copy entries from this pseudo-PGD during asi_init().

Memory can be mapped as globally non-sensitive by calling asi_map()
with ASI_GLOBAL_NONSENSITIVE.

Page tables allocated for global non-sensitive mappings are never
freed.

While a previous version used init_mm.asi[0] as the special global
nonsensitive domain, here we have tried to avoid special-casing index 0.
So now we have a special global variable for that. For this to work we
need to make sure that nobody assumes that asi is a member of
asi->mm->asi (also that nobody assumes a struct asi is embedded in a
struct mm - but that seems like a weird assumption to make anyway, when
you already have the .mm pointer). I currently believe that this is
worth it for the reduced level of magic in the code.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h |  3 +++
 arch/x86/mm/asi.c          | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c      | 25 ++++++++++++++++---------
 arch/x86/mm/mm_internal.h  |  3 +++
 include/asm-generic/asi.h  |  2 ++
 5 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 9aad843eb6df..2d86a5c17f2b 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -78,6 +78,9 @@
  */
 #define ASI_MAX_NUM		((1 << ASI_MAX_NUM_ORDER) - 1)
 
+extern struct asi __asi_global_nonsensitive;
+#define ASI_GLOBAL_NONSENSITIVE	(&__asi_global_nonsensitive)
+
 struct asi_hooks {
 	/*
 	 * Both of these functions MUST be idempotent and re-entrant. They will
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index e43b206450ad..807d51497f43 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -11,6 +11,7 @@
 #include <asm/mmu_context.h>
 #include <asm/traps.h>
 
+#include "mm_internal.h"
 #include "../../../mm/internal.h"
 
 static struct asi_class asi_class[ASI_MAX_NUM];
@@ -19,6 +20,13 @@ static DEFINE_SPINLOCK(asi_class_lock);
 DEFINE_PER_CPU_ALIGNED(struct asi *, curr_asi);
 EXPORT_SYMBOL(curr_asi);
 
+static __aligned(PAGE_SIZE) pgd_t asi_global_nonsensitive_pgd[PTRS_PER_PGD];
+
+struct asi __asi_global_nonsensitive = {
+	.pgd = asi_global_nonsensitive_pgd,
+	.mm = &init_mm,
+};
+
 static inline bool asi_class_registered(int index)
 {
 	return asi_class[index].name != NULL;
@@ -154,6 +162,31 @@ void __init asi_check_boottime_disable(void)
 		pr_info("ASI enablement ignored due to incomplete implementation.\n");
 }
 
+static int __init asi_global_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_ASI))
+		return 0;
+
+	/*
+	 * Lower-level pagetables for global nonsensitive mappings are shared,
+	 * but the PGD has to be copied into each domain during asi_init. To
+	 * avoid needing to synchronize new mappings into pre-existing domains
+	 * we just pre-allocate all of the relevant level N-1 entries so that
+	 * the global nonsensitive PGD already has pointers that can be copied
+	 * when new domains get asi_init()ed.
+	 */
+	preallocate_sub_pgd_pages(asi_global_nonsensitive_pgd,
+				  PAGE_OFFSET,
+				  PAGE_OFFSET + PFN_PHYS(max_pfn) - 1,
+				  "ASI Global Non-sensitive direct map");
+	preallocate_sub_pgd_pages(asi_global_nonsensitive_pgd,
+				  VMALLOC_START, VMALLOC_END,
+				  "ASI Global Non-sensitive vmalloc");
+
+	return 0;
+}
+subsys_initcall(asi_global_init)
+
 static void __asi_destroy(struct asi *asi)
 {
 	WARN_ON_ONCE(asi->ref_count <= 0);
@@ -168,6 +201,7 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 {
 	struct asi *asi;
 	int err = 0;
+	uint i;
 
 	*out_asi = NULL;
 
@@ -203,6 +237,9 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 	asi->mm = mm;
 	asi->index = asi_index;
 
+	for (i = KERNEL_PGD_BOUNDARY; i < PTRS_PER_PGD; i++)
+		set_pgd(asi->pgd + i, asi_global_nonsensitive_pgd[i]);
+
 exit_unlock:
 	if (err)
 		__asi_destroy(asi);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7e177856ee4f..f67f4637357c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1278,18 +1278,15 @@ static void __init register_page_bootmem_info(void)
 #endif
 }
 
-/*
- * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
- * Only the level which needs to be synchronized between all page-tables is
- * allocated because the synchronization can be expensive.
- */
-static void __init preallocate_vmalloc_pages(void)
+/* Initialize empty pagetables at the level below PGD.  */
+void __init preallocate_sub_pgd_pages(pgd_t *pgd_table, ulong start,
+				      ulong end, const char *name)
 {
 	unsigned long addr;
 	const char *lvl;
 
-	for (addr = VMALLOC_START; addr <= VMEMORY_END; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
-		pgd_t *pgd = pgd_offset_k(addr);
+	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
+		pgd_t *pgd = pgd_offset_pgd(pgd_table, addr);
 		p4d_t *p4d;
 		pud_t *pud;
 
@@ -1325,7 +1322,17 @@ static void __init preallocate_vmalloc_pages(void)
 	 * The pages have to be there now or they will be missing in
 	 * process page-tables later.
 	 */
-	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
+	panic("Failed to pre-allocate %s pages for %s area\n", lvl, name);
+}
+
+/*
+ * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
+ * Only the level which needs to be synchronized between all page-tables is
+ * allocated because the synchronization can be expensive.
+ */
+static void __init preallocate_vmalloc_pages(void)
+{
+	preallocate_sub_pgd_pages(init_mm.pgd, VMALLOC_START, VMEMORY_END, "vmalloc");
 }
 
 void __init mem_init(void)
diff --git a/arch/x86/mm/mm_internal.h b/arch/x86/mm/mm_internal.h
index 3f37b5c80bb3..1203a977edcd 100644
--- a/arch/x86/mm/mm_internal.h
+++ b/arch/x86/mm/mm_internal.h
@@ -25,4 +25,7 @@ void update_cache_mode_entry(unsigned entry, enum page_cache_mode cache);
 
 extern unsigned long tlb_single_page_flush_ceiling;
 
+extern void preallocate_sub_pgd_pages(pgd_t *pgd_table, ulong start,
+				      ulong end, const char *name);
+
 #endif	/* __X86_MM_INTERNAL_H */
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
index 3956f995fe6a..fd5a302e0e09 100644
--- a/include/asm-generic/asi.h
+++ b/include/asm-generic/asi.h
@@ -9,6 +9,8 @@
 #define ASI_MAX_NUM_ORDER		0
 #define ASI_MAX_NUM			0
 
+#define ASI_GLOBAL_NONSENSITIVE		NULL
+
 #ifndef _ASSEMBLY_
 
 struct asi_hooks {};

-- 
2.45.2.993.g49e7a77208-goog


