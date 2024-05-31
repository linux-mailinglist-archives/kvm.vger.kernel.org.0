Return-Path: <kvm+bounces-18514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 507398D5D90
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D298F1F233ED
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEB6157462;
	Fri, 31 May 2024 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNQsHtvS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A0156228;
	Fri, 31 May 2024 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717146244; cv=none; b=Zo8cxXjOZg5YnjKRQEM+Q4OOuCvj7Ugl1FZIoDgd24dy7/IvjT/WoEwVhNKxqj3nHcl73QVzWMbeVUWslWMfDXUnXQBrYpP+wyhlzPJFYjSsx3FAtwJSyr1PAn/5FrCssxkXsp3XRt4VAalqaeMLRQ+ejSdjCF+Rhthjbb4owDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717146244; c=relaxed/simple;
	bh=OHVq25vZLsqyLTtyp75ZE0G7ZNYjK4i/SyW0ERPfjvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5vlRZc0eWOVluLxfkh2P/0i4bOCDvy8E85a4t4dL77/4JXgg35sSsxFJWaJ5Fo4ehIxR2sSyT3F73N3MaI8NtBMoQVEf3lFR4hbv/887drVt9DkXCsTYGg0Nd0XPuc4goc07XMwfrCPoE4CPwDRRrW5al8MDZJ32tdfEJoqSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNQsHtvS; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717146242; x=1748682242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OHVq25vZLsqyLTtyp75ZE0G7ZNYjK4i/SyW0ERPfjvA=;
  b=JNQsHtvSK3n8FkSccktvt3IICxcZLmkrQqXNqGiptSj+QF5p3hlQFgd3
   NAOsyMymi6EN4pDuKaqJo4W26eP0GFBHzJPb6yD/vNN7V80v+5Vycmm6P
   oXiiPeI7ysP6YgqRJTu7CDQfreoXqcS0lg2n01hd6958dDmxCinEcAHdq
   GkHTZkavB46SaB+GnIsW+xqLhg1/4W8MrRANbO9macI9hzXI2bd0pK5nW
   Njlt1fveBe1CGa7AW/3f0wkPFMgyyaNUFZnOEBgSOZ+h4gJx6/IX7fDkn
   sz3R3sD5O9Z5dvTpSg8t7pfCpM8reDCy70WJw3aME4OUkquARsV3d4nLs
   Q==;
X-CSE-ConnectionGUID: YFiEU1KkQme+JfK8rNcI0Q==
X-CSE-MsgGUID: lELhkIdgQeKppo4SWVy8OQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="17480605"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="17480605"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:03:59 -0700
X-CSE-ConnectionGUID: FkvDbV+FTbOWVqeGkMwdiQ==
X-CSE-MsgGUID: 0qNeSv2bSImIGUYhFKgxFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36102750"
Received: from jf.jf.intel.com ([10.165.9.183])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 02:04:00 -0700
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
Subject: [PATCH 4/6] x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
Date: Fri, 31 May 2024 02:03:29 -0700
Message-ID: <20240531090331.13713-5-weijiang.yang@intel.com>
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

Define new fpu_guest_cfg to hold all guest FPU settings so that it can
differ from generic kernel FPU settings, e.g., enabling CET supervisor
xstate by default for guest fpstate while it's remained disabled in
kernel FPU config.

The kernel dynamic xfeatures are specifically used by guest fpstate now,
add the mask for guest fpstate so that guest_perm.__state_perm ==
(fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
if guest fpstate is re-allocated to hold user dynamic xfeatures, the
resulting permissions are consumed before calculate new guest fpstate.

With new guest FPU config added, there're 3 categories of FPU configs in
kernel, the usages and key fields are recapped as below.

kernel FPU config:
  @fpu_kernel_cfg.max_features
  - all known and CPU supported user and supervisor features except
    independent kernel features

  @fpu_kernel_cfg.default_features
  - all known and CPU supported user and supervisor features except
    dynamic kernel features, independent kernel features and dynamic
    userspace features.

  @fpu_kernel_cfg.max_size
  - size of compacted buffer with 'fpu_kernel_cfg.max_features'

  @fpu_kernel_cfg.default_size
  - size of compacted buffer with 'fpu_kernel_cfg.default_features'

user FPU config:
  @fpu_user_cfg.max_features
  - all known and CPU supported user features

  @fpu_user_cfg.default_features
  - all known and CPU supported user features except dynamic userspace
    features.

  @fpu_user_cfg.max_size
  - size of non-compacted buffer with 'fpu_user_cfg.max_features'

  @fpu_user_cfg.default_size
  - size of non-compacted buffer with 'fpu_user_cfg.default_features'

guest FPU config:
  @fpu_guest_cfg.max_features
  - all known and CPU supported user and supervisor features except
    independent kernel features.

  @fpu_guest_cfg.default_features
  - all known and CPU supported user and supervisor features except
    independent kernel features and dynamic userspace features.

  @fpu_guest_cfg.max_size
  - size of compacted buffer with 'fpu_guest_cfg.max_features'

  @fpu_guest_cfg.default_size
  - size of compacted buffer with 'fpu_guest_cfg.default_features'

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/fpu/types.h |  2 +-
 arch/x86/kernel/fpu/core.c       | 14 +++++++++++---
 arch/x86/kernel/fpu/xstate.c     | 10 ++++++++++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index d633cf833411..0ad17b0ffbe8 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -604,6 +604,6 @@ struct fpu_state_config {
 };
 
 /* FPU state configuration information */
-extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
 
 #endif /* _ASM_X86_FPU_TYPES_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1209c7aebb21..9e2e5c46cf28 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -33,9 +33,10 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
 DEFINE_PER_CPU(u64, xfd_state);
 #endif
 
-/* The FPU state configuration data for kernel and user space */
+/* The FPU state configuration data for kernel, user space and guest. */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct fpu_state_config fpu_guest_cfg __ro_after_init;
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
@@ -536,8 +537,15 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	/* Guest permission settings */
+	fpu->guest_perm.__state_perm	= fpu_guest_cfg.default_features;
+	fpu->guest_perm.__state_size	= fpu_guest_cfg.default_size;
+	/*
+	 * Set guest's __user_state_size to fpu_user_cfg.default_size so that
+	 * existing uAPIs can still work.
+	 */
+	fpu->guest_perm.__user_state_size = fpu_user_cfg.default_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1a8a187351d3..392f3ba3aa27 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -683,6 +683,7 @@ static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
 	unsigned int user_size, kernel_size, kernel_default_size;
+	unsigned int guest_default_size;
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
 
 	/* Uncompacted user space size */
@@ -704,13 +705,18 @@ static int __init init_xstate_size(void)
 	kernel_default_size =
 		xstate_calculate_size(fpu_kernel_cfg.default_features, compacted);
 
+	guest_default_size =
+		xstate_calculate_size(fpu_guest_cfg.default_features, compacted);
+
 	if (!paranoid_xstate_size_valid(kernel_size))
 		return -EINVAL;
 
 	fpu_kernel_cfg.max_size = kernel_size;
 	fpu_user_cfg.max_size = user_size;
+	fpu_guest_cfg.max_size = kernel_size;
 
 	fpu_kernel_cfg.default_size = kernel_default_size;
+	fpu_guest_cfg.default_size = guest_default_size;
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
 
@@ -823,6 +829,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
+	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
+	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
+	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
 
-- 
2.43.0


