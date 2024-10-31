Return-Path: <kvm+bounces-30254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 070CB9B852D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A502A2825BA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A56918EFF8;
	Thu, 31 Oct 2024 21:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WKGYpqLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D6C13C9C0
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 21:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409687; cv=none; b=iCo0kYyrFUNXcIfqMPLcZYnzTr/B7N6+cbqwG9HcAm1fqCcAvjkwM0rxgnV7a0vFri+jKOAmkFUC0r42YFKqzhtfsgGqj62SH4AgicgGGboBO+YF8QmDpbKa/LIIuuL/kU1cK6DyZJTeZHXNR8X6gm4D16ugEl8cft9FaHEhGmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409687; c=relaxed/simple;
	bh=A0LeMUsrI2DZFHfvPQZ1zzCeqpkkwWOuqpTiHH4UbQU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jz+pzAQS3ok1leNz7sTxetgxxwlb9XqyLRxgJy9KatAFh6DmVPMZmFRWx1M2QFWvpPkLF+JTEy7yF8oh6m+ZuuArhz8vBfw67+Cn/1DH3qwR8xkDnjiQnJBkQ1qvg4/QFK8JawD9fWoKWooV37Hb1Fe/+hVXd7wTW+byWnzCoV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WKGYpqLs; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30df208cadso2268101276.0
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 14:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730409679; x=1731014479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b/v8Mv1PK4LZF9Cis1bzmvNj+I57aITtqK3JVRR6JrA=;
        b=WKGYpqLsBztfdWnvXglfDgpeuWLO8kdm4515tIWfX+fut5T3DrrHbYjcNvVzV7TVPo
         hlVHDeLUO7Hnfc3+pfRIZeU4sg4UlScxqSD7gE25Fi8T2iWv1WkwTFjcR8gRnYsLs6Dr
         4tQF7XU4X5GICiuZErTspvoSaJm2g3W8Fp487afMiVPctsL9VaeOQo6CAr3Og9r/NEk6
         N6xh2p9aQyn3jcVoMCsbFICaxJkIYPx/No8tZPlQRekOjr7j036MROqgDyhkYy0DTkQE
         sf9/CSC/yizaPh7GnyA5f/iqftjR6c4xbGciUpwdPYKPEKW+FpPsrjqNZ4wWyOMgm9rr
         3MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730409679; x=1731014479;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b/v8Mv1PK4LZF9Cis1bzmvNj+I57aITtqK3JVRR6JrA=;
        b=vH759KamBzTnb7X5tz7omI/xuslCK/fqQ2EBKXbFiocc0/ZddronYoWrQAXXfDfpGx
         ND/03U3VQqc5SJ1fcANHHRVT2dj4qYHp3EzfD+ifTbesojm/jfH1D1/r+UFPMKqiadO7
         JxVJcJe0Sw3XNwc0ZwM6LiNkOmW/uKzopktYcsMRghDt/awwhelmYePKg+anIit8ZfPi
         KduxUacVSHgthTSj7qtEv/RQ/+vH+VjJy59CwOEhg6pRfNhrY/Fhyqea1RBn/bJ4FdY+
         RYsrSsyKBbk8pztwrTktPmhrcgEjGDc02jGcF2WZscTTdUMhj54seQaEICO3monTJA+J
         qV0w==
X-Forwarded-Encrypted: i=1; AJvYcCWG54PaLua8vgH5G3RnwT/xrBEzeKBZFiJLzEYVzlRysAtplH8l+Ug3nyAulUI3s6C2XTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx11Sr1iIsMfTmVdh5SYPZkfDMZ2nlp+ckQf+X8SbOrixqzykwL
	Cw1s+C4Zj7B2ZDxos1vtBR9Jv76e9D1wrO2LdQVaMsrSStZYDUQw3kwb6ENe7zynaxIVswa9wcg
	f+XbbLHaV8w==
X-Google-Smtp-Source: AGHT+IFOfPtKpMDG2yMvokzfd9vRZ2DjB/v6P8TmSQwoWItjAf484F7Xg8alAf6O51J10eF8sgO9lx+FRmnk0g==
X-Received: from yjqssd.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:abd])
 (user=jiaqiyan job=sendgmr) by 2002:a25:8289:0:b0:e2b:cca2:69e1 with SMTP id
 3f1490d57ef6-e30e8d6b7edmr9473276.3.1730409679245; Thu, 31 Oct 2024 14:21:19
 -0700 (PDT)
Date: Thu, 31 Oct 2024 21:21:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031212104.1429609-1-jiaqiyan@google.com>
Subject: [RFC PATCH v1] KVM: arm64: Introduce KVM_CAP_ARM_SIGBUS_ON_SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently KVM handles SEA in guest by injecting async SError into
guest directly, bypassing VMM, usually results in guest kernel panic.

One major situation of guest SEA is when vCPU consumes uncorrectable
memory error on the physical memory. Although SError and guest kernel
panic effectively stops the propagation of corrupted memory, it is not
easy for VMM and guest to recover from memory error in a more graceful
manner.

Alternatively KVM can send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
how core kernel signals SIGBUS BUS_OBJERR to the poison consuming
thread.
In addition to the benifit that KVM's handling for SEA becomes aligned
with core kernel behavior
- The blast radius in VM can be limited to only the consuming thread
  in guest, instead of entire guest kernel, unless the consumption is
  from guest kernel.
- VMM now has the chance to do its duties to stop the VM from repeatedly
  consuming corrupted data. For example, VMM can unmap the guest page
  from stage-2 table to intercept forseen memory poison consumption,
  and for every consumption injects SEA to EL1 with synthetic memory
  error CPER.

Introduce a new KVM ARM capability KVM_CAP_ARM_SIGBUS_ON_SEA. VMM
can opt in this new capability if it prefers SIGBUS than SError
injection during VM init. Now SEA handling in KVM works as follows:
1. Delegate to APEI/GHES to see if SEA can be claimed by them.
2. If APEI failed to claim the SEA and KVM_CAP_ARM_SIGBUS_ON_SEA is
   enabled for the VM, and the SEA is NOT about translation table,
   send SIGBUS BUS_OBJERR signal with host virtual address.
3. Otherwise directly inject async SError to guest.

Tested on a machine running Siryn AmpereOne processor. A in-house VMM
that opts in KVM_CAP_ARM_SIGBUS_ON_SEA started a VM. A dummy application
in VM allocated some memory buffer. The test used EINJ to inject an
uncorrectable recoverable memory error at a page in the allocated memory
buffer. The dummy application then consumed the memory error. Some hack
was done to make core kernel's memory_failure triggered by poison
generation to fail, so KVM had to deal with the SEA guest abort due to
poison consumption. vCPU thread in VMM received SIGBUS BUS_OBJERR with
valid host virtual address of the poisoned page. VMM then injected a SEA
into guest using KVM_SET_VCPU_EVENTS with ext_dabt_pending=1. At last
the dummy application in guest was killed by SIGBUS BUS_OBJERR, while the
guest survived and continued to run.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/include/asm/kvm_ras.h  | 20 ++++----
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/arm.c              |  5 ++
 arch/arm64/kvm/kvm_ras.c          | 77 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c              |  8 +---
 include/uapi/linux/kvm.h          |  1 +
 7 files changed, 98 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bf64fed9820ea..eb37a2489411a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -334,6 +334,8 @@ struct kvm_arch {
 	/* Fine-Grained UNDEF initialised */
 #define KVM_ARCH_FLAG_FGU_INITIALIZED			8
 	unsigned long flags;
+	/* Instead of injecting SError into guest, SIGBUS VMM */
+#define KVM_ARCH_FLAG_SIGBUS_ON_SEA			9
 
 	/* VM-wide vCPU feature set */
 	DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 87e10d9a635b5..4bb7a424e3f6c 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -11,15 +11,17 @@
 #include <asm/acpi.h>
 
 /*
- * Was this synchronous external abort a RAS notification?
- * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ * Handle synchronous external abort (SEA) in the following order:
+ * 1. Delegate to APEI/GHES to see if SEA can be claimed by them. If so, we
+ *    are all done.
+ * 2. If userspace opts in KVM_CAP_ARM_SIGBUS_ON_SEA, and if the SEA is NOT
+ *    about translation table, send SIGBUS
+ *    - si_code is BUS_OBJERR.
+ *    - si_addr will be 0 when accurate HVA is unavailable.
+ * 3. Otherwise, directly inject an async SError to guest.
+ *
+ * Note this applies to both ESR_ELx_EC_IABT_* and ESR_ELx_EC_DABT_*.
  */
-static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
-{
-	/* apei_claim_sea(NULL) expects to mask interrupts itself */
-	lockdep_assert_irqs_enabled();
-
-	return apei_claim_sea(NULL);
-}
+void kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_RAS_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b5038..c4a3a6d4870e6 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o kvm_ras.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 48cafb65d6acf..bb97ad678dbec 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -151,6 +151,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->slots_lock);
 		break;
+	case KVM_CAP_ARM_SIGBUS_ON_SEA:
+		r = 0;
+		set_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA, &kvm->arch.flags);
+		break;
 	default:
 		break;
 	}
@@ -339,6 +343,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_ARM_SIGBUS_ON_SEA:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
new file mode 100644
index 0000000000000..3225462bcbcda
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ras.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitops.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_ras.h>
+#include <asm/system_misc.h>
+
+/*
+ * For synchrnous external instruction or data abort, not on translation
+ * table walk or hardware update of translation table, is FAR_EL2 valid?
+ */
+static inline bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
+{
+	return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
+}
+
+/*
+ * Was this synchronous external abort a RAS notification?
+ * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ */
+static int kvm_delegate_guest_sea(phys_addr_t addr, u64 esr)
+{
+	/* apei_claim_sea(NULL) expects to mask interrupts itself */
+	lockdep_assert_irqs_enabled();
+	return apei_claim_sea(NULL);
+}
+
+void kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
+{
+	bool sigbus_on_sea;
+	int idx;
+	u64 vcpu_esr = kvm_vcpu_get_esr(vcpu);
+	u8 fsc = kvm_vcpu_trap_get_fault(vcpu);
+	phys_addr_t fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	/* When FnV is set, send 0 as si_addr like what do_sea() does. */
+	unsigned long hva = 0UL;
+
+	/*
+	 * For RAS the host kernel may handle this abort.
+	 * There is no need to SIGBUS VMM, or pass the error into the guest.
+	 */
+	if (kvm_delegate_guest_sea(fault_ipa, vcpu_esr) == 0)
+		return;
+
+	sigbus_on_sea = test_bit(KVM_ARCH_FLAG_SIGBUS_ON_SEA,
+				 &(vcpu->kvm->arch.flags));
+
+	/*
+	 * In addition to userspace opt-in, SIGBUS only makes sense if the
+	 * abort is NOT about translation table walk and NOT about hardware
+	 * update of translation table.
+	 */
+	sigbus_on_sea &= (fsc == ESR_ELx_FSC_EXTABT || fsc == ESR_ELx_FSC_SECC);
+
+	/* Pass the error directly into the guest. */
+	if (!sigbus_on_sea) {
+		kvm_inject_vabt(vcpu);
+		return;
+	}
+
+	if (kvm_vcpu_sea_far_valid(vcpu)) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		hva = gfn_to_hva(vcpu->kvm, gfn);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
+	/*
+	 * Send a SIGBUS BUS_OBJERR to vCPU thread (the userspace thread that
+	 * runs KVM_RUN) or VMM, which aligns with what host kernel do_sea()
+	 * does if apei_claim_sea() fails.
+	 */
+	arm64_notify_die("synchronous external abort",
+			 current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vcpu_esr);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a71fe6f6bd90f..f5335953827ec 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1766,13 +1766,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
-		/*
-		 * For RAS the host kernel may handle this abort.
-		 * There is no need to pass the error into the guest.
-		 */
-		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_esr(vcpu)))
-			kvm_inject_vabt(vcpu);
-
+		kvm_handle_guest_sea(vcpu);
 		return 1;
 	}
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc0551453..fe3ca787e72fa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_SIGBUS_ON_SEA 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.47.0.163.g1226f6d8fa-goog


