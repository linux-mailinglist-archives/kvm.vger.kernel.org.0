Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014F6750220
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbjGLIz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjGLIzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:55:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FA810F3;
        Wed, 12 Jul 2023 01:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152148; x=1720688148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0bi82ABbti6fBd5M79OMibwR5D1CvFGn0X38NtvwJRw=;
  b=SXZWv+664dVTL38AP0f+39HH9N2mnGic1Knw9k7u73/l9GBhzn1FdW6O
   0UKT+voHoRRZzwbzJiRfDPIAPAJmFvo092aoHgo3YfXQz0h+nUq9ADGje
   yffOIbypjg42fEIQuS12BKepmUXECI0QsZQ3Jnxu4TO7+LK8P/Vqdh3iX
   d7JjOyqb2aHXcdSKcgW7A686dzcTN+8RxfekcueHTlPta5LHXT3bwzBNN
   3W0BnCPFFz87Z/Gj4iwKtMCqUgDhSys13D6dHYUJQgGfWXrnlp2jEnq7x
   puKKuJYK1e8EZaWfVhkhX+Xn2dgUWMdewyT4yIs/xw9XRCkUzJAwzaFW/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439164"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439164"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573371"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573371"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:44 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 03/10] x86/tdx: Move FRAME_BEGIN/END to TDX_MODULE_CALL asm macro
Date:   Wed, 12 Jul 2023 20:55:17 +1200
Message-ID: <c0206c457f366ab007ab67ca16970cc4fc562877.1689151537.git.kai.huang@intel.com>
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

Currently, the TDX_MODULE_CALL asm macro and the __tdx_module_call()
take registers directly as input and a 'struct tdx_module_output' as
optional output.  This is different from the __tdx_hypercall(), which
simply uses a structure to carry all input/output.  There's no point to
leave __tdx_module_call() complicated as it is.

As a preparation to simplify the __tdx_module_call() to make it look
like __tdx_hypercall(), move FRAME_BEGIN/END and RET from the
__tdx_module_call() to the TDX_MODULE_CALL assembly macro.  This also
allows more implementation flexibility of the assembly inside the
TDX_MODULE_CALL macro, e.g., allowing putting an _ASM_EXTABLE() after
the main body of the assembly.

This is basically based on Peter's code.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/tdx/tdcall.S      | 3 ---
 arch/x86/virt/vmx/tdx/tdxcall.S | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index 2eca5f43734f..e5d4b7d8ecd4 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -78,10 +78,7 @@
  * Return status of TDCALL via RAX.
  */
 SYM_FUNC_START(__tdx_module_call)
-	FRAME_BEGIN
 	TDX_MODULE_CALL host=0
-	FRAME_END
-	RET
 SYM_FUNC_END(__tdx_module_call)
 
 /*
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 3524915d8bd9..b5ab919c7fa8 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
+#include <asm/frame.h>
 #include <asm/tdx.h>
 
 /*
@@ -18,6 +19,7 @@
  *            TDX module.
  */
 .macro TDX_MODULE_CALL host:req
+	FRAME_BEGIN
 	/*
 	 * R12 will be used as temporary storage for struct tdx_module_output
 	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
@@ -91,4 +93,7 @@
 .Lno_output_struct:
 	/* Restore the state of R12 register */
 	pop %r12
+
+	FRAME_END
+	RET
 .endm
-- 
2.41.0

