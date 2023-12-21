Return-Path: <kvm+bounces-4993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11BB681B1D0
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64FBBB2719E
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F9654756;
	Thu, 21 Dec 2023 09:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OuBpwSAm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389084D138;
	Thu, 21 Dec 2023 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149429; x=1734685429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vrM9JR0H5kr1MYXHBciwu2UwrgHEa2/kyZQ0I41qdRQ=;
  b=OuBpwSAmq6NhPDDZbOAo1rVjJ9q0KJ9WMfdLLsInAjs99R4M4M/Jnb8M
   wOL/80hXlgxe6ofUWQ2bVpcR564cMYkTyyi1GwsyGeB5MfCc87qNkRSS9
   NzwAlHzpBjQEUEu/rsoJLPm8+kjwxfxm+B36ahaxubLdXdIysS6IG9F5a
   uruD7YXdd9ju6l98i/i3zKC+VSwvmZavqIvCQ6P0zKAGjktY2vWtU0Rpl
   iE1OGDs/Ggdwl7z34Hh/bweiDJugVjtiaJaNOT7SRJ17GtLvEAeo5hSU9
   zAKJqwqz85VO1MkAEtSVIWGN6sn7Jl2o4iFFZHJSWFVCez10e+sRHNZP7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729637"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729637"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028576"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028576"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
Date: Thu, 21 Dec 2023 09:02:18 -0500
Message-Id: <20231221140239.4349-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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
add the mask for guest fpstate so that guest_perm.__state_permit ==
(fpu_kernel_cfg.default_xfeature | XFEATURE_MASK_KERNEL_DYNAMIC). And
if guest fpstate is re-allocated to hold user dynamic xfeatures, the
resulting permissions are consumed before calculate new guest fpstate.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/fpu/types.h |  2 +-
 arch/x86/kernel/fpu/core.c       | 70 ++++++++++++++++++++++++++++++--
 arch/x86/kernel/fpu/xstate.c     | 10 +++++
 3 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index c6fd13a17205..306825ad6bc0 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -602,6 +602,6 @@ struct fpu_state_config {
 };
 
 /* FPU state configuration information */
-extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg, fpu_guest_cfg;
 
 #endif /* _ASM_X86_FPU_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a21a4d0ecc34..976f519721e2 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -33,10 +33,67 @@ DEFINE_STATIC_KEY_FALSE(__fpu_state_size_dynamic);
 DEFINE_PER_CPU(u64, xfd_state);
 #endif
 
-/* The FPU state configuration data for kernel and user space */
+/* The FPU state configuration data for kernel, user space and guest. */
+/*
+ * kernel FPU config:
+ *
+ * all known and CPU supported user and supervisor features except
+ *  - independent kernel features (XFEATURE_LBR)
+ * @fpu_kernel_cfg.max_features;
+ *
+ * all known and CPU supported user and supervisor features except
+ *  - dynamic kernel features (CET_S)
+ *  - independent kernel features (XFEATURE_LBR)
+ *  - dynamic userspace features (AMX state)
+ * @fpu_kernel_cfg.default_features;
+ *
+ * size of compacted buffer with 'fpu_kernel_cfg.max_features'
+ * @fpu_kernel_cfg.max_size;
+ *
+ * size of compacted buffer with 'fpu_kernel_cfg.default_features'
+ * @fpu_kernel_cfg.default_size;
+ */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
+
+/*
+ * user FPU config:
+ *
+ * all known and CPU supported user features
+ * @fpu_user_cfg.max_features;
+ *
+ * all known and CPU supported user features except
+ *  - dynamic userspace features (AMX state)
+ * @fpu_user_cfg.default_features;
+ *
+ * size of non-compacted buffer with 'fpu_user_cfg.max_features'
+ * @fpu_user_cfg.max_size;
+ *
+ * size of non-compacted buffer with 'fpu_user_cfg.default_features'
+ * @fpu_user_cfg.default_size;
+ */
 struct fpu_state_config fpu_user_cfg __ro_after_init;
 
+/*
+ * guest FPU config:
+ *
+ * all known and CPU supported user and supervisor features except
+ *  - independent  kernel features (XFEATURE_LBR)
+ * @fpu_guest_cfg.max_features;
+ *
+ * all known and CPU supported user and supervisor features except
+ *  - independent kernel features (XFEATURE_LBR)
+ *  - dynamic userspace features (AMX state)
+ * @fpu_guest_cfg.default_features;
+ *
+ * size of compacted buffer with 'fpu_guest_cfg.max_features'
+ * @fpu_guest_cfg.max_size;
+ *
+ * size of compacted buffer with 'fpu_guest_cfg.default_features'
+ * @fpu_guest_cfg.default_size;
+ */
+
+struct fpu_state_config fpu_guest_cfg __ro_after_init;
+
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
  * depending on the FPU hardware format:
@@ -536,8 +593,15 @@ void fpstate_reset(struct fpu *fpu)
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
2.39.3


