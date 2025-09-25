Return-Path: <kvm+bounces-58712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F588B9D497
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 05:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A1141BC27B1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 03:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3682E5B0E;
	Thu, 25 Sep 2025 03:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IfJgIm88"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CA41DE4E0;
	Thu, 25 Sep 2025 03:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758769799; cv=none; b=NbGBz5V5viCBHi7MHQqqwzxXVigtNe00z6oy9bPd4BPm7NRuQ/1HmJ71YARrkx794ATTnCS/eFN8825jk2ARbDypWxYRmRUhfxZcO0SnYAB3j0qFD5rdnjbLRgkiOIesLNhvXku9oFWU1nUpN1fzryFMcPyEbzje8XEhlpPhvlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758769799; c=relaxed/simple;
	bh=EoLnv2veQbDu1IytgGqUEE67+JwY3QnjCQUAEBqcLbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpd+sxVsOHhBQoW5ZSZhKAmUFM/HjtObxG/koDLl7e1kGM9y8YPu7YbdikIBu8WuVcV/AIMAi8ysrZO4EG8rykInoRgGgKJXmROlfBg/RkFbUUKLcDVThmfcsowoa0K/9ovKlwWhNg3lGlrv1aISpLPWbz3GAeZjAnRS0oEEVTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IfJgIm88; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758769797; x=1790305797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EoLnv2veQbDu1IytgGqUEE67+JwY3QnjCQUAEBqcLbs=;
  b=IfJgIm88plNbfyeg8Q9qc1TvuVR5OAjXMgvTS24Y3yEynus8q3VwPHHe
   7v09dft0cyIcRqpItI2q34mHP5Wk1bSumkX4TScHKJuiXkyWgZG4bChd5
   7qZ8Y1zEDcz4eZ6t3yxsMcQv+DPY/x2ji9vegQWj6i0GXSNb0sxRQSUTV
   am6C4r+r74qy4ATAGZgsSqZIZDoyTRG2Ho1Op8hx4z1W3oqgVpEMg3eTw
   zbk1dxg3hu+53A44AZH5TKqiy7WnjCLdsj+t8F6WtRRgx461/roNBQspd
   4tGn6OyMWC/8NzcJisW+n/0F6XPC1O2ZIb3Y1E4TJgnKHg0wZGOvn1PIw
   Q==;
X-CSE-ConnectionGUID: 4Olj6TeiRwu5rSfRWmu11A==
X-CSE-MsgGUID: XopqgdP4T/6kx8qfc2pz0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="83683979"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="83683979"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:56 -0700
X-CSE-ConnectionGUID: Zo6WYOTEQ66OV42RKuwnnQ==
X-CSE-MsgGUID: dneCnMYKQ66fLOvgOkPdYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="214340558"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO desk) ([10.124.220.91])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:55 -0700
Date: Wed, 24 Sep 2025 20:09:54 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear on
 exit to userspace
Message-ID: <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>

IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
indirect branch isolation between guest and host userspace. But, a guest
could still poison the branch history.

To mitigate that, use the recently added clear_bhb_long_loop() to isolate
the branch history between guest and userspace. Add cmdline option
'vmscape=auto' that automatically selects the appropriate mitigation based
on the CPU.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++++
 Documentation/admin-guide/kernel-parameters.txt |  4 ++-
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/include/asm/entry-common.h             | 12 ++++---
 arch/x86/include/asm/nospec-branch.h            |  2 +-
 arch/x86/kernel/cpu/bugs.c                      | 44 ++++++++++++++++++-------
 arch/x86/kvm/x86.c                              |  5 +--
 7 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..13ca98f952f97daeb28194c3873e945b85eda6a1 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -86,6 +86,10 @@ The possible values in this file are:
    run a potentially malicious guest and issues an IBPB before the first
    exit to userspace after VM-exit.
 
+ * 'Mitigation: Clear BHB before exit to userspace':
+
+   As above conditional BHB clearing mitigation is enabled.
+
  * 'Mitigation: IBPB on VMEXIT':
 
    IBPB is issued on every VM-exit. This occurs when other mitigations like
@@ -108,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=`` command line parameter:
 
    Force vulnerability detection and mitigation even on processors that are
    not known to be affected.
+
+ * ``vmscape=auto``:
+
+   Choose the mitigation based on the VMSCAPE variant the CPU is affected by.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5a7a83c411e9c526f8df6d28beb4c784aec3cac9..4596bfcb401f1a89d2dc5ed8c44c83628c9c5dfe 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8048,9 +8048,11 @@
 
 			off		- disable the mitigation
 			ibpb		- use Indirect Branch Prediction Barrier
-					  (IBPB) mitigation (default)
+					  (IBPB) mitigation
 			force		- force vulnerability detection even on
 					  unaffected processors
+			auto		- (default) automatically select IBPB
+			                  or BHB clear mitigation based on CPU
 
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 751ca35386b0ef02ad8413321028c15086b3a552..b7382735165210b006449f9f36f59d97d839cfe2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -496,6 +496,7 @@
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
 #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
+#define X86_FEATURE_CLEAR_BHB_EXIT_TO_USER (21*32+15) /* Clear branch history on exit-to-userspace, see VMSCAPE bug */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..b7b9af1b641385b8283edf2449578ff65e5bd6df 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -94,11 +94,13 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	choose_random_kstack_offset(rdtsc());
 
-	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
-	    this_cpu_read(x86_ibpb_exit_to_user)) {
-		indirect_branch_prediction_barrier();
-		this_cpu_write(x86_ibpb_exit_to_user, false);
+	if (unlikely(this_cpu_read(x86_pred_flush_pending))) {
+		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
+			indirect_branch_prediction_barrier();
+		else if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
+			clear_bhb_long_loop();
+
+		this_cpu_write(x86_pred_flush_pending, false);
 	}
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ad7e9d1b3a70cce1f24697e35cecd7761bb1984a..32d52f32a5e7761fa1988a054a5d40debf67f53f 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -533,7 +533,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
 		: "memory");
 }
 
-DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
+DECLARE_PER_CPU(bool, x86_pred_flush_pending);
 
 static inline void indirect_branch_prediction_barrier(void)
 {
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 36dcfc5105be9acb6d67a0481949ff03874d5f5d..2f1a86d758777f03bb69b0dc60591108c5660f77 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -109,12 +109,11 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 /*
- * Set when the CPU has run a potentially malicious guest. An IBPB will
- * be needed to before running userspace. That IBPB will flush the branch
- * predictor content.
+ * Set when the CPU has run a potentially malicious guest. Indicates that a
+ * branch predictor flush is needed before running userspace.
  */
-DEFINE_PER_CPU(bool, x86_ibpb_exit_to_user);
-EXPORT_PER_CPU_SYMBOL_GPL(x86_ibpb_exit_to_user);
+DEFINE_PER_CPU(bool, x86_pred_flush_pending);
+EXPORT_PER_CPU_SYMBOL_GPL(x86_pred_flush_pending);
 
 u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
 
@@ -3270,13 +3269,15 @@ enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_AUTO,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
+	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
 };
 
 static const char * const vmscape_strings[] = {
-	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
+	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
-	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
-	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
+	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
 };
 
 static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
@@ -3294,6 +3295,8 @@ static int __init vmscape_parse_cmdline(char *str)
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
 		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
+	} else if (!strcmp(str, "auto")) {
+		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}
@@ -3304,14 +3307,28 @@ early_param("vmscape", vmscape_parse_cmdline);
 
 static void __init vmscape_select_mitigation(void)
 {
-	if (cpu_mitigations_off() ||
-	    !boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
-	    !boot_cpu_has(X86_FEATURE_IBPB)) {
+	if (cpu_mitigations_off() || !boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
 		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		return;
 	}
 
-	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO)
+	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER &&
+	    !boot_cpu_has(X86_FEATURE_IBPB)) {
+		pr_err("IBPB not supported, switching to AUTO select\n");
+		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
+	}
+
+	if (vmscape_mitigation != VMSCAPE_MITIGATION_AUTO)
+		return;
+
+	/*
+	 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
+	 * clear sequence. These CPUs are only vulnerable to the BHI variant
+	 * of the VMSCAPE attack.
+	 */
+	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
+		vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
+	else
 		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 }
 
@@ -3331,6 +3348,8 @@ static void __init vmscape_apply_mitigation(void)
 {
 	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
 		setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
+	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER);
 }
 
 #undef pr_fmt
@@ -3422,6 +3441,7 @@ void cpu_bugs_smt_update(void)
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
+	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
 		/*
 		 * Hypervisors can be attacked across-threads, warn for SMT when
 		 * STIBP is not already enabled system-wide.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 706b6fd56d3c5d29e7f9f6816beeebacb5ef68e6..190f193ef90e6615c5b12530f3f0c6632fda9137 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11016,8 +11016,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * set for the CPU that actually ran the guest, and not the CPU that it
 	 * may migrate to.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
-		this_cpu_write(x86_ibpb_exit_to_user, true);
+	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) ||
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
+		this_cpu_write(x86_pred_flush_pending, true);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of

-- 
2.34.1



