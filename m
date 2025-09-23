Return-Path: <kvm+bounces-58591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04456B9728D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 20:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC57A176D20
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DE32F9DAD;
	Tue, 23 Sep 2025 18:04:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from vps-ovh.mhejs.net (vps-ovh.mhejs.net [145.239.82.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1FC23CB;
	Tue, 23 Sep 2025 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.239.82.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758650645; cv=none; b=uekbf5DurOx4ze5w6JUqVP4RyeKdWeOLcySIHQfG4yHk53Blf1vEm4rrg62kr+2XTDN4AxS9BdwJaDTe4RIcsKMzMW+cPhRFAlv09ZSk13UO6aj1eDSBTlWVj8VlDJRaOeoTIpEe+mO5wjuO3Alfmhz3X3OXTgCpGWF0pj48eX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758650645; c=relaxed/simple;
	bh=fC7/debq4U++mSMaV3CtV6LEnqqFfbHG0W41nbG0S9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMdRK04xfrUwc9TN7SOd+THlzpLFfxSc9mAW/oYhMMYnu/T0jmRU6SPMlwQ1BXdmP99a6B5NWXhPErt5SdTN95CYmcoO4izNgKPtVpJkE/YRjXvje0sae/cJ4i2SyZflXsmIcIs0VTNWCLPa9ltQWHm6/PxMPXsKymjrlaMKqoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name; spf=pass smtp.mailfrom=vps-ovh.mhejs.net; arc=none smtp.client-ip=145.239.82.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maciej.szmigiero.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vps-ovh.mhejs.net
Received: from MUA
	by vps-ovh.mhejs.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mhej@vps-ovh.mhejs.net>)
	id 1v16sG-00000003CZx-2ira;
	Tue, 23 Sep 2025 19:32:20 +0200
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
	Naveen N Rao <naveen@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: selftests: Test TPR / CR8 sync and interrupt masking
Date: Tue, 23 Sep 2025 19:32:14 +0200
Message-ID: <90ea0b66874d676b93be43e9bf89a9a831323107.1758647049.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: mhej@vps-ovh.mhejs.net

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
* TPR is 0 on reset,
* TPR, PPR and CR8 are equal inside the guest,
* TPR and CR8 read equal by the host after a VMExit
* TPR borderline values set by the host correctly mask interrupts in the
guest.

These hopefully will catch the most obvious cases of improper TPR sync or
interrupt masking.

Do these tests both in x2APIC and xAPIC modes.
The x2APIC mode uses SELF_IPI register to trigger interrupts to give it a
bit of exercise too.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---

Changes from v2:
* Drop the patch with sync TPR from LAPIC to VMCB::V_TPR AVIC fix since it
  has been merged already,

* Use {GET,SET}_APIC_PRI() macros instead of SHIFT/MASK macros,

* Add a global is_x2apic flag instead of passing such argument to helpers,

* Add an explicit TPR == 0 check on guest startup,

* Wrap test_tpr_mask_irq({true, false}) into
  test_tpr_{set,clear}_tpr_mask().

 .../testing/selftests/kvm/include/x86/apic.h  |   3 +
 .../selftests/kvm/x86/xapic_state_test.c      | 290 +++++++++++++++++-
 2 files changed, 285 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 80fe9f69b38d..e9b9aebaac97 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -28,6 +28,8 @@
 #define		GET_APIC_ID_FIELD(x)	(((x) >> 24) & 0xFF)
 #define	APIC_TASKPRI	0x80
 #define	APIC_PROCPRI	0xA0
+#define	GET_APIC_PRI(x) (((x) & GENMASK(7, 4)) >> 4)
+#define	SET_APIC_PRI(x, y) (((x) & ~GENMASK(7, 4)) | (y << 4))
 #define	APIC_EOI	0xB0
 #define	APIC_SPIV	0xF0
 #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
@@ -67,6 +69,7 @@
 #define	APIC_TMICT	0x380
 #define	APIC_TMCCT	0x390
 #define	APIC_TDCR	0x3E0
+#define	APIC_SELF_IPI	0x3F0
 
 void apic_disable(void);
 void xapic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
index fdebff1165c7..e9fc99b831a2 100644
--- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <fcntl.h>
+#include <stdatomic.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <unistd.h>
 
 #include "apic.h"
 #include "kvm_util.h"
@@ -12,10 +14,262 @@
 
 struct xapic_vcpu {
 	struct kvm_vcpu *vcpu;
-	bool is_x2apic;
 	bool has_xavic_errata;
 };
 
+static bool is_x2apic;
+
+#define IRQ_VECTOR 0x20
+
+/* See also the comment at similar assertion in memslot_perf_test.c */
+static_assert(ATOMIC_INT_LOCK_FREE == 2, "atomic int is not lockless");
+
+static atomic_uint tpr_guest_irq_sync_val;
+
+static void tpr_guest_irq_sync_flag_reset(void)
+{
+	atomic_store_explicit(&tpr_guest_irq_sync_val, 0,
+			      memory_order_release);
+}
+
+static unsigned int tpr_guest_irq_sync_val_get(void)
+{
+	return atomic_load_explicit(&tpr_guest_irq_sync_val,
+				    memory_order_acquire);
+}
+
+static void tpr_guest_irq_sync_val_inc(void)
+{
+	atomic_fetch_add_explicit(&tpr_guest_irq_sync_val, 1,
+				  memory_order_acq_rel);
+}
+
+static void tpr_guest_irq_handler_xapic(struct ex_regs *regs)
+{
+	tpr_guest_irq_sync_val_inc();
+
+	xapic_write_reg(APIC_EOI, 0);
+}
+
+static void tpr_guest_irq_handler_x2apic(struct ex_regs *regs)
+{
+	tpr_guest_irq_sync_val_inc();
+
+	x2apic_write_reg(APIC_EOI, 0);
+}
+
+static void tpr_guest_irq_queue(void)
+{
+	if (is_x2apic) {
+		x2apic_write_reg(APIC_SELF_IPI, IRQ_VECTOR);
+	} else {
+		uint32_t icr, icr2;
+
+		icr = APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED |
+			IRQ_VECTOR;
+		icr2 = 0;
+
+		xapic_write_reg(APIC_ICR2, icr2);
+		xapic_write_reg(APIC_ICR, icr);
+	}
+}
+
+static uint8_t tpr_guest_tpr_get(void)
+{
+	uint32_t taskpri;
+
+	if (is_x2apic)
+		taskpri = x2apic_read_reg(APIC_TASKPRI);
+	else
+		taskpri = xapic_read_reg(APIC_TASKPRI);
+
+	return GET_APIC_PRI(taskpri);
+}
+
+static uint8_t tpr_guest_ppr_get(void)
+{
+	uint32_t procpri;
+
+	if (is_x2apic)
+		procpri = x2apic_read_reg(APIC_PROCPRI);
+	else
+		procpri = xapic_read_reg(APIC_PROCPRI);
+
+	return GET_APIC_PRI(procpri);
+}
+
+static uint8_t tpr_guest_cr8_get(void)
+{
+	uint64_t cr8;
+
+	asm volatile ("mov %%cr8, %[cr8]\n\t" : [cr8] "=r"(cr8));
+
+	return cr8 & GENMASK(3, 0);
+}
+
+static void tpr_guest_check_tpr_ppr_cr8_equal(void)
+{
+	uint8_t tpr;
+
+	tpr = tpr_guest_tpr_get();
+
+	GUEST_ASSERT_EQ(tpr_guest_ppr_get(), tpr);
+	GUEST_ASSERT_EQ(tpr_guest_cr8_get(), tpr);
+}
+
+static void tpr_guest_code(void)
+{
+	cli();
+
+	if (is_x2apic)
+		x2apic_enable();
+	else
+		xapic_enable();
+
+	GUEST_ASSERT_EQ(tpr_guest_tpr_get(), 0);
+	tpr_guest_check_tpr_ppr_cr8_equal();
+
+	tpr_guest_irq_queue();
+
+	/* TPR = 0 but IRQ masked by IF=0, should not fire */
+	udelay(1000);
+	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 0);
+
+	sti();
+
+	/* IF=1 now, IRQ should fire */
+	while (tpr_guest_irq_sync_val_get() == 0)
+		cpu_relax();
+	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
+
+	GUEST_SYNC(0);
+	tpr_guest_check_tpr_ppr_cr8_equal();
+
+	tpr_guest_irq_queue();
+
+	/* IRQ masked by barely high enough TPR now, should not fire */
+	udelay(1000);
+	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
+
+	GUEST_SYNC(1);
+	tpr_guest_check_tpr_ppr_cr8_equal();
+
+	/* TPR barely low enough now to unmask IRQ, should fire */
+	while (tpr_guest_irq_sync_val_get() == 1)
+		cpu_relax();
+	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 2);
+
+	GUEST_DONE();
+}
+
+static uint8_t lapic_tpr_get(struct kvm_lapic_state *xapic)
+{
+	return GET_APIC_PRI(*((u32 *)&xapic->regs[APIC_TASKPRI]));
+}
+
+static void lapic_tpr_set(struct kvm_lapic_state *xapic, uint8_t val)
+{
+	u32 *taskpri = (u32 *)&xapic->regs[APIC_TASKPRI];
+
+	*taskpri = SET_APIC_PRI(*taskpri, val);
+}
+
+static uint8_t sregs_tpr(struct kvm_sregs *sregs)
+{
+	return sregs->cr8 & GENMASK(3, 0);
+}
+
+static void test_tpr_check_tpr_zero(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic_state xapic;
+
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
+
+	TEST_ASSERT_EQ(lapic_tpr_get(&xapic), 0);
+}
+
+static void test_tpr_check_tpr_cr8_equal(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sregs sregs;
+	struct kvm_lapic_state xapic;
+
+	vcpu_sregs_get(vcpu, &sregs);
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
+
+	TEST_ASSERT_EQ(sregs_tpr(&sregs), lapic_tpr_get(&xapic));
+}
+
+static void test_tpr_mask_irq(struct kvm_vcpu *vcpu, bool mask)
+{
+	struct kvm_lapic_state xapic;
+	uint8_t tpr;
+
+	static_assert(IRQ_VECTOR >= 16, "invalid IRQ vector number");
+	tpr = IRQ_VECTOR / 16;
+	if (!mask)
+		tpr--;
+
+	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
+	lapic_tpr_set(&xapic, tpr);
+	vcpu_ioctl(vcpu, KVM_SET_LAPIC, &xapic);
+}
+
+static void test_tpr_set_tpr_mask(struct kvm_vcpu *vcpu)
+{
+	test_tpr_mask_irq(vcpu, true);
+}
+
+static void test_tpr_clear_tpr_mask(struct kvm_vcpu *vcpu)
+{
+	test_tpr_mask_irq(vcpu, false);
+}
+
+static void test_tpr(struct kvm_vcpu *vcpu)
+{
+	bool run_guest = true;
+
+	sync_global_to_guest(vcpu->vm, is_x2apic);
+
+	/* According to the SDM/APM the TPR value at reset is 0 */
+	test_tpr_check_tpr_zero(vcpu);
+	test_tpr_check_tpr_cr8_equal(vcpu);
+
+	tpr_guest_irq_sync_flag_reset();
+	sync_global_to_guest(vcpu->vm, tpr_guest_irq_sync_val);
+
+	while (run_guest) {
+		struct ucall uc;
+
+		alarm(2);
+		vcpu_run(vcpu);
+		alarm(0);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			test_tpr_check_tpr_cr8_equal(vcpu);
+
+			run_guest = false;
+			break;
+		case UCALL_SYNC:
+			test_tpr_check_tpr_cr8_equal(vcpu);
+
+			if (uc.args[1] == 0)
+				test_tpr_set_tpr_mask(vcpu);
+			else if (uc.args[1] == 1)
+				test_tpr_clear_tpr_mask(vcpu);
+			else
+				TEST_FAIL("Unknown SYNC %lu", uc.args[1]);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall result 0x%lx", uc.cmd);
+			break;
+		}
+	}
+}
+
 static void xapic_guest_code(void)
 {
 	cli();
@@ -80,7 +334,7 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
 	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
-	if (!x->is_x2apic) {
+	if (!is_x2apic) {
 		if (!x->has_xavic_errata)
 			val &= (-1u | (0xffull << (32 + 24)));
 	} else if (val & X2APIC_RSVD_BITS_MASK) {
@@ -100,7 +354,7 @@ static void __test_icr(struct xapic_vcpu *x, uint64_t val)
 	 * it is as _must_ be zero.  Intel simply ignores the bit.  Don't test
 	 * the BUSY bit for x2APIC, as there is no single correct behavior.
 	 */
-	if (!x->is_x2apic)
+	if (!is_x2apic)
 		____test_icr(x, val | APIC_ICR_BUSY);
 
 	____test_icr(x, val & ~(u64)APIC_ICR_BUSY);
@@ -195,6 +449,12 @@ static void test_apic_id(void)
 	kvm_vm_free(vm);
 }
 
+static void clear_x2apic_cap_map_apic(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_X2APIC);
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+}
+
 static void test_x2apic_id(void)
 {
 	struct kvm_lapic_state lapic = {};
@@ -226,21 +486,30 @@ int main(int argc, char *argv[])
 {
 	struct xapic_vcpu x = {
 		.vcpu = NULL,
-		.is_x2apic = true,
 	};
 	struct kvm_vm *vm;
 
+	/* x2APIC tests */
+	is_x2apic = true;
+
 	vm = vm_create_with_one_vcpu(&x.vcpu, x2apic_guest_code);
 	test_icr(&x);
 	kvm_vm_free(vm);
 
+	vm = vm_create_with_one_vcpu(&x.vcpu, tpr_guest_code);
+	vm_install_exception_handler(vm, IRQ_VECTOR, tpr_guest_irq_handler_x2apic);
+	test_tpr(x.vcpu);
+	kvm_vm_free(vm);
+
+	/* xAPIC tests */
+	is_x2apic = false;
+
 	/*
 	 * Use a second VM for the xAPIC test so that x2APIC can be hidden from
 	 * the guest in order to test AVIC.  KVM disallows changing CPUID after
 	 * KVM_RUN and AVIC is disabled if _any_ vCPU is allowed to use x2APIC.
 	 */
 	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
-	x.is_x2apic = false;
 
 	/*
 	 * AMD's AVIC implementation is buggy (fails to clear the ICR BUSY bit),
@@ -251,12 +520,17 @@ int main(int argc, char *argv[])
 	x.has_xavic_errata = host_cpu_is_amd &&
 			     get_kvm_amd_param_bool("avic");
 
-	vcpu_clear_cpuid_feature(x.vcpu, X86_FEATURE_X2APIC);
-
-	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+	clear_x2apic_cap_map_apic(vm, x.vcpu);
 	test_icr(&x);
 	kvm_vm_free(vm);
 
+	/* Also do a TPR non-x2APIC test */
+	vm = vm_create_with_one_vcpu(&x.vcpu, tpr_guest_code);
+	clear_x2apic_cap_map_apic(vm, x.vcpu);
+	vm_install_exception_handler(vm, IRQ_VECTOR, tpr_guest_irq_handler_xapic);
+	test_tpr(x.vcpu);
+	kvm_vm_free(vm);
+
 	test_apic_id();
 	test_x2apic_id();
 }

