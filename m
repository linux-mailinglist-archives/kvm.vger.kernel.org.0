Return-Path: <kvm+bounces-71696-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SP+HK2konmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71696-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7454618D75A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6617F306FE43
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC34537754C;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrW3PJls"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B0636F40C;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972469; cv=none; b=lFL95gJCBFgOqmDvMiHBR5rSuF18Bsa4ryiu3kBjsN4Cwwv9Wzs6EN7b9rUf48y+wHARDubYhjrX7w3PuPme7M7FWHkB7SpTZxOLTn7LebRjakGbMK+20rC/FsPTlPoa8Ll8bjY5EU0u+llEdYYSvWs/qX+LQTRSM8Kx4dAd3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972469; c=relaxed/simple;
	bh=C3tF9JsJzbsyykHYuvTRTgF0nYa7yshMd2hy9I1QB9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DIIZ6i7nwME4bvLEkd5CGfdvkPFCrtaXyCV+tCkTaflG+uxKGURGFMXfburLOkb7l71g055WmseqvCgklweBHezet9QLCoDMSkzqillauiLP3ezQOrByMKa6gWDU1fS64daeTo017JFlwOeWJr1jcb95n08IaUD0FR/7Pj0GWnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrW3PJls; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428D0C19423;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972469;
	bh=C3tF9JsJzbsyykHYuvTRTgF0nYa7yshMd2hy9I1QB9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrW3PJlsY7MKVzsssSx0S5yLI55t1gf9Nw8JVmbZaTfB5bDBABhQiSn/T7ukwzd+f
	 ibNRXS5kBuFR2okjAvUEow3degwdYDqCXZtDbvE5UeyADmfuKbRiTn63lOVbz+u/e7
	 Rc1YLZruvl6gEI9vZbtayrNXXlb2vOtowSLNmy8q3o97sQxYLgqgOvpGTdXHZSdq0H
	 onB83w5A5CpBojBkFBn1znmfH6+/r+T3LmlUxNW1lCYBylbCDNr2TQiKoNToH3vnTt
	 sjx5H44QVGbdVzIlG+2rHZZ5O+PT6WE5zz75mOSDxnUcmkl1NScabPbbZg2fYUGcXY
	 sJ7YWZgfXwLhQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 20/31] KVM: nSVM: Add missing consistency check for hCR0.PG and NP_ENABLE
Date: Tue, 24 Feb 2026 22:33:54 +0000
Message-ID: <20260224223405.3270433-21-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71696-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,hcr0.pg:url]
X-Rspamd-Queue-Id: 7454618D75A
X-Rspamd-Action: no action

From the APM Volume #2, 15.25.3 (24593—Rev. 3.42—March 2024):

	If VMRUN is executed with hCR0.PG cleared to zero and NP_ENABLE
	set to 1 , VMRUN terminates with #VMEXIT(VMEXIT_INVALID).

Add the consistency check by plumbing L1's CR0 to
nested_vmcb_check_controls().

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 752dd9eb98a84..6fffb6ae6b88b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -342,7 +342,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 }
 
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
-				       struct vmcb_ctrl_area_cached *control)
+				       struct vmcb_ctrl_area_cached *control,
+				       unsigned long l1_cr0)
 {
 	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
 		return false;
@@ -353,6 +354,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
 		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
 			return false;
+		if (CC(!(l1_cr0 & X86_CR0_PG)))
+			return false;
 	}
 
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
@@ -952,7 +955,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	enter_guest_mode(vcpu);
 
 	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
-	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl))
+	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
+					svm->vmcb01.ptr->save.cr0))
 		return -EINVAL;
 
 	if (nested_npt_enabled(svm))
@@ -1888,7 +1892,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
-	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
+	/* 'save' contains L1 state saved from before VMRUN */
+	if (!nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
 		goto out_free;
 
 	/*
-- 
2.53.0.414.gf7e9f6c205-goog


