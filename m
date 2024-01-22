Return-Path: <kvm+bounces-6588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE4D837944
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12031B22D23
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2749F56473;
	Mon, 22 Jan 2024 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kS1HBO3t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691E53E12;
	Mon, 22 Jan 2024 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967704; cv=none; b=njZmzmgmUbcmis3h1UMUT9VDe0m1wH6TJe4C5gQdFz4hINvk38DnWWIhucIr/KaatSQpwXZBeZ+YdTtsx4Nd0NgkiqCIa9JlqrAkNh9EaBuQmU1IborBe6MKTpp6IeZdH55cKmSquVT7erXaXvl6EKXyuRa3enO7cm9QmwXFZ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967704; c=relaxed/simple;
	bh=O3FRmmkEXq36zXdWdcN/SnmIfy+rFcFYaVWKi/yIim4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o1Pb7BghFeYLDEEBJx1NYxkcOQH4BYjD7AV/NAi9KEVaeVws5XXOJ0JOLvbmkTzicgfcmsTat1dfih/320FsCSKsN2EK89dUIOQzfnk6IXPHCpf/p+97xuPLKvFNVDmrlT8YJHCVQ3dPn+fdv4kkPVQB7yySvdnToivFgD+zdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kS1HBO3t; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967703; x=1737503703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O3FRmmkEXq36zXdWdcN/SnmIfy+rFcFYaVWKi/yIim4=;
  b=kS1HBO3tc/oM12IrGRErGUqnG67dBJ0PpFJj/lik3F9Tb16NiJxu4t2l
   7MVOpB0FjLWHQYJOMK2FxFQ5bnSfv2bCGwealsDQGX5b3dPv07D/Glj7L
   SE1VO2QPyVU7IkPEmdCRk5KYwdTKXJPMFqzRkca9+qVv6oCAgCNnqfacC
   O3Qj1aNYmRlqh/Vv9Ob26XzujVRbGRKbhJRqHCo/zf7JFMLTsApoST742
   Eg/g8EJ98y1ZdLqckyLOk/ZecqDTs291w42sY/jEO8J+B8Nef6z3uVK2z
   YcRFdAVg9TO8eA3tSphRy+B8Fi/UiD5Y5KysmsyppMtGAwvY9Hq6Vyn4e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217874"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350175"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:02 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 015/121] KVM: TDX: Retry SEAMCALL on the lack of entropy error
Date: Mon, 22 Jan 2024 15:52:51 -0800
Message-Id: <a4d44b01523c935595c8ee00622ab8766e269ef4.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
v18:
- update to use struct tdx_modules_args for inputs.
---
 arch/x86/kvm/vmx/tdx_errno.h |  1 +
 arch/x86/kvm/vmx/tdx_ops.h   | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

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
index 0e26cf22240e..f4c16e5265f0 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -6,6 +6,7 @@
 
 #include <linux/compiler.h>
 
+#include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/asm.h>
 #include <asm/kvm_host.h>
@@ -17,14 +18,20 @@
 static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
 			       struct tdx_module_args *out)
 {
+	struct tdx_module_args args;
+	int retry;
 	u64 ret;
 
-	if (out) {
+	if (!out)
+		out = &args;
+
+	/* Mimic the existing rdrand_long() to retry RDRAND_RETRY_LOOPS times. */
+	retry = RDRAND_RETRY_LOOPS;
+	do {
+		/* As __seamcall_ret() overwrites out, init out on each loop. */
 		*out = *in;
 		ret = __seamcall_ret(op, out);
-	} else
-		ret = __seamcall(op, in);
-
+	} while (unlikely(ret == TDX_RND_NO_ENTROPY) && --retry);
 	if (unlikely(ret == TDX_SEAMCALL_UD)) {
 		/*
 		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
-- 
2.25.1


