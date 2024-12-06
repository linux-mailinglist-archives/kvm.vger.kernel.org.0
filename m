Return-Path: <kvm+bounces-33186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC4C9E62E6
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 02:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4D511885326
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 01:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415C179DC7;
	Fri,  6 Dec 2024 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jY0igAv5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB777225D6
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733446973; cv=none; b=fC1YTuguhqPxQCNiOD6uvcx5/AC0W3b6wNtZoxUABFj8GH1dazx2JAjs038tOStQSXbJcBF7kyyXH38LPsyA49vYz5hEdZPiV/ihVA7RGOawHluECP6AYzKpKw8r/aOIDXfhCtNor/h2bD8WJJa/c0s/4cWq932Q07zfr4UZ5tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733446973; c=relaxed/simple;
	bh=ytrOPjuR6Jy6oLLBzmt7JL9Ng+gH6kmMQIne3PcMffs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bwP0HrK5IfyQoFvdtBC9mJQYDaci0y7ATiAUbYf3jXItGfYCiPP/CPNhumD5ZN8N/apOjIFNHxu4RHGqb1J3KRAI9reAbZucYQxq4LgklQY0hL7bsburXjHAoXnRifkOD6lIT2kGHbMRLhqUgEiNKCnkhZp5+ML9fg7AE29oC5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jY0igAv5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fcff306a20so2186414a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2024 17:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733446971; x=1734051771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MYLyTOTsZbCzQhUhTS6u7grQ+BFI1GLmSyaDSfFgEx8=;
        b=jY0igAv5G+7+BqBS2uvz0kIpm8ikFnGVdho/9y1es3LnW4xLDuoolHlyDhUyc9FpWm
         LK2DbBBL3cL9LEHtJWQbAmofHHWyJzFAjEaNmfYfpfXz1ju2PF7OJ7UQGb6hFYTiiTWL
         2pbUULV0YLJtcwQ82QRNVec1vF9xutWQZiZTO1Be+unS7byJWZfto1WW8biPBmlFHHnc
         aphPdYi9DVe4CHickeKfdKZhgsxWhAvGK0ZRJYdo+g+Itx4eKAmkoIPXOoKpji+FI2hS
         URqFZUL7vkX6wA6csMnETSF5wWdI/ARODqEESAs2my9WJCXH8XOxMV7QOFx27cuAUqhs
         s4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733446971; x=1734051771;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MYLyTOTsZbCzQhUhTS6u7grQ+BFI1GLmSyaDSfFgEx8=;
        b=Djpt8vFPp/hqvYEnk2LSPjQi1I4ie1UQYCVcWplxVLmLq6tmeMFhNiv0tKL+ZBbJ5N
         Bt5Q/yMwB86R8GMwvYwhES+O7Qg3fNAX2yGi5/7QxCCV6YRgS3yMB+aHW2S2s6fYH46a
         dIjuaDxNAu+ndrGlWsyXdcgAVmG3lnFzmdopygHLQwsfwSmcHO3prMcb7VGZ2pT3+Wjl
         0JBNeZssSl6SR3s4ulwknZ1VSsFU2NZvRV7n9wJ0fPy5lfhSyOoAQW23urA80DZtCVlG
         mx+pl1y1krGgtOWypT6TtacPosPso6zPcmRYWJb9oeKntelmdFKMez99jD/HNuuSoieA
         sUYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNSbmMqlgCJG6hMaevmZqR/BtgD6Y3CESzk6275/T9a3wA0I03vKMe17K+cr5TTtzrXWg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw5n001dFawUUwZzlTeYkHp2GjFw4xdeKLE6dhCPEBtrWmDMJt
	fGWvaf4MHu56rAwjkpAbC1vmaB3AO7sHvmypd6tvykfGFyPCQoOyCoubeDWr3LA3pWCcy5ttqM0
	sMFP9X+0qJg==
X-Google-Smtp-Source: AGHT+IG1nh8Otsg54SNCNFaLSELBcCc1sq66BJjw322b9cib3uOqLUZ0aIENc9csvG2opxvvri4AP80FQXXMCA==
X-Received: from pgbdp11.prod.google.com ([2002:a05:6a02:f0b:b0:7f4:5445:1822])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d85:b0:1cc:d9dc:5637 with SMTP id adf61e73a8af0-1e186c5e14amr2253562637.23.1733446971023;
 Thu, 05 Dec 2024 17:02:51 -0800 (PST)
Date: Fri,  6 Dec 2024 01:02:44 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241206010246.40282-1-jiaqiyan@google.com>
Subject: [RFC PATCH v2 1/3] KVM: arm64: SIGBUS VMM for SEA guest abort
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

When APEI is unable claim or handles synchronous external abort (SEA)
today KVM handles SEA for guest by injecting an async SError into the
guest directly, bypassing VMM, usually results in guest kernel panic.

One major situation of guest SEA is when vCPU consumes uncorrectable
memory error on the physical memory. Although SError and guest kernel
panic effectively stops the propagation of corrupted memory, it is not
easy for VMM and guest to recover from memory error in a more graceful
manner.

This patch teach KVM to send a SIGBUS BUS_OBJERR to VMM/vCPU, just like
how core kernel signals SIGBUS BUS_OBJERR to a gernal poison consuming
userspace thread when APEI is unable to claim the SEA. In addition to
the benifit that KVM's handling for SEA becomes aligned with core
kernel's behavior
- VMM can inject SEA to guest. Compared to SError, the blast radius in
  VM is possible to be limited to only the consuming thread in guest,
  instead of the entire guest kernel (unless the poison consumption is
  from guest kernel).
- VMM usually tracks the poisoned guest pages. Together with [1], if
  guest consumes again the already poisoned guest pages, VMM can protect
  itself and the host by stopping the consumption at software level, by
  intercepting guest's access to poisoned pages, and again injecting
  SEA to guest.

KVM now handles SEA as follows:
1. Delegate to APEI/GHES driver to see if SEA can be claimed by them.
2. If APEI failed to claim the SEA, send current thread (i.e. VMM in EL0)
   a si_code=BUS_OBJERR SIGBUS signal. If the DIMM error's physical
   address is available from FAR_EL2, si_addr will be the DIMM error's
   host virtual address in VMM/vCPU's memory space.
3. Otherwise bypass VMM and inject async SError to guest.

Tested on a machine running Siryn AmpereOne processor. A dummy application
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

[1] https://lpc.events/event/18/contributions/1757/attachments/1442/3073/LPC_%20KVM%20Userfault.pdf

Changelog

RFC v2 -> RFC v1
- reword commit msg
- drop unused parameters from kvm_delegate_guest_sea
- remove KVM_CAP_ARM_SIGBUS_ON_SEA and its opt in code
- set FnV bit in vcpu's ESR_ELx if host ESR_EL2's FnV is set
- add documentation for this new SIGBUS feature

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/include/asm/kvm_ras.h | 24 ++++++----
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/kvm_ras.c         | 81 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c             |  8 +---
 4 files changed, 98 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c

diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 87e10d9a635b5..5b4bec6f4f32b 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -1,5 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2018 - Arm Ltd */
 
 #ifndef __ARM64_KVM_RAS_H__
 #define __ARM64_KVM_RAS_H__
@@ -11,15 +10,22 @@
 #include <asm/acpi.h>
 
 /*
- * Was this synchronous external abort a RAS notification?
- * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ * For synchrnous external abort taken to KVM at EL2, not on translation
+ * table walk or hardware update of translation table, is FAR_EL2 valid?
  */
-static inline int kvm_handle_guest_sea(phys_addr_t addr, u64 esr)
-{
-	/* apei_claim_sea(NULL) expects to mask interrupts itself */
-	lockdep_assert_irqs_enabled();
+bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu);
 
-	return apei_claim_sea(NULL);
-}
+/*
+ * Handle synchronous external abort (SEA) in the following order:
+ * 1. Delegate to APEI/GHES to see if they can claim SEA. If so, all done.
+ * 2. If the SEA is NOT about S2 translation table, send SIGBUS to current
+ *    with BUS_OBJERR and si_addr set to faulting/poisoned host virtual
+ *    address. When accurate HVA is unavailable, si_addr will be 0.
+ * 3. Otherwise, directly inject an async SError to guest.
+ *
+ * Note this applies to both instruction and data abort (ESR_ELx_EC_IABT_*
+ * and ESR_ELx_EC_DABT_*).
+ */
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
diff --git a/arch/arm64/kvm/kvm_ras.c b/arch/arm64/kvm/kvm_ras.c
new file mode 100644
index 0000000000000..88d5c57f14bc7
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ras.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitops.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_ras.h>
+#include <asm/system_misc.h>
+
+bool kvm_vcpu_sea_far_valid(const struct kvm_vcpu *vcpu)
+{
+	/*
+	 * FnV is valid only for Data/Instruction aborts and if DFSC/IFSC
+	 * is ESR_ELx_FSC_EXTABT(0b010000).
+	 */
+	if (kvm_vcpu_trap_get_fault(vcpu) == ESR_ELx_FSC_EXTABT)
+		return !(vcpu->arch.fault.esr_el2 & ESR_ELx_FnV);
+
+	/* Other exception classes or aborts don't care about FnV field. */
+	return true;
+}
+
+/*
+ * Was this synchronous external abort a RAS notification?
+ * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ */
+static int kvm_delegate_guest_sea(void)
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
+	if (kvm_delegate_guest_sea() == 0)
+		return;
+
+	/*
+	 * In addition to userspace opt-in, SIGBUS only makes sense if the
+	 * abort is NOT about stage 2 translation table walk and NOT about
+	 * hardware update of stage 2 translation table.
+	 */
+	sigbus_on_sea = (fsc == ESR_ELx_FSC_EXTABT ||
+			 fsc == ESR_ELx_FSC_SECC ||
+			 fsc == ESR_ELx_FSC_SEA_TTW(1) ||
+			 fsc == ESR_ELx_FSC_SECC_TTW(1));
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
 
-- 
2.47.0.338.g60cca15819-goog


