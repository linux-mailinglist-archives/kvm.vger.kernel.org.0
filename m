Return-Path: <kvm+bounces-7892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02333847DBD
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B216E283AB8
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658E17482;
	Sat,  3 Feb 2024 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2EnIrlHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539046A5
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919832; cv=none; b=ErdbMh+jjJYX/CyPZDnbhL2/MV/NdpBaH54BCvmfPTwmTnR+7ftsHINvlzKI7DpHPgO/esA9MjbTEgOSWjgWBkRsKg2cJsYeDWqWbwJfLI/OGc9HsD8Htfh09cSOZcOkNi0TvDU1O5XdztUk+KDNZE5RStcMAnmV1Xvzds3FUf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919832; c=relaxed/simple;
	bh=+txod2hID5r4KzljZQHI8kZJi4ylAzG2GvBBhxnFqJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tiZwAOujONSWAw3DIE3Z0ZdGeyNnuqcLWEkH7XGmWNzlNWY03b5XryNRrFp15zWTUUfKL7p3kNIX3gLGr/hXAWOGnEeVlnJgZgNEtfgoY0el3JsC2YF810VKN3hNOVIy4YXL0805+U5UUd+SLzXoF1l8fVoYd33n4NOj6cwrLiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2EnIrlHC; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ade10cb8so2754024276.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919830; x=1707524630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gdrXXYnWw+bLoNL2lm3uC9b/C5lFzeIuJK5MljquSco=;
        b=2EnIrlHCTa0QDVqrK5SXKWbVSnY9Q5aNcoylD8hqad54bzA+m179YKbCBskIg2/sUu
         J39i3Tyj35w9CR8T/ESiYE5mj8AtB3HR7/Re2s/7/EYq2q/jsKyVig49i9cxPpiomnru
         yPwDEECDccrwfknqvvuRNUiLVE1Y3bs+e4vdAz7otOZC18sjmpMeF2XbW+dh9PtddqkT
         uEsko5VPT1He9zFO19qWgfQNH6lbi9HzrmTUALmomZ8ZNznvZoKrY1+ICrL/uSW3Eihs
         +D/jBkD4r0V4sx45sK6rxHyvc2dgH95wTDL8mn0qKeZjssnyp+O9Rwpi3YZjvtNP9Wj9
         wSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919830; x=1707524630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdrXXYnWw+bLoNL2lm3uC9b/C5lFzeIuJK5MljquSco=;
        b=o4kH6KVA6GfGthX7lAauXfnTfJdCQlLHEplyUZl7atfwvJ2Ey4lCOn1qzQ+ieW1L0Q
         wq2qMQvNDjbvblFBQx5H2JmqqTCGH3/O97pojcqUMI0VWUyIFjHbQTWl5pj8dFlQ7du6
         O2rBkxXsKymVSVAVqli1V8VwFyh6/wrIq2sKfvJzjff8WI6ahk3sgS5FCuQWSKHOds8R
         pECDl5agaxfT/AqQXqwvgtDl7ewfNNubZp7Z9X0m8VHkI/UCsYk2OCXKlE5YlxK/yG9L
         MeXCPhtRenpux2gOLh2BraSuF1Ercmx55Ru5Io5Kf6kn1eppJm+DdWa+BXzJm+ivZ+Qh
         sp8w==
X-Gm-Message-State: AOJu0YzsUr08sRstqUC+721Jbfm8qGlIOjGzzjgtPBdhr0LN1XAlIAV0
	uenk1TF8Wff3gLAQ09Wf5s+73QvSEtZoGq/VLMlpa2RQuhPqyBG6FuhElcyZdULePD0+R15EEKc
	UMQ==
X-Google-Smtp-Source: AGHT+IHvKP/rATiXeqKUH+UrRwvrsL9ZmSNIDc5BWAvnn33fK4l2sC00BL98oqRDtrhMCdV8x0/7YNdE4IQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2208:b0:dc6:c9e8:8b0d with SMTP id
 dm8-20020a056902220800b00dc6c9e88b0dmr43666ybb.1.1706919830060; Fri, 02 Feb
 2024 16:23:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:23:41 -0800
In-Reply-To: <20240203002343.383056-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203002343.383056-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203002343.383056-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: x86: Drop dedicated logic for direct MMUs in reexecute_instruction()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM doesn't pointlessly acquire mmu_lock for direct MMUs, drop
the dedicated path entirely and always query indirect_shadow_pages when
deciding whether or not to try unprotecting the gfn.  For indirect, a.k.a.
shadow MMUs, checking indirect_shadow_pages is harmless; unless *every*
shadow page was somehow zapped while KVM was attempting to emulate the
instruction, indirect_shadow_pages is guaranteed to be non-zero.

Well, unless the instruction used a direct hugepage with 2-level paging
for its code page, but in that case, there's obviously nothing to
unprotect.  And in the extremely unlikely case all shadow pages were
zapped, there's again obviously nothing to unprotect.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2ec3e1851f2f..c502121b7bee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8785,27 +8785,27 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	kvm_release_pfn_clean(pfn);
 
-	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->root_role.direct) {
-		if (vcpu->kvm->arch.indirect_shadow_pages)
-			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
-
-		return true;
-	}
-
 	/*
-	 * if emulation was due to access to shadowed page table
-	 * and it failed try to unshadow page and re-enter the
-	 * guest to let CPU execute the instruction.
+	 * If emulation may have been triggered by a write to a shadowed page
+	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the
+	 * guest to let the CPU re-execute the instruction in the hope that the
+	 * CPU can cleanly execute the instruction that KVM failed to emulate.
 	 */
-	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	if (vcpu->kvm->arch.indirect_shadow_pages)
+		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 	/*
-	 * If the access faults on its page table, it can not
-	 * be fixed by unprotecting shadow page and it should
-	 * be reported to userspace.
+	 * If the failed instruction faulted on an access to page tables that
+	 * are used to translate any part of the instruction, KVM can't resolve
+	 * the issue by unprotecting the gfn, as zapping the shadow page will
+	 * result in the instruction taking a !PRESENT page fault and thus put
+	 * the vCPU into an infinite loop of page faults.  E.g. KVM will create
+	 * a SPTE and write-protect the gfn to resolve the !PRESENT fault, and
+	 * then zap the SPTE to unprotect the gfn, and then do it all over
+	 * again.  Report the error to userspace.
 	 */
-	return !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
+	return vcpu->arch.mmu->root_role.direct ||
+	       !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
 }
 
 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-- 
2.43.0.594.gd9cf4e227d-goog


