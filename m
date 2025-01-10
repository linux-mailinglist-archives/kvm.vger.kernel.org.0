Return-Path: <kvm+bounces-35095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5C4A09A10
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 19:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB4101690A0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C3E24B244;
	Fri, 10 Jan 2025 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4hG1kZiF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E257324B22C
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736534884; cv=none; b=YiKWm9nXfUTKs9SdieMTBaddi6I73P3iCffGXYZAAvq2U3tWFNeyhOwNrtyvPSNaVLmwgJMzx7awku8dumeaohh3xMOhKsFrtlbV5u1jSF/NBGRxeQ1kYvvTra7eTaGYOVo5PyVUT8KOeh0ls5lZznR9jIwYFYiRTkgacubFlZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736534884; c=relaxed/simple;
	bh=ZK/QlM+sVXQDBx7cl96FsEOcDBNt5hiDNlbgk7bMxQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kfQ/SP1jcOvhdYJuLo6KQfZ+yTC0oNscXkfawtpWsNNKYAr3htbqmGjhi6aUAhAWb0B1T3pyR/bJsPYvU/mGXtFiPRCL9C7AZp+G8UcFep8TOhaMhbcKGY/ieZgUKBjzcnz5qgDEh5HBp6R+laMpCEFogrhQ3Cl6/59DFdDhW9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4hG1kZiF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so19336485e9.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 10:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736534880; x=1737139680; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAllTjvu+aeRJsuZfnIbaARP70yHbpTXyh5BDwNTLpw=;
        b=4hG1kZiFuW6COgD5B27L6J1DuYO/AficmaTBA73py5v0K0WKZs8jtZ0NQSSmaUmUgj
         Lr/UIAwTak3LCqx1CaSFWkvwEeH1hHI56xqhr1RvBNUjGj9X0RLkdR2e+1rLGOmlSXY2
         bEEjyruDEqnSP1QHTsvvNyYNGt5v0NZHX+v0C5iBsH5r2oBih4TrPZ+zXvOkNYrFfTe8
         yiHyW3StDIUN3IDO8bR2PBgI9IEPXg1enMcsAj9zoJVqfylWzyY4iRNybZI9Oz23x1j+
         lFcNdCf1eo1kmijTNkGW6MCcauZ5pMLyAHrmydYL8sLDCsu/Z/VBlwKg302sUZU5h8rr
         o48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736534880; x=1737139680;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CAllTjvu+aeRJsuZfnIbaARP70yHbpTXyh5BDwNTLpw=;
        b=eorEs8iFk+dsBInebjd6MU26usWXoSDym/4lCbO2ftVrV8+jEBihhED8X2i3+Ospsf
         +wllVe6/A7TjpmmmCnpJGzlp+fZ0xdp2v3xXU1/d/OrzpvE87MmrsuAcODqKc6Ox9mSi
         IUi+DngoakAFajQIWwBm0N3BbdU+Fqx6ayoTZMHnQNvoPo6AmUC72sYg2KrORFkMhXUc
         H/94UccwvgP9hzlyo9SSBoUNVmZmGV2i8Dh/GPtAclgJrQ5OYXHuoHonweqWLFKQkYGO
         wPcBMniTWkmNBwpc5RyKcXV//TBVGIVNz2O3TNDDe7JY2ID7EXdZyIVH2LuYqWbC7Ras
         vx0g==
X-Forwarded-Encrypted: i=1; AJvYcCUP2M/8o+k/wgcbVg2wQH92lzPt4wnHcUznf1s5Vvf45CnTaXTgXAkYPRF8BNM6y6mvejc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC/v7z/JSe4U1gX7thURjsZQPEuB/3Q5wD6wBN0Ujj/FuXkaJd
	cV/G3HVP8w0lL5yr1NEeK8ktrb8mvlVTmuPH/2psEXbFEElOUWtul1C5IKTZLbm4GVvUGAllPn4
	aRWzAbCXcOA==
X-Google-Smtp-Source: AGHT+IFbu2VfquZETrYawBwFSqjLwW/Qzimn4MDKfCetEVKQSMACYt32ELZsfcDoj+dSkmxIf50qY6QNFb/+Xg==
X-Received: from wmqe1.prod.google.com ([2002:a05:600c:4e41:b0:434:a050:ddcf])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3c85:b0:436:18d0:aa6e with SMTP id 5b1f17b1804b1-436e2679a7cmr125841955e9.5.1736534504638;
 Fri, 10 Jan 2025 10:41:44 -0800 (PST)
Date: Fri, 10 Jan 2025 18:40:52 +0000
In-Reply-To: <20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>
X-Mailer: b4 0.15-dev
Message-ID: <20250110-asi-rfc-v2-v2-26-8419288bc805@google.com>
Subject: [PATCH RFC v2 26/29] x86: Create library for flushing L1D for L1TF
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

ASI will need to use this L1D flushing logic so put it in a library
where it can be used independently of KVM.

Since we're creating this library, it starts to look messy if we don't
also use it in the double-opt-in (both kernel cmdline and prctl)
mm-switching flush logic which is there for mitigating Snoop-Assisted L1
Data Sampling ("SAL1DS"). However, that logic doesn't use any
software-based fallback for flushing on CPUs without the L1D_FLUSH
command. In that case the prctl opt-in will fail.

One option would be to just start using the software fallback sequence
currently done by VMX code, but Linus didn't seem happy with a similar
sequence being used here [1]. CPUs affected by SAL1DS are a subset of
those affected by L1TF, so it wouldn't be completely insane to assume
that the same sequence works for both cases, but I'll err on the side of
caution and avoid risk of giving users a false impression that the
kernel has really flushed L1D for them.

[1] https://lore.kernel.org/linux-kernel/CAHk-=whC4PUhErcoDhCbTOdmPPy-Pj8j9ytsdcyz9TorOb4KUw@mail.gmail.com/

Instead, create this awkward library that is scoped specifically to L1TF,
which will be used only by VMX and ASI, and has an annoying "only
sometimes works" doc-comment. Users of the library can then infer from
that comment whether they have flushed L1D.

No functional change intended.

Checkpatch-args: --ignore=COMMIT_LOG_LONG_LINE
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig            |  4 ++
 arch/x86/include/asm/l1tf.h | 11 ++++++
 arch/x86/kvm/Kconfig        |  1 +
 arch/x86/kvm/vmx/vmx.c      | 66 +++----------------------------
 arch/x86/lib/Makefile       |  1 +
 arch/x86/lib/l1tf.c         | 94 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 117 insertions(+), 60 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ae31f36ce23d7c29d1e90b726c5a2e6ea5a63c8d..ca984dc7ee2f2b68c3ce1bcb5055047ca4f2a65d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2523,6 +2523,7 @@ config MITIGATION_ADDRESS_SPACE_ISOLATION
 	bool "Allow code to run with a reduced kernel address space"
 	default n
 	depends on X86_64 && !PARAVIRT && !UML
+	select X86_L1TF_FLUSH_LIB
 	help
 	  This feature provides the ability to run some kernel code
 	  with a reduced kernel address space. This can be used to
@@ -3201,6 +3202,9 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
+config X86_L1TF_FLUSH_LIB
+	def_bool n
+
 source "arch/x86/kvm/Kconfig"
 
 source "arch/x86/Kconfig.assembler"
diff --git a/arch/x86/include/asm/l1tf.h b/arch/x86/include/asm/l1tf.h
new file mode 100644
index 0000000000000000000000000000000000000000..e0be19c588bb5ec5c76a1861492e48b88615b4b8
--- /dev/null
+++ b/arch/x86/include/asm/l1tf.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_L1TF_FLUSH_H
+#define _ASM_L1TF_FLUSH_H
+
+#ifdef CONFIG_X86_L1TF_FLUSH_LIB
+int l1tf_flush_setup(void);
+void l1tf_flush(void);
+#endif /* CONFIG_X86_L1TF_FLUSH_LIB */
+
+#endif
+
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6bbd28fa37fdf50547abf4403658c9..81c71510e33e52447882ab7b22682199c57b492e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -92,6 +92,7 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
+	select X86_L1TF_FLUSH_LIB
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e90463f1f2183b8d716f85d5c8a8af8958fef0b..b1a02f27b3abce0ef6ac448b66bef2c653a52eef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -42,6 +42,7 @@
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
+#include <asm/l1tf.h>
 #include <asm/reboot.h>
 #include <asm/perf_event.h>
 #include <asm/mmu_context.h>
@@ -250,9 +251,6 @@ static void *vmx_l1d_flush_pages;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
-	struct page *page;
-	unsigned int i;
-
 	if (!boot_cpu_has_bug(X86_BUG_L1TF)) {
 		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
 		return 0;
@@ -288,26 +286,11 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 		l1tf = VMENTER_L1D_FLUSH_ALWAYS;
 	}
 
-	if (l1tf != VMENTER_L1D_FLUSH_NEVER && !vmx_l1d_flush_pages &&
-	    !boot_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		/*
-		 * This allocation for vmx_l1d_flush_pages is not tied to a VM
-		 * lifetime and so should not be charged to a memcg.
-		 */
-		page = alloc_pages(GFP_KERNEL, L1D_CACHE_ORDER);
-		if (!page)
-			return -ENOMEM;
-		vmx_l1d_flush_pages = page_address(page);
+	if (l1tf != VMENTER_L1D_FLUSH_NEVER) {
+		int err = l1tf_flush_setup();
 
-		/*
-		 * Initialize each page with a different pattern in
-		 * order to protect against KSM in the nested
-		 * virtualization case.
-		 */
-		for (i = 0; i < 1u << L1D_CACHE_ORDER; ++i) {
-			memset(vmx_l1d_flush_pages + i * PAGE_SIZE, i + 1,
-			       PAGE_SIZE);
-		}
+		if (err)
+			return err;
 	}
 
 	l1tf_vmx_mitigation = l1tf;
@@ -6652,20 +6635,8 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return ret;
 }
 
-/*
- * Software based L1D cache flush which is used when microcode providing
- * the cache control MSR is not loaded.
- *
- * The L1D cache is 32 KiB on Nehalem and later microarchitectures, but to
- * flush it is required to read in 64 KiB because the replacement algorithm
- * is not exactly LRU. This could be sized at runtime via topology
- * information but as all relevant affected CPUs have 32KiB L1D cache size
- * there is no point in doing so.
- */
 static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
-	int size = PAGE_SIZE << L1D_CACHE_ORDER;
-
 	/*
 	 * This code is only executed when the flush mode is 'cond' or
 	 * 'always'
@@ -6695,32 +6666,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.l1d_flush++;
 
-	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
-		return;
-	}
-
-	asm volatile(
-		/* First ensure the pages are in the TLB */
-		"xorl	%%eax, %%eax\n"
-		".Lpopulate_tlb:\n\t"
-		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
-		"addl	$4096, %%eax\n\t"
-		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lpopulate_tlb\n\t"
-		"xorl	%%eax, %%eax\n\t"
-		"cpuid\n\t"
-		/* Now fill the cache */
-		"xorl	%%eax, %%eax\n"
-		".Lfill_cache:\n"
-		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
-		"addl	$64, %%eax\n\t"
-		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lfill_cache\n\t"
-		"lfence\n"
-		:: [flush_pages] "r" (vmx_l1d_flush_pages),
-		    [size] "r" (size)
-		: "eax", "ebx", "ecx", "edx");
+	l1tf_flush();
 }
 
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 98583a9dbab337e09a2e58905e5200499a496a07..b0a45bd70b40743a3fccb352b9641caacac83275 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -37,6 +37,7 @@ lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 lib-$(CONFIG_MITIGATION_RETPOLINE) += retpoline.o
+lib-$(CONFIG_X86_L1TF_FLUSH_LIB) += l1tf.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 obj-y += iomem.o
diff --git a/arch/x86/lib/l1tf.c b/arch/x86/lib/l1tf.c
new file mode 100644
index 0000000000000000000000000000000000000000..c474f18ae331c8dfa7a029c457dd3cf75bebf808
--- /dev/null
+++ b/arch/x86/lib/l1tf.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <asm/cpufeature.h>
+#include <asm/l1tf.h>
+#include <asm/msr.h>
+
+#define L1D_CACHE_ORDER 4
+static void *l1tf_flush_pages;
+
+int l1tf_flush_setup(void)
+{
+	struct page *page;
+	unsigned int i;
+
+	if (l1tf_flush_pages || boot_cpu_has(X86_FEATURE_FLUSH_L1D))
+		return 0;
+
+	page = alloc_pages(GFP_KERNEL, L1D_CACHE_ORDER);
+	if (!page)
+		return -ENOMEM;
+	l1tf_flush_pages = page_address(page);
+
+	/*
+	 * Initialize each page with a different pattern in
+	 * order to protect against KSM in the nested
+	 * virtualization case.
+	 */
+	for (i = 0; i < 1u << L1D_CACHE_ORDER; ++i) {
+		memset(l1tf_flush_pages + i * PAGE_SIZE, i + 1,
+			 PAGE_SIZE);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(l1tf_flush_setup);
+
+/*
+ * Flush L1D in a way that:
+ *
+ *  - definitely works on CPUs X86_FEATURE_FLUSH_L1D (because the SDM says so).
+ *  - almost definitely works on other CPUs with L1TF (because someone on LKML
+ *    said someone from Intel said so).
+ *  - may or may not work on other CPUs.
+ *
+ * Don't call unless l1tf_flush_setup() has returned successfully.
+ */
+noinstr void l1tf_flush(void)
+{
+	int size = PAGE_SIZE << L1D_CACHE_ORDER;
+
+	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		return;
+	}
+
+	if (WARN_ON(!l1tf_flush_pages))
+		return;
+
+	/*
+	 * This sequence was provided by Intel for the purpose of mitigating
+	 * L1TF on VMX.
+	 *
+	 * The L1D cache is 32 KiB on Nehalem and some later microarchitectures,
+	 * but to flush it is required to read in 64 KiB because the replacement
+	 * algorithm is not exactly LRU. This could be sized at runtime via
+	 * topology information but as all relevant affected CPUs have 32KiB L1D
+	 * cache size there is no point in doing so.
+	 */
+	asm volatile(
+		/* First ensure the pages are in the TLB */
+		"xorl	%%eax, %%eax\n"
+		".Lpopulate_tlb:\n\t"
+		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
+		"addl	$4096, %%eax\n\t"
+		"cmpl	%%eax, %[size]\n\t"
+		"jne	.Lpopulate_tlb\n\t"
+		"xorl	%%eax, %%eax\n\t"
+		"cpuid\n\t"
+		/* Now fill the cache */
+		"xorl	%%eax, %%eax\n"
+		".Lfill_cache:\n"
+		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
+		"addl	$64, %%eax\n\t"
+		"cmpl	%%eax, %[size]\n\t"
+		"jne	.Lfill_cache\n\t"
+		"lfence\n"
+		:: [flush_pages] "r" (l1tf_flush_pages),
+		    [size] "r" (size)
+		: "eax", "ebx", "ecx", "edx");
+}
+EXPORT_SYMBOL(l1tf_flush);

-- 
2.47.1.613.gc27f4b7a9f-goog


