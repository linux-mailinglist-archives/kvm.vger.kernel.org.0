Return-Path: <kvm+bounces-21555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00A2A92FF00
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C390285254
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5910917C9E7;
	Fri, 12 Jul 2024 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="apyLtnmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFEA17BB1E
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803704; cv=none; b=sSgkje4BCtT1y0lSs07nB/cDY6FygkmIYWrwvR0IRYOCsJSZkNS/XL07vH/+W9NenWHc3/aPaXoTQQMuNtJH3wu2kV7AHiAk+unxduaswIM53Zn1M3nse3tJ3W+DhcifTyme0Zh50j5QBT860SAjW9caCZ37vw2pXbP3wuOFzNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803704; c=relaxed/simple;
	bh=OoDGhAtZINf/eC54ISE3Likkp4nTLCyVsj6xWH4/LYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uYmj0WCOs/HTDjJDX2R9Pz/G3M57lCUF0+ZAaY8LDpCw32fqe1k+jumaI3Gxh/caIu8hYDjJSyuHsBn1UwOAY6Hv9XcXW3ZVyU0BBGhdhuVQ6RB3i7s0NoK1yf99PEY7abRsqXPkwUeI4uvoLQPaSfWhF/gD7PVMMFyH4hJZJMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=apyLtnmc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4266fbae4c6so15469785e9.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803701; x=1721408501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mWHMoCzbupyPLn4HJqmbJTZdF2QBYUbInE64x2NA2rE=;
        b=apyLtnmcUPymzIKsAD/MUoC0Z6tI0gArThPFKcpmi+m1mUp1Fen3vbEop1n6yCY5ov
         CgDn/IXU7zCeOjFteTKfL/NX0bF0H9cdN1uQM0Up4eVTSj+7sZSuCG9QxZiNo0iTNbeK
         zmLZY/fziBqYJjwKvj0Oc88kej3hIaYvoDIRursDi8NipPmWPqrHNjtYr5NgaWCMdp+l
         PCqJF8NiZwmiyqhhh1Fu0Tqrrolg+3zjF9tdMnXpV0rBNgaHhCWgOLXzOU25FRaMXb/3
         MLExLGtSZ2iEMxJlqlEeo1fNQMwVT7L21TA3DxZPLfWGIBGdQamIaVU9nwAq6kGWL8i0
         rm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803701; x=1721408501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mWHMoCzbupyPLn4HJqmbJTZdF2QBYUbInE64x2NA2rE=;
        b=T2/bM6oxfTGxGPfjIb06kBVSJBcYHpuvlDF1/fzzxqgjaOa4plUGiB2FI0rDjtAj0G
         /TnfD15TVhDMnp85nPacCCjAt/6SFJJcXrFNxMWkBQxvEVqZdlOuF5pMWIoDXtO1cCTJ
         xVe1OyCJ9vjHEYnN5yPFAjiMOq79WRMBBLpRGkZBhLh6zJibXKiGl1OpmjJT9ZbC0C2N
         YIEyBioTd10QTxWuArRn4+/ACSAjfFDvyVvLSZF4Bj84j08W1CPygHz0u9wvDhNOnLrD
         opTzcmqX43lUfYUlvBtDIAPcYcVSuvic2O/k4QpGedlNReY1kF/5qDmwD81vXh79xnLi
         MxXg==
X-Forwarded-Encrypted: i=1; AJvYcCXqi/4QJzZxc87MFbI9W634X3pbpiHvpoouDt3lZy99QTrLMoShumeZue4hX36aZVSvw4rjLEZ8TD8qdLRHpXaHRL0Z
X-Gm-Message-State: AOJu0Ywi7fWrAMKP7+ZL11D5Xu5K0nt474vG3cyYt4M6/H12tcizGxuv
	cd32BJAfbHr/aSPG2tmZtrXQvNE7hCtxxVNJv1aHG5Sb/NaqOuiuGApUpix7C7ssJVPebrHz6LZ
	4TnGF8hJtrw==
X-Google-Smtp-Source: AGHT+IH7bbw/Dn5jSbbHkSsXS63XrNwSXZ9nYhS09PC8vYQaS4DPRI1dYsfdXRcOP1EzG0hCXTQisDlHIVSzOg==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:4f0e:b0:426:6a73:fb5f with SMTP
 id 5b1f17b1804b1-426708f9ab5mr1905165e9.7.1720803701319; Fri, 12 Jul 2024
 10:01:41 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:35 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-17-144b319a40d8@google.com>
Subject: [PATCH 17/26] mm: asi: Map kernel text and static data as nonsensitive
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

Basically we need to map the kernel code and all its static variables.
Per-CPU variables need to be treated specially as described in the
comments. The cpu_entry_area is similar - this needs to be
nonsensitive so that the CPU can access the GDT etc when handling
a page fault.

Under 5-level paging, most of the kernel memory comes under a single PGD
entry (see Documentation/x86/x86_64/mm.rst. Basically, the mapping is
for this big region is the same as under 4-level, just wrapped in an
outer PGD entry). For that region, the "clone" logic is moved down one
step of the paging hierarchy.

Note that the p4d_alloc in asi_clone_p4d won't actually be used in
practice; the relevant PGD entry will always have been populated by
prior asi_map calls so this code would "work" if we just wrote
p4d_offset (but asi_clone_p4d would be broken if viewed in isolation).

The vmemmap area is not under this single PGD, it has its own 2-PGD
area, so we still use asi_clone_pgd for that one.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/asi.c                 | 106 +++++++++++++++++++++++++++++++++++++-
 include/asm-generic/vmlinux.lds.h |  11 ++++
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 6e106f25abbb..891b8d351df8 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -7,8 +7,8 @@
 #include <linux/init.h>
 #include <linux/pgtable.h>
 
-#include <asm/asi.h>
 #include <asm/cmdline.h>
+#include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/traps.h>
@@ -184,8 +184,68 @@ void __init asi_check_boottime_disable(void)
 		pr_info("ASI enablement ignored due to incomplete implementation.\n");
 }
 
+/*
+ * Map data by sharing sub-PGD pagetables with the unrestricted mapping. This is
+ * more efficient than asi_map, but only works when you know the whole top-level
+ * page needs to be mapped in the restricted tables. Note that the size of the
+ * mappings this creates differs between 4 and 5-level paging.
+ */
+static void asi_clone_pgd(pgd_t *dst_table, pgd_t *src_table, size_t addr)
+{
+	pgd_t *src = pgd_offset_pgd(src_table, addr);
+	pgd_t *dst = pgd_offset_pgd(dst_table, addr);
+
+	if (!pgd_val(*dst))
+		set_pgd(dst, *src);
+	else
+		WARN_ON_ONCE(pgd_val(*dst) != pgd_val(*src));
+}
+
+/*
+ * For 4-level paging this is exactly the same as asi_clone_pgd. For 5-level
+ * paging it clones one level lower. So this always creates a mapping of the
+ * same size.
+ */
+static void asi_clone_p4d(pgd_t *dst_table, pgd_t *src_table, size_t addr)
+{
+	pgd_t *src_pgd = pgd_offset_pgd(src_table, addr);
+	pgd_t *dst_pgd = pgd_offset_pgd(dst_table, addr);
+	p4d_t *src_p4d = p4d_alloc(&init_mm, src_pgd, addr);
+	p4d_t *dst_p4d = p4d_alloc(&init_mm, dst_pgd, addr);
+
+	if (!p4d_val(*dst_p4d))
+		set_p4d(dst_p4d, *src_p4d);
+	else
+		WARN_ON_ONCE(p4d_val(*dst_p4d) != p4d_val(*src_p4d));
+}
+
+/*
+ * percpu_addr is where the linker put the percpu variable. asi_map_percpu finds
+ * the place where the percpu allocator copied the data during boot.
+ *
+ * This is necessary even when the page allocator defaults to
+ * global-nonsensitive, because the percpu allocator uses the memblock allocator
+ * for early allocations.
+ */
+static int asi_map_percpu(struct asi *asi, void *percpu_addr, size_t len)
+{
+	int cpu, err;
+	void *ptr;
+
+	for_each_possible_cpu(cpu) {
+		ptr = per_cpu_ptr(percpu_addr, cpu);
+		err = asi_map(asi, ptr, len);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int __init asi_global_init(void)
 {
+	int err;
+
 	if (!boot_cpu_has(X86_FEATURE_ASI))
 		return 0;
 
@@ -205,6 +265,46 @@ static int __init asi_global_init(void)
 				  VMALLOC_START, VMALLOC_END,
 				  "ASI Global Non-sensitive vmalloc");
 
+	/* Map all kernel text and static data */
+	err = asi_map(ASI_GLOBAL_NONSENSITIVE, (void *)__START_KERNEL,
+		      (size_t)_end - __START_KERNEL);
+	if (WARN_ON(err))
+		return err;
+	err = asi_map(ASI_GLOBAL_NONSENSITIVE, (void *)FIXADDR_START,
+		      FIXADDR_SIZE);
+	if (WARN_ON(err))
+		return err;
+	/* Map all static percpu data */
+	err = asi_map_percpu(
+		ASI_GLOBAL_NONSENSITIVE,
+		__per_cpu_start, __per_cpu_end - __per_cpu_start);
+	if (WARN_ON(err))
+		return err;
+
+	/*
+	 * The next areas are mapped using shared sub-P4D paging structures
+	 * (asi_clone_p4d instead of asi_map), since we know the whole P4D will
+	 * be mapped.
+	 */
+	asi_clone_p4d(asi_global_nonsensitive_pgd, init_mm.pgd,
+		      CPU_ENTRY_AREA_BASE);
+#ifdef CONFIG_X86_ESPFIX64
+	asi_clone_p4d(asi_global_nonsensitive_pgd, init_mm.pgd,
+		      ESPFIX_BASE_ADDR);
+#endif
+	/*
+	 * The vmemmap area actually _must_ be cloned via shared paging
+	 * structures, since mappings can potentially change dynamically when
+	 * hugetlbfs pages are created or broken down.
+	 *
+	 * We always clone 2 PGDs, this is a corrolary of the sizes of struct
+	 * page, a page, and the physical address space.
+	 */
+	WARN_ON(sizeof(struct page) * MAXMEM / PAGE_SIZE != 2 * (1UL << PGDIR_SHIFT));
+	asi_clone_pgd(asi_global_nonsensitive_pgd, init_mm.pgd, VMEMMAP_START);
+	asi_clone_pgd(asi_global_nonsensitive_pgd, init_mm.pgd,
+		      VMEMMAP_START + (1UL << PGDIR_SHIFT));
+
 	return 0;
 }
 subsys_initcall(asi_global_init)
@@ -482,6 +582,10 @@ static bool follow_physaddr(
  * Map the given range into the ASI page tables. The source of the mapping is
  * the regular unrestricted page tables. Can be used to map any kernel memory.
  *
+ * In contrast to some internal ASI logic (asi_clone_pgd and asi_clone_p4d) this
+ * never shares pagetables between restricted and unrestricted address spaces,
+ * instead it creates wholly new equivalent mappings.
+ *
  * The caller MUST ensure that the source mapping will not change during this
  * function. For dynamic kernel memory, this is generally ensured by mapping the
  * memory within the allocator.
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f7749d0f2562..4eca33d62950 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1021,6 +1021,16 @@
 	COMMON_DISCARDS							\
 	}
 
+/*
+ * ASI maps certain sections with certain sensitivity levels, so they need to
+ * have a page-aligned size.
+ */
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define ASI_ALIGN() ALIGN(PAGE_SIZE)
+#else
+#define ASI_ALIGN() .
+#endif
+
 /**
  * PERCPU_INPUT - the percpu input sections
  * @cacheline: cacheline size
@@ -1042,6 +1052,7 @@
 	*(.data..percpu)						\
 	*(.data..percpu..shared_aligned)				\
 	PERCPU_DECRYPTED_SECTION					\
+	. = ASI_ALIGN();						\
 	__per_cpu_end = .;
 
 /**

-- 
2.45.2.993.g49e7a77208-goog


