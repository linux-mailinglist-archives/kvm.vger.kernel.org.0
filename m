Return-Path: <kvm+bounces-72267-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YD1tBGpiommN2gQAu9opvQ
	(envelope-from <kvm+bounces-72267-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:35:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C69011C0232
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27FFB30DCC02
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 03:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8628C2E03F2;
	Sat, 28 Feb 2026 03:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ug5x1mup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26A2DC77F
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772249618; cv=none; b=G3VTZi5kAZfR8iatCnraOqYuiGwVmp2p5DFvhgYVbo1ISInDiwgmBBdqzd7p9EVaK0Losm+Xn+UEqHLPMzsY2vN1aNTgHbh/X2OXgvWgwFIYXbmnyWHSXkhIUzB/3KMHhb6oV73NqZ9zSqQ3066aU/TwRQ7p2NwffTOFgiZrsyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772249618; c=relaxed/simple;
	bh=TMlSqCyWvJ5+oyMgoxICTdMjB6gA1+Lo1/8Yg28tCac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GgIPM74GNIqkXsszy7G3xaPpMHV1YG3zG/6WYGrUuCzJQB8ptO4FP2CG+DgmXV7NgI07gYioHYYC35aGxxmpoEVZP5p5aruSrnPJcTPsTLTdEW3+Qzd0MHFqbmtdISfzGLUBM06los21A3e1s9lrXECpEe6VwlKMEz8IUG6qW8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ug5x1mup; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad6045810so26636215ad.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 19:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772249617; x=1772854417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KECV5NM5vA0Sv5chR0aDxTLlt1UbjfAsSg2hi5p5zD8=;
        b=Ug5x1mupzby7JS+XXXkRWin4EQEn3O/iVyug0evHCDvMJLRvJY9XpjviStFzgU4xDF
         BowPumWwYPrfdZ0lZaly+ts01qZLa9/9tO1OdCUbGBxTZMQ92ZqWGOU52EWPiKJ+yZ6U
         IFzN+2/dtfpjvotcbEB/pRvUAxTYjk8ok6H4/KGe/nwaBlVRTxCVR8d4Xsh8WbeJ0Tun
         0HM3iW1MT4Kw6uGnk4alFvsWMqDcpojhhpXT9NCS0lYnHca3sj9O5gzRdKaDni40uYS6
         rksabqlTL/rZOn6f+MLhU0CqcTlQogUNxn0r466U2uUauRXuwXRuNOjDmHd52noYXVKM
         SvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772249617; x=1772854417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KECV5NM5vA0Sv5chR0aDxTLlt1UbjfAsSg2hi5p5zD8=;
        b=Sfwpj78Cu89Q8EWhPsq0MXXvqKqASPEct9QAJKeyZIjr8hRJ43w/gelNwkCr6ON43m
         cp2OZfa0IP7HPUmC0/u7vZ11tK+fEp/c+BARnce2tk7LUYHS1/roOdps1YftrRl8VyRH
         dMa9Epk/RCMrsqlQfa4HcHsxt+L9b0rHi3Z1v2fP3dAnFb4RwXUioPZcNOlWP6VA/Uwk
         TgzicvAe4PFlnnPPq1XCyaTQRUJwhviGmCQ/xdPdfmIrXMEmffkrPjGi8lYOG9BIgp0+
         fsqF2hkSxgD6yfYaXvkimZKBw/p8cex5we++4MAoNxyYfyG5PBUa+tk8lTqBtn5TASz6
         Obfg==
X-Gm-Message-State: AOJu0Yy8DU4kXQxyy4WrtqKa5ZVGkz/MB1nybcFh81Hsbcs/8/pLLFzo
	SQScVLbCOC7PA4w4ZsfITajPpcRFE3ua0/LWLnHkaL0+6qLFsJJHTEOV1xo5AQKcTwZyrzGZnlX
	TgXCebSnnyg3dFg==
X-Received: from pltt19.prod.google.com ([2002:a17:902:d153:b0:2ab:4d9c:3c06])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:41cb:b0:2ad:9421:613c with SMTP id d9443c01a7336-2ae2e400d0fmr40863855ad.21.1772249616796;
 Fri, 27 Feb 2026 19:33:36 -0800 (PST)
Date: Sat, 28 Feb 2026 03:33:27 +0000
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228033328.2285047-4-chengkev@google.com>
Subject: [PATCH V4 3/4] KVM: SVM: Recalc instructions intercepts when
 EFER.SVME is toggled
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
	TAGGED_FROM(0.00)[bounces-72267-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: C69011C0232
X-Rspamd-Action: no action

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
---
 arch/x86/kvm/svm/svm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 249bc3efe993a..f8f9b7a124c36 100644
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
@@ -1021,6 +1023,7 @@ static bool svm_has_pending_gif_event(struct vcpu_svm *svm)
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 efer = vcpu->arch.efer;
 
 	/*
 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
@@ -1045,8 +1048,13 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
 	 * always set if vls is enabled. If the intercepts are set, the bit is
 	 * meaningless anyway.
+	 *
+	 * Intercept instructions that #UD if EFER.SVME=0, as SVME must be set even
+	 * when running the guest, i.e. hardware will only ever see EFER.SVME=1.
 	 */
-	if (guest_cpuid_is_intel_compatible(vcpu)) {
+	if (guest_cpuid_is_intel_compatible(vcpu) || !(efer & EFER_SVME)) {
+		svm_set_intercept(svm, INTERCEPT_CLGI);
+		svm_set_intercept(svm, INTERCEPT_STGI);
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 	} else {
-- 
2.53.0.473.g4a7958ca14-goog


