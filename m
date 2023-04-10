Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07086DC46A
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjDJIlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 04:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDJIlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 04:41:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916EE49D9;
        Mon, 10 Apr 2023 01:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681116067; x=1712652067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=voFQVjFSRNzDP3of726cqSfwzN6e3VmowuyZWcsyuKM=;
  b=CcxZ40RUpjRQDkaBJVclQUXd5tTACuh+CWWPLtKOIMjvkz3wnH/RNOaL
   kT3tqm74YFqiP54XPTOjLBaQ1YZR0dO9briIxq1Ag5qpD9dB2VEZMq8yX
   dnIlEN0vzE8sT9WsYc2kHF8w0xGZrrcnmC5P5Bqzh31ipqsAl9PIaOb/l
   qSStoJJhxDvVtO2LEIBurH6qM1ApLUjnzrvoDL3EQS1AJ2usTpjljDQv7
   A3h6QHjPMHBMcq2ixwGtkHVrt+OpVvF+g04OdMxCJZqJzH3kGylpZsqU7
   xjxWaUfYXTLNoTShWqR4AmSgexX/QLKH0sfZ9bQCTO38guqxBQtdi3tXC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="342078020"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="342078020"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 01:41:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799436298"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="799436298"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga002.fm.intel.com with ESMTP; 10 Apr 2023 01:41:04 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
Subject: [PATCH v8 15/33] x86/fred: reserve space for the FRED stack frame
Date:   Mon, 10 Apr 2023 01:14:20 -0700
Message-Id: <20230410081438.1750-16-xin3.li@intel.com>
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

When using FRED, reserve space at the top of the stack frame, just
like i386 does. A future version of FRED might have dynamic frame
sizes, though, in which case it might be necessary to make
TOP_OF_KERNEL_STACK_PADDING a variable instead of a constant.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/thread_info.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f1cccba52eb9..998483078d5f 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -31,7 +31,9 @@
  * In vm86 mode, the hardware frame is much longer still, so add 16
  * bytes to make room for the real-mode segments.
  *
- * x86_64 has a fixed-length stack frame.
+ * x86-64 has a fixed-length stack frame, but it depends on whether
+ * or not FRED is enabled. Future versions of FRED might make this
+ * dynamic, but for now it is always 2 words longer.
  */
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_VM86
@@ -39,8 +41,12 @@
 # else
 #  define TOP_OF_KERNEL_STACK_PADDING 8
 # endif
-#else
-# define TOP_OF_KERNEL_STACK_PADDING 0
+#else /* x86-64 */
+# ifdef CONFIG_X86_FRED
+#  define TOP_OF_KERNEL_STACK_PADDING (2*8)
+# else
+#  define TOP_OF_KERNEL_STACK_PADDING 0
+# endif
 #endif
 
 /*
-- 
2.34.1

