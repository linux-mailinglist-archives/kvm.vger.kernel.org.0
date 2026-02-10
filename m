Return-Path: <kvm+bounces-70686-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMoVFxmFimnoLQAAu9opvQ
	(envelope-from <kvm+bounces-70686-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:08:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C1E115EB9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 737AE302866F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC926A1AC;
	Tue, 10 Feb 2026 01:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tfLppn6F"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE5221F15
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770685713; cv=none; b=XvfiCbZuXdptelWHF6ByiwH6X0IO7O8QMtk3BD9QdIRN2kLVD0+OazVLA3DOnQYbmCfiwIz54CLmiW8a7jubu+abIODMZW9aPywbc1bYDoCq9jUQlw92QQfg357yWtUFYLDihKbTK+ULpyMHeee/kQBlXMZkKjxw0lW/gYGF2YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770685713; c=relaxed/simple;
	bh=UgFMK87gMbiLTkxPxNtJt5viTEUwEhQAaH4Gg0AyR28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rv45llVmBMwH4HJ4OYHsvTqBgec8q11/4pG9QA6tw8kbrO05S/oKsqYe4Gdq8eNRGmA9RWxkxqzLzZnj6qEKzjHqXXBghHRrOLj8HrtqfiggWebygV6IN0qSx1suuNmmT08mMTVibeUiM0LmPuibuutpBHtPfSqm2xphJU9nfok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tfLppn6F; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770685709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oss6+Yt6vPsRwCho8KPS5orhk3NXvZs6/NMsKCKIGG0=;
	b=tfLppn6FG2l1ups5PtduKSMT9L4RunS6TLXPA0H6osKF7gRvFOmWHaeFW1EDt+wdJ1kQS9
	PplaQSuZCxQbzxqqLNkVFEXXc2iYEFzKMnpXZDkI3VAyJhTQGSftq7y7YP/EODR8XK+3h3
	tDTaJuqy5VIqZc2M9JEqNoppSn2Ks/Q=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state
Date: Tue, 10 Feb 2026 01:08:06 +0000
Message-ID: <20260210010806.3204289-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70686-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim,linux.dev:email]
X-Rspamd-Queue-Id: E6C1E115EB9
X-Rspamd-Action: no action

When restoring a vCPU in guest mode, any state restored before
KVM_SET_NESTED_STATE (e.g. KVM_SET_SREGS) will mark the corresponding
dirty bits in vmcb01, as it is the active VMCB before switching to
vmcb02 in svm_set_nested_state().

Hence, mark all fields in vmcb02 dirty in svm_set_nested_state() to
capture any previously restored fields.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..6ed333fcf0c3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1909,6 +1909,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
+	/*
+	 * Any previously restored state (e.g. KVM_SET_SREGS) would mark fields
+	 * dirty in vmcb01 instead of vmcb02, so mark all of vmcb02 dirty here.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
 	/*
 	 * While the nested guest CR3 is already checked and set by
 	 * KVM_SET_SREGS, it was set when nested state was yet loaded,

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


