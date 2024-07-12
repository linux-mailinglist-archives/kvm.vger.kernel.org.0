Return-Path: <kvm+bounces-21546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04ABB92FEEE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2875A1C22074
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1877217A939;
	Fri, 12 Jul 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pk/WG/fz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1026176AD9
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803677; cv=none; b=fD+BTBmfakk+n0mV+zyU6MUMGeu9THpm6gvPQIhntRoNeFRm5YnRGamHoul36OUAU9XLpzqu6XgyYVWstAvfoA7u0oA2e5g9si9QbV9bHcYrQNSPyd6spy1t/QoSwsTsJXM7SfrCZ2i1MW52ghX+abJUI4O25gm8zOPx6ZBGPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803677; c=relaxed/simple;
	bh=ysS/sHsfGcOywr5ecIDWgWosegBwRS/ro8phsMXIPz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tiZcKxcmVAjFRWHT52DSjVONReum1VwbSNV9z/xwXzZwXalp981/OY+IpNSs+iycZTr32U93vR50Axd51QulHT7goaViDJHdI1iy+fgYiDemeHXHPjQDL+mx7LYiIuaIulmMQlopOKlP1LIR4XOX9pgjLgPE0VoLNIMMvlGY3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pk/WG/fz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-654c14abdcfso32844207b3.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803675; x=1721408475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IU+0QFZ2g2My69wAuJPkncJIr3fDXfYxT6Ca6fNVeD8=;
        b=pk/WG/fz6s6/h2pPP3hkwdrfCZOpJr0JqEWwtHGKTm6ffeauyv1fxP7yiu80GgzWYH
         Dlg1qxyrCru9YHA2HRYfnuSATsDsIr6qYPzf7CBXsAdPfHXOpTk++C4Ay5lfcYQqmRXC
         jhgNUS0pWhh9/BMP8HOJEASo+bQRFHbR81Afjdy77g0YLD8v9KYDAuotCAgqVS1sDvrh
         QMHIhLfP6BSoRrmy8z141exdP3BZ44P/4WD1Q0Gd6shYlDKdoSvhXE60ZOAlvjlG7cAM
         T+9fWdTxOQkLL/ak3CsoJZrKFvPTlRoe84UsWBZUJyG2EfHQfGNKRtLwAU0XpY7xhHP7
         6kZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803675; x=1721408475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IU+0QFZ2g2My69wAuJPkncJIr3fDXfYxT6Ca6fNVeD8=;
        b=vOIHjHStdmTzWI+iKjgU682sQSZuYnODhghL6qoGS7FA6kiUikVShRNAmTRO8FPFzL
         3wgb5N4x60mVjXwcJxI6UYYiZWTX2NUcWy7Ksw816/jwMa1RwCRM4aguw/24oIU7XEYM
         QHfZC3vE5cUl+i6/WFqosyRyreBB2h8pkt29eCI6ymaPbgBYa+hBBDBNmIsmexJzzBKE
         9TxFbMByHqSiuCmkvB7Y1lZDOsf0Rgef5bgIjHJRJvo8mWkMjRlMCdRh0BjbMXSQ4eAi
         XeCriFWRAp2+gvr7IoA+SA9ydmvrw2yJowate+QUULztQkw9dM/+xmKLp1jRI+8XNT46
         xbzw==
X-Forwarded-Encrypted: i=1; AJvYcCX1b1gdtBESYXVNBrLLqOTg/1qR2ajbXCkoOprvmRtx6vj4I+MzOZTraI5IbmGpgoJAnSOhdL5z2QBaCG+w/5TwOwI+
X-Gm-Message-State: AOJu0YxNNwnm4KunFqonCiRPe/0lRqT+il1WkNVDi2Qo4I9bLCrKbStD
	zV4OlVDt146tmy3yohEzKnPoBsqnbnPnlWNnJsU1kO1AFM7w/s8tRKJnraz3+2LKYVqPpjQomBn
	YiAgsjzwkqQ==
X-Google-Smtp-Source: AGHT+IH090AhnVnRaBqnnakPZ4/V5j0nTOpLdhxmJg4znTZivgjhg0KK45kar3tFbJqN9PhohJA5PmDXL/BkUA==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a25:945:0:b0:e05:7113:920c with SMTP id
 3f1490d57ef6-e058a6cfb8dmr11142276.6.1720803674689; Fri, 12 Jul 2024 10:01:14
 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:26 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-8-144b319a40d8@google.com>
Subject: [PATCH 08/26] mm: asi: Use separate PCIDs for restricted address spaces
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

Each restricted address space is assigned a separate PCID. Since
currently only one ASI instance per-class exists for a given process,
the PCID is just derived from the class index.

This commit only sets the appropriate PCID when switching CR3, but does
not actually use the NOFLUSH bit. That will be done by later patches.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/asi.h      | 10 +++++++++-
 arch/x86/include/asm/tlbflush.h |  3 +++
 arch/x86/mm/asi.c               |  7 ++++---
 arch/x86/mm/tlb.c               | 44 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index df34a8c0560b..1a19a925300c 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -69,7 +69,14 @@
 #define static_asi_enabled() cpu_feature_enabled(X86_FEATURE_ASI)
 
 #define ASI_MAX_NUM_ORDER	2
-#define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
+/*
+ * We include an ASI identifier in the higher bits of PCID to use
+ * different PCID for restricted ASIs from non-restricted ASIs (see asi_pcid).
+ * The ASI identifier we use for this is asi_index + 1, as asi_index
+ * starts from 0. The -1 below for ASI_MAX_NUM comes from this PCID
+ * space availability.
+ */
+#define ASI_MAX_NUM		((1 << ASI_MAX_NUM_ORDER) - 1)
 
 struct asi_hooks {
 	/*
@@ -101,6 +108,7 @@ struct asi {
 	struct asi_class *class;
 	struct mm_struct *mm;
 	int64_t ref_count;
+	u16 index;
 };
 
 DECLARE_PER_CPU_ALIGNED(struct asi *, curr_asi);
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index ed847567b25d..3605f6b99da7 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -392,6 +392,9 @@ static inline bool huge_pmd_needs_flush(pmd_t oldpmd, pmd_t newpmd)
 #define huge_pmd_needs_flush huge_pmd_needs_flush
 
 unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam);
+unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid, unsigned long lam, bool noflush);
+
+u16 asi_pcid(struct asi *asi, u16 asid);
 
 #ifdef CONFIG_ADDRESS_MASKING
 static inline  u64 tlbstate_lam_cr3_mask(void)
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 2cd8e93a4415..0ba156f879d3 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -140,6 +140,7 @@ int asi_init(struct mm_struct *mm, int asi_index, struct asi **out_asi)
 
 	asi->class = &asi_class[asi_index];
 	asi->mm = mm;
+	asi->index = asi_index;
 
 exit_unlock:
 	if (err)
@@ -174,6 +175,7 @@ EXPORT_SYMBOL_GPL(asi_destroy);
 noinstr void __asi_enter(void)
 {
 	u64 asi_cr3;
+	u16 pcid;
 	struct asi *target = asi_get_target(current);
 
 	/*
@@ -200,9 +202,8 @@ noinstr void __asi_enter(void)
 	 */
 	this_cpu_write(curr_asi, target);
 
-	asi_cr3 = build_cr3(target->pgd,
-			    this_cpu_read(cpu_tlbstate.loaded_mm_asid),
-			    tlbstate_lam_cr3_mask());
+	pcid = asi_pcid(target, this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	asi_cr3 = build_cr3_pcid(target->pgd, pcid, tlbstate_lam_cr3_mask(), false);
 	write_cr3(asi_cr3);
 
 	if (target->class->ops.post_asi_enter)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 9a5afeac9654..34d61b56d33f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -98,7 +98,12 @@
 # define PTI_CONSUMED_PCID_BITS	0
 #endif
 
-#define CR3_AVAIL_PCID_BITS (X86_CR3_PCID_BITS - PTI_CONSUMED_PCID_BITS)
+#define ASI_CONSUMED_PCID_BITS ASI_MAX_NUM_ORDER
+#define ASI_PCID_BITS_SHIFT CR3_AVAIL_PCID_BITS
+#define CR3_AVAIL_PCID_BITS (X86_CR3_PCID_BITS - PTI_CONSUMED_PCID_BITS - \
+			     ASI_CONSUMED_PCID_BITS)
+
+static_assert(BIT(CR3_AVAIL_PCID_BITS) > TLB_NR_DYN_ASIDS);
 
 /*
  * ASIDs are zero-based: 0->MAX_AVAIL_ASID are valid.  -1 below to account
@@ -155,18 +160,23 @@ static inline u16 user_pcid(u16 asid)
 	return ret;
 }
 
+static inline unsigned long __build_cr3(pgd_t *pgd, u16 pcid, unsigned long lam)
+{
+	return __sme_pa_nodebug(pgd) | pcid | lam;
+}
+
 inline_or_noinstr unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
 {
-	unsigned long cr3 = __sme_pa_nodebug(pgd) | lam;
+	u16 pcid = 0;
 
 	if (static_cpu_has(X86_FEATURE_PCID)) {
 		VM_WARN_ON_ONCE(asid > MAX_ASID_AVAILABLE);
-		cr3 |= kern_pcid(asid);
+		pcid = kern_pcid(asid);
 	} else {
 		VM_WARN_ON_ONCE(asid != 0);
 	}
 
-	return cr3;
+	return __build_cr3(pgd, pcid, lam);
 }
 
 static inline unsigned long build_cr3_noflush(pgd_t *pgd, u16 asid,
@@ -181,6 +191,19 @@ static inline unsigned long build_cr3_noflush(pgd_t *pgd, u16 asid,
 	return build_cr3(pgd, asid, lam) | CR3_NOFLUSH;
 }
 
+inline_or_noinstr unsigned long build_cr3_pcid(pgd_t *pgd, u16 pcid,
+					       unsigned long lam, bool noflush)
+{
+	u64 noflush_bit = 0;
+
+	if (!static_cpu_has(X86_FEATURE_PCID))
+		pcid = 0;
+	else if (noflush)
+		noflush_bit = CR3_NOFLUSH;
+
+	return __build_cr3(pgd, pcid, lam) | noflush_bit;
+}
+
 /*
  * We get here when we do something requiring a TLB invalidation
  * but could not go invalidate all of the contexts.  We do the
@@ -995,6 +1018,19 @@ static void put_flush_tlb_info(void)
 #endif
 }
 
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+
+inline_or_noinstr u16 asi_pcid(struct asi *asi, u16 asid)
+{
+	return kern_pcid(asid) | ((asi->index + 1) << ASI_PCID_BITS_SHIFT);
+}
+
+#else /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
+u16 asi_pcid(struct asi *asi, u16 asid) { return kern_pcid(asid); }
+
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned int stride_shift,
 				bool freed_tables)

-- 
2.45.2.993.g49e7a77208-goog


