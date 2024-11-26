Return-Path: <kvm+bounces-32509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D3E9D9557
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3AD428493E
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8ED1C9DD8;
	Tue, 26 Nov 2024 10:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NT92ZPF2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF851CF5EE;
	Tue, 26 Nov 2024 10:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616313; cv=none; b=ZeT5w5JL4V1L7v4KwF/wFr4zVk2B7myM7KojIt93GG9/RpwNr7bCCyJ3+ITEfUOPl+q+n5K5H116+OOlSsAmLY1sd4xwDLrD3KhI2KE3LmegjZCjhoTAbpB879WE3ku2vzJEKjMJr9eHvZVfsj0+Dc5uqKOQ5XRwSURZF8N2krc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616313; c=relaxed/simple;
	bh=7CCBkpPKrgSPTMsqdgxCDezFCTgs+BY5GmIt1qUUpvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0lrPvmjxYFtDwfL+F807T7ESujRWYTpxGrsrfGp1KJuaoH9y72VPyAJMFms/O1dHd9e/zhOl/x3zeQlrLY2NC33exndy3+yx1d2pmWKmGrBlBmgRRO1u5O3l68rs3qUYlqckIgs4ZkCs42DXIYEt8DizNzHQmPfvqBHwVVpifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NT92ZPF2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732616312; x=1764152312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7CCBkpPKrgSPTMsqdgxCDezFCTgs+BY5GmIt1qUUpvg=;
  b=NT92ZPF21obmmdPU6DtbwLZuRlppOLJnf5syAYFdjGmwpYkAidSj1w2y
   /4l2fmo4qMdhH6vkSZAPwSfG8s7d7hRLv6RnaZdLY6GFpUZ6Gr8A3Eo+A
   CoCA+vN+11Ltk2CL2QJwwDsXAKwBruoVgZSSuUmfnGykW1dtRj/+fd6IA
   eW+UJEKfMGrXNGQ+OBZnhNndAlmKKZZEL3/8xfKHMC8C/YpQ1RNqc/jzI
   Rc2TVta7yfmu4H+YMiYNKeFTdee8mx2y4xCCywicOQQB8Y6TabIKBJYyy
   GUz0qL6B+28sc2rrGHZE4rzHU6h0AtfTR586ITQ21B5MQfaY0kk8+mxYO
   Q==;
X-CSE-ConnectionGUID: b38Y3nVOTiSzzKwfQtYj0Q==
X-CSE-MsgGUID: H81lCEekT2axL4EifzauGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="32139887"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="32139887"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:31 -0800
X-CSE-ConnectionGUID: Clv95LnyToSergpEZHWFsg==
X-CSE-MsgGUID: pPcNc4GxQBulYOXa8b02WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="96631840"
Received: from spr.sh.intel.com ([10.239.53.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2024 02:18:28 -0800
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
Subject: [PATCH v2 4/6] x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
Date: Tue, 26 Nov 2024 18:17:08 +0800
Message-ID: <20241126101710.62492-5-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/fpu/types.h |  2 +-
 arch/x86/kernel/fpu/core.c       | 14 +++++++++++---
 arch/x86/kernel/fpu/xstate.c     | 10 ++++++++++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index b49e65120d34..da6583a1c0a2 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -611,6 +611,6 @@ struct fpu_state_config {
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
index c38e477e3e45..17c3255dfa41 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -686,6 +686,7 @@ static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
 	unsigned int user_size, kernel_size, kernel_default_size;
+	unsigned int guest_default_size;
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
 
 	/* Uncompacted user space size */
@@ -707,13 +708,18 @@ static int __init init_xstate_size(void)
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
 
@@ -829,6 +835,10 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
 	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
 
+	fpu_guest_cfg.max_features = fpu_kernel_cfg.max_features;
+	fpu_guest_cfg.default_features = fpu_guest_cfg.max_features;
+	fpu_guest_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
 
-- 
2.46.1


