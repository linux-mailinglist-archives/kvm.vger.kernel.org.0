Return-Path: <kvm+bounces-56509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7337DB3EBED
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16BEC17EEA1
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76502F1FFE;
	Mon,  1 Sep 2025 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTrqBfev"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8D2E6CD0
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742991; cv=none; b=oWcbdRvP0thfjOZTL0u/Ozleyjr2afImbjltwQjCL9j3Mld+WDYSwB7wyHXnYye7XHVko/H7xDWYQJA4jFZTENSHFT3jL6pUPdFYDvQtKY6HqWCE31GDfCIY/D4YavA3q3Avtlj+Bp39h7EoVwhXfirBxOaOrwBMrEsmkPtPiyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742991; c=relaxed/simple;
	bh=jpKHYGmCtueZ8D8VBUsMZT8ONSweBcCS83ya6hNTJpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4b5VqS7OpG+G9x0bKH1ufe1pSvFTcX+ga30rKlrmJC+JNoNiYdnZHNkfDGtJNXcnLJxE59+P5lMjLsoiWhf193vNDUqL9q81U3gLXk7lPaxX0+umSVNe4KV2bGTVCJ7O8MvLGMQ8trRLx5DtNpcQFp2+SfLvqBZjZIzXfjjves=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTrqBfev; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U3TbFIMcvGAQ1Z4BqKhz2/agDzUx20cT3mtJIvL86Nc=;
	b=LTrqBfevcnC+4XnekPTxk6yFepgfs3nA39/HOU+6V77U5uOHjWcC3eb5lo50XqnB9JJvXd
	GJ5/WBVE/4u/Ry2NE78py12hdEUNNbzF0BIYBjebVJI+D8xlNQoIXgxawUWFNbeyAQtBXo
	Oui1DYXLFSQgErQoCl9W34dZikZK1kA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-WaD0f6tAN3euubNZa6s2gQ-1; Mon, 01 Sep 2025 12:09:45 -0400
X-MC-Unique: WaD0f6tAN3euubNZa6s2gQ-1
X-Mimecast-MFC-AGG-ID: WaD0f6tAN3euubNZa6s2gQ_1756742985
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7f2942a1aa1so1278241285a.0
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742985; x=1757347785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U3TbFIMcvGAQ1Z4BqKhz2/agDzUx20cT3mtJIvL86Nc=;
        b=bNm3A0Fmg/8/MgTa8MVg8aFyp3tCJAqAVsWe+TOiyxS8XnYT5Q0IANjG6IoK7HSaGi
         3h1/bKejhUelmn6W/XwKHSfjR3FK8X/ffqTqFWCKb4EQdMDSRSA38X16FER1K6/Yr2s8
         jQchxBcZfWE92HS8kx6baV6wyccP7b3Si6xJnHoyPWZ0f6aJwXGmrpzS2axXVWy6xorP
         YXRdpjEm5zP2IcT8wunjtre83wmxYEhQXzr3I8ccoVsUFPeEyXwBJOVwiGO0CJLdHIih
         qduMjwCcZ6aERcLxuRmmD89g3A4tA1s+kk15VZGstANrQ3CSUCqFQODu5srr3ryWutNl
         WGcg==
X-Forwarded-Encrypted: i=1; AJvYcCXHzC+//CMLHViMHU/yRHm0WjGl2mezdIjAKRbGffoG1RhgNbtaNrMH+0p4RIqoqEIUY6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXEbo2TImLVN31Asw1OFe2m3QQQ1HgBhoPj4Aa2YEF3Jk8bNEX
	tJ11IrvU3CVpfGV6chqStpkrOdWqdRxeihxdymB2WWkLA05KH2fBYzQGm0uuTJMykTxxla/Lprg
	o+qH3ntOzQL1jOe/5jYXkeauWWrejL29lZQEHM+gR6nQYl2Mf3xZOcA==
X-Gm-Gg: ASbGncta6Qy2yucwZEfKEvy4n5TJXWDzyf1YLnPrLESfqrHzo4P7yhadfTY0u7mnXW1
	WvLfFAN4FUDF2HF/yGXGY++LOTO/0oHXhjxG6DGygAV6essNjj3Gh5h6mWsTX2v2D36yvMQqPge
	iQDC77jH8Hb7K9lIHwugd5OSjyHj/03/rEyPRqoE4k7++s6htgcNF2iVy3oj5fv27GQZChTITho
	kOhQm/kb6i2VwFs5c40HWJSLBQS8aLw8/JM8RjSt1pI94JV5uxFyGh/wZ2v4Tk3Mo2y+c6hR+eL
	trc0BoOoQACOVBYsqhVMXrLqCrwlO4M6+0CaO7PEflCW2+7oORXOQ2MibCVnqsXXL+dPaoJG9o9
	/mwkTgh5Owr4h8VkGsQzIqaHnlZBeMDiXKNg4DRJWocxLphnUJu5h8awdutVJfv/q6s3U
X-Received: by 2002:a05:620a:45a3:b0:7fb:e684:bc0d with SMTP id af79cd13be357-7fed772f970mr655310785a.38.1756742984893;
        Mon, 01 Sep 2025 09:09:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4rUO01RPiRDYjEO824d/2PmRfL+5SSdY+BjxsONhN7FDIfaGb+sktB53si5IfTFykSqNyLw==
X-Received: by 2002:a05:620a:45a3:b0:7fb:e684:bc0d with SMTP id af79cd13be357-7fed772f970mr655305985a.38.1756742984156;
        Mon, 01 Sep 2025 09:09:44 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b30b67f435sm64472141cf.29.2025.09.01.09.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:43 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com,
	x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	kai.huang@intel.com,
	seanjc@google.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH 2/7] x86/sme: Use percpu boolean to control WBINVD during kexec
Date: Mon,  1 Sep 2025 18:09:25 +0200
Message-ID: <20250901160930.1785244-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

TL;DR:

Prepare to unify how TDX and SME do cache flushing during kexec by
making a percpu boolean control whether to do the WBINVD.

-- Background --

On SME platforms, dirty cacheline aliases with and without encryption
bit can coexist, and the CPU can flush them back to memory in random
order.  During kexec, the caches must be flushed before jumping to the
new kernel otherwise the dirty cachelines could silently corrupt the
memory used by the new kernel due to different encryption property.

TDX also needs a cache flush during kexec for the same reason.  It would
be good to have a generic way to flush the cache instead of scattering
checks for each feature all around.

When SME is enabled, the kernel basically encrypts all memory including
the kernel itself and a simple memory write from the kernel could dirty
cachelines.  Currently, the kernel uses WBINVD to flush the cache for
SME during kexec in two places:

1) the one in stop_this_cpu() for all remote CPUs when the kexec-ing CPU
   stops them;
2) the one in the relocate_kernel() where the kexec-ing CPU jumps to the
   new kernel.

-- Solution --

Unlike SME, TDX can only dirty cachelines when it is used (i.e., when
SEAMCALLs are performed).  Since there are no more SEAMCALLs after the
aforementioned WBINVDs, leverage this for TDX.

To unify the approach for SME and TDX, use a percpu boolean to indicate
the cache may be in an incoherent state and needs flushing during kexec,
and set the boolean for SME.  TDX can then leverage it.

While SME could use a global flag (since it's enabled at early boot and
enabled on all CPUs), the percpu flag fits TDX better:

The percpu flag can be set when a CPU makes a SEAMCALL, and cleared when
another WBINVD on the CPU obviates the need for a kexec-time WBINVD.
Saving kexec-time WBINVD is valuable, because there is an existing
race[*] where kexec could proceed while another CPU is active.  WBINVD
could make this race worse, so it's worth skipping it when possible.

-- Side effect to SME --

Today the first WBINVD in the stop_this_cpu() is performed when SME is
*supported* by the platform, and the second WBINVD is done in
relocate_kernel() when SME is *activated* by the kernel.  Make things
simple by changing to do the second WBINVD when the platform supports
SME.  This allows the kernel to simply turn on this percpu boolean when
bringing up a CPU by checking whether the platform supports SME.

No other functional change intended.

[*] The aforementioned race:

During kexec native_stop_other_cpus() is called to stop all remote CPUs
before jumping to the new kernel.  native_stop_other_cpus() firstly
sends normal REBOOT vector IPIs to stop remote CPUs and waits them to
stop.  If that times out, it sends NMI to stop the CPUs that are still
alive.  The race happens when native_stop_other_cpus() has to send NMIs
and could potentially result in the system hang (for more information
please see [1]).

Link: https://lore.kernel.org/kvm/b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kexec.h         |  4 ++--
 arch/x86/include/asm/processor.h     |  2 ++
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 14 ++++++++++----
 arch/x86/kernel/process.c            | 24 +++++++++++-------------
 arch/x86/kernel/relocate_kernel_64.S | 13 ++++++++++---
 6 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 12cebbcdb6c8..5cfb27f26583 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -17,8 +17,8 @@
 
 #include <linux/bits.h>
 
-#define RELOC_KERNEL_PRESERVE_CONTEXT		BIT(0)
-#define RELOC_KERNEL_HOST_MEM_ENC_ACTIVE	BIT(1)
+#define RELOC_KERNEL_PRESERVE_CONTEXT	BIT(0)
+#define RELOC_KERNEL_CACHE_INCOHERENT	BIT(1)
 
 #endif
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bde58f6510ac..a24c7805acdb 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -731,6 +731,8 @@ void __noreturn stop_this_cpu(void *dummy);
 void microcode_check(struct cpuinfo_x86 *prev_info);
 void store_cpu_caps(struct cpuinfo_x86 *info);
 
+DECLARE_PER_CPU(bool, cache_state_incoherent);
+
 enum l1tf_mitigations {
 	L1TF_MITIGATION_OFF,
 	L1TF_MITIGATION_AUTO,
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a6f88ca1a6b4..5398db4dedb4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -545,6 +545,23 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 {
 	u64 msr;
 
+	/*
+	 * Mark using WBINVD is needed during kexec on processors that
+	 * support SME. This provides support for performing a successful
+	 * kexec when going from SME inactive to SME active (or vice-versa).
+	 *
+	 * The cache must be cleared so that if there are entries with the
+	 * same physical address, both with and without the encryption bit,
+	 * they don't race each other when flushed and potentially end up
+	 * with the wrong entry being committed to memory.
+	 *
+	 * Test the CPUID bit directly because with mem_encrypt=off the
+	 * BSP will clear the X86_FEATURE_SME bit and the APs will not
+	 * see it set after that.
+	 */
+	if (c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+		__this_cpu_write(cache_state_incoherent, true);
+
 	/*
 	 * BIOS support is required for SME and SEV.
 	 *   For SME: If BIOS has enabled SME then adjust x86_phys_bits by
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index fdd04b5bb70e..34c303a92eaf 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -29,6 +29,7 @@
 #include <asm/set_memory.h>
 #include <asm/cpu.h>
 #include <asm/efi.h>
+#include <asm/processor.h>
 
 #ifdef CONFIG_ACPI
 /*
@@ -426,11 +427,11 @@ void __nocfi machine_kexec(struct kimage *image)
 		relocate_kernel_flags |= RELOC_KERNEL_PRESERVE_CONTEXT;
 
 	/*
-	 * This must be done before load_segments() since if call depth tracking
-	 * is used then GS must be valid to make any function calls.
+	 * This must be done before load_segments() since it resets
+	 * GS to 0 and percpu data needs the correct GS to work.
 	 */
-	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
-		relocate_kernel_flags |= RELOC_KERNEL_HOST_MEM_ENC_ACTIVE;
+	if (this_cpu_read(cache_state_incoherent))
+		relocate_kernel_flags |= RELOC_KERNEL_CACHE_INCOHERENT;
 
 	/*
 	 * The segment registers are funny things, they have both a
@@ -441,6 +442,11 @@ void __nocfi machine_kexec(struct kimage *image)
 	 *
 	 * Take advantage of this here by force loading the segments,
 	 * before the GDT is zapped with an invalid value.
+	 *
+	 * load_segments() resets GS to 0.  Don't make any function call
+	 * after here since call depth tracking uses percpu variables to
+	 * operate (relocate_kernel() is explicitly ignored by call depth
+	 * tracking).
 	 */
 	load_segments();
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1b7960cf6eb0..f2bbbeef5477 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -88,6 +88,16 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
 DEFINE_PER_CPU(bool, __tss_limit_invalid);
 EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
 
+/*
+ * The cache may be in an incoherent state and needs flushing during kexec.
+ * E.g., on SME/TDX platforms, dirty cacheline aliases with and without
+ * encryption bit(s) can coexist and the cache needs to be flushed before
+ * booting to the new kernel to avoid the silent memory corruption due to
+ * dirty cachelines with different encryption property being written back
+ * to the memory.
+ */
+DEFINE_PER_CPU(bool, cache_state_incoherent);
+
 /*
  * this gets called so that we can store lazy state into memory and copy the
  * current task into the new thread.
@@ -827,19 +837,7 @@ void __noreturn stop_this_cpu(void *dummy)
 	disable_local_APIC();
 	mcheck_cpu_clear(c);
 
-	/*
-	 * Use wbinvd on processors that support SME. This provides support
-	 * for performing a successful kexec when going from SME inactive
-	 * to SME active (or vice-versa). The cache must be cleared so that
-	 * if there are entries with the same physical address, both with and
-	 * without the encryption bit, they don't race each other when flushed
-	 * and potentially end up with the wrong entry being committed to
-	 * memory.
-	 *
-	 * Test the CPUID bit directly because the machine might've cleared
-	 * X86_FEATURE_SME due to cmdline options.
-	 */
-	if (c->extended_cpuid_level >= 0x8000001f && (cpuid_eax(0x8000001f) & BIT(0)))
+	if (this_cpu_read(cache_state_incoherent))
 		wbinvd();
 
 	/*
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 26e945f85d19..11e20bb13aca 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -198,14 +198,21 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movq	%r9, %cr3
 
 	/*
+	 * If the memory cache is in incoherent state, e.g., due to
+	 * memory encryption, do WBINVD to flush cache.
+	 *
 	 * If SME is active, there could be old encrypted cache line
 	 * entries that will conflict with the now unencrypted memory
 	 * used by kexec. Flush the caches before copying the kernel.
+	 *
+	 * Note SME sets this flag to true when the platform supports
+	 * SME, so the WBINVD is performed even SME is not activated
+	 * by the kernel.  But this has no harm.
 	 */
-	testb	$RELOC_KERNEL_HOST_MEM_ENC_ACTIVE, %r11b
-	jz .Lsme_off
+	testb	$RELOC_KERNEL_CACHE_INCOHERENT, %r11b
+	jz .Lnowbinvd
 	wbinvd
-.Lsme_off:
+.Lnowbinvd:
 
 	call	swap_pages
 
-- 
2.51.0


