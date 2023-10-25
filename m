Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB37D60AF
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 06:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjJYEBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 00:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjJYEBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 00:01:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBD8B3;
        Tue, 24 Oct 2023 21:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698206465; x=1729742465;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1dvC3N7YrfARLKq5nUqFeK9TE0Y0MO6GfZ1KuchckAY=;
  b=Oq5qBdu1WHx3kidmX/k+oKWX3+2vt4jcUjf4sfZp8s2vVHCfCdVh7Xyj
   72Q41ndGBeWoZx/UYbdQhrMKa4FcM0uLfD0XcDxHXMwtRjGUDVzzKSHIt
   GrzdigM6dLB5aA2f5GcRVWY9fjqWsYfhbkxkdgKE9BoDaArUHvd4jZ7V/
   TAZmiY74/siYZgMyNgJExRSwYBM7VXk6YK+L3qrkMZb2m356uWh97V+SH
   Pdjpj2pnKizTP+VIyKjbrDeRteVCyPZrew/U2oXOquNwKPlRmgdxX6zOy
   HUOi2EVTlhD1+UOP8P5fI3QaJDDmpGlLlKaNI7voKzsCTCWebEqWSBBi0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="372287488"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="372287488"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 21:01:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="824528049"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="824528049"
Received: from mhans-mobl3.amr.corp.intel.com (HELO desk) ([10.252.132.200])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 21:01:03 -0700
Date:   Tue, 24 Oct 2023 21:00:29 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231025040029.uglv4dwmlnfhcjde@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024103601.GH31411@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 12:36:01PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 24, 2023 at 01:08:21AM -0700, Pawan Gupta wrote:
> 
> > +.macro CLEAR_CPU_BUFFERS
> > +	ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@", X86_FEATURE_CLEAR_CPU_BUF
> > +		/* nopl __KERNEL_DS(%rax) */
> > +		.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;
> > +.Lverw_arg_\@:	.word __KERNEL_DS;
> > +.Ldo_verw_\@:	verw _ASM_RIP(.Lverw_arg_\@);
> > +.Lskip_verw_\@:
> > +.endm
> 
> Why can't this be:
> 
> 	ALTERNATIVE "". "verw _ASM_RIP(mds_verw_sel)", X86_FEATURE_CLEAR_CPU_BUF
> 
> And have that mds_verw_sel thing be out-of-line ? That gives much better
> code for the case where we don't need this.

Overall the code generated with this approach is much better. But, in my
testing I am seeing an issue with runtime patching in 32-bit mode, when
mitigations are off. Instead of NOPs I am seeing random instruction. I
don't see any issue with 64-bit mode.

config1: mitigations=on, 32-bit mode, post-boot

entry_SYSENTER_32:
   ...
   0xc1a3748e <+222>:   pop    %eax
   0xc1a3748f <+223>:   verw   0xc1a38240
   0xc1a37496 <+230>:   sti
   0xc1a37497 <+231>:   sysexit

---------------------------------------------

config2: mitigations=off, 32-bit mode, post-boot

entry_SYSENTER_32:
   ...
   0xc1a3748e <+222>:   pop    %eax
   0xc1a3748f <+223>:   lea    0x0(%esi,%eiz,1),%esi   <---- Doesn't look right
   0xc1a37496 <+230>:   sti
   0xc1a37497 <+231>:   sysexit

---------------------------------------------

config3: 32-bit mode, pre-boot objdump

entry_SYSENTER_32:
   ...
   c8e:       58                      pop    %eax
   c8f:       90                      nop
   c90:       90                      nop
   c91:       90                      nop
   c92:       90                      nop
   c93:       90                      nop
   c94:       90                      nop
   c95:       90                      nop
   c96:       fb                      sti
   c97:       0f 35                   sysexit

These tests were done with below patch:

-----8<-----
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Mon, 23 Oct 2023 15:04:56 -0700
Subject: [PATCH] x86/bugs: Add asm helpers for executing VERW

MDS mitigation requires clearing the CPU buffers before returning to
user. This needs to be done late in the exit-to-user path. Current
location of VERW leaves a possibility of kernel data ending up in CPU
buffers for memory accesses done after VERW such as:

  1. Kernel data accessed by an NMI between VERW and return-to-user can
     remain in CPU buffers ( since NMI returning to kernel does not
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
that can be used in asm. Also make them depend on a new feature flag
X86_FEATURE_CLEAR_CPU_BUF.

Reported-by: Alyssa Milburn <alyssa.milburn@intel.com>
Suggested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 58cb9495e40f..f21fc0f12737 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -308,10 +308,10 @@
 #define X86_FEATURE_SMBA		(11*32+21) /* "" Slow Memory Bandwidth Allocation */
 #define X86_FEATURE_BMEC		(11*32+22) /* "" Bandwidth Monitoring Event Configuration */
 #define X86_FEATURE_USER_SHSTK		(11*32+23) /* Shadow stack support for user mode applications */
-
 #define X86_FEATURE_SRSO		(11*32+24) /* "" AMD BTB untrain RETs */
 #define X86_FEATURE_SRSO_ALIAS		(11*32+25) /* "" AMD BTB untrain RETs through aliasing */
 #define X86_FEATURE_IBPB_ON_VMEXIT	(11*32+26) /* "" Issue an IBPB only on VMEXIT */
+#define X86_FEATURE_CLEAR_CPU_BUF	(11*32+27) /* "" Clear CPU buffers */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index c55cc243592e..ed8218e2d9a7 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -13,6 +13,7 @@
 #include <asm/unwind_hints.h>
 #include <asm/percpu.h>
 #include <asm/current.h>
+#include <asm/segment.h>
 
 /*
  * Call depth tracking for Intel SKL CPUs to address the RSB underflow
@@ -329,6 +330,29 @@
 #endif
 .endm
 
+/*
+ * Macros to execute VERW instruction that mitigate transient data sampling
+ * attacks such as MDS. On affected systems a microcode update overloaded VERW
+ * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
+ *
+ * Note: Only the memory operand variant of VERW clears the CPU buffers.
+ */
+.pushsection .rodata
+.align 64
+mds_verw_sel:
+	.word __KERNEL_DS
+ 	.byte 0xcc
+.align 64
+.popsection
+
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
-- 
2.34.1

