Return-Path: <kvm+bounces-18513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9208D5D8F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92599B27BA6
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D5D156C77;
	Fri, 31 May 2024 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1wTa+xd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB7B156679;
	Fri, 31 May 2024 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146243; cv=none; b=YV+9QECgjKYOGDt0GQjVdzIseaKdgWet9jksqxu30Bp8kp5LGaIdRXYWcRFRHlfCB5H1LwLQ4PLuP7HSgsuFlqNQcuc0sp6rrfmcbJitJE3qjdrs9koetFtv3I0gYk7P8TmRczKBAMrNL/glZqKNbS+uV0oYOTY7XA3FLuaheEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146243; c=relaxed/simple;
	bh=4QuEaaIyM77rU5Gvud0H6S7EuBirb3AmIOw/kWt/SiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmeSECa2B0DjTxZFxYbmWBXmKgvgvG4a5WYyrnaPdQ/SkkZCNiisuqMfiJ9MQoQsIhUGc9bi5oiTRoWKDTEh1P8keEyMPEk39kbcx7ct+uY1/5oe7M3YujtjkAyqrMD/h6nLR9qvqQDQivOw/nub9Fz2Zz3C+nnYbkrzgkKX4hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1wTa+xd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717146241; x=1748682241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QuEaaIyM77rU5Gvud0H6S7EuBirb3AmIOw/kWt/SiE=;
  b=C1wTa+xd4+GNa62TlGmBslutN9HyRXPJ5g1jez2udCVo0+0WOwUnxNSI
   NBi4yjturbjdcfySBBJ3Xl4oDVh7oL6/5zK1vDA+K+EkISaNZcwUgq5p+
   epVkoqtR606nvmU+qZibea1bNWRyz2gXw4cNhjjc1MaubcOlH6meVXq6G
   Z9i0Q/uWuhaibzu+dOFwI/mWtShcVFM/DhKpOlqSG+6BpxReXjFD9i73G
   wSMa9nfeZTAkBR+wCgguy1SqRx5IxUk6c9kTRxb5TYkHs7QnxEQHI7APW
   Yh+6/In9T25zZQWtz614uEFPudZXz3gzhxegUPAvm1tgR3E/F49L8d/+/
   g==;
X-CSE-ConnectionGUID: tBMG5Go5Qs24wecizm3YAg==
X-CSE-MsgGUID: vVSQ62fDTnCtfVruQYNmGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17480597"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="17480597"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:59 -0700
X-CSE-ConnectionGUID: ZpHNPchjRxe4DhDu7pcT2g==
X-CSE-MsgGUID: XROkOIGgSrGONW3qMFycEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36102746"
Received: from jf.jf.intel.com ([10.165.9.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:59 -0700
From: Yang Weijiang <weijiang.yang@intel.com>
To: tglx@linutronix.de,
	dave.hansen@intel.com,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	weijiang.yang@intel.com,
	john.allen@amd.com
Subject: [PATCH 3/6] x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Date: Fri, 31 May 2024 02:03:28 -0700
Message-ID: <20240531090331.13713-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531090331.13713-1-weijiang.yang@intel.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
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
index 84d4fcaeff35..1a8a187351d3 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -818,6 +818,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	/* Clean out dynamic features from default */
 	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
 	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
 
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-- 
2.43.0


