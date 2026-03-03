Return-Path: <kvm+bounces-72471-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MO4dHkgtpmkQLwAAu9opvQ
	(envelope-from <kvm+bounces-72471-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:37:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD1A1E7335
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 139BB302D1BC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E14A364E91;
	Tue,  3 Mar 2026 00:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oW9FlGC4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4376135F5ED;
	Tue,  3 Mar 2026 00:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498078; cv=none; b=rh4Xe+RNaEgK7suv996zR5px8R/DVxnTAF0NFu5MfaH5HpewIFV/RgNzWoS8ksMwEjOAgIp6Jpi3ZOQkgqGnUzV9q3JvjrLrnzOWlvzzqIEheHKoYpSklxd7jy7+iMPskw9DJjjzBGiuRLCELA5eTG+DFIpzE2nVqaAEib8Lvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498078; c=relaxed/simple;
	bh=pIwNjczmYnEx1LxueriC9FIL1WKTRkr09sZcduektJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPHMgKzMK9Jh6yggkPVP0kpJdPMSUHDcrvPP16S16F9Wyfq6/+bnAKSUPK6Wg/lma2xfyUVLaRR6z5CSwJnL+enAQDbI9risEXBuNAKsa4WncHcowykwytbxAJzKF0etI7CkfQ8GcvZ9ZbjBeDVIMFBEb9H3yprx5pscW64DyVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oW9FlGC4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA964C19423;
	Tue,  3 Mar 2026 00:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498078;
	bh=pIwNjczmYnEx1LxueriC9FIL1WKTRkr09sZcduektJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oW9FlGC45PZpaXjlcsBV9FcMpSFQZSxalnO2HaEgzIaaOkPG4Si4VbqvsCt9Ef9s0
	 p3nKyxbGxl55hlY2yXrL6SpOAtcaztbk2NED1B4m/Lx8ixakAw50N0V6XtXAYSPQnF
	 pOxR/8VyDA2pNOLaVcyh8vyzgCpinZw6pAZEZZmsr6tdmn/HJ07YfdN2Mt5YQUJBzE
	 z7d0bBsS/l3PjmpnqZ9JmWKQWrJLBnE9WOel+5QBsEA9kFMEqYJpPOsVTvyyzlt8Oy
	 +JaUSmrm1qeFUsnAajBUg2XhZJQnPjmkk/jhVUN3u8iXLv6TzCIn/OIPRHIHImgAL+
	 6Y18w6a+nSSIQ==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 16/26] KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
Date: Tue,  3 Mar 2026 00:34:10 +0000
Message-ID: <20260303003421.2185681-17-yosry@kernel.org>
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
X-Rspamd-Queue-Id: 1CD1A1E7335
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
	TAGGED_FROM(0.00)[bounces-72471-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

According to the APM Volume #2, 15.5, Canonicalization and Consistency
Checks (24593—Rev. 3.42—March 2024), the following condition (among
others) results in a #VMEXIT with VMEXIT_INVALID (aka SVM_EXIT_ERR):

  EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.

In the list of consistency checks done when EFER.LME and CR0.PG are set,
add a check that CS.L and CS.D are not both set, after the existing
check that CR4.PAE is set.

This is functionally a nop because the nested VMRUN results in
SVM_EXIT_ERR in HW, which is forwarded to L1, but KVM makes all
consistency checks before a VMRUN is actually attempted.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 6 ++++++
 arch/x86/kvm/svm/svm.h    | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3aaa4f0bb31ab..93b3fab9b415d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -392,6 +392,10 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 		    CC(!(save->cr0 & X86_CR0_PE)) ||
 		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))
 			return false;
+
+		if (CC((save->cs.attrib & SVM_SELECTOR_L_MASK) &&
+		       (save->cs.attrib & SVM_SELECTOR_DB_MASK)))
+			return false;
 	}
 
 	/* Note, SVM doesn't have any additional restrictions on CR4. */
@@ -487,6 +491,8 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
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
2.53.0.473.g4a7958ca14-goog


