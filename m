Return-Path: <kvm+bounces-70642-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOeYJig7imlvIgAAu9opvQ
	(envelope-from <kvm+bounces-70642-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1751011442B
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 737473025152
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 19:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D175426D1D;
	Mon,  9 Feb 2026 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W1m5E17F"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EA63876B6
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 19:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770666783; cv=none; b=bVuRKZn1/Cbn02Ulxn+duz4lQex41plqAEhz4jipsaP81v9UQqUhgSl9ZMyHgokeHXnrJC1tbP5ZlXrd1H4rOo4DW52p84CrGQCAHyTowt+hl/uVpIuGqfTgAXhTcdKJGGsHaEaCHWe4rEAEsOeeF3KeW5qfD8rkGsEu/hyVyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770666783; c=relaxed/simple;
	bh=6YZNN1UxcjX8gZNM775eAniWv8uktkNWbViC1mpDCyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is6yOWptniJNai9tvC4TernjT14Xmf10FR92Ko1SLeVxOoHDSL67+hdSAm959yoKp725rHz8DysBY3pu35TYZLtkiVjjH+nw0hTOK6hIskcUSIPtT3ONFxBTRI4mxKOD5uJMIS3IoEVegUF9VgzLe0ABWLrToKr13gAfqhyeKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W1m5E17F; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770666781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lvmdX8Wi8czgVl61TkPRJqdzEqIScTyuhi+2sPS7mLg=;
	b=W1m5E17FJJ1SmYTkI3uXv+vUpzyQJc7zyST+Kd+1wZhag/u1g5Rg76Bl9so7ReDnCa/GHh
	YrFqy3ZKkNbcCntX2qU5iaADywr1D5V5rud3suuVlbnf3oCOOznSwybieXxQjLyhqebhHi
	1ssPdRNMXkoV42fUi8fsB13qgijIj3M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted EFER.SVME clear by L2
Date: Mon,  9 Feb 2026 19:51:41 +0000
Message-ID: <20260209195142.2554532-2-yosry.ahmed@linux.dev>
In-Reply-To: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70642-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1751011442B
X-Rspamd-Action: no action

KVM tracks when EFER.SVME is set and cleared to initialize and tear down
nested state. However, it doesn't differentiate if EFER.SVME is getting
toggled in L1 or L2+. If L2 clears EFER.SVME, and L1 does not intercept
the EFER write, KVM exits guest mode and tears down nested state while
L2 is running, executing L1 without injecting a proper #VMEXIT.

According to the APM:

    The effect of turning off EFER.SVME while a guest is running is
    undefined; therefore, the VMM should always prevent guests from
    writing EFER.

Since the behavior is architecturally undefined, KVM gets to choose what
to do. Inject a triple fault into L1 as a more graceful option that
running L1 with corrupted state.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..ccd73a3be3f9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
+			/*
+			 * Architecturally, clearing EFER.SVME while a guest is
+			 * running yields undefined behavior, i.e. KVM can do
+			 * literally anything.  Force the vCPU back into L1 as
+			 * that is the safest option for KVM, but synthesize a
+			 * triple fault (for L1!) so that KVM at least doesn't
+			 * run random L2 code in the context of L1.
+			 */
+			if (is_guest_mode(vcpu))
+				kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
 			svm_leave_nested(vcpu);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
-- 
2.53.0.rc2.204.g2597b5adb4-goog


