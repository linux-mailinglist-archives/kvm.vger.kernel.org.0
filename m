Return-Path: <kvm+bounces-65078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF35EC9A3AE
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D963A6343
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D195A302161;
	Tue,  2 Dec 2025 06:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="my6H27dV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E577830147D;
	Tue,  2 Dec 2025 06:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656418; cv=none; b=qySOKw2RRSzOqMx08pZi2jqWqS4DVvAa46r/Fe0a7ivBual7AgP67y0IVP4bNEooVWhe2nqWkWAY5fAh7+3VaIEJVXCfadq/a2aTXiIYZkmpkGQu6zFwrdw1ELVuedEaDvfeUGPobM1lM8UWBmpbVovfpsaCeRn4D6fDu7Qu1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656418; c=relaxed/simple;
	bh=oocrIPR6C+2DQH6c7yeWH8JPDaIMIcXBefjYt1+BAho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWI139X0AcYYXoiyTTO3FFJ9v1T79sk7RZjV/Y4BN1g4fck2TpDleuVj6kjie6Di6Wxs8TEABe7uJBBcFNtqvyTPUPgIfgbUbWFffHEroZ7z3BF6dBKggM2w5qXSUJYCdG0V0qGv88Jrp9cpVIJdGIgj2gaqNi717ZsWcMxhX+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=my6H27dV; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656417; x=1796192417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oocrIPR6C+2DQH6c7yeWH8JPDaIMIcXBefjYt1+BAho=;
  b=my6H27dVFdpAQP090YFO6+1E3my8aqOncagfP32HrNc+K0QSiA6FvGJT
   BsQP5WiV4NqIH4kBg2e9B0VXI7dIct1zBDfS8TxhBFn9qxSGbqC7TNn5X
   8eyN04oMKZS8FJ/Kg8w9/YZWxPYxI8hS1GzQEDiZ2j/GrmDqoB9ZwRiop
   Eywo6PDrXEtXm/l8I1sVXPrDd+CEYt6pBv2rwkWAOI9dnckTS+WJkG7mQ
   X2JKWMQHPladYocP3Zc9e5IAup+11U3HMTEDXX0YwlPIFl/LMiLI1cTWO
   Lm2pct4w8E7pGXOB0URRGHFm/6ZRgjDgarer+ZEyZHzX0r505KsMCYjdG
   Q==;
X-CSE-ConnectionGUID: 3AUS9kddRdynKxXopP6SMQ==
X-CSE-MsgGUID: n3Zo1xuCTuiCWgFWxruEpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66499174"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="66499174"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:16 -0800
X-CSE-ConnectionGUID: +X+p83W5SaeSbx7UsBsxbw==
X-CSE-MsgGUID: Yuih8XwoQ069Ytetxyz/KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="193960127"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:16 -0800
Date: Mon, 1 Dec 2025 22:20:14 -0800
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
Subject: [PATCH v6 6/9] x86/vmscape: Use static_call() for predictor flush
Message-ID: <20251201-vmscape-bhb-v6-6-d610dd515714@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>

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
index 71865b9d2c5c18cd0cf3cb8bbf07d1576cd20498..71a35a153c1eb852438d533fc8ad76eefaca3219 100644
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
 
@@ -3276,7 +3279,7 @@ static void __init vmscape_update_mitigation(void)
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



