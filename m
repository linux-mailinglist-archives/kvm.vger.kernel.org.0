Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BBE46BEEB
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbhLGPOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:14:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:53842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238876AbhLGPNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237536538"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237536538"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290155"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:10:06 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Date:   Tue,  7 Dec 2021 19:03:56 -0500
Message-Id: <20211208000359.2853257-17-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

When dynamic XSTATE features are supported, the xsave states are
beyond 4KB. The current kvm_xsave structure and related
KVM_{G, S}ET_XSAVE only allows 4KB which is not enough for full
states.

Introduce a new kvm_xsave2 structure and the corresponding
KVM_GET_XSAVE2 and KVM_SET_XSAVE2 ioctls so that userspace VMM
can get and set the full xsave states.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  6 ++++
 arch/x86/kvm/x86.c              | 62 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  7 +++-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a776a08f78c..de42a51e20c3 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -47,6 +47,7 @@
 #define __KVM_HAVE_VCPU_EVENTS
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
+#define __KVM_HAVE_XSAVE2
 #define __KVM_HAVE_XCRS
 #define __KVM_HAVE_READONLY_MEM
 
@@ -378,6 +379,11 @@ struct kvm_xsave {
 	__u32 region[1024];
 };
 
+struct kvm_xsave2 {
+	__u32 size;
+	__u8 state[0];
+};
+
 #define KVM_MAX_XCRS	16
 
 struct kvm_xcr {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b033c9241d6..d212f6d2d39a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4216,6 +4216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
+	case KVM_CAP_XSAVE2:
 	case KVM_CAP_ASYNC_PF:
 	case KVM_CAP_ASYNC_PF_INT:
 	case KVM_CAP_GET_TSC_KHZ:
@@ -4940,6 +4941,17 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				       vcpu->arch.pkru);
 }
 
+static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
+					  u8 *state, u32 size)
+{
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return;
+
+	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu,
+				       state, size,
+				       vcpu->arch.pkru);
+}
+
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
@@ -4951,6 +4963,15 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					      supported_xcr0, &vcpu->arch.pkru);
 }
 
+static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *state)
+{
+	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return 0;
+
+	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
+					      supported_xcr0, &vcpu->arch.pkru);
+}
+
 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
 					struct kvm_xcrs *guest_xcrs)
 {
@@ -5416,6 +5437,47 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);
 		break;
 	}
+	case KVM_GET_XSAVE2: {
+		struct kvm_xsave2 __user *xsave2_arg = argp;
+		struct kvm_xsave2 xsave2;
+
+		r = -EFAULT;
+		if (copy_from_user(&xsave2, xsave2_arg, sizeof(struct kvm_xsave2)))
+			break;
+
+		u.buffer = kzalloc(xsave2.size, GFP_KERNEL_ACCOUNT);
+
+		r = -ENOMEM;
+		if (!u.buffer)
+			break;
+
+		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, xsave2.size);
+
+		r = -EFAULT;
+		if (copy_to_user(xsave2_arg->state, u.buffer, xsave2.size))
+			break;
+
+		r = 0;
+		break;
+	}
+	case KVM_SET_XSAVE2: {
+		struct kvm_xsave2 __user *xsave2_arg = argp;
+		struct kvm_xsave2 xsave2;
+
+		r = -EFAULT;
+		if (copy_from_user(&xsave2, xsave2_arg, sizeof(struct kvm_xsave2)))
+			break;
+
+		u.buffer = memdup_user(xsave2_arg->state, xsave2.size);
+
+		if (IS_ERR(u.buffer)) {
+			r = PTR_ERR(u.buffer);
+			goto out_nofree;
+		}
+
+		r = kvm_vcpu_ioctl_x86_set_xsave2(vcpu, u.buffer);
+		break;
+	}
 	case KVM_GET_XCRS: {
 		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL_ACCOUNT);
 		r = -ENOMEM;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0c7b301c7254..603e1ca9ba09 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1132,7 +1132,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
-
+#ifdef __KVM_HAVE_XSAVE2
+#define KVM_CAP_XSAVE2 207
+#endif
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
@@ -1679,6 +1681,9 @@ struct kvm_xen_hvm_attr {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
+#define KVM_GET_XSAVE2		   _IOR(KVMIO,  0xcf, struct kvm_xsave2)
+#define KVM_SET_XSAVE2		   _IOW(KVMIO,  0xd0, struct kvm_xsave2)
+
 struct kvm_xen_vcpu_attr {
 	__u16 type;
 	__u16 pad[3];
