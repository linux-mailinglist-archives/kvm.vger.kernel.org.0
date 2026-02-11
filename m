Return-Path: <kvm+bounces-70873-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CA4uFnyujGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70873-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:29:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E351261E0
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:29:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 42C373013CB7
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7E233F8C2;
	Wed, 11 Feb 2026 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vh9Zeag0"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C512D781F
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827351; cv=none; b=ILuC1wyEE7frcGEVbmXXr101YFGw4HD06vPk3sGny8xhveMupVnGr69pOD5Bwzn+cSp74qWuXUGSR2vqms1HIkKIgqt5kP6cSJ/pgQzXeqEv7G9YeM1HlPl1mW18bxyJ9mAx+satdLpNYSsS9LptpLEyEWA8NuNrGgDi8Z9CUjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827351; c=relaxed/simple;
	bh=DwNMt9sTxMJvPffKqssdDnCVH7eazxC3nEWkZRv8nHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC5qHas84Sk8mqhoPcBxRCY7DZu3uE9foGx9DlWXfQewblhts1rnNiMdq9Ami7vR2aHOY3fvpM20G5nJ9pV0r/ID8yOiDLW6cOSYoIn5KErqi2ZrfI/RQw6uXhHUNxxwn7b2bcKS20VXaCU+VM+dh1DDeRyLgCWp7JenzuIq5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vh9Zeag0; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770827347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0pfwtfuSAR+toNK8R5pgRmHFl05Ro/5VJ5HwjG4DKw=;
	b=Vh9Zeag0eUvYHlAg65EfEGWdcAaCR6oDF+VhAkKkBOyWWS60RRx8kH//EPOCMjbqJ6/9LR
	9eSCnEThzVMUH5/WDZn6fXmCAaMvZO1KB+Ib55HVaiFHpmuH2lprjRLh/513lRyjhNULL9
	P5tt5Q3DaZDtUr8c+qMyunltnDKvTo4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2
Date: Wed, 11 Feb 2026 16:28:38 +0000
Message-ID: <20260211162842.454151-2-yosry.ahmed@linux.dev>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70873-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim,linux.dev:email]
X-Rspamd-Queue-Id: 71E351261E0
X-Rspamd-Action: no action

After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
fields written by the CPU from vmcb02 to the cached vmcb12. This is
because the cached vmcb12 is used as the authoritative copy of some of
the controls, and is the payload when saving/restoring nested state.

NextRIP is also written by the CPU (in some cases) after VMRUN, but is
not sync'd to the cached vmcb12. As a result, it is corrupted after
save/restore (replaced by the original value written by L1 on nested
VMRUN). This could cause problems for both KVM (e.g. when injecting a
soft IRQ) or L1 (e.g. when using NextRIP to advance RIP after emulating
an instruction).

Fix this by sync'ing NextRIP to the cache after VMRUN of L2, but only
after completing interrupts (not in nested_sync_control_from_vmcb02()),
as KVM may update NextRIP (e.g. when re-injecting a soft IRQ).

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..1073a32a96fa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4435,6 +4435,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	svm_complete_interrupts(vcpu);
 
+	/*
+	 * Update the cache after completing interrupts to get an accurate
+	 * NextRIP, e.g. when re-injecting a soft interrupt.
+	 *
+	 * FIXME: Rework svm_get_nested_state() to not pull data from the
+	 *        cache (except for maybe int_ctl).
+	 */
+	if (is_guest_mode(vcpu))
+		svm->nested.ctl.next_rip = svm->vmcb->control.next_rip;
+
 	return svm_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.53.0.239.g8d8fc8a987-goog


