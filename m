Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719F57D9B9B
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345974AbjJ0OjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 10:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345876AbjJ0OjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 10:39:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537E2DE;
        Fri, 27 Oct 2023 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698417539; x=1729953539;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PE5fU1agwGvIYR6WvOaWH9GVoG/TbRgWJmFahYBu+3E=;
  b=W91o8T+OFJe/GWkmC5yEGIfpYejsOutjiDN0hOcrJ8nxXEKCSzJDDKiw
   v05OKruP/gBwbcBL4eDc4rfgudKP6Nyj/7mHi8ZDZpvWO+tbGuuSbVlyl
   eort2OLe81g79DRQxFh8ak0xtHazucaBBmOQls+2D1kR5pZZYBfn5BipL
   GtJVM07eytSsKUnaV5efvkYdam0RLyBDr8Umxq27000uY2f5hymqrAlhk
   61EPGQLz7a/iI0YtkRMa7SqpjVOUUMSnOtww7C74TliLqQt5S4je+jkke
   acyT9ouHYoO6w0BN/laURUYHE4dAz2Cwug0ukLXtftRIMuCuV70kkw6ml
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="386670113"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="386670113"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:38:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="812619"
Received: from dmnassar-mobl.amr.corp.intel.com (HELO desk) ([10.212.203.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 07:38:06 -0700
Date:   Fri, 27 Oct 2023 07:38:40 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: [PATCH  v4 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231027-delay-verw-v4-1-9a3622d4bcf7@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry.S               | 17 +++++++++++++++++
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h | 15 +++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index bfb7bcb362bc..8dc84bb9dc0b 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -6,6 +6,9 @@
 #include <linux/linkage.h>
 #include <asm/export.h>
 #include <asm/msr-index.h>
+#include <asm/unwind_hints.h>
+#include <asm/segment.h>
+#include <asm/cache.h>
 
 .pushsection .noinstr.text, "ax"
 
@@ -20,3 +23,17 @@ SYM_FUNC_END(entry_ibpb)
 EXPORT_SYMBOL_GPL(entry_ibpb);
 
 .popsection
+
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
index c55cc243592e..005e69f93115 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -329,6 +329,21 @@
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

-- 
2.34.1


