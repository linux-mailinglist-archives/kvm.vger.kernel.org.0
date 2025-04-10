Return-Path: <kvm+bounces-43061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04F6CA83B28
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:30:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD1988C397B
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C1E20B7FB;
	Thu, 10 Apr 2025 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Psknjdy6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F8204F65;
	Thu, 10 Apr 2025 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269763; cv=none; b=umLEvjiVLOhj+15isisbdyb5OACqB50dAMVv8DgUcLGe3P+RAG164gFcviwZwJe76Hj6K1FH1pJIV/lowgnAFEW8X4NJsJX+etwzJ4nRQJy1rWfqJojspHzaiPwPZmk7FV8mQzxbTl1WaXduBkobMYyMSqACYl8e23gyALzYNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269763; c=relaxed/simple;
	bh=qtvKykEg1wiWubS0qpVNWzid0JRvlUFA2Q4b21MMp98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVpQ5GE+f0hedNJ3hT1E0mrEURgFRr7IrNECMwM64552m7SHiWAp/lLYyxNerd1vpj6/4ouCoDphDh5ZXzVMInXgDmp+IAN1wgbBnpPjwvYdqhPgIgdcnYyhgjFFkWKaQTXtizJhN9MD7HOBJ/3Tf9vTvP3WcLhhSzUh/0HS55Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Psknjdy6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269762; x=1775805762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qtvKykEg1wiWubS0qpVNWzid0JRvlUFA2Q4b21MMp98=;
  b=Psknjdy6Vq3jQCpwPsb11hrFdbJ0ZJcqR97U81LxoPXNqYRfYHPfAMZJ
   ndptIh4DtD6NS7BUmKM9+XKfnQGLUZTT4Kwwb0Z0KE31uaIQI2WyIbV5M
   4vxFEyHITMz8++tjiEMFWBacAPobmWoJpv0T7bgcjihLaZK9BAe09oUvQ
   1qv37VCUV2z4eDAdQam5jqRpwMMhEpc418Fo5vRk0l0wBuOI3W6F1GfMt
   KF6uKhWj0/K2EJNteGV+gxRW6Cy+cO3CExKFFzg+fR1Yzo3foh7gItC6u
   XHSp/+YzdqSeMZLJ/oB4h4lsR9GrV9cG5tXNCDFeWZaSU2Feb5EDBdDS9
   A==;
X-CSE-ConnectionGUID: 9glWmQAVQ7qgqYy7lCMkSg==
X-CSE-MsgGUID: SZpL+cn7SNiGcaGxtIkizg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439335"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439335"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:39 -0700
X-CSE-ConnectionGUID: Gs/t1q4AQhaTR6f1acfaqg==
X-CSE-MsgGUID: PgBan7YPTZ6GfXbml3GDJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778143"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:33 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for host and guest FPUs
Date: Thu, 10 Apr 2025 15:24:43 +0800
Message-ID: <20250410072605.2358393-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, guest and host FPUs share the same default features. However,
the CET supervisor xstate is the first feature that needs to be enabled
exclusively for guest FPUs. Enabling it for host FPUs leads to a waste of
24 bytes in the XSAVE buffer.

To support "guest-only" features, add a new structure to hold the
default features and sizes for guest FPUs to clearly differentiate them
from those for host FPUs.

An alternative approach is adding a guest_only_xfeatures member to
fpu_kernel_cfg and adding two helper functions to calculate the guest
default xfeatures and size. However, calculating these defaults at runtime
would introduce unnecessary overhead.

Note that, for now, the default features for guest and host FPUs remain the
same. This will change in a follow-up patch once guest permissions, default
xfeatures, and fpstate size are all converted to use the guest defaults.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v5:
Add a new vcpu_fpu_config instead of adding new members to
fpu_state_config (Chang)
Extract a helper to set default values (Chang)
---
 arch/x86/include/asm/fpu/types.h | 43 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c       |  1 +
 arch/x86/kernel/fpu/xstate.c     | 29 ++++++++++++++++-----
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 9f9ed406b179..769155a0401a 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -542,6 +542,48 @@ struct fpu_guest {
 	struct fpstate			*fpstate;
 };
 
+/*
+ * FPU state configuration data for fpu_guest.
+ * Initialized at boot time. Read only after init.
+ */
+struct vcpu_fpu_config {
+	/*
+	 * @size:
+	 *
+	 * The default size of the register state buffer in guest FPUs.
+	 * Includes all supported features except independent managed
+	 * features and features which have to be requested by user space
+	 * before usage.
+	 */
+	unsigned int size;
+
+	/*
+	 * @user_size:
+	 *
+	 * The default UABI size of the register state buffer in guest
+	 * FPUs. Includes all supported user features except independent
+	 * managed features and features which have to be requested by
+	 * user space before usage.
+	 */
+	unsigned int user_size;
+
+	/*
+	 * @features:
+	 *
+	 * The default supported features bitmap in guest FPUs. Does not
+	 * include independent managed features and features which have to
+	 * be requested by user space before usage.
+	 */
+	u64 features;
+
+	/*
+	 * @user_features:
+	 *
+	 * Same as @features except only user xfeatures are included.
+	 */
+	u64 user_features;
+};
+
 /*
  * FPU state configuration data. Initialized at boot time. Read only after init.
  */
@@ -597,5 +639,6 @@ struct fpu_state_config {
 
 /* FPU state configuration information */
 extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct vcpu_fpu_config guest_default_cfg;
 
 #endif /* _ASM_X86_FPU_TYPES_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 28ad7ec56eaa..25f13cc8ad92 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -36,6 +36,7 @@ DEFINE_PER_CPU(u64, xfd_state);
 /* The FPU state configuration data for kernel and user space */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct vcpu_fpu_config guest_default_cfg __ro_after_init;
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 6f10f5490022..cdd1e51fb93e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -738,6 +738,11 @@ static int __init init_xstate_size(void)
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
 
+	guest_default_cfg.size =
+		xstate_calculate_size(guest_default_cfg.features, compacted);
+	guest_default_cfg.user_size =
+		xstate_calculate_size(guest_default_cfg.user_features, false);
+
 	return 0;
 }
 
@@ -766,6 +771,22 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpstate_reset(&current->thread.fpu);
 }
 
+static void __init init_default_features(u64 kernel_max_features, u64 user_max_features)
+{
+	u64 kfeatures = kernel_max_features;
+	u64 ufeatures = user_max_features;
+
+	/* Default feature sets should not include dynamic xfeatures. */
+	kfeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
+	ufeatures &= ~XFEATURE_MASK_USER_DYNAMIC;
+
+	fpu_kernel_cfg.default_features = kfeatures;
+	fpu_user_cfg.default_features   = ufeatures;
+
+	guest_default_cfg.features      = kfeatures;
+	guest_default_cfg.user_features = ufeatures;
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -837,12 +858,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.max_features = fpu_kernel_cfg.max_features;
 	fpu_user_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED;
 
-	/* Clean out dynamic features from default */
-	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
-	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-
-	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
-	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	/* Now, given maximum feature set, determine default values */
+	init_default_features(fpu_kernel_cfg.max_features, fpu_user_cfg.max_features);
 
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
-- 
2.46.1


