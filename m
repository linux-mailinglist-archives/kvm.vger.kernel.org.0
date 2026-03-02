Return-Path: <kvm+bounces-72392-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBSgOHSxpWk8EgAAu9opvQ
	(envelope-from <kvm+bounces-72392-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:49:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4B71DC283
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D07D2307F9AB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9627411628;
	Mon,  2 Mar 2026 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVapTgy8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92C1A2C0B;
	Mon,  2 Mar 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466212; cv=none; b=TxfDE1vLBEP02EE7rzLlr1jPgpEhHuIirTm4gO4tC9HKvJkk1bU3SX2TCuVi2U/oWaxjUu1bUS+u9Y8Tp0baybxYhvMurflFaw0FAu+QWPpICYsXsZDggcqm7am6+PKFfSdOHDmxYQvojijGJRLWclLaUk0d5RYtcvU6hNYbv8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466212; c=relaxed/simple;
	bh=BRe7At9WvNHmpVJLo9/EsBeq7CyAy2K9i5SpxPRKlvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KwNmf049OgCxXY0LO9mJmzaAhMRzBdD+aWrV8W0I45uLwLtyp8YM4hNwv8Pgt+qF0FK7o88lVI0niVOgUDMN8iYAxCTv3pjmRfNewCmm02gzNNLoBrLm/hLhveavMUvzLjdnhELpSawbjJJmN7OlZi5HcD5psDvcbr0hOOVF+KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVapTgy8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE72C19423;
	Mon,  2 Mar 2026 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772466212;
	bh=BRe7At9WvNHmpVJLo9/EsBeq7CyAy2K9i5SpxPRKlvY=;
	h=From:To:Cc:Subject:Date:From;
	b=NVapTgy8nkUYrNufw4ANp/xtU+x9h35sbUNi5NnHqJgJP6vwgSpNtWJ3sP56Yqr/r
	 J1KgOvVMs48rcBFJAET9mh3LCH5wxC6VvIRrlwocW1HMVHlSpNEuKhK8lj0hDCcFlr
	 OulHwm1ZUwIxP+pBme7ppYRrHPCHkCti/5XjFJu/HeUjP82B6F5CckqVeBk01U3rLu
	 wblW9pB0qJjFrkz91XWLP7E+OeZoeN6dB7szVgyhj9+XVG3k1AbhWjaHdtctWfqbyH
	 zSDUusMev6ZNHTB96RejvSJRLaRu/eT/nFPsMazNZa4g2nhWMNQjT/0/Je4QbG5wUn
	 IEPxYyoFGCw0A==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH] KVM: x86: Drop redundant call to kvm_deliver_exception_payload()
Date: Mon,  2 Mar 2026 15:42:49 +0000
Message-ID: <20260302154249.784529-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B4B71DC283
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
	TAGGED_FROM(0.00)[bounces-72392-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

In kvm_check_and_inject_events(), kvm_deliver_exception_payload() is
called for pending #DB exceptions. However, shortly after, the
per-vendor inject_exception callbacks are made. Both
vmx_inject_exception() and svm_inject_exception() unconditionally call
kvm_deliver_exception_payload(), so the call in
kvm_check_and_inject_events() is redundant.

Note that the extra call for pending #DB exceptions is harmless, as
kvm_deliver_exception_payload() clears exception.has_payload after the
first call.

The call in kvm_check_and_inject_events() was added in commit
f10c729ff965 ("kvm: vmx: Defer setting of DR6 until #DB delivery"). At
that point, the call was likely needed because svm_queue_exception()
checked whether an exception for L2 is intercepted by L1 before calling
kvm_deliver_exception_payload(), as SVM did not have a
check_nested_events callback. Since DR6 is updated before the #DB
intercept in SVM (unlike VMX), it was necessary to deliver the DR6
payload before calling svm_queue_exception().

After that, commit 7c86663b68ba ("KVM: nSVM: inject exceptions via
svm_check_nested_events") added a check_nested_events callback for SVM,
which checked for L1 intercepts for L2's exceptions, and delivered the
the payload appropriately before the intercept. At that point,
svm_queue_exception() started calling kvm_deliver_exception_payload()
unconditionally, and the call to kvm_deliver_exception_payload() from
its caller became redundant.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/x86.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d94..a9080418f3cfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10737,12 +10737,10 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
 
-		if (vcpu->arch.exception.vector == DB_VECTOR) {
-			kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
-			if (vcpu->arch.dr7 & DR7_GD) {
-				vcpu->arch.dr7 &= ~DR7_GD;
-				kvm_update_dr7(vcpu);
-			}
+		if (vcpu->arch.exception.vector == DB_VECTOR &&
+		    vcpu->arch.dr7 & DR7_GD) {
+			vcpu->arch.dr7 &= ~DR7_GD;
+			kvm_update_dr7(vcpu);
 		}
 
 		kvm_inject_exception(vcpu);

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.473.g4a7958ca14-goog


