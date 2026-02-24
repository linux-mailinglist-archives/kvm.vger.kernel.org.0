Return-Path: <kvm+bounces-71688-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 79BzNGsonmkzTwQAu9opvQ
	(envelope-from <kvm+bounces-71688-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5EF18D76A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61D9A30DD9BF
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1E4364021;
	Tue, 24 Feb 2026 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fV/mr7mn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653093624C0;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972466; cv=none; b=X8xkbczVlwqypDOhOEPZAdm2c3oRN0uYjAi9O3Dvpsvbc5Ynt5rum0qea1lpj4vGKMbQGJzeJFJncQDAeI7HtetlqzVvwt/4PsRm4C77pTpUT1a9SmNc6RIfrnl+EHE1/yjIYVpsv6Zt9bsg6kQu7l5bRizmgXiWVemSmSlJvc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972466; c=relaxed/simple;
	bh=IFCEWEs+v5uNIrZaMJ5+GDYk34dfb0i36jV1dJ/PfK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqPKXiuJCpmWY97n8u2STOSM1fF1E7ZIWfsFCuE+TBE0xWvjSSqWyaZa0LDQ0kNhM8f8bvf6Ig6Mmga7baLrqf2KNt/dU33bVUcOKBEflReDmczMC6Og20uZAUyPA1/9ZoOT6tA9RUuK44xgYdjuxfxVPm28aso9DlSJc8WTR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fV/mr7mn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB1FC19423;
	Tue, 24 Feb 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972466;
	bh=IFCEWEs+v5uNIrZaMJ5+GDYk34dfb0i36jV1dJ/PfK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fV/mr7mn6BdXIw12qag8AVS2NVj+YhR/SYvyI6hdj2KZQ6QjMyOjcJ4GuR39W1+kg
	 5TmrbAnpS7ueoKCmq9K+QnHuXZqL1ph68PIjZP8H6z0hBj9kaR8nyx37LGAFyevZxF
	 /6mifr5xlqOU3amNp//JpFJYClbP2lKI9j3HxMTdHuIHUGnxetes5OsewHaNeMpOtO
	 pBBvotfJJPkBoSGIeA3pKbyPobzv2oG/8+P/FfB1MLtnhizmIccaqtD9dMbk0CT7FZ
	 sVvXC90oHB4TiyuYz3fLSJHTgjeSYBEMTRyiElbv9wqeCd5XkzLxBD9S2nxPHfa8pI
	 ki1ZmRGH/U+6g==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 12/31] KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
Date: Tue, 24 Feb 2026 22:33:46 +0000
Message-ID: <20260224223405.3270433-13-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-71688-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4A5EF18D76A
X-Rspamd-Action: no action

In preparation for moving nested_svm_merge_msrpm() within
enter_svm_guest_mode(), which returns an errno, return an errno from
nested_svm_merge_msrpm().

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5ba3f8de0a939..78caa75fe619a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -276,7 +276,7 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
  * is optimized in that it only merges the parts where KVM MSR permission bitmap
  * may contain zero bits.
  */
-static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
+static int nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	nsvm_msrpm_merge_t *msrpm02 = svm->nested.msrpm;
@@ -303,17 +303,19 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 #endif
 
 	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
-		return true;
+		return 0;
 
 	for (i = 0; i < nested_svm_nr_msrpm_merge_offsets; i++) {
 		const int p = nested_svm_msrpm_merge_offsets[i];
 		nsvm_msrpm_merge_t l1_val;
 		gpa_t gpa;
+		int r;
 
 		gpa = svm->nested.ctl.msrpm_base_pa + (p * sizeof(l1_val));
 
-		if (kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val)))
-			return false;
+		r = kvm_vcpu_read_guest(vcpu, gpa, &l1_val, sizeof(l1_val));
+		if (r)
+			return r;
 
 		msrpm02[p] = msrpm01[p] | l1_val;
 	}
@@ -325,7 +327,7 @@ static bool nested_svm_merge_msrpm(struct kvm_vcpu *vcpu)
 #endif
 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm));
 
-	return true;
+	return 0;
 }
 
 /*
@@ -1040,7 +1042,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
-	if (nested_svm_merge_msrpm(vcpu))
+	if (!nested_svm_merge_msrpm(vcpu))
 		goto out;
 
 out_exit_err:
@@ -1940,7 +1942,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
-	if (!nested_svm_merge_msrpm(vcpu)) {
+	if (nested_svm_merge_msrpm(vcpu)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_EMULATION;
-- 
2.53.0.414.gf7e9f6c205-goog


