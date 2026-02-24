Return-Path: <kvm+bounces-71695-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEG1FG0pnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71695-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:42:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E66B818D92B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91C2830BE2E5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D749374749;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcmNmzmN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385B336D4FD;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972469; cv=none; b=WchY7pnbSE5647sJ7zL3tNfos3Wt5eQEDAidbhFJCZGY/Jx2NxluynIDr7yeyf4vR1xQvcHKj+ZD/4vhOdpjCitwqkb52XRngyXupCL1bRnGwQsnb8venttzE8G1mCV/V7p1CMeMikzRkp8GGsc4MRMCRMM+tB/BAJsjOavIkS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972469; c=relaxed/simple;
	bh=89Uh9bf3kyv7g5pliglimBSNkSLXd6p0n1HAtULumzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JY/58r8C2Cw3sTk4f5cXxVN91FSHx1ZMrKd3R3iJtQ64P6SWSW9urElN8vs27C3fi9Ki4H2Y+pj72ZHZToArEAfkmygrxPDf3IXzfjx9QZl/pcZ4zjDwSnouJrUCJWFhqKx6K4uUKk1xe/eOzPKtcRst6gA0CaNmVBIVCg47Pgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcmNmzmN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D446AC116D0;
	Tue, 24 Feb 2026 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972469;
	bh=89Uh9bf3kyv7g5pliglimBSNkSLXd6p0n1HAtULumzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcmNmzmN3C2Sh8SEioRGp6IHWOB9kBhzj8IWU1v2H2f8LDbgrWrQ5Dg3A3rnelXvq
	 OVu19vOepuCNonAdlswifsf1c0/O2TdLImoQCqoYsZBYM+zVUPXZnrP8XpLBjH/rsC
	 f842/fSDTIVj/UBXD1Esari8iZKtLkPBYKyQjmbTw7DaR3NthQtFEWP4Djrzz2HMt8
	 qE+6CJoTwYhVlQ2saUTu0awSKO8vrrO8m5SutGunUUSf9VKXFtu3eEpU2Be2LcmGBw
	 IYfVSMVe3LiFK85a+QpBEjbr62VlZDgGvmr0PGUzjrdqCgFsPirSFVIyGaGAG8wzgi
	 NnhV0ptyjiGfw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 19/31] KVM: nSVM: Add missing consistency check for nCR3 validity
Date: Tue, 24 Feb 2026 22:33:53 +0000
Message-ID: <20260224223405.3270433-20-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71695-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,g_pat.pa:url]
X-Rspamd-Queue-Id: E66B818D92B
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
index 0f18123f5461f..752dd9eb98a84 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -350,6 +350,11 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
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
2.53.0.414.gf7e9f6c205-goog


