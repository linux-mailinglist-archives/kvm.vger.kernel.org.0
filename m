Return-Path: <kvm+bounces-71562-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPMpJAL3nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71562-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 341FB18054C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ACB3E3033013
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C9C23E325;
	Tue, 24 Feb 2026 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IGsOfS0i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2823ABA7
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894522; cv=none; b=K50V6RoH2U3uqTOhSpCaD/M5b4FZDZMurAxHHzqWWNCHfLxTObeavW7YHm/vkyEuP1Bthitrw5iHXesFO7QIjhZYtNXZwBZQyIhF5DU4g4g8QTUwXOH0sZM0eR59YgBTiVeEVlAyvsoPvHWy5tJLxDYoqMpjBicJRH+EWwVP85I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894522; c=relaxed/simple;
	bh=wugGug88ulZBP+j2+aUrsuqT4ajAwhd5CJ12zCO2pgU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YQW0Gqd1yATe546wHc5fCwnBEGkmn0KjjpE5L1uVXIhurBRke5RHXXEjpCxGzXKO+5hkc61cw/nEE13m9LA23l3PDfm9RxVOWtD0NNquoUpwH+VSpB3aKTC4FWwM3D45aD3AglWvbxcGkXXbnghCCK+Dm3xWJ6eP3bSSM5MbWpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IGsOfS0i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824b42b8a81so20486180b3a.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894514; x=1772499314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Hqic4J3q/Gjct4qXtXk7Fpq6XEgqzORDUOT17QFCo=;
        b=IGsOfS0iiseZTXkRyjMPuRz0yd0R4HwqPg8peUzvpNWGM4sfmbJFQirrEyxDl+yclJ
         KqZyABpMBorhvUOOYaEAXyS9UHyHDnEZQ3aKjXkgvD6wNClIVL+qxRvPQrDHL0eqLFLr
         qbP6GAfvs6yboAPk3Of4P+MJhx1ZarlBgNHV/AsvIwjLialHrN+v7bAejZmV63agcpvy
         R7T/GMM6eQ3ZtAhB2b/tvRz6oPOijmE4bmw3vNuctWp4eBsz3MLwbrnNm8wn6ILxL4MZ
         4EqRKEQDaf11prOWe1ERcz0mniE0Y+N+15cJy3ejD7Z2Vpx7aDh+yGeGsJaZ/Bar95I1
         P1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894514; x=1772499314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+Hqic4J3q/Gjct4qXtXk7Fpq6XEgqzORDUOT17QFCo=;
        b=kDifxdL5W4qv6m8QDZtz0zhaptFu1brazryU75sZYIST7gGN2zb0ymHTv0ANVWLW2L
         PhSZbnZCx+JseUu/jISUx7GBFU9EgEQABCXgLUZI8FwqBkigDOFGJh2zxmpT7iTUBWZc
         UF0kzpoHXIQuN8rMi2N9jOOwHcawD7Wxme0D6ZpllKl1/UCUHeTr46bKDVnVnTCgi2Mp
         ZNZUvCwwDaQku850mrikLrP18DpEurkpSjs9sBBGJpqqe9HuepHMVs0WJdGIoH+ClM6c
         yc3R0HNFNsQyHyFYjenPLeXYNLBebOX3tq43/agrSHvsAxXWKgqdPohRV4Urv98kaHO2
         FWTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1dRMJWhjwgfH96t12l31hPV8bYJRD7YtmgD6TZd4RztzF+1J78kM9nvzwB6Wqz97ZF04=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVyYArfnUQ/Ob/8A38vXaY+xtABBWVvZOhKYU/A/LTTHR0Ss6E
	Ba6j8DNryiFfXh0GUpobgXMjFcKvnokxSOXxqT0Vlw/Me0W8Ph94/oGsSSJoYE0n6rnGIBa/J7Q
	pxR8ruUXOvew4qw==
X-Received: from pfbfb35.prod.google.com ([2002:a05:6a00:2da3:b0:824:ba70:4416])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:92a5:b0:81f:46ce:e90 with SMTP id d2e1a72fcca58-826da910433mr9511795b3a.28.1771894514274;
 Mon, 23 Feb 2026 16:55:14 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:42 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-5-jmattson@google.com>
Subject: [PATCH v5 04/10] KVM: x86: nSVM: Set vmcb02.g_pat correctly for
 nested NPT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71562-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 341FB18054C
X-Rspamd-Action: no action

When nested NPT is enabled in vmcb12, copy the (cached and validated)
vmcb12 g_pat field to the guest PAT register. Under KVM, the guest PAT
register lives in svm->nested.save.g_pat.

When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT MSR to
the vmcb02 g_pat field, since L2 shares the IA32_PAT MSR with L1.

When NPT is disabled, the g_pat field is ignored by hardware.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 91b35adb83f8..dc8275837120 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -724,9 +724,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	nested_vmcb02_compute_g_pat(svm);
-	vmcb_mark_dirty(vmcb02, VMCB_NPT);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -757,6 +754,13 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm)
 		vmcb_mark_dirty(vmcb02, VMCB_CET);
 	}
 
+	if (nested_npt_enabled(svm)) {
+		if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_NPT)))
+			vmcb_set_gpat(vmcb02, svm->nested.save.g_pat);
+	} else if (npt_enabled) {
+		vmcb_set_gpat(vmcb02, vcpu->arch.pat);
+	}
+
 	kvm_set_rflags(vcpu, save->rflags | X86_EFLAGS_FIXED);
 
 	svm_set_efer(vcpu, svm->nested.save.efer);
-- 
2.53.0.371.g1d285c8824-goog


