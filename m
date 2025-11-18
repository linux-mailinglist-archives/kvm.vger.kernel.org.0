Return-Path: <kvm+bounces-63598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 94556C6BDA0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CAE78362DBD
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14F1311C22;
	Tue, 18 Nov 2025 22:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRzBtuA2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A430F954
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504616; cv=none; b=i/qrdujHVlXurxP/Aoq8g+5zUUZTHNJpHknUcaOAT8VSClXQ4DPRcHIw9dmBgo83mlAYj2ubEN1Bg3swMVpozxNtuoy2OqwrKXMSJYL/3WSf7MY/V4uvFp54UlSHPY7vOSBE3fV2eK6v9UwfiipSSAPvxKLlFs72h4mzFqIEoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504616; c=relaxed/simple;
	bh=gkOFf1GrseR4lyx+m5A0i8MM9/uAsLY1WwIpa5M2Cos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bYWzBODOqprQHzfrfalfceJBe/LAoWfSchyGQrGFZHBrjK/TCRZDcq8GfNfhxPDUgeu4k5JdmKnCewGBJwj1CLKldUDabkMix6hTcpl3N9AZ/wU2BfYfriLodxtJjn7OJVL2xnOgxSvlHaY1MD6ROEF0qH/sV58g+cFJGUqoGm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRzBtuA2; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-298389232c4so92292465ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504613; x=1764109413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EoozWi2o0AP/cWaOLQLnk9g/zPkjhcGQ8ZSDyR31DRY=;
        b=eRzBtuA2psnUx1ZmHHnHjodKCcsmSe+Lh0yyURFF7Suo9lkxcjIoIFhCQm+k5IHf5u
         fePC/ykirHpsd7Or9Hwb+ZDZJa9pni7C9YvKMFgkW/+2woGs8rRRZgi8LCO+qGQVhkbV
         5RPTU9ttBIQfrLMz97kddttIzP+gqUtj9N5Wk7DM9B+whEZb8rs4fGNW/y9UEyzFRGjw
         cCsV6aqs98r3lc9sLDzaVfJzc+ml0XbghzQJQ/2ERNK8oVANBqA8XgEHNTYDll59fUVO
         l77p0dIE+tW98tufK8Ka9ExBoLXc8Ruzs7uxSTXM5fKl75GDlC1mNxpiUQcg4M15yOoJ
         bflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504613; x=1764109413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EoozWi2o0AP/cWaOLQLnk9g/zPkjhcGQ8ZSDyR31DRY=;
        b=whEKmzfmBFoitAtyC7Spas0sD8T8OC5OcQ2XP6Czj9JyyLKZDUaApP+RQSyhdWdH+K
         YQUBlR2Ct3E1/uRToLJKP5u7+7cRuzsjB65eE0v/aZAYKxfdhyL+4IgODd3DOcZnfCok
         eIcPiVaZGe1oErw6slnaqdqPOqSESDHNBvK6ZVRqI/uxVjA0cWMWIHOpOQf8B8MmhRlG
         z7MGf3c9CkyVDmaPOadmveeI2LGJ7rPAppmfT0BzXq3Y2516HIwMjJ/7GKhmd4w66WhE
         Ryznqz1/YKLr//OioQycOXeut8ZGGx/PQKSyJU5ox2ui0w8Br7DXxHjFr+Qy13zJyna8
         fweQ==
X-Gm-Message-State: AOJu0Yz9OvvrbK6eUBcsqBQLOjaYGpQQtmziDMtMUKVXiyt7Fikhqyja
	kIqeRzyl9mH1lH4Cy65ruJ78m4Ia4YhJT0ju99KNz0prh/1MN2o5ciLNBAQZTTPVxlmJT8TuuIK
	K5k1ZUw==
X-Google-Smtp-Source: AGHT+IGBpr2o1tN68nNDCesi9FJp0PssJ7eoZdkj6lok22m/Q8r6RJE+NAbbob2Q0BzsFgmO0oAokh9ajl8=
X-Received: from plbjc5.prod.google.com ([2002:a17:903:25c5:b0:295:68e0:66ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11c6:b0:297:e1f5:191b
 with SMTP id d9443c01a7336-2986a6abf3cmr224167275ad.11.1763504612758; Tue, 18
 Nov 2025 14:23:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Nov 2025 14:23:25 -0800
In-Reply-To: <20251118222328.2265758-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118222328.2265758-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: SVM: Handle #MCs in guest outside of fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Handle Machine Checks (#MC) that happen in the guest (by forwarding them
to the host) outside of KVM's fastpath so that as much host state as
possible is re-loaded before invoking the kernel's #MC handler.  The only
requirement is that KVM invokes the #MC handler before enabling IRQs (and
even that could _probably_ be relaxed to handling #MCs before enabling
preemption).

Waiting to handle #MCs until "more" host state is loaded hardens KVM
against flaws in the #MC handler, which has historically been quite
brittle. E.g. prior to commit 5567d11c21a1 ("x86/mce: Send #MC singal from
task work"), the #MC code could trigger a schedule() with IRQs and
preemption disabled.  That led to a KVM hack-a-fix in commit 1811d979c716
("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").

Note, except for #MCs on VM-Enter, VMX already handles #MCs outside of the
fastpath.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aac0eb3a490..bf34378ebe2d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4321,14 +4321,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
 
-	/*
-	 * We need to handle MC intercepts here before the vcpu has a chance to
-	 * change the physical cpu
-	 */
-	if (unlikely(svm->vmcb->control.exit_code ==
-		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
-		svm_handle_mce(vcpu);
-
 	trace_kvm_exit(vcpu, KVM_ISA_SVM);
 
 	svm_complete_interrupts(vcpu);
@@ -4631,8 +4623,16 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 
 static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_INTR)
+	switch (to_svm(vcpu)->vmcb->control.exit_code) {
+	case SVM_EXIT_EXCP_BASE + MC_VECTOR:
+		svm_handle_mce(vcpu);
+		break;
+	case SVM_EXIT_INTR:
 		vcpu->arch.at_instruction_boundary = true;
+		break;
+	default:
+		break;
+	}
 }
 
 static void svm_setup_mce(struct kvm_vcpu *vcpu)
-- 
2.52.0.rc1.455.g30608eb744-goog


