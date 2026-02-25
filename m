Return-Path: <kvm+bounces-71719-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLPSEO5JnmnXUQQAu9opvQ
	(envelope-from <kvm+bounces-71719-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:01:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D8B18E7A7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:01:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2698930DCCCF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BFF2701B6;
	Wed, 25 Feb 2026 01:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qTnugetr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6214A2550D7;
	Wed, 25 Feb 2026 01:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981201; cv=none; b=iJuJSUjTLVzOT9UVmGB7Cdo+OyUSLLo/MQOH88AbJJ591b5dins1/nrP04pxHfE/d2wYrk1+eyOkuwW4VsawhJSbt8jr44cewKsyqBR5R6TVzkYKm4N/Y+wb/dvO1WdOU3dZ1Mwj0grc8a4Q9E57D0xYtb3i121kzpXmOTTw6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981201; c=relaxed/simple;
	bh=ie0AVX8TGkke+XKy2jolgP57NcWThLPLDLOV6InUL0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGVQeBjBQKXZOiREKxoDECOxEUZah9FlT8dwdGomTIsbMHza8F1I1qhAdnCuIEnVqMLU3CZf1xNjeb6alCL8hLuoziNmHQYJtniesR2GhqF8d+p8pcc0QB6UD3A/d8GLYoNkz3i2Z8opX4vtldPU9sooAB4P1xmsU8vwHn98mAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qTnugetr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002F8C2BC87;
	Wed, 25 Feb 2026 01:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771981201;
	bh=ie0AVX8TGkke+XKy2jolgP57NcWThLPLDLOV6InUL0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTnugetriAb/QH4dEyuAR8OPIVvJo6d/MTkLXarDoxna7Evrrkk12wtIqofZ3jugF
	 XZeyKKbdwVgVONsB6QWNfaZqrmroMcUmLlGiMVK25wcEYCJ+p4cm02p79mD/NgLtTU
	 IDB1DS6PBPDRUR1d9Flgz9WasHSrhRfxEXxBpXF3nVL0jytYdbbd7H6YOEYEKHx/WA
	 0tDnDf0JrKoglidQcy7AQaYyZNYHHPhWeE4X6dhXkOp2hCNMcIfrwi/6UM1zc4iAj1
	 gOCEytmKgg6jTP+dQqluGJGKqZ0EdBzmYbnvjvgkUOjpgS0lRxW8hIfpFhj+8mvorn
	 3jd5/KdbgYJeg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 3/8] KVM: selftests: Extend state_test to check vGIF
Date: Wed, 25 Feb 2026 00:59:45 +0000
Message-ID: <20260225005950.3739782-4-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71719-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B5D8B18E7A7
X-Rspamd-Action: no action

V_GIF_MASK is one of the fields written by the CPU after VMRUN, and
sync'd by KVM from vmcb02 to cached vmcb12 after running L2. Part of the
reason is to make sure V_GIF_MASK is saved/restored correctly, as the
cached vmcb12 is the payload of nested state.

Verify that V_GIF_MASK is saved/restored correctly in state_test by
enabling vGIF in vmcb12, toggling GIF in L2 at different GUEST_SYNC()
points, and verifying that V_GIF_MASK is correctly propagated to the
nested state.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 tools/testing/selftests/kvm/x86/state_test.c | 24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index f2c7a1c297e37..57c7546f3d7c5 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -26,7 +26,9 @@ void svm_l2_guest_code(void)
 	GUEST_SYNC(4);
 	/* Exit to L1 */
 	vmcall();
+	clgi();
 	GUEST_SYNC(6);
+	stgi();
 	/* Done, exit to L1 and never come back.  */
 	vmcall();
 }
@@ -41,6 +43,8 @@ static void svm_l1_guest_code(struct svm_test_data *svm)
 	generic_svm_setup(svm, svm_l2_guest_code,
 			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
+	vmcb->control.int_ctl |= (V_GIF_ENABLE_MASK | V_GIF_MASK);
+
 	GUEST_SYNC(3);
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
@@ -222,6 +226,24 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 	GUEST_DONE();
 }
 
+void svm_check_nested_state(int stage, struct kvm_x86_state *state)
+{
+	struct vmcb *vmcb = (struct vmcb *)state->nested.data.svm;
+
+	if (kvm_cpu_has(X86_FEATURE_VGIF)) {
+		if (stage == 4)
+			TEST_ASSERT_EQ(!!(vmcb->control.int_ctl & V_GIF_MASK), 1);
+		if (stage == 6)
+			TEST_ASSERT_EQ(!!(vmcb->control.int_ctl & V_GIF_MASK), 0);
+	}
+}
+
+void check_nested_state(int stage, struct kvm_x86_state *state)
+{
+	if (kvm_has_cap(KVM_CAP_NESTED_STATE) && kvm_cpu_has(X86_FEATURE_SVM))
+		svm_check_nested_state(stage, state);
+}
+
 int main(int argc, char *argv[])
 {
 	uint64_t *xstate_bv, saved_xstate_bv;
@@ -278,6 +300,8 @@ int main(int argc, char *argv[])
 
 		kvm_vm_release(vm);
 
+		check_nested_state(stage, state);
+
 		/* Restore state in a new VM.  */
 		vcpu = vm_recreate_with_one_vcpu(vm);
 		vcpu_load_state(vcpu, state);
-- 
2.53.0.414.gf7e9f6c205-goog


