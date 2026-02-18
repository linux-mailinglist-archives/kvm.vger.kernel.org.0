Return-Path: <kvm+bounces-71292-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LgEB6dHlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71292-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:13:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3ED015AD66
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13FDF30A3511
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7146F33B6FC;
	Wed, 18 Feb 2026 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iwMV5LUg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65AB33ADA8
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456218; cv=none; b=gyqjBUW/Fy97nwPPqsLoMQ2YAXFYEu3zgbbZmiJZFrhooVvMynLnKPkV9nkPobw32zjI2lqhzDSz5oA8P0Gu6mA/gapUeyG+xP6UbcPJ7YV76nfYQGJ/yx1r0x85uej/5WbRtpbgacmock4DcYh1cAh8INbNK5JV7J8fOwGDARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456218; c=relaxed/simple;
	bh=NMDuvD7HrMiDW7irrkEtcqX9feVJnOUeWUwcpv6qmIw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K01PJuVT0knraUdJD73Of60iskCjgejfw/qwwB7aqOt5MqfFHEGqkFXasSVw8gxpCgw6sU55+xXMl6+tKsATVZd06Wm4yp5YbVOabqBMDOXxOyFeEwg2Z5Rykv1h6IWXOpZLmeHVEf8HgPcdWGJxv+IHzML3TjOSyYOJqbvWF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iwMV5LUg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a79164b686so3887065ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456216; x=1772061016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LLLEX7R/aRYWwzEE41grxY+H/LHczaoT3FkuhfJMqq4=;
        b=iwMV5LUgopwy6STRvmLJJ/3+mGb94X2kjz10QcjvZ9ffN9nHnDV3Q7y+/EXo8LHQdO
         T1uLFMnHuzPEYatDar+qXL8TYbtKkwn4Xrvy2J/+L3ZDDzkuQSjyBNVuN4X1YwLDVDAg
         Ga3EpKcPlF2i8vkOq5d4XaOpsin/9KyixgXt5zWYbz/pSjefhKreyuA7PsVvW6bSbrdI
         B2E+Uxw9W0fqPrKesICRlMe61NlgLdD6KCYQR5bxUOI8G7hBYLGF9PjsJbOUVYn0bZnJ
         QowJX+9sf5N/eMxwxwmGwe1ixQDvZo1jIT77GIz5py09CGjJDNtRM9++nAJpG1MofN/t
         btNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456216; x=1772061016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLLEX7R/aRYWwzEE41grxY+H/LHczaoT3FkuhfJMqq4=;
        b=JUC1o7LtYZW3bi5ZMDmzwje5VGC5/9cfj3U9SfE7NgJoaxTqX00Fs5Rfzwxqp4SPvb
         l2SKCxbFm9cSIvFFIDOgQK8cpMvcfbBa2fzhXylF73Z6BkOuyPAjV0SEW4VEmriLQKTC
         I8mbVmR7ZpVlZFppkKDzPtL+Qhxu6b8HIIf5TZrGySxLMud2q5zlBEJg+tMuACoVqZJa
         DsuvRBHRQF9ouLubAOXVeAe+tNff7uyYD+3SDPv0Lfnsr4ATb6rR1O7ZaGaup4V2X3fU
         nGYp+LevsyiAlBHvdVUwQxUwBAae8V2/D+e60CAXBZ9m6+eMmsX1ZZ2xclEfgsVi3IQx
         cMWw==
X-Gm-Message-State: AOJu0Yw6zPqZR78PNc2epk78K+0pIITCcWHmeecvf0LGDoMZwTNa5Ad8
	g6nv1HTS5y5fxEialqSXfWV6UFkIIo+4/74K3wzzoDFrQ2NeSRn7/zZ8XjkoaJee0txY+9W9yYe
	SGuSvKw==
X-Received: from plw19.prod.google.com ([2002:a17:903:45d3:b0:2a7:6eb5:7e30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:910:b0:2a9:4450:abb7
 with SMTP id d9443c01a7336-2ad50f6378fmr28512385ad.39.1771456215835; Wed, 18
 Feb 2026 15:10:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:58 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-9-seanjc@google.com>
Subject: [PATCH v2 8/8] KVM: nSVM: Capture svm->nested.ctl as vmcb12_ctrl when
 preparing vmcb02
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71292-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A3ED015AD66
X-Rspamd-Action: no action

Grab svm->nested.ctl as vmcb12_ctrl when preparing the vmcb02 controls to
make it more obvious that much of the data is coming from vmcb12 (or
rather, a snapshot of vmcb12 at the time of L1's VMRUN).

Opportunistically reorder the variable definitions to create a pretty
reverse fir tree.

No functional change intended.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bcd6304f3c0c..1814522db6b4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -745,11 +745,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
 
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct vmcb_ctrl_area_cached *vmcb12_ctrl = &svm->nested.ctl;
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
-	u32 pause_count12;
-	u32 pause_thresh12;
+	struct vmcb *vmcb01 = svm->vmcb01.ptr;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u32 pause_count12, pause_thresh12;
 
 	nested_svm_transition_tlb_flush(vcpu);
 
@@ -762,7 +762,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 */
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VGIF) &&
-	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
+	    (vmcb12_ctrl->int_ctl & V_GIF_ENABLE_MASK))
 		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 	else
 		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
@@ -820,10 +820,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	if (nested_npt_enabled(svm))
 		nested_svm_init_mmu_context(vcpu);
 
-	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
-			vcpu->arch.l1_tsc_offset,
-			svm->nested.ctl.tsc_offset,
-			svm->tsc_ratio_msr);
+	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(vcpu->arch.l1_tsc_offset,
+							   vmcb12_ctrl->tsc_offset,
+							   svm->tsc_ratio_msr);
 
 	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
 
@@ -832,13 +831,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		nested_svm_update_tsc_ratio_msr(vcpu);
 
 	vmcb02->control.int_ctl             =
-		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
+		(vmcb12_ctrl->int_ctl & int_ctl_vmcb12_bits) |
 		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
 
-	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
-	vmcb02->control.int_state           = svm->nested.ctl.int_state;
-	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
-	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
+	vmcb02->control.int_vector          = vmcb12_ctrl->int_vector;
+	vmcb02->control.int_state           = vmcb12_ctrl->int_state;
+	vmcb02->control.event_inj           = vmcb12_ctrl->event_inj;
+	vmcb02->control.event_inj_err       = vmcb12_ctrl->event_inj_err;
 
 	/*
 	 * next_rip is consumed on VMRUN as the return address pushed on the
@@ -849,7 +848,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * prior to injecting the event).
 	 */
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
-		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
+		vmcb02->control.next_rip    = vmcb12_ctrl->next_rip;
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
 
@@ -859,7 +858,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
 		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
-			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
+			svm->soft_int_next_rip = vmcb12_ctrl->next_rip;
 		else
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
@@ -870,11 +869,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
-		pause_count12 = svm->nested.ctl.pause_filter_count;
+		pause_count12 = vmcb12_ctrl->pause_filter_count;
 	else
 		pause_count12 = 0;
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PFTHRESHOLD))
-		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
+		pause_thresh12 = vmcb12_ctrl->pause_filter_thresh;
 	else
 		pause_thresh12 = 0;
 	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
@@ -888,7 +887,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
 
 		/* ... but ensure filtering is disabled if so requested.  */
-		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
+		if (vmcb12_is_intercept(vmcb12_ctrl, INTERCEPT_PAUSE)) {
 			if (!pause_count12)
 				vmcb02->control.pause_filter_count = 0;
 			if (!pause_thresh12)
@@ -905,7 +904,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * L2 is the "guest").
 	 */
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
-		vmcb02->control.erap_ctl = (svm->nested.ctl.erap_ctl &
+		vmcb02->control.erap_ctl = (vmcb12_ctrl->erap_ctl &
 					    ERAP_CONTROL_ALLOW_LARGER_RAP) |
 					   ERAP_CONTROL_CLEAR_RAP;
 
-- 
2.53.0.345.g96ddfc5eaa-goog


