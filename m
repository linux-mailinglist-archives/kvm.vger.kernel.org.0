Return-Path: <kvm+bounces-72460-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPxnE0ItpmkQLwAAu9opvQ
	(envelope-from <kvm+bounces-72460-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:37:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA96C1E732D
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7CEE31081EE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87562282F3C;
	Tue,  3 Mar 2026 00:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWS4FnHg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B6248861;
	Tue,  3 Mar 2026 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498073; cv=none; b=pMYLqG8oU+uiYINy3BBmi9cZdSZOnUNVpvPdRqKjgy/Kick/yHgLeC1itCi09XC5cNTsKKLhrxbGt2xJ2Bydx/Jj4tmkUp6lATjkCaLW6TECOW6D5HnY5jSJAYTDTtcIW54OFxE16ieKimByAmZJC0OR3m4sI9jYVqrnqN1tXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498073; c=relaxed/simple;
	bh=f5x63EWl9Ak0ynSIx2o+WVCZCa048niPnvi+1XUeCCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mweDhlMP/UlUr1hNhxMHY8BswPvc1oNhNPzj1vgP2dgqkd37dfbXrGPb9PWBtNQ10zO9TO2ORPGuh4QxyprnTl9EVVu4T3ReuZ9tJZ6WYCdrx2VsbIqjjsZFtGpAryI42USxhu2CDElgBCAq8WmpgOYpt70Yfy1+Sq9r4RCEiY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWS4FnHg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9B7C2BCB2;
	Tue,  3 Mar 2026 00:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498073;
	bh=f5x63EWl9Ak0ynSIx2o+WVCZCa048niPnvi+1XUeCCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWS4FnHgln9XDzgMfLOIFRGNJTsuEjCWkTXmc8i7xz+If/GTEWEAxs1MMzFLfnzg9
	 7w0s5lrouxgCAOHOAOU3gyBUApDO7BT63T7Ne3HEcoH3DSXOoSYN3G2qtH3DLXUuUE
	 UhqsJD7jVctmsssWLsiFYFAe7MF+sR7otqAhuJ3k1UxSisTzP6ZnWPCLy6dabQw1u6
	 j3yMQcuq5jXCU1TimL9M2UIiX0wsqFGExRMmxYMbBz/UOlAHnGQ211O6xLUUUDb0It
	 um1zp2UiJYmi6FpE0TCN2XNdjzWvoHxuo17boVbsx9S6/Vm7YI0qgBtRMJpQu67B1b
	 IBhQEiA9XvFdA==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 05/26] KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN
Date: Tue,  3 Mar 2026 00:33:59 +0000
Message-ID: <20260303003421.2185681-6-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA96C1E732D
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
	TAGGED_FROM(0.00)[bounces-72460-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

nested_svm_vmrun() currently only injects a #GP if kvm_vcpu_map() fails
with -EINVAL. But it could also fail with -EFAULT if creating a host
mapping failed. Inject a #GP in all cases, no reason to treat failure
modes differently.

Fixes: 8c5fbf1a7231 ("KVM/nSVM: Use the new mapping API for mapping guest memory")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3bf758c9cb85c..25f769a0d9a0d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1011,12 +1011,9 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	}
 
 	vmcb12_gpa = svm->vmcb->save.rax;
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
-	if (ret == -EINVAL) {
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
-	} else if (ret) {
-		return kvm_skip_emulated_instruction(vcpu);
 	}
 
 	ret = kvm_skip_emulated_instruction(vcpu);
-- 
2.53.0.473.g4a7958ca14-goog


