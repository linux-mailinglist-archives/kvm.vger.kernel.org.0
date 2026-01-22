Return-Path: <kvm+bounces-68845-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLdJG1KvcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68845-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:02:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D112061DF8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 45B555876BA
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EB337FF7B;
	Thu, 22 Jan 2026 04:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jBRNNN+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FBA3803C7
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057881; cv=none; b=evkrwGRNzwy66QOry+gswSfkh1ffWLP1fbPnU2deyV1uLNgjnXtcvjhj+8nJkeP7A5WibmHa7WPNPAvN2OQEva/rXCa5pttxCdRZb209ov1Z+yaNvr9+UdswiV0D9qwF2MQ1n9JdBRPUSHB9pzgb+zjBY+v2ZVfNf3cg/MoikwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057881; c=relaxed/simple;
	bh=wpXekjAzG3IL5CI+i20pupSmQcFDGu1Q1AxNefcVdag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IOxSdAvm6DcSxTnAPIh0YA5/zzabJRhx5PkV8CR5T0o6O+Fjl4r6LxArl7jZN2DEmun0xp4FsqZHGMHat3YD5qENYFf5Gim6c+9rQd7y/lRgzSTC1fnvSTOqDfs5p0R1gPwgeQY7561Q8znzyl9W9U8LaN0t74h0Gb1l+3anJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jBRNNN+j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac814f308so990901a91.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057879; x=1769662679; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RqpPgpBkcHsc1qhgHSbUd1JkeuX4eLvTF59kcb07cTA=;
        b=jBRNNN+j07a2FRn+gD+4c2DqUxlVq+8DU/CSvKJ+sJIASsd/TNhjb/ZovAWJQgiVJR
         o2V+3jDKheJ0iFe8i//DkDDbsEjIpWyFsMVdIF8dcD5cW354/JrauGA9WRrFfAm8D6Hx
         DIh/ym4O6zhoODwfoVs0HXdM4+TGvWT+DAEgKzAzYXf08CA8drUHhNCrSBU+gW66nIzC
         W7YRirn9FlHtnXEUyMRJtLUoDgCh1op/Cmnmd7GD37gcX5CH8hyYG2yGZpzzHdqUZco3
         MdCuca2GTogRTJHgCgfO/1RL0kVzXBHP8XpC/pZlcnUaPfA2JjSnCpInQkI+/mb+xx+8
         BPBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057879; x=1769662679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RqpPgpBkcHsc1qhgHSbUd1JkeuX4eLvTF59kcb07cTA=;
        b=oT+Bk7YXJXYK+lFCqFRDK3RRV5CLqgvGB0YVrLnVysa/gl0dk5XN0o8lWNGfPpv8T9
         6O5nDwBHQjQyfgHaHEGRqKCuBH2HeWFhONQyvoLjwQbIddQOPgjjnh8KLKv+01rtaCFI
         3YJmhwN6xvYEiNVjne0D2Ta8qywLVJLQ5nVpFnvsliapqKwcvzlsY5m5NMUVgh8/Z41r
         /ruYqR5vpH7V2OLEGRtRD8O2Krc+qxD346QmDxm1la1jfCsKzCgSWInflkAZ6eRaP+h/
         g5aYHrspeR4cKWsN+KHZoVYVrlx4Ce+HMpMnLLOcpsaTem2qycCgKBym2e3WNCz++OMS
         zdNA==
X-Gm-Message-State: AOJu0YzlRIh45148WfFu2I1RmDH8YT+0L1p969TfIDWBEKSPA9+i4JkH
	i7Z/PDHVFTV6ct2t+l7CQViYemA1D6rrbXIat/ebuyqctUBGiR9csp18bVpTBFOyDtefg4+jX72
	8Il+GqRDWWhAV5w==
X-Received: from pjbhl15.prod.google.com ([2002:a17:90b:134f:b0:352:fb17:1f20])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5606:b0:34a:48ff:694 with SMTP id 98e67ed59e1d1-352c40b68admr5643968a91.31.1769057879216;
 Wed, 21 Jan 2026 20:57:59 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:50 +0000
In-Reply-To: <20260122045755.205203-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-2-chengkev@google.com>
Subject: [PATCH V3 1/5] KVM: SVM: Move STGI and CLGI intercept handling
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68845-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: D112061DF8
X-Rspamd-Action: no action

Move the STGI/CLGI intercept handling to
svm_recalc_instruction_intercepts() in preparation for making the
function EFER-aware. A later patch will recalculate instruction
intercepts when EFER.SVME is toggled, which is needed to inject #UD on
STGI/CLGI when the guest clears EFER.SVME.

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
 arch/x86/kvm/svm/svm.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d9..7a854e81b6560 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -972,6 +972,14 @@ void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu)
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
@@ -1010,6 +1018,20 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
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
 }
 
@@ -1147,11 +1169,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	if (vnmi)
 		svm->vmcb->control.int_ctl |= V_NMI_ENABLE_MASK;
 
-	if (vgif) {
-		svm_clr_intercept(svm, INTERCEPT_STGI);
-		svm_clr_intercept(svm, INTERCEPT_CLGI);
+	if (vgif)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
-	}
 
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
@@ -2247,10 +2266,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
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
2.52.0.457.g6b5491de43-goog


