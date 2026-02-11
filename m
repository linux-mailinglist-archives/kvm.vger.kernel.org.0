Return-Path: <kvm+bounces-70876-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO4fJ/6ujGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70876-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:31:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2305B126247
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05F5B3090212
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDD7344D84;
	Wed, 11 Feb 2026 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ge4nM4iq"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4910234402D
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827355; cv=none; b=H/h/puQwpIBI0NH0iFkdEJualO4hqziCh1G/0Gjr3/qWYdFM77W7k81Bk7/pdp1c8XIbxG9/vzJrmFJHFKrMOfp6r252Dpgdyb9c71Bwdf+VxVT4XT21f9Cq3KFaUt5pCfsDjwqxMqdEAmv78ktvs3aeyDJdB4+ttHGWwR6juWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827355; c=relaxed/simple;
	bh=JQWwyvFcxCw9codsXvucZKYe/vNO0xvYDKNARMSJ61Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFk7272PUScnoe+UtgKvFR9XGtu2mfnOompEiBgf1hrEl4sFC104ywyd+J7sIekjO9TLl18MzpRm0VllFLMO6VHUIRrsovNIP2Fa6qhGZ+RxbU7WuWRMhaWzSlBMfesYO5Qsn7BGVhs3XK6RT3yCA8q/iSQRGDQdgNoxGsEbVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ge4nM4iq; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770827352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IAHA1BoR9Ww40qGSdofKCW6ZALBTizq0Cah0BSADaW4=;
	b=Ge4nM4iqICA2l8ZV43Do6Ey+gRQjSyJutZYlR0G/WJHNwBDfkWMSvWiN+xZtMREl175h8H
	0wTmZ2MLT0O2xXVKbGm24K53IgSptO8hWROXethlO6pgEJJAvojz86SYKFD3eWicvDIYFx
	GktqIAVQF5tIzM8NP0OpQiJYZILxUiM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 4/5] KVM: selftests: Extend state_test to check vGIF
Date: Wed, 11 Feb 2026 16:28:41 +0000
Message-ID: <20260211162842.454151-5-yosry.ahmed@linux.dev>
In-Reply-To: <20260211162842.454151-1-yosry.ahmed@linux.dev>
References: <20260211162842.454151-1-yosry.ahmed@linux.dev>
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
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70876-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 2305B126247
X-Rspamd-Action: no action

V_GIF_MASK is one of the fields written by the CPU after VMRUN, and
sync'd by KVM from vmcb02 to cached vmcb12 after running L2. Part of the
reason is to make sure V_GIF_MASK is saved/restored correctly, as the
cached vmcb12 is the payload of nested state.

Verify that V_GIF_MASK is saved/restored correctly in state_test by
enabling vGIF in vmcb12, toggling GIF in L2 at different GUEST_SYNC()
points, and verifying that V_GIF_MASK is correctly propagated to the
nested state.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/state_test.c | 24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index f2c7a1c297e3..57c7546f3d7c 100644
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
2.53.0.239.g8d8fc8a987-goog


