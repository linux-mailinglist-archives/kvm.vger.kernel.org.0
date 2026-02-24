Return-Path: <kvm+bounces-71707-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBsDIhYqnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71707-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:45:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CF018D9F5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE07C3134DAC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79183B8BA3;
	Tue, 24 Feb 2026 22:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqvtB6eA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7863AEF49;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972473; cv=none; b=ZOQIrG1zCDocezZMKL0iD3L0KfvaRzqQrv0djE8aliCCfHyQCjiaPF6iCRecbgSaF3NzWIFpDZ9x/oX4GN2q3wkCoearZ5ynWBUIlqXzi15L5sZWGefYgS4OdgawgOC9acOGHn8vqQoguDUZdUI0XBKH+yD6QSd6gWmzp1jdA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972473; c=relaxed/simple;
	bh=Azr0nTsvGAE8w6vk55HoET74YyhG7h/Gv57ZeCxeZk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpCw6sxmv9ggvj+2AmNngF7Jy9hz7gZR6J9MjpE1HamxV5qEIjKheQMMGDRMTRAfCWw0RYAu2iFlHK9DS0t3sKFyLVZ4iS5gAf8LyQOzvmoT3QmfAgGWsNgID4EswHeBFEWro/sgs264NePqM6kUEADS8c10YFL/OboldfCNDXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqvtB6eA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77025C116D0;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972473;
	bh=Azr0nTsvGAE8w6vk55HoET74YyhG7h/Gv57ZeCxeZk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqvtB6eA637PXWxwkxFweBsNrez2K55TAf60zVa1wCU9/koR/pB6bF0an6NMiVuB+
	 gcyu2A26Cdo16MJZLvTBM/fyqh8a6YjVbgHRrXU6x0OMh3Whue4P4V5dEYg+X8yawt
	 VyNhBZnTkZfmjNUUIUwc0g3MZnCSK7TGYFIkqRjMN5sVwYO6+s1LMd8uFNJLOsVRys
	 VT9svY7iSmf6QK0i8kxx/+k6mQXxtlebJhVi/gWDUElvo6zyMtMTTZcMq5a1xuDEnG
	 4a86eQ95WmI6UCUNMoCcNrrHXZCZ6pxykVHbCKqNhuepH6FBBusJTwQxGZyoDlR+LJ
	 H3/aFvlujVu5A==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 31/31] KVM: selftest: Add a selftest for VMRUN/#VMEXIT with unmappable vmcb12
Date: Tue, 24 Feb 2026 22:34:05 +0000
Message-ID: <20260224223405.3270433-32-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71707-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 18CF018D9F5
X-Rspamd-Action: no action

Add a test that verifies that KVM correctly injects a #GP for nested
VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 cannot be
mapped.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   | 95 +++++++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 36b48e766e499..f12e7c17d379d 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -110,6 +110,7 @@ TEST_GEN_PROGS_x86 += x86/state_test
 TEST_GEN_PROGS_x86 += x86/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_invalid_vmcb12_gpa
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86 += x86/svm_lbr_nested_state
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
new file mode 100644
index 0000000000000..5b0dec4240937
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google LLC.
+ */
+#include "kvm_util.h"
+#include "vmx.h"
+#include "svm_util.h"
+#include "kselftest.h"
+
+
+#define L2_GUEST_STACK_SIZE 64
+
+#define SYNC_GP 101
+#define SYNC_L2_STARTED 102
+
+extern char invalid_vmrun;
+
+static void guest_gp_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(SYNC_GP);
+	regs->rip = (uintptr_t)&invalid_vmrun;
+}
+
+static void l2_guest_code(void)
+{
+	GUEST_SYNC(SYNC_L2_STARTED);
+	vmcall();
+}
+
+static void l1_guest_code(struct svm_test_data *svm, u64 invalid_vmcb12_gpa)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(svm->vmcb, invalid_vmcb12_gpa); /* #GP */
+
+	/* GP handler should jump here */
+	asm volatile ("invalid_vmrun:");
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_x86_state *state;
+	vm_vaddr_t nested_gva = 0;
+	struct kvm_vcpu *vcpu;
+	uint32_t maxphyaddr;
+	u64 max_legal_gpa;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+
+	/*
+	 * Find the max legal GPA that is not backed by a memslot (i.e. cannot
+	 * be mapped by KVM).
+	 */
+	maxphyaddr = kvm_cpuid_property(vcpu->cpuid, X86_PROPERTY_MAX_PHY_ADDR);
+	max_legal_gpa = BIT_ULL(maxphyaddr) - PAGE_SIZE;
+	vcpu_alloc_svm(vm, &nested_gva);
+	vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
+
+	/* VMRUN with max_legal_gpa, KVM injects a #GP */
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
+
+	/*
+	 * Enter L2 (with a legit vmcb12 GPA), then overwrite vmcb12 GPA with
+	 * max_legal_gpa. KVM will fail to map vmcb12 on nested VM-Exit and
+	 * cause a shutdown.
+	 */
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], SYNC_L2_STARTED);
+
+	state = vcpu_save_state(vcpu);
+	state->nested.hdr.svm.vmcb_pa = max_legal_gpa;
+	vcpu_load_state(vcpu, state);
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
+
+	kvm_x86_state_cleanup(state);
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.53.0.414.gf7e9f6c205-goog


