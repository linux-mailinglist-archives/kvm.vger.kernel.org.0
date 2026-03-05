Return-Path: <kvm+bounces-72952-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKI9LQfoqWnuHQEAu9opvQ
	(envelope-from <kvm+bounces-72952-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:31:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4B92182BD
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 21:31:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AF278303BA73
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 20:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DAF33B6F6;
	Thu,  5 Mar 2026 20:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dU4JRJpE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63C133A9FF;
	Thu,  5 Mar 2026 20:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772742626; cv=none; b=uXp7cgyYEhF1wSZOIjd5t+bXfOJD5u7Yc5jnYiZXsuS+U6Pw0HSHmeJcJRzvgUDBXX7PK4PrIb4YYgmaQLQiMAkE27HTtcPK6iPsalrx0z9ZW98u8k3gkwIhDbLBWb5EUjo0mf2MjnZim4ckcua5w6O7K6LJfY3rrA+eac5hUMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772742626; c=relaxed/simple;
	bh=czB0idmCQXOwrXDrOdJ3Ftkm+nhGFiwI7nJsQQe6uEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfdXt6HR0xuTZtFwsADPehPCcmN2ZH3Dh7+2vD5mZ71o1AXcbuDP2GSpe616YyvLQkAbHbpjrdYpe+NWWQ7+aQqkxatxFrGMWevzpy6E269Sbr0m7YmD83yaUpuvgwKb6vw0+G7wRW/nz/qRq0NwsLjinLddehQfQkNtzLceKFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dU4JRJpE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4283EC2BCAF;
	Thu,  5 Mar 2026 20:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772742625;
	bh=czB0idmCQXOwrXDrOdJ3Ftkm+nhGFiwI7nJsQQe6uEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU4JRJpEmznYO4h51LQ6mRt11jH/zAgZw9dpEOh3846V0HrRyYqi2qMNK4ou86ztt
	 OlBKd6Jg2FhGqRf3WYG/H0ZCHsLIWV7NcZzBtNzu2B8kbNw0dZassHvbN/GPzgAjv/
	 fcmZVL/TwVLoZlqWCEHUQPfM5W/SsqBKEYeuOsxA3eisuDe2gLOOjoT/gn/qVXNG8b
	 fRHzaw5GJziikvOOZBwKgWNX8n7xRT3EdONRkQQf9U/OomOV4xU4KcXVuUS4FGWa3J
	 ZRCHMuO3oQeaPMVH0q/CvycqRSP6hDCQLmETe3d5S9hohOtlSaTxdMajPaiza4ZYDY
	 OswaO6ygZFlgg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 2/2] KVM: selftests: Actually check #GP on VMRUN with invalid vmcb12
Date: Thu,  5 Mar 2026 20:30:05 +0000
Message-ID: <20260305203005.1021335-3-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260305203005.1021335-1-yosry@kernel.org>
References: <20260305203005.1021335-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F4B92182BD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72952-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

in svm_nested_invalid_vmcb12_gpa test, run_guest() is called with an
unmappable vmcb12 GPA to make sure KVM injects a #GP. However,
run_guest() executes VMLOAD first, so the #GP does not actually come
from the VMRUN handler.

Execute VMRUN directly from L1 code with the invalid GPA instead of
calling into run_guest(), and have the #GP handler skip over it (instead
of fixing up the VMCBA GPA). A separate run_guest() call is then done
for the remaining test cases. Also assert that #GP happened on VMRUN to
avoid falling into the same problem.

Opportunisitically drop the GUEST_SYNC() from the #GP handler, as L1
already asserts gp_triggered is 1.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 .../kvm/x86/svm_nested_invalid_vmcb12_gpa.c   | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
index c6d5f712120d1..8b681796b48ef 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_invalid_vmcb12_gpa.c
@@ -10,23 +10,25 @@
 
 #define L2_GUEST_STACK_SIZE 64
 
-#define SYNC_GP 101
-#define SYNC_L2_STARTED 102
+#define VMRUN_OPCODE 0x000f01d8
 
-u64 valid_vmcb12_gpa;
 int gp_triggered;
 
 static void guest_gp_handler(struct ex_regs *regs)
 {
+	unsigned char *insn = (unsigned char *)regs->rip;
+	u32 opcode = (insn[0] << 16) | (insn[1] << 8) | insn[2];
+
+	GUEST_ASSERT_EQ(opcode, VMRUN_OPCODE);
 	GUEST_ASSERT(!gp_triggered);
-	GUEST_SYNC(SYNC_GP);
+
 	gp_triggered = 1;
-	regs->rax = valid_vmcb12_gpa;
+	regs->rip += 3; /* Skip over VMRUN */
 }
 
 static void l2_guest_code(void)
 {
-	GUEST_SYNC(SYNC_L2_STARTED);
+	GUEST_SYNC(1);
 	vmcall();
 }
 
@@ -37,11 +39,12 @@ static void l1_guest_code(struct svm_test_data *svm, u64 invalid_vmcb12_gpa)
 	generic_svm_setup(svm, l2_guest_code,
 			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	valid_vmcb12_gpa = svm->vmcb_gpa;
+	asm volatile ("vmrun %[invalid_vmcb12_gpa]" :
+		      : [invalid_vmcb12_gpa] "a" (invalid_vmcb12_gpa)
+		      : "memory");
+	GUEST_ASSERT_EQ(gp_triggered, 1);
 
-	run_guest(svm->vmcb, invalid_vmcb12_gpa); /* #GP */
-
-	/* GP handler should jump here */
+	run_guest(svm->vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
@@ -70,12 +73,6 @@ int main(int argc, char *argv[])
 	vcpu_alloc_svm(vm, &nested_gva);
 	vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
 
-	/* VMRUN with max_legal_gpa, KVM injects a #GP */
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
-	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
-	TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
-
 	/*
 	 * Enter L2 (with a legit vmcb12 GPA), then overwrite vmcb12 GPA with
 	 * max_legal_gpa. KVM will fail to map vmcb12 on nested VM-Exit and
@@ -84,7 +81,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
-	TEST_ASSERT_EQ(uc.args[1], SYNC_L2_STARTED);
+	TEST_ASSERT_EQ(uc.args[1], 1);
 
 	state = vcpu_save_state(vcpu);
 	state->nested.hdr.svm.vmcb_pa = max_legal_gpa;
-- 
2.53.0.473.g4a7958ca14-goog


