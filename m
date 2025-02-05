Return-Path: <kvm+bounces-37388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B73A298F8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02F2B18858AF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 18:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463B12153D5;
	Wed,  5 Feb 2025 18:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UD97/NXJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40A8215061
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 18:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738779897; cv=none; b=T2uhaLBNIIbwHlqHN9IhdtNBLCsD9qCp79CkmFoKQnOyD/FNghz/K+FuRFY9dG/BeRrry1Z+SlSN92eLmMOQqxSsrwT+E3r3t5Eh1o77dewng3xuwOY2SXZbyxGLOTXqjqVGHwqakW0v+vhchmyq0xuPZyo3YGfi3RQPaiSLRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738779897; c=relaxed/simple;
	bh=tlOgXnaqKp9NUL+LXoFpiVzobJNqv5f08XPkh3OR01g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ms92UnNbx6zMnMWS7gdULZ+abDYRBCBu+rHg5EOdAYDweZsyR5yyihbtNYe2pwIjFAKoQZVPzYmGo6TMNEgqIdBLAizwuIQlzy0Re2mh4jqoFGVOlaIM7zSW6OSC5egEI1HNViSFcSgJ3neXNIyx/NSXFPrP4O8McnlTUwRDG60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UD97/NXJ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738779894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wkp6NpfUIvQgIoWnkXuz59xSTMhu75OTgY4oeK1GYRA=;
	b=UD97/NXJGvSJt2fE2zbn0hCtPHezCKTJ92bbca+FHrrqM+TyfBFw8AP6tv7HUdN6DtoJCB
	jjwZtx5gVVsk2OK6Yc8+JU8y89pPU6tGQydwcGUwo8EWGqxE9jHeYbl4Z0NgQ1izG8EO0w
	MRd7rm+/lDrrZ6onq+T/CVlGV3SsE/s=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 12/13] KVM: nSVM: Service local TLB flushes before nested transitions
Date: Wed,  5 Feb 2025 18:24:01 +0000
Message-ID: <20250205182402.2147495-13-yosry.ahmed@linux.dev>
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

KVM does not track TLB flush requests for L1 vs. L2. Hence, service
local flush that target the current context before switching to a new
one. Since ASIDs are tracked per-VMCB, service the flushes before every
VMCB switch.

This is conceptually similar to how nVMX calls
kvm_service_local_tlb_flush_requests() in
nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(), with the
following differences:

1. nVMX tracks the current VPID based on is_guest_mode(), so local TLB
   flushes are serviced before enter_guest_mode() and
   leave_guest_mode(). On the other hand, nSVM tracks the current ASID
   based on the current VMCB, so the TLB flushes are serviced before an
   VMCB switch.

2. nVMX only enters and leaves guest mode in
   nested_vmx_enter_non_root_mode() and nested_vmx_vmexit(). Other paths
   like vmx_set_nested_state() and vmx_leave_nested() call into these
   two functions. On the other hand, nSVM open codes the switch in
   functions like svm_set_nested_state() and svm_leave_nested(), so
   servicing the flush in svm_switch_svm() is probably most reliable.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5e7b1c9bfa605..6daa7efa9262b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1421,6 +1421,12 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 {
+	/*
+	 * ASIDs are tracked per-VMCB. Perform any pending TLB flushes for the
+	 * current VMCB before switching to a new one.
+	 */
+	kvm_service_local_tlb_flush_requests(&svm->vcpu);
+
 	svm->current_vmcb = target_vmcb;
 	svm->vmcb = target_vmcb->ptr;
 }
-- 
2.48.1.362.g079036d154-goog


