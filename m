Return-Path: <kvm+bounces-25600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 409A7966D5A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73E611C22514
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFA113B29B;
	Sat, 31 Aug 2024 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OLlVQGX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4B9136E37
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063376; cv=none; b=alEkMRGkoiLjElRKkPmRqH+JCseeZRGdyhs+pf5J0y95M7npS6xvyvSjKAWv3ZGg8uwf2otNOwLlpwXxo8m3m6B4VwuWN+iz14Q6x8Gx7GYLbhqgwtZOT4qPqdTOzWMMMnUe5CXIjO3rm0RKo+CZW1dlu8yX2F+OL6Viwfjc0k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063376; c=relaxed/simple;
	bh=03HGP+MpByrZ7kzxrpdb3wvh41fpQldermKrn3cjMQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JmdizYTA4OZj8TYjCOb3oiJtfwmHujtD1mO3F7W4UDP1Kt/gT6LvJRCtJ8cM4V5dCa0Qcp/ILUnw+4sGPyU2B+Xs37kGli9qwjDe0XsKbAm5HJ1etQlW0/c6YQ2DyVuojVfnm+4t2AcIDesGMDpa7hukqoNSxAGSgUA8oMmq9+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OLlVQGX4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71439227092so2565210b3a.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063374; x=1725668174; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NOgdVNwQvUHFMsxLXjZ7EYJ7UIxi1DX2us/omkckfEs=;
        b=OLlVQGX4/ynkZOD+R7thBD3Acongqwxk1ZaX2reavQ+yWutoQ8sucH+A9BtccsKz26
         W5bOfSw7BidX4CyHQ0OGYU07NKxpmMXzNT/8XRELr08HAsBLGgEUk2QYVJonUvuUOssX
         BW8NHZtmHjhhL/J2t2ORjGZM+tuAj11l/AEGOImE4wyvCh2cR69gGwV02Jnl32zYEF54
         WuC39hI3Et1Pt+9W0l+/9x19gjMWB+Qb8H8McniOyv8AkyJsGxLUBV97PJgFt+1Da2UM
         eA+3j9HlnSsfOuTUU5jy8RZp6qYy6H3s37GlMSB5GSfHtzCESfJ9/jt0ewQWx7Rtfn2f
         mlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063374; x=1725668174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NOgdVNwQvUHFMsxLXjZ7EYJ7UIxi1DX2us/omkckfEs=;
        b=EPTyMqw8CsTKrGTzFCytW70JD7Ay1mmaDexOnr/nz92w2fYEKtZyFaGWZsyQdvvlDX
         RODG2mYWhEyDDwo1WGidZdh9ud1MX5r/tdmHtuGN+sxJtP97s8lPfa3cfOxfXCjxsZ8m
         lVgvwnJqbhNg4Sx8skhE1amct4NI6OfMF8hrg2QcPySNmsIA8s01urMHtNuc94XOY4Pv
         bUy7UVD6tV9YG08ML1Xq5MxxyOlpk9t9seXI5iEtS7EOGLXwbAWH3xVSAi/a4+H8KPVI
         VuMn8V/h8eE2zjECwV0SpIAqY5yBTiHHl6mLaUNqWxUIK7iFlhoYhi9hF+U8WaIfnxY/
         CzjQ==
X-Gm-Message-State: AOJu0YwTORtU40Pac2pD9UU2ENnH19gK2RWYy8xa0wB5nIHwkMpHAn2J
	W8gXfVT3bciCq5vBuUqld2gSvXaqp78pqxMrY/D2GaSRoRfWZ3Qmpmsi7czvn0eHxgcTCOxA3Le
	FOA==
X-Google-Smtp-Source: AGHT+IHOxjcI5NDjaRDWXOQy4s+IAV1B1/GPpRSOPNEGZ+Qxs8WEg4mv+/mZzSMwknbgpQWTaR+XmVIYezg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9444:b0:70d:2a6e:31cb with SMTP id
 d2e1a72fcca58-7173072f5a5mr11018b3a.3.1725063373855; Fri, 30 Aug 2024
 17:16:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:31 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-17-seanjc@google.com>
Subject: [PATCH v2 16/22] KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before
 unprotecting gfn
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother unprotecting the target gfn if EMULTYPE_WRITE_PF_TO_SP is
set, as KVM will simply report the emulation failure to userspace.  This
will allow converting reexecute_instruction() to use
kvm_mmu_unprotect_gfn_instead_retry() instead of kvm_mmu_unprotect_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23be5384d5a5..ad457487971c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8865,6 +8865,19 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
+	/*
+	 * If the failed instruction faulted on an access to page tables that
+	 * are used to translate any part of the instruction, KVM can't resolve
+	 * the issue by unprotecting the gfn, as zapping the shadow page will
+	 * result in the instruction taking a !PRESENT page fault and thus put
+	 * the vCPU into an infinite loop of page faults.  E.g. KVM will create
+	 * a SPTE and write-protect the gfn to resolve the !PRESENT fault, and
+	 * then zap the SPTE to unprotect the gfn, and then do it all over
+	 * again.  Report the error to userspace.
+	 */
+	if (emulation_type & EMULTYPE_WRITE_PF_TO_SP)
+		return false;
+
 	if (!vcpu->arch.mmu->root_role.direct) {
 		/*
 		 * Write permission should be allowed since only
@@ -8890,16 +8903,13 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 
 	/*
-	 * If the failed instruction faulted on an access to page tables that
-	 * are used to translate any part of the instruction, KVM can't resolve
-	 * the issue by unprotecting the gfn, as zapping the shadow page will
-	 * result in the instruction taking a !PRESENT page fault and thus put
-	 * the vCPU into an infinite loop of page faults.  E.g. KVM will create
-	 * a SPTE and write-protect the gfn to resolve the !PRESENT fault, and
-	 * then zap the SPTE to unprotect the gfn, and then do it all over
-	 * again.  Report the error to userspace.
+	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
+	 * all SPTEs were already zapped by a different task.  The alternative
+	 * is to report the error to userspace and likely terminate the guest,
+	 * and the last_retry_{eip,addr} checks will prevent retrying the page
+	 * fault indefinitely, i.e. there's nothing to lose by retrying.
 	 */
-	return !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
+	return true;
 }
 
 static int complete_emulated_mmio(struct kvm_vcpu *vcpu);
-- 
2.46.0.469.g59c65b2a67-goog


