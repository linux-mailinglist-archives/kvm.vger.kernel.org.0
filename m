Return-Path: <kvm+bounces-72629-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOvXHlZ9p2nYhwAAu9opvQ
	(envelope-from <kvm+bounces-72629-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:31:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5A91F8EB2
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73A36311473C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9703D3033FB;
	Wed,  4 Mar 2026 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YAmlabUg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5072FE591
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584215; cv=none; b=FfOyH6hj335FY8L1pmmdg9rcMxpgvpByGXvycqQGVTATuJEEPvHZ+UIk9n/eoo9a97WecfWKIvZ+eGMUnt8tgXaOH8iJIAstXNwRinjCpsKXOzolsGkzjTcJZf0UXTLjw/WtmlDdHQFLN6jUUE+C1dhLXxun3KQ5D2ekkHLSIjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584215; c=relaxed/simple;
	bh=ccMqsZsH0pOqdPvh+M4o4tLZ05ryk2Pk3IVrCCxCeo4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dZIjEr4zHBQpP7PYlGsDkGOVLJ+3Catd8qeooc/06AdBYJyJgSJFRhm4eFt9gZLXUVXnIzenq2cQXbells1MFTWtjC/shLMFHnoQAH9q9L4e4KphLQzBBWpXF0A8Od4/1h3TPOXxEpUBbXktgQoOkFBD9d5t/ZGRUiMGC9PWeGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YAmlabUg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e425c261so5380474a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772584214; x=1773189014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dq1B0TYlqPwxiWVLtbESTI9zQiKluvKfUnpH6I/C/Wk=;
        b=YAmlabUgyrGlGEIEWdFPJCZ1mbY4gQW9Y/IPgjGzBTPRxW3CbyfAb+l91mGtYRg8iH
         0hBhmjUv6iZOuk/v2jguwX5OLtJFiu3LiPExmEWJHspsuk0sXcCEpHJE5oZrKUkCwkwW
         MiUVNgu6qxDjcI4zXNRohWz+lEj3Kas70cRHUmWMFuRccjf3mJBalb0uJ1saPrcNxKYV
         9y9FgQzLedYktumIf+J+8VNDNfR5yri7zKIwqeMdBdEsOJvLaQQe9PIa3CHrKrp0k3Uf
         8BgT5UsWyNdKwbZkis3vuxx8WgaqNjELYUIjWLZ7DciL/yEFsFF887XYmZVTeGMu5s0q
         toOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772584214; x=1773189014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dq1B0TYlqPwxiWVLtbESTI9zQiKluvKfUnpH6I/C/Wk=;
        b=IonesuwrGVizggjjvaBo7Z4JdKevXvRAmAJDiDPTKl6nJ4M72h9JIyN3Ji172S8FCC
         KUhciHkROIDPP+seyi4X4kgYHxPD9ZDkSrrNJ/sw4X9V1t0qEuVMLQCEoHYiAVyx9eAX
         IAZcV6Wozng+GVLKHYfIk8q5Rk6lmMfaTmlJHlTIzF2G1DYmUtMtyl2gnYT1nLSlqx1M
         KekBSfQ/VhzKPO2Mt2tZYNAeDaeNV1abNPyYLCet38ZWaQ5ecjEadyH2j1OnKZiBdyew
         ajRdgyQuPlBZ/MY6PXzaVgpxvHVvLhLTcrMjBSottqd/3ImM+5f1FWU/ZOlYqdiqWYqU
         /Brg==
X-Gm-Message-State: AOJu0YwbmJrh3VQ5toejQU0pBsWpsypbHElXURGG7b33vyOAGCb/JzM0
	rtZEFZSJ9p3wqB/b0W+XdttaFHRP4fLH7VKccz2fqJ9+uUPd6ZDszMeDkaH1GAQM9hHMHdR89Tc
	W764Img==
X-Received: from pjbms20.prod.google.com ([2002:a17:90b:2354:b0:359:8d4a:7276])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1344:b0:359:8e59:16e6
 with SMTP id 98e67ed59e1d1-359a6a9f792mr190498a91.32.1772584213821; Tue, 03
 Mar 2026 16:30:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:30:09 -0800
In-Reply-To: <20260304003010.1108257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304003010.1108257-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304003010.1108257-2-seanjc@google.com>
Subject: [PATCH v5 1/2] KVM: SVM: Move STGI and CLGI intercept handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CB5A91F8EB2
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
	TAGGED_FROM(0.00)[bounces-72629-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
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
X-Rspamd-Action: no action

From: Kevin Cheng <chengkev@google.com>

Move STGI/CLGI intercept handling to svm_recalc_instruction_intercepts()
in preparation for making the function EFER.SVME-aware.  This will allow
configuring STGI/CLGI intercepts along with other intercepts for other SVM
instructions when EFER.SVME is toggled (KVM needs to intercept SVM
instructions when EFER.SVME=0 to inject #UD).

When clearing the STGI intercept in particular, request KVM_REQ_EVENT if
there is at least one a pending GIF-controlled event. This avoids breaking
NMI/SMI window tracking, as enable_{nmi,smi}_window() sets INTERCEPT_STGI
to detect when NMIs become unblocked. KVM_REQ_EVENT forces
kvm_check_and_inject_events() to re-evaluate pending events and re-enable
the intercept if needed.

Extract the pending GIF event check into a helper function
svm_has_pending_gif_event() to deduplicate the logic between
svm_recalc_instruction_intercepts() and svm_set_gif().

Signed-off-by: Kevin Cheng <chengkev@google.com>
[sean: keep vgif handling out of the "Intel CPU model" path]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..5975a1e14ac9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1009,6 +1009,14 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+static bool svm_has_pending_gif_event(struct vcpu_svm *svm)
+{
+	return svm->vcpu.arch.smi_pending ||
+	       svm->vcpu.arch.nmi_pending ||
+	       kvm_cpu_has_injectable_intr(&svm->vcpu) ||
+	       kvm_apic_has_pending_init_or_sipi(&svm->vcpu);
+}
+
 /* Evaluate instruction intercepts that depend on guest CPUID features. */
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 {
@@ -1052,6 +1060,20 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (vgif) {
+		svm_clr_intercept(svm, INTERCEPT_STGI);
+		svm_clr_intercept(svm, INTERCEPT_CLGI);
+
+		/*
+		 * Process pending events when clearing STGI/CLGI intercepts if
+		 * there's at least one pending event that is masked by GIF, so
+		 * that KVM re-evaluates if the intercept needs to be set again
+		 * to track when GIF is re-enabled (e.g. for NMI injection).
+		 */
+		if (svm_has_pending_gif_event(svm))
+			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+	}
+
 	if (kvm_need_rdpmc_intercept(vcpu))
 		svm_set_intercept(svm, INTERCEPT_RDPMC);
 	else
@@ -1195,11 +1217,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	if (vnmi)
 		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
 
-	if (vgif) {
-		svm_clr_intercept(svm, INTERCEPT_STGI);
-		svm_clr_intercept(svm, INTERCEPT_CLGI);
+	if (vgif)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
-	}
 
 	if (vls)
 		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
@@ -2320,10 +2339,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 			svm_clear_vintr(svm);
 
 		enable_gif(svm);
-		if (svm->vcpu.arch.smi_pending ||
-		    svm->vcpu.arch.nmi_pending ||
-		    kvm_cpu_has_injectable_intr(&svm->vcpu) ||
-		    kvm_apic_has_pending_init_or_sipi(&svm->vcpu))
+		if (svm_has_pending_gif_event(svm))
 			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	} else {
 		disable_gif(svm);
-- 
2.53.0.473.g4a7958ca14-goog


