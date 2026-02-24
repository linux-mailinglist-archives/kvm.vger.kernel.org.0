Return-Path: <kvm+bounces-71684-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DCBIqEnnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71684-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:35:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 699FC18D66B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5A9A2306C190
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B61362138;
	Tue, 24 Feb 2026 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rKgAFSYC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530E361675;
	Tue, 24 Feb 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972464; cv=none; b=g+Tn1DwNRiWIaWlHFxLKpvPwKlB+RnaoULnvnvc4XEEsGrJ5ZQvTD3VaX055LKJtj1XLNXzpgyK36989S8Jco56QM/VpKs+Y7+F5yyx98Y+8nk6hYVN/4kJyb61uUXqx3nqWFmgafVSh2kaTgGXCtn0/GzxeDHEd1pEyA5tMEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972464; c=relaxed/simple;
	bh=09jqxGNj7+pt+3TIkV+wQfEzua56Gn/NW8yGD9b2J4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwmeHkiQ9c2nlZMDcGogMd/RiIVKUGvAVPs4Qbyex9ybeIbvaAkUF/kbCne5kfkBAu09Vvm1Y3Hx4XFWK84FfKWoNGBz8ZVimTHcqWq5kXAXyQ1zaT/NwilI4BVQdhrL4Me9ngtJIaYnAf2JtN9AbQXN9I4Q6tVAhheAJs0UDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rKgAFSYC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C305C2BC86;
	Tue, 24 Feb 2026 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972464;
	bh=09jqxGNj7+pt+3TIkV+wQfEzua56Gn/NW8yGD9b2J4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKgAFSYCio+7URovISk75T8ETV4xlv8cO4PdBcc+wyGRaPg45pL7N1KvU7GBhwCDe
	 PgSUmZ8+zSmV/IB3hEchPtvrXXdYxw4puLZHRIyHYlQgn7HJ+zZBWoCIxyd7OBrfGY
	 6VcSRMrTK4xmcNoIxnLfNJpAna+kKdrcL4c+POXI7Qd9GJyymNcK7yBXVtMWtV8/+c
	 MB/1LyNnwrX1kbA1gN7zAE8aXQsDxjnvNYum9EQvcOBQNNCodDJJ47axHUsXh5S4mb
	 ZBttZNaPHm5FicGtG3MhVt/eDI+1/rLJHBy7hTQ1y5K4hY1mT/77dCLeaZBfbvQxaa
	 ae+L9OYA1mmAw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 08/31] KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT
Date: Tue, 24 Feb 2026 22:33:42 +0000
Message-ID: <20260224223405.3270433-9-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71684-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 699FC18D66B
X-Rspamd-Action: no action

KVM currently injects a #GP and hopes for the best if mapping VMCB12
fails on nested #VMEXIT, and only if the failure mode is -EINVAL.
Mapping the VMCB12 could also fail if creating host mappings fails.

After the #GP is injected, nested_svm_vmexit() bails early, without
cleaning up (e.g. KVM_REQ_GET_NESTED_STATE_PAGES is set, is_guest_mode()
is true, etc).

Instead of optionally injecting a #GP, triple fault the guest if mapping
VMCB12 fails since KVM cannot make a sane recovery. The APM states that
a #VMEXIT will triple fault if host state is illegal or an exception
occurs while loading host state, so the behavior is not entirely made
up.

Do not return early from nested_svm_vmexit(), continue cleaning up the
vCPU state (e.g. switch back to vmcb01), to handle the failure as
gracefully as possible.

Fixes: cf74a78b229d ("KVM: SVM: Add VMEXIT handler and intercepts")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6364c52e6e0a8..280d0fccd1971 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1198,12 +1198,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	int rc;
 
-	rc = nested_svm_vmexit_update_vmcb12(vcpu);
-	if (rc) {
-		if (rc == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
+	if (nested_svm_vmexit_update_vmcb12(vcpu))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
-- 
2.53.0.414.gf7e9f6c205-goog


