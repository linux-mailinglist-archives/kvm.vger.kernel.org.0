Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E834B7B611B
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjJCGym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjJCGyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:54:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9794FAC;
        Mon,  2 Oct 2023 23:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696316077; x=1727852077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5bEJT87B98JS6iQ6LlrNVmLBQuK2BkIiNY3V5ZdVNuo=;
  b=W42Fi3B0qrpu+FUCrOq9rp/2juU+nc3VMgeLLeJRP6sXaRK8GVR/ktzl
   Vj1t97gTM6GOhhMa4Epl13W11wo1o/SyiGz8gqKoBFPd0CR6IvXwcG3XX
   tCKcYhQpn6l5IKVQYz5BQrIgLqC5F7SWvAozUHTeerTDPM+zBikjV0kPS
   bL4c0wBJdTEDRmBOXQDHbwQkvywasog2rrNYWdRrCIlmSNyn0efwUmHPR
   YJNceZuxidQSm/UXmLz3OtyZ2Remw7oER/FYjUc/oM6eC3aBicaQCVg+g
   Eu9YVOHF/yx5bMmjdEDVguUi9KIJMr+UfUoHYTfCzI0sK8OHk/PnhaF7Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="367857912"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="367857912"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 23:54:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="1081900894"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="1081900894"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga005.fm.intel.com with ESMTP; 02 Oct 2023 23:54:34 -0700
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
Subject: [PATCH v12 01/37] x86/cpufeatures: Add the cpu feature bit for WRMSRNS
Date:   Mon,  2 Oct 2023 23:24:22 -0700
Message-Id: <20231003062458.23552-2-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003062458.23552-1-xin3.li@intel.com>
References: <20231003062458.23552-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WRMSRNS is an instruction that behaves exactly like WRMSR, with
the only difference being that it is not a serializing instruction
by default. Under certain conditions, WRMSRNS may replace WRMSR to
improve performance.

Add the CPU feature bit for WRMSRNS.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 58cb9495e40f..330876d34b68 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -322,6 +322,7 @@
 #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
 #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
 #define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
+#define X86_FEATURE_WRMSRNS		(12*32+19) /* "" Non-Serializing Write to Model Specific Register instruction */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 798e60b5454b..1b9d86ba5bc2 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -318,6 +318,7 @@
 #define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
 #define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
 #define X86_FEATURE_LKGS		(12*32+18) /* "" Load "kernel" (userspace) GS */
+#define X86_FEATURE_WRMSRNS		(12*32+19) /* "" Non-Serializing Write to Model Specific Register instruction */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */
-- 
2.34.1

