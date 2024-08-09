Return-Path: <kvm+bounces-23763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6033B94D6E3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 877B11C2226C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C171C15920E;
	Fri,  9 Aug 2024 19:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ILoWDIGr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C9C199392
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230231; cv=none; b=jPs9bd+rC6/J7R68eotgpMkDhJYVkjpd2bCMkg1Tsj6CzfIjP2dlof2py/YV0K3iv806xoSED9AiIADO1seOcZGgNO+zzTWcQt6mQWp5IcN8z7ljM3tXEmhQPOy6+ydRpOWEZqCgwjyGKEYvHbl/V3X20fsHHaYjh9ptsXolZdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230231; c=relaxed/simple;
	bh=sCYMMA2rJwBRxJrTSDkgNzKiSx1xbuccHFqpbX0NI+c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dc7mk5Vo1oZ90s2Fu+kJm0m7jKdigjrJYAIuVQcp5oYRHHaRmeuKUPpZcNQa2n0dQHKl8J5GVPxLMgmYcgAAl1tzUAWnaA6al1p4Xm97rFfHDubRaZmc1uSyBaJ+pNY1BRFgEUqV3YtvL1BUw73LJ59sJjGZZu8OGMrgs/2ksMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ILoWDIGr; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a12bb066aaso1802292a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230229; x=1723835029; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UL4xGW9Vpu7Q61ctxbdglUexBeIvbgO/x5cgODPhM5E=;
        b=ILoWDIGrpL5yE7HUgxssXh0ZcD0yqedEE0786kfhzOKs20v/2+aX2qM4+U8k6REoJW
         fhEEZQLH4utHVRCgRJfzwTr7ufKkUgi/8uWbbms2rR0RHlEgGEH+9ZzvHYMKgn+C9DLF
         /gAdsZq+I+Kbww8xgKOnEwb7uRSHgTj7dMk3k1AX7gbxcPLPBJYIDyBmTVvpe6Ixxw3f
         zejhsfU+KXLpKgRIRsHtfI6HOIgUV/ThE/IeP3qJEh0NioDJXguuRmhDlKohUg5mBsaK
         sW83UsA/wvoKkmLjkh4MoxNgt5EWZKeUFkAfjajuVGlbtGIoRP0f4cQXQLSbSRnIOhYn
         XswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230229; x=1723835029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UL4xGW9Vpu7Q61ctxbdglUexBeIvbgO/x5cgODPhM5E=;
        b=XGq8JxIH2xQ4naSwqiOVAERi7xLvVblf0RwQJQrAB1oZf8D5JmoWAFuF2FeOBdKL5m
         Z42xIdlF261NlFh7gVbApXqqvPsYWbDlIGpxMX3DJlr44RdSPOol5CARDVLXgbR8/tiB
         gQa3LZ68Q6FMLRSCU0qjEphPXxkPXFpdI+AG2BG84dSqFex1svGnhOXWhbweKLvS98iH
         qYMVxi74ttDYjZOmJ24nl7ZMfNwvaEJk3l399f5/lQvTQRVQilzdC93G1IyvJM7tbG4s
         k/SrFHXzRX8/BMYA0n3iXsWhYNO51VEAmaNvi6ZfD/H+Y7XrMyve0KcgJmDyVUqpa/Bj
         dFtw==
X-Gm-Message-State: AOJu0YwCsjlM7xXeFjBmWkJaHdIihd+6gXhLEwnnSww2k9HlxfLimsd/
	RmKj+0zd45IrAF5PB2sZ3kPDUYpPPIvRGyuCFg/p+toHQtcmJ2zJPjL7dJTU5aDqnWJcuo+Bj+6
	btw==
X-Google-Smtp-Source: AGHT+IEWNryKfrDGJ6A8ssPAg413DCCTFIkgK0+hprcIqq7sfsduMvpY8oVW+ZWuuTwECASFLr+r3u7EGWQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d490:b0:1f9:ddfe:fdde with SMTP id
 d9443c01a7336-200ae5cde47mr1585545ad.9.1723230228793; Fri, 09 Aug 2024
 12:03:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:09 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-13-seanjc@google.com>
Subject: [PATCH 12/22] KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
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
index 7e90c3b888c2..771e67381fce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8926,26 +8926,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
 
@@ -9225,7 +9205,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
2.46.0.76.ge559c4bf1a-goog


