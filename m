Return-Path: <kvm+bounces-25595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CED966D4F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60CAE1F21105
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 973F642A93;
	Sat, 31 Aug 2024 00:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4P17CCHH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA6679FD
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063364; cv=none; b=KmwtM2TDlHGqTUyaIrf/hTmUgoCwZVgHj/2biBxjCQAwiTvQgXm0C4q9GYbMnsxnBMH+Qy6xExBGzL4DNyF8qinCqfJ5DHMuRX+NR4u5zxcQtuLkkC2SZWm1PLPwWMv/Wi5hBoc1QuLjoejT5p+IFf5UwRwC6pRxA5IQMjEMobo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063364; c=relaxed/simple;
	bh=Gt/hYCvtkqqT087VrypTyzp43782ZGBu82s/aGaFlhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wy9S3fs+vzaTOge++lSyxIywm9p4mLJPI+zuBCj5sWa/HkzeJIiKXhiaK0wr8UT3M978+wG4TUi34AQu1ekfXdAtu6AWCJFqGri04WYpr+dN4+dOEme9janBD7Y1ZPKVH/6v//J7uEzg1iMzr+J6misjYANcVODbzkFlBwTzU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4P17CCHH; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2053f4938c7so6194095ad.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063362; x=1725668162; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=REcqlnagGsiRzvNxOPvSFUigo/12XdRKebv9ZoVRwHA=;
        b=4P17CCHH9cUyr35Ptu3Cp5aJpTAhT6f9U8msd7v1QhWjWMIYHtwFCwn5P6Crt7cRRY
         N6E6oUzAs9H5EGTsbBwVJ4GuYUdbk2SRil7Da5W05L/pOvfOVhtQck2wzFvx/i22UA+Q
         hDDsIASA5z4ZCrPR6wdWd7PevV8Wu1PNoki6y5aICA+MENKVxIbn39ZO1UeAkutIOoKB
         nuEFtAwx48ihfeNr8K3ed+NA3P0NG5Nm+o472txGcT9tRYGg+Y3DvenRIP/DDXkoHvMJ
         YwQFncsundD13wItLYdaqn6hdZ5PHEHPC9jLri5C88/go6K8NkJFvrKhp0uVAGQrRL3E
         VB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063362; x=1725668162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REcqlnagGsiRzvNxOPvSFUigo/12XdRKebv9ZoVRwHA=;
        b=A+gD95uVqlfQW17vZZMGhAj0dyGzKxp4DCE9BlgexYHJgFb+L7lsNh5wE+Ulj83cOj
         SVk7KD7CdW/ojNb7dWnlPy8OkfRtba9MKUUBqcW6NgRnjtibSPsQtUTevdOSs0Dm6zhX
         c+BseZqY8VnGDrsrYtegbLCyllCIvaC0VqBPBD0k0YwPu+/GduwYnGj5JqKqH1pD853b
         mBcfx0Sp5wIJiSxKNi1v7t7/DRsxxM8zlcZVD1hIKcqtOLjjXURcGnntBPxDKtv5AnO5
         +jJtLCUQKz7eSNfOYO+ruMnLoiq7+C9SvGKLpeR66GIZv6mCgvSkPpQfKjBBZwONCKEQ
         dW5w==
X-Gm-Message-State: AOJu0YycIJxMktrJHMQy7DJfvUwpZdhfQUWZy8RdUGrnOUIDgCg9Vefp
	KAtlKdYKtzG+iDtesjXThqr0R9lEL+QR+TxM3ERtY1gVSZyco4NRfaWrsdhS8f+yz3RAhsXrbCG
	Wyg==
X-Google-Smtp-Source: AGHT+IH1Nilzksm2OfpsDzscQSy+ZeVt81YmGO0kRIhD+rE737Nd1fk81Tkpfa9/YV68oh+vNJ/7FWAw/OI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fb0b:b0:202:232b:2dc6 with SMTP id
 d9443c01a7336-205276e1f97mr726825ad.5.1725063362502; Fri, 30 Aug 2024
 17:16:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:26 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-12-seanjc@google.com>
Subject: [PATCH v2 11/22] KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that retry_instruction() is reasonably tiny, fold it into its sole
caller, x86_emulate_instruction().  In addition to getting rid of the
absurdly confusing retry_instruction() name, handling the retry in
x86_emulate_instruction() pairs it back up with the code that resets
last_retry_{eip,address}.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ddca8edf91b..c873a587769a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8920,26 +8920,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
 }
 
-static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-			      gpa_t cr2_or_gpa,  int emulation_type)
-{
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-
-	/*
-	 * If the emulation is caused by #PF and it is non-page_table
-	 * writing instruction, it means the VM-EXIT is caused by shadow
-	 * page protected, we can zap the shadow page and retry this
-	 * instruction directly.
-	 */
-	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
-		return false;
-
-	if (x86_page_table_writing_insn(ctxt))
-		return false;
-
-	return kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
-}
-
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
 static int complete_emulated_pio(struct kvm_vcpu *vcpu);
 
@@ -9219,7 +9199,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return 1;
 	}
 
-	if (retry_instruction(ctxt, cr2_or_gpa, emulation_type))
+	/*
+	 * If emulation was caused by a write-protection #PF on a non-page_table
+	 * writing instruction, try to unprotect the gfn, i.e. zap shadow pages,
+	 * and retry the instruction, as the vCPU is likely no longer using the
+	 * gfn as a page table.
+	 */
+	if ((emulation_type & EMULTYPE_ALLOW_RETRY_PF) &&
+	    !x86_page_table_writing_insn(ctxt) &&
+	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
 		return 1;
 
 	/* this is needed for vmware backdoor interface to work since it
-- 
2.46.0.469.g59c65b2a67-goog


