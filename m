Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AFE65FD92
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjAFJU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbjAFJUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A326B5DB;
        Fri,  6 Jan 2023 01:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996818; x=1704532818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=msUUkkdZ4tNoxXqmpYk+fBav1/cjI+hkwg5c4Hl6h2s=;
  b=EvO9sKSOpJcMd3BEFIbGmet/jiAi8n2Ko0sjEQXGmBAHhpRiq7DulRZu
   JGQDU1HdSJW5XPm745anfj18E44tDRdk+/hDkTNoIN9LcgT/6veAK3mX/
   xYfKkVmu39R29JaaM+TqhDuaGJ6stIgnKEpNT7qwM219HLvzi7+t/rlpM
   yU0rfj4yc9CZjgWIgbr2V5Vun7wScCRt+ND+J6/0oc8gxc7LZTEdmUBtA
   r30Z0bM30LX8hsQh20zaaw5qLJJ+4uCaoYnr52sBjkwESHiDGXWo83W92
   luNfuPANPGbSn4eIu1Hgz46oYGfRYAOI+FmuE4XCUN2TXYQvXtIdGrmDl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511449"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511449"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139370"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139370"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:13 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 09/32] x86/cpu: add X86_CR4_FRED macro
Date:   Fri,  6 Jan 2023 00:55:54 -0800
Message-Id: <20230106085617.17248-10-xin3.li@intel.com>
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

Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit should be a
pinned bit, not to be changed after initialization.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/uapi/asm/processor-flags.h |  2 ++
 arch/x86/kernel/cpu/common.c                | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index c47cc7f2feeb..a90933f1ff41 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -132,6 +132,8 @@
 #define X86_CR4_PKE		_BITUL(X86_CR4_PKE_BIT)
 #define X86_CR4_CET_BIT		23 /* enable Control-flow Enforcement Technology */
 #define X86_CR4_CET		_BITUL(X86_CR4_CET_BIT)
+#define X86_CR4_FRED_BIT	32 /* enable FRED kernel entry */
+#define X86_CR4_FRED		_BITULL(X86_CR4_FRED_BIT)
 
 /*
  * x86-64 Task Priority Register, CR8
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d6eb4f60b47d..05a5538052ad 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -411,10 +411,15 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	cr4_clear_bits(X86_CR4_UMIP);
 }
 
-/* These bits should not change their value after CPU init is finished. */
+/*
+ * These bits should not change their value after CPU init is
+ * finished.  The explicit cast to unsigned long suppresses a warning
+ * on i386 for x86-64 only feature bits >= 32.
+ */
 static const unsigned long cr4_pinned_mask =
-	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
-	X86_CR4_FSGSBASE | X86_CR4_CET;
+	(unsigned long)
+	(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
+	 X86_CR4_FSGSBASE | X86_CR4_CET | X86_CR4_FRED);
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
-- 
2.34.1

