Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CBF7D494E
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjJXIIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbjJXII2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:08:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8ED7E;
        Tue, 24 Oct 2023 01:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698134903; x=1729670903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eA6CRDmNCGN8nFcWCJ9NGvgTusdz/Jy5pUn40Hz7ZCQ=;
  b=fCI5DppnRmZUaIpSjqHmrjDPrrBr723EeN+1LWDJ+nidCk0DVPOJCmLk
   w6KY2tz6YROtqplXz8nQ53FSLo2e3gJ2IGVT6XXMaFCZ9LPACe8J8JBS1
   EjCr+SxCGGj9qZ5dz5dtV7MfIaS8ND0GU6S5TGEPyCYakKceXWouDHf/9
   hUbsoaqJ0Uo5WutB7wBD/MjSRqhycYRtq6MS/q2a154bH4oifrlTvjfJt
   4GWW+i+ZQMuv7zlseK85DqfaST0nxE/KwuqMLOMdmr5fH68Jow78dc41y
   z56R+NPxjwaxNCzK/4Zn1oJ9bMAy3NjbdkkLHLIebBFmY83BvosYHj7xv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="418134603"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="418134603"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="762020201"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="762020201"
Received: from zijianw1-mobl.amr.corp.intel.com (HELO desk) ([10.209.109.187])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:08:22 -0700
Date:   Tue, 24 Oct 2023 01:08:21 -0700
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
        ak@linux.intel.com, tim.c.chen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

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
index c55cc243592e..c269ee74682c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -329,6 +329,25 @@
 #endif
 .endm
 
+/*
+ * Macro to execute VERW instruction to mitigate transient data sampling
+ * attacks such as MDS. On affected systems a microcode update overloaded VERW
+ * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
+ *
+ * Note: Only the memory operand variant of VERW clears the CPU buffers. To
+ * handle the case when VERW is executed after user registers are restored, use
+ * RIP to point the memory operand to a part NOPL instruction that contains
+ * __KERNEL_DS.
+ */
+.macro CLEAR_CPU_BUFFERS
+	ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@", X86_FEATURE_CLEAR_CPU_BUF
+		/* nopl __KERNEL_DS(%rax) */
+		.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;
+.Lverw_arg_\@:	.word __KERNEL_DS;
+.Ldo_verw_\@:	verw _ASM_RIP(.Lverw_arg_\@);
+.Lskip_verw_\@:
+.endm
+
 #else /* __ASSEMBLY__ */
 
 #define ANNOTATE_RETPOLINE_SAFE					\

-- 
2.34.1


