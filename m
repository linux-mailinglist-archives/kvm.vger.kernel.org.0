Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55028750230
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjGLI5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjGLI44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:56:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F7AFB;
        Wed, 12 Jul 2023 01:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152179; x=1720688179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZZnS4qYKEmMkuj/bTVIMjbuKRqrLk9IATDNJFNB5kyo=;
  b=dmdKqcXkULA9O/kFBSm752ZEMMohLh2+KLJEQox56hS3ObFjqQ5aXRJ9
   NmfZmDmbwwVIbhk1xH+im+9tGhWocDPWiFgeCoeUNsvIfX/XpiVk2SPjP
   4+lQ7/Hxg33LmAdUNPBaq+CujC9Bl0SOm3bDhfGlAGxImvWDKdJcO3L0n
   2U8ZH0pfHyR5q4OFT2GlEoO4S5CR0vtGokrqfHLyB7X6PtACZqqaWJcWE
   3lGgG4SkKwlLfzFLCQGv5/5mPEituq4KRlb+4rH40AS2gHmv+i0NR+jTS
   TU+GQpvhE+KBTMpjWYokB9Nn882SaAZtj05PpHCA/5OdS2RfYfC8uWSZ3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439344"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439344"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573421"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573421"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:10 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 10/10] x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
Date:   Wed, 12 Jul 2023 20:55:24 +1200
Message-ID: <d08c5e27dd7377564d69648f3eb7b56d3c95b84b.1689151537.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1689151537.git.kai.huang@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On the platform with the "partial write machine check" erratum, a kernel
partial write to TDX private memory may cause unexpected machine check.
It would be nice if the #MC handler could print additional information
to show the #MC was TDX private memory error due to possible kernel bug.

To do that, the machine check handler needs to use SEAMCALL to query
page type of the error memory from the TDX module, because there's no
existing infrastructure to track TDX private pages.

SEAMCALL instruction causes #UD if CPU isn't in VMX operation.  In #MC
handler, it is legal that CPU isn't in VMX operation when making this
SEAMCALL.  Extend the TDX_MODULE_CALL macro to handle #UD so the
SEAMCALL can return error code instead of Oops in the #MC handler.
Opportunistically handles #GP too since they share the same code.

A bonus is when kernel mistakenly calls SEAMCALL when CPU isn't in VMX
operation, or when TDX isn't enabled by the BIOS, or when the BIOS is
buggy, the kernel can get a nicer error message rather than a less
understandable Oops.

This is basically based on Peter's code.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/tdx.h      |  5 +++++
 arch/x86/virt/vmx/tdx/tdxcall.S | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a82e5249d079..feb85316346e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -8,6 +8,8 @@
 #include <asm/ptrace.h>
 #include <asm/shared/tdx.h>
 
+#include <asm/trapnr.h>
+
 /*
  * SW-defined error codes.
  *
@@ -18,6 +20,9 @@
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
 
+#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
+#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index e4e90ebf5dad..04b0c466f38c 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -2,6 +2,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/frame.h>
 #include <asm/tdx.h>
+#include <asm/asm.h>
 
 /*
  * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
@@ -85,6 +86,7 @@
 	.endif	/* \saved */
 
 	.if \host
+1:
 	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -99,6 +101,7 @@
 	 */
 	mov $TDX_SEAMCALL_VMFAILINVALID, %rdi
 	cmovc %rdi, %rax
+2:
 	.else
 	tdcall
 	.endif
@@ -185,4 +188,21 @@
 
 	FRAME_END
 	RET
+
+	.if \host
+3:
+	/*
+	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
+	 * the trap number.  Convert the trap number to the TDX error
+	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
+	 *
+	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
+	 * only accepts 32-bit immediate at most.
+	 */
+	movq $TDX_SW_ERROR, %r12
+	orq  %r12, %rax
+	jmp  2b
+
+	_ASM_EXTABLE_FAULT(1b, 3b)
+	.endif	/* \host */
 .endm
-- 
2.41.0

