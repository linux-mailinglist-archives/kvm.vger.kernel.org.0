Return-Path: <kvm+bounces-7891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A84D847DBC
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8A33283A79
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA03468F;
	Sat,  3 Feb 2024 00:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5M0nWAW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC7164D
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919830; cv=none; b=QGBXXEo1a2dzQp6pgP1586vACeyaLElhnXJ3V4YFSCcoP0kxQC6OtzA3nNyOKuvikJqPei+lSTnCPlKY2vYJaexxEUn2aqQMb4T00vSpSi8qIyUfyb0nViYy9QA4m7eQZUjayBFpKpyNJ0mSBR4QxVjMlD/cTQ3g7VEGj8Mygiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919830; c=relaxed/simple;
	bh=F3gM+mRPBb7pChqqTVYezZoTdDnp7w6wvEhOfKxw6A8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LcU6U2cCmV/Bi0605/027EkEK7E7pK3a2HRHnaO/jPsur50IY0niR0QaSwrElIovr2P9GXzDcwWB2Z0Ddq4GZffbr1B4FTXkhMu9d9aYvKLefpaWEY8dm2kxpQ54wConzSMyOSu9W8n9/I7moenUl3JsNELveyOUWb0mlFj1h0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5M0nWAW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2965e421c73so424100a91.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919828; x=1707524628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uDSqele7NE0OONssRlZQ9urUuntmdp88j24rPAm3SJc=;
        b=E5M0nWAW8IvkBQKGzVtATR37ylWds7zkYJd4IH6XutkuptQ0M4hYmSC3dQosiUo8+R
         HGf1LRG6sUqcCNudx7Dn77aI1u9TgHXjQHZtstHL7yF8eK2d69XMjw7h7abYnr+e0uKj
         sdBWRF/Jxo4Fux9X5yKCt7BanLpEkqNYdCvU0dENN+2dd912mych3zZoOiTKiRjqyefG
         MSNjoghukRTpA8/DWANl5E6mfJsfoKBOwU0S2QCQOwbzYQnC00U1CjL+ZKfiWRdRwVwc
         r+8XhjBBe1Ok5nJDGjpqRYFI2iAGja+ZHtci17sKzmy4sPPSxZ4iQdxisqsCigeptyeo
         sYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919828; x=1707524628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDSqele7NE0OONssRlZQ9urUuntmdp88j24rPAm3SJc=;
        b=ARf7bEiMl2+s+pcNBx4jw0wqboQr0ddyS/5NUOemGAD0kM/+GzAowh0BqP8WlsfW3Y
         ClsFYRyklZGJRyNTpqiH6DPQoiCqpmzHz80sE+OSMzlnRpyceaMqUD6mcWPn3FLXUpTK
         39VmqJ+bXeNO1DSXX5rCGfXsZZtseImJFZzX26ERepPALZDje+mIWfPYcHEu4UocKCFn
         AKV+yUXO9mYICsSQaql2BSaDuyxW0qPGN2MzAvNN5E/AQMALjoQ0wR8JJQLUp599l+jl
         IDLiBBVbKg64Y3xkx9euOHDCTciOUA+A7V/2Hz1DnobnbbfTxgsWMgUyCiTDs6KIobXh
         0mQg==
X-Gm-Message-State: AOJu0YzGZR2mm7M/mvNADOYoWdcjuXy8v6OynuFOAvinwltHvie6AsOA
	gg83zWTPFxqJqKZIsl8WY33ks0nCrdJdEe2jb8n+nsHZv3r7Txavka0+EtN2J8AlZuYDeNb1TuE
	5gA==
X-Google-Smtp-Source: AGHT+IGZlK5BxEG1BMmbcQ2/Jse5hoja4Dn0N5mQwD6YTOdKWTQsBPE9VCAtqp/a8VZd29eQ2VMQMSDz1Ks=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:48cd:b0:296:30e4:2c2d with SMTP id
 li13-20020a17090b48cd00b0029630e42c2dmr82613pjb.6.1706919827886; Fri, 02 Feb
 2024 16:23:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:23:40 -0800
In-Reply-To: <20240203002343.383056-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203002343.383056-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203002343.383056-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: x86/mmu: Don't acquire mmu_lock when using
 indirect_shadow_pages as a heuristic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mingwei Zhang <mizhang@google.com>

Drop KVM's completely pointless acquisition of mmu_lock when deciding
whether or not to unprotect any shadow pages residing at the gfn before
resuming the guest to let it retry an instruction that KVM failed to
emulated.  In this case, indirect_shadow_pages is used as a coarse-grained
heuristic to check if there is any chance of there being a relevant shadow
page to unprotected.  But acquiring mmu_lock largely defeats any benefit
to the heuristic, as taking mmu_lock for write is likely far more costly
to the VM as a whole than unnecessarily walking mmu_page_hash.

Furthermore, the current code is already prone to false negatives and
false positives, as it drops mmu_lock before checking the flag and
unprotecting shadow pages.  And as evidenced by the lack of bug reports,
neither false positives nor false negatives are problematic.  A false
positive simply means that KVM will try to unprotect shadow pages that
have already been zapped.  And a false negative means that KVM will
resume the guest without unprotecting the gfn, i.e. if a shadow page was
_just_ created, the vCPU will hit the same page fault and do the whole
dance all over again, and detect and unprotect the shadow page the second
time around (or not, if something else zaps it first).

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: drop READ_ONCE() and comment change, rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c339d9f95b4b..2ec3e1851f2f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8787,13 +8787,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu->root_role.direct) {
-		unsigned int indirect_shadow_pages;
-
-		write_lock(&vcpu->kvm->mmu_lock);
-		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
-		write_unlock(&vcpu->kvm->mmu_lock);
-
-		if (indirect_shadow_pages)
+		if (vcpu->kvm->arch.indirect_shadow_pages)
 			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 		return true;
-- 
2.43.0.594.gd9cf4e227d-goog


