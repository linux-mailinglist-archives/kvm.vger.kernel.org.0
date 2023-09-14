Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2505B79FA3C
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbjINFTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbjINFTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93231BD4;
        Wed, 13 Sep 2023 22:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668756; x=1726204756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UbhaPnTvbyw+zMdUXnvbzwhVl0YY5km3u8wmvpbx2GQ=;
  b=KZqQPGkkX+LMy45DL6+idM9zvxnYaUuMQ1vI61vXXT8lGsZRX9RYswLF
   RVd+HWS1ancI6rrJtazwVVAIrsGoSehEIzpzd9tYZkMfD20NeAoJhN3fg
   ykwFxHNtcE+ntWAfPloprFUaGjs9fQV3oeAvON6Mk0JQqSl+pvyShiBkx
   r2JLnyonLadYPNUs/9WFuUgk03nOXWfARHxH0K/nRV7jCPnuZunf4KpNp
   X7qatFbd5TkrkRXuNOctMvv41/HXSnV2prL5n2wuXvWEnWMS8JSJV5xF3
   LQeg90He2ca7nsW5AXtbTRfOjUFEjUipC4F1Flp3D31cIQsdFs8rf8UnK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661233"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661233"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488777"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488777"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:35 -0700
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
Subject: [PATCH v10 13/38] x86/cpu: Add X86_CR4_FRED macro
Date:   Wed, 13 Sep 2023 21:47:40 -0700
Message-Id: <20230914044805.301390-14-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Add X86_CR4_FRED macro for the FRED bit in %cr4. This bit must not be
changed after initialization, so add it to the pinned CR4 bits.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v9:
* Avoid a type cast by defining X86_CR4_FRED as 0 on 32-bit (Thomas
  Gleixner).
---
 arch/x86/include/uapi/asm/processor-flags.h | 7 +++++++
 arch/x86/kernel/cpu/common.c                | 5 ++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index d898432947ff..f1a4adc78272 100644
--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -139,6 +139,13 @@
 #define X86_CR4_LAM_SUP_BIT	28 /* LAM for supervisor pointers */
 #define X86_CR4_LAM_SUP		_BITUL(X86_CR4_LAM_SUP_BIT)
 
+#ifdef __x86_64__
+#define X86_CR4_FRED_BIT	32 /* enable FRED kernel entry */
+#define X86_CR4_FRED		_BITUL(X86_CR4_FRED_BIT)
+#else
+#define X86_CR4_FRED		(0)
+#endif
+
 /*
  * x86-64 Task Priority Register, CR8
  */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 317b4877e9c7..42511209469b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -400,9 +400,8 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 }
 
 /* These bits should not change their value after CPU init is finished. */
-static const unsigned long cr4_pinned_mask =
-	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
-	X86_CR4_FSGSBASE | X86_CR4_CET;
+static const unsigned long cr4_pinned_mask = X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP |
+					     X86_CR4_FSGSBASE | X86_CR4_CET | X86_CR4_FRED;
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
-- 
2.34.1

