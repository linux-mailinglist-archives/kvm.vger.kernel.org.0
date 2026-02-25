Return-Path: <kvm+bounces-71724-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOKbAHtKnmnXUQQAu9opvQ
	(envelope-from <kvm+bounces-71724-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:03:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AC90F18E817
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 179DB311EEA2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFE42820AC;
	Wed, 25 Feb 2026 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQ9Fy5yt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5842367CF;
	Wed, 25 Feb 2026 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981204; cv=none; b=tyLrmuqy9SHXflWJyCnri2TSrTyrovXiJTDY30e82WEG2w9NvwHfzSwtMoSytKZGMcpxAVmExnKQ06vMfuOhwP2o/pql/oeDcn7i9XeB40JdyBQxeyXRNAXEzAKA1u5YmTtbqR8Q7LXiSrzsaJThbU0v8iLUeJnfneF2teStz/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981204; c=relaxed/simple;
	bh=r4A3oZ1ITmR8NbPpP/pNNBimg1uZceWTv2yU3SBFO6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9VAAcAfzd5mwXaBC2+W3rhXEl3Rm4QUbMfCaRvPwU5zlr0nOO8H10ce+vzHmtqDzrJlhZbK2Zb8BEo6enf3Rvibmgojho8//z5z5RXaUWIVbPTaNgU4tDsfyTDsmf24K7uiRSh6llzMrdFwVDFcbrLvIzHrgjTbAC+7YZnZxyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQ9Fy5yt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B315EC19423;
	Wed, 25 Feb 2026 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771981203;
	bh=r4A3oZ1ITmR8NbPpP/pNNBimg1uZceWTv2yU3SBFO6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQ9Fy5ytgWKTYHtbh9f1IG65mVdlTVYg7/vz5d0IAlei+J4Vj+hZzw1JO/uEiQif8
	 GkZfx7M2a1RTuoQKCKFqGR/Fv0johx5YZx1jUq2kidXRluLUE7DdDqBrtGLAoFw+Rl
	 +N0BxatqOhjFezMnsiMldqqNH2Okio99OvMHaCaHrkZvgw8TKC8bpjPkhJL4H5+m0v
	 19xzpp3BTg0A3bC4DBLBS1ZodaBEYr/Sj2MLUZXRLcKMUZstZmEbw/Nb7elGFAWkg/
	 O3xNbvn5EicWchtexmcrJiJ8qvuxH1F0OATPr2+UaWxyl6R0QVOxNL05yT9en7hQ/O
	 PYseY+2hOvQVg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 8/8] DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug
Date: Wed, 25 Feb 2026 00:59:50 +0000
Message-ID: <20260225005950.3739782-9-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260225005950.3739782-1-yosry@kernel.org>
References: <20260225005950.3739782-1-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71724-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AC90F18E817
X-Rspamd-Action: no action

Update svm_nested_soft_inject_test such that L1 syncs to userspace
before running L2. The test then enables single-stepping and steps
through guest code until VMRUN is execute, and saves/restores the VM
immediately after (before L2 runs).

This reproduces a bug in save/restore where L2's RIP is not used
correctly to construct the vmcb02 at the destination.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     | 74 +++++++++++++++----
 2 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index fab18e9be66c9..7e0213a88697d 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1275,6 +1275,8 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu)
 	return state;
 }
 
+#define LOAD_REGS_BEFORE_NESTED 1
+
 void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state)
 {
 	vcpu_sregs_set(vcpu, &state->sregs);
@@ -1287,10 +1289,14 @@ void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state)
 	vcpu_events_set(vcpu, &state->events);
 	vcpu_mp_state_set(vcpu, &state->mp_state);
 	vcpu_debugregs_set(vcpu, &state->debugregs);
-	vcpu_regs_set(vcpu, &state->regs);
+	if (LOAD_REGS_BEFORE_NESTED)
+		vcpu_regs_set(vcpu, &state->regs);
 
 	if (state->nested.size)
 		vcpu_nested_state_set(vcpu, &state->nested);
+
+	if (!LOAD_REGS_BEFORE_NESTED)
+		vcpu_regs_set(vcpu, &state->regs);
 }
 
 void kvm_x86_state_cleanup(struct kvm_x86_state *state)
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 4bd1655f9e6d0..dfefd8eed392a 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
@@ -101,6 +101,7 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 		vmcb->control.next_rip = vmcb->save.rip;
 	}
 
+	GUEST_SYNC(true);
 	run_guest(vmcb, svm->vmcb_gpa);
 	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
 		       "Expected VMMCAL #VMEXIT, got '0x%lx', info1 = '0x%lx, info2 = '0x%lx'",
@@ -131,6 +132,7 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 	/* The return address pushed on stack, skip over UD2 */
 	vmcb->control.next_rip = vmcb->save.rip + 2;
 
+	GUEST_SYNC(true);
 	run_guest(vmcb, svm->vmcb_gpa);
 	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_HLT,
 		       "Expected HLT #VMEXIT, got '0x%lx', info1 = '0x%lx, info2 = '0x%lx'",
@@ -140,6 +142,24 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 	GUEST_DONE();
 }
 
+static struct kvm_vcpu *save_and_restore_vm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct kvm_x86_state *state = vcpu_save_state(vcpu);
+
+	kvm_vm_release(vm);
+	vcpu = vm_recreate_with_one_vcpu(vm);
+	vcpu_load_state(vcpu, state);
+	kvm_x86_state_cleanup(state);
+	return vcpu;
+}
+
+static bool is_nested_run_pending(struct kvm_vcpu *vcpu)
+{
+	struct kvm_x86_state *state = vcpu_save_state(vcpu);
+
+	return state->nested.size && (state->nested.flags & KVM_STATE_NESTED_RUN_PENDING);
+}
+
 static void run_test(bool is_nmi)
 {
 	struct kvm_vcpu *vcpu;
@@ -173,22 +193,44 @@ static void run_test(bool is_nmi)
 	memset(&debug, 0, sizeof(debug));
 	vcpu_guest_debug_set(vcpu, &debug);
 
-	struct ucall uc;
-
-	alarm(2);
-	vcpu_run(vcpu);
-	alarm(0);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-		break;
-		/* NOT REACHED */
-	case UCALL_DONE:
-		goto done;
-	default:
-		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+	for (;;) {
+		struct kvm_guest_debug debug;
+		struct ucall uc;
+
+		alarm(2);
+		vcpu_run(vcpu);
+		alarm(0);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * L1 syncs before calling run_guest(), single-step over
+			 * all instructions until VMRUN, and save+restore right
+			 * after it (before L2 actually runs).
+			 */
+			debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP;
+			vcpu_guest_debug_set(vcpu, &debug);
+
+			do {
+				vcpu_run(vcpu);
+				TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+			} while (!is_nested_run_pending(vcpu));
+
+			memset(&debug, 0, sizeof(debug));
+			vcpu_guest_debug_set(vcpu, &debug);
+			vcpu = save_and_restore_vm(vm, vcpu);
+			break;
+
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+			/* NOT REACHED */
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		}
 	}
 done:
 	kvm_vm_free(vm);
-- 
2.53.0.414.gf7e9f6c205-goog


