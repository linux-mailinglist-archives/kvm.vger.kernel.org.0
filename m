Return-Path: <kvm+bounces-72480-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMyMGs0tpmkQLwAAu9opvQ
	(envelope-from <kvm+bounces-72480-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 055431E73C3
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 572873033016
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44DB371D15;
	Tue,  3 Mar 2026 00:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUV7gj7L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C971137186C;
	Tue,  3 Mar 2026 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498081; cv=none; b=BC7lENYGcF0WkVNIrzRNJ8SPn7ezoFWLKA8Qy7pHErgwHt7lV4ZXz1G7NrrhdurNcxl+oGHY2IYwIXPLJ6l3LbpdLh0LmcI/yyNa/B8HRM4XTWZEr8aIPenrzKrV86FBfTwaYzdOtuemNihAheSSaoc4XDAaz7X1Tz0o1Q9lpfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498081; c=relaxed/simple;
	bh=E41yJLQJa1kqF9bhFB8S8YwPtajDsxHNIvscFJFH2Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3oy/7mXE32BglFCOYg9OCJmb+clPRRXAJWdNHGw75fyWN/pEWU96FUOntuaHijFkBa7D6ob/bwDa9V+SAg4jroi03ZXGXpQirjMMAog0sP0tTVufeMXOOOLv2tkRwVCp8ypr9ObEXbHG1UhML/P3DY0opuVe9T2dtRm1AdchAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUV7gj7L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC2C2BC9E;
	Tue,  3 Mar 2026 00:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498081;
	bh=E41yJLQJa1kqF9bhFB8S8YwPtajDsxHNIvscFJFH2Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUV7gj7LSCeT9sZJ27VEjZkN2odTwwLll/wOpGYnCLe1rjYJwZ5uwoypLJE+dfz04
	 L/Vcvdgy/1q7g8DizK2+xf89YFNofT84PmBEEjOhOC9rcqWqQT+qbuPxMSA8hByOzJ
	 4Xlhxu1KG5vuRkjIyRTr+websArHuXbUTItbcR2JlyQNmzG712zsq/bXm2JqdsoH5w
	 mX1JnJpNgUtLGvW98d9zF5Gx21mky/zRfdaXjKL+i8lbhKHVY5c6JaRpIi5sowPKWw
	 6rNnGgU91ZhkJEoOWfcz/QJNfzeUYzzUHhGZ3UilV4sv+1HjKSaOB8zMAMY7wm3Ayp
	 vf+lT8xsGcqjg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v7 25/26] KVM: nSVM: Only copy SVM_MISC_ENABLE_NP from VMCB01's misc_ctl
Date: Tue,  3 Mar 2026 00:34:19 +0000
Message-ID: <20260303003421.2185681-26-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 055431E73C3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72480-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
only bit that needs to copied is SVM_MISC_ENABLE_NP, as all other known
bits in misc_ctl are related to SEV guests, and KVM doesn't support
nested virtualization for SEV guests.

Only copy SVM_MISC_ENABLE_NP to harden against future bugs if/when other
bits are set for L1 but should not be set for L2.

Opportunistically add a comment explaining why SVM_MISC_ENABLE_NP is
taken from VMCB01 and not VMCB02.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7ae62f04667cc..fd1fc2d67bd33 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -849,8 +849,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
+	/*
+	 * Copied from vmcb01.  msrpm_base can be overwritten later.
+	 *
+	 * SVM_MISC_ENABLE_NP in vmcb12 is only used for consistency checks.  If
+	 * L1 enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If
+	 * L1 disables NPT, KVM runs L2 with the same NPTs used to run L1. For
+	 * the latter, L1 runs L2 with shadow page tables that translate L2 GVAs
+	 * to L1 GPAs, so the same NPTs can be used for L1 and L2.
+	 */
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_ENABLE_NP;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
-- 
2.53.0.473.g4a7958ca14-goog


