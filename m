Return-Path: <kvm+bounces-46150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB415AB328C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 11:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B53C189484C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D87E26656B;
	Mon, 12 May 2025 08:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dyqNmqy8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F047E25B691;
	Mon, 12 May 2025 08:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747040268; cv=none; b=B9VvuZX+XtRzG8Y5MUKvcU/KOie1rcr/3kUorVpzlqb25x8eu3iZtyi/q33y4hh2vQr9U1WTivhVlOsmd/8pUEX2GSY8ztPSGvqDKUqHtksGWWRKBNEjOeL4/JV5JCoRor/RubAUbr6JH9nr0A3YTws8WXJ/gG8SCa2kRUbO3H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747040268; c=relaxed/simple;
	bh=+hNZSzs+UU0rkjlXcA84b2Bq54FhNUxCpNk6I3td9qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvSPOl7c+wzGJ2AI/QJR4NsVd1tqiRes2bxnXeD4dPuQXA6Ww6+JtwwV9XbT3EichOJVbv8nuT8rDo6S+nFKIKy6QtPJk5/e/Mg6QYu3nd4Ob6p4YWEVaeZPQ+SRsSydVogYADQl6Oa+zVpsXOCPzXQgEAve/K/NHIqt31Gj+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dyqNmqy8; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747040265; x=1778576265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+hNZSzs+UU0rkjlXcA84b2Bq54FhNUxCpNk6I3td9qg=;
  b=dyqNmqy8GaJtLdGswb7BcpF0xj2EIyhgk1VbsuFiAxemcf9XhwiFi+tD
   KWnelDuywME4RAmGhCEd5FZrHkeyoRmn/KKEhKXeLQnM08j+Q6GgrfYwR
   weCSa90Y+wTb1FYJ5/y3UutaL2QA8p8jcigu4h+91VkWOaVFvx1cX9+yQ
   lCyPtkfN2HZPtwFSMXChlIBYuKDwFRDZoJdM5ybMzJsyjj0O1Y2P5Jk2t
   pY5XENSMQJmCOE9wB8+BnVhboZnQ+XePRiO1qeyXMrwfOHYWYXG5kUVb2
   PzPYACIpLNwGzyPG3OUeZ3lQsD8eSJ9Xa+Ig9i1JKVV/8sXP5+r90Yob5
   Q==;
X-CSE-ConnectionGUID: dLcqbt58SW2jcvyKMWFFgw==
X-CSE-MsgGUID: 6PkiyQKwRoumycdJSwSTqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59488692"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59488692"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:44 -0700
X-CSE-ConnectionGUID: eDU5l9WKQp2Mq9YEp1dZiw==
X-CSE-MsgGUID: /0EaOvfmQACyWE7Up/w+1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138235776"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 01:57:44 -0700
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
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v7 1/6] x86/fpu/xstate: Differentiate default features for host and guest FPUs
Date: Mon, 12 May 2025 01:57:04 -0700
Message-ID: <20250512085735.564475-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250512085735.564475-1-chao.gao@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
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

Note that,
1) for now, the default features for guest and host FPUs remain the
same. This will change in a follow-up patch once guest permissions, default
xfeatures, and fpstate size are all converted to use the guest defaults.

2) only supervisor features will diverge between guest FPUs and host
FPUs, while user features will remain the same [1][2]. So, the new
vcpu_fpu_config struct does not include default user features and size
for the UABI buffer.

An alternative approach is adding a guest_only_xfeatures member to
fpu_kernel_cfg and adding two helper functions to calculate the guest
default xfeatures and size. However, calculating these defaults at runtime
would introduce unnecessary overhead.

Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Link: https://lore.kernel.org/kvm/aAwdQ759Y6V7SGhv@google.com/ [1]
Link: https://lore.kernel.org/kvm/9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com/ [2]
---
v7: add Rick's Reviewed-by

v6:
Drop vcpu_fpu_config.user_* (Rick)
Reset guest default size when XSAVE is unavaiable or disabled (Chang)

v5:
Add a new vcpu_fpu_config instead of adding new members to
fpu_state_config (Chang)
Extract a helper to set default values (Chang)
---
 arch/x86/include/asm/fpu/types.h | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c       |  1 +
 arch/x86/kernel/fpu/init.c       |  1 +
 arch/x86/kernel/fpu/xstate.c     | 27 +++++++++++++++++++++------
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 1c94121acd3d..abd193a1a52e 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -551,6 +551,31 @@ struct fpu_guest {
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
+	 * @features:
+	 *
+	 * The default supported features bitmap in guest FPUs. Does not
+	 * include independent managed features and features which have to
+	 * be requested by user space before usage.
+	 */
+	u64 features;
+};
+
 /*
  * FPU state configuration data. Initialized at boot time. Read only after init.
  */
@@ -606,5 +631,6 @@ struct fpu_state_config {
 
 /* FPU state configuration information */
 extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+extern struct vcpu_fpu_config guest_default_cfg;
 
 #endif /* _ASM_X86_FPU_TYPES_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1cda5b78540b..2cd5e1910ff8 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -36,6 +36,7 @@ DEFINE_PER_CPU(u64, xfd_state);
 /* The FPU state configuration data for kernel and user space */
 struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
 struct fpu_state_config fpu_user_cfg __ro_after_init;
+struct vcpu_fpu_config guest_default_cfg __ro_after_init;
 
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 6bb3e35c40e2..e19660cdc70c 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -202,6 +202,7 @@ static void __init fpu__init_system_xstate_size_legacy(void)
 	fpu_kernel_cfg.default_size = size;
 	fpu_user_cfg.max_size = size;
 	fpu_user_cfg.default_size = size;
+	guest_default_cfg.size = size;
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1c8410b68108..f32047e12500 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -742,6 +742,9 @@ static int __init init_xstate_size(void)
 	fpu_user_cfg.default_size =
 		xstate_calculate_size(fpu_user_cfg.default_features, false);
 
+	guest_default_cfg.size =
+		xstate_calculate_size(guest_default_cfg.features, compacted);
+
 	return 0;
 }
 
@@ -762,6 +765,7 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpu_kernel_cfg.default_size = legacy_size;
 	fpu_user_cfg.max_size = legacy_size;
 	fpu_user_cfg.default_size = legacy_size;
+	guest_default_cfg.size = legacy_size;
 
 	/*
 	 * Prevent enabling the static branch which enables writes to the
@@ -772,6 +776,21 @@ static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 	fpstate_reset(x86_task_fpu(current));
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
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -854,12 +873,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
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
2.47.1


