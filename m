Return-Path: <kvm+bounces-55701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3070AB34F6B
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF5B25E7C33
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58602D0C61;
	Mon, 25 Aug 2025 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tt3hM9g5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5822D061E;
	Mon, 25 Aug 2025 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162753; cv=none; b=owsD1k3Xx8fO6pPH81/4Uy31/LMQEU/X+/DYozYd1Rg07KnIBDPxZgaR7zZYxVFa+nQGhTkE/ULu+Y9le49+EzKL7oqblBmdfteK5vTw7eH6S5FchqCOcZsF9GN7kyhCGKs1GFY+NtXvBrgc87lyda96YK/qJhfn2liKaAgj8+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162753; c=relaxed/simple;
	bh=sQLQIb3lXbdRCTd1qONWSd9/8AzyiqqEAKKCpvPKYpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH1jxJoTJSYaCMlt39rK+HGYVuhOTmIuXDtu77w92Eg0iRxj+2puttfuBYHVguThYNSlXit1BgAe54ZexnR6khJOks4RQrAHV01GRII1UmIUsN+WwetTrMo0SPtO2nS0/YDlPNX/68xays/wd9+8aruOq/ktTuYN/fV/pFOBVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tt3hM9g5; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756162751; x=1787698751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQLQIb3lXbdRCTd1qONWSd9/8AzyiqqEAKKCpvPKYpw=;
  b=Tt3hM9g5EyShe5hi8RTg6/4Uq3if3kSKDKbFAJThcYjA37iSzXH5MaeR
   4pgNtc3RDbRc28bd27NuIUtnjB2lF2gS3HCFR0k4JijQ5U5+qUPOVmAcr
   cnG/Y3o/Jod5Oan8FmzMmrr6DdkI38CfYX7DLOgYhrti3DaAoAlrJ8ET6
   em5YfGdYIKciYV0wbJH2GGz4qbrttcKYfJ1sMeTC7lKgOKCYxEBGKQmlE
   Bu/Ez8MI5uwNvO477xooCxUEkO98SBfVVqKXdLlBrLvTxzW9EoF705FRY
   Mtft3Emlf26rXlSx5kmI/XDQbjrQovXVGQyuYrcyYnfoDhBY34bJhhQox
   Q==;
X-CSE-ConnectionGUID: cerAGvNNQOuDTQ2Lm/kiYw==
X-CSE-MsgGUID: dBOck5q6Qq6KbmHZr+z7WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58533344"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58533344"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:10 -0700
X-CSE-ConnectionGUID: U1uN8Z/wSeqwLya4LvjUTw==
X-CSE-MsgGUID: aE5DiH4iR8iG5lU5lR8kFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200308423"
Received: from ldmartin-desk2.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.59])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:59:04 -0700
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
Subject: [PATCH v7 2/7] x86/sme: Use percpu boolean to control WBINVD during kexec
Date: Tue, 26 Aug 2025 10:58:37 +1200
Message-ID: <be288e39bdd03355ba6d8ab10d2cca73606275d9.1756161460.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756161460.git.kai.huang@intel.com>
References: <cover.1756161460.git.kai.huang@intel.com>
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
alive.  The race may happen when native_stop_other_cpus() has to send
NMIs and could potentially result in the system hang (see [1] for more
information).

Link: https://lore.kernel.org/kvm/b963fcd60abe26c7ec5dc20b42f1a2ebbcc72397.1750934177.git.kai.huang@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---

v6 -> v7:
 - Add Boris's RB.

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


