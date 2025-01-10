Return-Path: <kvm+bounces-35070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F79A099C4
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 19:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEB34169398
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4600D21A455;
	Fri, 10 Jan 2025 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ML8ORbYi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9982144AC
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 18:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736534455; cv=none; b=u3O/EcdM1SMcr6wIX7RsKuVFTxth6zb3dss6OI1GG+iEQ367LUpLK90mjRq+1GUvT577GrjwN/LsU4UvgGIbnRXh9lh2kAGk+vkuDl9cRN+zoH7MD/GArscIPIEOeSs1LPj9wxZJVJeF1fVZR9HXTyDUqqGuCuH+AiYOVzK3Xt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736534455; c=relaxed/simple;
	bh=B1CeSagBxrLfs6jB5VeoJ7nAmcaFxr/avrGaVkxPLqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FUvex4RsAfp+SAtnsdKANMWX6jDZPwCWA9MOc3b7sA5gKdq42BgaA9LwUtLNS7jX/zqMAtzrPcOcy4eJlVvMdkW0eVnwfi2wVIzENMQoP6dbxKCACCYHV5Q/LCvhbQICI1AheMs3S40QQJBNl5kTvkSv5cg+cqv8S8OognG6gzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ML8ORbYi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so19286775e9.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736534448; x=1737139248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMV7uJ7I18OKYw8GMGFQsmzHxbOybRxQHWQLaqO2yfM=;
        b=ML8ORbYiTLDXohU0y5JjdrYoFG9f7YQqzwlVNTqJu6MjeN+0QzfjxZDMNBYGaT6542
         RnZjPB2w45xOyBgQZVqyyWZEyIP2J5DH19+sa5xeBCGmGwQ/5CgNVdJlXyKcTAUiaaH+
         kYifAbhrTTuv8SIUdnaw8Wr5KSB/PLe4TX2Nl1OZN5yoWHRm3C8CqqDisNaJazvE7uVV
         kixOIzgKBwSiIWwcrEqYcOHjgZIWhhO9qnEaWwU8lOEefEvOTszrDaZcDUFIFsUzbO8a
         T/i9qQo433mdldYPYJHZg8cPqdYZE5+eBKhcBMxima5DodTabWWJG0qqZfY5r2V8wiyg
         PqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736534448; x=1737139248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lMV7uJ7I18OKYw8GMGFQsmzHxbOybRxQHWQLaqO2yfM=;
        b=kum2OAgdoshDBnEN1AEq153UtCbN85IazHGC6yPJZ9K7Nc3R6mo0N7s4ciZbFkjjIG
         NEkHFHlV3hA0jfss+3jzt/Wpp+tPGLnTxUIShFaeMk79jtnTy4po0SfIddqK08rv819m
         NnalxVxEz4Nf6hXUEAGG17s8nvik1TyFuGc7N+YcyEEOlCOZ7iTh5yMoALDuVDSh/Oxe
         yx7Bk2owRPAqjGTujCaY0r42l2MKAcLrO6d28+YOR95hFRt7EZVzDuMIGgHcHyLMCVmJ
         htM+ShxpfM/V/WkRhAoxOED+lQY5VXLKrxcPqiOHFWzXfOhoxecgJtTpNDsbGyawLL6/
         O3fw==
X-Forwarded-Encrypted: i=1; AJvYcCXNyA0T/2JBD49xL2Mxu+b8HFSCU0wz1vd9RbjLRSXMNen/i+KeMDptr0/R8eu2tucTjS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQIPBvLll9ro04Te9xtVhJ60E63pdTtYK0BFQI6lnpdLTj/kep
	QItb05OWR+Z0tWSja1v+wIwu4y9QtYtwp78c6CaGFWIeWsC9Nla7wwZjekhcAEDDuC65EDJDyUN
	09LDkbbhFFQ==
X-Google-Smtp-Source: AGHT+IFp39E9krgcILEXjwgS0eG/yaDAJpZCMdfJgN+pTbMyBclx0Pttf9qnW8OHp1hJ5TpOh65GX4riAPR9zA==
X-Received: from wmbbd12.prod.google.com ([2002:a05:600c:1f0c:b0:434:fd41:173c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d03:b0:434:a781:f5d9 with SMTP id 5b1f17b1804b1-436e2697b32mr62972955e9.11.1736534447848;
 Fri, 10 Jan 2025 10:40:47 -0800 (PST)
Date: Fri, 10 Jan 2025 18:40:27 +0000
In-Reply-To: <20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>
X-Mailer: b4 0.15-dev
Message-ID: <20250110-asi-rfc-v2-v2-1-8419288bc805@google.com>
Subject: [PATCH RFC v2 01/29] mm: asi: Make some utility functions noinstr compatible
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@quicinc.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Michal Simek <monstr@monstr.eu>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mike Rapoport <rppt@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-efi@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Some existing utility functions would need to be called from a noinstr
context in the later patches. So mark these as either noinstr or
__always_inline.

An earlier version of this by Junaid had a macro that was intended to
tell the compiler "either inline this function, or call it in the
noinstr section", which basically boiled down to:

 #define inline_or_noinstr noinline __section(".noinstr.text")

Unfortunately Thomas pointed out this will prevent the function from
being inlined at call sites in .text.

So far I haven't been able[1] to find a formulation that lets us :
1. avoid calls from .noinstr.text -> .text,
2. while also letting the compiler freely decide what to inline.

1 is a functional requirement so here I'm just giving up on 2. Existing
callsites of this code are just forced inline. For the incoming code
that needs to call it from noinstr, they will be out-of-line calls.

[1] https://lore.kernel.org/lkml/CA+i-1C1z35M8wA_4AwMq7--c1OgjNoLGTkn4+Td5gKg7QQAzWw@mail.gmail.com/

Checkpatch-args: --ignore=COMMIT_LOG_LONG_LINE
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/processor.h     |  2 +-
 arch/x86/include/asm/special_insns.h |  8 ++++----
 arch/x86/include/asm/tlbflush.h      |  3 +++
 arch/x86/mm/tlb.c                    | 13 +++++++++----
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4a686f0e5dbf6d906ed38276148b186e920927b3..1a1b7ea5d7d32a47d783d9d62cd2a53672addd6f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -220,7 +220,7 @@ void print_cpu_msr(struct cpuinfo_x86 *);
 /*
  * Friendlier CR3 helpers.
  */
-static inline unsigned long read_cr3_pa(void)
+static __always_inline unsigned long read_cr3_pa(void)
 {
 	return __read_cr3() & CR3_ADDR_MASK;
 }
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index aec6e2d3aa1d52e5c8f513e188015a45e9eeaeb2..6e103358966f6f1333aa07be97aec5f8af794120 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -42,14 +42,14 @@ static __always_inline void native_write_cr2(unsigned long val)
 	asm volatile("mov %0,%%cr2": : "r" (val) : "memory");
 }
 
-static inline unsigned long __native_read_cr3(void)
+static __always_inline unsigned long __native_read_cr3(void)
 {
 	unsigned long val;
 	asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
-static inline void native_write_cr3(unsigned long val)
+static __always_inline void native_write_cr3(unsigned long val)
 {
 	asm volatile("mov %0,%%cr3": : "r" (val) : "memory");
 }
@@ -153,12 +153,12 @@ static __always_inline void write_cr2(unsigned long x)
  * Careful!  CR3 contains more than just an address.  You probably want
  * read_cr3_pa() instead.
  */
-static inline unsigned long __read_cr3(void)
+static __always_inline unsigned long __read_cr3(void)
 {
 	return __native_read_cr3();
 }
 
-static inline void write_cr3(unsigned long x)
+static __always_inline void write_cr3(unsigned long x)
 {
 	native_write_cr3(x);
 }
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 69e79fff41b800a0a138bcbf548dde9d72993105..c884174a44e119a3c027c44ada6c5cdba14d1282 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -423,4 +423,7 @@ static inline void __native_tlb_flush_global(unsigned long cr4)
 	native_write_cr4(cr4 ^ X86_CR4_PGE);
 	native_write_cr4(cr4);
 }
+
+unsigned long build_cr3_noinstr(pgd_t *pgd, u16 asid, unsigned long lam);
+
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 86593d1b787d8a5b9fa4bd492356898ec8870938..f0428e5e1f1947903ee87c4c6444844ee11b45c3 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -108,7 +108,7 @@
 /*
  * Given @asid, compute kPCID
  */
-static inline u16 kern_pcid(u16 asid)
+static __always_inline u16 kern_pcid(u16 asid)
 {
 	VM_WARN_ON_ONCE(asid > MAX_ASID_AVAILABLE);
 
@@ -153,9 +153,9 @@ static inline u16 user_pcid(u16 asid)
 	return ret;
 }
 
-static inline unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
+static __always_inline unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
 {
-	unsigned long cr3 = __sme_pa(pgd) | lam;
+	unsigned long cr3 = __sme_pa_nodebug(pgd) | lam;
 
 	if (static_cpu_has(X86_FEATURE_PCID)) {
 		cr3 |= kern_pcid(asid);
@@ -166,6 +166,11 @@ static inline unsigned long build_cr3(pgd_t *pgd, u16 asid, unsigned long lam)
 	return cr3;
 }
 
+noinstr unsigned long build_cr3_noinstr(pgd_t *pgd, u16 asid, unsigned long lam)
+{
+	return build_cr3(pgd, asid, lam);
+}
+
 static inline unsigned long build_cr3_noflush(pgd_t *pgd, u16 asid,
 					      unsigned long lam)
 {
@@ -1084,7 +1089,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
  * It's intended to be used for code like KVM that sneakily changes CR3
  * and needs to restore it.  It needs to be used very carefully.
  */
-unsigned long __get_current_cr3_fast(void)
+noinstr unsigned long __get_current_cr3_fast(void)
 {
 	unsigned long cr3 =
 		build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,

-- 
2.47.1.613.gc27f4b7a9f-goog


