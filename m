Return-Path: <kvm+bounces-54036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD7EB1BA9B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11DC417529B
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AD629B8CF;
	Tue,  5 Aug 2025 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yfSaQQch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979929B205
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420736; cv=none; b=kHJnmfl4XcpoW5i62ZPMkDaYhz58ObKxKcnz5dn/NMnoj5pz5rcUVRVWmwE0vz3T1TPRJH8EnFT1Sm6ZiBUPydNZTvPVjGzqQ4D5CNvlXFFW8l9vhtsqAZmnBEllgSNGxlj1hLQyl+yZ0FlamYi1tKgZ6RwHR0/rpoX8qlfqF5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420736; c=relaxed/simple;
	bh=wn8FH/CbQefJkydk31Od56LqbL8DTaoAuQuLtn3ojvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sy0f0HSlIjwaco8HxwFxCiWFDCxT63eN8AH4Xc/NRNgNs/TZN2Pn+NV7eJfAOZdldHpXmFo6RB7RhkZgmilzlsusSZs0dQ/en0W0TqtXDmjTcQe4xk+7VUYFyrTj3RXMOmK/6FOZqcIJ2G0HKu+eISBzf4v034xNe2UHqUtIdpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yfSaQQch; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fe984fe57so65926795ad.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420734; x=1755025534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bUQ5kLCEv2X5mdMO2xveh6XBRkOp4xrjHvyUwtUsZso=;
        b=yfSaQQchUtUrGj76Fv5/KILsDdOCQ77CiiakfzJWL64HAIT4868x9K5kr+anWrDNP5
         ocUK1vuXUf+i9JKqUtrYcoOK5LCI4yYcayi0V6w9H84NnPZSRKdZNrKKMWlN9byFrRCK
         q+o0LLjYWEw7dcueMOdm39muhJBmK96/aY3L0dLBFiRfMiLepdAeJ8MqKKh/TF/HRmdp
         5sBAkKsjuFeGqkqAeV6vrEwxTKNZ6VrOBfRlAGYzUUmNxHFE2WQib/SuGVLgrXBzkjGF
         ZSmXS2/iRC/8QcRTFXaU9OTSEOUBCOm67sPxOH2N2YNrgu7xYidTwDpySy7DL+12Pc2w
         EVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420734; x=1755025534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bUQ5kLCEv2X5mdMO2xveh6XBRkOp4xrjHvyUwtUsZso=;
        b=BU0xAPlkk5ehMoqe/wSWbr0fUEv37X7YnEXXHtllYw3y1bwTDRSdCxRNEbyXM//v07
         /WZg/qKTecdbLvEs0CSpcYeaEDnfvlK3bO9cy02WTLDKQ8wGdpe9SM5CwY5u+BYCjUwQ
         zp985fBsg790RouxuJ4NKEu+dUhVIyNZ5QRntKGNEZyXGKSjveB179PcVrwydymwfQpQ
         +g/lE+75SEVW5ohB+qGkz2Ckho/rKTQ5yYyflnnLE28+Rtc2jJwi8Khq9TZgMwYcf8Sm
         XO9s5ywzaaGju4e3Y1RJATlx81VmqVf7zmPZ2Tr4Q/wrPpOaveoXF5TjAOl6vwxLeK+7
         EvCQ==
X-Gm-Message-State: AOJu0Yxe+1miwKchfZT8FPEssrRr34HIuoBNSX1XGMbDyKfnVd3Jc2J/
	6ivA5SOny2PfqHipbOOACql9aGvszbK8igWBeho8VD2mO6JjxV8IBN7nSlvMhniIAYKzItId3wJ
	41Kmkcg==
X-Google-Smtp-Source: AGHT+IE+OsfSdhSCn/Gs6PlSpEaDYKfPnlddZ+qWQCd+uo32vxz0OpikkULyxj2ptofDKrqY1oT+77lEksA=
X-Received: from plbkf15.prod.google.com ([2002:a17:903:5cf:b0:234:9673:1d13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50e:b0:240:5c38:7555
 with SMTP id d9443c01a7336-2429f1ddb60mr2746245ad.5.1754420734532; Tue, 05
 Aug 2025 12:05:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:11 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-4-seanjc@google.com>
Subject: [PATCH 03/18] KVM: x86: Only allow "fast" IPIs in fastpath
 WRMSR(X2APIC_ICR) handler
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly restrict fastpath ICR writes to IPIs that are "fast", i.e. can
be delivered without having to walk all vCPUs, and that target at most 16
vCPUs.  Artificially restricting ICR writes to physical mode guarantees
at most one vCPU will receive in IPI (because x2APIC IDs are read-only),
but that delivery might not be "fast".  E.g. even if the vCPU exists, KVM
might have to iterate over 4096 vCPUs to find the right one.

Limiting delivery to fast IPIs aligns the WRMSR fastpath with
kvm_arch_set_irq_inatomic() (which also runs with IRQs disabled), and will
allow dropping the semi-arbitrary restrictions on delivery mode and type.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 27 +++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h |  2 +-
 arch/x86/kvm/x86.c   |  2 +-
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9f9846980625..bd3232dd7a63 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2439,7 +2439,7 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 
 #define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
 
-int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
+static int __kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data, bool fast)
 {
 	if (data & X2APIC_ICR_RESERVED_BITS)
 		return 1;
@@ -2454,7 +2454,20 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 	 */
 	data &= ~APIC_ICR_BUSY;
 
-	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
+	if (fast) {
+		struct kvm_lapic_irq irq;
+		int ignored;
+
+		kvm_icr_to_lapic_irq(apic, (u32)data, (u32)(data >> 32), &irq);
+
+		if (!kvm_irq_delivery_to_apic_fast(apic->vcpu->kvm, apic, &irq,
+						   &ignored, NULL))
+			return -EWOULDBLOCK;
+
+		trace_kvm_apic_ipi((u32)data, irq.dest_id);
+	} else {
+		kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
+	}
 	if (kvm_x86_ops.x2apic_icr_is_split) {
 		kvm_lapic_set_reg(apic, APIC_ICR, data);
 		kvm_lapic_set_reg(apic, APIC_ICR2, data >> 32);
@@ -2465,6 +2478,16 @@ int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 	return 0;
 }
 
+static int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
+{
+	return __kvm_x2apic_icr_write(apic, data, false);
+}
+
+int kvm_x2apic_icr_write_fast(struct kvm_lapic *apic, u64 data)
+{
+	return __kvm_x2apic_icr_write(apic, data, true);
+}
+
 static u64 kvm_x2apic_icr_read(struct kvm_lapic *apic)
 {
 	if (kvm_x86_ops.x2apic_icr_is_split)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 72de14527698..1b2d408816aa 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -137,7 +137,7 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
-int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data);
+int kvm_x2apic_icr_write_fast(struct kvm_lapic *apic, u64 data);
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..8c8b7d7902a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2149,7 +2149,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	    ((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
 	    ((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
 	    ((u32)(data >> 32) != X2APIC_BROADCAST))
-		return kvm_x2apic_icr_write(vcpu->arch.apic, data);
+		return kvm_x2apic_icr_write_fast(vcpu->arch.apic, data);
 
 	return 1;
 }
-- 
2.50.1.565.gc32cd1483b-goog


