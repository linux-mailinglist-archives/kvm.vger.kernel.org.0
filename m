Return-Path: <kvm+bounces-3547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1882F8052A6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8360283B3D
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F8768EB9;
	Tue,  5 Dec 2023 11:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i6iNEMia"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10ED4C;
	Tue,  5 Dec 2023 03:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775297; x=1733311297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uIZltVBi8wI2fdlt/Uk1Bni3bjv6/HHLxi0uq5CIvWc=;
  b=i6iNEMiaEK0spK+TcD7AUm/WImr6AQexme4vVfpnpURZ9KS+JllcbghF
   EPJEdVnbUuUELT4PkDH9sXmQOvLyhn0AZjc6vtKK9eFmBY03si7DEo5/o
   T913qVfd4L1//WaI1WxrNcZmIDbsE69WB0fiP4cVbQwkMp6pe4cMXwF/6
   gn1TANM9FRil97Xl8q/GXxTosYPTll6/Ovhe1HojiBGUI3RAUUBA2XtIM
   KHovAw4lBsf58xYLTfYKVW/dYtxZb+raIGVobfVduaX1F2fuubPUt0eoe
   Ahy4OpCP1ylI+0Rj2KQf6INyQdjgP+3xhh6LdNaTgvQwwMI5pXK8g5st2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942693"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942693"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018193005"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018193005"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:25 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 30/35] x86/entry/calling: Allow PUSH_AND_CLEAR_REGS being used beyond actual entry code
Date: Tue,  5 Dec 2023 02:50:19 -0800
Message-ID: <20231205105030.8698-31-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

PUSH_AND_CLEAR_REGS could be used besides actual entry code; in that case
%rbp shouldn't be cleared (otherwise the frame pointer is destroyed) and
UNWIND_HINT shouldn't be added.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/calling.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index e59d3073e7cf..a023d9a97cd2 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -65,7 +65,7 @@ For 32-bit we have the following conventions - kernel is built with
  * for assembly code:
  */
 
-.macro PUSH_REGS rdx=%rdx rcx=%rcx rax=%rax save_ret=0
+.macro PUSH_REGS rdx=%rdx rcx=%rcx rax=%rax save_ret=0 unwind_hint=1
 	.if \save_ret
 	pushq	%rsi		/* pt_regs->si */
 	movq	8(%rsp), %rsi	/* temporarily store the return address in %rsi */
@@ -87,14 +87,17 @@ For 32-bit we have the following conventions - kernel is built with
 	pushq	%r13		/* pt_regs->r13 */
 	pushq	%r14		/* pt_regs->r14 */
 	pushq	%r15		/* pt_regs->r15 */
+
+	.if \unwind_hint
 	UNWIND_HINT_REGS
+	.endif
 
 	.if \save_ret
 	pushq	%rsi		/* return address on top of stack */
 	.endif
 .endm
 
-.macro CLEAR_REGS
+.macro CLEAR_REGS clear_bp=1
 	/*
 	 * Sanitize registers of values that a speculation attack might
 	 * otherwise want to exploit. The lower registers are likely clobbered
@@ -109,7 +112,9 @@ For 32-bit we have the following conventions - kernel is built with
 	xorl	%r10d, %r10d	/* nospec r10 */
 	xorl	%r11d, %r11d	/* nospec r11 */
 	xorl	%ebx,  %ebx	/* nospec rbx */
+	.if \clear_bp
 	xorl	%ebp,  %ebp	/* nospec rbp */
+	.endif
 	xorl	%r12d, %r12d	/* nospec r12 */
 	xorl	%r13d, %r13d	/* nospec r13 */
 	xorl	%r14d, %r14d	/* nospec r14 */
@@ -117,9 +122,9 @@ For 32-bit we have the following conventions - kernel is built with
 
 .endm
 
-.macro PUSH_AND_CLEAR_REGS rdx=%rdx rcx=%rcx rax=%rax save_ret=0
-	PUSH_REGS rdx=\rdx, rcx=\rcx, rax=\rax, save_ret=\save_ret
-	CLEAR_REGS
+.macro PUSH_AND_CLEAR_REGS rdx=%rdx rcx=%rcx rax=%rax save_ret=0 clear_bp=1 unwind_hint=1
+	PUSH_REGS rdx=\rdx, rcx=\rcx, rax=\rax, save_ret=\save_ret unwind_hint=\unwind_hint
+	CLEAR_REGS clear_bp=\clear_bp
 .endm
 
 .macro POP_REGS pop_rdi=1
-- 
2.43.0


