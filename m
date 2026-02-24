Return-Path: <kvm+bounces-71689-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEyeFpUonmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71689-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:39:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C644A18D79D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 049DF30E66E8
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12570364EBF;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1Usk6gg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6139363C59;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972467; cv=none; b=Oqj0oXHL/xW3DvyDXjDQntRoM5dkkxzoXcWQ36DXNMRQ4X2S50ua4gjjocklwRLzAB/BfEL5xSxy6VLqoS/YHqV39N3xsDTXy1lNqKn9xFchEI8DLu760FxYT2cDCeRqUAq+B7LbzuD3momdB60KkkAC7/bAZqUfnGxWL/EG8xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972467; c=relaxed/simple;
	bh=v3k1XuVOPyc0D6iXWZn2WZUJVDAowvvqRBuCr8T4O2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2UOKk5Zao2zB1Zx9dSN5gaF54U4TRZcGQE5jaLPdcY89cIK756Jwc8j6a8ZOhUfeodf8foBnYVcEcyDUv1Yj9DoOwlpxpEjLF+Or4uxUDUV4pRLFuZEuoX1nlOPqvOLMxnl6e85+3+SJZ25gb7Ohp77XNIb2mdf6NmQqvt9H+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1Usk6gg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC16C2BC86;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972466;
	bh=v3k1XuVOPyc0D6iXWZn2WZUJVDAowvvqRBuCr8T4O2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1Usk6gg8O30iusrKx3oyvCjQZemZU0lSL8Updf3YF0fq0rtl4iJjzPKiTN9rbwp7
	 V6twI3Fho2UGRAkcqnGh/dqWNbstwBdGbPVIHezX3VNGSAyPPo/QNRL4mAZmDHBEIW
	 bu3KUpQbzhMMbFkKMvXjWSb+myxHmAJlfDsrrqysPIAT5q+asl16xha73UdWcLMrDI
	 Cjs4i3S9TzIV0d3eEYdlVxqN1SOeI9yCHs1tQl9JAXNChuyn6zE1umUAUcnYjzJqox
	 /wyf+5Lv/LliWBmu2lm/JsaY28CGkKqOAG9rMBv7kni2fbQdoHChzcJ4RsIs989LT9
	 IFsl6T35h0MjQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 13/31] KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
Date: Tue, 24 Feb 2026 22:33:47 +0000
Message-ID: <20260224223405.3270433-14-yosry@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-71689-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C644A18D79D
X-Rspamd-Action: no action

In preparation for unifying the VMRUN failure code paths, move calling
nested_svm_merge_msrpm() into enter_svm_guest_mode() next to the
nested_svm_load_cr3() call (the other failure path in
enter_svm_guest_mode()).

Adding more uses of the from_vmrun parameter is not pretty, but it is
plumbed all the way to nested_svm_load_cr3() so it's not going away soon
anyway.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 78caa75fe619a..5276e41605d43 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -961,6 +961,12 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
+	if (from_vmrun) {
+		ret = nested_svm_merge_msrpm(vcpu);
+		if (ret)
+			return ret;
+	}
+
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1039,22 +1045,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
-		goto out_exit_err;
-
-	if (!nested_svm_merge_msrpm(vcpu))
-		goto out;
-
-out_exit_err:
-	svm->nested.nested_run_pending = 0;
-	svm->nmi_l1_to_l2 = false;
-	svm->soft_int_injected = false;
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true)) {
+		svm->nested.nested_run_pending = 0;
+		svm->nmi_l1_to_l2 = false;
+		svm->soft_int_injected = false;
 
-	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-	svm->vmcb->control.exit_info_1  = 0;
-	svm->vmcb->control.exit_info_2  = 0;
+		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+		svm->vmcb->control.exit_info_1  = 0;
+		svm->vmcb->control.exit_info_2  = 0;
 
-	nested_svm_vmexit(svm);
+		nested_svm_vmexit(svm);
+	}
 
 out:
 	kvm_vcpu_unmap(vcpu, &map);
-- 
2.53.0.414.gf7e9f6c205-goog


