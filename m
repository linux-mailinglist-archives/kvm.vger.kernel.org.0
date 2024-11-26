Return-Path: <kvm+bounces-32508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A319D9556
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D2432849EA
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B901B1CEEB6;
	Tue, 26 Nov 2024 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mZSk4BpO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CE1CEAC7;
	Tue, 26 Nov 2024 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616309; cv=none; b=d9exz0/Rb7ZY7xbfh+zbJdlMM7Wok78Td/zeTuKEW62eliRO9oNlaBLVjPLmjdFjTEvt1hPI4EdMkhYHRvZGUqo9vjlMrizSodT1OvKtA/b6YEYdMlkoBACJ+YLKC4Gu8sFjuntFE3xxfycNorp9luTn9GWNPbiuD5ZJzdYQsoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616309; c=relaxed/simple;
	bh=aLRMRewwIg11OaAmaBrIjIHYx6XV09N2Yn6IHNkO36w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgn9Aru40qnWMSL0DcahfG53e+cAs6rJehZDCtiE4tkDgtt3OpCS6Xzc6zFtHdSxzdfa5Ra3KrZ9I4IvzucKInjnJ2SfZdMBLYXmOWaFKIGf/OziXoEXrqU5wH05Vmvb05Isj9rpSrXejDY2bT4InJ45LKyfIH2KjaIBmSL4818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mZSk4BpO; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616308; x=1764152308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aLRMRewwIg11OaAmaBrIjIHYx6XV09N2Yn6IHNkO36w=;
  b=mZSk4BpOWAyyNTzBwa6XjWMvc+HR35xJVjQDmsID9ya6u+GZPZtGtVgk
   I/foHy5CqVnYZ0LW9KCXlBm7pclCvx3PDvuv/Fz8YZibA/okpCZ1OQPts
   PTCdPwTKUdlFpHJxu3depeCFGX5+ntQc1Jl6kA+OefL0E2ZAPLxxjHZq7
   NDUUAnse1Dx8uxOM9g+n8MFnrMXcZ5Qdc6NauDQuDrM5nxLxhqOrvw4MP
   ksOJhc66bTkNTA9KMXM2k12tmX67KIXNafVMXXulmKFKOvre32D3pPYG7
   80hynHsXVNWQN6megelrCZDt4OPl+01FFyyLUbdxr0PHm3CZPBUfL6jx2
   Q==;
X-CSE-ConnectionGUID: TtCYkryaTXWIP/GCb1WHtQ==
X-CSE-MsgGUID: Du6CfqQ1Q2yn5IFSnc/VFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139875"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139875"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:28 -0800
X-CSE-ConnectionGUID: wkzm4mz6SzKKUsMVwen4pQ==
X-CSE-MsgGUID: 4K/rV99QRpe+9g9u2gIbWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631823"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:24 -0800
From: Chao Gao <chao.gao@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH v2 3/6] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Tue, 26 Nov 2024 18:17:07 +0800
Message-ID: <20241126101710.62492-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

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
Signed-off-by: Chao Gao <chao.gao@intel.com>
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
index 2cf6ec536c0d..c38e477e3e45 100644
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
2.46.1


