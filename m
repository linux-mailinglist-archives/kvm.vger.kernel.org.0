Return-Path: <kvm+bounces-66032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E89CBF96C
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48BA3305958C
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0FB33E349;
	Mon, 15 Dec 2025 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O0Wh4LLY"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F59E33DEE9
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827028; cv=none; b=sYkyohMQQ6zBPD3xK0hHWC1rAkmR6ZLfA0M0qxBVphXTTmFzNN8p0vy1gW7lSljWg/nZC4Ya9DyPvNBZl1vlxhNInIShr6HCjTLBGPyEiMJ+vXIju59oJGgWvI/spRR55sUHeB08vNhgISx5TVYLk1ZlGTHMwvZiWabZBjeQ2+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827028; c=relaxed/simple;
	bh=TmAIHFIBy67IQq6UqFfKfKWIKkOc3mEymWWssMf11tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYURr1+g5fKMT/W2S0m7CjnmF2fYo39WdJEVf2sBMhNu+ssb5hZRVCl3A0VJfF2lDjU2Z3MguWbO2CEptkWTmkvY8BUH6xlnWMuRbTwM7qLL6KuR8qSetBa2P+6jbmg2fPOqTTQQd/p9X55j1VS1EBzPVF3iCdj5vLM28vzdkbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O0Wh4LLY; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765827020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWrJEh8Nktie/iD1iDW/0p+teecaOKksnLMwXSZBOC0=;
	b=O0Wh4LLYRNuUX2JJSHPF8u7dJGfrh96D37+8FCxCXMf9uFR73NfEapRADNP/mT8PqM5E4k
	PJydUXFPsw0KtOcuuIDo/HimCGD40DoCq8G70LazA09FJH0OKXLuAO+6aIsbpUSsJi6MCb
	Jb+z4ThEDnSRCHr15IR+NzLc/qO/ZrI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v3 26/26] KVM: nSVM: Only copy NP_ENABLE from VMCB01's misc_ctl
Date: Mon, 15 Dec 2025 19:27:21 +0000
Message-ID: <20251215192722.3654335-28-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
only bit that needs to copied is NP_ENABLE, as all other known bits in
misc_ctl are related to SEV guests, and KVM doesn't support nested
virtualization for SEV guests.

Only copy NP_ENABLE to harden against future bugs if/when other bits are
set for L1 but should not be set for L2.

Opportunistically add a comment explaining why NP_ENABLE is taken from
VMCB01 and not VMCB02.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2f1006119fe7..7af701e92c81 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -820,8 +820,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 						V_NMI_BLOCKING_MASK);
 	}
 
-	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
-	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
+	/*
+	 * Copied from vmcb01.  msrpm_base can be overwritten later.
+	 *
+	 * NP_ENABLE in vmcb12 is only used for consistency checks.  If L1
+	 * enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If L1
+	 * disables NPT, KVM runs L2 with the same NPTs used to run L1. For the
+	 * latter, L1 runs L2 with shadow page tables that translate L2 GVAs to
+	 * L1 GPAs, so the same NPTs can be used for L1 and L2.
+	 */
+	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
 	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
 	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
 	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
-- 
2.52.0.239.gd5f0c6e74e-goog


