Return-Path: <kvm+bounces-37384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1569FA298F0
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 983031882817
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7743214239;
	Wed,  5 Feb 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fXu3/Omx"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA281FE455
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779878; cv=none; b=rtRNaMV/DpqZX5GbH34t+n7MD/dbVir6Pb5iW31eGY4iq3a4yeNnuayizxPZwiyeDpqOYG29LHT6xmA0uAwLHLHX+mEv0SRnTXptFqoR99rOk/Les8zYtvI/hPASnNG1haA/m1GyEbUJJmsVQLFTIlvxlTR7ucoJ7Kow6u1sKYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779878; c=relaxed/simple;
	bh=h4MbKQQTqAjzHmrKLlep4WU41WTJGnth1WFuNMwjcy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdO75jJXxo4Y0ugU/nWLdqSFapEb+FK5DVKSnqBdf5ykl6OjEytVyOj28YgKcy18nHwoxRuzTvMsRFalVOgI551YFESl3IKMXt5BjQTquBaz4zZQhzCDfXJ4jDFIZ2pmwWngIz4tSH/m/V1N1IPXKI5/JJOnqHhvwclWeph7DDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fXu3/Omx; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7l1Q8RiV52bQukEA9QV4TzD72aVSvrPFZT5jtx/k5qI=;
	b=fXu3/Omxtd7C5jp6v+NCR/mH9LGxXvrUbCwc1kExAyT3rx7OhT/2agJPeeIl/3WnZy2SJd
	NMWKovwBx/kc5ysPRB7XKpks9Ny2V9ebpzuu2VArEV2PNJ5K/o/1plqYE4t/Yya3L/s5tA
	iAkX+uRXLxwQCvpOfm/pTvvhbYjLQZw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/13] KVM: nSVM: Flush both L1 and L2 ASIDs on KVM_REQ_TLB_FLUSH
Date: Wed,  5 Feb 2025 18:23:57 +0000
Message-ID: <20250205182402.2147495-9-yosry.ahmed@linux.dev>
In-Reply-To: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM_REQ_TLB_FLUSH is used to flush all TLB entries for all contexts
(e.g. in kvm_flush_remote_tlbs()). Flush both L1 and L2 ASIDs in
svm_flush_tlb_all() to handle it appropriately.

This is currently not required as nested transitions do unconditional
TLB flushes, but this is a step toward eliminating that.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 1 -
 arch/x86/kvm/svm/svm.c    | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 0e9b0592c1f83..0735177b95a1d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -491,7 +491,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
 	 *
-	 *  - Flush TLBs for both L1 and L2 remote TLB flush
 	 *  - Honor L1's request to flush an ASID on nested VMRUN
 	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
 	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e29f87d3bd93..8342c7eadbba8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4044,7 +4044,9 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
 		hv_flush_remote_tlbs(vcpu->kvm);
 
-	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
+	svm_flush_tlb_asid(vcpu, &svm->vmcb01);
+	if (svm->nested.initialized)
+		svm_flush_tlb_asid(vcpu, &svm->nested.vmcb02);
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
-- 
2.48.1.362.g079036d154-goog


