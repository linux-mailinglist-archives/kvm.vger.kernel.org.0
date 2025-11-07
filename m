Return-Path: <kvm+bounces-62358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CF9C418BA
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 21:13:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 529C23ACF89
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 20:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7126B309DA1;
	Fri,  7 Nov 2025 20:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwJeoGOD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808F430AACE
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 20:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546323; cv=none; b=FADgHANz9eMUdbs/o7DG3KuA3e4Uzm9c6ZjsEUI5JsC7qi4mrl9BmqAT0KR+xMzB7Gulq5c1hAUOxkhTeG6eSttf6sdgK2MAuE4jXweMBrorNx7BU41c5TA/UEq2/fAJI1whzgg0CmvkGW71NCf8dIorhFwq/fLQ4BpneBS6qyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546323; c=relaxed/simple;
	bh=sI2clx6m6yDxI8SOWEjPQNsSFN7NbjLqZ0gLeTraeyA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZmotkEc1Sq2HQJ6tPspJRGisBLrzWfW8NPTboFYt1kaTUXP3b81vF6VOP1XPwv2oI1PwFJ5GxHogy6AVEBeTD7DQi5qcaxNqgjN85nuSsOflT55Mjn6giQ12bWpAbWAzangXQSbm20SPTQkxMXSJ1//abpJy+uEPg7wBVhNXdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwJeoGOD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341cd35b0f3so1269363a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 12:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762546321; x=1763151121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxGIOgK9FDWxY7r1m8JPVJNrWZHinYe3MXWstZ+fuD0=;
        b=JwJeoGOD9qkNcqpLN062nDjTalqw+jTVJgVBuKtjy5DPTLgHmte2qyidY1JQtHJj/p
         zAgkWnAaNJ36Yv8qvu5JeluUEEZZjUaHh32urGLBjnGGlxI0di8xXYPFnU1hIivWnrVA
         IXbjRfoQxPZRiAB9EueTRULEyVTU+syPkiMnsyZ5f7jxlBAf06C3GgxcjIvlbBAAQB7L
         H75mDR9zpHbGCZNao13qmuOH5xJTKjureCUV+5p54VQ8D/0BDZVbv0krhTbWW7zno4hZ
         1yHiNnUOplBikWum9RQOmtcP3FA5fuhaVU2zTS/vFJRQTYdBEgFeLuzW1/ydOnzOiPUD
         PhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546321; x=1763151121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxGIOgK9FDWxY7r1m8JPVJNrWZHinYe3MXWstZ+fuD0=;
        b=p+HKFj8o26OmS8XTxsGLr5s7/EdW7WNVcdKDDI3e0hV5clWlmjAQCUcO5sMLUUVWbJ
         dOKPmZk8XUEzFtBkv7LtWol1ryJ82E6w8JsGiyLz53LQduKFBGiApgHyE8thceE4A652
         zrv7o1BqL/gySgXoUSmIwXac2oV6Fy7Cg8KsOo4rIvwJBcoN4Xs0I434J/v+j32UGzzg
         BF/9xxfBE4SvTt+h3mcT7YbvgNwO+Iydu8AVDG7bekw0hfU1Gfc1WAEeAi52dNnlHVoK
         UYPHrvwp5N5jX5enMFMHMtbCb+zHpSRpaE4JSjfa4tpTh8oV8EDl2q76npdWb0aiAS/d
         HHEw==
X-Forwarded-Encrypted: i=1; AJvYcCUa2NSl5S5+xxRl1NwYejtMKhEdV5Cz/+jCmc3c3bVESGgXl4YgayCzKfHd1sCsrNdyVm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcNmgqjCKXqvEkmicpyZeACIhguLurX/u3lr5HOXMFd50LhOLL
	KHJSwptIiDth/nTb7QIQlcaNgnSuc5Su6GR1nzxUMXjIzMI7BzRI8swSzNFltGxY9xlFzP1SncD
	b4V+woz3y5RB9ZA==
X-Google-Smtp-Source: AGHT+IGch52OnpzoFrGgut3GHntDyv4eE8MmfDX0ABWgIg6EW1CvmgksElczIbEJwEfGnzU2ioOfmfCMWL/5WQ==
X-Received: from pjbcu24.prod.google.com ([2002:a17:90a:fa98:b0:342:b238:e0a5])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f85:b0:343:6a63:85d5 with SMTP id 98e67ed59e1d1-3436accd340mr652802a91.16.1762546320755;
 Fri, 07 Nov 2025 12:12:00 -0800 (PST)
Date: Fri,  7 Nov 2025 12:11:25 -0800
In-Reply-To: <20251107201151.3303170-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251107201151.3303170-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251107201151.3303170-3-jmattson@google.com>
Subject: [RFC PATCH 2/6] KVM: x86: nSVM: Redirect PAT MSR accesses to gPAT
 when NPT is enabled in vmcb12
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

According to the APM volume 2, section 15.25.2: "Replicated State,"

  While nested paging is enabled, all (guest) references to the state of
  the paging registers by x86 code (MOV to/from CRn, etc.) read and write
  the guest copy of the registers.

The PAT MSR is explicitly enumerated as a "paging register" in that
section of the APM.

Implement the architected behavior by redirecting PAT MSR accesses
from vcpu->arch.pat to svm->vmcb->save.g_pat when L2 is active and
nested paging is enabled in vmcb12.

Note that the change in KVM_{GET,SET}_MSRS semantics breaks
serialization. Trigger a fixup in svm_set_nested_state() by setting
the VALID_GPAT flag in the SVM nested state header.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |  1 +
 arch/x86/kvm/svm/svm.c    | 25 +++++++++++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ad11b11f482e..c68511948501 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1728,6 +1728,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
 		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
+		kvm_state.hdr.svm.flags = KVM_STATE_SVM_VALID_GPAT;
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b4e5a0684f57..7e192fd5fb7f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2675,6 +2675,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = svm->tsc_ratio_msr;
 		break;
+	case MSR_IA32_CR_PAT:
+		if (!(is_guest_mode(vcpu) && nested_npt_enabled(svm)))
+			msr_info->data = vcpu->arch.pat;
+		else
+			msr_info->data = svm->vmcb->save.g_pat;
+		break;
 	case MSR_STAR:
 		msr_info->data = svm->vmcb01.ptr->save.star;
 		break;
@@ -2864,14 +2870,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		ret = kvm_set_msr_common(vcpu, msr);
-		if (ret)
-			break;
-
-		svm->vmcb01.ptr->save.g_pat = data;
-		if (is_guest_mode(vcpu))
-			nested_vmcb02_compute_g_pat(svm);
-		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
+		if (!kvm_pat_valid(data))
+			return 1;
+		if (!(is_guest_mode(vcpu) && nested_npt_enabled(svm))) {
+			vcpu->arch.pat = data;
+			svm->vmcb01.ptr->save.g_pat = data;
+			vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_NPT);
+		}
+		if (is_guest_mode(vcpu)) {
+			svm->vmcb->save.g_pat = data;
+			vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
+		}
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
-- 
2.51.2.1041.gc1ab5b90ca-goog


