Return-Path: <kvm+bounces-70877-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6MwbKi6vjGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70877-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:32:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2590112624F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53966305DA0A
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C08934404E;
	Wed, 11 Feb 2026 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o+xoKSVX"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172C7344D83
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827357; cv=none; b=nUxlDia7xKZCQO45XA8uJa3JSs+S5nR8T704D+CQvS9xE2LipL/N0FEXivhImzC3T52pQhzpu9PmrQ/C5QOx4nkWOE8vg8Mu78BRgaMFi/5XIEoDfr50EGO0MUBqI41z8y3uB1rRP8/EoWCCoLXxgZM5fm8Fk43H+mOw2d+zpEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827357; c=relaxed/simple;
	bh=/sgsLkfbqIClvvV8rFZNiXHMdUoW7U52VNMIRQlnhjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VX3n70ecfRxy1Pe1eeQHLcbGMR3HsJv7fTafbnZ1y2a8vuV2R2DyIPQNO7MP+aSyn+zN3D+y+0nuTv7YdRC9iV8CcFgOEJu86ZiZWvux4q4zwi6AcaGpna111qJyVoNUuiiOkiVViPeLwCLRMe8ADQSeIyAKEpns8YM/J1SORYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o+xoKSVX; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770827354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1FICbsfpn2yI8rBPMCG8CPTHNhJDyAKHkEnxlfHtJ8g=;
	b=o+xoKSVXF6Qw/oWMzkhV5+/1XrWWKis6fBHmVQNLdugwO5JEny1kwirFzCFwzaf9x7mCFY
	ItVF6LAKi6lLZcrmQHToea1Wgo2ej9W8Gliy5JDI3rX6WNjxwmGoDiXsKDQFYBszyYma/X
	4GAmm2JGhrmmGYxhC3uz9w4k7pUtLqM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 5/5] KVM: selftests: Extend state_test to check next_rip
Date: Wed, 11 Feb 2026 16:28:42 +0000
Message-ID: <20260211162842.454151-6-yosry.ahmed@linux.dev>
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
	TAGGED_FROM(0.00)[bounces-70877-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2590112624F
X-Rspamd-Action: no action

Similar to vGIF, extend state_test to make sure that next_rip is saved
correctly in nested state. GUEST_SYNC() in L2 causes IO emulation by
KVM, which advances the RIP to the value of next_rip. Hence, if next_rip
is saved correctly, its value should match the saved RIP value.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/state_test.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 57c7546f3d7c..992a52504a4a 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -236,6 +236,17 @@ void svm_check_nested_state(int stage, struct kvm_x86_state *state)
 		if (stage == 6)
 			TEST_ASSERT_EQ(!!(vmcb->control.int_ctl & V_GIF_MASK), 0);
 	}
+
+	if (kvm_cpu_has(X86_FEATURE_NRIPS)) {
+		/*
+		 * GUEST_SYNC() causes IO emulation in KVM, in which case the
+		 * RIP is advanced before exiting to userspace. Hence, the RIP
+		 * in the saved state should be the same as nRIP saved by the
+		 * CPU in the VMCB.
+		 */
+		if (stage == 6)
+			TEST_ASSERT_EQ(vmcb->control.next_rip, state->regs.rip);
+	}
 }
 
 void check_nested_state(int stage, struct kvm_x86_state *state)
-- 
2.53.0.239.g8d8fc8a987-goog


