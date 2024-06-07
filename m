Return-Path: <kvm+bounces-19082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA3D900B32
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 619911C21A48
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FB719D072;
	Fri,  7 Jun 2024 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NfgFH684"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F097199235
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781180; cv=none; b=KZrQcS49BeXHN1hqkHtmZhCBI3xe+ofCPmS0TgPoayJfAcnnW00DepDCqgaI87hzIwJDjN5cKBefslxEh/g4baY4KXzUWAxz3Ih4oMjuMfSjLnJPL6LQq9zDPm464sUl1YvBIjir+f2bWwzmW2wQWTSng59zpQ6ecI+53bsEvhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781180; c=relaxed/simple;
	bh=MTqQFmVrRdyG7Np823VTm6J+yyKDKmP35dXc0YupBSg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ufld0mfeEdR/SbK6ej65QbHlqiujA7v17epTb4uWLWFjQLX09b55rF56cf0r7zGqvihV9xNdvslg3z+lhWLogJ9KTI7dT/D/NbAdtvILoZjmgAJSs2VbhBQLrWlEP4AIVvZqpwQN5uBtmsvL1hN0IKeNuG8QLTBCjH7m3Zsqne4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NfgFH684; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a080977a5so40297237b3.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 10:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717781178; x=1718385978; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JYYDgtTjpdJQWbBa/dr8LzdA49eSHC9v6AH4GoU5QDU=;
        b=NfgFH684x+eCraapvFW3iwc8lOixsi02uCsT6l8EqJZNU1m6F4MlL3fwgRj3qOFeJz
         dHAZes6k9qIVZdwZwJSnYgw1PWU0Ako5Kcnxmeem31GfXrs2toI7SDEcgr53vbAKI8ro
         74y3gkhj8GaauC2PVISa7rr1BK8SphEcjBMZxtx9WIyI0H+l5xFBFLFkdZHxz2pz0uZv
         lsZXwUPexlp1/JYHokLgtBKOsO5urh3N/0E0nb7jYO6TNV3qH7RV1UD9i6Lu5vUEm2Dr
         B/C51Q3cvTREmPm1hgLUNKMe4Whv0fRpnfU8wCeetSy+gxt5uiADnP7h1dG5x4uLC6KX
         eXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717781178; x=1718385978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JYYDgtTjpdJQWbBa/dr8LzdA49eSHC9v6AH4GoU5QDU=;
        b=FP5UcwLmbvw/asCVP/FUcBk08xV/jXADcCPeDnEtYll44l+clIbx1yG1e/MStIXXlt
         2eaCTF0oNSzlgprMCwtQ33lgutIxwuGx423HxuxRE5lCaA3kD0AA1HbzbQxIfgC91ofo
         N3YXULZOH0X0gXIntwob3jDXSMVASLzh5F6pywlUyyCdNSJiRmcm5k/58lT7kxGJ8fwL
         sOlP899QMNvYcXZl643EJMwrr71Lcjxv1h/0N5tgvltI5g4WAFc888uz805HsjxGHv68
         9DThwvjqrHbBku+FzXgiJVQKkZWncNSDEX8U9qZZEQGnQsutIeJwG6VW4KpU+FSWXt0A
         sLIg==
X-Gm-Message-State: AOJu0Yyhu9WGa3Y62xSRVS9t9MBix1wKVSc/A9BdAhyUx+ZoDQqwGcts
	Ok0hS0GJuG6ZFgDNlOQ5L6Clw9/ltFZ9CXKJc7ZmGIFEWm4CSm+6L0HfS0xF6uhKS3YAghXKn/I
	I7Q==
X-Google-Smtp-Source: AGHT+IHChjWREz5f17er3Dt6IudMfKcgo37XC0GFeRYtbeBkJwfmU7kOe/5g8rorkUKpzeJq7A7baJuMnI8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dfa:7282:d6d4 with SMTP id
 3f1490d57ef6-dfaf64efa7dmr799974276.6.1717781177998; Fri, 07 Jun 2024
 10:26:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 10:26:06 -0700
In-Reply-To: <20240607172609.3205077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607172609.3205077-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607172609.3205077-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: VMX: Split out the non-virtualization part of vmx_interrupt_blocked()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the non-VMX chunk of the "interrupt blocked" checks to a separate
helper so that KVM can reuse the code to detect if interrupts are blocked
for L2, e.g. to determine if a virtual interrupt _for L2_ is a valid wake
event.  If L1 disables HLT-exiting for L2, nested APICv is enabled, and L2
HLTs, then L2 virtual interrupts are valid wake events, but if and only if
interrupts are unblocked for L2.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++----
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0e3aaf520db2..d8d9e1f6c340 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5050,16 +5050,21 @@ int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !vmx_nmi_blocked(vcpu);
 }
 
-bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
-		return false;
-
 	return !(vmx_get_rflags(vcpu) & X86_EFLAGS_IF) ||
 	       (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
 		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
 }
 
+bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
+		return false;
+
+	return __vmx_interrupt_blocked(vcpu);
+}
+
 int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	if (to_vmx(vcpu)->nested.nested_run_pending)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 08d7d67fe760..42498fa63abb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -406,6 +406,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
+bool __vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
-- 
2.45.2.505.gda0bf45e8d-goog


