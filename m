Return-Path: <kvm+bounces-67879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 243EAD16045
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5B89C300E8EF
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E232BEFEE;
	Tue, 13 Jan 2026 00:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M7rxCkUd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80B288522
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264251; cv=none; b=VLeZ0NRjIpu5i/kLoElKHotKrOMDghzAdwMBrvsHi0z6A7pTbwJf4X/+7zwU8zy1BvZub9RaGeQBqR60z+rVtxXsv9gZ1Fl8xIv9suxCaWKlGJp6cWFd2W2zfSZQ+yMFCc6T2eQoPO2khP2kd13I/s7RzX/mOZ5JiLp0xvBhQpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264251; c=relaxed/simple;
	bh=EGhyQwSph0LzMgiu5B+EdES+A6XGxqVH3cwlp19V2xg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HdQbGm7a52vEM+bcQGh3CXsZ61DLwI6m4Dy1idChDA99DyrSEhiSP+BLfpN6F02k6auqeKvBMHQcQ5nN/Hd5M1fltX0dZrXXlIB3LO9Mi3OMjaUxBXVc2GXx+7ykIaPfskjTFVcP/mWX3Wer3pV4v9vQzdK98XWLlY4zCrOFRdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M7rxCkUd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c6e05af3bso7565537a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264249; x=1768869049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qqn3ma3gV+5ioOHZfJQ8oXgHLrZbIOMhZwVIPABgW6A=;
        b=M7rxCkUdpTlSjlgviGpaQgWc/qOcRoUKQsVMCct+VT8wkFsZlsqR4SeEerj4/RZNgs
         t0PkEvvos3w6IsZbDvrEws7NiO7rgql1hr1eJqzwyCqCgthd2+J2t3ovxNyUkBL7l7jX
         WfjIxMmpbgMHOkc76xp6bX4MmY6gnlxuYZju7HGf+5/AyKiaooIj3sj3cvpfLA5V/p8x
         VkHSFfnqBNhypQQr5/S/mm8KaWqVehwQVUC74S4O+Mfq1r34mQAvJCOIN5hiI3RZs/3n
         165OZ+JSssMH2QK/evpaXMzZ3ghOHYk+w2g3/1swsooMvUvK624aQ8wSR4eazndAP+ZU
         lIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264249; x=1768869049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qqn3ma3gV+5ioOHZfJQ8oXgHLrZbIOMhZwVIPABgW6A=;
        b=mgoTTXKzwrBeSPwWYUIx1XfBYn+e+KAsw8lzYLqPN3fwJ/JBDQcMkyZu7pueH0VCL5
         gSbhaDCkD7VKUkp56ui9AagpR2OGuVrUhaHtftab426lyCWzRB9c81DH2KG/gNOvdUto
         fujawzQgX3mOPTsFcxrliVevXie2GEaBVcBrw3GY84ydU0hf0k4xtl6Am/iWgZyAa2Bm
         fWJS9LpWcMzoEDJBInqZY/XPpVc5lBdcFls6NBRhu59iPusjn56OdYdWQdp6jKe2bURw
         H9YnzPth5AiL/2D4kwhhmK48E67NEBaUiWLSppogLLdQmuAKcKgamKItirjZQcm0Gtgb
         2sfg==
X-Forwarded-Encrypted: i=1; AJvYcCVc809weIGJsAcfbuqn6XiZ5G+4yjRGPpsfcHlp/hEk2ZtYQ67ZoZCh0o4m45uYiuMWaio=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWYBPtsqvsPl5vm5q4fSayUUOuO+9VMYx2d4jeGoU/QOvDLdVl
	gIwlR5uSKQaJK6tY0L/jE96E2DG4v6gbxvfa41QY7V3D2dIu51EPqXmqWiTGbIcNj/O77sStOLK
	DyKWF63WBq9l0eg==
X-Google-Smtp-Source: AGHT+IFLNcKt2ozNKiFnGj+m7CgeLyZoO/CQAR137NPaSy1m6tiz+vtzOJT1hpH0lebhCAthvpqABnxiKLxxxg==
X-Received: from pjua12.prod.google.com ([2002:a17:90a:cb8c:b0:34c:d212:cb7f])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f0b:b0:343:c3d1:8b9b with SMTP id 98e67ed59e1d1-34f68c00b4bmr16640913a91.19.1768264249644;
 Mon, 12 Jan 2026 16:30:49 -0800 (PST)
Date: Mon, 12 Jan 2026 16:30:04 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003016.3511895-10-jmattson@google.com>
Subject: [PATCH 09/10] KVM: x86: nSVM: Fix assignment to IA32_PAT from L2
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

In svm_set_msr(), when the IA32_PAT MSR is updated, up to two vmcb
g_pat fields must be updated.

When NPT is disabled, no g_pat fields have to be updated, as they are
ignored by hardware.

When NPT is enabled, the current VMCB (either VMCB01 or VMCB02) g_pat
field must be updated.

In addition, when in guest mode and nested NPT is disabled, the VMCB01
g_pat field must be updated. In this scenario, L1 and L2 share the
same IA32_PAT MSR.

Fixes: 4995a3685f1b ("KVM: SVM: Use a separate vmcb for the nested L2 guest")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |  9 ---------
 arch/x86/kvm/svm/svm.c    | 14 +++++++++++---
 arch/x86/kvm/svm/svm.h    |  1 -
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5fbe730d4c69..b9b8d26db8dc 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -640,15 +640,6 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	return 0;
 }
 
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
-{
-	if (!svm->nested.vmcb02.ptr)
-		return;
-
-	/* FIXME: merge g_pat from vmcb01 and vmcb12.  */
-	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
-}
-
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7041498a8091..74130d67a372 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2933,10 +2933,18 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (ret)
 			break;
 
-		svm->vmcb01.ptr->save.g_pat = data;
-		if (is_guest_mode(vcpu))
-			nested_vmcb02_compute_g_pat(svm);
+		if (!npt_enabled)
+			break;
+
+		svm->vmcb->save.g_pat = data;
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
+
+		if (!is_guest_mode(vcpu) || nested_npt_enabled(svm))
+			break;
+
+		svm->vmcb01.ptr->save.g_pat = data;
+		vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_NPT);
+
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39138378531e..b25f06ec1c9c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -801,7 +801,6 @@ void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
 void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
 				    struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
-void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
-- 
2.52.0.457.g6b5491de43-goog


