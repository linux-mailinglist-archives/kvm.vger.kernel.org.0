Return-Path: <kvm+bounces-63772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 143B4C7250C
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 84C2F35023B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990C22DF148;
	Thu, 20 Nov 2025 06:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X1FiVMuj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018F2272811;
	Thu, 20 Nov 2025 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619486; cv=none; b=Q0E066HQtj0MgVRvvzqp3laPKQATrJoyt2P3QGlnYTVreed7PYuBr0WrwXR0Lcx7PbmPY/8GKuBvOCYIsIqCOt+LB8cUWZrv3TPsAnrMOVgZXywYXlsf+a5hQv4qI+wWb3/RAFQpk5zI+utZfYdukHIp/2UzkVPGcyiYrR7GM9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619486; c=relaxed/simple;
	bh=P49D+XNj2FfAb2wrhAl3Poi/xPL/yYF86RGfUVYhWOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZM7y2QzMCo1Z2siCQUShkXg2xQIw0pQkQWE+2cnpkG96SXsFExA5INQvD+evDi4XRxypRsPyDbC6frDfACfWZ9ueuh4vcfLNsLix0ux3FvYm9ep7TRuFQILvbX/bW2tXLh/gcl7DWyCtE6tzgFaVpQURrGEUm8xH28cNOu0RB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X1FiVMuj; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619485; x=1795155485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P49D+XNj2FfAb2wrhAl3Poi/xPL/yYF86RGfUVYhWOM=;
  b=X1FiVMujyRvrrph3WkGCKAimDczMsVWEoQms5zhVdYmcqrwvXbg7+4wI
   QGu1MqBpnDl7kXEbxLRYTs7T0YtdcQY6oBfYiRK2zl7r1sFBS/g59XCYD
   BZetb7teLuqk4bKSsOcgk9bL51cDJ9TqkrW9r+2FtiUEDeU6rNu8GrPMA
   SuD4nw7w327MXCc+AS85afqyVQ6bQUBidYpeMwGKND55JF6RToBTQDcPE
   mCEnYrqr8VILpBO7hyVJfjc27+/HgWNk6JdflwM0+Cey87JvzonBXqLjR
   Qw0rGLCoarT1wb2AKf8l14H+9bCwf+DHPju0M+lOSXMu+HDIbcVnEP+vI
   Q==;
X-CSE-ConnectionGUID: n3hkYl4lT1ifjKzATynF9g==
X-CSE-MsgGUID: GE7y3QNVR9aUFAGoykDpJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65713273"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65713273"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:05 -0800
X-CSE-ConnectionGUID: T0J2zFqxSISCe+T4tZhNmg==
X-CSE-MsgGUID: AyflTvtASfK7TuUBcBlHww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191700496"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:04 -0800
Date: Wed, 19 Nov 2025 22:18:03 -0800
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
Subject: [PATCH v4 02/11] x86/bhi: Move the BHB sequence to a macro for reuse
Message-ID: <20251119-vmscape-bhb-v4-2-1adad4e69ddc@linux.intel.com>
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

In preparation to make clear_bhb_loop() work for CPUs with larger BHB, move
the sequence to a macro. This will allow setting the depth of BHB-clearing
easily via arguments.

No functional change intended.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 886f86790b4467347031bc27d3d761d5cc286da1..a62dbc89c5e75b955ebf6d84f20d157d4bce0253 100644
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
@@ -1532,10 +1527,7 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * Note, callers should use a speculation barrier like LFENCE immediately after
  * a call to this function to ensure BHB is cleared before indirect branches.
  */
-SYM_FUNC_START(clear_bhb_loop)
-	ANNOTATE_NOENDBR
-	push	%rbp
-	mov	%rsp, %rbp
+.macro	CLEAR_BHB_LOOP_SEQ
 	movl	$5, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
@@ -1545,15 +1537,16 @@ SYM_FUNC_START(clear_bhb_loop)
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
+	 * This should ideally be: .skip 32 - (.Lret2_\@ - 2f), 0xcc
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
@@ -1564,8 +1557,24 @@ SYM_FUNC_START(clear_bhb_loop)
 	jnz	3b
 	sub	$1, %ecx
 	jnz	1b
-.Lret2:	RET
+.Lret2_\@:
+	RET
 5:
+.endm
+
+/*
+ * This should be used on parts prior to Alder Lake. Newer parts should use the
+ * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
+ * virtualized on newer hardware the VMM should protect against BHI attacks by
+ * setting BHI_DIS_S for the guests.
+ */
+SYM_FUNC_START(clear_bhb_loop)
+	ANNOTATE_NOENDBR
+	push	%rbp
+	mov	%rsp, %rbp
+
+	CLEAR_BHB_LOOP_SEQ
+
 	pop	%rbp
 	RET
 SYM_FUNC_END(clear_bhb_loop)

-- 
2.34.1



