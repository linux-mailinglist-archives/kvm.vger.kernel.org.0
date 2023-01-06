Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5B65FDAD
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjAFJVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjAFJU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD63463188;
        Fri,  6 Jan 2023 01:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996824; x=1704532824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Ow+AUlF3YAQbms59Th+YlBw4taXZzsqN7sPL++pLxY=;
  b=GFrwoDoZzAQYsx0gh11Hqxb8h7fLwmSqNWEyZMek6VpRGQHJe8r5KzEe
   5azy9OXAUco3j4MRSfK710d9U3u3xWunR3gQum3iB0mp7oTPlctIijmeU
   I6SLl9HXMMCsroCwYHzJ288fm4ig2QKFUWrL8audRh6MMM3+FJshVF+w8
   GfBgJPhq4Azh7q9cI6IXPnWqirZOqfKulFIZTGozSMM03hCRZnaPRapU7
   kn0pY2/OyK6+UFZc3nqCL4AQ/gdGuGMEobirTEvFQOjxBI9ksq5t0rRK3
   v4tBaiAcRDqQegOIC/cVPsjjmlMugfgLcGfuTEajrGIwQ6PQY+/95acqF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511592"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511592"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139434"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139434"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:16 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 24/32] x86/fred: let ret_from_fork() jmp to fred_exit_user when FRED is enabled
Date:   Fri,  6 Jan 2023 00:56:09 -0800
Message-Id: <20230106085617.17248-25-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
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

Let ret_from_fork() jmp to fred_exit_user when FRED is enabled,
otherwise the existing IDT code is chosen.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index e0c48998d2fb..cdb696cbb2a0 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -297,7 +297,12 @@ SYM_CODE_START(ret_from_fork)
 	UNWIND_HINT_REGS
 	movq	%rsp, %rdi
 	call	syscall_exit_to_user_mode	/* returns with IRQs disabled */
+#ifdef CONFIG_X86_FRED
+	ALTERNATIVE "jmp swapgs_restore_regs_and_return_to_usermode", \
+		    "jmp fred_exit_user", X86_FEATURE_FRED
+#else
 	jmp	swapgs_restore_regs_and_return_to_usermode
+#endif
 
 1:
 	/* kernel thread */
-- 
2.34.1

