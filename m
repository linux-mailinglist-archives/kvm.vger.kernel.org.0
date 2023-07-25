Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CF17625D6
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjGYWQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjGYWPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF45E47;
        Tue, 25 Jul 2023 15:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323340; x=1721859340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MkHfcpMwySOcGOfR6N8gvbfjq2Uw4EljfqsyyqkNNzc=;
  b=dKTqci6BL8cNhhwZQ/dgGUETXmdI6CyBD8rkg3FyvTH4tCMryM/DC8Pv
   E8ztLwB+oZ1TR1gCF+FO2lWowcLHmcD3utvRvo71KTYwUIVXgimQK3abr
   dSu2WiRu5RFKzZ7VvEUMZvIIDBQOHUL8ffzKvcPTMAhfV84nGvNRI03UO
   X3oUAAPVJQzAU6YwtP6an+YxhJOmOmzfGxEfYo86bWhOlNu8nzEkZ0wPZ
   Cm8IS3V67SPEVvpXBYwiJFt3B/wmsE/KwoldvNRT/aSditNRWXRaH1PXb
   8apzf1KxVb/Ds8C7xdexUPumm2xDsvdB9Nmmm0gIWc/vyWdJZnwrhT1+/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863087"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863087"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938803"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938803"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:19 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 012/115] KVM: TDX: Retry SEAMCALL on the lack of entropy error
Date:   Tue, 25 Jul 2023 15:13:23 -0700
Message-Id: <bd28783bfe705806afa11ab353903215557cf318.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some SEAMCALL may return TDX_RND_NO_ENTROPY error when the entropy is
lacking.  Retry SEAMCALL on the error following rdrand_long() to retry
RDRAND_RETRY_LOOPS times.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_errno.h | 1 +
 arch/x86/kvm/vmx/tdx_ops.h   | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 56cfd2f558fa..53dc14ba9107 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -14,6 +14,7 @@
 #define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
+#define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 76eddecdca12..d588a5507f5a 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
@@ -17,9 +18,14 @@
 static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 			       struct tdx_module_output *out)
 {
+	int retry;
 	u64 ret;
 
-	ret = __seamcall(op, rcx, rdx, r8, r9, out);
+	/* Mimic the existing rdrand_long() to retry RDRAND_RETRY_LOOPS times. */
+	retry = RDRAND_RETRY_LOOPS;
+	do {
+		ret = __seamcall(op, rcx, rdx, r8, r9, out);
+	} while (unlikely(ret == TDX_RND_NO_ENTROPY) && --retry);
 	if (unlikely(ret == TDX_SEAMCALL_UD)) {
 		/*
 		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
-- 
2.25.1

