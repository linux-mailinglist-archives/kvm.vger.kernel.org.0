Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200B110410F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 17:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbfKTQnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 11:43:08 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:58401 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732858AbfKTQnH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 11:43:07 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXT4A-0007RI-GB; Wed, 20 Nov 2019 17:42:54 +0100
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
Subject: [PATCH 01/22] KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace
Date:   Wed, 20 Nov 2019 16:42:15 +0000
Message-Id: <20191120164236.29359-2-maz@kernel.org>
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

For a long time, if a guest accessed memory outside of a memslot using
any of the load/store instructions in the architecture which doesn't
supply decoding information in the ESR_EL2 (the ISV bit is not set), the
kernel would print the following message and terminate the VM as a
result of returning -ENOSYS to userspace:

  load/store instruction decoding not implemented

The reason behind this message is that KVM assumes that all accesses
outside a memslot is an MMIO access which should be handled by
userspace, and we originally expected to eventually implement some sort
of decoding of load/store instructions where the ISV bit was not set.

However, it turns out that many of the instructions which don't provide
decoding information on abort are not safe to use for MMIO accesses, and
the remaining few that would potentially make sense to use on MMIO
accesses, such as those with register writeback, are not used in
practice.  It also turns out that fetching an instruction from guest
memory can be a pretty horrible affair, involving stopping all CPUs on
SMP systems, handling multiple corner cases of address translation in
software, and more.  It doesn't appear likely that we'll ever implement
this in the kernel.

What is much more common is that a user has misconfigured his/her guest
and is actually not accessing an MMIO region, but just hitting some
random hole in the IPA space.  In this scenario, the error message above
is almost misleading and has led to a great deal of confusion over the
years.

It is, nevertheless, ABI to userspace, and we therefore need to
introduce a new capability that userspace explicitly enables to change
behavior.

This patch introduces KVM_CAP_ARM_NISV_TO_USER (NISV meaning Non-ISV)
which does exactly that, and introduces a new exit reason to report the
event to userspace.  User space can then emulate an exception to the
guest, restart the guest, suspend the guest, or take any other
appropriate action as per the policy of the running system.

Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.txt       | 33 ++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_arm.h       |  1 +
 arch/arm/include/asm/kvm_emulate.h   |  5 +++++
 arch/arm/include/asm/kvm_host.h      |  8 +++++++
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/include/asm/kvm_host.h    |  8 +++++++
 include/uapi/linux/kvm.h             |  7 ++++++
 virt/kvm/arm/arm.c                   | 21 ++++++++++++++++++
 virt/kvm/arm/mmio.c                  |  9 +++++++-
 9 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 4833904d32a5..7403f15657c2 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4468,6 +4468,39 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
 event/message pages and to enable/disable SynIC messages/events processing
 in userspace.
 
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+
+Used on arm and arm64 systems. If a guest accesses memory not in a memslot,
+KVM will typically return to userspace and ask it to do MMIO emulation on its
+behalf. However, for certain classes of instructions, no instruction decode
+(direction, length of memory access) is provided, and fetching and decoding
+the instruction from the VM is overly complicated to live in the kernel.
+
+Historically, when this situation occurred, KVM would print a warning and kill
+the VM. KVM assumed that if the guest accessed non-memslot memory, it was
+trying to do I/O, which just couldn't be emulated, and the warning message was
+phrased accordingly. However, what happened more often was that a guest bug
+caused access outside the guest memory areas which should lead to a more
+meaningful warning message and an external abort in the guest, if the access
+did not fall within an I/O window.
+
+Userspace implementations can query for KVM_CAP_ARM_NISV_TO_USER, and enable
+this capability at VM creation. Once this is done, these types of errors will
+instead return to userspace with KVM_EXIT_ARM_NISV, with the valid bits from
+the HSR (arm) and ESR_EL2 (arm64) in the esr_iss field, and the faulting IPA
+in the fault_ipa field. Userspace can either fix up the access if it's
+actually an I/O access by decoding the instruction from guest memory (if it's
+very brave) and continue executing the guest, or it can decide to suspend,
+dump, or restart the guest.
+
+Note that KVM does not skip the faulting instruction as it does for
+KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
+if it decides to decode and emulate the instruction.
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 0125aa059d5b..9c04bd810d07 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -162,6 +162,7 @@
 #define HSR_ISV		(_AC(1, UL) << HSR_ISV_SHIFT)
 #define HSR_SRT_SHIFT	(16)
 #define HSR_SRT_MASK	(0xf << HSR_SRT_SHIFT)
+#define HSR_CM		(1 << 8)
 #define HSR_FSC		(0x3f)
 #define HSR_FSC_TYPE	(0x3c)
 #define HSR_SSE		(1 << 21)
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 40002416efec..e8ef349c04b4 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -167,6 +167,11 @@ static inline bool kvm_vcpu_dabt_isvalid(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_get_hsr(vcpu) & HSR_ISV;
 }
 
+static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_get_hsr(vcpu) & (HSR_CM | HSR_WNR | HSR_FSC);
+}
+
 static inline bool kvm_vcpu_dabt_iswrite(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & HSR_WNR;
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8a37c8e89777..19a92c49039c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -76,6 +76,14 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/*
+	 * If we encounter a data abort without valid instruction syndrome
+	 * information, report this to user space.  User space can (and
+	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
+	 * supported.
+	 */
+	bool return_nisv_io_abort_to_user;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d69c1efc63e7..a3c967988e1d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -258,6 +258,11 @@ static inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_ISV);
 }
 
+static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_get_hsr(vcpu) & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
+}
+
 static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
 {
 	return !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_SSE);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..019bc560edc1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -83,6 +83,14 @@ struct kvm_arch {
 
 	/* Mandated version of PSCI */
 	u32 psci_version;
+
+	/*
+	 * If we encounter a data abort without valid instruction syndrome
+	 * information, report this to user space.  User space can (and
+	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
+	 * supported.
+	 */
+	bool return_nisv_io_abort_to_user;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..7336ee8d98d7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -394,6 +395,11 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1000,6 +1006,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_EVENT_FILTER 173
 #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
 #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_ARM_NISV_TO_USER 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..e6d56f60e4b6 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -98,6 +98,26 @@ int kvm_arch_check_processor_compat(void)
 	return 0;
 }
 
+int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
+			    struct kvm_enable_cap *cap)
+{
+	int r;
+
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = 0;
+		kvm->arch.return_nisv_io_abort_to_user = true;
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -197,6 +217,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
+	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index 6af5c91337f2..70d3b449692c 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -167,7 +167,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (ret)
 			return ret;
 	} else {
-		kvm_err("load/store instruction decoding not implemented\n");
+		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+			run->exit_reason = KVM_EXIT_ARM_NISV;
+			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
+			run->arm_nisv.fault_ipa = fault_ipa;
+			return 0;
+		}
+
+		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
 		return -ENOSYS;
 	}
 
-- 
2.20.1

