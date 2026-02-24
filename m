Return-Path: <kvm+bounces-71693-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKscAeconmk7TwQAu9opvQ
	(envelope-from <kvm+bounces-71693-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A218818D877
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6DB5303B962
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813C036EAA3;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyov+M/b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6952B366823;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972468; cv=none; b=bV53ibQ1DSKgDxZIUkqMgcN+lAn56wF8nhv7nh3ZNnul8/M/izzxz4THivvh/ila7cWFPe0FZWmqH38n//3nAQAPk0pcWC+9yCO1+t49ManYNtsbJwSj7g0Hunc1RFeTN0Y8sC4SBqZCJsSfoJmAKKkQnq8OY678pEH4Oj+rLeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972468; c=relaxed/simple;
	bh=/pn0CYze4ws752rwcsq4J0RXY1UHXEv744XlprrqCGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DugK4vkCs0ttY8q7AcJMkwUfPW138is0ZyCqL7f2742Lo70zmYC2EtIkeVB9yjYkURC+/2tFc1jp++33IuzExqq7SU3lBB7lq+IOZNIqMmjsc5Hcstra07mZ3iI+saaMVkSidqn7b6pFXy/5sJ6IH9L2Gqotv12AMjhm2pjD8FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyov+M/b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1069BC19424;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972468;
	bh=/pn0CYze4ws752rwcsq4J0RXY1UHXEv744XlprrqCGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyov+M/bxZb4D7HJdWCVXlxc+MfMsgJTwOyiWTLLW1KGOuH73HC3iDBQEwCvEiiwA
	 qlXPqkRWYoOAFdalsOhB5Xpy5PRJiVQ9sSfgpDvSFN62WyXzRfUZHFJOnmtn8acxSX
	 5cxngxZ3Kw/5kcDjQF5iFyfaOi0nNWnD4oQ8EUJB2/+5MuLfOpmTZCKFrZyJdP3T8c
	 i2Cil9XTqs8YtWc1dvF1j/T9eQg8EZe2ml58SO2n31YIuBwKezVPYKfGUxi0qmTIj1
	 m6uyP1F7uQff4iRSNaWFpwOcL8OiPlN2YymU468SjLDXfvFuXprxyTAHEX8fMYnHFl
	 UbbuVFINVHsNg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 17/31] KVM: nSVM: Clear EVENTINJ field in VMCB12 on nested #VMEXIT
Date: Tue, 24 Feb 2026 22:33:51 +0000
Message-ID: <20260224223405.3270433-18-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71693-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A218818D877
X-Rspamd-Action: no action

According to the APM, from the reference of the VMRUN instruction:

	Upon #VMEXIT, the processor performs the following actions in
	order to return to the host execution context:
	...
	clear EVENTINJ field in VMCB

KVM correctly cleared EVENTINJ (i.e. event_inj and event_inj_err) on
nested #VMEXIT before commit 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB
controls updated by the processor on every vmexit"). That commit made
sure the fields are synchronized between VMCB02 and KVM's cached VMCB12
on every L2->L0 #VMEXIT, such that they are serialized correctly on
save/restore.

However, the commit also incorrectly copied the fields from KVM's cached
VMCB12 to L1's VMCB12 on nested #VMEXIT. This is mostly correct, as the
fields will be zeroed by the CPU, but it doesn't handle a #VMEXIT due to
an invalid VMRUN. Explicitly clear the fields all nested #VMEXIT code
paths.

Fixes: 2d8a42be0e2b ("KVM: nSVM: synchronize VMCB controls updated by the processor on every vmexit")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2c5878cbb3940..dd95c6434403f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1027,6 +1027,8 @@ static void nested_svm_vmrun_error_vmexit(struct kvm_vcpu *vcpu, struct vmcb *vm
 	vmcb12->control.exit_code = SVM_EXIT_ERR;
 	vmcb12->control.exit_info_1 = 0;
 	vmcb12->control.exit_info_2 = 0;
+	vmcb12->control.event_inj = 0;
+	vmcb12->control.event_inj_err = 0;
 	__nested_svm_vmexit(svm);
 }
 
@@ -1199,9 +1201,9 @@ static int nested_svm_vmexit_update_vmcb12(struct kvm_vcpu *vcpu)
 	if (nested_vmcb12_has_lbrv(vcpu))
 		svm_copy_lbrs(&vmcb12->save, &vmcb02->save);
 
+	vmcb12->control.event_inj	  = 0;
+	vmcb12->control.event_inj_err	  = 0;
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
-	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
-	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	trace_kvm_nested_vmexit_inject(vmcb12->control.exit_code,
 				       vmcb12->control.exit_info_1,
-- 
2.53.0.414.gf7e9f6c205-goog


