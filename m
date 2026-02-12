Return-Path: <kvm+bounces-71024-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHaFCzdejmmdBwEAu9opvQ
	(envelope-from <kvm+bounces-71024-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:11:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9AF131AD5
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 00:11:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4DF631CCD34
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0E5338936;
	Thu, 12 Feb 2026 23:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m2ge7CAD"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB735E553
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 23:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770937713; cv=none; b=GBAo9GjsPlX3VjmxvXNeRrnfZ6DAJAI0wjJI8yVHgfmA/WsVEuL8+YNYFyEF893QnQzRejmmsiIo9P6wYrTpWBuX56Q4DY6sIBsoyl1sO5XQ4HvBavz5LxwzDL4VVc3PqUBVTds/VdrWSCFS557Jryxxhjmn/nMIGV5mghb+SNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770937713; c=relaxed/simple;
	bh=bAOaJdOA04AkQxS17TJBTKFOnGSDb1vT1i6dJxSl2nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMEBYQGfThvSV4qHSZASSg/P30qKHR0ZCEMDOZYevcU/hZzcNBqT5G5xbPKk46Npwi7RU47ufvH5/vTGCXREyiiJ/9gUHGpwJKJKcC1+vI3gytqwCJEW9Vw/PkyvvYchP9n+EMfOVu1bvahj48izh23e2s71TdTGJp38OirNfkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m2ge7CAD; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770937704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xv3/xFFAZoY8Sit0MX/CbnOjm9pEWm9G+ntyH+it1HQ=;
	b=m2ge7CADwE8J8TFiGy/AGC7xyp/ExrzJvwKT0sGyjjpZsBBI0nzZWmA8eHVxadU0xR8R1J
	lSsYeG/39iO2W4/O0QtJwfGwJqjtoSnSN1YwTysAxheQtBKNfWic7PSa8eyiJJ3p4wWTG1
	GJJWWYso5N7wRV3x9Jb5YqzQhI2462M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 5/5] DO NOT MERGE: KVM: selftests: Reproduce nested RIP restore bug
Date: Thu, 12 Feb 2026 23:07:51 +0000
Message-ID: <20260212230751.1871720-6-yosry.ahmed@linux.dev>
In-Reply-To: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
References: <20260212230751.1871720-1-yosry.ahmed@linux.dev>
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
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71024-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8B9AF131AD5
X-Rspamd-Action: no action

Update svm_nested_soft_inject_test such that L1 syncs to userspace
before running L2. The test then enables single-stepping and steps
through guest code until VMRUN is execute, and saves/restores the VM
immediately after (before L2 runs).

This reproduces a bug in save/restore where L2's RIP is not used
correctly to construct the vmcb02 at the destination.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../testing/selftests/kvm/lib/x86/processor.c |  3 +
 .../kvm/x86/svm_nested_soft_inject_test.c     | 74 +++++++++++++++----
 2 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index fab18e9be66c..3e8d516ec8d3 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1291,6 +1291,9 @@ void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state)
 
 	if (state->nested.size)
 		vcpu_nested_state_set(vcpu, &state->nested);
+
+	/* Switch between this and the call above */
+	// vcpu_regs_set(vcpu, &state->regs);
 }
 
 void kvm_x86_state_cleanup(struct kvm_x86_state *state)
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 4bd1655f9e6d..dfefd8eed392 100644
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
2.53.0.273.g2a3d683680-goog


