Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7021487C94
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiAGS4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232428AbiAGSzd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sR7vxFiOYbciG3psN0s0MKUOYhjv+lmlyP32oWRaOM=;
        b=XIuV/ReOMND6bTTimfexA8DugHOkYw3Rm+FPzUKYkn4tdZ4o2Rg/V0lM0GrQD/h949cpyB
        eu4Ggqdg0CPzDeEJImCJ7gAh7h7alsp13354P6cdXvYbuHCb3ZkXkk3VIOWhbzv8UxpyK2
        ZU9uDPovrRbinBK+hWNrIIfTcvj8Fyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-NU2hTLGuP023zVUQ-zUuhA-1; Fri, 07 Jan 2022 13:55:31 -0500
X-MC-Unique: NU2hTLGuP023zVUQ-zUuhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C32E618C9F50;
        Fri,  7 Jan 2022 18:55:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F41C08CB2B;
        Fri,  7 Jan 2022 18:55:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 18/21] kvm: x86: Add support for getting/setting expanded xstate buffer
Date:   Fri,  7 Jan 2022 13:55:09 -0500
Message-Id: <20220107185512.25321-19-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Guang Zeng <guang.zeng@intel.com>

With KVM_CAP_XSAVE, userspace uses a hardcoded 4KB buffer to get/set
xstate data from/to KVM. This doesn't work when dynamic xfeatures
(e.g. AMX) are exposed to the guest as they require a larger buffer
size.

Introduce a new capability (KVM_CAP_XSAVE2). Userspace VMM gets the
required xstate buffer size via KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
KVM_SET_XSAVE is extended to work with both legacy and new capabilities
by doing properly-sized memdup_user() based on the guest fpu container.
KVM_GET_XSAVE is kept for backward-compatible reason. Instead,
KVM_GET_XSAVE2 is introduced under KVM_CAP_XSAVE2 as the preferred
interface for getting xstate buffer (4KB or larger size) from KVM
(Link: https://lkml.org/lkml/2021/12/15/510)

Also, update the api doc with the new KVM_GET_XSAVE2 ioctl.

Signed-off-by: Guang Zeng <guang.zeng@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-19-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++++--
 arch/x86/include/uapi/asm/kvm.h | 16 +++++++++++-
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/cpuid.h            |  2 ++
 arch/x86/kvm/x86.c              | 45 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  4 +++
 6 files changed, 106 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f4ea5e41a4d0..d3791a14eb9a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1569,6 +1569,7 @@ otherwise it will return EBUSY error.
 
   struct kvm_xsave {
 	__u32 region[1024];
+	__u32 extra[0];
   };
 
 This ioctl would copy current vcpu's xsave struct to the userspace.
@@ -1577,7 +1578,7 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
 4.43 KVM_SET_XSAVE
 ------------------
 
-:Capability: KVM_CAP_XSAVE
+:Capability: KVM_CAP_XSAVE and KVM_CAP_XSAVE2
 :Architectures: x86
 :Type: vcpu ioctl
 :Parameters: struct kvm_xsave (in)
@@ -1588,9 +1589,18 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
 
   struct kvm_xsave {
 	__u32 region[1024];
+	__u32 extra[0];
   };
 
-This ioctl would copy userspace's xsave struct to the kernel.
+This ioctl would copy userspace's xsave struct to the kernel. It copies
+as many bytes as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2),
+when invoked on the vm file descriptor. The size value returned by
+KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will always be at least 4096.
+Currently, it is only greater than 4096 if a dynamic feature has been
+enabled with ``arch_prctl()``, but this may change in the future.
+
+The offsets of the state save areas in struct kvm_xsave follow the
+contents of CPUID leaf 0xD on the host.
 
 
 4.44 KVM_GET_XCRS
@@ -5535,6 +5545,34 @@ the trailing ``'\0'``, is indicated by ``name_size`` in the header.
 The Stats Data block contains an array of 64-bit values in the same order
 as the descriptors in Descriptors block.
 
+4.42 KVM_GET_XSAVE2
+------------------
+
+:Capability: KVM_CAP_XSAVE2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_xsave (out)
+:Returns: 0 on success, -1 on error
+
+
+::
+
+  struct kvm_xsave {
+	__u32 region[1024];
+	__u32 extra[0];
+  };
+
+This ioctl would copy current vcpu's xsave struct to the userspace. It
+copies as many bytes as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+when invoked on the vm file descriptor. The size value returned by
+KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) will always be at least 4096.
+Currently, it is only greater than 4096 if a dynamic feature has been
+enabled with ``arch_prctl()``, but this may change in the future.
+
+The offsets of the state save areas in struct kvm_xsave follow the contents
+of CPUID leaf 0xD on the host.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5a776a08f78c..2da3316bb559 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -373,9 +373,23 @@ struct kvm_debugregs {
 	__u64 reserved[9];
 };
 
-/* for KVM_CAP_XSAVE */
+/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
 struct kvm_xsave {
+	/*
+	 * KVM_GET_XSAVE2 and KVM_SET_XSAVE write and read as many bytes
+	 * as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * respectively, when invoked on the vm file descriptor.
+	 *
+	 * The size value returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * will always be at least 4096. Currently, it is only greater
+	 * than 4096 if a dynamic feature has been enabled with
+	 * ``arch_prctl()``, but this may change in the future.
+	 *
+	 * The offsets of the state save areas in struct kvm_xsave follow
+	 * the contents of CPUID leaf 0xD on the host.
+	 */
 	__u32 region[1024];
+	__u32 extra[0];
 };
 
 #define KVM_MAX_XCRS	16
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ba4c3d5d2386..c55e57b30e81 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -32,7 +32,7 @@
 u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
-static u32 xstate_required_size(u64 xstate_bv, bool compacted)
+u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
 	int feature_bit = 0;
 	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c99edfff7f82..8a770b481d9d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -30,6 +30,8 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool exact_only);
 
+u32 xstate_required_size(u64 xstate_bv, bool compacted);
+
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
 u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 993eee6451ea..bde18ca657db 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4314,6 +4314,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = 0;
 		break;
+	case KVM_CAP_XSAVE2: {
+		u64 guest_perm = xstate_get_guest_group_perm();
+
+		r = xstate_required_size(supported_xcr0 & guest_perm, false);
+		if (r < sizeof(struct kvm_xsave))
+			r = sizeof(struct kvm_xsave);
+		break;
+	}
 	default:
 		break;
 	}
@@ -4917,6 +4925,16 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
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
@@ -5370,6 +5388,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_GET_XSAVE: {
+		r = -EINVAL;
+		if (vcpu->arch.guest_fpu.uabi_size > sizeof(struct kvm_xsave))
+			break;
+
 		u.xsave = kzalloc(sizeof(struct kvm_xsave), GFP_KERNEL_ACCOUNT);
 		r = -ENOMEM;
 		if (!u.xsave)
@@ -5384,7 +5406,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -5393,6 +5417,25 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_x86_set_xsave(vcpu, u.xsave);
 		break;
 	}
+
+	case KVM_GET_XSAVE2: {
+		int size = vcpu->arch.guest_fpu.uabi_size;
+
+		u.xsave = kzalloc(size, GFP_KERNEL_ACCOUNT);
+		r = -ENOMEM;
+		if (!u.xsave)
+			break;
+
+		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+
+		r = -EFAULT;
+		if (copy_to_user(argp, u.xsave, size))
+			break;
+
+		r = 0;
+		break;
+	}
+
 	case KVM_GET_XCRS: {
 		u.xcrs = kzalloc(sizeof(struct kvm_xcrs), GFP_KERNEL_ACCOUNT);
 		r = -ENOMEM;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index fbfd70d965c6..9563d294f181 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1132,6 +1132,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
+#define KVM_CAP_XSAVE2 208
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1622,6 +1623,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
-- 
2.31.1


