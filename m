Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D46FBCB28
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 17:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbfIXPWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 11:22:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732698AbfIXPWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 11:22:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4F6A85461CE3B3AB5C3B;
        Tue, 24 Sep 2019 23:22:34 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:22:24 +0800
From:   Heyi Guo <guoheyi@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
CC:     <wanghaibin.wang@huawei.com>, Heyi Guo <guoheyi@huawei.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [RFC PATCH 2/2] kvm/arm64: expose hypercall_forwarding capability
Date:   Tue, 24 Sep 2019 23:20:54 +0800
Message-ID: <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.222]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add new KVM capability "KVM_CAP_FORWARD_HYPERCALL" for user space to
probe whether KVM supports forwarding hypercall.

The capability should be enabled by user space explicitly, for we
don't want user space application to deal with unexpected hypercall
exits. We also use an additional argument to pass exception bit mask,
to request KVM to forward all hypercalls except the classes specified
in the bit mask.

Currently only PSCI can be set as exception, so that we can still keep
consistent with the old PSCI processing flow.

Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
---
 arch/arm64/kvm/reset.c   | 25 +++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index f4a8ae9..2201b62 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -95,6 +95,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = has_vhe() && system_supports_address_auth() &&
 				 system_supports_generic_auth();
 		break;
+	case KVM_CAP_FORWARD_HYPERCALL:
+		r = 1;
+		break;
 	default:
 		r = 0;
 	}
@@ -102,6 +105,28 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+			    struct kvm_enable_cap *cap)
+{
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_FORWARD_HYPERCALL: {
+		__u64 exclude_flags = cap->args[0];
+		/* Only support excluding PSCI right now */
+		if (exclude_flags & ~KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
+			return -EINVAL;
+		kvm->arch.hypercall_forward = true;
+		if (exclude_flags & KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI)
+			kvm->arch.hypercall_excl_psci = true;
+		return 0;
+	}
+	}
+
+	return -EINVAL;
+}
+
 unsigned int kvm_sve_max_vl;
 
 int kvm_arm_init_sve(void)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d..e3e5787 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -711,6 +711,8 @@ struct kvm_enable_cap {
 	__u8  pad[64];
 };
 
+#define KVM_CAP_FORWARD_HYPERCALL_EXCL_PSCI	(1 << 0)
+
 /* for KVM_PPC_GET_PVINFO */
 
 #define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
@@ -996,6 +998,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_FORWARD_HYPERCALL 174
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.8.3.1

