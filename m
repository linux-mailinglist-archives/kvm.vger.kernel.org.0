Return-Path: <kvm+bounces-38534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88441A3AEED
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E6CE188F9C3
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B53D146593;
	Wed, 19 Feb 2025 01:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qqw0y8b6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65B19F47E
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928443; cv=none; b=TTkP3MD3q+MaBMDqnohUdk7pa0YEzjbAVBjW3IDHtMah0yYczLDoVZDvCHzq1ympNMugV9C5A3BB4ft2D0HfaRMK8n9A0C562drcTZsLDr8P1o9GhcSEf+mzvlApOkSQ6l5CeGTl+hj/bBcqGdGthTk8breaUzbfr0RhHaspPd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928443; c=relaxed/simple;
	bh=sMb0VSq16pUIdqNUADb0can/VKUpPGYhL6VZ2dH8dR8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Iv8x8+nEeW2jkbL5wRYbwYuHDid1qsl+4jk+JA6jLY4sx3NV2QaSfq43NB5sDnjkOzVi1xrehL6g46ctozmc5pi5DadIzdxfW7QAsrFYNSGb89BlyEHcE7Xiwxg4wUnm7HOU9GK1zqhfcN1Y5o6asS2bLdjoJ/9ZmMM3AAEJybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qqw0y8b6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso11995381a91.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928441; x=1740533241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PwxgaI2CeQipiv6np04CuCnpFX89Ht2qe65kPiXCVz0=;
        b=qqw0y8b6lwKBJwbUF4N2o7w1wpxIfZf6vNgXte1dRUSvxqlb8VH2JZufjEUSNBSooD
         AybeM0xlAWnD3mE0/PI7q38ztWhaf7MyPMLXas2AlTDmC2RodTJhSI9zQdbdLpucTrWq
         fSJiIskAupFfvhCT4/brvTTHdh33DMLRubJQwQ3oJKSCoWG3mmd6kZsn87IJASsdhkuJ
         hfHTllk78gSfPoGAbsTu6StfNyQSIoevjB1NOpyUsm5fXEMQOPq+oNDoewSCuhA+BFrr
         D+A6x1dCmT14r+yz3HH+80NdQbhpsqGkjnHubyHRGFbJO2tfD+oUcsIN3hoAy2EIR1Wv
         WACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928441; x=1740533241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PwxgaI2CeQipiv6np04CuCnpFX89Ht2qe65kPiXCVz0=;
        b=gbEj0MtRviVu4yxstqFdZ5ybGcVHtZdet6Ryqoau+3+XpSXvVoeUZ2wHyYUEofQRxF
         6wl+pME/wuZ5j4TCACSVo09+2IZh20T6uTVUXTOYv7+axpE4I2/vHtDhIekPgM7+Lj+l
         3HCHDMVnD8XLWFcbt3r11oIS1rz5Rod16OIus7t3G8BXjhRWxJnSn+TFdVY9aKlNdgNs
         TRDtLI+FcPQTL+4PVQ8NybkLqo3hGmom6Gqfpb5ajnH3badsiiEsYVrQ41/wbTPbx6aa
         1k5IPAujGzeTNPRYJPlfS/g8LxN7AYkQDVjbqHGObb26NrVY9ea5oCM4B0v6HQqDkDHC
         wYIw==
X-Gm-Message-State: AOJu0Yz8jgFyKD6StI5XPaPFVeNA0hoCrs+SM0Ex/SFb2pygSdKWHSys
	6fsbCAQvRBFJd6TDA1woCZ30RSg/m96a7JxBC6gno2Rn8wWtVc19kGZ9tF7yWvBx8BbCgR6mkPZ
	njQ==
X-Google-Smtp-Source: AGHT+IHJis5ONtqIAO2VNOmFspIDyiasqqxQJYi+5qvapE2J88c06Fq0obIwe/jPXwcuN/eIyBJbDFgl/3c=
X-Received: from pfbig24.prod.google.com ([2002:a05:6a00:8b98:b0:730:7c03:35e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a4:b0:730:9446:4d75
 with SMTP id d2e1a72fcca58-732618e4f34mr22523992b3a.17.1739928441624; Tue, 18
 Feb 2025 17:27:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:27:03 -0800
In-Reply-To: <20250219012705.1495231-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-9-seanjc@google.com>
Subject: [PATCH 08/10] KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Mark the VMCB dirty, i.e. zero control.clean, prior to handling the new
VMSA.  Nothing in the VALID_PAGE() case touches control.clean, and
isolating the VALID_PAGE() code will allow simplifying the overall logic.

Note, the VMCB probably doesn't need to be marked dirty when the VMSA is
invalid, as KVM will disallow running the vCPU in such a state.  But it
also doesn't hurt anything.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 241cf7769508..3a531232c3a1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3852,6 +3852,12 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 
+	/*
+	 * When replacing the VMSA during SEV-SNP AP creation,
+	 * mark the VMCB dirty so that full state is always reloaded.
+	 */
+	vmcb_mark_all_dirty(svm->vmcb);
+
 	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
 		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 		struct kvm_memory_slot *slot;
@@ -3897,12 +3903,6 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		kvm_release_page_clean(page);
 	}
 
-	/*
-	 * When replacing the VMSA during SEV-SNP AP creation,
-	 * mark the VMCB dirty so that full state is always reloaded.
-	 */
-	vmcb_mark_all_dirty(svm->vmcb);
-
 	return 0;
 }
 
-- 
2.48.1.601.g30ceb7b040-goog


