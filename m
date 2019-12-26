Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5814712AC9B
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfLZN7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 08:59:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726626AbfLZN7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 08:59:06 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5F3AC4EA18A47E840D42;
        Thu, 26 Dec 2019 21:59:02 +0800 (CST)
Received: from DESKTOP-1NISPDV.china.huawei.com (10.173.221.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 26 Dec 2019 21:58:54 +0800
From:   Zengruan Ye <yezengruan@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <yezengruan@huawei.com>, <maz@kernel.org>, <james.morse@arm.com>,
        <linux@armlinux.org.uk>, <suzuki.poulose@arm.com>,
        <julien.thierry.kdev@gmail.com>, <catalin.marinas@arm.com>,
        <mark.rutland@arm.com>, <will@kernel.org>, <steven.price@arm.com>,
        <daniel.lezcano@linaro.org>
Subject: [PATCH v2 4/6] KVM: arm64: Provide VCPU attributes for PV lock
Date:   Thu, 26 Dec 2019 21:58:31 +0800
Message-ID: <20191226135833.1052-5-yezengruan@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20191226135833.1052-1-yezengruan@huawei.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.221.248]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow user space to inform the KVM host where in the physical memory
map the paravirtualized lock structures should be located.

User space can set an attribute on the VCPU providing the IPA base
address of the PV lock structure for that VCPU. This must be
repeated for every VCPU in the VM.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 +++++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/guest.c            |  9 +++++
 include/uapi/linux/kvm.h          |  2 ++
 virt/kvm/arm/pvlock.c             | 57 +++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2818a2330f92..63b6e204676b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -521,6 +521,15 @@ static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
 	return (vcpu_arch->steal.base != GPA_INVALID);
 }
 
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr);
+
 static inline void kvm_arm_pvlock_preempted_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->pv.base = GPA_INVALID;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 820e5751ada7..137d966b57c7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -326,6 +326,8 @@ struct kvm_vcpu_events {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_PVLOCK_CTRL	3
+#define   KVM_ARM_VCPU_PVLOCK_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_VCPU2_SHIFT		28
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2fff06114a8f..6a5c12f3b08b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -875,6 +875,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_set_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_set_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -898,6 +901,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_get_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_get_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -921,6 +927,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 	case KVM_ARM_VCPU_PVTIME_CTRL:
 		ret = kvm_arm_pvtime_has_attr(vcpu, attr);
 		break;
+	case KVM_ARM_VCPU_PVLOCK_CTRL:
+		ret = kvm_arm_pvlock_has_attr(vcpu, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..bfc628c580d4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1238,6 +1238,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_ARM_PV_LOCK,
+#define KVM_DEV_TYPE_ARM_PV_LOCK	KVM_DEV_TYPE_ARM_PV_LOCK
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/pvlock.c b/virt/kvm/arm/pvlock.c
index cdfd30a903b9..cbc562274e5e 100644
--- a/virt/kvm/arm/pvlock.c
+++ b/virt/kvm/arm/pvlock.c
@@ -44,3 +44,60 @@ void kvm_update_pvlock_preempted(struct kvm_vcpu *vcpu, u64 preempted)
 	kvm_put_guest(kvm, base + offset, preempted_le, u64);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
+
+int kvm_arm_pvlock_set_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	u64 ipa;
+	int ret = 0;
+	int idx;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	if (get_user(ipa, user))
+		return -EFAULT;
+	if (!IS_ALIGNED(ipa, 64))
+		return -EINVAL;
+	if (vcpu->arch.pv.base != GPA_INVALID)
+		return -EEXIST;
+
+	/* Check the address is in a valid memslot */
+	idx = srcu_read_lock(&kvm->srcu);
+	if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+		ret = -EINVAL;
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	if (!ret)
+		vcpu->arch.pv.base = ipa;
+
+	return ret;
+}
+
+int kvm_arm_pvlock_get_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+
+	if (attr->attr != KVM_ARM_VCPU_PVLOCK_IPA)
+		return -ENXIO;
+
+	ipa = vcpu->arch.pv.base;
+
+	if (put_user(ipa, user))
+		return -EFAULT;
+	return 0;
+}
+
+int kvm_arm_pvlock_has_attr(struct kvm_vcpu *vcpu,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PVLOCK_IPA:
+		return 0;
+	}
+	return -ENXIO;
+}
-- 
2.19.1


