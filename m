Return-Path: <kvm+bounces-71560-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0N6pC1X3nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71560-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9502A1805C4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBA5B316920E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A3E123D7F4;
	Tue, 24 Feb 2026 00:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QNgZtgH7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DC7245020
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894514; cv=none; b=sk1CdcRuYeK8TlfGMJVYzu460LY7fz2f6Z6w0xvlvqDlp0LwFWc4K9f+glrenW4RJ/f0AF3q05kXcAQfDgv6I5jt8xWf9UByCFE6ry+nQ+cQuNlDSs7axBnMrOXr1NH8XGUUWP4cQCtZi1bYL3Hgy85eXc7WomhlayBCZfwoSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894514; c=relaxed/simple;
	bh=U8dRdtvZcYyWcRaAsd+lFSbNG2mMRb2eHiWi+yh8UNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EraGk9+CjCTMrxkUbU4Hjgtzci1IvwgOnDUfuOzSL87HYUdXMZ81TQf8Dlu09FUohIg8BP8h13jKts7roHteUM8V9FyW1mg5bQ7XW90/AmXIfZYeWgUPWWJi3adHJHbGXsqt0qUZrvLQ8us15mmoz5mJEB8qp06GrZg/urBscxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QNgZtgH7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7d7b87977so51874925ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894513; x=1772499313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kw54h9TT8085zuh20vf9SBkAnbrWrd9JjgAMyyfoHIE=;
        b=QNgZtgH7EkSsUYLrS4NcQGLDnYgYZcPKojIQlmta5GD8dlRC149fYW7zJaIVy5pQv2
         IdeRRgvO0Kklu1nd1g4Eln3IvIVoqwfdg5k9LyIL1N6H3A1iQTQij36mJWW+BEqcSJto
         J0qP6NkJqBETtPxNZn9CyjxUvzJU39s6lB9sEFaD1mtPsoIpqgrKq/YegowwL0SK0oTS
         NUH53RuuTvIxAk9Od6nzwjqXxKjWHO+1dzVObYd/DSqEAKWh7LH0gL3FzbmlUn2ExCi3
         pPLwA1vQPPnhETzmagrmDw4elMc22DkIl+++2Ohfz9CyPzMoyRFONEFkL4aIYBBcA+7/
         BpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894513; x=1772499313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kw54h9TT8085zuh20vf9SBkAnbrWrd9JjgAMyyfoHIE=;
        b=NYEsJy1OTfcbdjTB6KVrowPXhuEiHSjdofj1/SSZA0o1ytV//pdNVNHJmbNKBXBN4S
         0Kn+884uXfAfBdLoaFNCiVLxPPBeb2Ds+ccUlkLcFq8Ofi0RQXpm4E3c7siMhaD6C9e9
         yNNcrzl64j89cjSbHkkJBb3b6FPwAtkt9xDw9Jhd9pZHrvtMteVDuIqy0jBz6OhwmZRJ
         Bqg0UNXOATglM00McDqFgWD3gH/qDgXR3BT/Wo7juqQ81Booy3JYy11Ja8X1NtgORcDr
         mqlUblUT0q7bcMExEXAaoCEeLDrGPWO0U9XKtHJPodlWLPP/Pd0hMEHtNvizWZptGKC2
         llDg==
X-Forwarded-Encrypted: i=1; AJvYcCV/W62I4yeL/sw2x5dJMf1EEj2yhgqy/YEkfCev5qQyFsC3NwAIfUvYCbEbfM/61ObgE1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEpZZGYLK4JYJkVUkRhh9XQ/DSG/C2rs5agMJh/0BXod4cs2Qh
	Kapl3vmgUxYqR+Z/hOCfjV7WCQMmYL0ntE1rFaKm9oWhrXmInE16rBIv5uK7V3QxIFRXaH5dsZb
	yZB97KaFujifTLg==
X-Received: from pjbev14.prod.google.com ([2002:a17:90a:eace:b0:356:3104:ed7])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e544:b0:2ad:9421:6136 with SMTP id d9443c01a7336-2ad942166b9mr10617865ad.1.1771894512864;
 Mon, 23 Feb 2026 16:55:12 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:41 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-4-jmattson@google.com>
Subject: [PATCH v5 03/10] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71560-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9502A1805C4
X-Rspamd-Action: no action

Cache g_pat from vmcb12 in vmcb_save_area_cached to avoid TOCTTOU issues,
and add a validity check so that when nested paging is enabled for vmcb12,
an invalid g_pat at emulated VMRUN causes an immediate VMEXIT with exit
code VMEXIT_INVALID, as specified in the APM, volume 2: "Nested Paging and
VMRUN/VMEXIT."

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 17 +++++++++++++----
 arch/x86/kvm/svm/svm.h    |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b72a1f3c4144..91b35adb83f8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -426,7 +426,8 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 
 /* Common checks that apply to both L1 and L2 state.  */
 static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
-				   struct vmcb_save_area_cached *save)
+				   struct vmcb_save_area_cached *save,
+				   bool check_gpat)
 {
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
@@ -462,6 +463,9 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu,
 	if (CC(!kvm_valid_efer(vcpu, save->efer)))
 		return false;
 
+	if (check_gpat && CC(!kvm_pat_valid(save->g_pat)))
+		return false;
+
 	return true;
 }
 
@@ -573,6 +577,7 @@ static void __nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
 
 	to->rax = from->rax;
 	to->cr2 = from->cr2;
+	to->g_pat = from->g_pat;
 
 	svm_copy_lbrs(to, from);
 }
@@ -1036,7 +1041,8 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
 
 	enter_guest_mode(vcpu);
 
-	if (!nested_vmcb_check_save(vcpu, &svm->nested.save) ||
+	if (!nested_vmcb_check_save(vcpu, &svm->nested.save,
+				    nested_npt_enabled(svm)) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl,
 					svm->vmcb01.ptr->save.cr0))
 		return -EINVAL;
@@ -2006,13 +2012,16 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	/*
 	 * Validate host state saved from before VMRUN (see
-	 * nested_svm_check_permissions).
+	 * nested_svm_check_permissions). Note that the g_pat field is not
+	 * validated, because (a) it may have been clobbered by SMM before
+	 * KVM_GET_NESTED_STATE, and (b) it is not loaded at emulated
+	 * #VMEXIT.
 	 */
 	__nested_copy_vmcb_save_to_cache(&save_cached, save);
 	if (!(save->cr0 & X86_CR0_PG) ||
 	    !(save->cr0 & X86_CR0_PE) ||
 	    (save->rflags & X86_EFLAGS_VM) ||
-	    !nested_vmcb_check_save(vcpu, &save_cached))
+	    !nested_vmcb_check_save(vcpu, &save_cached, false))
 		goto out_free;
 
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9850ed01e16e..a49c48459e0b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -161,6 +161,7 @@ struct vmcb_save_area_cached {
 	u64 isst_addr;
 	u64 rax;
 	u64 cr2;
+	u64 g_pat;
 	u64 dbgctl;
 	u64 br_from;
 	u64 br_to;
-- 
2.53.0.371.g1d285c8824-goog


