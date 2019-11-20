Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18904104116
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbfKTQnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:43:09 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:42402 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732847AbfKTQnJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:43:09 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT4B-0007RI-BX; Wed, 20 Nov 2019 17:42:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Julien Grall <julien.grall@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Price <steven.price@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 02/22] KVM: arm/arm64: Allow user injection of external data aborts
Date:   Wed, 20 Nov 2019 16:42:16 +0000
Message-Id: <20191120164236.29359-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com, drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com, eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com, mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com, tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

In some scenarios, such as buggy guest or incorrect configuration of the
VMM and firmware description data, userspace will detect a memory access
to a portion of the IPA, which is not mapped to any MMIO region.

For this purpose, the appropriate action is to inject an external abort
to the guest.  The kernel already has functionality to inject an
external abort, but we need to wire up a signal from user space that
lets user space tell the kernel to do this.

It turns out, we already have the set event functionality which we can
perfectly reuse for this.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.txt    | 22 +++++++++++++++++++++-
 arch/arm/include/uapi/asm/kvm.h   |  3 ++-
 arch/arm/kvm/guest.c              | 10 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h |  3 ++-
 arch/arm64/kvm/guest.c            | 10 ++++++++++
 arch/arm64/kvm/inject_fault.c     |  4 ++--
 include/uapi/linux/kvm.h          |  1 +
 virt/kvm/arm/arm.c                |  1 +
 8 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 7403f15657c2..bd29d44af32b 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -1002,12 +1002,18 @@ Specifying exception.has_esr on a system that does not support it will return
 -EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
 will return -EINVAL.
 
+It is not possible to read back a pending external abort (injected via
+KVM_SET_VCPU_EVENTS or otherwise) because such an exception is always delivered
+directly to the virtual CPU).
+
+
 struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -1051,9 +1057,23 @@ contain a valid state and shall be written into the VCPU.
 
 ARM/ARM64:
 
+User space may need to inject several types of events to the guest.
+
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
+If the guest performed an access to I/O memory which could not be handled by
+userspace, for example because of missing instruction syndrome decode
+information or because there is no device mapped at the accessed IPA, then
+userspace can ask the kernel to inject an external abort using the address
+from the exiting fault on the VCPU. It is a programming error to set
+ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
+KVM_EXIT_ARM_NISV. This feature is only available if the system supports
+KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
+how userspace reports accesses for the above cases to guests, across different
+userspace implementations. Nevertheless, userspace can still emulate all Arm
+exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
+
 See KVM_GET_VCPU_EVENTS for the data structure.
 
 
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 2769360f195c..03cd7c19a683 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -131,8 +131,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 684cf64b4033..735f9b007e58 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -255,6 +255,12 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 {
 	events->exception.serror_pending = !!(*vcpu_hcr(vcpu) & HCR_VA);
 
+	/*
+	 * We never return a pending ext_dabt here because we deliver it to
+	 * the virtual CPU directly when setting the event and it's no longer
+	 * 'pending' at this point.
+	 */
+
 	return 0;
 }
 
@@ -263,12 +269,16 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 {
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
+	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
 	if (serror_pending && has_esr)
 		return -EINVAL;
 	else if (serror_pending)
 		kvm_inject_vabt(vcpu);
 
+	if (ext_dabt_pending)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
 	return 0;
 }
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 67c21f9bdbad..d49c17a80491 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -164,8 +164,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd626447482..ca613a44c6ec 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -712,6 +712,12 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
 
+	/*
+	 * We never return a pending ext_dabt here because we deliver it to
+	 * the virtual CPU directly when setting the event and it's no longer
+	 * 'pending' at this point.
+	 */
+
 	return 0;
 }
 
@@ -720,6 +726,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 {
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
+	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
 	if (serror_pending && has_esr) {
 		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
@@ -733,6 +740,9 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 		kvm_inject_vabt(vcpu);
 	}
 
+	if (ext_dabt_pending)
+		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a9d25a305af5..ccdb6a051ab2 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -109,7 +109,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 /**
  * kvm_inject_dabt - inject a data abort into the guest
- * @vcpu: The VCPU to receive the undefined exception
+ * @vcpu: The VCPU to receive the data abort
  * @addr: The address to report in the DFAR
  *
  * It is assumed that this code is called from the VCPU thread and that the
@@ -125,7 +125,7 @@ void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr)
 
 /**
  * kvm_inject_pabt - inject a prefetch abort into the guest
- * @vcpu: The VCPU to receive the undefined exception
+ * @vcpu: The VCPU to receive the prefetch abort
  * @addr: The address to report in the DFAR
  *
  * It is assumed that this code is called from the VCPU thread and that the
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7336ee8d98d7..65db5a4257ec 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1007,6 +1007,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
 #define KVM_CAP_ARM_NISV_TO_USER 176
+#define KVM_CAP_ARM_INJECT_EXT_DABT 177
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index e6d56f60e4b6..12064780f1d8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
+	case KVM_CAP_ARM_INJECT_EXT_DABT:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
-- 
2.20.1

