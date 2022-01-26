Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF21249CDFB
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbiAZPW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:22:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242749AbiAZPWU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AtISGxDKqp2+YL6RMZb18kawYorGajMtuStz3sh+IE8=;
        b=h+P0mVDPQzglfJPKyIHsMyDKYJRCQTD9TWxGVZ7cljw0bm+vGwDTZgispwq1ssnJDBv7U5
        BG3FL6IsGhFDyD4Gw4HObUj8rGhWaGpVfangvq1VjaASI6QIrQQ6WlzhEJ3eouG4KYW7Aq
        5C/oKGjH5qjeKVmYemzOMParpJX2SGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-IrvEyJjaNM2rGXiag1ouWQ-1; Wed, 26 Jan 2022 10:22:16 -0500
X-MC-Unique: IrvEyJjaNM2rGXiag1ouWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0F0310168D8;
        Wed, 26 Jan 2022 15:22:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5794B38E0F;
        Wed, 26 Jan 2022 15:22:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yang.zhong@intel.com, seanjc@google.com
Subject: [PATCH 2/3] KVM: x86: add system attribute to retrieve full set of supported xsave states
Date:   Wed, 26 Jan 2022 10:22:09 -0500
Message-Id: <20220126152210.3044876-3-pbonzini@redhat.com>
In-Reply-To: <20220126152210.3044876-1-pbonzini@redhat.com>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because KVM_GET_SUPPORTED_CPUID is meant to be passed (by simple-minded
VMMs) to KVM_SET_CPUID2, it cannot include any dynamic xsave states that
have not been enabled.  Probing those, for example so that they can be
passed to ARCH_REQ_XCOMP_GUEST_PERM, requires a new ioctl or arch_prctl.
The latter is in fact worse, even though that is what the rest of the
API uses, because it would require supported_xcr0 to be moved from the
KVM module to the kernel just for this use.  In addition, the value
would be nonsensical (or an error would have to be returned) until
the KVM module is loaded in.

KVM_CHECK_EXTENSION cannot be used because it only has 32 bits of
output; in order to limit the growth of capabilities and ioctls, the
series adds a /dev/kvm variant of KVM_{GET,HAS}_DEVICE_ATTR that
can be used in the future and by other architectures.  It then
implements it in x86 with just one group (0) and attribute
(KVM_X86_XCOMP_GUEST_SUPP).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst  |  4 ++-
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              | 45 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bb8cfddbb22d..a4267104db50 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3268,6 +3268,7 @@ number.
 
 :Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
              KVM_CAP_VCPU_ATTRIBUTES for vcpu device
+             KVM_CAP_SYS_ATTRIBUTES for system (/dev/kvm) device (no set)
 :Type: device ioctl, vm ioctl, vcpu ioctl
 :Parameters: struct kvm_device_attr
 :Returns: 0 on success, -1 on error
@@ -3302,7 +3303,8 @@ transferred is defined by the particular attribute.
 ------------------------
 
 :Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
-	     KVM_CAP_VCPU_ATTRIBUTES for vcpu device
+             KVM_CAP_VCPU_ATTRIBUTES for vcpu device
+             KVM_CAP_SYS_ATTRIBUTES for system (/dev/kvm) device
 :Type: device ioctl, vm ioctl, vcpu ioctl
 :Parameters: struct kvm_device_attr
 :Returns: 0 on success, -1 on error
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 2da3316bb559..bf6e96011dfe 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -452,6 +452,9 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
+/* attributes for system fd (group 0) */
+#define KVM_X86_XCOMP_GUEST_SUPP	0
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 056e30f85424..b533301af95a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4229,6 +4229,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SREGS2:
 	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
 	case KVM_CAP_VCPU_ATTRIBUTES:
+	case KVM_CAP_SYS_ATTRIBUTES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -4331,7 +4332,35 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	}
 	return r;
+}
+
+static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
+{
+	if (attr->group)
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_X86_XCOMP_GUEST_SUPP:
+		if (put_user(supported_xcr0, (u64 __user *)attr->addr))
+			return -EFAULT;
+		return 0;
+	default:
+		return -ENXIO;
+		break;
+	}
+}
+
+static int kvm_x86_dev_has_attr(struct kvm_device_attr *attr)
+{
+	if (attr->group)
+		return -ENXIO;
 
+	switch (attr->attr) {
+	case KVM_X86_XCOMP_GUEST_SUPP:
+		return 0;
+	default:
+		return -ENXIO;
+	}
 }
 
 long kvm_arch_dev_ioctl(struct file *filp,
@@ -4422,6 +4451,22 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_SUPPORTED_HV_CPUID:
 		r = kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
 		break;
+	case KVM_GET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+		r = -EFAULT;
+		if (copy_from_user(&attr, (void __user *)arg, sizeof(attr)))
+			break;
+		r = kvm_x86_dev_get_attr(&attr);
+		break;
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+		r = -EFAULT;
+		if (copy_from_user(&attr, (void __user *)arg, sizeof(attr)))
+			break;
+		r = kvm_x86_dev_has_attr(&attr);
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9563d294f181..b46bcdb0cab1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_SYS_ATTRIBUTES 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1


