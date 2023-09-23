Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0013E7AC042
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjIWKM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjIWKL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83CA1AB;
        Sat, 23 Sep 2023 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463906; x=1726999906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f4gesqgoemAM7gLIVW0tfHuShJv23oH28+TguMOULZ8=;
  b=QxWUBZs0xpA7p45SMCJP3pzboZwv1TWVn8628483/zG1HN6J3uhYFht0
   8wbEKjofUV5ftUEKibda7nWg3+Zz3/6MhwKuLmcTkGWpumromTH58FCkM
   vn0z6XIWq4sjp0uhOhy5iySOKDOuojLMrlJRxrG2OR8vaDGGRaNSfLmoH
   047a2i9MLbggY/U922moqfRaC2R0N/FdYTWCQbNG2HaA3WDJVd8eS8htp
   8X0ZBQfgiuAVJ3D/c/KuIsrFMn1X971OQ+g5mSqXkOr3zmlFR3+nBr6O3
   38RSSIasELGBMsA0JXZUQiZnUUVdeX63YB2q98yDP0Li8d/CNOg0tV6aA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492290"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492290"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388160"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388160"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:44 -0700
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
Subject: [PATCH v11 18/37] x86/fred: Reserve space for the FRED stack frame
Date:   Sat, 23 Sep 2023 02:41:53 -0700
Message-Id: <20230923094212.26520-19-xin3.li@intel.com>
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

When using FRED, reserve space at the top of the stack frame, just
like i386 does.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/thread_info.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index d63b02940747..12da7dfd5ef1 100644
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
+#  define TOP_OF_KERNEL_STACK_PADDING (2 * 8)
+# else
+#  define TOP_OF_KERNEL_STACK_PADDING 0
+# endif
 #endif
 
 /*
-- 
2.34.1

