Return-Path: <kvm+bounces-23762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C8E94D6E2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E25D01C21D31
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB7D1993A7;
	Fri,  9 Aug 2024 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3D/xdQ2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDF519922A
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230229; cv=none; b=JpaK7eu907vGYCBvpMd+/XppkUrW0GyiMk/7v/Fe0hTEHQP3TcL5GSjJOSJYsPKOmPqXLpP7fmFcbLZn5w3fWCFC+LIxdNdoOx1zncJ7FaUlpl3nCDs+sUQOnN652ZLdXn9RCtGaQSKOD4rp+CFHHLc8ws2WNd97EKQECwvVgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230229; c=relaxed/simple;
	bh=H5VYBxwz21vxlZmMRXdu3AJVQuY7buVv49eVdc22C0U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PYUag3OTSIOEYXvu6XnVq5l625Yz+syIp3JQ7AKl9fV+NJdz1jKsTJ7zRED1H+k4RV9e10yuEyQ5JME36j8jzih5ElWz1xWm9cyd8mehDqcIs3LRdacs6OC2vWOEtv9FMMI9cxV2Qub7jdSazN6A9PDY3PKixQRG5hPb1+XxAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3D/xdQ2D; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd8a1a75e7so23103185ad.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230227; x=1723835027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wRBh1Yq0HIE0LrqUowwJYclZkwSPk2840j1yHgVdQPA=;
        b=3D/xdQ2DJzCQP3vEfTMmnPdy/OTKSFcO/8Y7EjP+OxrYnAK905f3r19QARJu/mCmpW
         k6TdEK/8Y+QwBcIsV7LCyyFFeuFYkOyB3Lb/m++kDAkxQ/WvAM4I8IA9c0mXfwQSpr4y
         rf/lytcCP+pQTgfRxsf7RvSvaIcMC3ckzukkQz3WYHlr/1HJrkLycTco0sxHvQB5Zq5z
         //4ys3CrCUO8QEpJkPxtUffVLBXPNHmpfeIWdNCLZ5dcw8pRqlb+b+WPUL79yxzE5kwY
         9AsQMoFvZ/4dGKK1eNC56MzgOCrxQymfM/dHhrpwKAj8stDx5viKRLdYf/swqMAQnLlL
         N6zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230227; x=1723835027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wRBh1Yq0HIE0LrqUowwJYclZkwSPk2840j1yHgVdQPA=;
        b=HIodj8SdPWR7mK33CA4PXFP4FME+EYQIfRANn9ZG/J+zqOStSgnU/RojIBUlAwZE/5
         GqdzLL56RARAB8a3Fo0R/U4MT0xQCQy0utosgypF7sLo0EZmdlBlw+2gvJmlj4+0JaPB
         IsTyhgKsHI5x9ZBU3u61oOxR0IP8TVZJk4ShAQMHBsqjSMU1EC81ra9Yb7cKCl9ivANe
         tVDYXAT4I6U5h3pwCvub8hcZCtliS3QIWKgXXZH+IiYiQUcQSEFqk3vwA6eV+AGaNYlQ
         A68/U+LbU5Ki1wepcFKJy72mVc0dZPQYwSPnnSIWQ6SzkmXAdWDmzz7ks/kn4hfk0ANb
         cdLA==
X-Gm-Message-State: AOJu0Yw1m2xwgj2mPG97yJcv0F3prOTgE1QF9+jznOIdbsRRMYeu38CJ
	WvwPLCTLAi8vXwd0VNzBPRFuxjfPDCjAUbDO++TiInWz+1brPnGoJsC+9rydcgNlQyn4UYHsY/W
	sQA==
X-Google-Smtp-Source: AGHT+IEFKdM8xue3Odmp4NwfLFd4bvZYSXUmHSlUZu20h4ZixmSV8G+oSrO/GTtZZlzBDf9TdiNKX+NlKww=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2441:b0:1ff:4618:36b8 with SMTP id
 d9443c01a7336-200ae5a7a86mr1534465ad.11.1723230227071; Fri, 09 Aug 2024
 12:03:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:08 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-12-seanjc@google.com>
Subject: [PATCH 11/22] KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the sanity checks for EMULTYPE_ALLOW_RETRY_PF to the top of
x86_emulate_instruction().  In addition to deduplicating a small amount
of code, this makes the connection between EMULTYPE_ALLOW_RETRY_PF and
EMULTYPE_PF even more explicit, and will allow dropping retry_instruction()
entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5377ca55161a..7e90c3b888c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8872,10 +8872,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
-	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
-		return false;
-
 	if (!vcpu->arch.mmu->root_role.direct) {
 		/*
 		 * Write permission should be allowed since only
@@ -8944,10 +8940,6 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
-	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
-		return false;
-
 	if (x86_page_table_writing_insn(ctxt))
 		return false;
 
@@ -9150,6 +9142,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	bool writeback = true;
 
+	if ((emulation_type & EMULTYPE_ALLOW_RETRY_PF) &&
+	    (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
+	     WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF))))
+		emulation_type &= ~EMULTYPE_ALLOW_RETRY_PF;
+
 	r = kvm_check_emulate_insn(vcpu, emulation_type, insn, insn_len);
 	if (r != X86EMUL_CONTINUE) {
 		if (r == X86EMUL_RETRY_INSTR || r == X86EMUL_PROPAGATE_FAULT)
-- 
2.46.0.76.ge559c4bf1a-goog


