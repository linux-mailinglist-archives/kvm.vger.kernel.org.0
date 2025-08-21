Return-Path: <kvm+bounces-55410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71476B3088A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40EF55881A1
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DEA2DFF04;
	Thu, 21 Aug 2025 21:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRk9hRog"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F62E284C
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812537; cv=none; b=bpKomhcGPMU+goe8CYBEwOf3Bm3AMbXSLbSYbcgzuA/x9HxbMrsISUWpWvUf7d1BffP/e8yr4MXQy+3+m10RerdL7BMsbNICoEdp4Vd1RGW3SFb9V4IOnI+xGX4gvg4VJ3uZyL/OrsLVG8kfYAxKk1PGeh3k7FJd/Gp/PqXMR3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812537; c=relaxed/simple;
	bh=ca0kzC2BdLl1IEbdeerqiPG0LW2JuMEFuPZUqCrU+ms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TjLcOoqpOwMutnFjp3hWybDbe2okF6gl6t7iyOczvcWVtJvRnvi2d7wBVowBoXE+mzYpMCgYyRgSDOJdnO9dEpTJo4QusTflcJ0EFzwQOyeqJdouW+5DnJmMgm6seGHNl7cCBo4cwVU0xstatL+1vbJAxr/NfXVKJ52k2wZGGVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRk9hRog; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3234811cab3so1617616a91.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755812535; x=1756417335; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OSS0ebn8BjSjAcdAaIlZpHKKhuVPmoJB9rSKcDaaT3k=;
        b=xRk9hRogFuhksiNliH3yTfYBamDqqOV7UcEq/ryVYLU0BEgZjPdOthzK+hT2ZwCVLy
         jybyGSngD00jNuOQjTesHkdutWbL1hcxI4QMxzIDo2i+mTWIWaJAPRkMwI99EiPe6IOw
         BP2+32/L9DXz10Bp2af2W4Wx0sIvOgd8nLt5o9LNWoKy0UhV/LFBN5ZJb3V8WlkWinb3
         hZcdLP7738x/nK05RktcDIEdZvJkIDFnr1rCdI9oqirJKi2I/XIRgWQR8q1P4XHK63+K
         f06wTnx+cZsopEtYAqSRJM90Mm6MVEnZ/7P+Nzg2VntegHK3NQpVjaeZOiN/sZvyOZUP
         tOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812535; x=1756417335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OSS0ebn8BjSjAcdAaIlZpHKKhuVPmoJB9rSKcDaaT3k=;
        b=ViFTObd4gNq7RJg3M9PJ9YrYmT2tt1BM+WO2B1Nc409Q8mQTYJndlBHGu7vVm6//Ip
         c1oyy+r0H2jUFd3SOXP4O76Xn/vP18sScBI/WlbSaPgFyJRyEuLLX8vGN/3G5hisrcGL
         HCvUsbazRtH11j+iX/5BMae+KieOT9B0XUnuAIcmeRzZqkwG8V3GSN0clDReMLqd7akv
         ZuMuwRGUia8CK4h6FMNcQMhKhf0OMamla3duFsKxK/1YzUHVBVbUH3XK5PPEkKK3Lf0O
         sXfMe0fl2pC94yJmgjUF3UeqdzNVQzuPVViXXyB8Wby4fFBXXcpUAmojc9dgwbhzBhvw
         sLPg==
X-Gm-Message-State: AOJu0Yxu1d+6K0Hbqqs3CgrwmTI5ADxjhvRzs+8e8LW8eyNCphT4+u6d
	l4LmrgSoZoT9hY8e/xT0GOQQLv4KZOAAarLKFSQJhb5l7C8ZiO5QehlVcImca/6b4/XGbxGtdPX
	6osHSzw==
X-Google-Smtp-Source: AGHT+IGNgc8k2e72ps969uvmThUfuYJmfxHpoyG6JUsRaulQAD2cbnF2fFqr89qAQwVjqG1aUuTvd/V3mKo=
X-Received: from pjboh13.prod.google.com ([2002:a17:90b:3a4d:b0:31f:26b:cc66])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cd:b0:31e:f193:1822
 with SMTP id 98e67ed59e1d1-32517745f63mr1046195a91.28.1755812535571; Thu, 21
 Aug 2025 14:42:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:42:08 -0700
In-Reply-To: <20250821214209.3463350-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821214209.3463350-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821214209.3463350-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Make "lowest priority" helpers local to lapic.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Make various helpers for resolving lowest priority IRQs local to lapic.c
now that kvm_irq_delivery_to_apic() lives in lapic.c as well.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 19 ++++++++++++-------
 arch/x86/kvm/lapic.h |  9 ---------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 129ade22efca..1a8bc81973e3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1063,8 +1063,8 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 }
 EXPORT_SYMBOL_GPL(kvm_apic_match_dest);
 
-int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
-		       const unsigned long *bitmap, u32 bitmap_size)
+static int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
+			       const unsigned long *bitmap, u32 bitmap_size)
 {
 	int idx = find_nth_bit(bitmap, bitmap_size, vector % dest_vcpus);
 
@@ -1099,6 +1099,16 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
 	return false;
 }
 
+static bool kvm_lowest_prio_delivery(struct kvm_lapic_irq *irq)
+{
+	return (irq->delivery_mode == APIC_DM_LOWEST || irq->msi_redir_hint);
+}
+
+static int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
+{
+	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
+}
+
 /* Return true if the interrupt can be handled by using *bitmap as index mask
  * for valid destinations in *dst array.
  * Return false if kvm_apic_map_get_dest_lapic did nothing useful.
@@ -1451,11 +1461,6 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 	rcu_read_unlock();
 }
 
-int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
-{
-	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
-}
-
 static bool kvm_ioapic_handles_vector(struct kvm_lapic *apic, int vector)
 {
 	return test_bit(vector, apic->vcpu->arch.ioapic_handled_vectors);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index edfed763cf89..50123fe7f58f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -105,7 +105,6 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
-int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec);
 bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, unsigned long *pir, int *max_irr);
@@ -225,12 +224,6 @@ static inline bool kvm_apic_init_sipi_allowed(struct kvm_vcpu *vcpu)
 	       !kvm_x86_call(apic_init_signal_blocked)(vcpu);
 }
 
-static inline bool kvm_lowest_prio_delivery(struct kvm_lapic_irq *irq)
-{
-	return (irq->delivery_mode == APIC_DM_LOWEST ||
-			irq->msi_redir_hint);
-}
-
 static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 {
 	return lapic_in_kernel(vcpu) && test_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
@@ -245,8 +238,6 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
-int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
-			const unsigned long *bitmap, u32 bitmap_size);
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
-- 
2.51.0.261.g7ce5a0a67e-goog


