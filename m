Return-Path: <kvm+bounces-70875-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eI9jJt2ujGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70875-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:31:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11803126231
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6707F3086268
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93AC33F38C;
	Wed, 11 Feb 2026 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VNqNxvUp"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5EC33F389
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827354; cv=none; b=GHoeRCyfEeV6oTBr1abDr9ywxlEANPP9EIy5W3g2zmXYoXmkKVuA1hY4WA+sYjk5HJvxe7So5Vqet09Wqg2obcrPOIGm7Oh97qPweSWudasdPBCdt6Htpu6n5xM8H98oprrvmC/mFrBlTC7exPyu1W7mwcT2i2xofFqqYwadMTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827354; c=relaxed/simple;
	bh=6YOnt69hh33xI0AM5ZsndXVvbB6SsOgg8IHG8x0zhkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrme0m7oH2hTwK82YaVIZhPTiuAYcsrHbqkzI7kXEZ+PN9CQoNXAvMKpCkUl/IHNTAFCx/CntW61aA2KHyyiZxPJdQD0qpmXSkMKNgkseXMR6wwCO4S0ieI7yiZsU1FlGswwl9jXQWx1XqbhRaG5taXaE7Ka8EP+Gv4Gr7sPWSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VNqNxvUp; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770827350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O2sl1XMMR/LmDqFSCtGv6iunZkhUJ85VwJIVaeYY+xw=;
	b=VNqNxvUpnNBdyNIcW0kZJjPrRRQDf8b0BA8D4qeT+vfpucdebZ3NoJinnWiQ6zZVxdNQcn
	5VTi9uHzuN9eEYp8N0tq9qEZGCVITgCBQg/NBEedK251/cHCuDJ+k3NRnEdg3XuHLN4bvi
	5BE1Pz6rROxQthyseiTVTeYxy4iLMEI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 3/5] KVM: nSVM: Move sync'ing to vmcb12 cache after completing interrupts
Date: Wed, 11 Feb 2026 16:28:40 +0000
Message-ID: <20260211162842.454151-4-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70875-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 11803126231
X-Rspamd-Action: no action

nested_sync_control_from_vmcb02() sync's some fields from vmcb02 to the
cached vmcb12 after a VMRUN of L2, mainly to keep the cache up-to-date
for save/restore. However, NextRIP is sync'd separately after
completing interrupts, as svm_complete_soft_interrupt() may update it
(e.g. for soft IRQ re-injection).

Move the call to nested_sync_control_from_vmcb02() after completing
interrupts, moving the NextRIP sync (and the FIXME) inside it. This
keeps the sync code together, and puts the FIXME in a more adequate
location, as it applies to most/all fields sync'd by
nested_sync_control_from_vmcb02().

Moving the call is safe, as nothing in-between accesses any of the VMCB
fields sync'd by nested_sync_control_from_vmcb02(), except NextRIP.

Opportunistically make some whitespace fixes. No functional change
intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 10 ++++++++--
 arch/x86/kvm/svm/svm.c    | 26 ++++++++++----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9909ff237e5c..6a7c7c5b742a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -519,9 +519,15 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
 {
 	u32 mask;
-	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
-	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+
+	/*
+	 * FIXME: Rework svm_get_nested_state() to not pull data from the
+	 *        cache (except for maybe int_ctl).
+	 */
+	svm->nested.ctl.event_inj	= svm->vmcb->control.event_inj;
+	svm->nested.ctl.event_inj_err	= svm->vmcb->control.event_inj_err;
 	svm->nested.ctl.int_state	= svm->vmcb->control.int_state;
+	svm->nested.ctl.next_rip	= svm->vmcb->control.next_rip;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1073a32a96fa..458abead9d5b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4399,17 +4399,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	sync_cr8_to_lapic(vcpu);
 
 	svm->next_rip = 0;
-	if (is_guest_mode(vcpu)) {
-		nested_sync_control_from_vmcb02(svm);
-
-		/* Track VMRUNs that have made past consistency checking */
-		if (svm->nested.nested_run_pending &&
-		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
-                        ++vcpu->stat.nested_run;
-
-		svm->nested.nested_run_pending = 0;
-	}
-
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 
 	/*
@@ -4438,12 +4427,17 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	/*
 	 * Update the cache after completing interrupts to get an accurate
 	 * NextRIP, e.g. when re-injecting a soft interrupt.
-	 *
-	 * FIXME: Rework svm_get_nested_state() to not pull data from the
-	 *        cache (except for maybe int_ctl).
 	 */
-	if (is_guest_mode(vcpu))
-		svm->nested.ctl.next_rip = svm->vmcb->control.next_rip;
+	if (is_guest_mode(vcpu)) {
+		nested_sync_control_from_vmcb02(svm);
+
+		/* Track VMRUNs that have made past consistency checking */
+		if (svm->nested.nested_run_pending &&
+		    !svm_is_vmrun_failure(svm->vmcb->control.exit_code))
+			++vcpu->stat.nested_run;
+
+		svm->nested.nested_run_pending = 0;
+	}
 
 	return svm_exit_handlers_fastpath(vcpu);
 }
-- 
2.53.0.239.g8d8fc8a987-goog


