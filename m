Return-Path: <kvm+bounces-21985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 958D4937E27
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:51:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 403D41F21D72
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBBD149C78;
	Fri, 19 Jul 2024 23:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OoI3Ey6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC871494DB
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433074; cv=none; b=iSy+Yb+JpFofFRVzs7j7Or2a+a9Xe/Wu2c+PA1NorTOvNlF+kQCUv40pSW4p3XR2hwecIVRkgC1i3sLk8X7x2UfoU73ZxSHqPhdI1BlI2MwM1X0u/vuIIXdpz6aAeg6mIPA75RhIzYBaYgfuAoDNSDf4XI7UQyKaMNbdNqGZ5Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433074; c=relaxed/simple;
	bh=Z1cH1V9K2pPOjjICaFF7xPr76fow0RyXynIXQuiRywA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g8+SnH4G3ovzGrxi4SsEPWDsPsxUDx1uHZ3vdO6UJMDVJ2foZUYM7fbIMHeB4DN9g7XRt0r0Ywcuk+Iefb5M18IUe9f81iDt8vgdfjN/fOHPJXMgB1URm/SWDyTmNrkgujhribkh9PeS22w2MUU1UbvMZXHGNvRxT7iohk+M5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OoI3Ey6G; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb7364bac9so1836715a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433073; x=1722037873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RdVO46PMlcBgI+ne7j7UwSAA4lN1OIh/NoMWcCiQ7DM=;
        b=OoI3Ey6GTgrYVKbH5Dz1xQw/VxYVlAZlUJSuCfbXBYjp4p0lHZj37PYNPQOBrsJoTK
         0CZueGELn7K2s9ongLOoh3i5vJ1vPREDEXwtfaSV9kSL1wBf+T5IPgvsqzG4HvoWuPPL
         GU2FgT41NNicpd9Oi6z1vQDdfQgkqexjcrofT7CoKP0dLIijEESME+2RwNP0+hlBOf7v
         sZlIxq361CVmwuWeR4rjmBLhBuprwwR9+W1Q8WEamQt0UDG6z2dIbFINFU4i1bYpNZle
         adFd0vBObsHgwb4AzUQ+kvYIB0An/9C5ZShJvBdOy6s0XVkqSW1O1hQt35RjQ/b0dnAp
         YJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433073; x=1722037873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdVO46PMlcBgI+ne7j7UwSAA4lN1OIh/NoMWcCiQ7DM=;
        b=jXSmNxnDoHX/revFmMrtzobv1CqzaVoSq57rCnXk+Aqvspx0aGtFAfX7ALI4pDXit2
         gk7GBLCadOb45Y6y10q6r9Fatrref19tnpx0n6yzfCXxY01MZIEUSp47GlJJnkjZqzmr
         TB8PYFhDTVgrMHpWwgUlgDKqq86Fq69sCgPe0GaRM3uaRQHnPolX8Q2OzLLwTGnvvJuM
         V0G2G/BwE8rbxpnP9M+Z8h1hrEvT6xH8gddjk4jLOEuBE4LQ/kQs5f48jBwQy3RnEbFx
         q7owUhsXtFlpkbcil3MNYrXtRhgk+RszmX/uTOHXtpHARrhPnUJ38QZkJckDSqVlyx4X
         +DZA==
X-Gm-Message-State: AOJu0YwZdDTTj8iWPXpTI4cIHaXB3Oy9Y6cGaDtN/NPKyOKTR9hdVpCi
	bZDTcDMk3BghdSUVox+FdKZhIkdD0nYuraKXOegfO/Bb6xXyEElqdHYX+ZSYYugTqv+AmQSANRa
	V9Q==
X-Google-Smtp-Source: AGHT+IGmFkrrWPx3tuEOZ0FODIaBqubff0bPniwUu0Iu1FG6TzHsKKgJswuzEa2qgvqE403sR3EIJhNUJ+w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b0e:b0:2ca:f1a0:8e74 with SMTP id
 98e67ed59e1d1-2cd170a5399mr56982a91.2.1721433072795; Fri, 19 Jul 2024
 16:51:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:50:59 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-3-seanjc@google.com>
Subject: [PATCH v2 02/10] KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Hoist kvm_x2apic_icr_write() above kvm_apic_write_nodecode() so that a
local helper to _read_ the x2APIC ICR can be added and used in the
nodecode path without needing a forward declaration.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 46 ++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 35c4567567a2..d14ef485b0bd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2455,6 +2455,29 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 
+#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
+
+int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
+{
+	if (data & X2APIC_ICR_RESERVED_BITS)
+		return 1;
+
+	/*
+	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
+	 * only AMD requires it to be zero, Intel essentially just ignores the
+	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
+	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
+	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
+	 * sane way to provide consistent behavior with respect to hardware.
+	 */
+	data &= ~APIC_ICR_BUSY;
+
+	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
+	kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	trace_kvm_apic_write(APIC_ICR, data);
+	return 0;
+}
+
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
@@ -3186,29 +3209,6 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 	return 0;
 }
 
-#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
-
-int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
-{
-	if (data & X2APIC_ICR_RESERVED_BITS)
-		return 1;
-
-	/*
-	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
-	 * only AMD requires it to be zero, Intel essentially just ignores the
-	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
-	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
-	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
-	 * sane way to provide consistent behavior with respect to hardware.
-	 */
-	data &= ~APIC_ICR_BUSY;
-
-	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-	kvm_lapic_set_reg64(apic, APIC_ICR, data);
-	trace_kvm_apic_write(APIC_ICR, data);
-	return 0;
-}
-
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 {
 	u32 low;
-- 
2.45.2.1089.g2a221341d9-goog


