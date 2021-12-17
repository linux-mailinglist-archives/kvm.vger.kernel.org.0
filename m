Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0A478FBB
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbhLQPaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:10852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238243AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z0qw6k02GCrK+dqLpnYIbrq3jMZsIMBndSKn0eXyQqs=;
  b=benw4jgxs3MT72ba+lBigx3D3bmaajHObV2wR0McO+ADNVI3ZErnDNZx
   P2fqpxODpJrKCSP7ILY4BRVRinDMHaLxe1s2i5JYyMYnMtLN5AC7knr6i
   6PZGc6i4Ae3YMhWOi5j5tzTUtrntA5JCbJuXe2RkF3PvoeXF+6S+IG0ea
   5tpLb/NoMZN38IfhBmZly8Zkput1GX3jsCMp5ds839jvwTIT9/QB2k2Dz
   B813TiGn3JcTRPqquOXEA/EY5O2noWAun+st5qMGw+5JbOlEcqZ+oc9zq
   +YaLxgeuY87D404Tj6aGQ+j3ixBVWsri+12Jr0D0iTXXdvnmi34r3i0E/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723466"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723466"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588464"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 18/23] kvm: x86: Get/set expanded xstate buffer
Date:   Fri, 17 Dec 2021 07:29:58 -0800
Message-Id: <20211217153003.1719189-19-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guang Zeng <guang.zeng@intel.com>

When AMX is enabled it requires a larger xstate buffer than the
legacy hardcoded 4KB one. Exising kvm ioctls (KVM_[G|S]ET_XSAVE
under KVM_CAP_XSAVE) are not suitable for this purpose.

A new capability (KVM_CAP_XSAVE2) is introduced to mark an extended
kvm_xsave format for supporting >4KB fpstate. The expanded fpstate
size is returned to userspace when KVM_CAP_XSAVE2 is queried.

Introduce KVM_GET_XSAVE2 under this capability with the new format
for copying kernel fpstate to userspace.

Reuse KVM_SET_XSAVE for both old/new formats by reimplementing it to
do properly-sized memdup_user() based on guest fpstate.

Signed-off-by: Guang Zeng <guang.zeng@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 12 ++++++++++-
 arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  4 ++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a776a08f78c..240e17829e89 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -373,9 +373,19 @@ struct kvm_debugregs {
 	__u64 reserved[9];
 };
 
-/* for KVM_CAP_XSAVE */
+/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
 struct kvm_xsave {
+	/*
+	 * KVM_GET_XSAVE only uses the first 4096 bytes.
+	 *
+	 * KVM_GET_XSAVE2 must have the size match what is returned by
+	 * KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
+	 *
+	 * KVM_SET_XSAVE uses the extra field if guest_fpu::fpstate::size
+	 * exceeds 4096 bytes.
+	 */
 	__u32 region[1024];
+	__u32 extra[0];
 };
 
 #define KVM_MAX_XCRS	16
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f8bacf18e6ed..796a9f2d1f23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4296,6 +4296,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = 0;
 		break;
+	case KVM_CAP_XSAVE2:
+		r = kvm->vcpus[0]->arch.guest_fpu.uabi_size;
+		break;
 	default:
 		break;
 	}
@@ -4899,6 +4902,16 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				       vcpu->arch.pkru);
 }
 
+static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
+					  u8 *state, unsigned int size)
+{
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return;
+
+	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
+				       state, size, vcpu->arch.pkru);
+}
+
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
@@ -5366,7 +5379,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_XSAVE: {
-		u.xsave = memdup_user(argp, sizeof(*u.xsave));
+		int size = vcpu->arch.guest_fpu.uabi_size;
+
+		u.xsave = memdup_user(argp, size);
 		if (IS_ERR(u.xsave)) {
 			r = PTR_ERR(u.xsave);
 			goto out_nofree;
@@ -5375,6 +5390,26 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);
 		break;
 	}
+
+	case KVM_GET_XSAVE2: {
+		int size = vcpu->arch.guest_fpu.uabi_size;
+
+		u.xsave = kzalloc(size, GFP_KERNEL_ACCOUNT);
+		if (!u.xsave) {
+			r = -ENOMEM;
+			break;
+		}
+
+		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+
+		if (copy_to_user(argp, u.xsave, size)) {
+			r = -EFAULT;
+			break;
+		}
+		r = 0;
+		break;
+	}
+
 	case KVM_GET_XCRS: {
 		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL_ACCOUNT);
 		r = -ENOMEM;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..9d1c01669560 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_XSAVE2 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1610,6 +1611,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
-- 
2.27.0

