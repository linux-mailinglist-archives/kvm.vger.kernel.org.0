Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA59DF175
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfJUP3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:29:25 -0400
Received: from [217.140.110.172] ([217.140.110.172]:55862 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbfJUP3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:29:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CBFA15A1;
        Mon, 21 Oct 2019 08:28:49 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A2983F71F;
        Mon, 21 Oct 2019 08:28:47 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/10] KVM: arm64: Provide VCPU attributes for stolen time
Date:   Mon, 21 Oct 2019 16:28:20 +0100
Message-Id: <20191021152823.14882-8-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191021152823.14882-1-steven.price@arm.com>
References: <20191021152823.14882-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow user space to inform the KVM host where in the physical memory
map the paravirtualized time structures should be located.

User space can set an attribute on the VCPU providing the IPA base
address of the stolen time structure for that VCPU. This must be
repeated for every VCPU in the VM.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  7 ++++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/guest.c            |  9 +++++
 include/uapi/linux/kvm.h          |  2 ++
 virt/kvm/arm/pvtime.c             | 59 +++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 75ef37f79633..eb1f33af45aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -490,6 +490,13 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
+int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->steal.base = GPA_INVALID;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 67c21f9bdbad..cff1ba12c768 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -323,6 +323,8 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd626447482..d3ac9d2fd405 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -858,6 +858,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVTIME_CTRL:
+		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -878,6 +881,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVTIME_CTRL:
+		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -898,6 +904,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVTIME_CTRL:
+		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..a540c8357049 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1227,6 +1227,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
index b90b3a7bea85..1e0f4c284888 100644
--- a/virt/kvm/arm/pvtime.c
+++ b/virt/kvm/arm/pvtime.c
@@ -2,7 +2,9 @@
 // Copyright (C) 2019 Arm Ltd.
 
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 
+#include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -70,3 +72,60 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 
 	return base;
 }
+
+int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	u64 ipa;
+	int ret = 0;
+	int idx;
+
+	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+		return -ENXIO;
+
+	if (get_user(ipa, user))
+		return -EFAULT;
+	if (!IS_ALIGNED(ipa, 64))
+		return -EINVAL;
+	if (vcpu->arch.steal.base != GPA_INVALID)
+		return -EEXIST;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.steal.base = ipa;
+
+	return ret;
+}
+
+int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+
+	if (attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+		return -ENXIO;
+
+	ipa = vcpu->arch.steal.base;
+
+	if (put_user(ipa, user))
+		return -EFAULT;
+	return 0;
+}
+
+int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PVTIME_IPA:
+		return 0;
+	}
+	return -ENXIO;
+}
-- 
2.20.1

