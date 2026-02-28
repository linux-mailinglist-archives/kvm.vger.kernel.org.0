Return-Path: <kvm+bounces-72265-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLBEFCdiommN2gQAu9opvQ
	(envelope-from <kvm+bounces-72265-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:33:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB761C020D
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5A2E030462CF
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 03:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DDA2DA75B;
	Sat, 28 Feb 2026 03:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l28WjmCR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598962D0292
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772249615; cv=none; b=Yd4aZA2Z7VoNzqmE0MSuNmHS3KPu7mqrBuRe8qpGR+oCHjgzg16WVSlxV1dXv+xfELPEB0LP5UdZSTBiA+5AWtiUM/o9GGf+ofYkmEL4hSqjyIC/aXmaxq5jpXyxkYCrXXNu7wcp+IUDm+sD2zZ6cBHpmt3hn/OU/GUsLY5q5Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772249615; c=relaxed/simple;
	bh=QeMp4SItLEY+RtGFw9jYs1xeLiZhCoFEz023scLX/I0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ffeVYAzHr0nla1qQvAjR4IG9SrkOqLmJYPIzC6Nzl6IR6ANXVBBfwu6gkmVcZmeuBHkM5DM9HI6IRMt5HlwVCWHEAnHVgrNtyasljDkHbRCT8RmOmkbgTdCZS8/tS+lv73/PWD+RgM9LsFcnqo8QbqDKYUKfAnssL3oQlf/6ubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l28WjmCR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3593c55e434so2541910a91.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 19:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772249614; x=1772854414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMeckVBCJeT9+5nk88sC0zbSpPJ6gkZiJXCizVZfHao=;
        b=l28WjmCRRpREE2KrbLLK7wy/j7KLff0QU7tGltj9VjCcO5vhBC6JlelyFzMkRMpJMW
         /JT9zVqmsovVIO2MbWcHVCkOr/ICwIQ9gXRRKWIDs3GAXsMRAoPwso89dVJUPFwPn7bB
         5NvmahBGntsXrzcL+tzyUa1bO259CPoRWUJ4z4ZT56UMbS+En4Pyi8lbyprnFhjiuhnD
         Q6aopBlqpAWw82znBxIgf6p00wiw02F2HdMrkm8mzwsLcJD9VcFntDr9KhZ+mV4978Q/
         VThAPQ3QcFQvRpqV4a5UhHSGre08Mavg+ipKRs5Q7Sxa+iCG3PQw6+CQAR0cbeqlyaB/
         mXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772249614; x=1772854414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMeckVBCJeT9+5nk88sC0zbSpPJ6gkZiJXCizVZfHao=;
        b=EvJ1EjxPhZ0sfONkJCwkz7nXBvm6HK2pE66gt4yXQjyHN1HGbzapp/4bDMwP6zvSEJ
         qHbhtTDrYUsdIAzh7oDc3AfxdMdyEAKQ5DgITpaXQ3NG/SRSHGjSVBfJOtf0xUADpt3T
         ayIwHtUF9cBVR+Xylcu2eNeJSr5gna58IrIhDC+iuOolBWzAZjIhhD62h6v43Dl/TTkt
         v9mYlnsxESvOFqYsPgYpDIbFchPE6mwGEV9OzaS+IvDd6elGJndyRc2Rq1c4AYDvbEhI
         q44AKEjeTaAMgqeluMZERHevpgepO/SJhb89RxsMx4sumT5wwEMB0tMYJT2fYrqaZyy3
         g/rw==
X-Gm-Message-State: AOJu0YxCstrZ5T5ty4QdzMb34ZD4TCTWTEPMf5AiiKZ4xLCeNQpctqX1
	5DkpBc+6jhXtuyCZg+onV9fYE7ucfH69TA0rzZ6F8zB2XhSH68uBS22UzyT6W12dSXlFm3fP6mO
	Q62bMBNCQBdAMsw==
X-Received: from pjbpi2.prod.google.com ([2002:a17:90b:1e42:b0:359:bc4:636])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:da85:b0:358:ed1d:2834 with SMTP id 98e67ed59e1d1-35968faa663mr4320102a91.6.1772249613484;
 Fri, 27 Feb 2026 19:33:33 -0800 (PST)
Date: Sat, 28 Feb 2026 03:33:25 +0000
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228033328.2285047-2-chengkev@google.com>
Subject: [PATCH V4 1/4] KVM: SVM: Move STGI and CLGI intercept handling
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72265-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7EB761C020D
X-Rspamd-Action: no action

Add STGI/CLGI intercept handling to svm_recalc_instruction_intercepts()
in preparation for making the function EFER-aware. A later patch will
recalculate instruction intercepts when EFER.SVME is toggled, which is
needed to inject #UD on STGI/CLGI when the guest clears EFER.SVME.

When clearing the STGI intercept with vgif enabled, request
KVM_REQ_EVENT if there is a pending GIF-controlled event. This avoids
breaking NMI/SMI window tracking, as enable_{nmi,smi}_window() sets
INTERCEPT_STGI to detect when NMIs become unblocked. KVM_REQ_EVENT
forces kvm_check_and_inject_events() to re-evaluate pending events and
re-enable the intercept if needed.

Extract the pending GIF event check into a helper function
svm_has_pending_gif_event() to deduplicate the logic between
svm_recalc_instruction_intercepts() and svm_set_gif().

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e2143..25b15934330bb 100644
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
@@ -1050,6 +1058,20 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 		}
+
+		if (vgif) {
+			/*
+			 * If there is a pending interrupt controlled by GIF, set
+			 * KVM_REQ_EVENT to re-evaluate if the intercept needs to be set
+			 * again to track when GIF is re-enabled (e.g. for NMI
+			 * injection).
+			 */
+			svm_clr_intercept(svm, INTERCEPT_STGI);
+			if (svm_has_pending_gif_event(svm))
+				kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+
+			svm_clr_intercept(svm, INTERCEPT_CLGI);
+		}
 	}

 	if (kvm_need_rdpmc_intercept(vcpu))
@@ -2320,10 +2342,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
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


