Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2927ABF9A
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjIWKLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjIWKLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:11:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180001A5;
        Sat, 23 Sep 2023 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463900; x=1726999900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9qsPaAmdkqHl0KD85EKfAfnheAb+UY4gBzEbjksg7Tw=;
  b=m8D4g9jtEHVZyc/7yeQid5UQkI622OUGXu6C5QqNnc0g8oGtbCnle+b5
   DZR6YObIOQRklpoowjD/e61vfFyAedBfMsmtKHP+dAZf99oQ0Ys8cSZhq
   ywCv+aN/nJ9onOt/mTeMP8cOryJVkm102LyO1UoyYjcQu2Wdwap0xpBpc
   9UkYzkpcfm+1Aoih3s2sHV8u15e0hMH/T7yjE3RTpXEW/BymECwW0qIOK
   AIc028z6VTjUPatT9lN/f+u4DWlkWss24UroYh3TMp/qlI1SF9Nc+xsis
   QiTluArivWyLVQTSGrjEsENXXNuUs1l6284/pBKhjCQ/k+fCO2Ecxk5sh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492106"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492106"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388107"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388107"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:37 -0700
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
Subject: [PATCH v11 03/37] x86/msr: Add the WRMSRNS instruction support
Date:   Sat, 23 Sep 2023 02:41:38 -0700
Message-Id: <20230923094212.26520-4-xin3.li@intel.com>
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

Add an always inline API __wrmsrns() to embed the WRMSRNS instruction
into the code.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/msr.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 65ec1965cd28..c284ff9ebe67 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -97,6 +97,19 @@ static __always_inline void __wrmsr(unsigned int msr, u32 low, u32 high)
 		     : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
+/*
+ * WRMSRNS behaves exactly like WRMSR with the only difference being
+ * that it is not a serializing instruction by default.
+ */
+static __always_inline void __wrmsrns(u32 msr, u32 low, u32 high)
+{
+	/* Instruction opcode for WRMSRNS; supported in binutils >= 2.40. */
+	asm volatile("1: .byte 0x0f,0x01,0xc6\n"
+		     "2:\n"
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
+		     : : "c" (msr), "a"(low), "d" (high));
+}
+
 #define native_rdmsr(msr, val1, val2)			\
 do {							\
 	u64 __val = __rdmsr((msr));			\
@@ -297,6 +310,11 @@ do {							\
 
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
+static __always_inline void wrmsrns(u32 msr, u64 val)
+{
+	__wrmsrns(msr, val, val >> 32);
+}
+
 /*
  * 64-bit version of wrmsr_safe():
  */
-- 
2.34.1

