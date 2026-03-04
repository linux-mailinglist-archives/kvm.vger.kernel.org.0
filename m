Return-Path: <kvm+bounces-72630-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8O9zLmx9p2nYhwAAu9opvQ
	(envelope-from <kvm+bounces-72630-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:31:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 430231F8EBA
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C3173139AF2
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA0D2FFFB8;
	Wed,  4 Mar 2026 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZLN+mrW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884D3033C0
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584217; cv=none; b=bFc3t/J4F0ioAX2XHVh6294NN2UMsCuMGeTB2cPMTubrWcVObNrZH8oW5bIcYDCbEEGpt2FqdTYOcBnS0aNpogSQLYr8uyoS1/GB3URtjUZ5pc7xSF20ULqu90kTkOYkgUNEf7WMV2wamVtUqC0OTqXeq4+YMpMvoxYljZDNjFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584217; c=relaxed/simple;
	bh=gj5RrXvjF9gGzH/8mhVzBo2MAAP1PcFar51lLz5JUCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RkivZYX7I+MPM8V62+j+ua1F7Cf9qcFydzfSW/QzRt3cwIMRn00tgjPw8O7Nr6NkabEYFRtlo3ZHPhJhj4xr4WbmV1ODPUEm5+DiFyYtYY0BzErGsCixERZxV0odZQg2iVaaPI9aIlDURqit1BTPL83qe/7PcnJuDILgqdSebhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZLN+mrW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354490889b6so22078950a91.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772584216; x=1773189016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IjLyd2RWGNGV5RqBT9JABbG50LnPdxLHn8xgFqmPo6c=;
        b=OZLN+mrWvs3FfrKwMl0U7RTi4J445jkh8sHIvoclDKUNCg6Sre40xGfxAlhkaNGC0C
         PJ4ych7se+BlbTPwSWbi/HbLoJIyJoh+nngNi1DhQ+6fkx1beezlrm3Q7tX79wT3i2bD
         ScbcKyE6VqK4prFzRRBBjKyFbkzLwzEAVBS42Q/dX6RUcguCq2bUVFqf9bOxXAqLNN7E
         FZetMQQfHPXuOYUS6WoiN41VrTflLYcbOh9B/aGbR2/WrTqXIiTlqur4Rs6Vu7prblEY
         tiYt+s8dN0uji+1ZR+6R2D5KtnSUClLE7bIOZiNO0YlbPBuV6LNbRppferWp3A+Ez89m
         Rv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772584216; x=1773189016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IjLyd2RWGNGV5RqBT9JABbG50LnPdxLHn8xgFqmPo6c=;
        b=qw7VSEAR0wWsE6ZX/WlzyZCcqHrXrx6gY1P56mZm3GqL26Pxi9IS2+QD8KrvyXI/n1
         t8y2fCUov10PUCfJE1bkwDXOjjXBtINdBGkkkyV9B0Or/dQcD3Y5XJUlcICKDnG35EfX
         nTSTta9b/kLh6FfJANdTKQmMHYCthCvbG276U1AcJzPTx0ow+67kByUefIfq9u06sCmM
         L0lA4S1RRdGLm1TJcoBQviNbI3iwY05vDcJd7Ny6oRhDoMHLTHeCrwie9kKSC5dZzo6u
         96GAQJzVyRQKLkL8DVHSw07T06YLT3v8RO51Re2hRe7nTSrNmOjzsM0g9SVflawRBQLz
         mC7A==
X-Gm-Message-State: AOJu0Yy1wjC+l9fn3+kZz1DysfF/IgtWqRCpWjJgXNp83ctK+s+YCPYy
	+72GaPf71+0tZQeTokRvQhsXHVIQhETVq1bJ8/jvLi7CHQeArlS1HGrZrSJO1qq56szGwIk38R5
	K5s3X/Q==
X-Received: from pjbrs4.prod.google.com ([2002:a17:90b:2b84:b0:359:9111:25a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1643:b0:356:24f0:af0c
 with SMTP id 98e67ed59e1d1-359a6a4d3famr310677a91.17.1772584215513; Tue, 03
 Mar 2026 16:30:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Mar 2026 16:30:10 -0800
In-Reply-To: <20260304003010.1108257-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304003010.1108257-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304003010.1108257-3-seanjc@google.com>
Subject: [PATCH v5 2/2] KVM: SVM: Recalc instructions intercepts when
 EFER.SVME is toggled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 430231F8EBA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72630-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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

The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
EFER.SVME cleared, no #UD is generated in certain cases. This is because
the intercepts for these instructions are cleared based on whether or
not vls or vgif is enabled. The #UD fails to be generated when the
intercepts are absent.

Fix the missing #UD generation by ensuring that all relevant
instructions have intercepts set when SVME.EFER is disabled.

VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
supported for L1 and never fault.

Signed-off-by: Kevin Cheng <chengkev@google.com>
[sean: isolate Intel CPU "compatibility" in EFER.SVME=1 path]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5975a1e14ac9..07b595487caf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -244,6 +244,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -1042,27 +1044,31 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
-	 * always set if vls is enabled. If the intercepts are set, the bit is
-	 * meaningless anyway.
+	 * Intercept instructions that #UD if EFER.SVME=0, as SVME must be set
+	 * even when running the guest, i.e. hardware will only ever see
+	 * EFER.SVME=1.
+	 *
+	 * No need to toggle any of the vgif/vls/etc. enable bits here, as they
+	 * are set when the VMCB is initialized and never cleared (if the
+	 * relevant intercepts are set, the enablements are meaningless anyway).
 	 */
-	if (guest_cpuid_is_intel_compatible(vcpu)) {
+	if (!(vcpu->arch.efer & EFER_SVME)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
+		svm_set_intercept(svm, INTERCEPT_CLGI);
+		svm_set_intercept(svm, INTERCEPT_STGI);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
 		 * in VMCB and clear intercepts to avoid #VMEXIT.
 		 */
-		if (vls) {
+		if (guest_cpuid_is_intel_compatible(vcpu)) {
+			svm_set_intercept(svm, INTERCEPT_VMLOAD);
+			svm_set_intercept(svm, INTERCEPT_VMSAVE);
+		} else if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 		}
-	}
-
-	if (vgif) {
-		svm_clr_intercept(svm, INTERCEPT_STGI);
-		svm_clr_intercept(svm, INTERCEPT_CLGI);
 
 		/*
 		 * Process pending events when clearing STGI/CLGI intercepts if
@@ -1070,8 +1076,13 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		 * that KVM re-evaluates if the intercept needs to be set again
 		 * to track when GIF is re-enabled (e.g. for NMI injection).
 		 */
-		if (svm_has_pending_gif_event(svm))
-			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+		if (vgif) {
+			svm_clr_intercept(svm, INTERCEPT_CLGI);
+			svm_clr_intercept(svm, INTERCEPT_STGI);
+
+			if (svm_has_pending_gif_event(svm))
+				kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+		}
 	}
 
 	if (kvm_need_rdpmc_intercept(vcpu))
-- 
2.53.0.473.g4a7958ca14-goog


