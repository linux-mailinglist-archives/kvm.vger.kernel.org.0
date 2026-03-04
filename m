Return-Path: <kvm+bounces-72627-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CC2jE3h7p2kshwAAu9opvQ
	(envelope-from <kvm+bounces-72627-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:23:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 668A81F8DDC
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 32E7630314C9
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9AF2F6170;
	Wed,  4 Mar 2026 00:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bXhmFLjX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E72EFDA4
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583752; cv=none; b=tdzKcuGTltcexRONiOgbfsb6BchrLqpwAxDXa+/ljetqHTkCfhCK3AoMQMOxsS8XBNwu0fmCqkFTzUFPIdkDGykL1PowUYOHNUCz+xsZCobtn1nN9gw4zXPK6PXce5K0q2UdKHJV+DBX8QoF7WQwTQIgCA7ryCa/xm7RyFI6GU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583752; c=relaxed/simple;
	bh=NPX7a4G73+QzySINrUOAjawzHqN9/zKfXL/heyEw3GA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rTPPaE0sXWLONwE2+sfHizIZ8/sDomGGXGn2EFUaFOTiKTaV/xqgLVRiY3lcbAFxbYTFNCBM+W9GPY76EWWYFWWhqYEBBwBpooDizz1Zse2Nk22LwhnEhRMq5+bFrRBA16fd7ge88o6sH+RdscFx0y3sWuNtfDvVe1Hxk3+7G9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bXhmFLjX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c70f137aa4aso3656874a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772583750; x=1773188550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kDpA+UvHfqu2KXcEE0BeLwUh8qWoHNo3iiEgddOUlSA=;
        b=bXhmFLjXMt+jLLcLnKC2YEU2Gnh2U1iyyAa8t65BE5dhOjbRzMMY4b344ChMsOSfMO
         tFq3Ef2v6rhqpSYBBVRwc9ecplKQ+pHU7e/593QMeaZnY1bFUbI7YVNhbo2DOr+DyvCv
         e3Gj4L/Hhpb0rmfr/aT3HazUyTYD2Ot00x/vzpod9/SZzPAkjA1/YRqFtEZm1Nvd/RTn
         5gl8H/PLZTFwJwxKvp8veQCsl4l/oADvwgex0MYsdDJPJerU76UFrL1j8Eh8RHPIdEWQ
         2/3MWAwNSo7elG1HRt9ILmL0LSkZ0iQGN+AfWJFOj5+RvOEjxPZp9EsYu4JsjFgDYhOZ
         ZdRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772583750; x=1773188550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDpA+UvHfqu2KXcEE0BeLwUh8qWoHNo3iiEgddOUlSA=;
        b=Lor/2XNDE65PvzaMKL5x3Ek6VQ5d5o6oGGdu9cIqNf6iTIdUgvQJOnbUHBLdPZQjiC
         Y8oNyw4EJt3u5Wk0GZ1KOlxFWE5+jnOnePr8VPbPY6qQ3SzryoWofY6+bll0QBlierxZ
         psXdwn6c18X3BP0gPPc/8l5V8uDQcmWQ+baB4+hADdRI/apkJry2HgmikW2VE/jMh782
         AAUBj2iXu9QjAzBA1OgBM9IjxL7ADkFVcIVSJvv4zBLGspiGkZaHFlsMxDsXpyY113KU
         rmOQMlr4fB6hBbjE7lA7JO9sjCZuiDfZZF1q0n0IH+7JOoqv5qq3kWYJQRuGzZKC1Lvj
         niqg==
X-Gm-Message-State: AOJu0YwHDdJBEXX91kfmKlb1UwB60e8rHjWp6igFNOgBiTFNHGCKT6/Z
	lwgMIkzuX3Yhmp88rFl4hD2qR95x33kNTJO2bAlrMeVIdeXYrB08wsb0Mb3bXjn1EPZQ8IYWVrP
	rv5KMNw==
X-Received: from pgpc1.prod.google.com ([2002:a63:a441:0:b0:bc0:ea34:538])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4598:b0:395:cb87:dd6b
 with SMTP id adf61e73a8af0-3982ded303emr99556637.28.1772583749893; Tue, 03
 Mar 2026 16:22:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:22:23 -0800
In-Reply-To: <20260304002223.1105129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304002223.1105129-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304002223.1105129-3-seanjc@google.com>
Subject: [PATCH v5 2/2] KVM: nSVM: Always intercept VMMCALL when L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 668A81F8DDC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72627-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Action: no action

Always intercept VMMCALL now that KVM properly synthesizes a #UD as
appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_INSN
is enabled.

By letting L2 execute VMMCALL natively and thus #UD, for all intents and
purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM always
intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
VMMCALL in response to the #UD by trying to fixup the opcode to the "right"
vendor, then restarts the guest, without skipping the VMMCALL.  As a
result, the guest sees an endless stream of #UDs since it's already
executing the correct vendor hypercall instruction, i.e. the emulator
doesn't anticipate that the #UD could be due to lack of interception, as
opposed to a truly undefined opcode.

Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL into host")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/hyperv.h | 4 ----
 arch/x86/kvm/svm/nested.c | 7 -------
 2 files changed, 11 deletions(-)

diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 9af03970d40c..f70d076911a6 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else /* CONFIG_KVM_HYPERV */
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
-static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
 static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 750bf93c5341..2ac28d2c34ca 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -156,13 +156,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
 			vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
-	/*
-	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
-	 * flush feature is enabled.
-	 */
-	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
-		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
-
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		c->intercepts[i] |= g->intercepts[i];
 
-- 
2.53.0.473.g4a7958ca14-goog


