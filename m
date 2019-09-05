Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CA3AA7DC
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 18:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389437AbfIEQCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 12:02:55 -0400
Received: from foss.arm.com ([217.140.110.172]:47030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730518AbfIEQCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 12:02:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 577AE28;
        Thu,  5 Sep 2019 09:02:54 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB2923F67D;
        Thu,  5 Sep 2019 09:02:52 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Peter Maydell <peter.maydell@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Cc:     qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [PATCH v2] KVM: arm/arm64: vgic: Allow more than 256 vcpus for KVM_IRQ_LINE
Date:   Thu,  5 Sep 2019 17:02:45 +0100
Message-Id: <20190905160245.20746-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While parts of the VGIC support a large number of vcpus (we
bravely allow up to 512), other parts are more limited.

One of these limits is visible in the KVM_IRQ_LINE ioctl, which
only allows 256 vcpus to be signalled when using the CPU or PPI
types. Unfortunately, we've cornered ourselves badly by allocating
all the bits in the irq field.

Since the irq_type subfield (8 bit wide) is currently only taking
the values 0, 1 and 2 (and we have been careful not to allow anything
else), let's reduce this field to only 4 bits, and allocate the
remaining 4 bits to a vcpu2_index, which acts as a multiplier:

  vcpu_id = 256 * vcpu2_index + vcpu_index

With that, and a new capability (KVM_CAP_ARM_IRQ_LINE_LAYOUT_2)
allowing this to be discovered, it becomes possible to inject
PPIs to up to 4096 vcpus. But please just don't.

Whilst we're there, add a clarification about the use of KVM_IRQ_LINE
on arm, which is not completely conditionned by KVM_CAP_IRQCHIP.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
* From v1 (https://lore.kernel.org/r/20190818140710.23920-1-maz@kernel.org)
  - Always say that we support the new layout, no matter whether
    we have an in-kernel irqchip or not
  - Clarify use of KVM_IRQ_LINE wrt KVM_CAP_IRQCHIP
  - Collected RBs

 Documentation/virt/kvm/api.txt    | 12 ++++++++++--
 arch/arm/include/uapi/asm/kvm.h   |  4 +++-
 arch/arm64/include/uapi/asm/kvm.h |  4 +++-
 include/uapi/linux/kvm.h          |  1 +
 virt/kvm/arm/arm.c                |  2 ++
 5 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..25931ca1cb38 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -753,8 +753,8 @@ in-kernel irqchip (GIC), and for in-kernel irqchip can tell the GIC to
 use PPIs designated for specific cpus.  The irq field is interpreted
 like this:
 
-  bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
-  field: | irq_type  | vcpu_index |     irq_id     |
+  bits:  |  31 ... 28  | 27 ... 24 | 23  ... 16 | 15 ... 0 |
+  field: | vcpu2_index | irq_type  | vcpu_index |  irq_id  |
 
 The irq_type field has the following values:
 - irq_type[0]: out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
@@ -766,6 +766,14 @@ The irq_type field has the following values:
 
 In both cases, level is used to assert/deassert the line.
 
+When KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 is supported, the target vcpu is
+identified as (256 * vcpu2_index + vcpu_index). Otherwise, vcpu2_index
+must be zero.
+
+Note that on arm/arm64, the KVM_CAP_IRQCHIP capability only conditions
+injection of interrupts for the in-kernel irqchip. KVM_IRQ_LINE can always
+be used for a userspace interrupt controller.
+
 struct kvm_irq_level {
 	union {
 		__u32 irq;     /* GSI */
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index a4217c1a5d01..2769360f195c 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -266,8 +266,10 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9a507716ae2f..67c21f9bdbad 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -325,8 +325,10 @@ struct kvm_vcpu_events {
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e3f12d5359e..5414b6588fbb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -996,6 +996,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 35a069815baf..86c6aa1cb58e 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -196,6 +196,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
+	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
@@ -888,6 +889,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 
 	irq_type = (irq >> KVM_ARM_IRQ_TYPE_SHIFT) & KVM_ARM_IRQ_TYPE_MASK;
 	vcpu_idx = (irq >> KVM_ARM_IRQ_VCPU_SHIFT) & KVM_ARM_IRQ_VCPU_MASK;
+	vcpu_idx += ((irq >> KVM_ARM_IRQ_VCPU2_SHIFT) & KVM_ARM_IRQ_VCPU2_MASK) * (KVM_ARM_IRQ_VCPU_MASK + 1);
 	irq_num = (irq >> KVM_ARM_IRQ_NUM_SHIFT) & KVM_ARM_IRQ_NUM_MASK;
 
 	trace_kvm_irq_line(irq_type, vcpu_idx, irq_num, irq_level->level);
-- 
2.20.1

