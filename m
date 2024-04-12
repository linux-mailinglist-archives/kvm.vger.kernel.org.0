Return-Path: <kvm+bounces-14450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B198A29D5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 823B21F2219B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE91E7F7DA;
	Fri, 12 Apr 2024 08:44:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0FF78C96;
	Fri, 12 Apr 2024 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911442; cv=none; b=CoOCJIej/reCQUCJ5b8nURCYCDJzHXSdPJaEfbGKzeBKRdF/SmOdj27kqIfTBMN47cTNeIYGT5UzzlkPIEyAyH0t+4deFnH6oNmkg4OKYutV4BRMuYEUHSgrlSQAF6l+cGIr2yxsgKWz2IjCZdsZgUJvHVu5926CsOZt7qOogOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911442; c=relaxed/simple;
	bh=ran3vRdncg2fBPKCAvc0IZi2hCEcLfyuakbV4gRdBSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K4xkdW7lv+f0eBb8IH7UcGYky9XFGuz6td2qrZcLhKKRTsUgrV/9Hegy5Zz2sRhmzOjWT8pYYl0N1Q6sLBoI7jZph5+EbBVZZc+X3lID3iWDcHS5wkyO7r8rEJHrtK+6nDWNC0e5G9aWHIeDfx1fahxmev2CNrsPG8vRkl64QGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDB7E14BF;
	Fri, 12 Apr 2024 01:44:29 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8183E3F6C4;
	Fri, 12 Apr 2024 01:43:58 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 18/43] arm64: RME: Handle realm enter/exit
Date: Fri, 12 Apr 2024 09:42:44 +0100
Message-Id: <20240412084309.1733783-19-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
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
---
 arch/arm64/include/asm/kvm_rme.h |   3 +
 arch/arm64/kvm/Makefile          |   2 +-
 arch/arm64/kvm/arm.c             |  19 +++-
 arch/arm64/kvm/rme-exit.c        | 180 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/rme.c             |  11 ++
 5 files changed, 209 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/kvm/rme-exit.c

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index cc8f81cfc3c0..749f2eb97bd4 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -96,6 +96,9 @@ void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
 int kvm_create_rec(struct kvm_vcpu *vcpu);
 void kvm_destroy_rec(struct kvm_vcpu *vcpu);
 
+int kvm_rec_enter(struct kvm_vcpu *vcpu);
+int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
+
 void kvm_realm_unmap_range(struct kvm *kvm,
 			   unsigned long ipa,
 			   u64 size,
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1c1d8cdf381f..2eec980cbe5c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -21,7 +21,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o \
-	 rme.o
+	 rme.o rme-exit.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f8daf478114f..e92afb3835f6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1130,7 +1130,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_timing_enter_irqoff();
 
-		ret = kvm_arm_vcpu_enter_exit(vcpu);
+		if (vcpu_is_rec(vcpu))
+			ret = kvm_rec_enter(vcpu);
+		else
+			ret = kvm_arm_vcpu_enter_exit(vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
@@ -1184,10 +1187,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_enable();
 
-		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
-
 		/* Exit types that need handling before we can be preempted */
-		handle_exit_early(vcpu, ret);
+		if (!vcpu_is_rec(vcpu)) {
+			trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu),
+				       *vcpu_pc(vcpu));
+
+			handle_exit_early(vcpu, ret);
+		}
 
 		preempt_enable();
 
@@ -1210,7 +1216,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			ret = ARM_EXCEPTION_IL;
 		}
 
-		ret = handle_exit(vcpu, ret);
+		if (vcpu_is_rec(vcpu))
+			ret = handle_rme_exit(vcpu, ret);
+		else
+			ret = handle_exit(vcpu, ret);
 	}
 
 	/* Tell userspace about in-kernel device output levels */
diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
new file mode 100644
index 000000000000..5bf58c9b42b7
--- /dev/null
+++ b/arch/arm64/kvm/rme-exit.c
@@ -0,0 +1,180 @@
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
+	pr_err("[vcpu %d] Unhandled exit reason from realm (ESR: %#llx)\n",
+	       vcpu->vcpu_id, rec->run->exit.esr);
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
+	pr_err("[vcpu %d] Unhandled instruction abort (ESR: %#llx).\n",
+	       vcpu->vcpu_id, rec->run->exit.esr);
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
+
+	if (ret >= 0 && !is_write)
+		rec->run->entry.gprs[0] = vcpu_get_reg(vcpu, rt);
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
+	int ret;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	ret = kvm_smccc_call_handler(vcpu);
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		rec->run->entry.gprs[i] = vcpu_get_reg(vcpu, i);
+
+	return ret;
+}
+
+static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_rec *rec = &vcpu->arch.rec;
+	unsigned long base = rec->run->exit.ripas_base;
+	unsigned long top = rec->run->exit.ripas_top;
+	unsigned long ripas = rec->run->exit.ripas_value & 1;
+	int ret = -EINVAL;
+
+	if (realm_is_addr_protected(realm, base) &&
+	    realm_is_addr_protected(realm, top - 1)) {
+		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
+					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
+		write_lock(&kvm->mmu_lock);
+		ret = realm_set_ipa_state(vcpu, base, top, ripas);
+		write_unlock(&kvm->mmu_lock);
+	}
+
+	WARN(ret && ret != -ENOMEM,
+	     "Unable to satisfy SET_IPAS for %#lx - %#lx, ripas: %#lx\n",
+	     base, top, ripas);
+
+	/* Exit to VMM to complete the change */
+	kvm_prepare_memory_fault_exit(vcpu, base, top - base, false, false,
+				      ripas == 1);
+
+	return 0;
+}
+
+static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	__vcpu_sys_reg(vcpu, CNTV_CTL_EL0) = rec->run->exit.cntv_ctl;
+	__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0) = rec->run->exit.cntv_cval;
+	__vcpu_sys_reg(vcpu, CNTP_CTL_EL0) = rec->run->exit.cntp_ctl;
+	__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0) = rec->run->exit.cntp_cval;
+
+	kvm_realm_timers_update(vcpu);
+}
+
+/*
+ * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * proper exit to userspace.
+ */
+int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
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
+		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+		return 0;
+	}
+
+	if (rec_run_ret)
+		return -ENXIO;
+
+	vcpu->arch.fault.esr_el2 = rec->run->exit.esr;
+	vcpu->arch.fault.far_el2 = rec->run->exit.far;
+	vcpu->arch.fault.hpfar_el2 = rec->run->exit.hpfar;
+
+	update_arch_timer_irq_lines(vcpu);
+
+	/* Reset the emulation flags for the next run of the REC */
+	rec->run->entry.flags = 0;
+
+	switch (rec->run->exit.exit_reason) {
+	case RMI_EXIT_SYNC:
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
index 9e5983c51393..0a3f823b2446 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -864,6 +864,17 @@ void kvm_destroy_realm(struct kvm *kvm)
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
+int kvm_rec_enter(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
+		return -EINVAL;
+
+	return rmi_rec_enter(virt_to_phys(rec->rec_page),
+			     virt_to_phys(rec->run));
+}
+
 static void free_rec_aux(struct page **aux_pages,
 			 unsigned int num_aux)
 {
-- 
2.34.1


