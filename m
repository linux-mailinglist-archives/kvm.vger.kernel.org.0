Return-Path: <kvm+bounces-71565-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJUgFUX3nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71565-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1565A1805B3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 58462303DF40
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3B724A07C;
	Tue, 24 Feb 2026 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pRtpSPsq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A17256C9E
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894525; cv=none; b=EA4NmJG8I1owyCKZP9vxv0gw6FSZNqyeRCimZRfu8s7EiJV9DqUVj6Y6tW+hR7z0yoF9dRz5rPdDiBiXtfC4ka+LzRa8vGKqyinpjUiZ2vszj+Kn/2asiUsnXTKAMLbzOt20VxAInXT2egwC7N3R4rBATBoFXwoaEQG0WXEDYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894525; c=relaxed/simple;
	bh=D0wfVSvJ1UsJp3MyQ6wAzujmp3VR7K5htA+colO4tiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aIKnu3QnClqqz4BjYCxLVBlp6zaiQ3EeeheXTPsAWmOEhpuncXZjm9SKJw1If/a+artcP/fyBY21GnxOK3+Q8UYGedyFNI89Vknd8UT4xJIuQ7Wuz26WtpGvEqzEXjtewRdhRaBfxS/3zu2amaw3ndWes7hLlxYpkgg1/txcChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pRtpSPsq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c0eb08ceso33473214a91.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894523; x=1772499323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M8RJNlKzUYHH3Z91vbtEnFmofJjfz47joowNwa+7Nt8=;
        b=pRtpSPsqxIy5r/2Z+T/r2olIPtMJ7f3IGw6jVp878fEgCFA0JD+l9SxYu24VyL2ZqC
         rzOwO5T/xhkCN2pi3HSlyLeXB8SCUAkYW/TeHpRKP1OcEY+gZN2qV12q+0+rulOWuFpr
         o/3Uu3rGjR3j6ZVHXU9yfv21+pMOBug1jwj+zPF7XV4Tslc8PYDNKhN20sHz6NkoWI6S
         6wD5QZIJsrMzGIrRR8DNhdV1fwZTPw6jdnN6ixcT7BB2cxGrywMkh0IkjEAgob50zXtL
         9tftFx3LhXd4KqjM4gvHHSNSmOSyBB8xXsYF+4Fh1vFpeu4pHtZEc4gqJJLbIY7LRubW
         e2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894523; x=1772499323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M8RJNlKzUYHH3Z91vbtEnFmofJjfz47joowNwa+7Nt8=;
        b=DcWdqgC7sY10DGpXkmKG9cX5K/exIGvEcHCaOFR1wATe7ETg1cqXwPoc7gJtbxJPbc
         Cmakhkw0GZvmCaMbSuWqioHqO5RLpwYTxiH1WOGJ1ExLP+UtJoGUSWyr2nToW2rAhwiF
         qaKLhUz2vMhstylddkVdUJy0ljs+nN5pyFC+rJdKpqEvFCsTYSDfZixtK/Zl79mlhn1w
         vIIzGgVt3XIZvKDpl+b4RybUc8mnXCivxd+OPFKhnKZ0Jxeeq+7UNtytzplu6CFCN7be
         Zo7n88CYWXfJuwzwo9xcQByJe2E899mIILkhPgqrV0qO2O8RZdc3rNlU2/y5WxPkzJwz
         3FEw==
X-Forwarded-Encrypted: i=1; AJvYcCU7o6b04qh1loJqQ8dBr3quILflVna+0ekURN6huD/JxjlDKWaMbf3sY3CkyQt0MDvOqG4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4J2OqYyRK+fjh3d9wQELj4yV9iQX1JJ3V0+g3eCrvJAiNbZKn
	G4raNONKe5ek9cLmAJHqk605rq+HMPabaeNGmAHHavvZZciu5rAJtJ1rKYKHlG4gc27yqxnQ/Iv
	UQAV7OL9Js/dOOA==
X-Received: from pjug8.prod.google.com ([2002:a17:90a:ce88:b0:354:7c11:76e1])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:56ce:b0:336:9dcf:ed14 with SMTP id 98e67ed59e1d1-358ae8d0c60mr8820057a91.23.1771894522639;
 Mon, 23 Feb 2026 16:55:22 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:47 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-10-jmattson@google.com>
Subject: [PATCH v5 09/10] KVM: x86: nSVM: Handle restore of legacy nested state
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71565-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1565A1805B3
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
decoupled before the vCPU resumes execution. Also clear this boolean when
the vCPU is forced out of guest mode by svm_leave_nested().

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 13 ++++++++++---
 arch/x86/kvm/svm/svm.c    |  8 ++++++--
 arch/x86/kvm/svm/svm.h    |  9 +++++++++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5a35277f2364..b68eddcbc217 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1537,6 +1537,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
 		svm->nested.vmcb12_gpa = INVALID_GPA;
+		svm->nested.legacy_gpat_semantics = false;
 
 		leave_guest_mode(vcpu);
 
@@ -2075,9 +2076,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 
-	if (nested_npt_enabled(svm) &&
-	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
-		vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
+	svm->nested.legacy_gpat_semantics =
+		nested_npt_enabled(svm) &&
+		!(kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT);
+	if (nested_npt_enabled(svm)) {
+		u64 g_pat = svm->nested.legacy_gpat_semantics ?
+			    vcpu->arch.pat : kvm_state->hdr.svm.gpat;
+
+		vmcb_set_gpat(svm->nested.vmcb02.ptr, g_pat);
+	}
 
 	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 00dba10991a5..ac45702f566e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2727,7 +2727,8 @@ static bool svm_pat_accesses_gpat(struct kvm_vcpu *vcpu, bool from_host)
 	 * with older kernels.
 	 */
 	WARN_ON_ONCE(from_host && vcpu->wants_to_run);
-	return !from_host && is_guest_mode(vcpu) && nested_npt_enabled(svm);
+	return !svm->nested.legacy_gpat_semantics && !from_host &&
+		is_guest_mode(vcpu) && nested_npt_enabled(svm);
 }
 
 static u64 svm_get_pat(struct kvm_vcpu *vcpu, bool from_host)
@@ -2749,7 +2750,8 @@ static void svm_set_pat(struct kvm_vcpu *vcpu, bool from_host, u64 data)
 		if (npt_enabled) {
 			vmcb_set_gpat(svm->vmcb01.ptr, data);
 			if (is_guest_mode(&svm->vcpu) &&
-			    !nested_npt_enabled(svm))
+			    (svm->nested.legacy_gpat_semantics ||
+			     !nested_npt_enabled(svm)))
 				vmcb_set_gpat(svm->vmcb, data);
 		}
 	}
@@ -4262,6 +4264,8 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	if (to_kvm_sev_info(vcpu->kvm)->need_init)
 		return -EINVAL;
 
+	to_svm(vcpu)->nested.legacy_gpat_semantics = false;
+
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b0b935d049..626efef878a5 100644
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
-- 
2.53.0.371.g1d285c8824-goog


