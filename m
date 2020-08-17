Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6870724607A
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 10:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgHQIlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 04:41:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbgHQIl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 04:41:29 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6AFD1575E938EDF8A34A;
        Mon, 17 Aug 2020 16:41:22 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:41:14 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH 3/5] KVM: arm64: Provide VM device attributes for LPT time
Date:   Mon, 17 Aug 2020 16:41:08 +0800
Message-ID: <20200817084110.2672-4-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817084110.2672-1-zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow user space to inform the KVM host what the PV frequency is
and where in the physical memory map the paravirtualized LPT time
structures should be located. User space can set attributes on the
VM for that guest.

The address is given in terms of the physical address visible to
the guest and must be 64 byte aligned. The guest will discover the
address via a hypercall. PV frequency is 32 bits and must not be 0.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++
 arch/arm64/include/uapi/asm/kvm.h |  5 +++
 arch/arm64/kvm/arm.c              | 64 ++++++++++++++++++++++++++++
 arch/arm64/kvm/pvtime.c           | 87 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 160 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c6a564..cbe330c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -523,6 +523,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_pvtime_lpt_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_arm_pvtime_lpt_get_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_arm_pvtime_lpt_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->steal.base = GPA_INVALID;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ba85bb2..7b045c7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -325,6 +325,11 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/* Device Control API on kvm fd */
+#define KVM_ARM_VM_PVTIME_LPT_CTRL	0
+#define   KVM_ARM_VM_PVTIME_LPT_IPA	0
+#define   KVM_ARM_VM_PVTIME_LPT_FREQ	1
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 671f1461..4a867e5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1235,11 +1235,60 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 	}
 }
 
+static int kvm_arm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_set_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_get_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_arm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_ARM_VM_PVTIME_LPT_CTRL:
+		ret = kvm_arm_pvtime_lpt_has_attr(kvm, attr);
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
+	struct kvm_device_attr attr;
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
@@ -1271,6 +1320,21 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 		return 0;
 	}
+	case KVM_SET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vm_set_attr(kvm, &attr);
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return -EFAULT;
+		return kvm_arm_vm_get_attr(kvm, &attr);
+	}
+	case KVM_HAS_DEVICE_ATTR: {
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			return  -EFAULT;
+		return kvm_arm_vm_has_attr(kvm, &attr);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 24131ca..3f93473 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -257,3 +257,90 @@ gpa_t kvm_init_lpt_time(struct kvm *kvm)
 {
 	return kvm->arch.lpt.base;
 }
+
+int kvm_arm_pvtime_lpt_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 ipa;
+	u32 freq;
+	int idx;
+	int ret = 0;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+		if (get_user(ipa, user)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (!IS_ALIGNED(ipa, 64)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (kvm->arch.lpt.base != GPA_INVALID) {
+			ret = -EEXIST;
+			break;
+		}
+		/* Check the address is in a valid memslot */
+		idx = srcu_read_lock(&kvm->srcu);
+		if (kvm_is_error_hva(gfn_to_hva(kvm, ipa >> PAGE_SHIFT)))
+			ret = -EINVAL;
+		srcu_read_unlock(&kvm->srcu, idx);
+		if (ret)
+			break;
+
+		kvm->arch.lpt.base = ipa;
+		break;
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		if (get_user(freq, user)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (freq == 0) {
+			ret = -EINVAL;
+			break;
+		}
+		if (kvm->arch.lpt.fpv != 0) {
+			ret = -EEXIST;
+			break;
+		}
+		kvm->arch.lpt.fpv = freq;
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_pvtime_lpt_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	int ret = 0;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+		if (put_user(kvm->arch.lpt.base, user))
+			ret = -EFAULT;
+		break;
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		if (put_user(kvm->arch.lpt.fpv, user))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -ENXIO;
+		break;
+	}
+
+	return ret;
+}
+
+int kvm_arm_pvtime_lpt_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VM_PVTIME_LPT_IPA:
+	case KVM_ARM_VM_PVTIME_LPT_FREQ:
+		return 0;
+	}
+	return -ENXIO;
+}
-- 
1.8.3.1

