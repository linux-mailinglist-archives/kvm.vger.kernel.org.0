Return-Path: <kvm+bounces-21550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E377E92FEF7
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3025EB2164A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AA5317BB0C;
	Fri, 12 Jul 2024 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1O2tT4b8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A117B504
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803689; cv=none; b=ZAWp624I44H2LCIljCfpeW9H9628DtN9mxGvij6KKwaETKXF3ihWHi0/lzdqxONjCfWy0lrEEIVIiMoE37HwQ5g40AXAsvWfebHkQeZ0si0iFH8QQDSRhQwMUbr7tF1Ay9rAH0WvVUqZn7bvLPJVTwdVilBKggjX889ToAPN+KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803689; c=relaxed/simple;
	bh=zjiZ8DlYeMv7rFCcpM3mQi4MuT9VAeVdTY4uW1UV8lE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ba6mNxRrdvGK6QPhz6XVmYJanrIS/K7qZiy1YbeNFqtOf4SFzLJlC+c0UcE/N3/hY+gs+h+ejVIlSzjmjn27n9QbJ0o06RiENXfL+MUmw+FYeU6u/EasLMgBYtyuV74rt4c82Kdx7thrWR8Ay+8Y1McvxgV80/a0HHSLTrUTqQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1O2tT4b8; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-367988464ceso1772221f8f.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803686; x=1721408486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MiTpcmi4SGpEzjuyBzeicJVJrQMm8QovFUpVk7p2Hrs=;
        b=1O2tT4b8VtedcUoeKiNXsgthbJfySQHATtFEegS2cd35VXkonC207t68YcMGkPvwht
         r2RedZNsC57MnjiyVx5V2dl+wKwnOkU0eSDWXYKPuUAsX+rxTkvbRX4pzZYHxZ2QoSbW
         6PTAfbhXTU8cFzWHA6HwwbKzYImPkkOZCsL6sLfjAJxAyorhlbVsf6NhF6Hcg5O2zQ7G
         mulcu51Ir5AVVtiUsLkTKukvI4YC+w9CDH3q9wGBl2QZBOW3jDvlHdhDfWE2sMWIpViJ
         NF0jkw+I+69r7m30uWA0dOsoT/MHrkucfeLSyRj/EWNQ/2CpieTVuoG3rAqri3qrAhmA
         ot1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803686; x=1721408486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MiTpcmi4SGpEzjuyBzeicJVJrQMm8QovFUpVk7p2Hrs=;
        b=WIMOYjmlNPJd1FGDTdyTIGQbO++VJoh/M9H19hkAR5W+Z8AyKcTQYiLEXKue37UkyN
         OGOWtE1dWs8XANWO2YQFRdNTW51IvAhJCtDvkMbinRA8GRXAnsTlRkFE1A/jwnIIkzGp
         Eax2c2soZqRmGDGLing0ElcFziW5fw8nuEDWW7H7WVR4dWdxC2ZE2KVP/tzeD0cUcFEd
         mMo4CJDvpMLz10tPJG8b826mLWtHS6kxgqnUt0Rq/Jmbnk91fDumyWhJ9Fv6Whq8/sa4
         6e+hj5cnLjLel3bZD/ebnREEyXdffh2dOC1tb4J24J/J8W+HAdorhNZydRitHPOkgViZ
         xxCg==
X-Forwarded-Encrypted: i=1; AJvYcCVo6p9ZMO1T5FsH+PTm6f8rXas53VlGwmeeKFbA0IgHY6hoxVsFxk67DV3iAF/RyOyS2JuadfyN71GGk+0418D/DyTP
X-Gm-Message-State: AOJu0YyOSZDT7FqRxahjDvsMy00n6cvDVpumj2HDIROsZTkSW6jrpnNq
	qMgS5mafxKun7KGeRQ371A30438Sdff7UJ6wi0FOeaWqynbpvOiev1s1Yp3uVse5Yq8KHvKjdqA
	Nn4SVksMsqA==
X-Google-Smtp-Source: AGHT+IHaxca8Kt7JtoFlz5j8ZwGaa7ohvNgTm761vo7JWzSlYydrUy+c3mRwk3Ip75evYABidpu6mgorHtLpeg==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a5d:6387:0:b0:367:890e:935e with SMTP id
 ffacd0b85a97d-367cea67da0mr20496f8f.4.1720803686255; Fri, 12 Jul 2024
 10:01:26 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:30 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-12-144b319a40d8@google.com>
Subject: [PATCH 12/26] mm: asi: asi_exit() on PF, skip handling if address is accessible
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

From: Ofir Weisse <oweisse@google.com>

On a page-fault - do asi_exit(). Then check if now after the exit the
address is accessible. We do this by refactoring spurious_kernel_fault()
into two parts:

1. Verify that the error code value is something that could arise from a
lazy TLB update.
2. Walk the page table and verify permissions, which is now called
is_address_accessible(). We also define PTE_PRESENT() and PMD_PRESENT()
which are suitable for checking userspace pages. For the sake of
spurious faults,  pte_present() and pmd_present() are only good for
kernelspace pages. This is because these macros might return true even
if the present bit is 0 (only relevant for userspace).

Signed-off-by: Ofir Weisse <oweisse@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/fault.c | 119 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 104 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bba4e020dd64..e0bc5006c371 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -942,7 +942,7 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)address);
 }
 
-static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
+static __always_inline int kernel_protection_ok(unsigned long error_code, pte_t *pte)
 {
 	if ((error_code & X86_PF_WRITE) && !pte_write(*pte))
 		return 0;
@@ -953,6 +953,9 @@ static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
 	return 1;
 }
 
+static inline_or_noinstr int kernel_access_ok(
+	unsigned long error_code, unsigned long address, pgd_t *pgd);
+
 /*
  * Handle a spurious fault caused by a stale TLB entry.
  *
@@ -978,11 +981,6 @@ static noinline int
 spurious_kernel_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	int ret;
 
 	/*
 	 * Only writes to RO or instruction fetches from NX may cause
@@ -998,6 +996,50 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 		return 0;
 
 	pgd = init_mm.pgd + pgd_index(address);
+	return kernel_access_ok(error_code, address, pgd);
+}
+NOKPROBE_SYMBOL(spurious_kernel_fault);
+
+/*
+ * For kernel addresses, pte_present and pmd_present are sufficient for
+ * is_address_accessible. For user addresses these functions will return true
+ * even though the pte is not actually accessible by hardware (i.e _PAGE_PRESENT
+ * is not set). This happens in cases where the pages are physically present in
+ * memory, but they are not made accessible to hardware as they need software
+ * handling first:
+ *
+ * - ptes/pmds with _PAGE_PROTNONE need autonuma balancing (see pte_protnone(),
+ *   change_prot_numa(), and do_numa_page()).
+ *
+ * - pmds with _PAGE_PSE & !_PAGE_PRESENT are undergoing splitting (see
+ *   split_huge_page()).
+ *
+ * Here, we care about whether the hardware can actually access the page right
+ * now.
+ *
+ * These issues aren't currently present for PUD but we also have a custom
+ * PUD_PRESENT for a layer of future-proofing.
+ */
+#define PUD_PRESENT(pud) (pud_flags(pud) & _PAGE_PRESENT)
+#define PMD_PRESENT(pmd) (pmd_flags(pmd) & _PAGE_PRESENT)
+#define PTE_PRESENT(pte) (pte_flags(pte) & _PAGE_PRESENT)
+
+/*
+ * Check if an access by the kernel would cause a page fault. The access is
+ * described by a page fault error code (whether it was a write/instruction
+ * fetch) and address. This doesn't check for types of faults that are not
+ * expected to affect the kernel, e.g. PKU. The address can be user or kernel
+ * space, if user then we assume the access would happen via the uaccess API.
+ */
+static inline_or_noinstr int
+kernel_access_ok(unsigned long error_code, unsigned long address, pgd_t *pgd)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	int ret;
+
 	if (!pgd_present(*pgd))
 		return 0;
 
@@ -1006,27 +1048,27 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 		return 0;
 
 	if (p4d_leaf(*p4d))
-		return spurious_kernel_fault_check(error_code, (pte_t *) p4d);
+		return kernel_protection_ok(error_code, (pte_t *) p4d);
 
 	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
+	if (!PUD_PRESENT(*pud))
 		return 0;
 
 	if (pud_leaf(*pud))
-		return spurious_kernel_fault_check(error_code, (pte_t *) pud);
+		return kernel_protection_ok(error_code, (pte_t *) pud);
 
 	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	if (!PMD_PRESENT(*pmd))
 		return 0;
 
 	if (pmd_leaf(*pmd))
-		return spurious_kernel_fault_check(error_code, (pte_t *) pmd);
+		return kernel_protection_ok(error_code, (pte_t *) pmd);
 
 	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
+	if (!PTE_PRESENT(*pte))
 		return 0;
 
-	ret = spurious_kernel_fault_check(error_code, pte);
+	ret = kernel_protection_ok(error_code, pte);
 	if (!ret)
 		return 0;
 
@@ -1034,12 +1076,11 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 	 * Make sure we have permissions in PMD.
 	 * If not, then there's a bug in the page tables:
 	 */
-	ret = spurious_kernel_fault_check(error_code, (pte_t *) pmd);
+	ret = kernel_protection_ok(error_code, (pte_t *) pmd);
 	WARN_ONCE(!ret, "PMD has incorrect permission bits\n");
 
 	return ret;
 }
-NOKPROBE_SYMBOL(spurious_kernel_fault);
 
 int show_unhandled_signals = 1;
 
@@ -1483,6 +1524,29 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 	}
 }
 
+static __always_inline void warn_if_bad_asi_pf(
+	unsigned long error_code, unsigned long address)
+{
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+	struct asi *target;
+
+	/*
+	 * It's a bug to access sensitive data from the "critical section", i.e.
+	 * on the path between asi_enter and asi_relax, where untrusted code
+	 * gets run. #PF in this state sees asi_intr_nest_depth() as 1 because
+	 * #PF increments it. We can't think of a better way to determine if
+	 * this has happened than to check the ASI pagetables, hence we can't
+	 * really have this check in non-debug builds unfortunately.
+	 */
+	VM_WARN_ONCE(
+		(target = asi_get_target(current)) != NULL &&
+		asi_intr_nest_depth() == 1 &&
+		!kernel_access_ok(error_code, address, asi_pgd(target)),
+		"ASI-sensitive data access from critical section, addr=%px error_code=%lx class=%s",
+		(void *) address, error_code, target->class->name);
+#endif
+}
+
 DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 {
 	irqentry_state_t state;
@@ -1490,6 +1554,31 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 
 	address = cpu_feature_enabled(X86_FEATURE_FRED) ? fred_event_data(regs) : read_cr2();
 
+	if (static_asi_enabled() && !user_mode(regs)) {
+		pgd_t *pgd;
+
+		/* Can be a NOP even for ASI faults, because of NMIs */
+		asi_exit();
+
+		/*
+		 * handle_page_fault() might oops if we run it for a kernel
+		 * address. This might be the case if we got here due to an ASI
+		 * fault. We avoid this case by checking whether the address is
+		 * now, after asi_exit(), accessible by hardware. If it is -
+		 * there's nothing to do. Note that this is a bit of a shotgun;
+		 * we can also bail early from user-address faults here that
+		 * weren't actually caused by ASI. So we might wanna move this
+		 * logic later in the handler. In particular, we might be losing
+		 * some stats here. However for now this keeps ASI page faults
+		 * nice and fast.
+		 */
+		pgd = (pgd_t *)__va(read_cr3_pa()) + pgd_index(address);
+		if (kernel_access_ok(error_code, address, pgd)) {
+			warn_if_bad_asi_pf(error_code, address);
+			return;
+		}
+	}
+
 	prefetchw(&current->mm->mmap_lock);
 
 	/*

-- 
2.45.2.993.g49e7a77208-goog


