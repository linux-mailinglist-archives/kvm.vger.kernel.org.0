Return-Path: <kvm+bounces-70997-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gM8sBgL5jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70997-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:00:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1715512F2B4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BBEB3302E73E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE22B35D5E5;
	Thu, 12 Feb 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zif59+xB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF89935DD11
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911965; cv=none; b=AgEf6BPsoG1EMcasErNpGcRrngQ5Pq6FbwDrOTkdXD72lPj97qZYo5G2y/Q22FVjuVP9Wj13frRwuX9uIMTLG+8zB60XTNimTUK+EzQIumsd6NK6AQ3fk8m27ig2d9QZR7O5rWHQXFMuNNevusd7CvJk6Uuq7iDHeADFEteaDpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911965; c=relaxed/simple;
	bh=k4PiYHsSuuJFMDCPsbANk87y2wEFqDT2QuLQAFxQBqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ldhGEFvGLa/VGsq5mmBZ/HHkL7ADJH5JAZ5v2T1KCa/SD1BgfAnbETEbDeAZprtBD3nTFvhGsJP4iJ9ebcQj+t32n/+uWUWqQj0lDWT7RIjYDxGbNgSCOU9ZbVWSHEPLSFtFZS4UxH1kIgH3VGh67w1q5z9GroVL9OGV+3RroH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zif59+xB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fc5b2fso35293355ad.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911963; x=1771516763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PVdp9sqT0g4R8OZdrPzG/zG6Qh9LMmNSXbaooXKmXCg=;
        b=zif59+xBcl7e0OBAqId74xmvjRidQUf3nY5NJYVNYZjDJqvDBHJ9G5EVcy/sUbh/Pr
         z39dkDkgf1yrBENuQtrEJzEA11tM27F0dHSA1yan4nXMhlF+RZEAc4GgUnS2PbHg3xLp
         IkLNIs9P50QgP0PzAbr2yF5R48H3ebaRb1/NCbi9O/zJODISKQF77ZAajDoXDyb/WqyM
         lKbrbMqPAHLZVOnzatRe5wchYaHTISKVFIlKxIAraaja6xUD0Lxz+2OGV1zFFd0V6v4L
         MTdFicP8Mc/aKk8IfIvEIkLL1sSM89FLSfuAyykQWaJTcigC2hWotzHEgy3oOhQO8uud
         PtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911963; x=1771516763;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVdp9sqT0g4R8OZdrPzG/zG6Qh9LMmNSXbaooXKmXCg=;
        b=ESazD/5KP5x215CsM+Zgv23tO0F/nQwHnd46WSBFA6C2ePlmslgIX1hxn4pkFG3YKf
         uzXK7nZPkjCuz4qWsE5eNKFj71+HqEY8pJNM/fuTUbuy9PJzhakzO+IgT6X1YPaWrjGN
         a0TqHnYz0Ubg+gvrGDq+3fPeqHgCnb7HF2Wl74LOGXpmaqgWLy1cz0fPuZBEwRmhb5Oh
         i6VozdHCiU2nFah0rs3Be2O05F+/HQEEEq3Rhy6S7WjMwj9KbC7dGDV/Qmq8SEn56OYK
         Ch9vq7Y1ZTiHUfItki6TB4Td8vIWI1BbeuG/QNI7RV68rGAkZQ2RciHsAlRM2qbLCTuD
         jHuA==
X-Forwarded-Encrypted: i=1; AJvYcCUnT1bSdD9Dyt6iP60WZFkgsVpjGOTH8eJwJ5Gb2jCShEvaZRM7wGJ6Ug/aqwSwwmYfjZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM5j1qBoVUQ14p45AMe2rj29RLHMCn/Hngn91ft+YYNrvOvhZd
	S6WE066iqXdF41RHiJsd0mUFp1hH714Qipqbd0NRsyXhxHj67VB069AUAzHiXpzBG/EBdwfh8zG
	3+iLeI62PAUiIlw==
X-Received: from plbkk4.prod.google.com ([2002:a17:903:704:b0:2a9:6206:d68])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ec83:b0:2a7:3dbe:353d with SMTP id d9443c01a7336-2ab3b28af34mr31946425ad.53.1770911963215;
 Thu, 12 Feb 2026 07:59:23 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:55 -0800
In-Reply-To: <20260212155905.3448571-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-8-jmattson@google.com>
Subject: [PATCH v4 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-70997-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1715512F2B4
X-Rspamd-Action: no action

When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore an
old checkpoint (without a valid gPAT), the current IA32_PAT value must be
used as L2's gPAT.

Unfortunately, checkpoint restore is non-atomic, and the order in which
state components are restored is not specified. Hence, the current IA32_PAT
value may be restored by KVM_SET_MSRS after KVM_SET_NESTED_STATE.  To
further complicate matters, there may be a KVM_GET_NESTED_STATE before the
next KVM_RUN.

Introduce a new boolean, svm->nested.legacy_gpat_semantics. When set, hPAT
updates are also applied to gPAT, preserving the old behavior (i.e. L2
shares L1's PAT). Set this boolean when restoring legacy state (i.e. nested
NPT is enabled, but no GPAT is provided) in KVM_SET_NESTED_STATE. Clear
this boolean in svm_vcpu_pre_run(), to ensure that hPAT and gPAT are
decoupled before the vCPU resumes execution.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 11 ++++++++---
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    | 11 +++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f73f3e586012..d854d29b0bd8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -2073,9 +2073,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (ret)
 		goto out_free;
 
-	if (nested_npt_enabled(svm) &&
-	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
-		svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+	if (nested_npt_enabled(svm)) {
+		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) {
+			svm_set_gpat(svm, kvm_state->hdr.svm.gpat);
+		} else {
+			svm_set_gpat(svm, vcpu->arch.pat);
+			svm->nested.legacy_gpat_semantics = true;
+		}
+	}
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 205bf07896ad..d951d25f1f91 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4245,6 +4245,8 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	if (to_kvm_sev_info(vcpu->kvm)->need_init)
 		return -EINVAL;
 
+	to_svm(vcpu)->nested.legacy_gpat_semantics = false;
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 88549705133f..0bb9fdcb489d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -238,6 +238,15 @@ struct svm_nested_state {
 	 * on its side.
 	 */
 	bool force_msr_bitmap_recalc;
+
+	/*
+	 * Indicates that a legacy nested state (without a valid gPAT) was
+	 * recently restored. Until the next KVM_RUN, updates to hPAT are
+	 * also applied to gPAT, preserving legacy behavior (i.e. L2 shares
+	 * L1's PAT). Because checkpoint restore is non-atomic, this
+	 * complication is necessary for backward compatibility.
+	 */
+	bool legacy_gpat_semantics;
 };
 
 struct vcpu_sev_es_state {
@@ -621,6 +630,8 @@ static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
 		if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
 			vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
 	}
+	if (svm->nested.legacy_gpat_semantics)
+		svm_set_gpat(svm, data);
 }
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
-- 
2.53.0.239.g8d8fc8a987-goog


