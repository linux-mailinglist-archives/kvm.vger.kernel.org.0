Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47507D4959
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjJXIJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjJXIIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:08:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98CB10C8;
        Tue, 24 Oct 2023 01:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698134925; x=1729670925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f8WABQscczreYMsh6w/UPybERylFJVbRLTk7MhGIgFg=;
  b=Rheydpeu8NE43qOIfM9foMW0pLFbSwrfrG9p5nSzjA2H/Y7pd1g5Qj9o
   jyhjF72EIiaYJLbeva6BTWIKQV2yXNlZ63ZP5067IExCfLGUoyy6J6DAG
   5dGFcuh754hKMjb6Hv4PA3JN/7u3x+ww3V6HFPRk2tyAz2qje1HxIDIRN
   amaiaZPCs+jErDvJPfI4AFFhnPvUhISyezP2R6NbjZUQulO445LVQUUTC
   dhgf3V3/Tr9V6zmnWN15DbsrQZAu+tkWBb5CrLVvC7jx8qyQ7gyVYYVgU
   9GbgCm0GEMe4CjkR2xURbdjT/d6pG9jvYnwh672V4HOj3XTbaiQSU2z91
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="451239391"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="451239391"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:08:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="734956073"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="734956073"
Received: from zijianw1-mobl.amr.corp.intel.com (HELO desk) ([10.209.109.187])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:08:41 -0700
Date:   Tue, 24 Oct 2023 01:08:40 -0700
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
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH  v2 4/6] x86/bugs: Use ALTERNATIVE() instead of
 mds_user_clear static key
Message-ID: <20231024-delay-verw-v2-4-f1881340c807@linux.intel.com>
X-Mailer: b4 0.12.3
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VERW mitigation at exit-to-user is enabled via a static branch
mds_user_clear. This static branch is never toggled after boot, and can
be safely replaced with an ALTERNATIVE() which is convenient to use in
asm.

Switch to ALTERNATIVE() to use the VERW mitigation late in exit-to-user
path. Also remove the now redundant VERW in exc_nmi() and
arch_exit_to_user_mode().

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/arch/x86/mds.rst       | 39 ++++++++++++++++++++++++++----------
 arch/x86/include/asm/entry-common.h  |  1 -
 arch/x86/include/asm/nospec-branch.h | 12 -----------
 arch/x86/kernel/cpu/bugs.c           | 15 ++++++--------
 arch/x86/kernel/nmi.c                |  2 --
 arch/x86/kvm/vmx/vmx.c               |  2 +-
 6 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/Documentation/arch/x86/mds.rst b/Documentation/arch/x86/mds.rst
index e73fdff62c0a..34b9e476078c 100644
--- a/Documentation/arch/x86/mds.rst
+++ b/Documentation/arch/x86/mds.rst
@@ -95,6 +95,9 @@ The kernel provides a function to invoke the buffer clearing:
 
     mds_clear_cpu_buffers()
 
+Also macro CLEAR_CPU_BUFFERS is meant to be used in ASM late in exit-to-user
+path. This macro works for cases where GPRs can't be clobbered.
+
 The mitigation is invoked on kernel/userspace, hypervisor/guest and C-state
 (idle) transitions.
 
@@ -138,17 +141,31 @@ Mitigation points
 
    When transitioning from kernel to user space the CPU buffers are flushed
    on affected CPUs when the mitigation is not disabled on the kernel
-   command line. The migitation is enabled through the static key
-   mds_user_clear.
-
-   The mitigation is invoked in prepare_exit_to_usermode() which covers
-   all but one of the kernel to user space transitions.  The exception
-   is when we return from a Non Maskable Interrupt (NMI), which is
-   handled directly in do_nmi().
-
-   (The reason that NMI is special is that prepare_exit_to_usermode() can
-    enable IRQs.  In NMI context, NMIs are blocked, and we don't want to
-    enable IRQs with NMIs blocked.)
+   command line. The mitigation is enabled through the feature flag
+   X86_FEATURE_CLEAR_CPU_BUF.
+
+   The mitigation is invoked just before transitioning to userspace after
+   user registers are restored. This is done to minimize the window in
+   which kernel data could be accessed after VERW e.g. via an NMI after
+   VERW.
+
+   Corner case not handled
+   ^^^^^^^^^^^^^^^^^^^^^^^
+   Interrupts returning to kernel don't clear CPUs buffers since the
+   exit-to-user path is expected to do that anyways. But, there could be
+   a case when an NMI is generated in kernel after the exit-to-user path
+   has cleared the buffers. This case is not handled and NMI returning to
+   kernel don't clear CPU buffers because:
+
+   1. It is rare to get an NMI after VERW, but before returning to userspace.
+   2. For an unprivileged user, there is no known way to make that NMI
+      less rare or target it.
+   3. It would take a large number of these precisely-timed NMIs to mount
+      an actual attack.  There's presumably not enough bandwidth.
+   4. The NMI in question occurs after a VERW, i.e. when user state is
+      restored and most interesting data is already scrubbed. Whats left
+      is only the data that NMI touches, and that may or may not be of
+      any interest.
 
 
 2. C-State transition
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce8f50192ae3..7e523bb3d2d3 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -91,7 +91,6 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 
 static __always_inline void arch_exit_to_user_mode(void)
 {
-	mds_user_clear_cpu_buffers();
 	amd_clear_divider();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index c269ee74682c..214d68956d50 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -557,7 +557,6 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-DECLARE_STATIC_KEY_FALSE(mds_user_clear);
 DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
@@ -589,17 +588,6 @@ static __always_inline void mds_clear_cpu_buffers(void)
 	asm volatile("verw %[ds]" : : [ds] "m" (ds) : "cc");
 }
 
-/**
- * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
- *
- * Clear CPU buffers if the corresponding static key is enabled
- */
-static __always_inline void mds_user_clear_cpu_buffers(void)
-{
-	if (static_branch_likely(&mds_user_clear))
-		mds_clear_cpu_buffers();
-}
-
 /**
  * mds_idle_clear_cpu_buffers - Mitigation for MDS vulnerability
  *
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 10499bcd4e39..00aab0c0937f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -111,9 +111,6 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
-/* Control MDS CPU buffer clear before returning to user space */
-DEFINE_STATIC_KEY_FALSE(mds_user_clear);
-EXPORT_SYMBOL_GPL(mds_user_clear);
 /* Control MDS CPU buffer clear before idling (halt, mwait) */
 DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
 EXPORT_SYMBOL_GPL(mds_idle_clear);
@@ -252,7 +249,7 @@ static void __init mds_select_mitigation(void)
 		if (!boot_cpu_has(X86_FEATURE_MD_CLEAR))
 			mds_mitigation = MDS_MITIGATION_VMWERV;
 
-		static_branch_enable(&mds_user_clear);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 
 		if (!boot_cpu_has(X86_BUG_MSBDS_ONLY) &&
 		    (mds_nosmt || cpu_mitigations_auto_nosmt()))
@@ -356,7 +353,7 @@ static void __init taa_select_mitigation(void)
 	 * For guests that can't determine whether the correct microcode is
 	 * present on host, enable the mitigation for UCODE_NEEDED as well.
 	 */
-	static_branch_enable(&mds_user_clear);
+	setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 
 	if (taa_nosmt || cpu_mitigations_auto_nosmt())
 		cpu_smt_disable(false);
@@ -424,7 +421,7 @@ static void __init mmio_select_mitigation(void)
 	 */
 	if (boot_cpu_has_bug(X86_BUG_MDS) || (boot_cpu_has_bug(X86_BUG_TAA) &&
 					      boot_cpu_has(X86_FEATURE_RTM)))
-		static_branch_enable(&mds_user_clear);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
 	else
 		static_branch_enable(&mmio_stale_data_clear);
 
@@ -484,12 +481,12 @@ static void __init md_clear_update_mitigation(void)
 	if (cpu_mitigations_off())
 		return;
 
-	if (!static_key_enabled(&mds_user_clear))
+	if (!boot_cpu_has(X86_FEATURE_CLEAR_CPU_BUF))
 		goto out;
 
 	/*
-	 * mds_user_clear is now enabled. Update MDS, TAA and MMIO Stale Data
-	 * mitigation, if necessary.
+	 * X86_FEATURE_CLEAR_CPU_BUF is now enabled. Update MDS, TAA and MMIO
+	 * Stale Data mitigation, if necessary.
 	 */
 	if (mds_mitigation == MDS_MITIGATION_OFF &&
 	    boot_cpu_has_bug(X86_BUG_MDS)) {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a0c551846b35..ebfff8dca661 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -551,8 +551,6 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
 	if (this_cpu_dec_return(nmi_state))
 		goto nmi_restart;
 
-	if (user_mode(regs))
-		mds_user_clear_cpu_buffers();
 	if (IS_ENABLED(CONFIG_NMI_CHECK_CPU)) {
 		WRITE_ONCE(nsp->idt_seq, nsp->idt_seq + 1);
 		WARN_ON_ONCE(nsp->idt_seq & 0x1);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..24e8694b83fc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7229,7 +7229,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mds_user_clear))
+	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
 		mds_clear_cpu_buffers();
 	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
 		 kvm_arch_has_assigned_device(vcpu->kvm))

-- 
2.34.1


