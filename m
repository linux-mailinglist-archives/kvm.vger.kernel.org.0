Return-Path: <kvm+bounces-42067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F6CA71F85
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B22C3BC721
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F1B19E804;
	Wed, 26 Mar 2025 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lNOhrmSM"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076DC253B59
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018301; cv=none; b=VexsAE+QNm/wX1msTDjxgAgYxR0PLrJEXxJ+Une+cd/VHz0UGCdq/yPsDFHMRNFrKBPlf2vrkoHvad4T7ymfnc1xP+gWAofHiJ9C0g7O7K8gwV/T2jeCM0HZ7cecSqP1aRd9pBALqRV7XfCzi8DtL9eVA514IM3tQL6kbC89wXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018301; c=relaxed/simple;
	bh=06W+xjBikL2e5WSjyl9hv6fa9JUDpIOERb5aLSLgzls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC2iuUfuYIbSCkALXkGBkBLRidWbhKPHuxsotNxZ6HV8MIrIwBk718/89i5/JH4Ko2Cw9qK1JcdjsC88q6fvPUrp8mmD28fMeroijVeUhrUbc6zXSM1ziYq+5BZ7XKSLlyub7mOz4VGTHtObhW+tAHXimKZQUOcOett1Nk4B3Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lNOhrmSM; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743018298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0gdv8+DAFVCBWhKiUPDk4OG8SS8ISgvrrX6Fqg7BSIU=;
	b=lNOhrmSMGI4n0kZrbN2GAOIC03vpuqYcTl8BM296Sri5T+qXcL1Lx662bG8mQrdGVeE/Nb
	ts5Q7QpC4MVw9zlXuE66GvbnDuTRTrGIIxjr7OGXVu8UT1lHYC4BlXiHFhrZhvuR77Db2v
	VQwkpOQSBsfqUX/B0Yj8wYB2VdJZyD8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 21/24] KVM: nSVM: Service local TLB flushes before nested transitions
Date: Wed, 26 Mar 2025 19:44:20 +0000
Message-ID: <20250326194423.3717668-2-yosry.ahmed@linux.dev>
In-Reply-To: <20250326194423.3717668-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM does not track TLB flush requests for L1 vs. L2. Hence, service
local flush that target the current context before switching to a new
one. Since the current ASID is identified through the current VMCB
(nested or not), service the flushes before every VMCB switch.

This is conceptually similar to how nVMX calls
kvm_service_local_tlb_flush_requests() in
nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
following differences:

1. VMX tracks the current VPID based on is_guest_mode(), so local TLB
   flushes are serviced before enter_guest_mode() and
   leave_guest_mode(). On the other hand, SVM tracks the current ASID
   based on the current VMCB, so the TLB flushes are serviced before an
   VMCB switch.

2. nVMX only enters and leaves guest mode in
   nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
   like vmx_set_nested_state() and vmx_leave_nested() call into these
   two functions. On the other hand, nSVM open codes the switch in
   functions like svm_set_nested_state() and svm_leave_nested(), so
   servicing the flush in svm_switch_svm() is probably most reliable.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3e33ac876eb32..3649707c61d3e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1439,6 +1439,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 {
+	/*
+	 * The current ASID is identified through the VMCB.  Perform any pending
+	 * TLB flushes for the current VMCB before switching to a new one.
+	 */
+	kvm_service_local_tlb_flush_requests(&svm->vcpu);
+
 	svm->current_vmcb = target_vmcb;
 	svm->vmcb = target_vmcb->ptr;
 }
-- 
2.49.0.395.g12beb8f557-goog


