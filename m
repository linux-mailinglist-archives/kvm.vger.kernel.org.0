Return-Path: <kvm+bounces-72477-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oO+pKqQtpmkrLwAAu9opvQ
	(envelope-from <kvm+bounces-72477-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAFA1E73A3
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C690E3049D69
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73DE36F41A;
	Tue,  3 Mar 2026 00:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEM5J6YD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3682367DF;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498080; cv=none; b=K+OmMm4bsc3OL16+NKg5v3yjB280m37wCE8/6pdNJKMTIbsraGJstY2HcLPY0tuqL3OBa4QoLkqWhCSGQNk2x06Ih78iVPwa8UzmQIM82qaViLfQHe3y4wlsH2UbIVKUU3t3/Vv9+l4LsktBn2VIpLPY+bkQs/Mr2GHa/zqv1VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498080; c=relaxed/simple;
	bh=fj6FLXq+xF1/WvdvmFuZXB1XYHfJzjPbj4Xu3XDLoxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clQ1qV/hw/Lgbs/P04VuiFInY6k8wVXreM5c1++YrwWFIn6uTnCfCZnZ3y5YxVBTuv69blF3Q+o5WpU+vgqgtYofD4taDePQ24QMV83Su1T5OR802U7MdAytKmI9cQ2NMPMDm7748zbgvvAKWu/o4LjsH/dsQb1YrLU0LCF48dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEM5J6YD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4295CC2BC86;
	Tue,  3 Mar 2026 00:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498080;
	bh=fj6FLXq+xF1/WvdvmFuZXB1XYHfJzjPbj4Xu3XDLoxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEM5J6YDT1pPqvT1YX4cXLGiCYn8eASdYQIqSPWuFcMQe7ssaS9OYRjtvfWlp393G
	 Vfpwa6ZZfZX/ioA7LwFzXr+m3VM4OdrLPD38gQFbMddftfO1uE8BO0meXhszEWXnz8
	 bsA6Gtwtgf6n57zwajyga7Y/PZCTA2CNjgqS1U5B4gO09GMnxu2fccAccSowLVzXR6
	 sUkX/6512XX3Fn4LC/EGn0JGtyVBJ1Y2s4k5XKwlHbNTF0EqTvILA3SKEv3p2w/pql
	 iuEjImhEObs2OjGc8TOY/d2ruqVy0wg07VVyTNz2Key6mZcrQ/BiR/N2Z5go4vGm6A
	 KW7Rwza2P8NBQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v7 22/26] KVM: nSVM: Use PAGE_MASK to drop lower bits of bitmap GPAs from vmcb12
Date: Tue,  3 Mar 2026 00:34:16 +0000
Message-ID: <20260303003421.2185681-23-yosry@kernel.org>
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
X-Rspamd-Queue-Id: 8DAFA1E73A3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72477-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
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
index 0151354b2ef01..2d0c39fad2724 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -493,8 +493,8 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
 		to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
 
-	to->iopm_base_pa        = from->iopm_base_pa;
-	to->msrpm_base_pa       = from->msrpm_base_pa;
+	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
+	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
 	to->tsc_offset          = from->tsc_offset;
 	to->tlb_ctl             = from->tlb_ctl;
 	to->erap_ctl            = from->erap_ctl;
@@ -516,8 +516,6 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 
 	/* Copy asid here because nested_vmcb_check_controls() will check it */
 	to->asid           = from->asid;
-	to->msrpm_base_pa &= ~0x0fffULL;
-	to->iopm_base_pa  &= ~0x0fffULL;
 	to->clean = from->clean;
 
 #ifdef CONFIG_KVM_HYPERV
-- 
2.53.0.473.g4a7958ca14-goog


