Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F90423E954
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgHGIkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:40:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53431 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728071AbgHGIkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yHxQsreLsQCcoAZzJ0RILY+JhPpLl1iv6YFjaVsyomI=;
        b=JsZZr1QULp/5dvdOJHN66cy6Qz1a/uoIwO5ViHGSwA1afM3O7B4Xhw46F+Sq/fqgWVc88K
        l1dq0MC/ZHlgzlUiUCT5bFb5CQK8wKe0EVeh4NIAS4RAyBV9CS1zpWKu/kv9wGOHyHa6NQ
        9HgxQWTtBncrbTyNFAw5Ei4i6dPzvNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-31uDRS6xNiGombWvzQ_s-w-1; Fri, 07 Aug 2020 04:40:20 -0400
X-MC-Unique: 31uDRS6xNiGombWvzQ_s-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8914800472;
        Fri,  7 Aug 2020 08:40:18 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187FC5FC3B;
        Fri,  7 Aug 2020 08:40:12 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
Date:   Fri,  7 Aug 2020 10:39:45 +0200
Message-Id: <20200807083946.377654-7-vkuznets@redhat.com>
In-Reply-To: <20200807083946.377654-1-vkuznets@redhat.com>
References: <20200807083946.377654-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_HV_CPUID is a vCPU ioctl but its output is now
independent from vCPU and in some cases VMMs may want to use it as a system
ioctl instead. In particular, QEMU doesn CPU feature expansion before any
vCPU gets created so KVM_GET_SUPPORTED_HV_CPUID can't be used.

Convert KVM_GET_SUPPORTED_HV_CPUID to 'dual' system/vCPU ioctl with the
same meaning.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst |  4 ++--
 arch/x86/kvm/x86.c             | 43 ++++++++++++++++++++--------------
 include/uapi/linux/kvm.h       |  4 ++--
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6acdc6f80aee..4672d6e4d955 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4451,9 +4451,9 @@ that KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is present.
 4.118 KVM_GET_SUPPORTED_HV_CPUID
 --------------------------------
 
-:Capability: KVM_CAP_HYPERV_CPUID
+:Capability: KVM_CAP_HYPERV_CPUID (vcpu), KVM_CAP_SYS_HYPERV_CPUID (system)
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: system ioctl, vcpu ioctl
 :Parameters: struct kvm_cpuid2 (in/out)
 :Returns: 0 on success, -1 on error
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4659067c2e53..f2002f2b4ab8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3457,6 +3457,26 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_cpuid2 __user *cpuid_arg)
+{
+	struct kvm_cpuid2 cpuid;
+	int r;
+
+	r = -EFAULT;
+	if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
+		return r;
+
+	r = kvm_get_hv_cpuid(&cpuid, cpuid_arg->entries);
+	if (r)
+		return r;
+
+	r = -EFAULT;
+	if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
+		return r;
+
+	return 0;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -3493,6 +3513,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
@@ -3672,6 +3693,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_MSRS:
 		r = msr_io(NULL, argp, do_get_msr_feature, 1);
 		break;
+	case KVM_GET_SUPPORTED_HV_CPUID:
+		r = kvm_ioctl_get_supported_hv_cpuid(argp);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -4741,24 +4765,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
-	case KVM_GET_SUPPORTED_HV_CPUID: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
-
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
-			goto out;
-
-		r = kvm_get_hv_cpuid(&cpuid, cpuid_arg->entries);
-		if (r)
-			goto out;
-
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
-			goto out;
-		r = 0;
+	case KVM_GET_SUPPORTED_HV_CPUID:
+		r = kvm_ioctl_get_supported_hv_cpuid(argp);
 		break;
-	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2c73dcfb3dbb..05459dd3dc70 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1034,7 +1034,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ASYNC_PF_INT 183
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
-
+#define KVM_CAP_SYS_HYPERV_CPUID 186
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1493,7 +1493,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
 /* Available with KVM_CAP_ARM_SVE */
-- 
2.25.4

