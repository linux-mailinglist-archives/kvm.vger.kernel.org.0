Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749756DC47E
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjDJIlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjDJIlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6064EC2;
        Mon, 10 Apr 2023 01:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116071; x=1712652071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O9acOeCuSr/+wKyZ7069qEc1yb3O4hIxP1jgg1zr2lE=;
  b=BeL26GLpLLY4x0pXd1dn8kkAg3eIMR46Q9sGZSPELWgST4Ipn0fLhmdw
   It6MrGABBVyDHH9XU2KGsX4QMdjjuNooEILNTeLt9O6QWhKKBvgFGK7R8
   eIH3+HM2Ok1FwOCdlZyKU+cE5eU4/W8qlCO7hsV9ZYAAUZ/+7e1qYHGxH
   0GWY11C5wtDCOyz2mvNlpnGAuK63lzUoQwwobty5h5TbmIGneASWrvHMz
   Zn5GOuH3HZ4Ue4YGYumMhFG3dkXuByjPgCyJsBWpwE0lxmwNd1VWOyIfX
   Ok9G3dKZlO6As/wc2H2lEiBlSagRshOLGHoCdCxrlwIPKexOLNbc4eFEL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078118"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078118"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436334"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436334"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:06 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 23/33] x86/fred: let ret_from_fork() jmp to fred_exit_user when FRED is enabled
Date:   Mon, 10 Apr 2023 01:14:28 -0700
Message-Id: <20230410081438.1750-24-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410081438.1750-1-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
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

