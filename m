Return-Path: <kvm+bounces-73164-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANf2E4ZCq2nJbgEAu9opvQ
	(envelope-from <kvm+bounces-73164-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE9B227B8F
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CADD304115D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93601481FDE;
	Fri,  6 Mar 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msS/vTXy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0755481FA0;
	Fri,  6 Mar 2026 21:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772831351; cv=none; b=XSRR5W1CslxBQfuFCBfKsuo5jLSPEl+6h6JcGnlldh7dpaGp1sw0caBbON6cjIDWInAHduFuI1ryvprF0h1HZGqsmspKyryekv0CMyiN2hAeoWRZMXmcu4eA6sx+8WTHUEkKs4KiNJUQguNk1ezh8RLd2M99n1huEWdoqGxS19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772831351; c=relaxed/simple;
	bh=zlFgROWLnxVwC4QoyF8FYkdqnZDZOTfxmemo5hzE2nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8Y3AOIkgl5T8TJkRzpUETZf3aWTV9mJvAEsRZd8ueWP/WI6Fdch0ZpGU0SeP+k1+s5Fa8+imrtEV9jlfWsHQ3R0nSYsNRAfjuMYQAkvNdtPEdk/aEQceAsp6DqDEQZeWAqjwa/9tPaLfoZf09xCG8FiG4FFdtbrtCkYiye5ymQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msS/vTXy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65091C4CEF7;
	Fri,  6 Mar 2026 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772831351;
	bh=zlFgROWLnxVwC4QoyF8FYkdqnZDZOTfxmemo5hzE2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msS/vTXy4vrAatHVDXTNfTlDGkIePu0rWzonK+un3oboazCH4K0BjDCqwDG42rFgg
	 kbRGO+Z6uwHka6urunH6r2Ofu60D7ODtGzmVRhJgqohILp43ZZU3wNBYKR4dtysufQ
	 5i4oGv2mVcY7kz0l5/uXo7PPdtTafg/fLlQNcquSKza24EtERq2l0WRpPtSu2iedZ/
	 co25pPLrJLwFX7gmEflhZi7ctL2l+jrLyqIqw13fYSVp3UErBQgH1wzDRjyt42A4p0
	 r9wZQeTMrh7786NS6e6Hd4SpKqUFbKFCjbHJP8XfJf3INOqsWg6zaeab8bM8dcqOqX
	 oIShVRYo+NWng==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 2/6] KVM: nSVM: Simplify error handling of nested_svm_copy_vmcb12_to_cache()
Date: Fri,  6 Mar 2026 21:08:56 +0000
Message-ID: <20260306210900.1933788-3-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260306210900.1933788-1-yosry@kernel.org>
References: <20260306210900.1933788-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDE9B227B8F
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
	TAGGED_FROM(0.00)[bounces-73164-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.982];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

nested_svm_vmrun() currently stores the return value of
nested_svm_copy_vmcb12_to_cache() in a local variable 'err', separate
from the generally used 'ret' variable. This is done to have a single
call to kvm_skip_emulated_instruction(), such that we can store the
return value of kvm_skip_emulated_instruction() in 'ret', and then
re-check the return value of nested_svm_copy_vmcb12_to_cache() in 'err'.

The code is unnecessarily confusing. Instead, call
kvm_skip_emulated_instruction() in the failure path of
nested_svm_copy_vmcb12_to_cache() if the return value is not -EFAULT,
and drop 'err'.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b191c6cab57db..6d4c053778b21 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1079,7 +1079,7 @@ static int nested_svm_copy_vmcb12_to_cache(struct kvm_vcpu *vcpu, u64 vmcb12_gpa
 int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int ret, err;
+	int ret;
 	u64 vmcb12_gpa;
 	struct vmcb *vmcb01 = svm->vmcb01.ptr;
 
@@ -1104,19 +1104,20 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	err = nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
-	if (err == -EFAULT) {
+	ret = nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
+
+	/*
+	 * Advance RIP if #GP or #UD are not injected, but otherwise
+	 * stop if copying and checking vmcb12 failed.
+	 */
+	if (ret == -EFAULT) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
+	} else if (ret) {
+		return kvm_skip_emulated_instruction(vcpu);
 	}
 
-	/*
-	 * Advance RIP if #GP or #UD are not injected, but otherwise stop if
-	 * copying and checking vmcb12 failed.
-	 */
 	ret = kvm_skip_emulated_instruction(vcpu);
-	if (err)
-		return ret;
 
 	/*
 	 * Since vmcb01 is not in use, we can use it to store some of the L1
-- 
2.53.0.473.g4a7958ca14-goog


