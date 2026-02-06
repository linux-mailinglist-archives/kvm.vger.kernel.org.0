Return-Path: <kvm+bounces-70482-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GNbOJIw8hmnzLAQAu9opvQ
	(envelope-from <kvm+bounces-70482-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A95F102755
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 243563049EEF
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A244C42DFE8;
	Fri,  6 Feb 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VE/DXPPR"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60EA429835
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404958; cv=none; b=SzdNj22cEx+gPfGVuUqic3IkUexBCbeJA+9/ujv50QBlfkam9BmPS0suk0uLEPxR2DTxg5KaBJsNyE+8QOs7kDHyV6kghZXV7g5aybr4bIyR6SCDaPVTRlJhYx1wZy/mKgcEWI1aIj0Aoom1M9uTd8B9O8r3iK/Nl2tre6r94M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404958; c=relaxed/simple;
	bh=F9dZRsnyxRXWTRB7obIOuB4MUPqlW49vwnA1iHjR1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9bFRxyA/YCScx7SBChZz9wqduvNb3SPEwCON0E+enKxc2f9WPBGBCDMA2QaLaFcJgdYgltYikkgzRDeNMnsFruxhAyc6DcVL6aBj63Rn223xJFBKiGauOyKPNeQoC1JauNbNW4mjpC/nd12/TScGLg2DqQ7yVIDyEhpcYTXaBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VE/DXPPR; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NIvn4eC5R359Z5KTSY9RaVtvmEanE1nmyKVWvi5ZPU=;
	b=VE/DXPPRraC2Q6IytJi4MsoyDNfSIEFGunIKUZ+ecj9qC22kQuKGyHip/soe2ZAQ92wMzC
	BB75XDXU0GZJ9KYguHGJ7XZFkX8A5F53GEEbAOwvu26cr+pNd05NDDF8+yimIRxgt9Z+AW
	s+xKkG91Eh8sizDQnMw7V5xi802zrcc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v5 04/26] KVM: selftests: Add a test for LBR save/restore (ft. nested)
Date: Fri,  6 Feb 2026 19:08:29 +0000
Message-ID: <20260206190851.860662-5-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70482-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4A95F102755
X-Rspamd-Action: no action

Add a selftest exercising save/restore with usage of LBRs in both L1 and
L2, and making sure all LBRs remain intact.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 .../selftests/kvm/x86/svm_lbr_nested_state.c  | 146 ++++++++++++++++++
 3 files changed, 152 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 58eee0474db6..7810f9db5f77 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/svm_lbr_nested_state
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
 TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 4ebae4269e68..db0171935197 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1360,6 +1360,11 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
+static inline bool kvm_is_lbrv_enabled(void)
+{
+	return !!get_kvm_amd_param_integer("lbrv");
+}
+
 uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
new file mode 100644
index 000000000000..0a17a2c71634
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google, Inc.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+
+#define L2_GUEST_STACK_SIZE 64
+
+#define DO_BRANCH() do { asm volatile("jmp 1f\n 1: nop"); } while (0)
+
+struct lbr_branch {
+	u64 from, to;
+};
+
+volatile struct lbr_branch l2_branch;
+
+#define RECORD_AND_CHECK_BRANCH(b)					\
+do {									\
+	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);			\
+	DO_BRANCH();							\
+	(b)->from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);			\
+	(b)->to = rdmsr(MSR_IA32_LASTBRANCHTOIP);			\
+	/* Disabe LBR right after to avoid overriding the IPs */	\
+	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);					\
+									\
+	GUEST_ASSERT_NE((b)->from, 0);					\
+	GUEST_ASSERT_NE((b)->to, 0);					\
+} while (0)
+
+#define CHECK_BRANCH_MSRS(b)						\
+do {									\
+	GUEST_ASSERT_EQ((b)->from, rdmsr(MSR_IA32_LASTBRANCHFROMIP));	\
+	GUEST_ASSERT_EQ((b)->to, rdmsr(MSR_IA32_LASTBRANCHTOIP));	\
+} while (0)
+
+#define CHECK_BRANCH_VMCB(b, vmcb)					\
+do {									\
+	GUEST_ASSERT_EQ((b)->from, vmcb->save.br_from);			\
+	GUEST_ASSERT_EQ((b)->to, vmcb->save.br_to);			\
+} while (0)
+
+static void l2_guest_code(struct svm_test_data *svm)
+{
+	/* Record a branch, trigger save/restore, and make sure LBRs are intact */
+	RECORD_AND_CHECK_BRANCH(&l2_branch);
+	GUEST_SYNC(true);
+	CHECK_BRANCH_MSRS(&l2_branch);
+	vmmcall();
+}
+
+static void l1_guest_code(struct svm_test_data *svm, bool nested_lbrv)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	struct lbr_branch l1_branch;
+
+	/* Record a branch, trigger save/restore, and make sure LBRs are intact */
+	RECORD_AND_CHECK_BRANCH(&l1_branch);
+	GUEST_SYNC(true);
+	CHECK_BRANCH_MSRS(&l1_branch);
+
+	/* Run L2, which will also do the same */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	if (nested_lbrv)
+		vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	else
+		vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+
+	/* Trigger save/restore one more time before checking, just for kicks */
+	GUEST_SYNC(true);
+
+	/*
+	 * If LBR_CTL_ENABLE is set, L1 and L2 should have separate LBR MSRs, so
+	 * expect L1's LBRs to remain intact and L2 LBRs to be in the VMCB.
+	 * Otherwise, the MSRs are shared between L1 & L2 so expect L2's LBRs.
+	 */
+	if (nested_lbrv) {
+		CHECK_BRANCH_MSRS(&l1_branch);
+		CHECK_BRANCH_VMCB(&l2_branch, vmcb);
+	} else {
+		CHECK_BRANCH_MSRS(&l2_branch);
+	}
+	GUEST_DONE();
+}
+
+void test_lbrv_nested_state(bool nested_lbrv)
+{
+	struct kvm_x86_state *state = NULL;
+	struct kvm_vcpu *vcpu;
+	vm_vaddr_t svm_gva;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	pr_info("Testing with nested LBRV %s\n", nested_lbrv ? "enabled" : "disabled");
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vcpu_alloc_svm(vm, &svm_gva);
+	vcpu_args_set(vcpu, 2, svm_gva, nested_lbrv);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			/* Save the vCPU state and restore it in a new VM on sync */
+			pr_info("Guest triggered save/restore.\n");
+			state = vcpu_save_state(vcpu);
+			kvm_vm_release(vm);
+			vcpu = vm_recreate_with_one_vcpu(vm);
+			vcpu_load_state(vcpu, state);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+done:
+	if (state)
+		kvm_x86_state_cleanup(state);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_is_lbrv_enabled());
+
+	test_lbrv_nested_state(/*nested_lbrv=*/false);
+	test_lbrv_nested_state(/*nested_lbrv=*/true);
+
+	return 0;
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


