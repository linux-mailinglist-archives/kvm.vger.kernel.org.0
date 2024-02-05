Return-Path: <kvm+bounces-7966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77704849452
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE111C23298
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 07:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817F9125A1;
	Mon,  5 Feb 2024 07:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I8j2E42Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A4111BC;
	Mon,  5 Feb 2024 07:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707117544; cv=none; b=mxhq37LvpkZb7X9YgkPdqoO9vE4pRGOdFgQ+g1dpwfUaRFgVa+k5GUOsiJI7QUpz05TEzZQBHekisgCCYu/39nHnuYq50QtQuxZsYszyWHeLlwMUtNyHxpYRqxmGz3oOUH4ctpDgGshw7uvl9klZZIJx97g7IXG7rNaHNoDFKwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707117544; c=relaxed/simple;
	bh=EesMNqE0ujt4byHeug0Qr3bN30EdDER8F7GBOgLYbeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6dxJrFUcSRAXg8d7VfZavln3duPTl7aRSqfkBSkNau4oLNOGZeP0X1C85KW7PwykvWLOaPgp7+34LXylPFrx432zZigfOhbK+NHpKwwwg7Y8GcJVVVTh3B0w8E8OLGkyY/qVFJH5fEBELvyvOf2aUP3JLdKD7/tbzyCKMJImfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I8j2E42Z; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707117544; x=1738653544;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EesMNqE0ujt4byHeug0Qr3bN30EdDER8F7GBOgLYbeY=;
  b=I8j2E42ZKXUlQ7ObTqA/enXR0+tx8gvEg1k3ZX8Nn814PODOX1KlrqZo
   TiYfBos1lT75TINzueTP/Q7RQAbQgb+HwX/R2fFd6wdA+aFWNQTPWBsR3
   72y9smura5HHHbnI/yKSkLuQC1c8sVrR3cHSnYfs4VR65pnM3BacSabfG
   JAGPCDvN+Yno4aH9Jkw3Lf+xh+9A5Te/EWs1K3o73By0Y6WMBWL8mtDIj
   lC8N8ImscI+pKd/f9v1jO1OYcWmqfPNveDR1zRAz16KKy9sFedviSo79F
   89D0bNt0fJbUlkCPy4g9zcMaUR2tMnCevw3flLYdFrPaKYMxjWEeIsBPn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11557538"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="11557538"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:19:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="909221964"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="909221964"
Received: from tdspence-mobl1.amr.corp.intel.com (HELO desk) ([10.251.0.86])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 23:19:00 -0800
Date: Sun, 4 Feb 2024 23:18:59 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Alyssa Milburn <alyssa.milburn@intel.com>, stable@kernel.org
Subject: [PATCH  v7 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>

MDS mitigation requires clearing the CPU buffers before returning to
user. This needs to be done late in the exit-to-user path. Current
location of VERW leaves a possibility of kernel data ending up in CPU
buffers for memory accesses done after VERW such as:

  1. Kernel data accessed by an NMI between VERW and return-to-user can
     remain in CPU buffers since NMI returning to kernel does not
     execute VERW to clear CPU buffers.
  2. Alyssa reported that after VERW is executed,
     CONFIG_GCC_PLUGIN_STACKLEAK=y scrubs the stack used by a system
     call. Memory accesses during stack scrubbing can move kernel stack
     contents into CPU buffers.
  3. When caller saved registers are restored after a return from
     function executing VERW, the kernel stack accesses can remain in
     CPU buffers(since they occur after VERW).

To fix this VERW needs to be moved very late in exit-to-user path.

In preparation for moving VERW to entry/exit asm code, create macros
that can be used in asm. Also make VERW patching depend on a new feature
flag X86_FEATURE_CLEAR_CPU_BUF.

Reported-by: Alyssa Milburn <alyssa.milburn@intel.com>
Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry.S               | 22 ++++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h | 17 +++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 8c8d38f0cb1d..bd8e77c5a375 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -6,6 +6,9 @@
 #include <linux/export.h>
 #include <linux/linkage.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
+#include <asm/segment.h>
+#include <asm/cache.h>
 
 .pushsection .noinstr.text, "ax"
 
@@ -20,3 +23,22 @@ SYM_FUNC_END(entry_ibpb)
 EXPORT_SYMBOL_GPL(entry_ibpb);
 
 .popsection
+
+/*
+ * Defines the VERW operand that is disguised as entry code so that
+ * it can be referenced with KPTI enabled. This ensures VERW can be
+ * used late in exit-to-user path after page tables are switched.
+ */
+.pushsection .entry.text, "ax"
+
+.align L1_CACHE_BYTES, 0xcc
+SYM_CODE_START_NOALIGN(mds_verw_sel)
+	UNWIND_HINT_UNDEFINED
+	ANNOTATE_NOENDBR
+	.word __KERNEL_DS
+.align L1_CACHE_BYTES, 0xcc
+SYM_CODE_END(mds_verw_sel);
+/* For KVM */
+EXPORT_SYMBOL_GPL(mds_verw_sel);
+
+.popsection
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index fdf723b6f6d0..2b62cdd8dd12 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -95,7 +95,7 @@
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
 #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
-/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
+#define X86_FEATURE_CLEAR_CPU_BUF	( 3*32+18) /* "" Clear CPU buffers using VERW */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 262e65539f83..ec85dfe67123 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -315,6 +315,21 @@
 #endif
 .endm
 
+/*
+ * Macros to execute VERW instruction that mitigate transient data sampling
+ * attacks such as MDS. On affected systems a microcode update overloaded VERW
+ * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
+ *
+ * Note: Only the memory operand variant of VERW clears the CPU buffers.
+ */
+.macro EXEC_VERW
+	verw _ASM_RIP(mds_verw_sel)
+.endm
+
+.macro CLEAR_CPU_BUFFERS
+	ALTERNATIVE "", __stringify(EXEC_VERW), X86_FEATURE_CLEAR_CPU_BUF
+.endm
+
 #else /* __ASSEMBLY__ */
 
 #define ANNOTATE_RETPOLINE_SAFE					\
@@ -536,6 +551,8 @@ DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
 DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
 
+extern u16 mds_verw_sel;
+
 #include <asm/segment.h>
 
 /**

-- 
2.34.1



