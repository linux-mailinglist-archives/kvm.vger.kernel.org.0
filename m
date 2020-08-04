Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8092223BE9D
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgHDRIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 13:08:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36446 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729632AbgHDRI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 13:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596560908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAkg/Iwx4xnjg6Rnu+uqLzEQ6JwtFTxMfaav6AgT7dU=;
        b=Xg5gKdE5RKC6kSeIOOC2j+slpGNB2KBK9sAumiOzJdPAFnnIajb/e9u0UtY+Zje/yPPg0I
        XiWCWEx8OFLrBqZY2ypMfpi/Z+hPEXALO/+2nvRVRVOAcHsCDY3CIMJ258u6EQNb4Xz7eq
        MC8TQN4r/WDuGxm8G0F6wjJvXyN4mug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-HN4gs_NwNji8AcnAAw6L6A-1; Tue, 04 Aug 2020 13:06:21 -0400
X-MC-Unique: HN4gs_NwNji8AcnAAw6L6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E15E2800475;
        Tue,  4 Aug 2020 17:06:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F97272E48;
        Tue,  4 Aug 2020 17:06:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, steven.price@arm.com, pbonzini@redhat.com
Subject: [PATCH v2 6/6] arm64/x86: KVM: Introduce steal-time cap
Date:   Tue,  4 Aug 2020 19:06:04 +0200
Message-Id: <20200804170604.42662-7-drjones@redhat.com>
In-Reply-To: <20200804170604.42662-1-drjones@redhat.com>
References: <20200804170604.42662-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
support for steal-time. However this is unnecessary, as only a KVM
fd is required, and it complicates userspace (userspace may prefer
delaying vcpu creation until after feature probing). Introduce a cap
that can be checked instead. While x86 can already probe steal-time
support with a kvm fd (KVM_GET_SUPPORTED_CPUID), we add the cap there
too for consistency.

Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virt/kvm/api.rst    | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           |  2 +-
 arch/x86/kvm/x86.c                |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 6 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3bd96c1a3962..51208c5d6ac2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6152,3 +6152,16 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_STEAL_TIME
+-----------------------
+
+:Architectures: arm64, x86
+
+This capability indicates that KVM supports steal time accounting.
+When steal time accounting is supported it may be enabled with
+architecture-specific interfaces.  This capability and the architecture-
+specific interfaces must be consistent, i.e. if one says the feature
+is supported, than the other should as well and vice versa.  For arm64
+see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
+For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1b65dfeb6fed..57c44bc56087 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
+bool kvm_arm_pvtime_supported(void);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 90cb90561446..0f7f8cd2f341 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 */
 		r = 1;
 		break;
+	case KVM_CAP_STEAL_TIME:
+		r = kvm_arm_pvtime_supported();
+		break;
 	default:
 		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
 		break;
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 75234321d896..920ac43077ad 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -71,7 +71,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
-static bool kvm_arm_pvtime_supported(void)
+bool kvm_arm_pvtime_supported(void)
 {
 	return !!sched_info_on();
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..27fc86bb28c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3538,6 +3538,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
+	case KVM_CAP_STEAL_TIME:
+		r = sched_info_on();
+		break;
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4fdf30316582..121fb29ac004 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_STEAL_TIME 184
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.4

