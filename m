Return-Path: <kvm+bounces-72268-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIX1DIZiommN2gQAu9opvQ
	(envelope-from <kvm+bounces-72268-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:35:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A26E21C0241
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A413230EE47E
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 03:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3717D2E2665;
	Sat, 28 Feb 2026 03:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aVcInqJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587DA2DF707
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772249620; cv=none; b=a6LgEiVl8Zke6ZzPSNZLENTXmkZU0DftkC3gVcREl5BqSONhscIj9dlwF8FkirOK0tOoAFqF/Y8g9DL/fNaJzEGgnk+ufNZHDIpnGx7DCQKQFhSl6cUi3hSq4DXEaOs65nuVB0P6O6KFvKL71OsNJCejm4ygVyQAsyjbRqnJ6tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772249620; c=relaxed/simple;
	bh=/lCxiHbvKeja+uJyJNRaWhTwWnRWmN3ecTB1MEqsjPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f5QdRyCGYVPiTCnaAChy/5L4dulDIR3f317Sswzs5iyjLzba488Hqdsp4Pe9O7MXGRvKIVgTOpb4LjM/8CXyl4YUCet0IDp+QF3R1nf2d8TlrOLH+/xdkWaTMUC1oDbPxjnNAaDuSZwqYLhfBjxth01q2lnOOUHscq+7cPN+Ckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aVcInqJu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aae146bab0so39713605ad.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 19:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772249619; x=1772854419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzK+ahrN0WrI65Z8BtzgCkPZKdVkUFBx57SYFZxh0S8=;
        b=aVcInqJullGrn8lOqBWKmJSXiZiCYX8JJuMsK2j3Xs7MdYwl59Tl/RP2sWt402/9Sp
         eXpFqAQxWi7lADL0JFOTU3+tblhmrp72YwsjsQAftjtvD18s2er3jNH4+PuQfuaIScXA
         spQOstvGflDaiwFdrlPhRzQdMv65kosbtbjzN+ro7esGKC4WaZ0P3H5ww25FOmhqJ9KN
         zOouHD3n0RXubNxBsA7/llhenCbn5sMNRbqJYkSlbqoVTPazFuj0FkttFB7At2Yqy58g
         ppB12taDb8e5EtmHoNQTXMeVeK6i3w/9W6kzEM62TLz6j9yXxP9trajNlilPy4QLBWnV
         OK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772249619; x=1772854419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzK+ahrN0WrI65Z8BtzgCkPZKdVkUFBx57SYFZxh0S8=;
        b=CGLfszDBEjb7vPqbtft3MoLHtDVCKGHdezTi79IpPK2cRhF4l7WKPTUcrInejtSaIk
         JXCJFHL1/I4KNsyJY5En8rNb+bQlvf0qlwrqsPgty3yiUS+Bz7w82AAKPXlPzGoxsURT
         KLkbrMrrkTOTsHj6urD5kc2gIx1QaplLwCHVbMA+yXhdatD1qItE8+8ZO0XNpb9wDVdm
         gEGrjYWtUjAvp+7Ez2O0HigLaN908iq0tLbY1n/3m9VHVHe5FR6f+L5NkrcgONshZobv
         H6ghGN2TQxqorG+wLfBfZi/Kf38TBxkTx5NRYXzHZhciRtuevMuYR8+nXyevbdJHWA/y
         k/rQ==
X-Gm-Message-State: AOJu0YzWjyR0pcehJfKhqWpxp4mbG4nRQ66NG1NT7yv32EXzB3IyzDgN
	ArBavjL3s5oBAc5y3mL8oWHk/LRcdW7fWd1+9wu/LRNr3tk9GZ2B+6Byc5PnrXCLuaNwHIRrTsF
	rYFZwoOvsA1hSaQ==
X-Received: from plkg16.prod.google.com ([2002:a17:903:19d0:b0:298:1151:5f6d])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:18b:b0:2ad:da26:c2c4 with SMTP id d9443c01a7336-2ae2e3ce810mr48921795ad.9.1772249618503;
 Fri, 27 Feb 2026 19:33:38 -0800 (PST)
Date: Sat, 28 Feb 2026 03:33:28 +0000
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228033328.2285047-5-chengkev@google.com>
Subject: [PATCH V4 4/4] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry@kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72268-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A26E21C0241
X-Rspamd-Action: no action

The AMD APM states that if VMMCALL instruction is not intercepted, the
instruction raises a #UD exception.

Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
from L2 is being handled by L0, which means that L1 did not intercept
the VMMCALL instruction. The exception to this is if the exiting
instruction was for Hyper-V L2 TLB flush hypercalls as they are handled
by L0.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/hyperv.h | 11 +++++++++++
 arch/x86/kvm/svm/nested.c |  4 +---
 arch/x86/kvm/svm/svm.c    | 19 ++++++++++++++++++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index d3f8bfc05832e..9af03970d40c2 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -41,6 +41,13 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
 	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
 }

+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
+	       nested_svm_l2_tlb_flush_enabled(vcpu) &&
+	       kvm_hv_is_tlb_flush_hcall(vcpu);
+}
+
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else /* CONFIG_KVM_HYPERV */
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
@@ -48,6 +55,10 @@ static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu) {}
 #endif /* CONFIG_KVM_HYPERV */

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd5..45d1496031a74 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1674,9 +1674,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	}
 	case SVM_EXIT_VMMCALL:
 		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
-		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
-		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
-		    kvm_hv_is_tlb_flush_hcall(vcpu))
+		if (nested_svm_is_l2_tlb_flush_hcall(vcpu))
 			return NESTED_EXIT_HOST;
 		break;
 	default:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f8f9b7a124c36..d662d5ce986ac 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -52,6 +52,7 @@
 #include "svm.h"
 #include "svm_ops.h"

+#include "hyperv.h"
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"

@@ -3258,6 +3259,22 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
 	return 0;
 }

+static int vmmcall_interception(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Per the AMD APM, VMMCALL raises #UD if the VMMCALL intercept
+	 * is not set. For an L2 guest, inject #UD as L1 did not intercept
+	 * VMMCALL, except for Hyper-V L2 TLB flush hypercalls as they
+	 * are handled by L0.
+	 */
+	if (is_guest_mode(vcpu) && !nested_svm_is_l2_tlb_flush_hcall(vcpu)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	return kvm_emulate_hypercall(vcpu);
+}
+
 static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -3308,7 +3325,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
 	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
 	[SVM_EXIT_VMRUN]			= vmrun_interception,
-	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
+	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
 	[SVM_EXIT_VMLOAD]			= vmload_interception,
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
--
2.53.0.473.g4a7958ca14-goog


