Return-Path: <kvm+bounces-55156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A334B2E049
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA1D35E730A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D323376AE;
	Wed, 20 Aug 2025 14:58:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56322337699;
	Wed, 20 Aug 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701911; cv=none; b=jh2UEwbXI4Fx+iudwrETe0pWoFfURFXpIfb750gYNKpCmQJcntYFQ/RhW7J+9NCz7NTzrhx/bdM344jKyWqpMyTnBvWY6lcTd3DpfHNbTX6WoqEVWbK4r7vFuJ8C5mqpzCr6T82CbZv6zkSv7lGohbeiD5007lyLK2KSbQE87ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701911; c=relaxed/simple;
	bh=pS26bJ3stHH1lQyaNM9jEj86ZI2wEwoWeuUD0+00XoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqcMExnzOe1aU/pvHF1dKIPgMPjkulzcaIRdVeO+7FN2IdSKMmS7FLmWB1w0cVqMQ62sqdbnlVY3Hg2JAoRdLs2m/ER7epOrowItnT0B36Q8ycClIIkhrW31eCOazbhtyraGnggjywXhyunMIzPmJ8xuv71WUGZOpQ0zwOjW5BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B02051D31;
	Wed, 20 Aug 2025 07:58:20 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 810D33F738;
	Wed, 20 Aug 2025 07:58:23 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v10 16/43] arm64: RME: Handle realm enter/exit
Date: Wed, 20 Aug 2025 15:55:36 +0100
Message-ID: <20250820145606.180644-17-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Entering a realm is done using a SMC call to the RMM. On exit the
exit-codes need to be handled slightly differently to the normal KVM
path so define our own functions for realm enter/exit and hook them
in if the guest is a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
Changes since v8:
 * Introduce kvm_rec_pre_enter() called before entering an atomic
   section to handle operations that might require memory allocation
   (specifically completing a RIPAS change introduced in a later patch).
 * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
   HPFAR_EL2_NS as a valid flag.
 * Fix exit reason when racing with PSCI shutdown to return
   KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
Changes since v7:
 * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
   been read (although that can never happen in the current code). Tidy
   up the condition to handle any future refactoring.
Changes since v6:
 * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
   vcpu to the error.
 * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
   this exit type.
 * Split code handling a RIPAS change triggered by the guest to the
   following patch.
Changes since v5:
 * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
   change on next entry rather than immediately on the exit. This allows
   the VMM to 'reject' a RIPAS change by refusing to continue
   scheduling.
Changes since v4:
 * Rename handle_rme_exit() to handle_rec_exit()
 * Move the loop to copy registers into the REC enter structure from the
   to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
   where the handler exits to user space and user space wants to modify
   the GPRS.
 * Some code rearrangement in rec_exit_ripas_change().
Changes since v2:
 * realm_set_ipa_state() now provides an output parameter for the
   top_iap that was changed. Use this to signal the VMM with the correct
   range that has been transitioned.
 * Adapt to previous patch changes.
---
 arch/arm64/include/asm/kvm_rme.h |   4 +
 arch/arm64/kvm/Makefile          |   2 +-
 arch/arm64/kvm/arm.c             |  22 +++-
 arch/arm64/kvm/rme-exit.c        | 178 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/rme.c             |  38 +++++++
 5 files changed, 239 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/kvm/rme-exit.c

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 14deace6a4ea..0342b8475f0d 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -97,6 +97,10 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
 int kvm_create_rec(struct kvm_vcpu *vcpu);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
+int kvm_rec_enter(struct kvm_vcpu *vcpu);
+int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
+int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
+
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   unsigned long size,
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 70fa017831b3..e273838aad9c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
 kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o config.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
-	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rme.o \
+	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rme.o rme-exit.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 81a4193d78cf..935ecdfd197e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1233,6 +1233,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (ret > 0)
 			ret = check_vcpu_requests(vcpu);
 
+		if (ret > 0 && vcpu_is_rec(vcpu))
+			ret = kvm_rec_pre_enter(vcpu);
+
 		/*
 		 * Preparing the interrupts to be injected also
 		 * involves poking the GIC, which must be done in a
@@ -1280,7 +1283,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_timing_enter_irqoff();
 
-		ret = kvm_arm_vcpu_enter_exit(vcpu);
+		if (vcpu_is_rec(vcpu))
+			ret = kvm_rec_enter(vcpu);
+		else
+			ret = kvm_arm_vcpu_enter_exit(vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
@@ -1338,8 +1344,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
-		/* Exit types that need handling before we can be preempted */
-		handle_exit_early(vcpu, ret);
+		if (!vcpu_is_rec(vcpu)) {
+			/*
+			 * Exit types that need handling before we can be
+			 * preempted
+			 */
+			handle_exit_early(vcpu, ret);
+		}
 
 		kvm_nested_sync_hwstate(vcpu);
 
@@ -1364,7 +1375,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			ret = ARM_EXCEPTION_IL;
 		}
 
-		ret = handle_exit(vcpu, ret);
+		if (vcpu_is_rec(vcpu))
+			ret = handle_rec_exit(vcpu, ret);
+		else
+			ret = handle_exit(vcpu, ret);
 	}
 
 	/* Tell userspace about in-kernel device output levels */
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
new file mode 100644
index 000000000000..feb248f4377c
--- /dev/null
+++ b/arch/arm64/kvm/rme-exit.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#include <linux/kvm_host.h>
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_psci.h>
+
+#include <asm/rmi_smc.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_rme.h>
+#include <asm/kvm_mmu.h>
+
+typedef int (*exit_handler_fn)(struct kvm_vcpu *vcpu);
+
+static int rec_exit_reason_notimpl(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	vcpu_err(vcpu, "Unhandled exit reason from realm (ESR: %#llx)\n",
+		 rec->run->exit.esr);
+	return -ENXIO;
+}
+
+static int rec_exit_sync_dabt(struct kvm_vcpu *vcpu)
+{
+	return kvm_handle_guest_abort(vcpu);
+}
+
+static int rec_exit_sync_iabt(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	vcpu_err(vcpu, "Unhandled instruction abort (ESR: %#llx).\n",
+		 rec->run->exit.esr);
+	return -ENXIO;
+}
+
+static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long esr = kvm_vcpu_get_esr(vcpu);
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	bool is_write = !(esr & 1);
+	int ret;
+
+	if (is_write)
+		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[0]);
+
+	ret = kvm_handle_sys_reg(vcpu);
+	if (!is_write)
+		rec->run->enter.gprs[0] = vcpu_get_reg(vcpu, rt);
+
+	return ret;
+}
+
+static exit_handler_fn rec_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]	= rec_exit_reason_notimpl,
+	[ESR_ELx_EC_SYS64]	= rec_exit_sys_reg,
+	[ESR_ELx_EC_DABT_LOW]	= rec_exit_sync_dabt,
+	[ESR_ELx_EC_IABT_LOW]	= rec_exit_sync_iabt
+};
+
+static int rec_exit_psci(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	int i;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	return kvm_smccc_call_handler(vcpu);
+}
+
+static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.ripas_base;
+	unsigned long top = rec->run->exit.ripas_top;
+	unsigned long ripas = rec->run->exit.ripas_value;
+
+	if (!kvm_realm_is_private_address(realm, base) ||
+	    !kvm_realm_is_private_address(realm, top - 1)) {
+		vcpu_err(vcpu, "Invalid RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
+			 base, top, ripas);
+		/* Set RMI_REJECT bit */
+		rec->run->enter.flags = REC_ENTER_FLAG_RIPAS_RESPONSE;
+		return -EINVAL;
+	}
+
+	/* Exit to VMM, the actual RIPAS change is done on next entry */
+	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
+				      ripas == RMI_RAM);
+
+	/*
+	 * KVM_EXIT_MEMORY_FAULT requires an return code of -EFAULT, see the
+	 * API documentation
+	 */
+	return -EFAULT;
+}
+
+static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	__vcpu_assign_sys_reg(vcpu, CNTV_CTL_EL0, rec->run->exit.cntv_ctl);
+	__vcpu_assign_sys_reg(vcpu, CNTV_CVAL_EL0, rec->run->exit.cntv_cval);
+	__vcpu_assign_sys_reg(vcpu, CNTP_CTL_EL0, rec->run->exit.cntp_ctl);
+	__vcpu_assign_sys_reg(vcpu, CNTP_CVAL_EL0, rec->run->exit.cntp_cval);
+
+	kvm_realm_timers_update(vcpu);
+}
+
+/*
+ * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * proper exit to userspace.
+ */
+int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+	u8 esr_ec = ESR_ELx_EC(rec->run->exit.esr);
+	unsigned long status, index;
+
+	status = RMI_RETURN_STATUS(rec_run_ret);
+	index = RMI_RETURN_INDEX(rec_run_ret);
+
+	/*
+	 * If a PSCI_SYSTEM_OFF request raced with a vcpu executing, we might
+	 * see the following status code and index indicating an attempt to run
+	 * a REC when the RD state is SYSTEM_OFF.  In this case, we just need to
+	 * return to user space which can deal with the system event or will try
+	 * to run the KVM VCPU again, at which point we will no longer attempt
+	 * to enter the Realm because we will have a sleep request pending on
+	 * the VCPU as a result of KVM's PSCI handling.
+	 */
+	if (status == RMI_ERROR_REALM && index == 1) {
+		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+		return 0;
+	}
+
+	if (rec_run_ret)
+		return -ENXIO;
+
+	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
+	vcpu->arch.fault.far_el2 = rec->run->exit.far;
+	/* HPFAR_EL2 is only valid for RMI_EXIT_SYNC */
+	vcpu->arch.fault.hpfar_el2 = 0;
+
+	update_arch_timer_irq_lines(vcpu);
+
+	/* Reset the emulation flags for the next run of the REC */
+	rec->run->enter.flags = 0;
+
+	switch (rec->run->exit.exit_reason) {
+	case RMI_EXIT_SYNC:
+		/*
+		 * HPFAR_EL2_NS is hijacked to indicate a valid HPFAR value,
+		 * see __get_fault_info()
+		 */
+		vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar | HPFAR_EL2_NS;
+		return rec_exit_handlers[esr_ec](vcpu);
+	case RMI_EXIT_IRQ:
+	case RMI_EXIT_FIQ:
+		return 1;
+	case RMI_EXIT_PSCI:
+		return rec_exit_psci(vcpu);
+	case RMI_EXIT_RIPAS_CHANGE:
+		return rec_exit_ripas_change(vcpu);
+	}
+
+	kvm_pr_unimpl("Unsupported exit reason: %u\n",
+		      rec->run->exit.exit_reason);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	return 0;
+}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index fd214e002bdb..a8ea469a9e3b 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -940,6 +940,44 @@ void kvm_destroy_realm(struct kvm *kvm)
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
+/*
+ * kvm_rec_pre_enter - Complete operations before entering a REC
+ *
+ * Some operations require work to be completed before entering a realm. That
+ * work may require memory allocation so cannot be done in the kvm_rec_enter()
+ * call.
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   < 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+int kvm_rec_pre_enter(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
+		return -EINVAL;
+
+	switch (rec->run->exit.exit_reason) {
+	case RMI_EXIT_HOST_CALL:
+	case RMI_EXIT_PSCI:
+		for (int i = 0; i < REC_RUN_GPRS; i++)
+			rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
+		break;
+	}
+
+	return 1;
+}
+
+int kvm_rec_enter(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	return rmi_rec_enter(virt_to_phys(rec->rec_page),
+			     virt_to_phys(rec->run));
+}
+
 static void free_rec_aux(struct page **aux_pages,
 			 unsigned int num_aux)
 {
-- 
2.43.0


