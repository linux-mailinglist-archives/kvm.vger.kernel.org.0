Return-Path: <kvm+bounces-71286-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kAuFFhBHlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71286-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF00215AD29
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:11:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 579053066BD8
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79D833AD96;
	Wed, 18 Feb 2026 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hR22eUF+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DBA33A9F2
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456207; cv=none; b=MwKaOffPmjlhcF1SYbkDwlOPQHoHxHBxiyaEnmcK2DbYFpYrees130+YLpjJGnR+rFaDLIlikXF/h919w4KY32tIHVQtpDR/Ir4gLj62P/i4RLOnkL0JPg0DSJM/VZlW1lHNVe0j4rk1+EaZsXwM0A9F74oCFUDf7LlKQ8cydgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456207; c=relaxed/simple;
	bh=tM8BjxTRUaM9RBki5MGlHN9TGhISx29jk5LkEA8/YTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X1uUPy/QeYQjLaY+5h5VhmHIFzGRJaswOWUfvTMFQl8lcdpiHRAcmrEam7SNRH5GceeqHfzvpVKbq/bmUR3qb/CRKDULLcCJWadUfYT7Z4ZKWrzmNx8/TB1KDm6YPfQOZe/dIZJdr/EUQAEmG6491ya2McAAtrkfrGeu4gjL2Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hR22eUF+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7b7f04a11so16163005ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456205; x=1772061005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BUA1fpDExNjo2szFuuW5OFhmaYWnSXBuESu8pBSWCgY=;
        b=hR22eUF+8g7QtEJBq7VOsz2TXrp+uV5NPHAoKQt4yQj0syvVNug4hhD79rFkdzUmHb
         UHP5mvr/jRus8TS2kls8fzii7+PvcPJvr07rowqlVx1Q5PAK0h12tcv6KY/MrrB7fDVw
         48el9qr5wjJ/UrGKkChvbH7SJuCcNaOVZpL22kammEcR0Qjc+zlcJQsQEweGhSwc2D80
         59IiRwFWImQvOUOZqTA3ZL6hSF7nICOmUw8mZPcVEsAfXrxIpr8cE9bNkgP8ci6p+EN0
         xCm3v90ITH6OVFTeW/sPg9293+2v1gF6+MN/i0xdEDGupHfV0hm/jdh5Xxcq8NdfoGXr
         APOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456205; x=1772061005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BUA1fpDExNjo2szFuuW5OFhmaYWnSXBuESu8pBSWCgY=;
        b=Ws8Qr3PRFaRb9ArVRqcSQ4Xqsz6FEVaFi/WzusbXN2wsfq5iJRQKT2daIkgzjOJvBJ
         gUXxpAgoMNWrFZgo2oktz/O/oJclsBsrT+uJ+99PYWnEgLDpPiL21elVacfx29bh9npe
         Tg/5H2w54QGnztT4sSWePLJVYfVilnFw++R0tP3X9297k050MZQaxyqmeO1bpr21ehQZ
         IdmUM0/0xTt0mzUXAh4010RobrMfiQa2X1soAjETr4tjQnxBpU11eL0I65z9cE7anudu
         k6RVsHhTwnmiM1FLmvgN8tH1Uk619y2gCts0/b4CqfIHQRBUXh3WqyZOWa3RH+e5q6u6
         OACA==
X-Gm-Message-State: AOJu0Yywu664UX4lJY/C6+poXdPSZWz4Pq2LU3jiVjEp0T9/7P+tYkQA
	mrpYTCqIXHNCsHhMERQvJwcLB1udCuoORcDTJ5YTazrVB3NuHVqBAHgeh1lukItI0VW2tGLQl0Y
	28+nTlg==
X-Received: from plbbb9.prod.google.com ([2002:a17:902:bc89:b0:2a8:fb03:a261])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f68d:b0:2aa:e6fa:2f6c
 with SMTP id d9443c01a7336-2ad50ebcee5mr32304845ad.24.1771456205026; Wed, 18
 Feb 2026 15:10:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:52 -0800
In-Reply-To: <20260218230958.2877682-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260218230958.2877682-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-3-seanjc@google.com>
Subject: [PATCH v2 2/8] KVM: SVM: Separate recalc_intercepts() into nested vs.
 non-nested parts
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
	TAGGED_FROM(0.00)[bounces-71286-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: AF00215AD29
X-Rspamd-Action: no action

Extract the non-nested aspects of recalc_intercepts() into a separate
helper, svm_mark_intercepts_dirty(), to make it clear that the call isn't
*just* recalculating (vmcb02's) intercepts, and to not bury non-nested
code in nested.c.

As suggested by Yosry, opportunistically prepend "nested_vmbc02_" to
recalc_intercepts() so that it's obvious the function specifically deals
with recomputing intercepts for L2.

No functional change intended.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c |  9 ++-------
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  4 ++--
 arch/x86/kvm/svm/svm.h    | 26 ++++++++++++++++++++------
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 66701106a51b..48b60dd6e7a3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -122,17 +122,12 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 	return false;
 }
 
-void recalc_intercepts(struct vcpu_svm *svm)
+void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *c, *h;
 	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
-	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
-
-	if (!is_guest_mode(&svm->vcpu))
-		return;
-
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 
 	c = &svm->vmcb->control;
@@ -918,7 +913,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
 	 */
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..03b6dc75a6e8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4639,7 +4639,7 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm, bool init_event)
 	if (!sev_vcpu_has_debug_swap(svm)) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-		recalc_intercepts(svm);
+		svm_mark_intercepts_dirty(svm);
 	} else {
 		/*
 		 * Disable #DB intercept iff DebugSwap is enabled.  KVM doesn't
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..9e76bf1671da 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -635,7 +635,7 @@ static void set_dr_intercepts(struct vcpu_svm *svm)
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static void clr_dr_intercepts(struct vcpu_svm *svm)
@@ -644,7 +644,7 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..92a1691dc7be 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -357,8 +357,6 @@ struct svm_cpu_data {
 
 DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
-void recalc_intercepts(struct vcpu_svm *svm);
-
 static __always_inline struct kvm_svm *to_kvm_svm(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_svm, kvm);
@@ -486,6 +484,22 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
 }
 
+void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm);
+
+static inline void svm_mark_intercepts_dirty(struct vcpu_svm *svm)
+{
+	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
+
+	/*
+	 * If L2 is active, recalculate the intercepts for vmcb02 to account
+	 * for the changes made to vmcb01.  All intercept configuration is done
+	 * for vmcb01 and then propagated to vmcb02 to combine KVM's intercepts
+	 * with L1's intercepts (from the vmcb12 snapshot).
+	 */
+	if (is_guest_mode(&svm->vcpu))
+		nested_vmcb02_recalc_intercepts(svm);
+}
+
 static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -493,7 +507,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_set_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
@@ -503,7 +517,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	WARN_ON_ONCE(bit >= 32);
 	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
@@ -512,7 +526,7 @@ static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 
 	vmcb_set_intercept(&vmcb->control, bit);
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
@@ -521,7 +535,7 @@ static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
 
 	vmcb_clr_intercept(&vmcb->control, bit);
 
-	recalc_intercepts(svm);
+	svm_mark_intercepts_dirty(svm);
 }
 
 static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
-- 
2.53.0.345.g96ddfc5eaa-goog


