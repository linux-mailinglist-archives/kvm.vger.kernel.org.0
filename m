Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E458173E1DC
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjFZOR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjFZORE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:17:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6841984;
        Mon, 26 Jun 2023 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788977; x=1719324977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aUMKWf1P6Io805CmABy5YQpEPitiSlwsBehX9i/r0CA=;
  b=R7KsmDVarrNYWv+4+A0iJd0Vz4AC0qOED51++5JTqrbTKtyfYlRIXCYL
   rbBMqzv0CgGCoWxqGPdZcGGQ7yHp/JR7bnrHtrByABvp7qeTKpSz+eydI
   q5U5hLyVhEvLf0Io+LsqxArP9oqK3hfRaKByOfLdbYd9f9DzB74Vbm2Nd
   mfranaNYFFutKUGxEGC9xIsMK+Igj5cwFCAOMv2dWMjw7KgpAhPxtKJ1Z
   ZUuW0NPdxuoza6nTrDaVtG74eYkerqgOGnK8ZIg5akCdKJA09+yXST9+T
   MZuBTW5gWsDGdMrGT4oP8aw5Kp17+H8FZjwDjS60G84JCvWm9WSKeiYjG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346034210"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346034210"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292482"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292482"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:43 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
Date:   Tue, 27 Jun 2023 02:12:50 +1200
Message-Id: <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v11 -> v12 (new patch):
  - Splitted out from "SEAMCALL infrastructure" patch for better review.
  - Provide justification in changelog (Dave/David)

---
 arch/x86/include/asm/tdx.h      |  5 +++++
 arch/x86/virt/vmx/tdx/tdx.c     |  7 +++++++
 arch/x86/virt/vmx/tdx/tdxcall.S | 19 +++++++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e95c9fbf52e4..8d3f85bcccc1 100644
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
 
 /* TDX supported page sizes from the TDX module ABI. */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1107f4227568..eba7ff91206d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -93,6 +93,13 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	case TDX_SEAMCALL_VMFAILINVALID:
 		pr_err_once("module is not loaded.\n");
 		return -ENODEV;
+	case TDX_SEAMCALL_GP:
+		pr_err_once("not enabled by BIOS.\n");
+		return -ENODEV;
+	case TDX_SEAMCALL_UD:
+		pr_err_once("SEAMCALL failed: CPU %d is not in VMX operation.\n",
+				cpu);
+		return -EINVAL;
 	default:
 		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
 				cpu, fn, sret);
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 49a54356ae99..757b0c34be10 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
 #include <asm/tdx.h>
+#include <asm/asm.h>
 
 /*
  * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
@@ -45,6 +46,7 @@
 	/* Leave input param 2 in RDX */
 
 	.if \host
+1:
 	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -57,10 +59,23 @@
 	 * This value will never be used as actual SEAMCALL error code as
 	 * it is from the Reserved status code class.
 	 */
-	jnc .Lno_vmfailinvalid
+	jnc .Lseamcall_out
 	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-.Lno_vmfailinvalid:
+	jmp .Lseamcall_out
+2:
+	/*
+	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
+	 * the trap number.  Convert the trap number to the TDX error
+	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
+	 *
+	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
+	 * only accepts 32-bit immediate at most.
+	 */
+	mov $TDX_SW_ERROR, %r12
+	orq %r12, %rax
 
+	_ASM_EXTABLE_FAULT(1b, 2b)
+.Lseamcall_out:
 	.else
 	tdcall
 	.endif
-- 
2.40.1

