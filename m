Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1EB79FA99
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbjINFUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235447AbjINFTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903682110;
        Wed, 13 Sep 2023 22:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668764; x=1726204764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M6fmRAapBD1o7lcFP0DE6JJOLTPbVa+6x+sO9If/vNA=;
  b=hlQOIJCIBUTSnhebYrT5AkuQGB95vOGW02WTEZpV8Z+Y4gMYPqdgOb8j
   4VbZoDS7SKJEUafGgqYkHKHIj3l7sCk4eIt6+HFoXONYFiNrEqcnwZBzM
   QtToJPOk79G9ncwLT7fNo+6JUR7ZFk2jNQEN1lsyXk00O+0Go1lT72cag
   Kem2l49MLVO4s2BLE1ooQydYsVbXJsrkBwyTLMXF5iY9B5Hm/2Tx+9601
   XgeAkoCHiKEASfGppgmepnW4FM72HF/CZYNdiVbfo9A4SvF7+NxUJT9J1
   IghRtbZazismvWuXwD9WioaXx78GL2HNIvSDCmi75ZgC7jX7yqqiDGA9b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661458"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661458"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488829"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488829"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:44 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 30/38] x86/fred: Let ret_from_fork_asm() jmp to asm_fred_exit_user when FRED is enabled
Date:   Wed, 13 Sep 2023 21:47:57 -0700
Message-Id: <20230914044805.301390-31-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Let ret_from_fork_asm() jmp to asm_fred_exit_user when FRED is enabled,
otherwise the existing IDT code is chosen.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_64.S      | 6 ++++++
 arch/x86/entry/entry_64_fred.S | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 9cdb61ea91de..c9e14617dd3f 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -309,7 +309,13 @@ SYM_CODE_START(ret_from_fork_asm)
 	 * and unwind should work normally.
 	 */
 	UNWIND_HINT_REGS
+
+#ifdef CONFIG_X86_FRED
+	ALTERNATIVE "jmp swapgs_restore_regs_and_return_to_usermode", \
+		    "jmp asm_fred_exit_user", X86_FEATURE_FRED
+#else
 	jmp	swapgs_restore_regs_and_return_to_usermode
+#endif
 SYM_CODE_END(ret_from_fork_asm)
 .popsection
 
diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 37a1dd5e8ace..5781c3411b44 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -32,6 +32,7 @@
 SYM_CODE_START_NOALIGN(asm_fred_entrypoint_user)
 	FRED_ENTER
 	call	fred_entry_from_user
+SYM_INNER_LABEL(asm_fred_exit_user, SYM_L_GLOBAL)
 	FRED_EXIT
 	ERETU
 SYM_CODE_END(asm_fred_entrypoint_user)
-- 
2.34.1

