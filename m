Return-Path: <kvm+bounces-47383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17752AC0F88
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 17:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 685DA7AA4F0
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 15:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D17228FFFB;
	Thu, 22 May 2025 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FSU97JvM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111E028FABB;
	Thu, 22 May 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747926642; cv=none; b=HLAv2Qpx0Aqla9ypXzFlNTFbYodoP2iC6e4Vp1FepRa3+aOs7NWGuojfB5XAdTvqyPDR0huWzauu2oY97vGcsq43aRSfAr6vEfljy+X3ksTpHg6xlQvSf0lfcZxnX4Nd9Yi0mIcbX+wQie0fw4FCtMq6EFpXIQ9ppvoDHS0sq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747926642; c=relaxed/simple;
	bh=mbg5ajRFMEDQQKFEx/vW+1u4KdIzkPdIQePGYoq58H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGzIngeJfdGZA+dkaJR1sJOMynmbtsWA8uwMRmUHHx0DpdfhO8e7Xt0owh2n7FFmi4boNZbG72LWykmoeAUV21+Zo4hm2+Nz43CHnkEHzw93Yf9BpYByLPDeBm/u3VZjqCKfkSSZweWr3nxJLnGwidVvN3Phbysa3d2lzEA2bZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FSU97JvM; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747926640; x=1779462640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mbg5ajRFMEDQQKFEx/vW+1u4KdIzkPdIQePGYoq58H4=;
  b=FSU97JvMoGx3jQ9V3WMfT218Ucg0LN8cgLDIKtasykfy6mqlKF1QS/4h
   Ez6LPP2JDB+4vMANFmjMezh7HPAzzU1sBv0bZjHNf5L2cgybw+Lwcuvm/
   zkJ9weJ+w7+q/+R5o5RdJ0iOYHgrVyuRQ9g2JowRLtIqbizjFauX+jAXj
   fvHHbUbnKMrH3moK+SpcfT8jsHGCroxPpUuLB2egqpyzTXmK/ld1pkyQb
   CHgNrP/98GOLKeBYPFTyDSXKjrqZtimOjsWLcVPKNFJW9+adeDUFgNTvb
   gRyc9Dyp7xtqx0Es4Ld9matkmI6AgIe6J7ISgsg4/+gOfynOHffjsoZpR
   g==;
X-CSE-ConnectionGUID: n3F10tDXScOUrA7Pb6ykwA==
X-CSE-MsgGUID: +4EoEQ7mRFyfcv+rlGsxfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61006662"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61006662"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:40 -0700
X-CSE-ConnectionGUID: PkLlwb8dQtWGXPOVveIQ0w==
X-CSE-MsgGUID: CV2DO4OSTCi7yUHNGBPLlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171627608"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 08:10:39 -0700
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
	Mitchell Levy <levymitchell0@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Stanislav Spassov <stanspas@amazon.de>,
	Eric Biggers <ebiggers@google.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>
Subject: [PATCH v8 1/6] x86/fpu/xstate: Differentiate default features for host and guest FPUs
Date: Thu, 22 May 2025 08:10:04 -0700
Message-ID: <20250522151031.426788-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
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

Add two helpers to provide the default feature masks for guest and host
FPUs. Default features are derived by applying the masks to the maximum
supported features.

Note that,
1) for now, guest_default_mask() and host_default_mask() are identical.
This will change in a follow-up patch once guest permissions, default
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
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/kvm/aAwdQ759Y6V7SGhv@google.com/ [1]
Link: https://lore.kernel.org/kvm/9ca17e1169805f35168eb722734fbf3579187886.camel@intel.com/ [2]
---
v8:
provide helpers to provide the default masks (Sean)

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
 arch/x86/kernel/fpu/xstate.c     | 32 ++++++++++++++++++++++++++------
 4 files changed, 54 insertions(+), 6 deletions(-)

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
index 1c8410b68108..f15be5c3f0cc 100644
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
 
+static u64 __init host_default_mask(void)
+{
+	/* Exclude dynamic features, which require userspace opt-in. */
+	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
+}
+
+static u64 __init guest_default_mask(void)
+{
+	/*
+	 * Exclude dynamic features, which require userspace opt-in even
+	 * for KVM guests.
+	 */
+	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
+}
+
 /*
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
@@ -854,12 +873,13 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
 	fpu_user_cfg.max_features = fpu_kernel_cfg.max_features;
 	fpu_user_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED;
 
-	/* Clean out dynamic features from default */
-	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
-	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
-
-	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
-	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
+	/*
+	 * Now, given maximum feature set, determine default values by
+	 * applying default masks.
+	 */
+	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features & host_default_mask();
+	fpu_user_cfg.default_features   = fpu_user_cfg.max_features & host_default_mask();
+	guest_default_cfg.features      = fpu_kernel_cfg.max_features & guest_default_mask();
 
 	/* Store it for paranoia check at the end */
 	xfeatures = fpu_kernel_cfg.max_features;
-- 
2.47.1


