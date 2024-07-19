Return-Path: <kvm+bounces-21975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A02937E10
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E69B1C2135A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96233149C6F;
	Fri, 19 Jul 2024 23:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TPPHYkBy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2C1494D7
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432634; cv=none; b=W0HPsn2z5RI3Lb0NQPpSKsPgQwg0EPJLqihlNkgabEx6tLETcmFIl9EBZ2JKO5GrifDJe34gWe2onBdradKDRVpjslwq9EIrjRayjISmoKqWLStF5CjROoxp2W8i4EJYnVmISZ8RnMoYcQaqPNn7KxlW5TwhHMX08ennK+qvuHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432634; c=relaxed/simple;
	bh=Z1cH1V9K2pPOjjICaFF7xPr76fow0RyXynIXQuiRywA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tAvBG54vgguRl1VCzXnxzvlPnfQTL0Y5ww7xmBUJ0YV6JyhZigumxKG0gMIZQ5mx/2x6E7wxwZ1+sUTEj7wk77cEs6vhCi3KXcQ0XnlmJ+70ar0EAagH2jK5TAC4WCU8BmccDKzXbQj2qeC1MJBuPBZPmD6KALUxMhYn7VqFSf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TPPHYkBy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70b0bb79c49so1211730b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432633; x=1722037433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RdVO46PMlcBgI+ne7j7UwSAA4lN1OIh/NoMWcCiQ7DM=;
        b=TPPHYkBy3TiUELDRlwMuEx+qBxW/BuO8KYkUDyHRSf5MRNaGhFPDHXmDgsmVwaNDIJ
         h03JcUYfpPEroZmy0kWXwF2IhAvoCKaKYp1tatz34XiYTzXqudOIWGVsqlgOH1BOJMHP
         DRV19vp/2yVwlm5/dOIMoynZG9OGr8jYTLrjEvOcGsKb7nGIVzrjUpF0Nlg9g8AX3IKh
         LPT/cWKLZHsPOa7cV3sTWdOv+zjK6GyAmce0HRb0FbGNyZTycFsqSAYdJeFgy1k8cTK8
         TzrICGeUx3icxZ6SBMFaYOx2/VTKm+aKWaBbCWL7EO/3/cjusTZrV0cB7XMxqgurea7e
         wu9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432633; x=1722037433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdVO46PMlcBgI+ne7j7UwSAA4lN1OIh/NoMWcCiQ7DM=;
        b=jnyVY7wWG/KV1EWuRyRbAzF5+7/hryShhy1tpzikoYLfPfLJ6dlLt4NyRYOMnUX5pi
         mznPgbnWvNPqeYR8le9HwbZtcXvPiZmyjWet8VkGgfDfoI5QKiadvN9eDTe/5J1dFRYA
         rdYjbpR4F9AHGKn6DzRiztGfQyKWS6vUqwVl9Ija/wZDDQ14LeZJUMD/hsqsRxkMpbU+
         kvjKukYiGVVklTILv37q2FW7092BhlqNVYrE6f06iTJec0+FWnDDnnp5j5RtXqFaU8O6
         mvaodK2QJWWVaKWM8XMnhPvRIpDkR1pO3/ZX8tujwdsjrHi5P/Zxr8ug7MVZfzV5sBdX
         ANHg==
X-Gm-Message-State: AOJu0Yx7TveC3dh4sA6OUMzX2zD+3qCarvgSVcOKnCx1pT8ZCMPO0f9k
	IwYHdP5Zt+NmV+P2veErBBlIQi7FLqFSdbdMpysrE5iTIUcMnXTO4oJV8zgBqSsPGA0+h3JS767
	idQ==
X-Google-Smtp-Source: AGHT+IGrqTi7r+bD33iXiOlKe24I4fRBWbe1ifwKtqgnwHLxRGmTs+zh59kEsCtnf3DhIB+XwN5wBZPlmi0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:87d8:0:b0:70a:ffc2:ba with SMTP id
 d2e1a72fcca58-70d0845b84dmr4399b3a.0.1721432632396; Fri, 19 Jul 2024 16:43:52
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:39 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
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


