Return-Path: <kvm+bounces-48870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE207AD434F
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 703F4189CAC4
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30576265CAD;
	Tue, 10 Jun 2025 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0r8NIE78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0B226563C
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585267; cv=none; b=dBXQyHfW+xyppcPDzIIM2Zfwh2Jk8TVtTcc346u/ida1UoL1nvoWTiGtGU653e/shofOsXDYOpCPf5YX4JZGZF44XafUTXqlDoZqG0ztSuoWP+LWOvh1kQko8gOsPFazfGcC6+x0n+vxZMw7JY+i0NE3gIspVxO8m52UxU5htuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585267; c=relaxed/simple;
	bh=4+9p0TzKIASE6m4NeXxrSkyGtNH7JotQ5vAg/hOM9Tw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Prc1iXyMGoZqqdNaYBZ6qAvh2CUERrfzdgXu8L+7AnZ3gSPjGlkmBnHpW9nFj8nI8qgQXgIr9X0y2pk17eMGcvWcAX4kt3dqKZdS9R8/ohS24fM+dSYqtI39lmg4deqF05fYm8BXhwLm29h11mYLiTGa8FUldzIXeliwFMsvF4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0r8NIE78; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74834bc5d37so5819772b3a.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585265; x=1750190065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gRcnM2GxLHZW0mpZdSEmRrAzA/TmAqkGwEyEbDNhOZk=;
        b=0r8NIE78Wwo2OeomqaDK/HE6lHgJmZusLx4sSbzCWEsFLfPaG/Q+d8wH16yE4srjN/
         08FfDKd2OHw/Q3PZ32edj0c6m9hGkN1L+Ns6jqqrVLRv9NFSu9GLItauCaRnfzIke87T
         GPedfHjfBmgsVGNm5fyl79iDmxvu3kSLOwIzIsi1SR/4i/TAPNxdeBG7YXG4I/4CYHUB
         5pE3GF36+ZNJg9Qy0JqMBbK4p9Z8ElwQIVCyda8hTqORGupEIbZbXFAgDY2Zld1ijj4a
         eHeZZ0Oaxmt3WP2T8TSejj9xu03jvvYrXyEtBnLLqvbgspASc3WXXz7e1i2iH1kLeqzC
         Dvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585265; x=1750190065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRcnM2GxLHZW0mpZdSEmRrAzA/TmAqkGwEyEbDNhOZk=;
        b=o3MIjTktlbLKQmQPROGUACiSehZ8wq9vj/fZBFrbfmSImDrxZMHJZbPPcY4W4DkEV7
         k/Ao6J9m40lM2BjxeUPC9axwTZ4frbuxSRDRyvwilhJsKPIkXzv4W6WFM5qTo+WyxlS2
         9YV5MZNsksA5Xe1p+mmJccqZq8Kw9vobu0pa35TYc4VsWhgF3wM1wh1jnYTpNtYo3Xvt
         Qw+4Sfjkv7XhZfhn+WXcvGfJ2rPao/RIbdGzImejuvIiP+d1vBekDH1FFbi5bN6MQ0cH
         xJ0qTv/4i8K1LinepyvfqDLeT78GE2grPMtgDcJfNdcj9aKU7rH4nP90zE4QtRs/4Ps6
         cu3w==
X-Gm-Message-State: AOJu0YwScmgaTxE/mVcrtppUkwpzOHBIgTr6wJd7qX7E1NuE1CUbZrFS
	9FerCoeLrGgfH1F88rqVNY+V+gEMit8wAtyvnWGOl2/Tf43c5drf2srwqoKXTANTesBVGOAwcAy
	ObiELfw==
X-Google-Smtp-Source: AGHT+IF25lN6YKlm3MWbep+lAwdqGOlVx9dqRwcdlNWSmCm88aZquNdiRP7TWGY8+MpOMfFIE3gG5LwuvIw=
X-Received: from pfxx12.prod.google.com ([2002:a05:6a00:10c:b0:746:fd4c:1fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:cce:b0:740:aa33:c6f8
 with SMTP id d2e1a72fcca58-7486cba08e0mr1091194b3a.7.1749585265340; Tue, 10
 Jun 2025 12:54:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:05 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 04/14] x86: Implement get_supported_xcr0()
 using X86_PROPERTY_SUPPORTED_XCR0_{LO,HI}
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Use X86_PROPERTY_SUPPORTED_XCR0_{LO,HI} to implement get_supported_xcr0().

Opportunistically rename the helper and move it to processor.h.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h |  9 +++++++++
 x86/xsave.c         | 11 +----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 10391cc0..b3ea6881 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -442,6 +442,15 @@ static inline u8 cpuid_maxphyaddr(void)
 	return this_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
 }
 
+static inline u64 this_cpu_supported_xcr0(void)
+{
+	if (!this_cpu_has_p(X86_PROPERTY_SUPPORTED_XCR0_LO))
+		return 0;
+
+	return (u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_LO) |
+	       ((u64)this_cpu_property(X86_PROPERTY_SUPPORTED_XCR0_HI) << 32);
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
diff --git a/x86/xsave.c b/x86/xsave.c
index 5d80f245..cc8e3a0a 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -8,15 +8,6 @@
 #define uint64_t unsigned long long
 #endif
 
-static uint64_t get_supported_xcr0(void)
-{
-    struct cpuid r;
-    r = cpuid_indexed(0xd, 0);
-    printf("eax %x, ebx %x, ecx %x, edx %x\n",
-            r.a, r.b, r.c, r.d);
-    return r.a + ((u64)r.d << 32);
-}
-
 #define XCR_XFEATURE_ENABLED_MASK       0x00000000
 #define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
 
@@ -33,7 +24,7 @@ static void test_xsave(void)
 
     printf("Legal instruction testing:\n");
 
-    supported_xcr0 = get_supported_xcr0();
+    supported_xcr0 = this_cpu_supported_xcr0();
     printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
 
     test_bits = XSTATE_FP | XSTATE_SSE;
-- 
2.50.0.rc0.642.g800a2b2222-goog


