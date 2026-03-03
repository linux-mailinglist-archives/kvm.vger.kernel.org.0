Return-Path: <kvm+bounces-72470-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDSYGKstpmkQLwAAu9opvQ
	(envelope-from <kvm+bounces-72470-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5CF1E73AC
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E6C443036062
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DC23630B4;
	Tue,  3 Mar 2026 00:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5Qmc9Ii"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71AA35F171;
	Tue,  3 Mar 2026 00:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498078; cv=none; b=X7zKLQayGq1txiz/VTIlrEddvMB8Pkp5TyE/rhAA1/23p4jAwcCuaRAIOqSG8kvz8NoYoeu04o57JWlkc1TxvT/tzELQZSGRhHC1duZQ8in00wHNEAW7ORzK/Z2Q0tgB+x0uwuUaflFkWcM8dGyDatdGme6lpOKhGmd/4A+rr2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498078; c=relaxed/simple;
	bh=4yF4ObMkUIsa5S10Tx/7NPubGq6kLDk80Z+SpNKvNkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwxH/xw3vYKDSDTty77LKaTMRlqVc6MJHfKkKmoppYn9g1rCLYG/0rQTDI4V/4qyGl+y0RK97oxLCjv5Vh3K0t6f/M6mkejawHOX2GQvlAm6a3JWOZEgUCkY0yZQXSf0RqNm1V81mbkKo7VuAZg0vvt8asSLZ/DJwIaW2hAgMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5Qmc9Ii; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75490C2BCB0;
	Tue,  3 Mar 2026 00:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498077;
	bh=4yF4ObMkUIsa5S10Tx/7NPubGq6kLDk80Z+SpNKvNkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5Qmc9Ii20cmtZR0kZRHCf2J3nrhhIeANVXWoTmRV+A0ujH3++pnqOFIXuzsB3uYp
	 SI+3VQGG2xcZYI2TFJIo2p/tpF4TKzJldOjnD8y3VGkQLvlZc5Cyiuwk+hz/1TXK3B
	 7U44VvMKClHwhNN8sOgQ1iyAjQ3+4yCXCz6sHt8B9+R+2XK/GU4jBtKEU0sFVRJOo/
	 kQFIzlhk3bwtpX2j4WXTbve5axtL9P0NC1Pi1s1EPzXAS19fgs1E+gBzq8osoLhPto
	 Wl/EXifzy4Gmf6VQbPaS6DM78dKBiJZ5bmhYTKbJQWXIJthYSdZn8DBAZ0OkN2GSXN
	 V8opTrbYOx50g==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 15/26] KVM: nSVM: Add missing consistency check for nCR3 validity
Date: Tue,  3 Mar 2026 00:34:09 +0000
Message-ID: <20260303003421.2185681-16-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F5CF1E73AC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72470-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

From the APM Volume #2, 15.25.4 (24593—Rev. 3.42—March 2024):

	When VMRUN is executed with nested paging enabled
	(NP_ENABLE = 1), the following conditions are considered illegal
	state combinations, in addition to those mentioned in
	“Canonicalization and Consistency Checks”:
	• Any MBZ bit of nCR3 is set.
	• Any G_PAT.PA field has an unsupported type encoding or any
	reserved field in G_PAT has a nonzero value.

Add the consistency check for nCR3 being a legal GPA with no MBZ bits
set. The G_PAT.PA check was proposed separately [*].

[*]https://lore.kernel.org/kvm/20260205214326.1029278-3-jmattson@google.com/

Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 613d5e2e7c3d1..3aaa4f0bb31ab 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -348,6 +348,11 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(control->asid == 0))
 		return false;
 
+	if (control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
+		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
+			return false;
+	}
+
 	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
 					   MSRPM_SIZE)))
 		return false;
-- 
2.53.0.473.g4a7958ca14-goog


