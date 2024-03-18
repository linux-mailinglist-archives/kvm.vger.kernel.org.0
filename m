Return-Path: <kvm+bounces-11996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 242C787EDD8
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3D74282279
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:47:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C9455790;
	Mon, 18 Mar 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yfi4kdXF"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E3452F6E;
	Mon, 18 Mar 2024 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780431; cv=none; b=QLc1tzeWk7Te+oAFwy9fbXlOJM+Ai78IIeJwBPx68EcN4ob7fhM6mijnwKRoGcd+EA+5QID97b97jAP33T7eZbHMDKoZziQt6WV3FJHpZ3HL4SzsyZzhCTc+kLzXSY4J4Y3LkrJ0l2CCJ32XjWWYZ5VL3ACOEMbvOhNIZYF4fdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780431; c=relaxed/simple;
	bh=xCMcoBeAn92mm429fRpBaeAv+JW9JgKJuf/H7YpvXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBTeNJnxRDZXidoK0b6ZD1gQu49BV68Z5v/bmMx9+thiZTNJ2chBgQ0Wv2Ye1syvTwBb54ZDbk/HH5PsKdkQvyp+8PtyB73LDrhPxj+jZmwbSXRi+W7k0Xxal4xeYgo1bUcVGo5hXOpZikYVWVELeHtt1FxzaDsNLJANL4ocQ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yfi4kdXF; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xyw6pk7zn4iFLKziLAKf5sK11Uu17VrJE78dXX+5XEk=; b=Yfi4kdXFo5ww+yFo2Q7L746RO3
	hXmuv4GJNX1gSMcu8d4JM2BIxo4Tv57TKIHP3sLhORGEVEpNrnRcgy6XJrWwv6e6B5mlMSB8d8ld8
	oCJL5M45rPGtGqABzd69bZzMnl7ahUwZ88dbMbwNy5Ha94r6xqk2tJQjHA3dugoOAD3pLrlyxi4BC
	BpRugeUSo6NDW85TPieORghou9/cVyJOW8H6tQi3U2ciyMrQKWqgIbaWmlaB/8ozEqMXH8ojBtrw6
	Xm9ffYFVCQHJ9yJ7TVWayK59u4IqEmUvtQRjxjnYIo8oqMNF4yE78m7CqlGjxFK38aN1qm4IWagVi
	4UM2cRBQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8Z-0000000CjyB-1jje;
	Mon, 18 Mar 2024 16:46:59 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8W-00000004F1G-16xY;
	Mon, 18 Mar 2024 16:46:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v2 2/4] KVM: arm64: Add PSCI SYSTEM_OFF2 function for hibernation
Date: Mon, 18 Mar 2024 16:14:24 +0000
Message-ID: <20240318164646.1010092-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240318164646.1010092-1-dwmw2@infradead.org>
References: <20240318164646.1010092-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2 function
which is analogous to ACPI S4 state. This will allow hosting environments
to determine that a guest is hibernated rather than just powered off, and
ensure that they preserve the virtual environment appropriately to allow
the guest to resume safely (or bump the hardware_signature in the FACS to
trigger a clean reboot instead).

The beta version will be changed to say that PSCI_FEATURES returns a bit
mask of the supported hibernate types, which is implemented here.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst    | 11 +++++++++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  6 +++++
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/psci.c             | 37 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 6 files changed, 62 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..ff061b6a2393 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6761,6 +6761,10 @@ the first `ndata` items (possibly zero) of the data array are valid.
    the guest issued a SYSTEM_RESET2 call according to v1.1 of the PSCI
    specification.
 
+ - for arm64, data[0] is set to KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2
+   if the guest issued a SYSTEM_OFF2 call according to v1.3 of the PSCI
+   specification.
+
  - for RISC-V, data[0] is set to the value of the second argument of the
    ``sbi_system_reset`` call.
 
@@ -6794,6 +6798,13 @@ either:
  - Deny the guest request to suspend the VM. See ARM DEN0022D.b 5.19.2
    "Caller responsibilities" for possible return values.
 
+Hibernation using the PSCI SYSTEM_OFF2 call is enabled with the
+KVM_CAP_ARM_SYSTEM_OFF2 VM capability. If a guest invokes the PSCI
+SYSTEM_OFF2 function, KVM will exit to userspace with the
+KVM_SYSTEM_EVENT_SHUTDOWN event type and with data[0] set to
+KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2. The only supported hibernate
+type for the SYSTEM_OFF2 function is HIBERNATE_OFF (0x0).
+
 ::
 
 		/* KVM_EXIT_IOAPIC_EOI */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6883963bbc3a..6ed05791afdb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -299,6 +299,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
 	/* Fine-Grained UNDEF initialised */
 #define KVM_ARCH_FLAG_FGU_INITIALIZED			8
+	/* PSCI SYSTEM_OFF2 (hibernate) enabled for the guest */
+#define KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED		9
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..66736ff04011 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -484,6 +484,12 @@ enum {
  */
 #define KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2	(1ULL << 0)
 
+/*
+ * Shutdown caused by a PSCI v1.3 SYSTEM_OFF2 call.
+ * Valid only when the system event has a type of KVM_SYSTEM_EVENT_SHUTDOWN.
+ */
+#define KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2	(1ULL << 0)
+
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3dee5490eea9..47d23064d6f7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -98,6 +98,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
 		break;
+	case KVM_CAP_ARM_SYSTEM_OFF2:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags);
+		break;
 	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
 		new_cap = cap->args[0];
 
@@ -243,6 +247,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+	case KVM_CAP_ARM_SYSTEM_OFF2:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
 		r = 1;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..59570eea8aa7 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -194,6 +194,12 @@ static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN, 0);
 }
 
+static void kvm_psci_system_off2(struct kvm_vcpu *vcpu)
+{
+	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN,
+				 KVM_SYSTEM_EVENT_SHUTDOWN_FLAG_PSCI_OFF2);
+}
+
 static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 {
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET, 0);
@@ -353,6 +359,11 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			if (test_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags))
 				val = 0;
 			break;
+		case PSCI_1_3_FN_SYSTEM_OFF2:
+		case PSCI_1_3_FN64_SYSTEM_OFF2:
+			if (test_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags))
+				val = 1UL << PSCI_1_3_HIBERNATE_TYPE_OFF;
+			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
 			if (minor >= 1)
@@ -374,6 +385,32 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			return 0;
 		}
 		break;
+	case PSCI_1_3_FN_SYSTEM_OFF2:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_3_FN64_SYSTEM_OFF2:
+		if (!test_bit(KVM_ARCH_FLAG_SYSTEM_OFF2_ENABLED, &kvm->arch.flags))
+			break;
+
+		arg = smccc_get_arg1(vcpu);
+		if (arg != PSCI_1_3_HIBERNATE_TYPE_OFF) {
+			val = PSCI_RET_INVALID_PARAMS;
+			break;
+		}
+		kvm_psci_system_off2(vcpu);
+		/*
+		 * We shouldn't be going back to guest VCPU after
+		 * receiving SYSTEM_OFF2 request.
+		 *
+		 * If user space accidentally/deliberately resumes
+		 * guest VCPU after SYSTEM_OFF request then guest
+		 * VCPU should see internal failure from PSCI return
+		 * value. To achieve this, we preload r0 (or x0) with
+		 * PSCI return value INTERNAL_FAILURE.
+		 */
+		val = PSCI_RET_INTERNAL_FAILURE;
+		ret = 0;
+		break;
 	case PSCI_1_1_FN_SYSTEM_RESET2:
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..caa3845b80d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_ARM_SYSTEM_OFF2 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.44.0


