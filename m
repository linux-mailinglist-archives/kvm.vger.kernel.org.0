Return-Path: <kvm+bounces-21990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9314F937E32
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6BA01C21456
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C88A14B091;
	Fri, 19 Jul 2024 23:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sT9zKYe2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F398914A60D
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433085; cv=none; b=IYnQmJIyO5ZDiN/+ucGQFRtO9E6ZDY6NGWejUcwn2k4SX72vHVhldwR0IF8gdfrRzuwhNLOgmUSP6WGLY9d5XS8ekYlKPKnSF2oaKQdzP8zzHeKAsLPmYeG6H7Xb5XCDy4QKdbl64GTOlqURHF3SeLVYqCwgQQjXudkgrhSVSY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433085; c=relaxed/simple;
	bh=vGX+QjydJu3zU32DeuD0uDs+BGgsKqP86RvQO+BJ6uk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PzyugtlHWi2B2GjShXctAFPngizTTzElYyXoVZQbduLenaiofpNwpJ5c3vpQd5HG0ANOsUO/ax8Dp335y2KTWJvP0xV/bPM0Xiga8OIMMaWztT7WUcvBelmTaB8Iv0YFOoHUrqQ5SHuQsG1B3bQPhl5atUf3hac5z+xD+2Ks3oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sT9zKYe2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb4c2276b6so1991107a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433083; x=1722037883; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUvOecK3sLTMz6qm67Q0shiPwc10UQD2irey1Qg3WXo=;
        b=sT9zKYe2AnbCTWsxr2d+fvVP4mKJUgIgXJYnlFGwbN2u1npFeDMpIcc3z3jjWOTQSY
         H1zxBQ0kXPJL+zhopTFnpLjeoU1Kl0GDPM4hL3UNX+dkgZZShZDl5USm+o4L29nKeCz5
         KOyMqlnUxXNiuvLojxG9ZSbEkI0yQZwTZ4NQM5uN0iH78cf1KErmABawHv1CbQbMpsZ4
         ZO+VAeLMLsd+Dz8+YMBUWGUXDhplT+ByCmoTGiGSRBjG7eS9Bx2Ve6yGPE2FxApaAvWO
         IwFBp4Ekb2SBl6EH+fX3jyvtCcgLUNcdVeoOILasvKyMw+NMnMOlyaUrazK60oGQzR5x
         hlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433083; x=1722037883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUvOecK3sLTMz6qm67Q0shiPwc10UQD2irey1Qg3WXo=;
        b=gyJtixgOH8Pv5sXBeOz4MnA4mB1Hco3SnMSMv9oHQtJ7XbJgVJfEarEZEGxg9BGPAJ
         4C4F+6Njes2dq99PXqqLOn5eX2PquqIJoZa8R/sBiw08s04WRaDxpTUK01uudOPfILK9
         A892N5RMpqyYopuBfWuanL0olwgbELjuVNlfxS/nF87PUtiLrj+mjDXnJVednZDtVinE
         mHDdBH3kY7tN7WNqdfaEIffXGQWG3pTQ5J60pQRFiCx/Ac3s1tUNsIvkoqpj7tBflHfM
         0ccRYJ5Vi1uPMrDMFXs/mZJ2k1UimGQEfK0kSc6qL1z8UQzVBgWlgDpaMX+1I9ocIcD0
         sd9Q==
X-Gm-Message-State: AOJu0YwBiMr8QLWvewZ1RMQl0Fg2SdPc3dTvDDmTw10+bc0P+894Kfyb
	pjsyomQIib+0GIcq/8NgUKeShHsRmubwduBfGwgConXla4MINPaGiqLOFo1SPpohxXxht0iIkDK
	KJg==
X-Google-Smtp-Source: AGHT+IH4xR/BOfWKOPUMASMusbY5ub+urdfsnucw/9o+x1nLQ9TwhoA/c/J2omSZr9UBr+XODY5GuQ6L3iI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fe8f:b0:2c9:ba2b:42ac with SMTP id
 98e67ed59e1d1-2cd1618bd8amr3900a91.4.1721433083102; Fri, 19 Jul 2024 16:51:23
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:04 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-8-seanjc@google.com>
Subject: [PATCH v2 07/10] KVM: selftests: Skip ICR.BUSY test in
 xapic_state_test if x2APIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Don't test the ICR BUSY bit when x2APIC is enabled as AMD and Intel have
different behavior (AMD #GPs, Intel ignores), and the fact that the CPU
performs the reserved bit checks when IPI virtualization is enabled makes
it impossible for KVM to precisely emulate one or the other.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c    | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 69849acd95b0..928d65948c48 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -70,12 +70,10 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
 	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
-	if (!x->is_x2apic) {
+	if (!x->is_x2apic)
 		val &= (-1u | (0xffull << (32 + 24)));
-		TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
-	} else {
-		TEST_ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
-	}
+
+	TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
 #define X2APIC_RSVED_BITS_MASK  (GENMASK_ULL(31,20) | \
@@ -91,7 +89,15 @@ static void __test_icr(struct xapic_vcpu *x, uint64_t val)
 		 */
 		val &= ~X2APIC_RSVED_BITS_MASK;
 	}
-	____test_icr(x, val | APIC_ICR_BUSY);
+
+	/*
+	 * The BUSY bit is reserved on both AMD and Intel, but only AMD treats
+	 * it is as _must_ be zero.  Intel simply ignores the bit.  Don't test
+	 * the BUSY bit for x2APIC, as there is no single correct behavior.
+	 */
+	if (!x->is_x2apic)
+		____test_icr(x, val | APIC_ICR_BUSY);
+
 	____test_icr(x, val & ~(u64)APIC_ICR_BUSY);
 }
 
-- 
2.45.2.1089.g2a221341d9-goog


