Return-Path: <kvm+bounces-25986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCB596E8B3
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC5DFB22774
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F68D1428F3;
	Fri,  6 Sep 2024 04:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnUKM2Le"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6813D600
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597270; cv=none; b=MjrvR1vT4+ptVTwuyVa1psdwDa8jjopRqZ20qBCBn3xDRVC9ATl22U0Mdbdf3BxSqQPWkZ5K8YUCsjqfNJ3/Shv/FifvmWzbBD27VQHBGvnsvKvLq+dBe2auTyJGZ6gedIXt8J5H6xbeBIngy6yQJqpQI0F6MJHsJY5460tWEKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597270; c=relaxed/simple;
	bh=16BMCLeOVpdv0K/WH9ozgUVcrDZ/XLhLK3PWi4tm9l0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YXDmgKNT+wfSud0DPJTHjxT5Yx6NfFGCC9OjCoPLlfTdcRULKajnNo8bbwbKf/a/fndY6mD5erTwWCju173IwpFs3WOt0YkKJI2/GoEkpLxJJ2Hj4ABs/T0up1SN3iiH2O6C3cIlllXIi4d+2gEnG8qgWewgaHAzX7R8Jvo9k5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnUKM2Le; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d6b2b9a534so62743627b3.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597268; x=1726202068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uzxku0+LxyHsHOYX6rcGXjDtKiKbrlhkjaeoxb7nWcQ=;
        b=lnUKM2Le9gtS7mKy1NFJU7llV3HsuTaVEo9Ge9k3I/lAvyaMJbqIWUgf2aG4SVjgq6
         0O86BuIKEnFPCusK0FD58aRa7/VfxwxWMcvN8OsH/Actv38uJyx7lU8T4P0ECfY7YQDO
         wNerNKjpeSS7qpKqOxYb9RQulZ2u+2sFi0y13ie7ROOPWqHRvtcd87LWiu07MFmRFMmP
         ImXJozsi4HExJiYXYeK7R0Jw7x85In8LnXT3IvQgYN8+1cHeAoIod64VuAM10JeoHMFQ
         o2QdhwDLvnyw+VZdSBqhHbrXMvJ2VoiGkve1Nr8DL3N9YvkSC4k20YxqjvHBiOBRNdnz
         qOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597268; x=1726202068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzxku0+LxyHsHOYX6rcGXjDtKiKbrlhkjaeoxb7nWcQ=;
        b=n+cEPrivZy9oEG9EEvVHjhnMIfFSaqQmaVuXhRP44gs5pYOvuqdM+AxgcWyzj5R6rj
         7v54yOJeC2ah+eqspzOJcVq25PdvxQOwup+iNk0Os6xOZA6pdvI0uzUixpTquSjHq0gG
         a2Pwmrxk+waPgelRClJ3wVJuGX3BPpIfAHQKZu9kN//bNf9/XdE9uyriKGrwHz0Qb8zX
         Va8T/hmx4EEbRh2nB5/tOb2Ub3mBxUdjuLomq0sKF45QW1XhxaDFL7cpI0HHFnpTosyv
         W/pIg691XY8Ed5yzhACVL5PUtVeteFWmaKqtchCEHAywekN0mUAtn7y6GBXfgDCczCcr
         il/A==
X-Gm-Message-State: AOJu0YypDSJt8XKOKdeikilDu8JU39mk6OJErxMLJVKWTb4E7sdR3aeF
	p6nfZj0J5Ctk8TRirjWV4FvYx5vovNYlmJ+YODiqBTEf/flrmC6fbM4CieAjIm1KoqkeAwdz95M
	jYg==
X-Google-Smtp-Source: AGHT+IHnO4jNQ69g0TR8pRoeAENrswe//rGX8Vs4B2T2hgTvjDXJ14AKHraOC49CTLTBDc+mdxX6LOuY5UY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e9c4:0:b0:6d9:c367:54a5 with SMTP id
 00721157ae682-6db45036a46mr9767b3.4.1725597266843; Thu, 05 Sep 2024 21:34:26
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:11 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-6-seanjc@google.com>
Subject: [PATCH v2 5/7] KVM: x86: Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt() now that nVMX
essentially open codes kvm_get_apic_interrupt() in order to correctly
emulate nested posted interrupts.

Opportunistically stop exporting kvm_cpu_get_interrupt(), as the
aforementioned nVMX flow was the only user in vendor code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/irq.c   |  7 +++++--
 arch/x86/kvm/lapic.c | 10 ----------
 arch/x86/kvm/lapic.h |  1 -
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 810da99ff7ed..63f66c51975a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -142,9 +142,12 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 	if (vector != -1)
 		return vector;			/* PIC */
 
-	return kvm_get_apic_interrupt(v);	/* APIC */
+	vector = kvm_apic_has_interrupt(v);	/* APIC */
+	if (vector != -1)
+		kvm_apic_ack_interrupt(v, vector);
+
+	return vector;
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
 
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ff63ef8163a9..5c820e3f06a8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2961,16 +2961,6 @@ void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_ack_interrupt);
 
-int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
-{
-	int vector = kvm_apic_has_interrupt(vcpu);
-
-	if (vector != -1)
-		kvm_apic_ack_interrupt(vcpu, vector);
-
-	return vector;
-}
-
 static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s, bool set)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index db80a2965b9c..8310ff74be29 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -90,7 +90,6 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu);
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
 void kvm_apic_ack_interrupt(struct kvm_vcpu *vcpu, int vector);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
-int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
-- 
2.46.0.469.g59c65b2a67-goog


