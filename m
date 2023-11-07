Return-Path: <kvm+bounces-905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A987E424D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:58:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B8D281338
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18670341BD;
	Tue,  7 Nov 2023 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PaoNax7s"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540C31A7F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:52 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FC1D7A;
	Tue,  7 Nov 2023 06:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369070; x=1730905070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vLgUmjmBLc3J6I9Eg/cKgAU8/9ugkH9ESWoL90woQ1s=;
  b=PaoNax7s6zPkyYU0WFPWnwuQVGIgXc1onZr0x5lHRASY2MCZGZ9u0Ktp
   V12RIWGOe3MuGRedDIaZrtsgw8UzMPFZrmvQ7va+iYMZV4GZNrRFPdoR3
   dmb60tnKosAJYD5FA/Frns6ay5Pf0c/UOdt6IY4eGzZCRWcMqIZM9GQ1G
   bxvoAKxhcc5hf5crbIxjG1BjccTrxt0SxONQkiay8jMBUakBxZaleFunF
   NRKsUbXXuPzmQ6EuCcoHMqTLndnt2UkwL36+1oVaALK0up1QHevyqeUvy
   c38EeFaTtaxAbPOYR940gWJEsdu6qnxgwSqwN+ioRMy7QmuuQXiUlw/Jc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555728"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555728"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10444001"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:47 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 012/116] KVM: TDX: Retry SEAMCALL on the lack of entropy error
Date: Tue,  7 Nov 2023 06:55:38 -0800
Message-Id: <a67c877521a6913911bd569c38c772ade6a1403b.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 7f96696b8e7c..bb093e292fef 100644
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


