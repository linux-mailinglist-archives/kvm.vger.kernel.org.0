Return-Path: <kvm+bounces-62357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CF807C418AF
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E49674EBE2B
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C16C30B52B;
	Fri,  7 Nov 2025 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MUan9kFo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D50309DA1
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546322; cv=none; b=ka0x4tLeURbTI808yfHJzvci260iFfRwK3sC+qAbDE/r1SZsKs+OLovrO7R9IviKQj08oWV8feFpLtFmiMOeWCEVF3b7OHXzH9qFCw4cq2TA06DswrsXYXxMdI9ddk8VC2XdNEBG4gLSZnUOCQkgTi5vMWmNShTlLS5cgxFihAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546322; c=relaxed/simple;
	bh=6mhxmlCkJdMvlQlffB6c92IR/AzJRxNT+9oxiSDNPT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L1WmS3vI8aG+sFOVPeIjs+PU3FNbZCWhd8rzqewp+y/ewiarWRe8p4AyYcD8TkADdeKUNfmW47AKL3qgjMcKZISTzSjEz6EDkJJoLhaD3A+W7doWnued9rdBI7NLViPfO/4xjKxf/mx8FjQSCKxhiAsLYs5rA4lTKf+jzMkfH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MUan9kFo; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso1480634a91.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546319; x=1763151119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lhiSMyqm92MMUM5EN3rog8SDMgfsHheSQRcp3hOaMHg=;
        b=MUan9kFo2st0Pg5KqyUd8n0jRMRsy3eah99ZDUdVM7dzCX8Os5EqU8hMPVf3yz0rnR
         QuOXnTPQTHws2RrIb5JKHKGupA51x9SjD8KPUeTz/zENHz7CP9LWPKvsPdgL1MKs7RJZ
         ZfzNWXWbVfxrSQpxqoPx818KIgWsNxFy7xoP1jcazRo5LB8gjan279sLlKQJPphfIXu9
         4vjvU7H/k57uArMRN+DS4PT7dn2syO7bREJfWMtyD1CNuhViG/bx+L77qWzbdXemVKPB
         9Gxmuz7tjUbaomSSySbnfvzQZNyZ/KWYsZbQ4hvsN7DYDbOJef9lr/y8bKI2aAFwciPJ
         gA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546319; x=1763151119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lhiSMyqm92MMUM5EN3rog8SDMgfsHheSQRcp3hOaMHg=;
        b=DkhoicVuB036aK2n6cOhZDLvBPqX8PskV/bZ2jM1zha3EDDs8obAYHKl7Ixqtdqrpd
         GiU72tZEMce1eWOidGVEM1/makIOwGu16lQAa0cow875cpBfAPP5BmdVoeNi3AFidTkI
         mFg37hqrGxxIPvV+69Uqn/gqqBrahrmQmZ9rB8WnWgQ/CY88Aw7gzLT90uUhOp74CvFI
         6GWc0fEC+5a7qbxle9+IfRTKrqBoEPQXJt+hzd5dQoLWXM8bTBs3YYLIJ1KCdfmh+Sqx
         BO+AsQAM/Tzk9LQ2YeQQW0B7ak4fc38wWWLYdIlrLz7LLoXhRFDT21iLBTwm8GXtSvtW
         gtSw==
X-Forwarded-Encrypted: i=1; AJvYcCXKpUiMDPMjsg+uz7ceiH9XRhCjMb6b5CUbRG1cxh5KEcTRlBJUk3Owa/4M10BU1DxEsfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBbIEvkUnGjhEfHpqy4zBcMN02nMMtGbqz+0HlqBz4ckPqKZuE
	qyXJJriJIunsVdkKP6/aX0jIxVAIoSYnFRqtB65l5uCpjg6Em2oyKy6yrKQMj1EYF7CDJFLfOpz
	TJk0l4OvzSAlSBw==
X-Google-Smtp-Source: AGHT+IFpJp+VwLKq8k0TLxsmj++3hUzm6S2CN12G8usM3ikhh4AiSOVq9alb1RG6mNKwrtTVoiHTzNlX1lqs3Q==
X-Received: from pjof5.prod.google.com ([2002:a17:90a:8e85:b0:330:7dd8:2dc2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e710:b0:339:f09b:d36f with SMTP id 98e67ed59e1d1-3436cbab88emr348383a91.28.1762546319147;
 Fri, 07 Nov 2025 12:11:59 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:24 -0800
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107201151.3303170-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-2-jmattson@google.com>
Subject: [RFC PATCH 1/6] KVM: x86: nSVM: Shuffle guest PAT and PAT MSR in svm_set_nested_state()
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Alexander Graf <agraf@suse.de>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When L2 is active and using nested paging, accesses to the PAT MSR
should be redirected to the Guest PAT register. As a result,
KVM_GET_MSRS will save the Guest PAT register rather than the PAT
MSR. However, on restore, KVM_SET_MSRS is called before
KVM_SET_NESTED_STATE, so the Guest PAT register will be restored to
the PAT MSR.

To fix the serialization of the Guest PAT register and the PAT MSR,
copy the PAT MSR to the Guest PAT register (vmcb02->save.g_pat) and
copy vmcb01->save.g_pat to the PAT MSR in svm_set_nested_state() under
the right conditions. One of these conditions is a new SVM nested
state flag, which will be set in the commit that modifies the
KVM_{GET,SET}_MSRS semantics.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/uapi/asm/kvm.h |  2 ++
 arch/x86/kvm/svm/nested.c       | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..df8ae68f56f7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -494,6 +494,7 @@ struct kvm_sync_regs {
 #define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
+#define KVM_STATE_SVM_VALID_GPAT	0x00000001
 
 /* vendor-independent attributes for system fd (group 0) */
 #define KVM_X86_GRP_SYSTEM		0
@@ -529,6 +530,7 @@ struct kvm_svm_nested_state_data {
 
 struct kvm_svm_nested_state_hdr {
 	__u64 vmcb_pa;
+	__u32 flags;
 };
 
 /* for KVM_CAP_NESTED_STATE */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a6443feab252..ad11b11f482e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1052,6 +1052,7 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 	to_save->rsp = from_save->rsp;
 	to_save->rip = from_save->rip;
 	to_save->cpl = 0;
+	to_save->g_pat = from_save->g_pat;
 
 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
 		to_save->s_cet  = from_save->s_cet;
@@ -1890,6 +1891,20 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(ret))
 		goto out_free;
 
+	/*
+	 * If nested paging is enabled in vmcb12, then KVM_SET_MSRS restored
+	 * the guest PAT register to the PAT MSR. Move this to the guest PAT
+	 * register (svm->vmcb->save.g_pat) and restore the PAT MSR from
+	 * svm->vmcb01.ptr->save.g_pat).
+	 */
+	if ((kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) &&
+		nested_npt_enabled(svm)) {
+		ret = -EINVAL;
+		svm->vmcb->save.g_pat = vcpu->arch.pat;
+		if (!kvm_pat_valid(svm->vmcb01.ptr->save.g_pat))
+			goto out_free;
+		vcpu->arch.pat = svm->vmcb01.ptr->save.g_pat;
+	}
 	svm->nested.force_msr_bitmap_recalc = true;
 
 	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
-- 
2.51.2.1041.gc1ab5b90ca-goog


