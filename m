Return-Path: <kvm+bounces-71703-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iIsHOvEonmk7TwQAu9opvQ
	(envelope-from <kvm+bounces-71703-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E80F18D87F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ECF4130B56EB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AC13AE719;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxOqL00o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4342C3ACF05;
	Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972472; cv=none; b=qMpgpskemnBdBqVSjmnZN09uZkzlTaCdJiN4VluQMoixdA2DyX3A7v2eICS/5+OZMcQLQmXsugeZFPnkajZJafW/3SaTPDEdgUKRCi7tCspEH60Qb98qFFdT9mTW0yKITtc6HgUV322Qrj0fLP5/FRXxkBat6TxatNcp7g2NuaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972472; c=relaxed/simple;
	bh=IM+ni7R0tCySorWNqi7DDiY8uOysUtiVySdq/OQQOEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXc0M8qHwaNu4xpmS4abFMtWYQYsTRMSqtK1/GbtZcpq+elCih4UzYoEnATKYaPKJI6guXfKuStnQCQWPM0TUJSvQsTq8PJJSn9+khXSM5BOZfzBjEdtd8LDfPpDBhEx/uj918SSeiku3px2Sri9+CI1BMLNdXBZUbT/Yj8Mc5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxOqL00o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74AEC19424;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972472;
	bh=IM+ni7R0tCySorWNqi7DDiY8uOysUtiVySdq/OQQOEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxOqL00osshPsWMWJ0Hmy+vZliDAPz50WQXbux9eBjvkslA+M7zIB/G6wbDcPVusO
	 wLGWLzrtXMsaOE/Mcvg0i+MamV6JeIF4IXGM86TDwrQCBfC4faONfE9lWo8E4UIjak
	 hvclrD+g02atVzT5qCedHvEaWLT8Cjjz5UF4juKhmBw67XkXXGmi+QT+JOuZE9Fgk9
	 ihJuHoND3CXvRqoFTAGt0E+auTHqDp2UJlVJfKokRHm8A2DKPdZRwFO158l4//2H4f
	 zusU95LvGC20HjBSs9aSCAcTAL2Y9uzbWz4R29kyR0QZpypaUadV4cP9WdSKvz0WUK
	 o36Ok45oqm+Nw==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 27/31] KVM: nSVM: Use PAGE_MASK to drop lower bits of bitmap GPAs from vmcb12
Date: Tue, 24 Feb 2026 22:34:01 +0000
Message-ID: <20260224223405.3270433-28-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71703-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8E80F18D87F
X-Rspamd-Action: no action

Use PAGE_MASK to drop the lower bits from IOPM_BASE_PA and MSRPM_BASE_PA
while copying them instead of dropping the bits afterward with a
hardcoded mask.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5c8449bc6fa0c..28a8bfc632ef5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -499,8 +499,8 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
 		to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
 
-	to->iopm_base_pa        = from->iopm_base_pa;
-	to->msrpm_base_pa       = from->msrpm_base_pa;
+	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
+	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
 	to->tsc_offset          = from->tsc_offset;
 	to->tlb_ctl             = from->tlb_ctl;
 	to->erap_ctl            = from->erap_ctl;
@@ -522,8 +522,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 
 	/* Copy asid here because nested_vmcb_check_controls() will check it */
 	to->asid           = from->asid;
-	to->msrpm_base_pa &= ~0x0fffULL;
-	to->iopm_base_pa  &= ~0x0fffULL;
 
 #ifdef CONFIG_KVM_HYPERV
 	/* Hyper-V extensions (Enlightened VMCB) */
-- 
2.53.0.414.gf7e9f6c205-goog


