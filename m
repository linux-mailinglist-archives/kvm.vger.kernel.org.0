Return-Path: <kvm+bounces-9019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6E0859D7D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6BD6B222ED
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C6D52D04A;
	Mon, 19 Feb 2024 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BhuyfOn8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704BD241E1;
	Mon, 19 Feb 2024 07:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328870; cv=none; b=gXYg/DbUEaPqUFf4EaCb27yRAYCIsjZCA517Yg8xF3/KvzshPxej9We5aNMfH7WAtm0n973XZ3TcMG1mooIjxqyqwjMjP3uUwVT9cLy+kWAwv5BlhmYqTwBMIWNypzRyM0j8V1w8L0V3tvkKmkrWKSFe2EXlYo0kcu65fkSO9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328870; c=relaxed/simple;
	bh=Np6rck3vYGS0TWNIPT5gHe6jyCmUuYJzYZHXucZHL90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM1J7CQ2s/9eTa0V0MpdQAXvFliaVbFmpDz9OhMgC/n8lLxP3vWgXlwrcfjRLLU4gVjV5gddiOQzhZwHxU0VpfyvVe6T9ReEXnk6y4zXtdoxgWVS27THLsD/6F3dH8X3i1fqERcTKSMOM4pLBHdtSP9tXKCQJnNnBsVuKiWd/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BhuyfOn8; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328868; x=1739864868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Np6rck3vYGS0TWNIPT5gHe6jyCmUuYJzYZHXucZHL90=;
  b=BhuyfOn8iNvCwN3O/FPAi6wMz2qkCFiXoIHiACLtp9nwxVw57v4oVKlt
   tCa6lt8AKWu18F5osXa/TzGLc3nIUFqrpKFDyKoeRZ/fnhDxC6XZlO96m
   q604Jw2l58k5BXK6ZTMX4OrBHUVdeV7TnVbkTySHp1EYIcMCXjATW0PH9
   kGS2JiEOaFhVB1KGWmqdjj4GHQdcQTSKqNl2yuPmuFU9pPeeHSSaZZTHj
   Kdhr9skWK5+flf1gopZHfp49EEx85O8AvYUN2aMgR/tCyyJoivamzbBBJ
   5SmXlxtfiwh6yPyZsB0WhpIxcIV5ittIFLbw/FJSuZg+4w7Xs+IHAXnkV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535039"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535039"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966072"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966072"
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
Subject: [PATCH v10 05/27] x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
Date: Sun, 18 Feb 2024 23:47:11 -0800
Message-ID: <20240219074733.122080-6-weijiang.yang@intel.com>
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
index fe12724c50cc..aa00a9617832 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -604,6 +604,6 @@ struct fpu_state_config {
 };
 
 /* FPU state configuration information */
-extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
 
 #endif /* _ASM_X86_FPU_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 520deb411a70..e8205e261a24 100644
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
index ca4b83c142eb..9cbdc83d1eab 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -681,6 +681,7 @@ static int __init init_xstate_size(void)
 {
 	/* Recompute the context size for enabled features: */
 	unsigned int user_size, kernel_size, kernel_default_size;
+	unsigned int guest_default_size;
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XCOMPACTED);
 
 	/* Uncompacted user space size */
@@ -702,13 +703,18 @@ static int __init init_xstate_size(void)
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
2.43.0


