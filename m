Return-Path: <kvm+bounces-21989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA7E937E2F
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E335F1F22813
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A0A14AD02;
	Fri, 19 Jul 2024 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOAWMULj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E914A4D2
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433084; cv=none; b=FV4B2upnZ2gjN3W2I7U6VvLeT8EePRvok1fanATCDBw8cS+dAIwtdwLCaMYTasQr6bdQtz8Z3oaBwUiaLlaKz9265WnTs594rwZeqMuBxkdCg7mgAGYxXwlIL2DHgsxmYDsL60L5GxkEi0TXrN0DEOOYOKtGuOveitaBA34wnDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433084; c=relaxed/simple;
	bh=avuIVrOvbdJuGswu1VBc5QXgq1mmaRUWopHFZ+/wLdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RgFVUIO6cG1Srww0BqsrBlYP2s7U1nNxAdxJ9eftlYpyVHaUT0RldLOXuQef+PV4gYfmmgiZ8dzlLHhAaWxTDxBL6Ja/tJ3tB4ku4Oc9xS0oUTPB0/U+TdK6mIk3BiAB0UyF+kTv0dFen71yBcDKX9Ph2i7BrUuHPyFUrXchKW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOAWMULj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66890dbb7b8so50143357b3.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433081; x=1722037881; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vV3aMaVHf7C/0akufsxFVZJRmuCa+4Ea2SM/3XMiVaU=;
        b=eOAWMULjI0sxK5+DAGTf7g9lHPawrWWDsxm1ws1SCXQnGgMmZlrpwdvAKK7GIiqYM/
         86KTwrWcZOkwk7sU/2lG9+C+pPS+aOu3skk+15ZSsWbZXh357kpP52cV6LIaXA9WXY6h
         XZacye6vD82sbm6lh+YBso2VPAnffT8ty12duHvIQ10PyaYDF8jrzeH1NYR+TzbOcrls
         CLRqv2lUm6tC0DqTkqJeCf1A8mOAz/aX2lzGpAs2KwolKFs9IAeD1hyKRhE2EuBPVrnA
         hpDs8Nr+nLZVF9W7EJ7QHudRi4WsIGGTcEgbl2OpPSsOCGvuSqXa/kkwlkZi41i08PHI
         DiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433081; x=1722037881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vV3aMaVHf7C/0akufsxFVZJRmuCa+4Ea2SM/3XMiVaU=;
        b=G8gpzsWTqwx2xqTZUGC/ZMoHyVqEzZYVWAuqGUm/W5Dm+aEdbrlIaCWQi9ZQbxBxhl
         Og7DjEbV7p6Gved3qfgoJfSdxxcbyeCrgLkB6oPMp3khWTzfwmYS5HQwCDTcDhAPwRnE
         MRbuCO2HJOVd8/F98fEUToAKSJGrhcC3OV7V/IYRUSgl6HKwf5xmJ7qKipUlSAKSFO9u
         w7dU3w8tL4ySVBe27y1d4z3gclUW5zBvPBs0sGPTPKDS1chq5xxixk71xrewa6jZ0Bz7
         xZCn91O7JPECSlVw/y1UfOJgjvft6EycEgyWrBzJhOBIYx+9KC0cLXnww31iS0m7owOk
         ubZg==
X-Gm-Message-State: AOJu0YxznguP4MzUYkxUSrLR8HpTlpki7U7gg57CogiZ1W+zbrhxgZ1v
	HY56B8A5CT3/Z/GuM3Pi7C5ddU8RpRu84w9QuKMkRudLK5fPA/fR/5fAY4inUneF2U1i4XBPLr5
	tGg==
X-Google-Smtp-Source: AGHT+IFx9+7vK2ERpoBYVxnQ2HTxUS6m7HbUD6i5XHwtnqVPJXqKCxVy91eJGzC7dRUx4lbD788BVlCbsAI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100c:b0:e03:b3e8:f9a1 with SMTP id
 3f1490d57ef6-e086fe45084mr25809276.2.1721433081278; Fri, 19 Jul 2024 16:51:21
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:03 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-7-seanjc@google.com>
Subject: [PATCH v2 06/10] KVM: selftests: Add x86 helpers to play nice with
 x2APIC MSR #GPs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Add helpers to allow and expect #GP on x2APIC MSRs, and opportunistically
have the existing helper spit out a more useful error message if an
unexpected exception occurs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/apic.h       | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index 0f268b55fa06..51990094effd 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -11,6 +11,7 @@
 #include <stdint.h>
 
 #include "processor.h"
+#include "ucall_common.h"
 
 #define APIC_DEFAULT_GPA		0xfee00000ULL
 
@@ -93,9 +94,27 @@ static inline uint64_t x2apic_read_reg(unsigned int reg)
 	return rdmsr(APIC_BASE_MSR + (reg >> 4));
 }
 
+static inline uint8_t x2apic_write_reg_safe(unsigned int reg, uint64_t value)
+{
+	return wrmsr_safe(APIC_BASE_MSR + (reg >> 4), value);
+}
+
 static inline void x2apic_write_reg(unsigned int reg, uint64_t value)
 {
-	wrmsr(APIC_BASE_MSR + (reg >> 4), value);
+	uint8_t fault = x2apic_write_reg_safe(reg, value);
+
+	__GUEST_ASSERT(!fault, "Unexpected fault 0x%x on WRMSR(%x) = %lx\n",
+		       fault, APIC_BASE_MSR + (reg >> 4), value);
 }
 
+static inline void x2apic_write_reg_fault(unsigned int reg, uint64_t value)
+{
+	uint8_t fault = x2apic_write_reg_safe(reg, value);
+
+	__GUEST_ASSERT(fault == GP_VECTOR,
+		       "Wanted #GP on WRMSR(%x) = %lx, got 0x%x\n",
+		       APIC_BASE_MSR + (reg >> 4), value, fault);
+}
+
+
 #endif /* SELFTEST_KVM_APIC_H */
-- 
2.45.2.1089.g2a221341d9-goog


