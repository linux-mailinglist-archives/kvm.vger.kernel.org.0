Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77527312214
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 08:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBGG6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:58:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:48431 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhBGG5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:57:55 -0500
IronPort-SDR: E4f3NOfFG/8BtYItaJu3G4B4+D9WdP/QtgxCgGBmMT1d/o/8A1dl1xL9ql62AOs/UYP/b+qPnE
 WT/6VDyAwOLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660852"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660852"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:51 -0800
IronPort-SDR: dIqPEJcRoYUpsE1RAVhPQDzeGJf0iZtAL1B2H/GOBqKWVZxkf5yUzkuc3sf6G/DrP5YYcLtz5u
 OOIvABNMVRmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376593"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:49 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
Date:   Sun,  7 Feb 2021 10:42:53 -0500
Message-Id: <20210207154256.52850-5-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The static xstate buffer kvm_xsave contains the extended register
states, but it is not enough for dynamic features with large state.

Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
detect if hardware has XSAVE extension (XFD). Meanwhile, add two
new ioctl interfaces to get/set the whole xstate using struct
kvm_xsave_extension buffer containing both static and dynamic
xfeatures. Reuse fill_xsave and load_xsave for both cases.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  5 +++
 arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++--------
 include/uapi/linux/kvm.h        |  8 ++++
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 89e5f3d1bba8..bf785e89a728 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -362,6 +362,11 @@ struct kvm_xsave {
 	__u32 region[1024];
 };
 
+/* for KVM_CAP_XSAVE_EXTENSION */
+struct kvm_xsave_extension {
+	__u32 region[3072];
+};
+
 #define KVM_MAX_XCRS	16
 
 struct kvm_xcr {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15908bc65d1c..bfbde877221e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3786,6 +3786,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_XCRS:
 		r = boot_cpu_has(X86_FEATURE_XSAVE);
 		break;
+	case KVM_CAP_X86_XSAVE_EXTENSION:
+		r = boot_cpu_has(X86_FEATURE_XSAVE) &&
+			boot_cpu_has(X86_FEATURE_XFD);
+		break;
 	case KVM_CAP_TSC_CONTROL:
 		r = kvm_has_tsc_control;
 		break;
@@ -4395,7 +4399,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 #define XSTATE_COMPACTION_ENABLED (1ULL << 63)
 
-static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
+static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu, bool has_extension)
 {
 	struct xregs_state *xsave;
 	struct fpu *guest_fpu;
@@ -4403,9 +4407,14 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 	u64 valid;
 
 	guest_fpu = vcpu->arch.guest_fpu;
-	xsave = &guest_fpu->state.xsave;
+	xsave = __xsave(guest_fpu);
 	xstate_bv = xsave->header.xfeatures;
 
+	if (!has_extension) {
+		/* truncate with only non-dynamic features */
+		xstate_bv = xstate_bv & ~xfeatures_mask_user_dynamic;
+	}
+
 	/*
 	 * Copy legacy XSAVE area, to avoid complications with CPUID
 	 * leaves 0 and 1 in the loop below.
@@ -4450,7 +4459,7 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	u64 valid;
 
 	guest_fpu = vcpu->arch.guest_fpu;
-	xsave = &guest_fpu->state.xsave;
+	xsave = __xsave(guest_fpu);
 
 	/*
 	 * Copy legacy XSAVE area, to avoid complications with CPUID
@@ -4488,29 +4497,31 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	}
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu, u32 *region, bool has_extension)
 {
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
-		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
-		fill_xsave((u8 *) guest_xsave->region, vcpu);
+		if (has_extension)
+			memset(region, 0, sizeof(struct kvm_xsave_extension));
+		else
+			memset(region, 0, sizeof(struct kvm_xsave));
+
+		fill_xsave((u8 *)region, vcpu, has_extension);
 	} else {
-		memcpy(guest_xsave->region,
+		memcpy(region,
 			&vcpu->arch.guest_fpu->state.fxsave,
 			sizeof(struct fxregs_state));
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
+		*(u64 *)&region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
 	}
 }
 
 #define XSAVE_MXCSR_OFFSET 24
 
-static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
-					struct kvm_xsave *guest_xsave)
+static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu, u32 *region)
 {
 	u64 xstate_bv =
-		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)];
-	u32 mxcsr = *(u32 *)&guest_xsave->region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
+		*(u64 *)&region[XSAVE_HDR_OFFSET / sizeof(u32)];
+	u32 mxcsr = *(u32 *)&region[XSAVE_MXCSR_OFFSET / sizeof(u32)];
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		/*
@@ -4520,13 +4531,13 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		 */
 		if (xstate_bv & ~supported_xcr0 || mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
-		load_xsave(vcpu, (u8 *)guest_xsave->region);
+		load_xsave(vcpu, (u8 *)region);
 	} else {
 		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
 			mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
 		memcpy(&vcpu->arch.guest_fpu->state.fxsave,
-			guest_xsave->region, sizeof(struct fxregs_state));
+			region, sizeof(struct fxregs_state));
 	}
 	return 0;
 }
@@ -4642,6 +4653,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	union {
 		struct kvm_lapic_state *lapic;
 		struct kvm_xsave *xsave;
+		struct kvm_xsave_extension *xsave_ext;
 		struct kvm_xcrs *xcrs;
 		void *buffer;
 	} u;
@@ -4847,7 +4859,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave->region, false);
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
@@ -4855,6 +4867,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_GET_XSAVE_EXTENSION: {
+		u.xsave_ext = kzalloc(sizeof(struct kvm_xsave_extension), GFP_KERNEL_ACCOUNT);
+		r = -ENOMEM;
+		if (!u.xsave_ext)
+			break;
+
+		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave_ext->region, true);
+
+		r = -EFAULT;
+		if (copy_to_user(argp, u.xsave_ext, sizeof(struct kvm_xsave_extension)))
+			break;
+		r = 0;
+		break;
+	}
 	case KVM_SET_XSAVE: {
 		u.xsave = memdup_user(argp, sizeof(*u.xsave));
 		if (IS_ERR(u.xsave)) {
@@ -4862,7 +4888,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			goto out_nofree;
 		}
 
-		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);
+		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave->region);
+		break;
+	}
+	case KVM_SET_XSAVE_EXTENSION: {
+		u.xsave_ext = memdup_user(argp, sizeof(*u.xsave_ext));
+		if (IS_ERR(u.xsave_ext)) {
+			r = PTR_ERR(u.xsave_ext);
+			goto out_nofree;
+		}
+
+		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave_ext->region);
 		break;
 	}
 	case KVM_GET_XCRS: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..42a167a29350 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_X86_XSAVE_EXTENSION 191
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1462,6 +1463,13 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_XSAVE */
 #define KVM_GET_XSAVE		  _IOR(KVMIO,  0xa4, struct kvm_xsave)
 #define KVM_SET_XSAVE		  _IOW(KVMIO,  0xa5, struct kvm_xsave)
+/*
+ * Available with KVM_CAP_XSAVE_EXTENSION
+ * 0xa4/0xa5 are ok for the new ioctls since structure size is different.
+ */
+#define KVM_GET_XSAVE_EXTENSION   _IOW(KVMIO,  0xa4, struct kvm_xsave_extension)
+#define KVM_SET_XSAVE_EXTENSION   _IOW(KVMIO,  0xa5, struct kvm_xsave_extension)
+
 /* Available with KVM_CAP_XCRS */
 #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
-- 
2.18.4

