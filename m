Return-Path: <kvm+bounces-8495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAAE84FF6C
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:08:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B074628162E
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDE938DC9;
	Fri,  9 Feb 2024 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7wj8mpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CF2374DE
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707516480; cv=none; b=uz5RyuK9XquBZ75ykfR/hyOp+hf2nzFqJG/k7Ad62l+40xzoLrDUb24cASuzS7XWtFUFOcepXt35fxVdxJdHjbIsjYsrv6BZw5r1n4tlNlByJsczna6HTVEERZungBXmtQdx1zOaTNX37vLLokMpjPfKWOjS+rAQPeJzJMilGOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707516480; c=relaxed/simple;
	bh=G8yYb549bHS0dm420NgpCxsXl+WFxhziVrxJ57VN10A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eoCW/FZvy0GdxNycAbzI066bSNwHPpBfNW3kFyFQMRZixKhzI01pwMT25shXHj/nmzz7xoVcVN/hC7v1CplgrAywXkQYaJEHSOo8hHaySDyyCgWNTSbrmfSvgmn1iT3szJ595TqElULEuMjKAsLXz4aivkhYYXWuwStm3cg5WGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7wj8mpT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc64f63d768so2588824276.2
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707516478; x=1708121278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CiNmwT6G4ZjT0uaWThby9fO5R8PDoaUWp6GHwG0vlXE=;
        b=i7wj8mpT2zu8prxr0fg8qTWPuPGzcSLsfevxIA4G/j/GW1uT+DgC7iDbKEJRsJDUWg
         Ze3zk3Smrhr2K4gI8a+GJcqWFYWhirb2JRM3StOeI/WhXRcEuYGlEuknN6YJFHcQAGx1
         0MKHYuA+RuBlXRQev3GiCgaZKPownxAt199ZKw62NmBAZ7iLTYdEuo/MRHfBtycreJQy
         bJUJskw22D7APpQQb82n1UyGN2NPUFMP026cf+yu9mgM2qio7qQEhVkgq1AovB8Rwqc/
         kAxMCbfCZvWemxJPp+5Yk3TF4+OlYfKKn1jGP3Ndj3aBB7c4mL8VJqJ7iHU9LEGGGQju
         tzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707516478; x=1708121278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CiNmwT6G4ZjT0uaWThby9fO5R8PDoaUWp6GHwG0vlXE=;
        b=hjFUBAySbIbQiJ7MrKZfJSaD7SXb3K882H82mewnSeUV0sFVVPF1H6PHpxOZENLglN
         BvrWw/gDuoYiQJEcSV6B+GrEpnMeon8mHradnydJcReM9LykOPE8/wJ8VEu1PzIDpMwF
         vEO7ejimSdTe2RfB3Q9H+p9JskXgq/0SfeB1iSmPk/nQLhokG+YCUkd4x44RE09cl+PX
         B4gOYG8UZ9keCegz6JbtrxYz2JAuV/+YdAGuALtw6XCajCA9iOHfBzWpLDncoormbZXj
         9nqkBj00M2xOFVdtbTSI1hLY3+q8+VpXLejiyiCmRrGEwYXGd2B7hJ2HvVRbxfUSJzp5
         hyvw==
X-Gm-Message-State: AOJu0Yz6LS0nM9ayylXw0s0E6uf7hMTkl15dirglt/7KmVKYFBa+UU8B
	m1mqhlYpGr8UxUUxdiz79zXoOopF4DqzQqhZPjZ8mSJOxjdfqQ6nUFym998u8Xn2oDyQohVoebE
	lcw==
X-Google-Smtp-Source: AGHT+IHtfM9LTc4d2GpYZt5fisFL8uhOLCh2hC0auqTcKJbjQu/fK8j5e8AkLzG6VyiPL+ddqdUewMn6buY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d2:b0:dc6:d233:ffdd with SMTP id
 ck18-20020a05690218d200b00dc6d233ffddmr112509ybb.0.1707516477995; Fri, 09 Feb
 2024 14:07:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:07:52 -0800
In-Reply-To: <20240209220752.388160-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209220752.388160-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209220752.388160-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: x86: Open code all direct reads to guest DR6 and DR7
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Bite the bullet, and open code all direct reads of DR6 and DR7.  KVM
currently has a mix of open coded accesses and calls to kvm_get_dr(),
which is confusing and ugly because there's no rhyme or reason as to why
any particular chunk of code uses kvm_get_dr().

The obvious alternative is to force all accesses through kvm_get_dr(),
but it's not at all clear that doing so would be a net positive, e.g. even
if KVM ends up wanting/needing to force all reads through a common helper,
e.g. to play caching games, the cost of reverting this change is likely
lower than the ongoing cost of maintaining weird, arbitrary code.

No functional change intended.

Cc: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/smm.c        | 8 ++++----
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/x86.c        | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 19a7a0a31953..d06d43d8d2aa 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -194,8 +194,8 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu,
 	for (i = 0; i < 8; i++)
 		smram->gprs[i] = kvm_register_read_raw(vcpu, i);
 
-	smram->dr6     = (u32)kvm_get_dr(vcpu, 6);
-	smram->dr7     = (u32)kvm_get_dr(vcpu, 7);
+	smram->dr6     = (u32)vcpu->arch.dr6;
+	smram->dr7     = (u32)vcpu->arch.dr7;
 
 	enter_smm_save_seg_32(vcpu, &smram->tr, &smram->tr_sel, VCPU_SREG_TR);
 	enter_smm_save_seg_32(vcpu, &smram->ldtr, &smram->ldtr_sel, VCPU_SREG_LDTR);
@@ -236,8 +236,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	smram->rip    = kvm_rip_read(vcpu);
 	smram->rflags = kvm_get_rflags(vcpu);
 
-	smram->dr6 = kvm_get_dr(vcpu, 6);
-	smram->dr7 = kvm_get_dr(vcpu, 7);
+	smram->dr6 = vcpu->arch.dr6;
+	smram->dr7 = vcpu->arch.dr7;
 
 	smram->cr0 = kvm_read_cr0(vcpu);
 	smram->cr3 = kvm_read_cr3(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 28d1088a1770..d05ddf751491 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4433,7 +4433,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
-		vmcs12->guest_dr7 = kvm_get_dr(vcpu, 7);
+		vmcs12->guest_dr7 = vcpu->arch.dr7;
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfffc13f91e6..5a08d895bde6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5510,7 +5510,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
 		dbgregs->db[i] = vcpu->arch.db[i];
 
-	dbgregs->dr6 = kvm_get_dr(vcpu, 6);
+	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 }
 
-- 
2.43.0.687.g38aa6559b0-goog


