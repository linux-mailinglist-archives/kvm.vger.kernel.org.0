Return-Path: <kvm+bounces-37379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EF2A298E2
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C53C21884C00
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9CC01FFC5D;
	Wed,  5 Feb 2025 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y7NDq911"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251651FF1B9
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779871; cv=none; b=ubf0I4A9HZkviwbixdFkWFxGF2ROBnNGfuyXKJuSOTWAtsLlnBJt9n4Ufmg/gtL6w6lwF2/NMGO6XobOjHb+0AVTICD+L6TLbSIqyf7zZtL9/FC5FlnX5hXQcxUH6cdon0T3yd7cd2y6Mhcigo7O1ldiZHTKa90egJ+U7TOotHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779871; c=relaxed/simple;
	bh=y0ETfi4XxlyM14bktngNlCHmHhFeNkK4dgV/ueMQpq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9NhsWeoxfQ2zF6z486Ssdkrr8haRt+7GyoBVmSzrxtCtGHXjt3ph7ViexushcleUQnoSgFfv2cmKpd7tVFm+YLyNMPJWeDKy2xO7/doMQWnaprbIve8ZxbgmYzK5ufLnzAJE0vCGYRTZvKloPdugB0dQGs+q8IBPFXMY9QEysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y7NDq911; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3IxGgLbg8MJVF0QNKewRjo2LHkpbHKqZR8+vO+mj01Q=;
	b=Y7NDq911WyabGgas+JmWUKo3HC5yqM4hDYmWnVZulr7ECW0ZQ+5keifiDDp6CANFYKF+Qo
	N9fhl2GIhBmW7nf8imgUqsqp5hZ4DC0W/mnmHo9wc97BiZMZdA9sm41ZWl1tK+3of7Nwii
	C46vGj5RTtQrLvYTzRM96qqoqy46B3g=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/13] KVM: nSVM: Split nested_svm_transition_tlb_flush() into entry/exit fns
Date: Wed,  5 Feb 2025 18:23:52 +0000
Message-ID: <20250205182402.2147495-4-yosry.ahmed@linux.dev>
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

The handling for the entry and exit TLB flushes will diverge
significantly in the following changes. Instead of adding an 'is_vmenter'
argument like nested_vmx_transition_tlb_flush(), just split the function
into two variants for 'entry' and 'exit'.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bbe4f3ac9f250..2eba36af44f22 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -482,7 +482,7 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 	vmcb12->control.exit_int_info = exit_int_info;
 }
 
-static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
+static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	/* Handle pending Hyper-V TLB flush requests */
 	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
@@ -503,6 +503,16 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
+static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
+{
+	/* Handle pending Hyper-V TLB flush requests */
+	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
+
+	/* See nested_svm_entry_tlb_flush() */
+	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+}
+
 /*
  * Load guest's/host's cr3 on nested vmentry or vmexit. @nested_npt is true
  * if we are emulating VM-Entry into a guest with NPT enabled.
@@ -645,7 +655,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	u32 pause_count12;
 	u32 pause_thresh12;
 
-	nested_svm_transition_tlb_flush(vcpu);
+	nested_svm_entry_tlb_flush(vcpu);
 
 	/* Enter Guest-Mode */
 	enter_guest_mode(vcpu);
@@ -1131,7 +1141,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	kvm_vcpu_unmap(vcpu, &map);
 
-	nested_svm_transition_tlb_flush(vcpu);
+	nested_svm_exit_tlb_flush(vcpu);
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-- 
2.48.1.362.g079036d154-goog


