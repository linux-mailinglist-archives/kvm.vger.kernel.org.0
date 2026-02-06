Return-Path: <kvm+bounces-70489-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAjZGsI8hmkvLQQAu9opvQ
	(envelope-from <kvm+bounces-70489-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC2D1027AF
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 20:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2AA90301C720
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 19:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6599043CECE;
	Fri,  6 Feb 2026 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cYkUgsYk"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C242DFFC
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770404968; cv=none; b=h8+V3Qko7bSVwUyhn0/Sws5qAyfSHH4QcOpOhbb+apMc+sAMvoFjly7Qc53GXwm3E3r/oqcbxJ+R2QUi/OSaC/EwkZ01Fy1MgQJuiY1yyE1Tzr3vIQyAO8QHYbo9HlQYnWD9255ThFdvTV/zhqAoM5MdH1+/tt2cFXsoXAstEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770404968; c=relaxed/simple;
	bh=ODb2/IeBwTyKMp4WD85zCZj6S9Ai9FchMpNcAg0S+no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ642jaL8IaoBLLPYGtgl+Dqrj3BD7kFfiXh+T3Mvm6toMvGMCoeVkkHXbt87BzmGC2gqdgtp3kYlinE9f3TXhx5tgrwFYFR+HOp2vz8ewdkxGPxclHfsUW+Gn6E6qXasqPu9z0aEAGJngSsJ1DGDMPD6gQCfwNVbJOOncnUYq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cYkUgsYk; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770404967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iUgewoR9hSRJHPl5m11yn7PrfmFETAQcerjNyaq/Mfs=;
	b=cYkUgsYkjTu4mizejs2EwuPQugsVehayIX12RSQc1G2FjrUPlGmMglVDBoxIVQgJWdOwkh
	ZGPbabTcSAbIEZiCFOyNX8DDLTNftsppEW5nmSsgEfApvnZ0+nUSdgfGNKU+gRyEzziZPS
	ZCeV9/r70YY/lGXbMu6MwlnBqemATh8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v5 11/26] KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
Date: Fri,  6 Feb 2026 19:08:36 +0000
Message-ID: <20260206190851.860662-12-yosry.ahmed@linux.dev>
In-Reply-To: <20260206190851.860662-1-yosry.ahmed@linux.dev>
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70489-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 4CC2D1027AF
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
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6e7238fed7ab..c16b68a07369 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -956,6 +956,12 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
 
@@ -1034,22 +1040,17 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
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
2.53.0.rc2.204.g2597b5adb4-goog


