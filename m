Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF95D7B4CDC
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 09:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbjJBHwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 03:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbjJBHwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 03:52:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BD5C4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 00:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696233171; x=1727769171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4tKHv5OEKwpSrHxLYdaqKvaovIBLgPE2/VnUpwq6398=;
  b=g6M74vNgr6V3sERYaHoJPXtNCr7s9Qgn5egN7ywBAjVsTAWPHp25sMDa
   jY4h8sYN05YGB2rjoj2/gJhxDZmDgZvV4kiJFz9+11MugCeVPRFmhu5aq
   mpLbK2T9oK6seVSl5EHrf3YbM/5lX8tmCVbFyvMcLn3ylTNgCdmzEXT6x
   qm49TVzZxOMExDIOvr9sy6ZDe6gX3FQCFXR/QZUU19FG0n/CIDwZnO2YX
   X8YksfCOqzp9ZulgY5oC1Brid3GURwb2g80vVts2FhxjIxokHSMK/to01
   YNv3DoULhzJiALqlN3g9j986Ab7WBLo1zP8+Z1gARb1u8vnzUVQKmaUte
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="361975566"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="361975566"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 00:52:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="750511627"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="750511627"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 02 Oct 2023 00:52:49 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, richard.henderson@linaro.org,
        pbonzini@redhat.com, eduardo@habkost.net, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH v2 2/4] target/i386: mark CR4.FRED not reserved
Date:   Mon,  2 Oct 2023 00:23:11 -0700
Message-Id: <20231002072313.17603-3-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231002072313.17603-1-xin3.li@intel.com>
References: <20231002072313.17603-1-xin3.li@intel.com>
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

The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when FRED
is exposed to guests, otherwise it is still a reserved bit.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 target/i386/cpu.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index e2946f1d6b..322547aa49 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -262,6 +262,12 @@ typedef enum X86Seg {
 #define CR4_PKE_MASK   (1U << 22)
 #define CR4_PKS_MASK   (1U << 24)
 
+#ifdef TARGET_X86_64
+#define CR4_FRED_MASK   (1ULL << 32)
+#else
+#define CR4_FRED_MASK   0
+#endif
+
 #define CR4_RESERVED_MASK \
 (~(target_ulong)(CR4_VME_MASK | CR4_PVI_MASK | CR4_TSD_MASK \
                 | CR4_DE_MASK | CR4_PSE_MASK | CR4_PAE_MASK \
@@ -269,7 +275,8 @@ typedef enum X86Seg {
                 | CR4_OSFXSR_MASK | CR4_OSXMMEXCPT_MASK | CR4_UMIP_MASK \
                 | CR4_LA57_MASK \
                 | CR4_FSGSBASE_MASK | CR4_PCIDE_MASK | CR4_OSXSAVE_MASK \
-                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK))
+                | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
+                | CR4_FRED_MASK))
 
 #define DR6_BD          (1 << 13)
 #define DR6_BS          (1 << 14)
@@ -2484,6 +2491,9 @@ static inline uint64_t cr4_reserved_bits(CPUX86State *env)
     if (!(env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS)) {
         reserved_bits |= CR4_PKS_MASK;
     }
+    if (!(env->features[FEAT_7_1_EAX] & CPUID_7_1_EAX_FRED)) {
+        reserved_bits |= CR4_FRED_MASK;
+    }
     return reserved_bits;
 }
 
-- 
2.34.1

