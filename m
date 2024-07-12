Return-Path: <kvm+bounces-21548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB13892FEF2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DE9E1F213C4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632CA17B43D;
	Fri, 12 Jul 2024 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZbsFT+f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E017B420
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803683; cv=none; b=VeynBTOGs6c0ESCdSJ/cadcal3GQdSLe8DoQ8g4Wh5cTDRE5LSOQ+V2ed4g98gxG8yb/54BfIxlfVbJftoyxwg3sFyhoQ65FRz1464RnsQ/DpT05aXZaIKze3IzhCjA9/MqouDStkpqoCcwdstfBoubR4GG/MdycqAi/IDZeR0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803683; c=relaxed/simple;
	bh=JV+LctEmZ8RVScnNvPDQmSmCQdrPRydUorU75kWraZk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p9wXEem6RUzMsTgdvPtf3jaUrm/+tCjy3tkE8t743AFAqnrepWsL/xE7ak4rRAWRLKbzpj9VNd1f+BfSHJ4Tvs2jO/kHa1XjbXMR0oAKyc06fEFR7o7a1Ji6PR37OymWsO24hZSGuWIMJQKe2URQFYF8xeCsiqKeNF0ZRdz00qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZbsFT+f; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-367960f4673so1771430f8f.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803680; x=1721408480; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jms+qnUoGWR3Ok8D5PSRh1HvZeNFLLNfdQwhqdA9AN8=;
        b=FZbsFT+fMDAuUgio48QK61G8Yxlx/8W5pbGp04kifviTcGbOfXubWv+6lPj7XuuRIm
         JoGdvNbW7IXh54dcdDR+0Gx8G0PABCk6RdhxkKcKyNzcLq2s+baZ67N6sT0u07UaefZt
         i8A//X66F5F9HiH7RkFxhKM4y3gnO8h99dP5blKtBPczwkXB2gd9BvgY7x955J44ueCF
         nz/W+DYg3rXxwQAvJPPCdh3QEIefThWUbVRRRJr7fN5vwjmNG5+9ayeZPc08Tc4i/tr6
         /+Q8LnNcd9K7msMIe1kBVfg9P/U3Lg6zC00FNdq9vuRHaAGGhvnuedXt8QX29oWTTNB5
         Cz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803680; x=1721408480;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jms+qnUoGWR3Ok8D5PSRh1HvZeNFLLNfdQwhqdA9AN8=;
        b=GBT6k5nLKMbHKhrd7AL9a8sNzIxSOZ1wTho0hzG/alJX/Z5lCZ2+0/bXVAXXClixQJ
         bEYWBkab+5fYUaCPzIdbrt0AL2hFCcLVtHa1yhPD/ei82dPzrC5coKsKa4KqmaxwQaq4
         JyKYjCPkRnTmFusq/IcKaYOwzeQe4rpvEzw5aQ5LxagfcTuqdrzmomje8EPRU2RQ6rq1
         aOk7NOXOxnI4QdiNSXnin6R9dCQThtdJd/FfNIIupocLO5PPSFEaBPeES97+hBCn24YX
         rJe6fOWIT8Nsk2a2KB8FymMSG3IKF3Il+jYOTYhRzv08MSN5I0mVUmCZeFe/YQuMB5hp
         VXYA==
X-Forwarded-Encrypted: i=1; AJvYcCWp53pFDk9eHyoKQGzL0wzPDCdJF1uigAYR6CNPodRli9vK7z24mwikK2m/cjHuhY+0FdNm496FiaQ+wzfLNaLSByZW
X-Gm-Message-State: AOJu0YykH+tSDDZtxvvtKKADJEoG6mM0eYcXYuGv6vh0fC4M4nKY8mXz
	5O4KlZR5O2cjMyYNeddzEPleKaJN+VflEtoikzbrpvmed6AmoNwnlgnGdIOvrg1xD2hUubWkCNy
	Q4MXY84p7Ag==
X-Google-Smtp-Source: AGHT+IGisRm/zH5xPuc3vZntkMct9zRaY/l9dILlFDVOJcrKy+wGrjnqUwhX4l9eAthBD2p9mDlo+nx2x2+a6A==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a7b:cb11:0:b0:426:670b:20bf with SMTP id
 5b1f17b1804b1-427a0a24cb6mr168765e9.0.1720803680269; Fri, 12 Jul 2024
 10:01:20 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:28 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-10-144b319a40d8@google.com>
Subject: [PATCH 10/26] mm: asi: Avoid warning from NMI userspace accesses in
 ASI context
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

nmi_uaccess_okay() emits a warning if current CR3 != mm->pgd.
Limit the warning to only when ASI is not active.

Co-developed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/tlb.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 02f73a71d4ea..e80cd67a5239 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -1326,6 +1326,24 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 	put_cpu();
 }
 
+static inline bool cr3_matches_current_mm(void)
+{
+	struct asi *asi = asi_get_current();
+	pgd_t *cr3_pgd;
+
+	/*
+	 * Prevent read_cr3_pa -> [NMI, asi_exit] -> asi_get_current,
+	 * otherwise we might find CR3 pointing to the ASI PGD but not
+	 * find a current ASI domain.
+	 */
+	barrier();
+	cr3_pgd = __va(read_cr3_pa());
+
+	if (cr3_pgd == current->mm->pgd)
+		return true;
+	return asi && (cr3_pgd == asi_pgd(asi));
+}
+
 /*
  * Blindly accessing user memory from NMI context can be dangerous
  * if we're in the middle of switching the current user task or
@@ -1341,10 +1359,10 @@ bool nmi_uaccess_okay(void)
 	VM_WARN_ON_ONCE(!loaded_mm);
 
 	/*
-	 * The condition we want to check is
-	 * current_mm->pgd == __va(read_cr3_pa()).  This may be slow, though,
-	 * if we're running in a VM with shadow paging, and nmi_uaccess_okay()
-	 * is supposed to be reasonably fast.
+	 * The condition we want to check that CR3 points to either
+	 * current_mm->pgd or an appropriate ASI PGD. Reading CR3 may be slow,
+	 * though, if we're running in a VM with shadow paging, and
+	 * nmi_uaccess_okay() is supposed to be reasonably fast.
 	 *
 	 * Instead, we check the almost equivalent but somewhat conservative
 	 * condition below, and we rely on the fact that switch_mm_irqs_off()
@@ -1353,7 +1371,7 @@ bool nmi_uaccess_okay(void)
 	if (loaded_mm != current_mm)
 		return false;
 
-	VM_WARN_ON_ONCE(current_mm->pgd != __va(read_cr3_pa()));
+	VM_WARN_ON_ONCE(!cr3_matches_current_mm());
 
 	return true;
 }

-- 
2.45.2.993.g49e7a77208-goog


