Return-Path: <kvm+bounces-23769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC8494D6EF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:09:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8655B2873DE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13ABE624;
	Fri,  9 Aug 2024 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UrxlA6W2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB98E19B5BC
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230242; cv=none; b=MNuofsRwYBzfpEZQlLkHo5r8t4fOv2ai3zo2LVEeds0CBB+tygnDp9ZaoRkvTWSRRFe9wk2vxNMrqJnsvKmgAiXPSZUNWqISGEkD7npmeNzvUYK07WgCSUUcnR19T7C3G4hyb49Rwbgnfd7gl+RywZUHXPJJlcpQmb0yzSwcn04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230242; c=relaxed/simple;
	bh=OP2Xm/eCfjpFyHsXtR5gMPIrKC8fRopal9cAbGgO8xI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DypeR1Era8INJCAA4gg3ok84QuYZs4nucjXvvDLJyOJBhWbPHC/qJbactnw0poKNsQYqrxw4Gj33hMA7ld+xFK/6dMcl7LhjSxM0byoEb7FrYayxXNUEjTNLzp5pxj3+pi9s8wFCu645cOJOHZK+XDFbG5O6vgLvc7g1c7Crpto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UrxlA6W2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ff72ddb631so19954895ad.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230240; x=1723835040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8EFwojLdgCXRArpaY4WrRJNxw1pZl6kTHVRAl3enDUk=;
        b=UrxlA6W2axWrmkJW/aK/C81Dro0T2orEkmqitkMhvYQoVge8LUz725tcTa27ArHi4i
         AisSFJ/RxN8abI8+BvlWFGo0RoMM0UJofAgI10YEdlKQcZduQFxnM58D/KlawXWKiDF9
         QilZeWFRz2fEDBcn6mChX+1GvfOIk4axZJckLL8roYsezwMElX161+q950zCWAzN4AP4
         zux18oYCPuHNKsRJGuw4bT8SNciJ9a559ZmgWkCpbVxnisIOHDKJ0b4jQbm4OSSXefUW
         GSC59q0pD85uCd/U4GUozkI+N5uGux33Bzt0P939WJVC1E/7fV/O9GHgfMxFEU4Hj0jx
         l17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230240; x=1723835040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8EFwojLdgCXRArpaY4WrRJNxw1pZl6kTHVRAl3enDUk=;
        b=cjFemqtmMiCbygKIO2qsB2OhP8C9iR/Y20gmuWtsgeGjFhhAtZTEnlqRcHuux2dk6f
         wCfy8C+5CT9gHOUsUVGqvtsFykBJIdWSS1RyMc2HU8KFyP82WZfJE9Se//Bs33NmSuLu
         PnPgANeNjmkvQJ6ECuiluUeZwXpgxaALZP8AdUqA1fLzolBZ2kK47brFqRr2I4h4/Y6r
         Jd0mUwkKg0haGRlHsorYOv1rtuCg1thSkeKm32aCe0+IWg2jxs2MwZa2QVTUwzsTY/Ci
         Wm2wxZbcLyzWFbMxP7jZSQarl6y8ugKskmGaTjJ1hdS3leq1txCHTI5Prn2hIQYAzSn3
         HKHw==
X-Gm-Message-State: AOJu0Yx5fTBwvi4D8ZrCwsadEnPV3o85nehX3YJ+5xCXQ5SHlXz5hLN1
	QjduGbEBaHwmbhJZtEKAU1giOFjMEecAkh+h3Cl6GccQ9qjAjtdPSHitdfauEHTe0M0/W6Y6aJe
	bgA==
X-Google-Smtp-Source: AGHT+IHL18+pCNoijbD8KFo1R0+dsdp7SJvyPnWEUeMEzIHpCRLtjzjhtG6pvSImezAFhKPYfcjJa5aR9lY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec85:b0:1fb:72b4:8772 with SMTP id
 d9443c01a7336-200ae5d42ddmr1281035ad.10.1723230240209; Fri, 09 Aug 2024
 12:04:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:15 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-19-seanjc@google.com>
Subject: [PATCH 18/22] KVM: x86: Apply retry protection to "unprotect on
 failure" path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Use kvm_mmu_unprotect_gfn_and_retry() in reexecute_instruction() to pick
up protection against infinite loops, e.g. if KVM somehow manages to
encounter an unsupported instruction and unprotecting the gfn doesn't
allow the vCPU to make forward progress.  Other than that, the retry-on-
failure logic is a functionally equivalent, open coded version of
kvm_mmu_unprotect_gfn_and_retry().

Note, the emulation failure path still isn't fully protected, as KVM
won't update the retry protection fields if no shadow pages are zapped
(but this change is still a step forward).  That flaw will be addressed
in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbb63cf9fe2c..ddeda91b0530 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8866,8 +8866,6 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  int emulation_type)
 {
-	gpa_t gpa = cr2_or_gpa;
-
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
@@ -8884,29 +8882,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (emulation_type & EMULTYPE_WRITE_PF_TO_SP)
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct) {
-		/*
-		 * Write permission should be allowed since only
-		 * write access need to be emulated.
-		 */
-		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
-
-		/*
-		 * If the mapping is invalid in guest, let cpu retry
-		 * it to generate fault.
-		 */
-		if (gpa == INVALID_GPA)
-			return true;
-	}
-
 	/*
 	 * If emulation may have been triggered by a write to a shadowed page
 	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the
 	 * guest to let the CPU re-execute the instruction in the hope that the
 	 * CPU can cleanly execute the instruction that KVM failed to emulate.
 	 */
-	if (vcpu->kvm->arch.indirect_shadow_pages)
-		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
 
 	/*
 	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
-- 
2.46.0.76.ge559c4bf1a-goog


