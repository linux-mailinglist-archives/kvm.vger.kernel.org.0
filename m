Return-Path: <kvm+bounces-25594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D54F966D4C
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03AFF1F24675
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511DD3A29A;
	Sat, 31 Aug 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jOjvqHEq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186EC2B9B8
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063363; cv=none; b=qC6I77gHKiO0j75KLdCG2C6ST93QssqXNkIJixdVQo0Zgz4kxqff9zlM0MS5Wc3EGpCab/g/iaZ7cWoM+z+UntR+fKwE+BJEr6llj82Vf08jlENoANqhVDZD2aXyGmSy8Na0ut91fWeEdUaBPPdQ1zoSSG4fRwpMS86jPmKI0+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063363; c=relaxed/simple;
	bh=DCTzB3tz2/E8t0BLmCC1a+S2lgNSLEDLxXAB74yg2pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rqt510mIEno4jUGDxqQboGpBt2jttIK2NAvJ1xtHnNy6VuwlHmnySQ3lmMVkZVYMzm+1O8UBrx/tdsnt6Ahv5BRyH/qpQ3CMeiKc8JBy/1wi283s8eCG24gxv+1mT49W9ipX0ANRPd63Hy0jzWcNT3AKEqe4cTfeIpYezDMF8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jOjvqHEq; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b2822668c2so45865687b3.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063361; x=1725668161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=If9fhF0Hkv4z0IGK7mMWOkmyhzNHFQEYRDvTkV0MKq0=;
        b=jOjvqHEq+XKUKiN1eGl8lkJ3pYAE5i/2mfM8UXFFxvr6LmknJDVZeYqb18NcyD0y1Z
         GOL32mRi8Kkin+X7bh5DnjtKL2gmOnuMV77DktMYX9pnHVEk21QrZ73+5WFeNQueK9ks
         B/O93/GVYPqqH1XTxY3RlHjYr/JA0VwBD5mFqOVcrCeK4nn1vXF8C5ekusA6ScMBWZ5r
         Ly16/M5lRvb7aaJ9R7ymrBLB7hnIC9Xus0WNoL49B71qgjGSrNXbbKTVJLeYAFeOfH1d
         H1AlZX0j9HSJDz3hdRQSV9bzAr1DERaKdQXMuhDxYtW8gTZdAKqeITYEOnHspcsUBpoJ
         ZgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063361; x=1725668161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=If9fhF0Hkv4z0IGK7mMWOkmyhzNHFQEYRDvTkV0MKq0=;
        b=vZYKhe6rsC3OCw0JSCCpbsVF3Y0iaEwH2gS/tj2Ttu/WPXRGamdXcfeasE/brNlgGp
         zVyT1/stRl4N9rWa3Us7QgzO+x3KroaWRSVW+4E2qk5obpdpBBYjzI9UVAEaea1+uo06
         C0bSXg6T6QtFHLgnzTlpJ+tMP+gBv7I6GxiG0nnzlQsh0sJkyzyy03QSiHcA4cxBMluE
         3yTpOaI00w/UTFDAQoB5Eav4omc01A6sRldZoUfa6t6taGeXeAhv1N/f6Waoawp3jBfR
         NYd0DHqjdgZmIIHy2V3rud/qdPy03P6PBudpCedRlh18US5JaV94uuZp7qffUBlRMeRq
         33Fg==
X-Gm-Message-State: AOJu0YyDPat/SuyPefvyWr2VRv8Nzo2t6H+k3Y3w3jAwjrJplIip710G
	A5zmFSGUtvzmUhefTkOAj6jM0dNANhbyJtccDQspM9+MzwGbGr78ZtdUE5kUa9wIxYpe5ZxFBV4
	RoQ==
X-Google-Smtp-Source: AGHT+IGiIrJ4A5BQmPLk01OCG6uv19KvfBdqQ++zW9utvyZoUIEh7zcE7pTpIYxGuUvXyPiED4dAhLqQ79M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:c944:0:b0:691:55ea:85e6 with SMTP id
 00721157ae682-6d410bbb5c2mr205897b3.7.1725063360840; Fri, 30 Aug 2024
 17:16:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:25 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-11-seanjc@google.com>
Subject: [PATCH v2 10/22] KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
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
index 862eed96cfd5..7ddca8edf91b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8866,10 +8866,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
-	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
-		return false;
-
 	if (!vcpu->arch.mmu->root_role.direct) {
 		/*
 		 * Write permission should be allowed since only
@@ -8938,10 +8934,6 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
 
-	if (WARN_ON_ONCE(is_guest_mode(vcpu)) ||
-	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
-		return false;
-
 	if (x86_page_table_writing_insn(ctxt))
 		return false;
 
@@ -9144,6 +9136,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
2.46.0.469.g59c65b2a67-goog


