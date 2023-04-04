Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AA26D5E4D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 12:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjDDKzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 06:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjDDKyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 06:54:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF1F44B2;
        Tue,  4 Apr 2023 03:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680605631; x=1712141631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O9acOeCuSr/+wKyZ7069qEc1yb3O4hIxP1jgg1zr2lE=;
  b=OxLFL1EG8IE2p3wVLV5DbZVsjCXYOfKBUnT0f49b18rQudvs2BTzm+SF
   jVpNKKgivZMILyiIKab54B90IzVa6ng9TdLuoValCPrcx9sZBCa0FlMq+
   0h6UF3H11IXgm82gk5bE6YOIsogJ1db49VohQm+4L8h7NukjpsnWN2e3l
   JnNn/AoviZTv7zdNcwqUNQHHEUfIhGATHsX4+JfXkAoa+VD3kyEn8uQa3
   iyyV/wcNVXSl51bHrfBmlvuxDz4vLRe06wOy3hyysQMSokjfTCU8WN91G
   kt4/uMboc0OHLmyGyGubb56y8rEuUmIwcXrgws6uQXGtsPYlUh4tZp7qU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330734156"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="330734156"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 03:53:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775597847"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="775597847"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Apr 2023 03:53:05 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to fred_exit_user when FRED is enabled
Date:   Tue,  4 Apr 2023 03:27:06 -0700
Message-Id: <20230404102716.1795-24-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230404102716.1795-1-xin3.li@intel.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Let ret_from_fork() jmp to fred_exit_user when FRED is enabled,
otherwise the existing IDT code is chosen.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/entry/entry_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index eccc3431e515..5b595a9b2ffb 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -299,7 +299,12 @@ SYM_CODE_START_NOALIGN(ret_from_fork)
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

