Return-Path: <kvm+bounces-39642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54136A48B83
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E2087A6DE3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766C4276D72;
	Thu, 27 Feb 2025 22:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="abkAOfxW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B2B281353
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695064; cv=none; b=sRvbTclzJ8/qWEHUwBdvA+qBzD6/btD1mAh/Pv1c65/X8vq2QY2s4yTBIxP4kynq3DMpkxPkUywUi8swkGY1lcvwDgaxZmPewDXp57Xcv9gxZ/1QZ3Hu/f37ZblUalcmiQ1i4wh5WNy9IV53kfO7GKWkTyhnq/G1VsKdHRiaehs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695064; c=relaxed/simple;
	bh=uaIIITJgUawWH54PuijoRuV64Rx6tfBFy6BV8graBMw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VTTuydgzjgQvtDcJZwbbgDmJLPbLofVB0M+QfU1Sodqgqr88WOtOMoRSKJytxPul1yLA4mm9pbRQMMaJSUkbltBhMppmRfWUlI+xEAIi80QWHToFg3SQeSrUPVwPaFB4ueH+mYL4kpvZOT4T42kvlQWfwR3Ff38tEyC0GJulFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=abkAOfxW; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2234c09240fso27690175ad.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695062; x=1741299862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4G+4qHSVJnaTG8aqakqnf5oS6XZxipCyWxhYCrPdMqU=;
        b=abkAOfxWRZcu4NRNZREt5bSe9KbvOD5QN5aQFG0qL8Aj9kos5xCL7mNITnpRu+1DbQ
         Wuvj33poeMCtoj8vXNAlClXU59J7czJkkcXGjW1XagJmaNq4n5e8igRiHARCcHk580h8
         bxRmoM4LPfDR/EJwx+fA3D2wHVdVmkwPRLLl+gdCHcWjy1Jt5XwTSv0yBC+L9QK/TfRM
         mnD8YdBzRp6q8MYROO5ttHF1icj33+aM/TLwtsSR/rEo17WRdHo7n5tqsFszGyzaT1Ak
         WrLJx/UnJAl4L1mk/F+2muHCDPtU05yjfkuBOjVnWIk9KquDQHrazosTus2qyJOaoWU2
         uEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695062; x=1741299862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4G+4qHSVJnaTG8aqakqnf5oS6XZxipCyWxhYCrPdMqU=;
        b=R3qUhOsqiDS9geILPI35cygWgAoi/zDZ6ejQ/E/DKR5jfqZv4Q4dPS3FfyMjXwtnAT
         VR/MJ5ml1D0ydCL/hQ9IhNvpsv07IS5i1j/aFTFoZA3Zv54ZdVRDZnOfY/07Nh6EKTwE
         dcQO0gLQbAHu/ZDu9++LyH3euZXDULEi6gKFl6E3Rcalc377pfXBVgIJLhnQyJXDfZUt
         eOb9dX/1OOp1ie6Qiw2hLdGZTRoX0Pk25+aHh1DuEBNGkO0vkYSROWOLF1GrPU1i+smz
         MG3LiSwRrGCo9353a1UKdoXfbhFRgoQCuxT5FJgpq3yclbP3rmFet2eDSGMwu3VOE8Ul
         Br5w==
X-Gm-Message-State: AOJu0YxiTyHGJu8TMkSpyw6NOrzlxM0RCNUcp52/EAvGf5cSwM66lZU/
	NZrg5VFiO7ws0jlOLqntQSp4Pub9lQxcpi+xygPvMI1aYfn0LybSZk8eaB2jJPZiDrXSf3gMXBG
	Ncw==
X-Google-Smtp-Source: AGHT+IEgwwtyjm9FH0NZoHUXAAKG79/J8WSFp39HQkew/kpXx6ars2ZD8qvS6jLycvRG3qg04LFPzNBgvnI=
X-Received: from pfjd20.prod.google.com ([2002:a05:6a00:2454:b0:730:8a55:44fd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:929b:b0:732:a24:7351
 with SMTP id d2e1a72fcca58-734ac35dbbbmr1768936b3a.6.1740695062583; Thu, 27
 Feb 2025 14:24:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:10 -0800
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-6-seanjc@google.com>
Subject: [PATCH v3 5/6] KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09c3d27cc01a..a2cd734beef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4991,7 +4991,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10984,6 +10983,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.48.1.711.g2feabab25a-goog


