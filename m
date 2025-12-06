Return-Path: <kvm+bounces-65442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6383CCA9C30
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 414D43032255
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8757C3191A0;
	Sat,  6 Dec 2025 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xxKwT0pT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E4318120
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981805; cv=none; b=E6T3ZnyQRyZ803Cmr0Y0HP9G8AVHUPVqQkLoM/Vbjdu1nwm+lkZQxq2KvyTRmPTGG0UeGjL+DgMEM3vG3O0pySu11jjA5Hm9pRPLGYcXryzB7F0ULQDNVQp+RTWiwTDrjmSpXgH99byo0fXyMoHEwXLG0YrkqCd0GUOFY4IKkIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981805; c=relaxed/simple;
	bh=r2ovlZRhwODpc4bFG8XgEXKmSauokJzle7yBrk7uvqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PHuiW/gqy6eFq0tO4X/j0NqwmpM+nYNzeQ/F5XjzJzmpwNDeiPvPbXColKRUO1Nw/PKtYMQOln/imHeuMygdeWpMax/CnzvhGm/GVsFOUy/sN0tq4mN3rw8IU05h9zFmUD6fbUxDc7Df7CfnWjkDWwnmVDWgnBUDve2CJqgBUJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xxKwT0pT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4760919a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981803; x=1765586603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u/pAhAueiQpgBzrKR/h8os6IRtJ3jF7T0UFHgX/hns0=;
        b=xxKwT0pT14Wch/xbwPge7GjVyL2/ErV/Lxzn0XHvjPZB04qmK3XRRgfiI/6kjUnZNE
         VqeIoPNxH/jkG4SJ7eQO5iPla4aGYUtsJ9Lx395tLzCyizMeZoOpem7VDylaVKYrAe9a
         uwyOQ2NGcwcGhaRKbH98QOlRorZLei7RTsJpREpKxIKDK/v1akt4d6fwS/7peH4JG+ik
         q22lvYkDM0EjlEu7lEFBabjouy11lDREqxEDGoSmVWdfEDDb9xAJG4Dc1CV0in+wvz+2
         KadTfoUXtPp7F+Mp38AoG7YGTS+u1H5y8/IWOjFdKRM27hYLNY9mf/4fV564s65D7dh9
         Gz4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981803; x=1765586603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u/pAhAueiQpgBzrKR/h8os6IRtJ3jF7T0UFHgX/hns0=;
        b=rODcMVn842aN+bz9dTCf5kWnfloeh1d1gr/KSgXPUymvR1nOPGZsw8B57IFeCYEL3E
         kVFLiWgCten6eb4d8Fwg4Sk4FTfdBWhrJuw+ue0Dw7DOO6pt6RiJYhppW4eUW2WBVs9h
         iu8go30cp8yCeWwFYH2iv/8cAvnteWGIVgfBk1dX4FeJE84rSVny99QBBqDLW2JCikfw
         Kp+H+TKxQJ2MKyI5C+0TcrhFkl2h2LNsc+f+qqdOGQ7vKiK6S2ypCpTxW7bJJrCmh/zu
         1KoJ4V6x8z5GCo7qRSmFJv56KUygAdFNsLsTyzfhaKFk2rZjOX5OWgxSAMHDSJUDLTMM
         vzUQ==
X-Gm-Message-State: AOJu0YxoM9shyAd06+iwWNssszpHv8b+ISVfUSzJJBLnAY+QwHJ7k4Zy
	g99fPTaCbyWN0xipOXUoTYf2vwuzdbxcLX3Rhs8xI4eikQVyOAms/AVUAcX2aruP8B2ftc8gkif
	kRn70fg==
X-Google-Smtp-Source: AGHT+IHCE7UebBiwXFxTpupxVzVDlk/3MrknX4il2CCrZdx9H59F59NZCM1+BgnfZN/7hx58J5GaTzyvpqI=
X-Received: from pjp3.prod.google.com ([2002:a17:90b:55c3:b0:343:af64:f654])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e53:b0:330:6d5e:f17b
 with SMTP id 98e67ed59e1d1-349a25bd8ebmr669682a91.21.1764981803494; Fri, 05
 Dec 2025 16:43:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:06 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: x86: Drop guest-triggerable ASSERT()s on I/O APIC
 access alignment
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop the asserts on the guest-controlled address being 16-byte aligned
when emulating I/O APIC accesses, as the ASSERT()s are guest-triggerable
and ultimately pointless since KVM requires exact register matches, i.e.
will ultimately ignore unaligned accesses anyways.

Drop the ASSERT() definition itself now that all users are gone.

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/ioapic.c |  4 ----
 arch/x86/kvm/ioapic.h | 13 -------------
 2 files changed, 17 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index e7315b9311d3..955c781ba623 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -618,8 +618,6 @@ static int ioapic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	if (!ioapic_in_range(ioapic, addr))
 		return -EOPNOTSUPP;
 
-	ASSERT(!(addr & 0xf));	/* check alignment */
-
 	addr &= 0xff;
 	spin_lock(&ioapic->lock);
 	switch (addr) {
@@ -660,8 +658,6 @@ static int ioapic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	if (!ioapic_in_range(ioapic, addr))
 		return -EOPNOTSUPP;
 
-	ASSERT(!(addr & 0xf));	/* check alignment */
-
 	switch (len) {
 	case 8:
 	case 4:
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index bf28dbc11ff6..913016acbbd5 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -104,19 +104,6 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
 void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask);
 
-#ifdef DEBUG
-#define ASSERT(x)  							\
-do {									\
-	if (!(x)) {							\
-		printk(KERN_EMERG "assertion failed %s: %d: %s\n",	\
-		       __FILE__, __LINE__, #x);				\
-		BUG();							\
-	}								\
-} while (0)
-#else
-#define ASSERT(x) do { } while (0)
-#endif
-
 static inline int ioapic_in_kernel(struct kvm *kvm)
 {
 	return irqchip_full(kvm);
-- 
2.52.0.223.gf5cc29aaa4-goog


