Return-Path: <kvm+bounces-41144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C647A6251F
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:08:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6175E420729
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E6019ABB6;
	Sat, 15 Mar 2025 03:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ojr76eZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A11991D2
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742008002; cv=none; b=fQDCUq0Eh7fVMYkrJZ4dgWKfqOQEBxJQ7tTvO22ZE3HLAFRHBFRC/7MUbF9brqecz0titXGH1eRUcjCfvwXeVRD0yJ/45skJntzjZAlaD1ObXvifsqYv+nsABvmBjTmWDgQqrEpCMh1XOnOPvtw0KYnux1s9OwpA+datoBVQD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742008002; c=relaxed/simple;
	bh=YPH0PHJw1tpa8l8R9QQeeIkiVyk20jHhX+FQL8dEQKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dB88zZ37F+R1Cguk6c+JLkqvm2CQhfRnTi7uW6K/NRW5z5b061Qo7aau/NQUSVO6k0GH+Sk3Aid+p7+G7k3t/4l3ltIdnH7glADEYlN/oO0vCSZUK9KaFyVPaqeHpyCmiTaoOOpkCR34UPzaXO4dgCI5qerxVJQAO21Nkm1d1KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ojr76eZ7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3011bee1751so522688a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742008000; x=1742612800; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yig8PS2Kt8/pb1c+Gkh8z0ntzMG9R4wz5XbuI5FRVMQ=;
        b=Ojr76eZ7/Cnv0xzFfKrdSeyZ72bzbBnuOeyFAMXAU9GWiWoKoOFRVz/QbIhLzMxrX6
         ImRZBcHvQg6dEabtMGjRYoqvjou2z8+JD8X70Vw+cswDHnHNQx1PlQ50ikcNqSOQkTd9
         KehFp2sdWkkuNSEZOxGQff+6Uclkmkxq62ngovRrGu8uXfBZUdlGxK5E39dDAqOW2J2A
         tRu/3gxr4sTpa/6oBCCA6KZz7YtakVlvkil7BIPd7wG8q6MeWVUA5vf7Xq/sp2e30uO9
         hFPM9wl4AiNo1UnOM563eaqhXYCt9QBITMzrN/IpOSUOyQSf4q8/WgSIM09D8MApxvnl
         XyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742008000; x=1742612800;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yig8PS2Kt8/pb1c+Gkh8z0ntzMG9R4wz5XbuI5FRVMQ=;
        b=USm1LKu3Nngj0noL5ZmYRMkiORj3are+cou1VvNhLyL3bOLE63k0HnJMnEHiYgZWn7
         i17C5ZSmX8EvCMFxhySLs6mT1bJBD+3bbDfTdpa2sh4sAKPak1s9s09ca9wuzY0kS03m
         z7y1fIAPAJuEmwezT4WVRxJY5X1WTVkUpdBUcCWmdYE4UUZaP3UYPpAqGnQSm3ggiQBc
         mv+KdJl5PtZQFCDn7io4WaGsBg0wcx8koXWTnFz9H6AnbNCVimBMAQG+XCOqUjln+7En
         1ajckbR56C04pO0/BLNMyMT0PIcGZyo9omEvDySVBjbrGJv9loq3d/EQ74SmXfRVSF5d
         FWYw==
X-Forwarded-Encrypted: i=1; AJvYcCUszt/VwSoI3Mq0dI1IluDRKncpcnJZkYShGAhgfCh1u7+hEd6ADrZVTby2spBXCcrJAag=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZpioEpy2og7BBj6weHEmbdAuGoiGYYP504/thRRTE9u4vruL0
	QOBqirZPvmZc2WU21fhQQBNS6tj7fRpFUSuNo6kAORpvaTUdk3KlLaMO0OQrcjWi8J6pPLI59Gu
	McA==
X-Google-Smtp-Source: AGHT+IE+tLpYYn+7SIxiMQbvt6BNA1OW+IsM1LNLKbpBuX9tC4yl9q4XDM8kwytvK/R01RnOYlCyet2fS44=
X-Received: from pjl6.prod.google.com ([2002:a17:90b:2f86:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18f:b0:2ee:b6c5:1def
 with SMTP id 98e67ed59e1d1-30151ce1224mr6192064a91.8.1742008000654; Fri, 14
 Mar 2025 20:06:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:26 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-6-seanjc@google.com>
Subject: [PATCH 5/8] KVM: VMX: Process PIR using 64-bit accesses on 64-bit kernels
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Process the PIR at the natural kernel width, i.e. in 64-bit chunks on
64-bit kernels, so that the worst case of having a posted IRQ in each
chunk of the vIRR only requires 4 loads and xchgs from/to the PIR, not 8.

Deliberately use a "continue" to skip empty entries so that the code is a
carbon copy of handle_pending_pir(), in anticipation of deduplicating KVM
and posted MSI logic.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 893e7d06e0e6..e4f182ee9340 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -657,26 +657,32 @@ static u8 count_vectors(void *bitmap)
 
 bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 {
-	u32 *__pir = (void *)pir;
+	unsigned long pir_vals[NR_PIR_WORDS];
+	u32 *__pir = (void *)pir_vals;
 	u32 i, vec;
-	u32 pir_val, irr_val, prev_irr_val;
+	u32 irr_val, prev_irr_val;
 	int max_updated_irr;
 
 	max_updated_irr = -1;
 	*max_irr = -1;
 
+	for (i = 0; i < NR_PIR_WORDS; i++) {
+		pir_vals[i] = READ_ONCE(pir[i]);
+		if (!pir_vals[i])
+			continue;
+
+		pir_vals[i] = xchg(&pir[i], 0);
+	}
+
 	for (i = vec = 0; i <= 7; i++, vec += 32) {
 		u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);
 
 		irr_val = READ_ONCE(*p_irr);
-		pir_val = READ_ONCE(__pir[i]);
-
-		if (pir_val) {
-			pir_val = xchg(&__pir[i], 0);
 
+		if (__pir[i]) {
 			prev_irr_val = irr_val;
 			do {
-				irr_val = prev_irr_val | pir_val;
+				irr_val = prev_irr_val | __pir[i];
 			} while (prev_irr_val != irr_val &&
 				 !try_cmpxchg(p_irr, &prev_irr_val, irr_val));
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


