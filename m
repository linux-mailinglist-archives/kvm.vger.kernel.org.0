Return-Path: <kvm+bounces-58711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A37B9D48C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 05:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD65516BFE4
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 03:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE09A2E6CD7;
	Thu, 25 Sep 2025 03:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8Ko6dqE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE12E55A;
	Thu, 25 Sep 2025 03:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758769783; cv=none; b=rjYFLnialpxseHadO8jhUR8DtpDfgyF+30RNetCA2PFsNQaLUSSx4f3nBEP49wrNdbvfvOB9wOrU4v2JWF4zhgMGEUJsuqWOiX9viPCWCtYIfWgQ+VXZ0FeWQ1lrxsap0zAc2ctjhLwOWWebnV9yw/GuBmob3hhONlsSKy2ePkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758769783; c=relaxed/simple;
	bh=mWLDZMPMofTAYaYx2sVpFnjZtnEhoi3zJS0yIoUqJ4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RloUxJWxtuQCgZlwtgP/amlnX5kFIm69Q2tLG4rNs8VlKYXkw1PA0b8AHwBR3T5sJeu64YWkOu3OCTvnptse4fyVogv7aF+5IplwmDMtCOqImt+YDaIPoi3FtreudIQPbUq3H97mbIEk1J2eUnWGXmYrrRTeH2jwJt5bHLVeHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8Ko6dqE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758769781; x=1790305781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mWLDZMPMofTAYaYx2sVpFnjZtnEhoi3zJS0yIoUqJ4s=;
  b=j8Ko6dqElrbo/Y9dAH/J/xqTVyV1XILN/hnUDbxf/KWlWMVSF2hKfwmQ
   QUtpw8lGNKNsDXNcRZhzeiBY7Qtm1qs5HbJMmz1+26riKp1ta1xelnZ8c
   K53FHSTNrV8dqEBWOgF6TchdwgGxZiWDKT2JnCEk4YKXxq8Q0fm8Bbl+q
   KUVB5F/+J0I3aqH4nzFvQ+L+1po3Fnefwb1bMpYRlh2COm8ncjLMC3DUl
   BMladlwGukB+ecBEOW7QuE2hF0hFKQwDC3wKzkhO2iZMD/ReIE6fciEIO
   cGjKjeRuvJdsLbx0431Q2nUu3w46Gyzd7Vhin53ppm52N79EGQzUTCPCL
   w==;
X-CSE-ConnectionGUID: u9vvbhzeRCyyfQFMsy4kBA==
X-CSE-MsgGUID: /kd9c3AOSFOBqhKQR7IbWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="83683953"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="83683953"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:40 -0700
X-CSE-ConnectionGUID: jDiDMIvqSpeplCT6ZTJG1A==
X-CSE-MsgGUID: Mu8eTuKfRcK729aS6lEbWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="214340547"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO desk) ([10.124.220.91])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:09:39 -0700
Date: Wed, 24 Sep 2025 20:09:38 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH 1/2] x86/bhi: Add BHB clearing for CPUs with larger branch
 history
Message-ID: <20250924-vmscape-bhb-v1-1-da51f0e1934d@linux.intel.com>
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

Add a version of clear_bhb_loop() that works on CPUs with larger branch
history table such as Alder Lake and newer. This could serve as a cheaper
alternative to IBPB mitigation for VMSCAPE.

clear_bhb_loop() and the new clear_bhb_long_loop() only differ in the loop
counter. Convert the asm implementation of clear_bhb_loop() into a macro
that is used by both the variants, passing counter as an argument.

There is no difference in the output of:

  $ objdump --disassemble=clear_bhb_loop vmlinux

before and after this commit.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 47 ++++++++++++++++++++++++++----------
 arch/x86/include/asm/nospec-branch.h |  3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ed04a968cc7d0095ab0185b2e3b5beffb7680afd..f5f62af080d8ec6fe81e4dbe78ce44d08e62aa59 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1499,11 +1499,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * from the branch history tracker in the Branch Predictor, therefore removing
  * user influence on subsequent BTB lookups.
  *
- * It should be used on parts prior to Alder Lake. Newer parts should use the
- * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
- * virtualized on newer hardware the VMM should protect against BHI attacks by
- * setting BHI_DIS_S for the guests.
- *
  * CALLs/RETs are necessary to prevent Loop Stream Detector(LSD) from engaging
  * and not clearing the branch history. The call tree looks like:
  *
@@ -1529,11 +1524,12 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * that all RETs are in the second half of a cacheline to mitigate Indirect
  * Target Selection, rather than taking the slowpath via its_return_thunk.
  */
-SYM_FUNC_START(clear_bhb_loop)
+.macro	__CLEAR_BHB_LOOP outer_loop_count:req, inner_loop_count:req
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
-	movl	$5, %ecx
+
+	movl	$\outer_loop_count, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1542,29 +1538,54 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * Shift instructions so that the RET is in the upper half of the
 	 * cacheline and don't take the slowpath to its_return_thunk.
 	 */
-	.skip 32 - (.Lret1 - 1f), 0xcc
+	.skip 32 - (.Lret1_\@ - 1f), 0xcc
 	ANNOTATE_INTRA_FUNCTION_CALL
 1:	call	2f
-.Lret1:	RET
+.Lret1_\@:
+	RET
 	.align 64, 0xcc
 	/*
-	 * As above shift instructions for RET at .Lret2 as well.
+	 * As above shift instructions for RET at .Lret2_\@ as well.
 	 *
-	 * This should be ideally be: .skip 32 - (.Lret2 - 2f), 0xcc
+	 * This should be ideally be: .skip 32 - (.Lret2_\@ - 2f), 0xcc
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	$\inner_loop_count, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax
 	jnz	3b
 	sub	$1, %ecx
 	jnz	1b
-.Lret2:	RET
+.Lret2_\@:
+	RET
 5:	lfence
+
 	pop	%rbp
 	RET
+.endm
+
+/*
+ * This should be used on parts prior to Alder Lake. Newer parts should use the
+ * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
+ * virtualized on newer hardware the VMM should protect against BHI attacks by
+ * setting BHI_DIS_S for the guests.
+ */
+SYM_FUNC_START(clear_bhb_loop)
+	__CLEAR_BHB_LOOP 5, 5
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
+
+/*
+ * A longer version of clear_bhb_loop to ensure that the BHB is cleared on CPUs
+ * with larger branch history tables (i.e. Alder Lake and newer). BHI_DIS_S
+ * protects the kernel, but to mitigate the guest influence on the host
+ * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
+ */
+SYM_FUNC_START(clear_bhb_long_loop)
+	__CLEAR_BHB_LOOP 12, 7
+SYM_FUNC_END(clear_bhb_long_loop)
+EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
+STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index e29f82466f4323aeb2daedb876a34cf686016549..ad7e9d1b3a70cce1f24697e35cecd7761bb1984a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,6 +388,9 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+extern void clear_bhb_long_loop(void);
+#else
+static inline void clear_bhb_long_loop(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);

-- 
2.34.1



