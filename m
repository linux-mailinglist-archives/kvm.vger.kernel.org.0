Return-Path: <kvm+bounces-23757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5953794D6D7
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 888671C22136
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036861940AB;
	Fri,  9 Aug 2024 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CsE49SMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE37B16B73E
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230220; cv=none; b=srudYvYLrZISOdm2r1D2nukmWo1OOgvBsyLBvIjhx8K7WD0wOgzYpnZHBHgF9xm9n4G2yvlz9Qi87R40YXjv3HVXOzs+54WF3inEO5coFY6yo9TREFrwlHjA3PZEizoOSxGV1Edf/0TmaQTEGgCtQ56UIALFdbnpPdZotgMxrDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230220; c=relaxed/simple;
	bh=21Oqbef94jP18zcmD++heqnas/lAgBbqRkP0cSKsWBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S84kbQhJdnWWCbbhA0fCVyd3l4DurMRAhONYTpR41Zz6lNIbIwj5P4/usKZ4+AZQYaOoLCNwj3pPcg+VZBuCpESYCg4nkHhlSVrKMAG0JRVntBGl1Xsj0+oBnCoMJaeaM0kkrfjJX3zC6GwFf4YozIuudSLfYei7nkXWPFxk4sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CsE49SMl; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-79028eac001so2522594a12.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230218; x=1723835018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PEo03FT/iIpJNEkcG69iehsrgcwll+jefs5K49ylrzM=;
        b=CsE49SMlL7nWanmZvTPdH6LvkdOzHU26mJ5JlEsfPgTJXu4AOFYZkq10s7hO9mqG8t
         RZQrWRqY3nsHSzXneNzBfQ0u3xcvtJ9RyFQqyJj6jjEYc4/kz+6OWhVPavppyppxA1BM
         83yvDojTNxcGyAb522UrBuMO61CDyUBTzNY6ZFAXPYBp201pErBD+5GpLZjqPjuq2+/r
         5pepx/FKt4oO3OKQgjf3wVaOzKdY/QaR89mIKFcxRhfm2210RHEGRZYLiL6ft8V6+YiN
         qy1w3BTkPXxlIva1y+4yCGX5vnB9xQL7HsnV5cMaWzjSH0155izC4OklzaOXC5d/ex2t
         uHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230218; x=1723835018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEo03FT/iIpJNEkcG69iehsrgcwll+jefs5K49ylrzM=;
        b=hp7nA9jC5FvDKHVPcCfg5xo3GGENIC2DJyQsmeK6zhVapbIvdpbSVkThgh6gQxquT0
         676F2XzXG/WKGCCAvQsagMmKBgSV8aSzvAc15sEPuBCMTFMwiHN8n6TR6G39515Y30/p
         oTXVf0i1PTeZAau/wJ8+CArKD5QPK0b8OMbEK9ePuvvhtdkrStf5x5D9MyiyetWv0AxP
         w576EFJNOLcQCC4BunE0EbgSP8McXR4JERzrTEA/4v0ilC8BS5L/4aKLyr9PuK87BnhN
         J/KMk/bZKWrFT3S1qaxmgtqM7LJWjj/5k1flN2df+UqUL3XsRcQP+YtZZCDCEjuU9Cfj
         pK+A==
X-Gm-Message-State: AOJu0YxvtLItlND9Hm3d1scEsLxBetJ/broGNrvGPXw/J3BQFNCx+9QI
	kk63yuK+PGjPlCv1I788qPGHKif7OJZ7/dc0SlX/nH1gLDPsR2rXXmte/m2cCL4hjFjXAzGrDRC
	R3w==
X-Google-Smtp-Source: AGHT+IH5LOjJ12m73lV027giJooc8yKy5h6vOUlHboXG6c+B/Zn9yoHT1SD7ZeiYbKu/63dWHfYsnexMC/M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74b:b0:1f7:3e75:20cf with SMTP id
 d9443c01a7336-200ae5cb75amr1696075ad.8.1723230217981; Fri, 09 Aug 2024
 12:03:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:03 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-7-seanjc@google.com>
Subject: [PATCH 06/22] KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Read RIP from vCPU state instead of pulling it from the emulation context
when filling last_retry_eip, which is part of the anti-infinite-loop
protection used when unprotecting and retrying instructions that hit a
write-protected gfn.

This will allow reusing the anti-infinite-loop protection in flows that
never make it into the emulator.

This is a glorified nop as ctxt->eip is set to kvm_rip_read() in
init_emulate_ctxt(), and EMULTYPE_PF emulation is mutually exclusive with
EMULTYPE_NO_DECODE and EMULTYPE_SKIP, i.e. always goes through
x86_decode_emulated_instruction() and hasn't advanced ctxt->eip (yet).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2072cceac68f..372ed3842732 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8973,7 +8973,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
 		return false;
 
-	vcpu->arch.last_retry_eip = ctxt->eip;
+	vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 	return true;
 }
-- 
2.46.0.76.ge559c4bf1a-goog


