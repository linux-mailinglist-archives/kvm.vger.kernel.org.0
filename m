Return-Path: <kvm+bounces-65440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30275CA9C7B
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3147322BEEC
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34815316907;
	Sat,  6 Dec 2025 00:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fBO+lDfN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E75316185
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981800; cv=none; b=U8nR9lnV5bIq7V1dwUTuuxAmSvUrOeE1YUIXK9oq35JTi12OIjN1YOtWBWzRG8zoYDuu11cMkXLi15IBDcoM+KABjKBOw8t7D4VB9zu7AY4fHjpi7bKg3J5TpcMLJthS8ivnixHrazDuLc/0X+RoTwr9jpcNKIWzBYzabZXl/qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981800; c=relaxed/simple;
	bh=2L2gL97o++f/gm2tCxBBuOlts49MrQmg/0G3RrKqFGI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=udJlv3z+mfuWTNLruQgNKCye9hcskzMBR7yAnllmwr5uA21R4RMoGMVBvgJZxxpn1k68No4WYLUUkn0KJ9EcD6wVtZe90DdgxyMVgceX7/MpQAc+nWge90057eNFGOCTwg8Sl1d256BzKgd+qiyIKQ2dDxARasSvUekDD+jynNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fBO+lDfN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7dd05696910so3502109b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981798; x=1765586598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=upYs1KMuqdfjrUFjVx53Z/p9uat0/PpyZSW2MXnW3Lo=;
        b=fBO+lDfN2BvakO6w0WfhPc/5Y7uUdAYJLm+IUY5AYMew0ggGYaSpzTcadRkqbTV0UX
         U1/S5NYRF0iz+G2Ou/mGF7u92a3XtQrcv/8ANbZV+aL1pD9EQikIsn/49Oh2XIDUCCsB
         rgX891MsmGpaqqKk4eiMHXWE0dKFvmEGpgZ1tmdBOP48d7Q912O+94m2pKcCkIjX4vd2
         jjoqAMl5oQWthoIKQp8VGtvywQUz2wywjh0cuUP+mT42dzKgOZ/dXDLJa5+xjnR5KPz/
         MFKxqBhThPVZgGC0oqO3CsR/kmCdyht0n6tVFXwltbX53Cef6Amdys4uJK3I9nqoHUg4
         GlQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981798; x=1765586598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upYs1KMuqdfjrUFjVx53Z/p9uat0/PpyZSW2MXnW3Lo=;
        b=wivN443ckNd10yX0moarGuvR2zgXPi5MPdxfZx8gD9fpJsGnVU3qcyFkw2QPenRVdP
         8DSmUXCK+4F15VQfYywtKKoiPh6ccboe3UP4YhUeLdnZIuDgzOuQemg0vpiFaBLeQ9Y1
         sCCOeiiK4OX1V+mDpMPMa8zpoXw6eQug9x2kd2K8ujCnrNw7lOpNcTVqby2X6XeNf2/O
         AOSrxLgfJpQ1q9cKFc6EdSA2qqeN0CnVwx6fOTieVk+VMY51sw8d0nuSIH/lu/M8a08S
         HYvrDGJvmT+KTUBhLTM8F/PqNjccxdAmS0R6gq5ox2hqqwM4pj53Q75e4AnFYYwoZVuE
         K+6g==
X-Gm-Message-State: AOJu0Yypqit41JY+t0J3cBmt33mFSRIJnlYBb6U8GMqQJvHB4CQTTB3y
	mbaJ/mWG1cV4k9Kjor670hGvkbcE9u17Hxh6A7imoWSGPHYx28aaEsiwvBW31FLSDIg7VNFjLSA
	TVVovAw==
X-Google-Smtp-Source: AGHT+IHgSKLoznbT+PBn/5JXieJ/Q/CNe9rxTSrYRb/BtQdSAiY0k616rOq6tNZj6AT6841f3cLU7sFkWdw=
X-Received: from pglx8.prod.google.com ([2002:a63:1708:0:b0:bd9:a349:94b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c3:b0:35d:d477:a7ff
 with SMTP id adf61e73a8af0-36617e834f4mr1014907637.21.1764981798188; Fri, 05
 Dec 2025 16:43:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:04 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-3-seanjc@google.com>
Subject: [PATCH 2/9] KVM: x86: Drop guest/user-triggerable asserts on IRR/ISR vectors
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove the ASSERT()s in apic_find_highest_i{r,s}r() that exist to detect
illegal vectors (0-15 are reserved and never recognized by the local APIC),
as the asserts, if they were ever to be enabled by #defining DEBUG, can be
trivially triggered from both the guest and from userspace, and ultimately
because the ASSERT()s are useless.

In large part due to lack of emulation for the Error Status Register and
its "delayed" read semantics, KVM doesn't filter out bad IRQs (IPIs or
otherwise) when IRQs are sent or received.  Instead, probably by dumb
luck on KVM's part, KVM effectively ignores pending illegal vectors in
the IRR due vector 0-15 having priority '0', and thus never being higher
priority than PPR.

As for ISR, a misbehaving userspace could stuff illegal vector bits, but
again the end result is mostly benign (aside from userspace likely
breaking the VM), as processing illegal vectors "works" and doesn't cause
functional problems.

Regardless of the safety and correctness of KVM's illegal vector handling,
one thing is for certain: the ASSERT()s have done absolutely nothing to
help detect such issues since they were added 18+ years ago by commit
97222cc83163 ("KVM: Emulate local APIC in kernel").

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 558adcb67171..785c0352fa0e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -666,8 +666,6 @@ static inline int apic_search_irr(struct kvm_lapic *apic)
 
 static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 {
-	int result;
-
 	/*
 	 * Note that irr_pending is just a hint. It will be always
 	 * true with virtual interrupt delivery enabled.
@@ -675,10 +673,7 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 	if (!apic->irr_pending)
 		return -1;
 
-	result = apic_search_irr(apic);
-	ASSERT(result == -1 || result >= 16);
-
-	return result;
+	return apic_search_irr(apic);
 }
 
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
@@ -731,8 +726,6 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 {
-	int result;
-
 	/*
 	 * Note that isr_count is always 1, and highest_isr_cache
 	 * is always -1, with APIC virtualization enabled.
@@ -742,10 +735,7 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 	if (likely(apic->highest_isr_cache != -1))
 		return apic->highest_isr_cache;
 
-	result = apic_find_highest_vector(apic->regs + APIC_ISR);
-	ASSERT(result == -1 || result >= 16);
-
-	return result;
+	return apic_find_highest_vector(apic->regs + APIC_ISR);
 }
 
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
-- 
2.52.0.223.gf5cc29aaa4-goog


