Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C317CAF34
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjJPQaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjJPQax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:30:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D594ECD;
        Mon, 16 Oct 2023 09:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473272; x=1729009272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vpXCmlD0snO0WBWWUvJdVYMn9hwOmcv8k5zeczxfXWo=;
  b=Gru45sM4+ABG8aR2h7PXmFd0FW8lOsbinTa1gkMJTkoTicDKBtprnsmC
   YrTyBShemzJyN+koxyorvt6ty7Se7lRPJVnWPAe8rpUrW6MF3kA/MgYGV
   8hzovgnhodCTXRfJ7lUO2IiDT6DJXS9GFk9TlmC4SehSe0CtSW3zKk9A2
   SJ5De1kQXOq2XIl6cLOBHktPmlugQQSjuoAyang50INbiw9JNaUUr7ElW
   YfRhfeE7cKlj135wY78gJW0h8ia32Q0S1mmEIdQdGBes4kXGGOXUma6ux
   e+7/vnk6JvN1WRlh4dh70KUdWvnOV/tOZfFgyGkje7ISknLcelpSBaXkr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825919"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825919"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126000"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126000"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:26 -0700
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
Subject: [PATCH v16 012/116] KVM: TDX: Retry SEAMCALL on the lack of entropy error
Date:   Mon, 16 Oct 2023 09:13:24 -0700
Message-Id: <a026559ffe2f10108c243327462af0bd066ffb5d.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some SEAMCALL may return TDX_RND_NO_ENTROPY error when the entropy is
lacking.  Retry SEAMCALL on the error following rdrand_long() to retry
RDRAND_RETRY_LOOPS times.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_errno.h |  1 +
 arch/x86/kvm/vmx/tdx_ops.h   | 40 +++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index ec76740dc6a1..dbee050b2356 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -14,6 +14,7 @@
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
+#define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 12fd6b8d49e0..a55977626ae3 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
@@ -17,25 +18,30 @@
 static inline u64 tdx_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 			       struct tdx_module_args *out)
 {
+	int retry;
 	u64 ret;
 
-	if (out) {
-		*out = (struct tdx_module_args) {
-			.rcx = rcx,
-			.rdx = rdx,
-			.r8 = r8,
-			.r9 = r9,
-		};
-		ret = __seamcall_ret(op, out);
-	} else {
-		struct tdx_module_args args = {
-			.rcx = rcx,
-			.rdx = rdx,
-			.r8 = r8,
-			.r9 = r9,
-		};
-		ret = __seamcall(op, &args);
-	}
+	/* Mimic the existing rdrand_long() to retry RDRAND_RETRY_LOOPS times. */
+	retry = RDRAND_RETRY_LOOPS;
+	do {
+		if (out) {
+			*out = (struct tdx_module_args) {
+				.rcx = rcx,
+				.rdx = rdx,
+				.r8 = r8,
+				.r9 = r9,
+			};
+			ret = __seamcall_ret(op, out);
+		} else {
+			struct tdx_module_args args = {
+				.rcx = rcx,
+				.rdx = rdx,
+				.r8 = r8,
+				.r9 = r9,
+			};
+			ret = __seamcall(op, &args);
+		}
+	} while (unlikely(ret == TDX_RND_NO_ENTROPY) && --retry);
 	if (unlikely(ret == TDX_SEAMCALL_UD)) {
 		/*
 		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
-- 
2.25.1

