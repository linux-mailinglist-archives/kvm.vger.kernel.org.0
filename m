Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A16665FD98
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjAFJVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjAFJUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398566B5DD;
        Fri,  6 Jan 2023 01:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996817; x=1704532817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t538ktauL1cAgq6AUr7Ip99zqgMTE2CVEc4jgszwTWk=;
  b=IlCK8AiLKAzVy21E3RFR1IyF9FW8JoxaDOzfXZKFP5ujToz3+6/e3B2/
   IeYRQPDRwv1mFRJYs3MeP1dsr56KJ/hadWjeTyNEQmHQlHZ+nW4R7nRb6
   uYDQYamXnbNMt56Lsb4zcS8JyZ6Dqax+7mH+fmMp0ya5oI0xLN4E+Axd5
   RgwVBgOirBkGLe0B8JX3sFsj+7MbHpRoNrzCbYDUSJYJZZ+gf0MfEf8cT
   ETznyA7bLzuSz3lDUClOvsvgR1xnKMqOvkjEsNF77q47TZOCpA845czI5
   WEuyE7YKeGoFrd0wd3HJIeGg8ijrichiJW67U18wVqWIlH8HI9DfrXS1b
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511418"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511418"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139359"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139359"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:12 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 06/32] x86/cpufeature: add the cpu feature bit for FRED
Date:   Fri,  6 Jan 2023 00:55:51 -0800
Message-Id: <20230106085617.17248-7-xin3.li@intel.com>
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

Add the CPU feature bit for FRED (Flexible Return and Event Delivery).

The Intel flexible return and event delivery (FRED) architecture defines simple
new transitions that change privilege level (ring transitions).  The FRED
architecture was designed with the following goals:
1) Improve overall performance and response time by replacing event delivery
through the interrupt descriptor table (IDT event delivery) and event return by
the IRET instruction with lower latency transitions.
2) Improve software robustness by ensuring that event delivery establishes the
full supervisor context and that event return establishes the full user context.

The new transitions defined by the FRED architecture are FRED event delivery and,
for returning from events, two FRED return instructions. FRED event delivery can
effect a transition from ring 3 to ring 0, but it is used also to deliver events
incident to ring 0. One FRED instruction (ERETU) effects a return from ring 0 to
ring 3, while the other (ERETS) returns while remaining in ring 0.

The Intel FRED architecture spec can be downloaded from:
	https://cdrdv2.intel.com/v1/dl/getContent/678938

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 29f53b31056e..6148e8a94d24 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -312,6 +312,7 @@
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_LKGS		(12*32+ 18) /* "" Load "kernel" (userspace) gs */
+#define X86_FEATURE_FRED		(12*32+ 17) /* Flexible Return and Event Delivery */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 3dc1a48c2796..41d1e1b4a6cb 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -308,6 +308,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
+#define X86_FEATURE_FRED		(12*32+ 17) /* Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+ 18) /* "" Load "kernel" (userspace) gs */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
-- 
2.34.1

