Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7A46A1726
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 08:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBXH2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 02:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjBXH2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 02:28:01 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0415557;
        Thu, 23 Feb 2023 23:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223678; x=1708759678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NHRufqx3uD2JDcRRkT2OSWUCnw5FRpH1XcQKduLdUk=;
  b=RWE/jgop6PK+myh+sc+KbWayTeRsrt7ahNHsRduhhV6CsZO1/Ue0WoSF
   v+F+ePZQDSi6n9J4OPKWKrvG69ecxMRbNG5AWjSS0qReIlvOzTq968A0/
   3+eHNSk0jTmrTzm0aKfiEU85MWWEWcRR0/GL5NmUHiZ4GpsnciRJNBBN+
   XH3KjvRrYeLvHd1He0AqIdxfJZIZAQQKZ9yy1ABppaznTzEPCjl34KRle
   106joPE1JhYmvWlSNH8JsIn7G+7SbqIPWbWdi6IDPntaG8fUUs5+ZFkK/
   MYI0ZRhdK4pwhuRA7VY9J1QTTc9ppL4NYRROaDh0u244tRLjncAR9yIcn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="334835987"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="334835987"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:27:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="815639213"
X-IronPort-AV: E=Sophos;i="5.97,324,1669104000"; 
   d="scan'208";a="815639213"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2023 23:27:21 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v3 09/32] x86/cpu: add X86_CR4_FRED macro
Date:   Thu, 23 Feb 2023 23:01:22 -0800
Message-Id: <20230224070145.3572-10-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230224070145.3572-1-xin3.li@intel.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 831a1a07d357..21237cb0aa93 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -412,10 +412,15 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	cr4_clear_bits(X86_CR4_UMIP);
 }
 
-/* These bits should not change their value after CPU init is finished. */
+/*
+ * These bits should not change their value after CPU init is finished.
+ * The explicit cast to unsigned long suppresses a warning on i386 for
+ * x86-64 only feature bits >= 32.
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

