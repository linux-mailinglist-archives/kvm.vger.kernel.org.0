Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309E179FA1F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbjINFT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbjINFTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:19:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBD51BCD;
        Wed, 13 Sep 2023 22:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668755; x=1726204755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZlGESG1ZjbxHp/2vGEpu7uzY2F9a0taEPQgxug8c1Qc=;
  b=Hh049Uru6vw5PJ+LfcSYO/H6uxwh4L+p0vVbPY/wQB1Yndwu5LRuyJ2o
   InZasxo7UPXakD7xu5Wl9OxTAw0n0Z/B+Z43/dU1JocnR+WQi6t/YNpQY
   AgRAOJtigvEwp2NEuug9d5+2kDRGFKJEJl7jn8fd8jG1oTzwVskHvgfgz
   S+pIrTu+XbvfmMZF9G6sSETqaaEv98JylgrIepRL4yq4ym52Hu+vhVdRz
   0rkZFTvQsdoXbIsV4taLIQvNy2FkygBmBTs/thrzlSuSrOz2bzGoE3o9r
   EIdz4GxIAdAY1VvG6lr4+d872Nk4cfUx3IQtYOsSkTBSzn+tpnHtJUo8D
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661167"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661167"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488760"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488760"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:32 -0700
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
Subject: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for FRED
Date:   Wed, 13 Sep 2023 21:47:35 -0700
Message-Id: <20230914044805.301390-9-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Any FRED CPU will always have the following features as its baseline:
  1) LKGS, load attributes of the GS segment but the base address into
     the IA32_KERNEL_GS_BASE MSR instead of the GS segment’s descriptor
     cache.
  2) WRMSRNS, non-serializing WRMSR for faster MSR writes.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c         | 2 ++
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 330876d34b68..57ae93dc1e52 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -321,6 +321,7 @@
 #define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
 #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
 #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
+#define X86_FEATURE_FRED		(12*32+17) /* Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
 #define X86_FEATURE_WRMSRNS		(12*32+19) /* "" Non-Serializing Write to Model Specific Register instruction */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index e462c1d3800a..b7174209d855 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -82,6 +82,8 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_XFD,			X86_FEATURE_XGETBV1   },
 	{ X86_FEATURE_AMX_TILE,			X86_FEATURE_XFD       },
 	{ X86_FEATURE_SHSTK,			X86_FEATURE_XSAVES    },
+	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
+	{ X86_FEATURE_FRED,			X86_FEATURE_WRMSRNS   },
 	{}
 };
 
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 1b9d86ba5bc2..18bab7987d7f 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -317,6 +317,7 @@
 #define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
 #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
 #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
+#define X86_FEATURE_FRED		(12*32+17) /* Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
 #define X86_FEATURE_WRMSRNS		(12*32+19) /* "" Non-Serializing Write to Model Specific Register instruction */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
-- 
2.34.1

