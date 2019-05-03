Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0105712E11
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfECMqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:00 -0400
Received: from foss.arm.com ([217.140.101.70]:60452 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfECMqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23D5B15AD;
        Fri,  3 May 2019 05:46:00 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0EA13F220;
        Fri,  3 May 2019 05:45:56 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 22/56] KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
Date:   Fri,  3 May 2019 13:43:53 +0100
Message-Id: <20190503124427.190206-23-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Some aspects of vcpu configuration may be too complex to be
completed inside KVM_ARM_VCPU_INIT.  Thus, there may be a
requirement for userspace to do some additional configuration
before various other ioctls will work in a consistent way.

In particular this will be the case for SVE, where userspace will
need to negotiate the set of vector lengths to be made available to
the guest before the vcpu becomes fully usable.

In order to provide an explicit way for userspace to confirm that
it has finished setting up a particular vcpu feature, this patch
adds a new ioctl KVM_ARM_VCPU_FINALIZE.

When userspace has opted into a feature that requires finalization,
typically by means of a feature flag passed to KVM_ARM_VCPU_INIT, a
matching call to KVM_ARM_VCPU_FINALIZE is now required before
KVM_RUN or KVM_GET_REG_LIST is allowed.  Individual features may
impose additional restrictions where appropriate.

No existing vcpu features are affected by this, so current
userspace implementations will continue to work exactly as before,
with no need to issue KVM_ARM_VCPU_FINALIZE.

As implemented in this patch, KVM_ARM_VCPU_FINALIZE is currently a
placeholder: no finalizable features exist yet, so ioctl is not
required and will always yield EINVAL.  Subsequent patches will add
the finalization logic to make use of this ioctl for SVE.

No functional change for existing userspace.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  4 ++++
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 include/uapi/linux/kvm.h          |  3 +++
 virt/kvm/arm/arm.c                | 18 ++++++++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index a49ee01242ff..e80cfc18412b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #ifndef __ARM_KVM_HOST_H__
 #define __ARM_KVM_HOST_H__
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/cputype.h>
@@ -411,4 +412,7 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
+#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
+#define kvm_arm_vcpu_is_finalized(vcpu) true
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e8950942591..98658f7dad68 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -23,6 +23,7 @@
 #define __ARM64_KVM_HOST_H__
 
 #include <linux/bitmap.h>
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kvm_types.h>
@@ -625,4 +626,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
+#define kvm_arm_vcpu_is_finalized(vcpu) true
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dc77a5a3648d..c3b8e7a31315 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1441,6 +1441,9 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_HYPERV_CPUID */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
+/* Available with KVM_CAP_ARM_SVE */
+#define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c69e1370a5dc..9edbf0f676e7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -545,6 +545,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (likely(vcpu->arch.has_run_once))
 		return 0;
 
+	if (!kvm_arm_vcpu_is_finalized(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -1116,6 +1119,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (unlikely(!kvm_vcpu_initialized(vcpu)))
 			break;
 
+		r = -EPERM;
+		if (!kvm_arm_vcpu_is_finalized(vcpu))
+			break;
+
 		r = -EFAULT;
 		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
 			break;
@@ -1169,6 +1176,17 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_set_events(vcpu, &events);
 	}
+	case KVM_ARM_VCPU_FINALIZE: {
+		int what;
+
+		if (!kvm_vcpu_initialized(vcpu))
+			return -ENOEXEC;
+
+		if (get_user(what, (const int __user *)argp))
+			return -EFAULT;
+
+		return kvm_arm_vcpu_finalize(vcpu, what);
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.20.1

