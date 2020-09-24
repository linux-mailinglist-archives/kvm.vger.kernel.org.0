Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C4427747B
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgIXO6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbgIXO60 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+3BDgNEh6WQR4cWZDffvHCn1h3EKsWOUm/P48DIWyM=;
        b=gA0Youiqmo2/Gl1Eyt8j9iW7Ugv+vOsMu7xMFewES1BL1Of2uhNQjsKJIvAARi6kDtjnaI
        rbAd0OJEcUU2qjV1w6pTcGV808UrtOdbjV4Hn2i4JIIX6rcoORNYGJvOjGeKeXKM9oHcAN
        y4GI5JhVs2pvQJJRDoENLwIkxruZKS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-bcSfsg2oMZiNhLYSbb7dVg-1; Thu, 24 Sep 2020 10:58:20 -0400
X-MC-Unique: bcSfsg2oMZiNhLYSbb7dVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 439221084CA8;
        Thu, 24 Sep 2020 14:58:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D7995576C;
        Thu, 24 Sep 2020 14:58:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
Date:   Thu, 24 Sep 2020 16:57:56 +0200
Message-Id: <20200924145757.1035782-7-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 include/uapi/linux/kvm.h       |  3 ++-
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a552d41308e1..c323b346f001 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4455,9 +4455,9 @@ that KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is present.
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
index 4b1a092d9e51..6170489bb823 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3453,6 +3453,26 @@ static inline bool kvm_can_mwait_in_guest(void)
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
@@ -3489,6 +3509,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
@@ -3671,6 +3692,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_MSRS:
 		r = msr_io(NULL, argp, do_get_msr_feature, 1);
 		break;
+	case KVM_GET_SUPPORTED_HV_CPUID:
+		r = kvm_ioctl_get_supported_hv_cpuid(argp);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -4740,24 +4764,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 7d8eced6f459..3ebd48e72cdd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1037,6 +1037,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_SYS_HYPERV_CPUID 188
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1495,7 +1496,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
 /* Available with KVM_CAP_ARM_SVE */
-- 
2.25.4

