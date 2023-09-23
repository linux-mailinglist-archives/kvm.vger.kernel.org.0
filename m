Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABFA7AC02F
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjIWKN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjIWKMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:12:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E372E42;
        Sat, 23 Sep 2023 03:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463915; x=1726999915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1q9TX+E9M+XAvCy1QsZHulLmmodNJZdOtsrh5PyAo94=;
  b=BSoRMQU3UDlxsImqiXJoM4K5k+zFH3SpWys/576wd49w8l61JyMxqsbG
   C0YmByCxgI4hvFIwfb68sDcByyWtz0kXM8eMLXra3nViNrHXlU9wQgwkl
   UIfN5uG7JGOSofS7lkKIOsl3znipGNUNasDGloS4qKX+hI83E2ftMvH94
   8v0Vatc79B09u0Mk0SGzdCXkaItWrLF6G/M9cr22WLeX/eEsEUNTX+SaZ
   9Rl8rTRKX4LQkmhNRlYOXRX38QfGwPj8xFy6JsbUCQu408lszOHhRKSd1
   060IKVzwcBG7y21YgZ5ETiTKPcexlYHwKfADrDEhs8tmPTjRcMyEcwwXH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492435"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492435"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388206"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388206"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:50 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 30/37] x86/fred: Let ret_from_fork_asm() jmp to asm_fred_exit_user when FRED is enabled
Date:   Sat, 23 Sep 2023 02:42:05 -0700
Message-Id: <20230923094212.26520-31-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 179e08d34eb6..f7db3a12ccb1 100644
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

