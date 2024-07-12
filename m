Return-Path: <kvm+bounces-21562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2579C92FF0E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54BC51C22CF4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187C817DE19;
	Fri, 12 Jul 2024 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mntdEWTU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA11517DA3A
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803725; cv=none; b=HXPwwn3NShHGzbtpgcbLCY0LHoZe/En3WqnsBmlzFK4RphSuqZLU2+RDWAPpnM/C2Sp8EKDBI4Wb1GlMqgp/C+Yznb6rCYISYBhBzW71scCtTJufvygVKjieG6Gt15nl+Xc7N2QK3OPWQApR+qSo47NtIGhjj2rBs/ZG/FS7UMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803725; c=relaxed/simple;
	bh=NZYj7MLt+2lxNLGEUfzWJwn+jAe/yUlHRhssEDgRpv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WLnBDeujOuQP0v6MgJ3huYINjzgvn3fFaPrZc9L10LPyFhQqjgx+dpHlkG+qBPZGxvieNjvBNf1v07BhE+ElgDTit8i7apUUPAn1of1atJzr5Jlg5GiOEZPoIzR0ufqPz/WafBRR8Xx2OJEikgJlwVNVBByfgtOfO0le4G5hkes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mntdEWTU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6525230ceeaso40872967b3.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803723; x=1721408523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2i/EY2B7r1Db+9uC+ppZJ+s/pV+Uwv0UgdTvi6uATis=;
        b=mntdEWTUwpsEtrLjZI18CSEwPWTr6TECPUpfek0CIR0nTCtb36AYk5CGBjD9Rowu8u
         CLyq9Qs1ztU1IVVyYhYsMmLTkP0BRCcnV6xoAOnJxYY3eR2DRCTWi2VlBNlwmEndZTV8
         DIgBSpn1UPIw8ISEusfy+OIHr644WXt4Z0xxfQDmUJbFA2irLXzaw/8nr2MoUPvTBI/b
         jnzgzPD2GxElJ1yokguoNcgToUy0LZ8VKpvlP37RlF2adZyzxu5WkYgOj0o+9Nyk2DJM
         1X5uz4HZBimhBzu9KB4gZqOsnk3bLq9Dx1UsnCvTV/G0ZJp9CSBJORZsUyqypBUnoxUa
         p9KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803723; x=1721408523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2i/EY2B7r1Db+9uC+ppZJ+s/pV+Uwv0UgdTvi6uATis=;
        b=iln48fyvVWVsl8iNyR1rybcLxjSVhklvOI531/RdxtRDH+A9DK6RaLFFF8tCjtytpX
         VM87e4h5sRXJ9tEvKpHc++DCWcq0hbuAnZyLwOA47MCbgQgGiqhhekzuGO278fdriGcJ
         KmROZQe6sPnvnYCZ+rsotw8Nk8dNo56Pz8erPcpInULvNQzekD/Y035BsdialAS9sjr2
         4KrfGx0+uUmjPOl7EJmA2aOGwtBDTMCRYx3K5pOuodzbUqEuujHv1TH8oFnpQ2SWX9d8
         i37bKQHGynK0U5HWFP/PvttOWBB1z4SnjfSNT33sKkzU3aS7+HLnJbqIcVPFKCMZw7rF
         Gnqg==
X-Forwarded-Encrypted: i=1; AJvYcCWdaWBrvufnQS5SZm5LPV1opRfR4pUlGzEmqpTk8yJXge59FlUSYm8JTKThYTVFSfl4zWvejKMSMwvBHj72pg/Vrr6Z
X-Gm-Message-State: AOJu0YzYY5aZzkOeeYE4RmGr2Ffo///12nNlAEgVyBxUlyZ4+mhMQSfr
	oYH7VqSAd7KZQ6rKt58SsGtxZ7tgLLanCrxb3963hnLjQGtvsnlz6X3OrUGdGMg6Ks9MwD5HCX/
	jtAUbHe+sVg==
X-Google-Smtp-Source: AGHT+IFNgdBalbrX784MJSkG7g28jv3ta6SaiIVV2y32vALYWfCkCKFBAZMdIemQeL1Zf8yLiAeIuqRY45gfTg==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6902:154d:b0:dfe:fe5e:990a with SMTP
 id 3f1490d57ef6-e041b1134demr24774276.9.1720803722717; Fri, 12 Jul 2024
 10:02:02 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:42 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-24-144b319a40d8@google.com>
Subject: [PATCH 24/26] mm: asi: Make TLB flushing correct under ASI
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

This is the absolute minimum change for TLB flushing to be correct under
ASI. There are two arguably orthogonal changes in here but they feel
small enough for a single commit.

.:: CR3 stabilization

As noted in the comment ASI can destabilize CR3, but we can stabilize it
again by calling asi_exit, this makes it safe to read CR3 and write it
back.

This is enough to be correct - we don't have to worry about invalidating
the other ASI address space (i.e. we don't need to invalidate the
restricted address space if we are currently unrestricted / vice versa)
because we currently never set the noflush bit in CR3 for ASI
transitions.

Even without using CR3's noflush bit there are trivial optimizations
still on the table here: on where invpcid_flush_single_context is
available (i.e. with the INVPCID_SINGLE feature) we can use that in lieu
of the CR3 read/write, and avoid the extremely costly asi_exit.

.:: Invalidating kernel mappings

Before ASI, with KPTI off we always either disable PCID or use global
mappings for kernel memory. However ASI disables global kernel mappings
regardless of factors. So we need to invalidate other address spaces to
trigger a flush when we switch into them.

Note that there is currently a pointless write of
cpu_tlbstate.invalidate_other in the case of KPTI and !PCID. We've added
another case of that (ASI, !KPTI and !PCID). I think that's preferable
to expanding the conditional in flush_tlb_one_kernel.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/tlb.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a9804274049e..1d9a300fe788 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -219,7 +219,7 @@ static void clear_asid_other(void)
 	 * This is only expected to be set if we have disabled
 	 * kernel _PAGE_GLOBAL pages.
 	 */
-	if (!static_cpu_has(X86_FEATURE_PTI)) {
+	if (!static_cpu_has(X86_FEATURE_PTI) && !static_cpu_has(X86_FEATURE_ASI)) {
 		WARN_ON_ONCE(1);
 		return;
 	}
@@ -1178,15 +1178,19 @@ void flush_tlb_one_kernel(unsigned long addr)
 	 * use PCID if we also use global PTEs for the kernel mapping, and
 	 * INVLPG flushes global translations across all address spaces.
 	 *
-	 * If PTI is on, then the kernel is mapped with non-global PTEs, and
-	 * __flush_tlb_one_user() will flush the given address for the current
-	 * kernel address space and for its usermode counterpart, but it does
-	 * not flush it for other address spaces.
+	 * If PTI or ASI is on, then the kernel is mapped with non-global PTEs,
+	 * and __flush_tlb_one_user() will flush the given address for the
+	 * current kernel address space and, if PTI is on, for its usermode
+	 * counterpart, but it does not flush it for other address spaces.
 	 */
 	flush_tlb_one_user(addr);
 
-	if (!static_cpu_has(X86_FEATURE_PTI))
+	/* Nothing more to do if PTI and ASI are completely off. */
+	if (!static_cpu_has(X86_FEATURE_PTI) && !static_cpu_has(X86_FEATURE_ASI)) {
+		VM_WARN_ON_ONCE(static_cpu_has(X86_FEATURE_PCID) &&
+				!(__default_kernel_pte_mask & _PAGE_GLOBAL));
 		return;
+	}
 
 	/*
 	 * See above.  We need to propagate the flush to all other address
@@ -1275,6 +1279,13 @@ STATIC_NOPV void native_flush_tlb_local(void)
 
 	invalidate_user_asid(this_cpu_read(cpu_tlbstate.loaded_mm_asid));
 
+	/*
+	 * Restricted ASI CR3 is unstable outside of critical section, so we
+	 * couldn't flush via a CR3 read/write.
+	 */
+	if (!asi_in_critical_section())
+		asi_exit();
+
 	/* If current->mm == NULL then the read_cr3() "borrows" an mm */
 	native_write_cr3(__native_read_cr3());
 }

-- 
2.45.2.993.g49e7a77208-goog


