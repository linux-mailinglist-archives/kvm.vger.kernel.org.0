Return-Path: <kvm+bounces-63778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F27C9C72524
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:21:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 65065354741
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323BE2DF148;
	Thu, 20 Nov 2025 06:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jCzd2iC/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD4283151;
	Thu, 20 Nov 2025 06:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619579; cv=none; b=ia1IhF9TS8z12e07hWtSZIAsRvetYJF6ssBFKV/icnFZCTPgYBjspVmE0czempozwzlN1g/4uGZ4i5q7Wf1sSC3+lUrOnjkyDym8ztVgAv3QpYovEQUEGK3HEggUWYi4OgZ0EY7xWiQe9RNcqb6u2XOorwljs265UlCDCRMk1VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619579; c=relaxed/simple;
	bh=Z/nsdGQiF6DtXgACWfa5M2hYz2xzZefNlC797ixTlDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWFnoCgJGfzQ8wM5ayfyG3uLvHcPpPR5jteFBRomVKtQoG/vAnrpgDUkxlEItc/z0uESUJPvh+bW/wvUhUNznCybcwuOxQU9VB4ofycwexQej0y60MWsmbxlvkQmK9DH48lyL7n9spQ/4iYFE2SnC2M8R49VS7y+LJ/OaEldgrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jCzd2iC/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619578; x=1795155578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z/nsdGQiF6DtXgACWfa5M2hYz2xzZefNlC797ixTlDQ=;
  b=jCzd2iC/DnH81yaMDJ+mq2LRdy1XYjvPS350hGweah2oNM5FA25KeM0A
   NqzUGND8znjaOoiBW6RRUREgA7lw+5HH5BW0RM3AQ9VUjxhqymNFM+6ka
   +alffEChGhWE68RrXMY5sT34zkrq5oqcYSPMVBlj/QIcjBDZhMUqGw/fB
   +jdFuPu/SVumiAaKBYZ6Smig9AsM9rd0ZMhn1FgWqfbis62Sx4wsbM0Vo
   mMGpdzh/prwe08f/FPoy2wHOKrz5AgRhKRDXixgFObVxiIl29JptBhDSm
   m0MmD96bZhtRBMyV3nR5oR82irEt39iu9RJdfmxapcx70YY3ubJMGW6Gk
   Q==;
X-CSE-ConnectionGUID: rSQe/8APSEWgiQofTFt/XA==
X-CSE-MsgGUID: VN6/pYkKQ1S5wOksHC48zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="77142854"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="77142854"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:37 -0800
X-CSE-ConnectionGUID: wnL8x1ToQLuE3c7kZHiu6g==
X-CSE-MsgGUID: w95QrIpHQOayypOvUuPJ3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="195570824"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:36 -0800
Date: Wed, 19 Nov 2025 22:19:36 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v4 08/11] x86/vmscape: Use static_call() for predictor flush
Message-ID: <20251119-vmscape-bhb-v4-8-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

Adding more mitigation options at exit-to-userspace for VMSCAPE would
usually require a series of checks to decide which mitigation to use. In
this case, the mitigation is done by calling a function, which is decided
at boot. So, adding more feature flags and multiple checks can be avoided
by using static_call() to the mitigating function.

Replace the flag-based mitigation selector with a static_call(). This also
frees the existing X86_FEATURE_IBPB_EXIT_TO_USER.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/Kconfig                     | 1 +
 arch/x86/include/asm/cpufeatures.h   | 2 +-
 arch/x86/include/asm/entry-common.h  | 7 +++----
 arch/x86/include/asm/nospec-branch.h | 3 +++
 arch/x86/kernel/cpu/bugs.c           | 5 ++++-
 arch/x86/kvm/x86.c                   | 2 +-
 6 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa3b616af03a2d50eaf5f922bc8cd4e08a284045..066f62f15e67e85fda0f3fd66acabad9a9794ff8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2706,6 +2706,7 @@ config MITIGATION_TSA
 config MITIGATION_VMSCAPE
 	bool "Mitigate VMSCAPE"
 	depends on KVM
+	select HAVE_STATIC_CALL
 	default y
 	help
 	  Enable mitigation for VMSCAPE attacks. VMSCAPE is a hardware security
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..02871318c999f94ec8557e5fb0b8fb299960d454 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -496,7 +496,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
-#define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
+/* Free */
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
 
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index 78b143673ca72642149eb2dbf3e3e31370fe6b28..783e7cb50caeb6c6fc68e0a5c75ab43e75e37116 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -4,6 +4,7 @@
 
 #include <linux/randomize_kstack.h>
 #include <linux/user-return-notifier.h>
+#include <linux/static_call_types.h>
 
 #include <asm/nospec-branch.h>
 #include <asm/io_bitmap.h>
@@ -94,10 +95,8 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	choose_random_kstack_offset(rdtsc());
 
-	/* Avoid unnecessary reads of 'x86_predictor_flush_exit_to_user' */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
-	    this_cpu_read(x86_predictor_flush_exit_to_user)) {
-		write_ibpb();
+	if (unlikely(this_cpu_read(x86_predictor_flush_exit_to_user))) {
+		static_call_cond(vmscape_predictor_flush)();
 		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
 }
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index df60f9cf51b84e5b75e5db70713188d2e6ad0f5d..15a2fa8f2f48a066e102263513eff9537ac1d25f 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -540,6 +540,9 @@ static inline void indirect_branch_prediction_barrier(void)
 			    :: "rax", "rcx", "rdx", "memory");
 }
 
+#include <linux/static_call_types.h>
+DECLARE_STATIC_CALL(vmscape_predictor_flush, write_ibpb);
+
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 233594ede19bf971c999f4d3cc0f6f213002c16c..cbb3341b9a19f835738eda7226323d88b7e41e52 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -200,6 +200,9 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
 EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
 
+DEFINE_STATIC_CALL_NULL(vmscape_predictor_flush, write_ibpb);
+EXPORT_STATIC_CALL_GPL(vmscape_predictor_flush);
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"mitigations: " fmt
 
@@ -3274,7 +3277,7 @@ static void __init vmscape_update_mitigation(void)
 static void __init vmscape_apply_mitigation(void)
 {
 	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
-		setup_force_cpu_cap(X86_FEATURE_IBPB_EXIT_TO_USER);
+		static_call_update(vmscape_predictor_flush, write_ibpb);
 }
 
 #undef pr_fmt
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60123568fba85c8a445f9220d3f4a1d11fd0eb77..7e55ef3b3203a26be1a138c8fa838a8c5aae0125 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11396,7 +11396,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * set for the CPU that actually ran the guest, and not the CPU that it
 	 * may migrate to.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
+	if (static_call_query(vmscape_predictor_flush))
 		this_cpu_write(x86_predictor_flush_exit_to_user, true);
 
 	/*

-- 
2.34.1



