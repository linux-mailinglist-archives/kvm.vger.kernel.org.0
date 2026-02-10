Return-Path: <kvm+bounces-70684-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCgcDCaDimlaLQAAu9opvQ
	(envelope-from <kvm+bounces-70684-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:00:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D2ED115E17
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 02:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 13B94308EED9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6DC27F19F;
	Tue, 10 Feb 2026 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GC5JiMwk"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74ED274B37
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770684925; cv=none; b=gMBA+jW79F51dONm6JKDk72L7WA3mS2U2MXQmXrsEIaXlR6+CgfmbIwcSh9/EWp4PLzt2EUSnIiLldZmsxEyDbjDnx6BRgtvN90RDTdfKQI0XFKMzrLEqkxGBQ56d79sLd4Uf7G9DN7celwh9d1MYm5nNG8zJ8d9ZHS/AzDQfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770684925; c=relaxed/simple;
	bh=cwG/NMskJD4ybURXDROCS0IewPftFdK1QqvbrL5qXhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRXCDsJUN7J9h9hsA00pyCs6yR8/TyAun4w3ulpwo/fJbUcqrK38LniMtNgsbcNT1g2Hq59CKFxVQYiAIIYW++5aj6YOYc9bvp1aI1VdvaxbR0tDpldw86QVbBBzNK3bKXoVVmUUraLv89IEqmZq56nKOMXEhxNWCsYPYbhbTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GC5JiMwk; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770684922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vNfLu8p+LHceCLGq3Bp6+ezRZl+1WypRkVGHyFCfSwA=;
	b=GC5JiMwktNZbPOwY39KefserrlFxIO3WYhQKbvMR2hhSyU4b5RXF28p9RzQNOPNtdNfuB6
	FFJq1FRkWclEs+jclg9AUziSu/75ox53XuOApV2RSlMO3kQOiEsrw2d0T9vcTkJS8Gm62j
	xSzkKfMaRBCZ84c9HIKW18GrE2vQu1M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 4/4] KVM: selftests: Extend state_test to check next_rip
Date: Tue, 10 Feb 2026 00:54:49 +0000
Message-ID: <20260210005449.3125133-5-yosry.ahmed@linux.dev>
In-Reply-To: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
References: <20260210005449.3125133-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70684-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9D2ED115E17
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
2.53.0.rc2.204.g2597b5adb4-goog


