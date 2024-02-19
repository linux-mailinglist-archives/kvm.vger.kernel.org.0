Return-Path: <kvm+bounces-9017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 335B5859D7A
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FBDA1C21B80
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6542B2C6AA;
	Mon, 19 Feb 2024 07:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0aO/FND"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DE721101;
	Mon, 19 Feb 2024 07:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328869; cv=none; b=BYTxIxHfM2ggAX5hM9Dx9xhRD2y5U+Z8CWFE1MwM3sfntfSXdRdqbS+xn1yIVXEzjgzvTxGyRdBnW0SctLO9n+CX0AoJUwbg1y5hrZFLzCwHpdNETThGHVORQvPmDW2ABb5xlshLmfCrh6FsybzqZKGyuuO5/yDrgJFJ9szpQ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328869; c=relaxed/simple;
	bh=MlqnfeMU4VB44Hds9887OeMo+hsI9GbnOK6otdEL9WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuX1QYSATmzI4/KiMExbl6/ZJSjS6nUzD/iDfcpyAxvGEq/wZc/AKREFG5xLGJ8tlgyB8LKv1g3GDetBG8WdxUIKOx13OjGPHeB6DYGqJ2D1E1MWkvsOmZdKjYRY/xduIi13Lc7N8Bu4KmROu1pFFb5sixItoaZ6WME/7vUowW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0aO/FND; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328867; x=1739864867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MlqnfeMU4VB44Hds9887OeMo+hsI9GbnOK6otdEL9WA=;
  b=B0aO/FNDVdQ4BqhOLxI3ip3ZW6QSpg52i8od/nLfewIXb6XAIalPZtlo
   SQ9l17pauXFg214aNiHfy6P/10o6IcWp5HAoVEgfL6MGS742ApUQkcN44
   KyyQ9HoEiJELZ2+/WBTv/MbrawoglVst3n0bZSl9dP5WwIGFD3Jy9Q3nn
   fNZ0z/9iBXN4Tfi6pE+Db2/kejcxhtqTeSz0gN/LLeY858nfcSchIB61X
   mOetZni7w433nPlTsQ0b27uIu8jPDTdrPIF+zZAiU4s1FZy5YXV0qpPNo
   XIAu46kTwgVCbT+s/LMY0rip8xgw5xe/inIAVWOzDr9DFlVFjP8IeNfAZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535033"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535033"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966069"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966069"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:43 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 04/27] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Sun, 18 Feb 2024 23:47:10 -0800
Message-ID: <20240219074733.122080-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
2.43.0


