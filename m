Return-Path: <kvm+bounces-71697-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDw7KUEpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71697-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:42:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45FEC18D90E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4857831AA9F5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE22350A3B;
	Tue, 24 Feb 2026 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdWNyYFo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0708937416E;
	Tue, 24 Feb 2026 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972470; cv=none; b=q79+9dE4F1u+g8WANXfQT/rYE00vQg3DvxXv0o9oJSyFuXE4yfQtkvStZpieaCx4pqLquIb5MRP6Z/7bil1ixaoWhCa2kHtiHJJNq5BpMxUeLtps0Rtnv0uN5VOgT8jsO7MfeFI8m+9QVZuNeWEWHoSmmOM89SH58TJ+wlcWgA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972470; c=relaxed/simple;
	bh=k4+yXe4ROo+NBnHHVzfrgeWre0T/weuNn//DP9UhS0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lQjTAZesPFTEaJrR5ycVbiUebh0sotO9PmcsHytYDaz5kj768WCdDWgLkgqAiiDL4LPnSknYWWDL4i2EkSib+aknK8sIY8zCY8D1EHv3EBn4XKfigmXs2IsniF6YlOAnMLa/NuHWh0OZtwhDQxFOM5yAlK2c9xFTy8LANGDYX04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdWNyYFo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46E1C2BC87;
	Tue, 24 Feb 2026 22:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972469;
	bh=k4+yXe4ROo+NBnHHVzfrgeWre0T/weuNn//DP9UhS0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdWNyYFoDmIAs0p1ufqBoCb+obXSqq/sqJE6ucczyfLgD/ocBoi62anGAWFdLIRVP
	 rR1Z9Pkkmtx8UE8nOaqB78Bqb5drs1s8OE6JCC1Y0HhpWQXuUInrkpQhZH8bQio/Oq
	 dPV0Odv2MC2PRT2Q+DlnfVkZTBuRjGaBUVshR0zr+x6KgnQyIs5kFEwLIOIL7UcOdf
	 zQCa2L+iOMVnu4fOT75Jtep/q48gaREMtk/duz/lGeA6iKhDRV3+mp7sFFndV+1NTc
	 1wxYSYKI5tO1aEc3vPvzFlWZmfMeLgYWN96X3KzNIRjlY5iOSUgbOsFWop3DmxrhiW
	 92LHvGbIGPMew==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v6 21/31] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Tue, 24 Feb 2026 22:33:55 +0000
Message-ID: <20260224223405.3270433-22-yosry@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71697-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 45FEC18D90E
X-Rspamd-Action: no action

According to the APM Volume #2, 15.5, Canonicalization and Consistency
Checks (24593—Rev. 3.42—March 2024), the following condition (among
others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):

  EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.

Add the missing consistency check. This is functionally a nop because
the nested VMRUN results in SVM_EXIT_ERR in HW, which is forwarded to
L1, but KVM makes all consistency checks before a VMRUN is actually
attempted.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 7 +++++++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6fffb6ae6b88b..2c852e94a9ad9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -397,6 +397,11 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cr4 & X86_CR4_PAE) &&
+		       (save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -492,6 +497,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 	 * Copy only fields that are validated, as we need them
 	 * to avoid TOC/TOU races.
 	 */
+	to->cs = from->cs;
+
 	to->efer = from->efer;
 	to->cr0 = from->cr0;
 	to->cr3 = from->cr3;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7629cb37c9302..0a5d5a4453b7e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -140,6 +140,7 @@ struct kvm_vmcb_info {
 };
 
 struct vmcb_save_area_cached {
+	struct vmcb_seg cs;
 	u64 efer;
 	u64 cr4;
 	u64 cr3;
-- 
2.53.0.414.gf7e9f6c205-goog


