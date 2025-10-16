Return-Path: <kvm+bounces-60121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC0DBE1335
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 03:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A339D4EABBD
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 01:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369DF1EEA5D;
	Thu, 16 Oct 2025 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BDr/AgIe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0F21DE2D7;
	Thu, 16 Oct 2025 01:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760579550; cv=none; b=jEgyZgyb+5BQLMI5Hbvk3Jm0e45BDvS5AaAQr/uf6zM1nC0wml9C1Qvfb+lrky/nf4cylrztMADb6Yd1cm1uaO6W0iHzXOdkdSnnwwxh3DxBu330Uh4RnFz0Az/dVxtYXnn8ZQIzLOjg96/sDKNZhtGnHLnc4twi1kwh0htpnVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760579550; c=relaxed/simple;
	bh=woq5C4XAhmSCnRFLmSIdNScVyP7bE3LD7+vv5yYzPoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j95oAWHW89H5JP0lQUouR3o1Y7NjVt285FPJrD75CCwjV7gKQaWohumjf1n1aZJUkeg2tvaGQU0+7Wns5VfBI+bH2ZVcywmHLNFrIGl3BBy2qvFMyesrkNcI28KBdLVSGMoT39qD1fli86vTIsg3SzpatTsxC6SLeNvYervMTpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BDr/AgIe; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760579548; x=1792115548;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=woq5C4XAhmSCnRFLmSIdNScVyP7bE3LD7+vv5yYzPoI=;
  b=BDr/AgIe/si8j4LPeH7dn9Z3R1SYvS/3Los3qatF3CRu5BX/7KNs3bVy
   /5YcsllfgQPuA9JhJ6Qd8oEovEx6wfI8ktgUkUnRwl/9nJxCxevz+M7Yn
   bnPmFRYsFBQHTXVvMo6Q2rR0vYH0B0ucy1jcltbuh8KBLUb10ieeONyGb
   IygoRJYK1VOEgAhqZRmVCbJSiD3eo1j85+atnCD8a0lrciO1c2j84yPLh
   WswVFulRN6jyGEA64hTPBmcGJSZWG/BlhLn2D4wz+D3AayFmeWp547Ifx
   FNkAxVdtkIG4ppr/7dNW5MMF7k95uqChBdgdKfk4gVS3yegVAms/OPFb1
   w==;
X-CSE-ConnectionGUID: q4uoiG2qQIKIclfMFXcMbA==
X-CSE-MsgGUID: HRcj0vCUQeeuWKU79ARexA==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="74210615"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="74210615"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:52:28 -0700
X-CSE-ConnectionGUID: 3QTDFGsRTXKxD/kDsPowPg==
X-CSE-MsgGUID: FkJkE/UQR9e5Ry2TOuVj3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="182001111"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO desk) ([10.124.223.20])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:52:26 -0700
Date: Wed, 15 Oct 2025 18:52:26 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v2 3/3] x86/vmscape: Remove LFENCE from BHB clearing long loop
Message-ID: <20251015-vmscape-bhb-v2-3-91cbdd9c3a96@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>

Long loop is used to clear the branch history when switching from a guest
to host userspace. The LFENCE barrier is not required in this case as ring
transition itself acts as a barrier.

Move the prologue, LFENCE and epilogue out of __CLEAR_BHB_LOOP macro to
allow skipping the LFENCE in the long loop variant. Rename the long loop
function to clear_bhb_long_loop_no_barrier() to reflect the change.

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
index b7b9af1b641385b8283edf2449578ff65e5bd6df..c70454bdd0e3f544dedf582ad6f7f62e2833704c 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -98,7 +98,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 		if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
 			indirect_branch_prediction_barrier();
 		else if (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_EXIT_TO_USER))
-			clear_bhb_long_loop();
+			clear_bhb_long_loop_no_barrier();
 
 		this_cpu_write(x86_pred_flush_pending, false);
 	}
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 00730cc22c2e7115f6dbb38a1ed8d10383ada5c0..3bcf9f180c21d468f17fa9c1210cba84a541e6ea 100644
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



