Return-Path: <kvm+bounces-65380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C12D5CA9895
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 23:49:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E925315C811
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 22:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3507C2E9EC3;
	Fri,  5 Dec 2025 22:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1VPol7ZR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A438440855
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764974982; cv=none; b=pD3uOapTPjeeMXFfp3yKPzB8rgQFH7fqnKvxbaVuSdI0Zf3Wt0E4MZb+R0kR5e6T9unzCQkS11Mtr3wlF3w/3ZjmfbLljoOrEAvNYkpiYBw5loyUXjWnoYDycZFJgsvB97f0TUdrv9XFHAUIA6LRBCo/GIAFsmxGKeS8hddEIR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764974982; c=relaxed/simple;
	bh=X57tVemjh2jaVhBk5NaR3kFttGoCvaki3I+cGsePSzY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dY3VZjvsk2H9RVXm67m91VCx1FD9Mpc7ZXaMuIUNIazukeiUsBmd4Mcs07tK3E0D/svps2COzGzxxeHIDPLbG1LrrwZc3tJ6WQMm4iF/POVK1ojleSSADH14Aws5bk+in9DzhFxmYeDoqj7n4bJOQmUmr0348QbdhZV5XZdUvYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1VPol7ZR; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-298535ef0ccso33553975ad.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 14:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764974980; x=1765579780; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZMrwhko6AnIBgvP4nQrBCm5/odBpP9xiyPtrdy1jwg=;
        b=1VPol7ZRgo9NnWjnpvClHlOMl/hI+9fhbJb+LKE18puBE2+OVrlKrFFpF/mEZMFQfy
         3uyJj/lNWHLUUJ6aXBKNr0i8W13rOiM9++un2xkseinNbYU7NMCdciLQe3hzLNp+36MB
         N1bKEOCgnFFQlOU0pR113+CQQWuVlXmLeOVVpDlQOe1HOZ8T5pEAxmSEyxxlyduv1fT/
         mD3vrxr6uJT/Mk9Dpe8kUvwPntPVavSRIZnKeAIr18MgX5WkH9BHLItKuljD5XI1XnMK
         /52YugO88dOI/S3J6B9stfYeauEruLDYBqm+XfM8IATGRSXfmECHBPERdhjb4EGez3hm
         OHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764974980; x=1765579780;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dZMrwhko6AnIBgvP4nQrBCm5/odBpP9xiyPtrdy1jwg=;
        b=VS89T9L7s1/Qigq1HRg15copMMK7v6FGHziyvJN10StgL25EX0JNyUGeH9VvDuIcU/
         hiVjoiSE6DweKbs4UYXkr0Al1maexKN2xMkI7avm94mOXd2CRLNeKU35BCwkhRVY6dCp
         XKKzuMnRP+f0Q/mltAUfY8Zq+L4lb1/XNpxZ7EFDSq5dvaS+/RfBa6uvJVc+0jGbSC5n
         lDdMGN+nJf6Cqb6GHV9jnjujlPqktxqIcdp155dRbJ/8Tgb9OHS6xLe2EvGVKdTnRvme
         /uuNyN6MwXLkugg905/AqfhDu5lClTIM2NYMXZzthCwHL8UyG3XJwiiH3SNhc7a13O2b
         6ANg==
X-Gm-Message-State: AOJu0YzZzE/avBOpMxjoavleL9tkoanJRi604h89K9oCesIyJag7pYcE
	Bxu6CJegnzntm+garxRyUKDHsHooVCVjUHn9mEIbc7ACcBeiGdrrUGbhGZM56070jDPzfEU7rwU
	n9j4mXw==
X-Google-Smtp-Source: AGHT+IFTC7PszfajORMIYajL483lbmvE3y8WUlQs0qfVTOBKYdKjPNhmn5O/LeHcolNjk6wzRSDQMrC0yjE=
X-Received: from pjbbg7.prod.google.com ([2002:a17:90b:d87:b0:340:5c38:986c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d02:b0:343:edb0:1012
 with SMTP id 98e67ed59e1d1-349a25b49f8mr445655a91.21.1764974979916; Fri, 05
 Dec 2025 14:49:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 14:49:37 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205224937.428122-1-seanjc@google.com>
Subject: [PATCH v4] KVM: selftests: Test TPR / CR8 sync and interrupt masking
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>, Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

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
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
[sean: put code in separate test]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Maciej's TPR test.  The only change relative to v3 (well, the only intended
change :-D) is to move the testcase to its own test.  IMO, it's cleaner for
both this test and the existing xapic_state_test (which I plan on splitting
up at some point).

v3: https://lore.kernel.org/all/90ea0b66874d676b93be43e9bf89a9a831323107.1758647049.git.maciej.szmigiero@oracle.com

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   3 +
 .../selftests/kvm/x86/xapic_tpr_test.c        | 276 ++++++++++++++++++
 3 files changed, 280 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/xapic_tpr_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..3789890421bd 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -124,6 +124,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
 TEST_GEN_PROGS_x86 += x86/xapic_ipi_test
 TEST_GEN_PROGS_x86 += x86/xapic_state_test
+TEST_GEN_PROGS_x86 += x86/xapic_tpr_test
 TEST_GEN_PROGS_x86 += x86/xcr0_cpuid_test
 TEST_GEN_PROGS_x86 += x86/xss_msr_test
 TEST_GEN_PROGS_x86 += x86/debug_regs
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
diff --git a/tools/testing/selftests/kvm/x86/xapic_tpr_test.c b/tools/testing/selftests/kvm/x86/xapic_tpr_test.c
new file mode 100644
index 000000000000..3862134d9d40
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/xapic_tpr_test.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <stdatomic.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include "apic.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
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
+	GUEST_SYNC(true);
+	tpr_guest_check_tpr_ppr_cr8_equal();
+
+	tpr_guest_irq_queue();
+
+	/* IRQ masked by barely high enough TPR now, should not fire */
+	udelay(1000);
+	GUEST_ASSERT_EQ(tpr_guest_irq_sync_val_get(), 1);
+
+	GUEST_SYNC(false);
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
+static void test_tpr_set_tpr_for_irq(struct kvm_vcpu *vcpu, bool mask)
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
+static void test_tpr(bool __is_x2apic)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool done = false;
+
+	is_x2apic = __is_x2apic;
+
+	vm = vm_create_with_one_vcpu(&vcpu, tpr_guest_code);
+	if (is_x2apic) {
+		vm_install_exception_handler(vm, IRQ_VECTOR,
+					     tpr_guest_irq_handler_x2apic);
+	} else {
+		vm_install_exception_handler(vm, IRQ_VECTOR,
+					     tpr_guest_irq_handler_xapic);
+		vcpu_clear_cpuid_feature(vcpu, X86_FEATURE_X2APIC);
+		virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+	}
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
+	while (!done) {
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
+			done = true;
+			break;
+		case UCALL_SYNC:
+			test_tpr_check_tpr_cr8_equal(vcpu);
+			test_tpr_set_tpr_for_irq(vcpu, uc.args[1]);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall result 0x%lx", uc.cmd);
+			break;
+		}
+	}
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	/*
+	 * Use separate VMs for the xAPIC and x2APIC tests so that x2APIC can
+	 * be fully hidden from the guest.  KVM disallows changing CPUID after
+	 * KVM_RUN and AVIC is disabled if _any_ vCPU is allowed to use x2APIC.
+	 */
+	test_tpr(false);
+	test_tpr(true);
+}

base-commit: 5d3e2d9ba9ed68576c70c127e4f7446d896f2af2
-- 
2.52.0.223.gf5cc29aaa4-goog


