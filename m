Return-Path: <kvm+bounces-64197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 29835C7B40F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CC41A3475E7
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198F634DCF5;
	Fri, 21 Nov 2025 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="02eXL6qu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23B230AAC8
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748568; cv=none; b=WGKL9743rcKEGObweLrrBWQ8M6vlti2f6k53j+Txyiiz/QcEYSkiutRG+ycLRkbC6Qa85RtxwqmZjeT+HvqRoznl3PFmhIocvviX10VFbvqIPqxP7nfbKCjnzX90yQlVU/j+mSZBWA0RkEMrjWABWh52JKEZgvpscAVSKBZk92M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748568; c=relaxed/simple;
	bh=fVap9qsbslxIIux0AyKqW7jpzubZ81AFKFxTQXAYgXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BTWU5bIs7Vpgv29O/Ep6/RXAO6GknAsdtyEuxywx+HXlkWIsVZ//btcIHJGFf/szxbCOHDOGl6auHrVJixbBIou3ROQ3bcPqkF5HlWfCjc87dAbQzqPNZ1RoLucKGWoU2xCkA1m1UaJi6r3Lq5r68v1llVZgRsF3KaoFmEK76As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=02eXL6qu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso2595768a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748566; x=1764353366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J2J5UcXpbQH5riAn/lkjPdOYesyfwi/jI8HCDcOQoVc=;
        b=02eXL6qu/44mS1Cmppv41y/ZDhDLoE/WuHtTa/WYAiPvT/4F2WwSk+V6rOK6thkJAF
         bqOgOrRpFAY4FjY+1ZmMNv3CCgT+63uxEOTPZ0WadbGZwiyeYsWqSTY2wtz30AUXT0SR
         bussBDaM5CgwRkQ5v/6UQ58Af5pAZIw8qdPP/okSCHfFT4haZUfNvUNU/ngjmSQkPLya
         gyyD9VfyathsL7aF36pxw4Pg5gMj2nwmd7hwN8IdAmvO00iWTZW67VTcob2D+VVEI2nK
         lrRB+SZ+rMqfNhriKj0oax7jk4eCTBus245iTKzl8gI7IljPxFlu8mjW5ZwV0smjS7bE
         TtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748566; x=1764353366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2J5UcXpbQH5riAn/lkjPdOYesyfwi/jI8HCDcOQoVc=;
        b=uG+Umq8JRpvpsytDdS751yenybBts/q8/xJOBNg9m/2Yb+dGcSbd67B6Q9FnjslC++
         shEyIMbrhPbKON8peKYKE6hKFbFbfFq3mXWOCuXAAddj829RMkWJDKFuGAmf7WTPji2h
         zZIOkgA6jqdeLl8lBl2g4PgT1OzakruND/1Kc5ik1i8cSUCMgCFgomD/+WLN9pBKzHGS
         ub/bzkB4oQW2djTQyHEiD3qawP6cVL5YnL/cibdBxle5rcy9TjctJMDOncWoJ7O3MJ0V
         IOszcpwwgezHSYIE45YHhZcnGk+3YX+vl8UlUMhJJyjCDbaUoQ8eGEwatnsMD7KxWL7p
         LWLQ==
X-Gm-Message-State: AOJu0YxIvY13JpKHGK1+kOLuia/3SKD4W1MPSv1rvkK4f8AtHqsjDlHy
	LDjHsMQdDMoJ2UlJ/RN1vFtUlH+MxogpbK894pMn0hIrCPw1Idl/ek3xtCSJfzS55V3yztN/HVO
	ie+4jsw==
X-Google-Smtp-Source: AGHT+IHJugXzQWdlkyWlkhNKNnpWt+n7RjqhO1mZggiREUsvbm4lxrLStfRe/65Oco+jg8SfgxuL3Ydev9w=
X-Received: from pjbms3.prod.google.com ([2002:a17:90b:2343:b0:343:7087:1d21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5746:b0:340:a5b2:c305
 with SMTP id 98e67ed59e1d1-34733e4368fmr2757976a91.2.1763748566190; Fri, 21
 Nov 2025 10:09:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:59 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 09/11] x86: xsave: Always verify XCR0 is
 actually written
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When testing writes to XCR0, always verify that XCR0 reads back what was
written.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index 72e9c673..54905e06 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -43,9 +43,17 @@ do {									\
 		__TEST_VMOVDQA(ymm##r1, ymm##r2, KVM_FEP);		\
 } while (0)
 
+static void test_write_xcr0(u64 val)
+{
+	write_xcr0(val);
+
+	report(read_xcr0() == val,
+	       "Wanted XCR0 == 0x%lx, got XCR0 == 0x%lx", val, read_xcr0());
+}
+
 static __attribute__((target("avx"))) void test_avx_vmovdqa(void)
 {
-	write_xcr0(XFEATURE_MASK_FP_SSE | XFEATURE_MASK_YMM);
+	test_write_xcr0(XFEATURE_MASK_FP_SSE | XFEATURE_MASK_YMM);
 
 	TEST_VMOVDQA(0, 15);
 	TEST_VMOVDQA(1, 14);
@@ -120,9 +128,8 @@ static void test_xsave(void)
 	       "Check CPUID.1.ECX.OSXSAVE - expect 1");
 
 	printf("\tLegal tests\n");
-	write_xcr0(XFEATURE_MASK_FP);
-	write_xcr0(XFEATURE_MASK_FP_SSE);
-	(void)read_xcr0();
+	test_write_xcr0(XFEATURE_MASK_FP);
+	test_write_xcr0(XFEATURE_MASK_FP_SSE);
 
 	if (supported_xcr0 & XFEATURE_MASK_YMM)
 		test_avx_vmovdqa();
-- 
2.52.0.rc2.455.g230fcf2819-goog


