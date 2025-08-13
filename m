Return-Path: <kvm+bounces-54621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F2DB257FC
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 02:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 408501BC67CE
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF79730AADC;
	Wed, 13 Aug 2025 23:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OGyCkfss"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A26C301486;
	Wed, 13 Aug 2025 23:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129577; cv=none; b=kDDGg7ZQL2ynvgzD3WpX39t6s1WomDYtfh+pAhzEyieOJ2kMqeQpRbYyWVN2VdYaBGrHUJNBeav1FDKagSMbWwmzcLlMV78FexznZQGG+PgTB9qedYISAJiAO8Z9e5k+a1GgOahPjN5VzYZyz+jNg9zSTO+ZJz8OzjQDCtDTNGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129577; c=relaxed/simple;
	bh=JO8rsFnkOnYJy9J9uAdKbxBmCUSsYoNSMGcFvfWwYkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sieRHYmcCi6yc4Vf+pEcP0pSJfGKzFElthAikF0snX2RLh+g7atHybUflCKl6s8LD/r77XORPvOR2gnwZwPEZTUbKVl7YEJ9+XS1t+qby1+KnHcbhWKCqJKiww+LqL9Fi4P0Y/k7Pl17W4bqxSic1g/Zz7+a8tjFAf0pALMnb0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OGyCkfss; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129575; x=1786665575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JO8rsFnkOnYJy9J9uAdKbxBmCUSsYoNSMGcFvfWwYkY=;
  b=OGyCkfssT8sOJorcc2X5SUyMKCs/tgURJ6QjDd9WERk6zn1IdZMkJbDI
   ZcRcBtWU4fBS5Jt+rjUu9HmwYuPV3TtxV4A9a/r7NlFlUcKqmlsIc7h1r
   YQ48AWIB3vYuKqDlV5QO+gbN6Ey2HvDMUFL6oWuGgLfTu+ztTLx87Gcsx
   erzUB7Fog7nNhoir0anqqDKFxFNXFupgRTbkQmkXC+yzSiVJQ0ZcZovRg
   AftKTECAqFAK3127FQqhlQkjWEfkQW3Z6aRkuUM8rm9oVK+sMuiUzbLJx
   THhtlotp2oUR3EwcVHGGkPahUPf8p+fFB2R6pZsEaWwKfqP5yI3YCW+uX
   g==;
X-CSE-ConnectionGUID: XMVQ+f20QDa1y+JifjkZ2g==
X-CSE-MsgGUID: 9OrXbBN/SACdAs6ebz3kMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014669"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014669"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:35 -0700
X-CSE-ConnectionGUID: zaCpU3tyTaGtujGfcnEbYA==
X-CSE-MsgGUID: ODtXpSSvTVm3hg/JNWrRog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105047"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:29 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH v6 2/7] x86/sme: Use percpu boolean to control WBINVD during kexec
Date: Thu, 14 Aug 2025 11:59:02 +1200
Message-ID: <c09d17677fa127a7b23b24b6c225f7dc5b68fd98.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755126788.git.kai.huang@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---

v5 -> v6:
 - No change

v4 -> v5:
 - Code rebase due to change RELOC_KERNEL_HOST_MEM_ACTIVE to
   RELOC_KERNEL_HOST_MEM_ENC_ACTIVE.

v3 -> v4:
 - Simplify the changelog using AI -- Boris
 - Call out "Test CPUID bit directly due to mem_encrypt=off" in the
   comment  -- Boris
 - Add a comment to explain the percpu boolean -- Boris
 - s/wbinvd/WBINVD -- Boris
 - Code update due to patch 1 being added


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
index a5ece6ebe8a7..66a682be4a1a 100644
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
index 5cda8d8d8b13..dfb91091f451 100644
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
2.50.1


