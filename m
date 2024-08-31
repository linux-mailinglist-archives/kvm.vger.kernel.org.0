Return-Path: <kvm+bounces-25586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12C32966D3A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B646F1F242F5
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E5E12E48;
	Sat, 31 Aug 2024 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zUqpGxDA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FFA932
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063347; cv=none; b=kYDWh70pGAviZls7S2olT1hvVhlHR7INtYWA7NqeQTdhYbDe2NlpnJm2Oxs+Lnlum5p2JjfG5nm5AFTuIZL/kPnEHqF0JcZVZo77qszgG9pYz5DolGUvUfqPGbTrMtSJaYxYpZvhw6yNOverdbyl7SdLLNWgXXoauHu6PjRZd4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063347; c=relaxed/simple;
	bh=Mo/ClTEYGuNJJb8dKR3/LwowRG+11WAmRzNI0wc6hIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o+cGJYj1i1vZl/t1gxZ3tWDkQawbENKDhdiZZbeN6NSHDRvG2xidtNJglHRnGBER24R+2A2DjCPU4tvQQYvVvwtJfkE01EpUaYf6Hvz6Q3HwzAX0i40BHjbAGIy0vEER6E8Bg7KBuQXymGYe/GaP2ivBKDvr9wSJV6A7V5FjHKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zUqpGxDA; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d54ab222fcso3284977b3.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063344; x=1725668144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4GoAAkSfNvtumfQvjreZFP9Dt8KDDoJK+os4hnvMlFA=;
        b=zUqpGxDAkLHSy1m0G0VXcv28dH5UkPDbGfG9jD2oTaIMmsqfsXM8Og+S4qcxGjkeQi
         YXExGWU0qNI/1WMXxiRlPFJSS3S38G88u3bD5Ullu1Vha/o064Tpom9hCh+x2dSTzUcb
         Ogg7v1jobsRrTCHXFysi9i/6RUnYCQ/L0voUEFp3MJ0+YNYHNlSpALws7JISQqbUMTKu
         drpr6mVYv+QWvQZkoaTBR8OUy+JFFf8sADsPHIlodjy5LAQbD8SEbqvH1p7yD3c7RCtM
         o2ibQeOgeIMagHHTUV3WgVZvyyKAsKTUyn8m1HI142xhbKIBOsDyvXYVlEyTRGfZt9xo
         aOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063344; x=1725668144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4GoAAkSfNvtumfQvjreZFP9Dt8KDDoJK+os4hnvMlFA=;
        b=bAM1HW7M6FKEVyk6wEc7KUkjrnauM3De8Qk2Trr1SMt/+pOnUG3HdIQUAooKur6/st
         WuldejthjLqlbVjZXQBNKcEaJlD/Hxvb1epVu0d9+KrmvJsHt8vgd5pMTjr+FMU1Qdd2
         f8Bxwnu7IM9em4CMnhlzxb9uvv0KozdoQjFeicrae0g1ZdcOGMbg8Lteft1Amlj6XYLi
         yyWf5/bbcUhqKiOOKEMOC27jXu4ZsQJbXmnH4Bzp3cly0ABlYsO31o9xW4MIINctJ9Nw
         IfuxHCDqwahDVyVGZKe9fm7S5krsf1i5Rae9g7G5fMfIEhBsFCPw/3Yte5EnCiGYMydH
         7sww==
X-Gm-Message-State: AOJu0YzbIj9H5wpj83OUmckgWDq7cxSweAo0dLjefU4pFXLRcmW+wun2
	ggHdH1qR6YHnIRUySiDry8EWlUUwGc3CCCcrOuNZyTfFhZ/KTODamb3FB0WrT0AbvBA4U3fGnA0
	G/w==
X-Google-Smtp-Source: AGHT+IErh4TFCGh75jwFCCbkJhJfx7XdDEylAQkQhEXoE6ZOSV4assjNprZddTeOdsaNpULeb35aupwsApg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4182:b0:691:2f66:4b1c with SMTP id
 00721157ae682-6d410103377mr464037b3.6.1725063344714; Fri, 30 Aug 2024
 17:15:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:17 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-3-seanjc@google.com>
Subject: [PATCH v2 02/22] KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a
 more descriptive helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the globally visible PFERR_NESTED_GUEST_PAGE and replace it with a
more appropriately named is_write_to_guest_page_table().  The macro name
is misleading, because while all nNPT walks match PAGE|WRITE|PRESENT, the
reverse is not true.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ----
 arch/x86/kvm/mmu/mmu.c          | 9 ++++++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1811a42fa093..62d19403d63c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -280,10 +280,6 @@ enum x86_intercept_stage;
 #define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
 #define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
 
-#define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
-				 PFERR_WRITE_MASK |		\
-				 PFERR_PRESENT_MASK)
-
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d25c2b395116..4ca01256143e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5947,6 +5947,13 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static bool is_write_to_guest_page_table(u64 error_code)
+{
+	const u64 mask = PFERR_GUEST_PAGE_MASK | PFERR_WRITE_MASK | PFERR_PRESENT_MASK;
+
+	return (error_code & mask) == mask;
+}
+
 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len)
 {
@@ -6010,7 +6017,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	 * and resume the guest.
 	 */
 	if (vcpu->arch.mmu->root_role.direct &&
-	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
+	    is_write_to_guest_page_table(error_code)) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
 	}
-- 
2.46.0.469.g59c65b2a67-goog


