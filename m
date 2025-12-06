Return-Path: <kvm+bounces-65439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C76CA9C81
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E911E32502F1
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712CE3161A5;
	Sat,  6 Dec 2025 00:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lOPrXEBL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A6315D2A
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981798; cv=none; b=b6ZRuoUZ3axoYiDfpauU6/NPD8XGOnVuluox5BeROMxNaHcRnYtYFfhUiRA91laBWrTichokOs3mSE/0eITtFyHIH4tXrnSuk/8SIjM4Jh+MyY5O/nKUMemBii1z0oOsX0JBSarNsB4X+j5j7bDVvX4RuTR8YNnlZRwDkZARu1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981798; c=relaxed/simple;
	bh=iChR0Rc4BB9WG7gSWIif9Hae1GK7UMbvihwokYDapp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrM39+zi56t7dz4BKyGqgf4TK/8zAFzSVrbvy6AisXBJFOtVCdqdBtCkEqg3g8T0ldEwdOiXyllydD0uGDa8pgALYJG0NIB0ubqPBmn2erp2jO/3qaZXS691gjbwgZuOeQKQ4YVPgjw+5anLS1kH9GW5d0jcanmyXu5JudRsWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lOPrXEBL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29557f43d56so34959485ad.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981796; x=1765586596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nDbfRGVCOdB8q8+bSZUn6u1eLIn1JShiu3JRgjwMHyI=;
        b=lOPrXEBL83pUdariqM2GocB/5ejBWc/nlw4rmkyp1jWkf6Awdd/TqkXzaG+pZXvKvD
         cKLqLpmlaRe6iB3dltuHVgMY4BeCOypey/1qZlCEYlxShg0Ah5ffDOCgtwGIixizzgGf
         tK7xOQM2ztbkz0ykcymhY1vSi4bO0uf+5bLmtoMXzXJFtC8GMazrKjTr2MK7/vlgUJ0/
         7LV6UHsMJXuPgvQpbPYA2bdwSEDQc3zIxLNPU1bW42TvlAC8CqPmTNdssq2TeHtDyEc+
         VKpFHL7Eml5daGtTDevkQvpJp5w3LA9kxDV4T3pCl3kaAEd58Dkkf0WwJ7KR74WwZujY
         5cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981796; x=1765586596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nDbfRGVCOdB8q8+bSZUn6u1eLIn1JShiu3JRgjwMHyI=;
        b=ifdMYI1/pYtZ0srCICIyDccUCNRVGk73u6PUxVmhRY2rHHaOGOE76EmNF+I62v/zzR
         GZW2Uh8ZCPOUjPor2Rt0yJ34ZR2T3RvPsUONmrNn2ls88VS4VOcR84vPKvRWv1+u8uGE
         jHVglMk9Emlv0/ctPcRha3cZH5MY3/huncu0Jx8CfwWaVEdKdF5zmUMNoNRArF6Hfc9V
         AF6hUE1CbaN7rMTue7YhWuQsYpo6zxKR1463v4RGAQeIa3JCvRyLGH+u3bCH8VvrQwBc
         IFdhGZzRccGIKiPFXiNKHZCL4V0aRgqvTf6wmW5YVCuNm+BAO2dpAl4kO1D7oZNNGD4S
         4B5g==
X-Gm-Message-State: AOJu0YzO6zWR+Ft/is9VRPx/N4Y3OkImtvcj/IvS1WDMmhQCcsoQjSXU
	S0Y7BxHj6KuJShzfc2RvK6NZQwbDcstn2AP+tmG0GDi557QhTZuvzwsyOHPgSdUZje7lEEbKvFQ
	R2evsDg==
X-Google-Smtp-Source: AGHT+IHv8VUdThEMuYCTo4CRTZK/X2P2LNU9z0jf1LB7AEYk0QUXaJ8qfyEqkCSAnavX436lQTAj32kbRlw=
X-Received: from plhz1.prod.google.com ([2002:a17:902:d9c1:b0:295:fdf4:5ad4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cecc:b0:297:d4c4:4d99
 with SMTP id d9443c01a7336-29df579ea1dmr8987315ad.6.1764981796344; Fri, 05
 Dec 2025 16:43:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:03 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: x86: Drop ASSERT()s on APIC/vCPU being non-NULL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove ASSERT()s on vCPU and APIC structures being non-NULL in the local
APIC code as the DEBUG=1 path of ASSERT() ends with BUG(), i.e. isn't
meaningfully better for debugging than a NULL pointer dereference.

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1597dd0b0cc6..558adcb67171 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1048,7 +1048,6 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 	struct kvm_lapic *target = vcpu->arch.apic;
 	u32 mda = kvm_apic_mda(vcpu, dest, source, target);
 
-	ASSERT(target);
 	switch (shorthand) {
 	case APIC_DEST_NOSHORT:
 		if (dest_mode == APIC_DEST_PHYSICAL)
@@ -1607,8 +1606,6 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	ktime_t remaining, now;
 	s64 ns;
 
-	ASSERT(apic != NULL);
-
 	/* if initial count is 0, current count should also be 0 */
 	if (kvm_lapic_get_reg(apic, APIC_TMICT) == 0 ||
 		apic->lapic_timer.period == 0)
@@ -3000,8 +2997,6 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic;
 
-	ASSERT(vcpu != NULL);
-
 	if (!irqchip_in_kernel(vcpu->kvm)) {
 		static_branch_inc(&kvm_has_noapic_vcpu);
 		return 0;
-- 
2.52.0.223.gf5cc29aaa4-goog


