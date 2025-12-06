Return-Path: <kvm+bounces-65441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A28FBCA9C45
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD6F3310FD67
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5625A312816;
	Sat,  6 Dec 2025 00:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZEQSUU8p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF83168E5
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981802; cv=none; b=h/McL+s70lwTG/lWLDlmIvsUuU8rT+upJugeUH9LkWZEs993AM65LK0qvTfR+fQb3NkHTxgFQoeBzDXcEHY/9B9sKW0KN60XMX5LS8Rgh1VEV3tGwZdXhmu34ay4QEkpe3NlEEntUPRUVsEVEosy9gAFqSqWsD0HkJ5Ptka7iao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981802; c=relaxed/simple;
	bh=Hy74djawqMvSP0jMJOk9BCT2RyW0VOR90fXdslhQje0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XH+O1478GfjFFkLQjCRa4jDUNE4IIPxE4J+dFEhg5i5uFXOYMszXR/aCZTIJzAPraWfA2WPaOS4v3L9lufKpDco1iDg8gcvjqKNFVw7wfwUQJF0PKunnkMhM9Es24Nm5I0xgJv5Y2DLL/xlR6pxkXzRaP9NHbnSUILarJ743U/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZEQSUU8p; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3438744f11bso4944179a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981800; x=1765586600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=173K4atzjTV2FLTaLFj0n34rAomBtKCng7OEVaMUqaE=;
        b=ZEQSUU8pPvE0bONpoXFp4e7swPzQFL1px4v7+bBiSqkY9ZRwDm7UPAr3cuO9nLUtgt
         78RR68LA8TU1BjSzryAUfHC83ojmNjgyywt6rtUnfgijqa6x6e/3rE35x1WbvTYMd90a
         C496YEWBlmTeR2mM2d1CE6cqzYtJvwDBcgs4ziCJ76ro00j+iYlokFnYTPY/h7bo6d88
         3JfRmFPaTn7zVC+KEFqyscwWwN7TU439furgNb/QujagsJuN0+04vzigOUADjuAqP1JI
         uxJBeuheA/AQ9AxwU9b3YPWLyUspW4I6mJ0rnpKPv1jX6AidBfvFSe4hZymppUmycHf9
         kYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981800; x=1765586600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=173K4atzjTV2FLTaLFj0n34rAomBtKCng7OEVaMUqaE=;
        b=i8DiOOzz9LwYHyRaWfClzhCWKmSCFRiNfMleW6GLKETDI/Q2mN4XQMafrdzjkWbztr
         JA1m+HMsp3grkMo3CR3WHFzC5YEGTgumuHwtY4vdakvvXXsaZMSzeyH/xmmiIvF41849
         7wYdAZyScDSNrargnwwP7/Q8jkvSFL3Q6XMNZHVXqHvaDIIYiTgjeHOX/jjOE+19OK/M
         Fi6UWChNixB0JpSmwOHo+nwACuFcvKkq5G73GvOm3rtOXjFAeiG7G/9cVmuvhKldu1Y5
         6as7LAlePKPHscP6qDjoSWuzq9B/CzUbeAsfl4nXNkEhvdm2tJb8hWjh4JOJD9MgdruC
         n4tw==
X-Gm-Message-State: AOJu0Yzemfyj4lrwkqoGlnCqT5G7SuVzYhgR9G+Rk61NRhI5L5MkXyP0
	mQ20ywh/ReIzU/Mjg3WLjqdnXDiXPry5f8nxnX3ik3DOPNSZqA2kwhhfMur3Ox+CQkgrcDiG/P7
	a89PhEg==
X-Google-Smtp-Source: AGHT+IGTVnpxzGirvoM3sWOHnaYFOdYvPr17LMZTMJrq9eXAIpbGbRw9kPXACGvzABd9IaSIWNihB3yXpFc=
X-Received: from pjbhl15.prod.google.com ([2002:a17:90b:134f:b0:340:9a37:91a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:184e:b0:340:d511:e167
 with SMTP id 98e67ed59e1d1-349a23af6bemr710202a91.0.1764981800353; Fri, 05
 Dec 2025 16:43:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:05 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-4-seanjc@google.com>
Subject: [PATCH 3/9] KVM: x86: Drop ASSERT() on I/O APIC EOIs being only for
 LEVEL_to WARN_ON_ONCE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove kvm_ioapic_update_eoi_one()'s ASSERT() that the vector's entry is
configured to be level-triggered, as KVM intercepts and forward EOIs to
the I/O APIC even for edge-triggered IRQs (see kvm_ioapic_scan_entry()),
and nothing guarantees the local APIC's TMR register is synchronized with
the I/O APIC redirection table, i.e. the @trigger_mode check just out of
sight doesn't provide any meaningful protection.

Given that roughly half of the historic ASSERT()s are/were guest- and/or
user-triggerable, it's safe to assume no one has run meaningful workloads
with DEBUG=1, i.e. that the ASSERT() has been dead code since it was
added 18+ years ago.

Opportunistically drop the unnecessary forward declaration of
kvm_ioapic_update_eoi_one().

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2c2783296aed..e7315b9311d3 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -37,11 +37,6 @@
 static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
 		bool line_status);
 
-static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
-				      struct kvm_ioapic *ioapic,
-				      int trigger_mode,
-				      int pin);
-
 static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic)
 {
 	unsigned long result = 0;
@@ -564,7 +559,6 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
 		return;
 
-	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
 	ent->fields.remote_irr = 0;
 	if (!ent->fields.mask && (ioapic->irr & (1 << pin))) {
 		++ioapic->irq_eoi[pin];
-- 
2.52.0.223.gf5cc29aaa4-goog


