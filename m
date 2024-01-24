Return-Path: <kvm+bounces-6753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22978839F5B
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCF8D1F2BB0C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A5F15AF6;
	Wed, 24 Jan 2024 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgINgB9t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B4DC120;
	Wed, 24 Jan 2024 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064157; cv=none; b=tEsbjKjpjOQRYQyFEg0Mpsk0lkOPbfxvCDz8o2lxeR+9X9hl/8K+zlm5TxBnnSfn9TYdp/RWphOB8Wq0Tk6WhFNRmzxPY8ouiXhN2t8tYl6lNk52IrPZpmEkZMrknUMqlYC55AAIfhN+pPSb8sSnAbbMQ9EyG2cwoSTLfvC1XJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064157; c=relaxed/simple;
	bh=f4g1pickiFt8Es6a14IkTLu0NwpeGAkFFhCSd8aA94E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HEQYBVp0BTQiDn9FGBpL9VSYc4Yn0rhSPEQ+kN3x7DJFUPLYbymDRpzysfR9oRafglqQ5vxefpv8vVLNC9cPh8wvhiSrlhXkHRb3TD1FhnAVryeeOZGLEsbFNKVCf/ivI5E/sNwLt4SuP6yl9k0hOvfpjBrvOLpr4DcV0IUAXmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgINgB9t; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064155; x=1737600155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f4g1pickiFt8Es6a14IkTLu0NwpeGAkFFhCSd8aA94E=;
  b=bgINgB9tjyZ6jqCn6LQb2JbCfPILbWuzZqCcAqr8B3Tfa2TtxuNoDUxX
   rE5l+tyXpjSlEjLUgbxXF8qLGjk1vAPj6uky0VUyuHlBoP6nQlTUrnDTC
   lkVe5iwuvmbUEQ3Y2tLi5jeVVK4zvAFS+oJrE6splqtkQa14K2efH9s7j
   dzJ0wPUvGI+igWIm543Ygzk6TRVGZbEqjLDhAL1vGXFHihjTVnWJVvi9c
   +7CqGSU/21/7+ysVQvWORbC/CVrbiVcbthlRGb840YIj+AWrGse8JTrGg
   /cNjSpLzZGKWrkjYVmHhh5YwGISIw/JxJVuPgwUWM6O8k8cbdOJXJYSoj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586437"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586437"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825823"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:32 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 04/27] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Tue, 23 Jan 2024 18:41:37 -0800
Message-Id: <20240124024200.102792-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
that can be optionally enabled by kernel components. This is similar to
XFEATURE_MASK_USER_DYNAMIC in that it contains optional xfeatures that
can allows the FPU buffer to be dynamically sized. The difference is that
the KERNEL variant contains supervisor features and will be enabled by
kernel components that need them, and not directly by the user. Currently
it's used by KVM to configure guest dedicated fpstate for calculating
the xfeature and fpstate storage size etc.

The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which
is supported by host as they're enabled in kernel XSS MSR setting but
relevant CPU feature, i.e., supervisor shadow stack, is not enabled in
host kernel therefore it can be omitted for normal fpstate by default.

Remove the kernel dynamic feature from fpu_kernel_cfg.default_features
so that the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors
can be optimized by HW for normal fpstate.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/fpu/xstate.h | 5 ++++-
 arch/x86/kernel/fpu/xstate.c      | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index 3b4a038d3c57..a212d3851429 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -46,9 +46,12 @@
 #define XFEATURE_MASK_USER_RESTORE	\
 	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
 
-/* Features which are dynamically enabled for a process on request */
+/* Features which are dynamically enabled per userspace request */
 #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
 
+/* Features which are dynamically enabled per kernel side request */
+#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
+
 /* All currently supported supervisor features */
 #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
 					    XFEATURE_MASK_CET_USER | \
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 03e166a87d61..ca4b83c142eb 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-- 
2.39.3


