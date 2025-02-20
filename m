Return-Path: <kvm+bounces-38807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A26A3E884
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C999D7025D5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232372B9AA;
	Thu, 20 Feb 2025 23:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eh2zgG4l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167D267717
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094206; cv=none; b=grf0Zr7FuYw6O7ky4Z3Vz5OdJlgJVngOWy9C5rh8TWGy/KZnxseHPVesHDJhrSXKN899brrszEhhK93waGS36YzmlCjVcSKGLKvu1m3jWeXXp5bysVKxWylv9Kb2FwJQhRg+zmFRCiHKRcmEDxvCO2v7UFwwW/HyvewTwWLCrL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094206; c=relaxed/simple;
	bh=BcXcrtm0K01Xeqh58KAhFqHzuEUgX433PHRzOQkqfgI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=i6TfMmDMNtjNiGrWeTjjOn5ln2f7PDkvDWekiS2x8xUTF9D3Yx0pifn05Coh6y1YdOnL95wwCVLfjTHJOr8kFL1NAoeXkNfyoWVD9kMYFNXKUmN9el7YAYdjIpnc64COkysH5dQH0RO9S42LmZmHLYQdLzMZAcdoiZ/tuXDVWdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eh2zgG4l; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc43be27f8so5011521a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740094203; x=1740699003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=16mDfwgtMHX4C5Bzktye9hLGYxEoL74KODcm/rd0Vtg=;
        b=Eh2zgG4lz9nkqxhELlaezmKujsyA53CrNzHnJPJ/hPUtSpyiN6MWGE3rPixosn7/a2
         0Tm/xJA2HCmrcCD7Y11yZczOXQpogcd2IoIOCUneZcTs2TxtaH//GDgXZgFhgqGHdpjv
         WbHrJSndQIHvcL0Ldktxl+8jVeFF3Zc5GFxqSAE03ctrKVVfu/z45M/jrW3114oCqiOq
         erFN/a5a5wZwoKqRsBfTuJN/67kElZsVLcOEgq/jEf8lCNB87dcEfarZ90mPt2Px2xpr
         fFCXX2WBS4JEgwpEoqJaow/EPMMlBtJvBOD6zkGczg3iZzHlncevZw7QULUAQ2Kb85U3
         gN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094203; x=1740699003;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=16mDfwgtMHX4C5Bzktye9hLGYxEoL74KODcm/rd0Vtg=;
        b=SLyqz+pdGPz92okOfOeBtr0NfE9yJI1NsIemxpP4lfcpFamdTilf8raPhEFfpfp1Oh
         o6xPwQ1tXbUr35zWu83P6l8nIlKtgcKzv2oQ+r2UDUr23VxazQplOQI69mOtBY07Xdw4
         zRwU9v3K0jsoApS1YF8bymTW5Jy4Nh6OxHR/9a0LJ9+WcDrCkCa4t6ldsmUPbA5HgIdg
         6vs+Q3SsRlXBbFQ6k3DkwzsxUyN7xqKEHJh3qmOwhUOuoUIy30Jdu4kEZiReFeQdTH3G
         RawUfflrQv7dUtewykCeywqs4GUX/P97pacjGojiFC7FSU3h5vvFb2gizqwfsK5jRH/V
         NNDg==
X-Forwarded-Encrypted: i=1; AJvYcCXllqVcOapyZ0eWhIwEgOaQ2x4jutmdSOYyBLnMLBmf4pI3pqOlTrAoXS4WOxG+bw8ZcxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygyw5A2YT+0Xcyvw0DPK2+F0m40LEDOMXRWoUQn+vLsnCGpVq0
	8Uk2JZiSAGs2FDnfdzC5rxySMlP3BN52C3hWNLxNQygQ60rWDh9ZeaVGMOonTtijuh7wdT6NHCT
	rYgsC0PKdFQ==
X-Google-Smtp-Source: AGHT+IE0UCb7fstOq8GvjQmovtZG7N52pSWA/eoj0xYpz/TJAddrAEm6ZQs55YbiR88DnJaYKlzvY93re7M0jA==
X-Received: from pjg5.prod.google.com ([2002:a17:90b:3f45:b0:2ef:d136:17fc])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ece:b0:2ee:6d04:9dac with SMTP id 98e67ed59e1d1-2fce7b3e506mr1466909a91.32.1740094203403;
 Thu, 20 Feb 2025 15:30:03 -0800 (PST)
Date: Thu, 20 Feb 2025 23:29:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250220232959.247600-1-jiaqiyan@google.com>
Subject: [RFC PATCH v3 1/3] KVM: arm64: SIGBUS VMM for SEA guest abort
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

This patch teaches KVM to send a SIGBUS BUS_OBJERR to VMM/vCPU, like
how core kernel signals SIGBUS BUS_OBJERR to a gernal poison consuming
userspace thread when APEI is unable to claim the SEA. In addition to
the benifit that KVM's handling for SEA becomes aligned with core
kernel's behavior:
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
1. Delegate to APEI and GHES to see if SEA can be claimed by them.
2. If APEI failed to claim the SEA, send current thread (i.e. VMM in EL0)
   a si_code=BUS_OBJERR SIGBUS signal. If the DIMM error's physical
   address is available from FAR_EL2, si_addr will be the DIMM error's
   host virtual address in VMM/vCPU's memory space.

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

RFC V3 -> RFC v2
- SEA or ECC error at all levels of TTW can be handled by SIGBUS EL0,
  and no case to inject SError to guest anymore.
- move #include from kvm_ras.h to kvm_ras.c.

RFC v2 -> RFC v1
- reword commit msg
- drop unused parameters from kvm_delegate_guest_sea
- remove KVM_CAP_ARM_SIGBUS_ON_SEA and its opt in code
- set FnV bit in vcpu's ESR_ELx if host ESR_EL2's FnV is set
- add documentation for this new SIGBUS feature

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/include/asm/kvm_ras.h | 29 +++++++-------
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/kvm_ras.c         | 65 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c             |  8 +---
 4 files changed, 83 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/kvm/kvm_ras.c

diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 87e10d9a635b5..bacae54013b4e 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -4,22 +4,25 @@
 #ifndef __ARM64_KVM_RAS_H__
 #define __ARM64_KVM_RAS_H__
 
-#include <linux/acpi.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-
-#include <asm/acpi.h>
+#include <linux/kvm_host.h>
 
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
+ * 2. Send SIGBUS to current with si_code=BUS_OBJERR and si_addr set to
+ *    the poisoned host virtual address. When accurate HVA is unavailable,
+ *    si_addr will be 0.
+ *
+ * Note this applies to both instruction and data abort (ESR_ELx_EC_IABT_*
+ * and ESR_ELx_EC_DABT_*). As the name suggests, KVM must be taking the SEA
+ * when calling into this function, e.g. kvm_vcpu_abt_issea == true.
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
index 0000000000000..47531ed378910
--- /dev/null
+++ b/arch/arm64/kvm/kvm_ras.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/acpi.h>
+#include <linux/types.h>
+
+#include <asm/acpi.h>
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
+	int idx;
+	u64 vcpu_esr = kvm_vcpu_get_esr(vcpu);
+	phys_addr_t fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
+	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
+	unsigned long hva = 0UL;
+
+	/*
+	 * For RAS the host kernel may handle this abort.
+	 * There is no need to SIGBUS VMM, or pass the error into the guest.
+	 */
+	if (kvm_delegate_guest_sea() == 0)
+		return;
+
+	if (kvm_vcpu_sea_far_valid(vcpu)) {
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		hva = gfn_to_hva(vcpu->kvm, gfn);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	}
+
+	/*
+	 * When FAR is not valid, or GFN to HVA translation failed, send 0
+	 * as si_addr like what do_sea() does.
+	 */
+	if (kvm_is_error_hva(hva))
+		hva = 0UL;
+
+	arm64_notify_die("synchronous external abort",
+			 current_pt_regs(), SIGBUS, BUS_OBJERR, hva, vcpu_esr);
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d9..ef6127d0bf24f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1808,13 +1808,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
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
2.48.1.658.g4767266eb4-goog


