Return-Path: <kvm+bounces-68847-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qA/uJ5GvcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68847-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:03:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A90B61E15
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A6A247A3724
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A723D4779AC;
	Thu, 22 Jan 2026 04:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ugh9Rptu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945AB472763
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057886; cv=none; b=kO8FAeGRumPyMzwNeg25erJS0yO21uTA0RcWhhPx66OFWF5B93HynDc3zCaxliO1tJ/pjdhp0F+ThBEUIus6BxLclA9yrnPcLG0tAyWFMhhrD+FM8J2klgeE612co+B18jfGjH5eoznkTXdheEp4ylma7iddnDRL/xMR8JtbkBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057886; c=relaxed/simple;
	bh=XcN9XQSp7vAr+/NP33TR/5kwIGgIMbdTWz9Y1Boqn/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vGqz4N56xXoMXdDBHdj6xPtQHu19VPPJn0s5S8/fQez7okvedH7YOoWqYRSqGEmPlRqZdxZdqWRDJmn6FbIUGl8IK7V+gOexHclseLrjpPTeDeub9lHbW7/DMWTwWgwQ1I1qiYpHWlrKs8c98b6VjngHxeZMMyMhVpLKFmujAoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ugh9Rptu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso900446a91.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057884; x=1769662684; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3U0BOUGnwPJAwwi3q0VBYzZ4CYyVrcP38EvplDhJ6lk=;
        b=Ugh9RptuVYW0EmhHmVHXyhAOTkHhF87Zq+raDDNTzqZx8f+AfuUyjc2LxCxjIFn4XE
         moqzTsB8G3kD+b8uD9u8J4AZZwYWdS10Lin3ZDYE5nFKlg/jO2MYFo8K5RW2KxnBsjv3
         0mTkdnxeb+XwwPFNlbqj3EZ9bK/Ex7ehRpMG6mzANfQw5+6x6YrMmXZKqn7UIA8pJalk
         SinAh4/ejXI78ew+fut1BQ/SdqbNMOdVggG4QJBvUG8MI7SfSuGby5sFf38U/pj/fzpJ
         NSg8x+uOcJj+ijFeIOR75cRlUidCh1RPm9O011TXxPa/deLzRCS1UQhgcK7lvsYgwBYg
         1TYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057884; x=1769662684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3U0BOUGnwPJAwwi3q0VBYzZ4CYyVrcP38EvplDhJ6lk=;
        b=NbP7BtlVgkltuS0Nizbvut9APJZ1O09ZgFES8OZk5fQp8IC6bQHzifB//pAdtl2Few
         Noxr7iyH2HQn32bKm1Ae5eYG2RkYC7ZXj711uRm8MDLGf5q2YkNUTVoOZ0Plmk0rM26V
         LhkFTW8i96LYUS3qxC5qDXn8TE/7AHugt1ud9DuvIA42yb+YV0Igetr5d9lH6mHTIrjk
         iQ72cua1pit6KCqfx5yHosMFLU9sfkd4U/F1CLDZjZF4VEcBT/OQmIdEc6NsV97giZEc
         ggKKiy9eMf4GcyEtqAdLp5Jfwk5pii1WbZKycmhK8pnNdX8uNtHD2xLSc5BSy3kscafT
         xmfg==
X-Gm-Message-State: AOJu0Yw+ySjZX0tng76DC/RK5yre8/Y26Csb/zFyxpmq2VTGrj2yihKO
	2cbjwnfBDRJs+y0o5V+4F2hVTVn1ixliTx9FYfEblXGebLrq2/0iOEt7kYkVZzZcMhqrPcZclxt
	wlhQ3bt3+wHWXQQ==
X-Received: from pjbqj7.prod.google.com ([2002:a17:90b:28c7:b0:34c:811d:e3ca])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:240e:b0:352:c146:dc39 with SMTP id 98e67ed59e1d1-352c146dc7amr4825518a91.30.1769057883808;
 Wed, 21 Jan 2026 20:58:03 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:53 +0000
In-Reply-To: <20260122045755.205203-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-5-chengkev@google.com>
Subject: [PATCH V3 4/5] KVM: SVM: Recalc instructions intercepts when
 EFER.SVME is toggled
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
	TAGGED_FROM(0.00)[bounces-68847-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3A90B61E15
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
 arch/x86/kvm/svm/svm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d3d7daf886b29..1888211e20988 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -243,6 +243,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		kvm_make_request(KVM_REQ_RECALC_INTERCEPTS, vcpu);
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
@@ -984,6 +986,7 @@ static bool svm_has_pending_gif_event(struct vcpu_svm *svm)
 static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 efer = vcpu->arch.efer;
 
 	/*
 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
@@ -1004,7 +1007,13 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
 
-	if (guest_cpuid_is_intel_compatible(vcpu)) {
+	/*
+	 * Intercept instructions that #UD if EFER.SVME=0, as SVME must be set even
+	 * when running the guest, i.e. hardware will only ever see EFER.SVME=1.
+	 */
+	if (guest_cpuid_is_intel_compatible(vcpu) || !(efer & EFER_SVME)) {
+		svm_set_intercept(svm, INTERCEPT_CLGI);
+		svm_set_intercept(svm, INTERCEPT_STGI);
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
-- 
2.52.0.457.g6b5491de43-goog


