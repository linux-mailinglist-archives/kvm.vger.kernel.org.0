Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C818821C37A
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGKKEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 06:04:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33840 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgGKKEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jul 2020 06:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594461890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Loz/by5cCzQfeF0Iy4rcvDt836YPjU7na+/HRz/MmxY=;
        b=MKF5o/AwkJl+uKrg1LBRSrv3sclDx9BoOCtuLCJAIhDRBww9NdWsP7Q9kBFXGg/q1s3SQZ
        5h2piyuMb64Kji/psx3ZeHGyVztkifvDxPt4bdAH0X24HeS4z4qaFl717+ieZhkemYC8ub
        4RZVJ7s41uhJsH9S1uIuD5vyAeNrFKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-TaQC9ItrNhmlp5Oyr4oVbQ-1; Sat, 11 Jul 2020 06:04:48 -0400
X-MC-Unique: TaQC9ItrNhmlp5Oyr4oVbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29740E91B;
        Sat, 11 Jul 2020 10:04:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE9EF19D61;
        Sat, 11 Jul 2020 10:04:45 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: [PATCH 5/5] arm64/x86: KVM: Introduce steal-time cap
Date:   Sat, 11 Jul 2020 12:04:34 +0200
Message-Id: <20200711100434.46660-6-drjones@redhat.com>
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 Documentation/virt/kvm/api.rst    | 11 +++++++++++
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/pvtime.c           |  2 +-
 arch/x86/kvm/x86.c                |  3 +++
 include/uapi/linux/kvm.h          |  1 +
 6 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3bd96c1a3962..3716d1e29771 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6152,3 +6152,14 @@ KVM can therefore start protected VMs.
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
+architecture-specific interfaces.  For x86 see
+Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
+Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b01f52b61572..8909c840ea91 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -500,6 +500,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
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
index 025b5f3a97ef..468bd1ef9c7e 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -73,7 +73,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
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

