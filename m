Return-Path: <kvm+bounces-37387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58EBEA298F6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5BB1164B0B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409D921506F;
	Wed,  5 Feb 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CqAP90UN"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B9A1FECDC
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779896; cv=none; b=KwGtC7RXnn1PpRIUS/6QamgMyXQe+uBgPTM/Pdmq38VlsshAtMX+EEiVWM20enzCkW5UinD8kQRpNjVHV5ZmUuVcxp0zDAokblQbQV52Vc1McoX6j1W3YMn+jXCvp+hj5jt0H8hMPzBS+iKosNT0JK9GI/pe/YMIoVqVu6iPkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779896; c=relaxed/simple;
	bh=G8vnaOWQJ5Oj78kftPCmluJb4+vY84aUlbOf6mIvYHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmJYszxk90KXez2IRcU18p66i2N8eJA1mwDr4aXxfKxOgX/uvZCLNiE3FaG8mEhlqqLNe2ROGK244ZYhP8hp81Rmp1ak3xfNcrT7oQWVAyyuR8V3oIkJQSQIUfXGW5ZDkWtRiMrd9LAsn2yFKoBnB4U3eHjKOXPHlxN7bnKo6qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CqAP90UN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+aZxHkGDKGQVqlD/AOZPROKXjugIKgS0ANHq/kESss=;
	b=CqAP90UNeXqSyZD8+VjrVbhHejxIjyT3xxMfgHcrStUdktFl3WI/fg/Js7ETTtmvHefEeT
	WKCqFdv/FnvOXGuLZXH/RqPSgbGk7CB6AcCii/ohGGW4mj3O0gbLqpzznksn6lXtteewaf
	4CSQipKW0M9pftq3YQR7h8lP8PICE6M=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 11/13] KVM: nSVM: Do not reset TLB_CONTROL in VMCB02 on nested entry
Date: Wed,  5 Feb 2025 18:24:00 +0000
Message-ID: <20250205182402.2147495-12-yosry.ahmed@linux.dev>
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

TLB_CONTROL is reset to TLB_CONTROL_DO_NOTHING on nested transitions to
L2. This is unnecessary because it should always be
TLB_CONTROL_DO_NOTHING at this point.

The flow for setting TLB_CONTROL is as follows:
1. In vcpu_enter_guest(), servicing a TLB flush request may set it to
TLB_CONTROL_FLUSH_ASID in svm_flush_tlb_asid().
2. In svm_vcpu_run() -> pre_svm_run(), it may get upgraded to
TLB_CONTROL_FLUSH_ALL_ASID when assigning a new ASID.
3. In svm_cpu_run(), it gets reset to TLB_CONTROL_DO_NOTHING after the
guest is run.

Hence, TLB_CONTROL is reset after each run and there is no need to do it
again on every nested transition to L2.

There is a TODO in nested_svm_transition_tlb_flush() about this reset
crushing pending TLB flushes. Remove it, as the reset is not really
crushing anything as explained above.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 12bb391884299..8e40ff21f7353 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -512,12 +512,7 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 		svm->nested.last_asid = svm->nested.ctl.asid;
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 	}
-	/*
-	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
-	 * things to fix before this can be conditional:
-	 *
-	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
-	 */
+	/* TODO: optimize unconditional TLB flush/MMU sync */
 	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
@@ -536,7 +531,7 @@ static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
 	if (svm->nested.ctl.tlb_ctl == TLB_CONTROL_FLUSH_ALL_ASID)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 
-	/* See nested_svm_entry_tlb_flush() */
+	/* TODO: optimize unconditional TLB flush/MMU sync */
 	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
@@ -717,9 +712,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	/* Done at vmrun: asid.  */
 
-	/* Also overwritten later if necessary.  */
-	svm_clear_tlb_ctl_flush(vmcb02);
-
 	/* nested_cr3.  */
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
-- 
2.48.1.362.g079036d154-goog


