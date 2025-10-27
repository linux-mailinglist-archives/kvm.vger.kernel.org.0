Return-Path: <kvm+bounces-61241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38074C1216C
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33965461A2E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44592330323;
	Mon, 27 Oct 2025 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irRjvZDo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A483A21D011;
	Mon, 27 Oct 2025 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761608636; cv=none; b=RAodLTLSDJy2nGPKEIcsI3Ic/x6LEGjN1/9PZpd+Jj5nZyIzkNfrKp0e+YyVkHqMbrR1ZVhX9UjJFhFLrtUKh9fW2PzaqP7w9ES4f08z9+PH85RMOJ16/v9vpC4fs5497Hx8HkB9eGqkgXdJY0JBzostjS55JrNmtz8Sk1RyMpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761608636; c=relaxed/simple;
	bh=/LCL26vV39UaGLsu5OiJu/WwAyU1M+YxkN2F2ruiYrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzjDM4wZRYWCLDVYsAkzNNz/HY1SPB9ZUn+tZa7ubv2A8FRNYljePOqjz8S0ZSxqSsMd4+lOSgnSU9a61ACj8qhO3/xMu9ZNrl5PSPkmAUE8niniiVibQy2F2urhMOhwntlH4RPWvbkhEez4MHq26/CZl9jSDiuBfMIHMZM9Mkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irRjvZDo; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761608635; x=1793144635;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/LCL26vV39UaGLsu5OiJu/WwAyU1M+YxkN2F2ruiYrI=;
  b=irRjvZDoeztGCdnM/wKnn/QwtKrDUHSm3Ho/WPzda/gdtSdHLc0pioxk
   YnqgpzS50dEEnPsK95iLogUF+jzNPi27IIECuRawRQROPjODcuEQ9dBjX
   pfDUdDhAFH30UHPcCHaMk8zlQO12IGpbFRHAasPTs1Poly5kAT6LO4aLo
   ftwLJjG2kyeowoF+mBTfXVM6BjtHotjddym36zToRmk+VmHewk0q6eejC
   BEnqlGM8oU1PnsMMBgPaaP8w8dCeTcMa5eFmhz+J6JSGvu8gQ/UtmiMcC
   5IrG6OsAwkmJnFvhF62xRrPTBXfIAOltiHFOXiiG1dQtZpJEuSI6nTsNd
   w==;
X-CSE-ConnectionGUID: s2Xi9DEkTkyfLO8DB+xS7g==
X-CSE-MsgGUID: yhSQRNBmQditHpMq02gfIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63589196"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="63589196"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:54 -0700
X-CSE-ConnectionGUID: PTVkikBAT1GiCwDHCuBqJw==
X-CSE-MsgGUID: qgnIbx8aRMumcC/KqPDnbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="222392733"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 16:43:53 -0700
Date: Mon, 27 Oct 2025 16:43:53 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v3 3/3] x86/vmscape: Remove LFENCE from BHB clearing long loop
Message-ID: <20251027-vmscape-bhb-v3-3-5793c2534e93@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>

Long loop is used to clear the branch history when switching from a guest
to host userspace. The LFENCE barrier is not required in this case as ring
transition itself acts as a barrier.

Move the prologue, LFENCE and epilogue out of __CLEAR_BHB_LOOP macro to
allow skipping the LFENCE in the long loop variant. Rename the long loop
function to clear_bhb_long_loop_no_barrier() to reflect the change.

Acked-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 32 ++++++++++++++++++++------------
 arch/x86/include/asm/entry-common.h  |  2 +-
 arch/x86/include/asm/nospec-branch.h |  4 ++--
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f5f62af080d8ec6fe81e4dbe78ce44d08e62aa59..bb456a3c652e97f3a6fe72866b6dee04f59ccc98 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1525,10 +1525,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * Target Selection, rather than taking the slowpath via its_return_thunk.
  */
 .macro	__CLEAR_BHB_LOOP outer_loop_count:req, inner_loop_count:req
-	ANNOTATE_NOENDBR
-	push	%rbp
-	mov	%rsp, %rbp
-
 	movl	$\outer_loop_count, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
@@ -1560,10 +1556,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
 	jnz	1b
 .Lret2_\@:
 	RET
-5:	lfence
-
-	pop	%rbp
-	RET
+5:
 .endm
 
 /*
@@ -1573,7 +1566,15 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * setting BHI_DIS_S for the guests.
  */
 SYM_FUNC_START(clear_bhb_loop)
+	ANNOTATE_NOENDBR
+	push	%rbp
+	mov	%rsp, %rbp
+
 	__CLEAR_BHB_LOOP 5, 5
+
+	lfence
+	pop	%rbp
+	RET
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
@@ -1584,8 +1585,15 @@ STACK_FRAME_NON_STANDARD(clear_bhb_loop)
  * protects the kernel, but to mitigate the guest influence on the host
  * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
  */
-SYM_FUNC_START(clear_bhb_long_loop)
+SYM_FUNC_START(clear_bhb_long_loop_no_barrier)
+	ANNOTATE_NOENDBR
+	push	%rbp
+	mov	%rsp, %rbp
+
 	__CLEAR_BHB_LOOP 12, 7
-SYM_FUNC_END(clear_bhb_long_loop)
-EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
-STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
+
+	pop	%rbp
+	RET
+SYM_FUNC_END(clear_bhb_long_loop_no_barrier)
+EXPORT_SYMBOL_GPL(clear_bhb_long_loop_no_barrier)
+STACK_FRAME_NON_STANDARD(clear_bhb_long_loop_no_barrier)
diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index b629e85c33aa7387042cce60040b8a493e3e6d46..eb2b7303a9c1fc5976388c2a6a3fb7914b553239 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -98,7 +98,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
 			indirect_branch_prediction_barrier();
 		if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
-			clear_bhb_long_loop();
+			clear_bhb_long_loop_no_barrier();
 
 		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 745394be734f3c2b5640c9aef10156fe1d02636b..7f479aaa21313e484e7a0fded0b8b417feb8e2d0 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,9 +388,9 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
-extern void clear_bhb_long_loop(void);
+extern void clear_bhb_long_loop_no_barrier(void);
 #else
-static inline void clear_bhb_long_loop(void) {}
+static inline void clear_bhb_long_loop_no_barrier(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);

-- 
2.34.1



