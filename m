Return-Path: <kvm+bounces-25982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4173996E8A8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 600161C2357F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F6374BF5;
	Fri,  6 Sep 2024 04:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GSRoYNGE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B384F4594A
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597261; cv=none; b=d5ivpAd0TjSU9ZVU9H/mPmmVE4xbCqTjHH3piLUpy5KcEoyXOTHANv/gD6rAxBDm5D7wzDGa4eMDLemxKq30pNnNlix8SZH9NVKSHFKrxEgCImSyxkBdZoMfq4Y34RlcFBX4ahJyQePk/XC7CWENHHttUrISUw1KAcM+rWosLTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597261; c=relaxed/simple;
	bh=IvNHY4s2sMwGIf0YtwnB+tocpqjPSUFN5NVhawuBXGY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RpctkBdSELp4BYhdtZ+7i+h/cb+Tjs3LsRsMOU1ziOOGkHKEkns8nueCUclQfsROlf9SQNkFrScPbjk6w/zKeQ6ag6E4oQdYGhRXdMnYuk48lsJfF7vC6dSTuaBg9TRMC/Oia5RO7HKnsSPmhQNzbHAjJ6tI12k9XP97odx8hgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GSRoYNGE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6c3982a0c65so70077697b3.1
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597258; x=1726202058; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mCaD0TEOBVOQwGb6+w3Vfrkr+Z/WBNGokOq9Bgi0c+0=;
        b=GSRoYNGEPKl/6E7LBNLR3g7V2gfPZG2wSWUEuMD+ZLeZpvpBBoRLHVx7xDraG1yfJH
         HH/um61pKQehkoU60FWYxt+91VhyGNalT5PkBXodSgO4EDIT4Bbn5ZNWuJMOzyVbUByN
         DuJXRuJEpTxALSodktKG5QPNjWtKk4FlJXN9AwLUkeH3PTunAQrirViLmQ/Z7/EBh0mu
         BndDgRh/ANP81IkGHfE9LsM52BW39zVMQbrWsNJGLpl5xZX0ZDa9cStj37AtdksvifFB
         nvC1/SmgbEdUNYd8PY+5S6M7sD9fdGocmERaIaPTiHN+6pS6y9L4sjJuwDmmmI/eLWoe
         gQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597258; x=1726202058;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mCaD0TEOBVOQwGb6+w3Vfrkr+Z/WBNGokOq9Bgi0c+0=;
        b=lF0vXZcqTOfWY7lCANbScy64tnGiHE9jWY23hITCjcoNils1+PpDRVO8OT6+Q88KCg
         ZiUejNFbWdL9Nu7Ue+/IKFvpbDF6/fzxt+TK2ZGswysBtVJQYZjKEYbY66KdvSBwOSdi
         +yO5QCh+BUP36pWom5+Ip+kZsOsdjNqrDWjpA9eKSBSY1PGy3YD8Mtim2MB97vL5WMf7
         bb/DFJtIcmQfaLZhNI5RJrjNnPz1BRNte5zlGb6tt0gcaFE//kdKvEiOvhTjd4p6GAAU
         dEHtGahq8/zpDnbK9O8W0yqwElJ0Nzvr+wvpYAg8TYuZiKLUroTEVz0YK6BneQ15fr+D
         4JaQ==
X-Gm-Message-State: AOJu0Yw0bZ6k44djPL2HPIGs9FOOyAJwdcCuTWyxoVyty4O4GSJuNJ97
	8gqtQpJIG9s7OzXafSEOj3jmCumvNszD3s9XiuxdHR6zQFrZHOsqzMyv76x8ZWJFVoii7KgS3gV
	QvQ==
X-Google-Smtp-Source: AGHT+IGCDgcglWhh/eqririlfxwRjfWcrURdZg+FkjDnBxo0+i6VcRR3gAjFm5Rm67GVxheJV7Gf0Avr2mM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fcf:b0:627:a671:8805 with SMTP id
 00721157ae682-6db4512db7bmr1018207b3.3.1725597258694; Thu, 05 Sep 2024
 21:34:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:07 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-2-seanjc@google.com>
Subject: [PATCH v2 1/7] KVM: x86: Move "ack" phase of local APIC IRQ delivery
 to separate API
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Split the "ack" phase, i.e. the movement of an interrupt from IRR=>ISR,
out of kvm_get_apic_interrupt() and into a separate API so that nested
VMX can acknowledge a specific interrupt _after_ emulating a VM-Exit from
L2 to L1.

To correctly emulate nested posted interrupts while APICv is active, KVM
must:

  1. find the highest pending interrupt.
  2. check if that IRQ is L2's notification vector
  3. emulate VM-Exit if the IRQ is NOT the notification vector
  4. ACK the IRQ in L1 _after_ VM-Exit

When APICv is active, the process of moving the IRQ from the IRR to the
ISR also requires a VMWRITE to update vmcs01.GUEST_INTERRUPT_STATUS.SVI,
and so acknowledging the interrupt before switching to vmcs01 would result
in marking the IRQ as in-service in the wrong VMCS.

KVM currently fudges around this issue by doing kvm_get_apic_interrupt()
smack dab in the middle of emulating VM-Exit, but that hack doesn't play
nice with nested posted interrupts, as notification vector IRQs don't
trigger a VM-Exit in the first place.

Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 17 +++++++++++++----
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..ff63ef8163a9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2924,14 +2924,13 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 	}
 }
 
-int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
+void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
-	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (vector == -1)
-		return -1;
+	if (WARN_ON_ONCE(vector < 0 || !apic))
+		return;
 
 	/*
 	 * We get here even with APIC virtualization enabled, if doing
@@ -2959,6 +2958,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 		__apic_update_ppr(apic, &ppr);
 	}
 
+}
+EXPORT_SYMBOL_GPL(kvm_apic_ack_interrupt);
+
+int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
+{
+	int vector = kvm_apic_has_interrupt(vcpu);
+
+	if (vector != -1)
+		kvm_apic_ack_interrupt(vcpu, vector);
+
 	return vector;
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ef8ae73e82d..db80a2965b9c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -88,6 +88,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
 
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
+void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
-- 
2.46.0.469.g59c65b2a67-goog


