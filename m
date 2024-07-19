Return-Path: <kvm+bounces-21981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D2E937E1C
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 307011C21073
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE1414B953;
	Fri, 19 Jul 2024 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VWJ7ayf8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA581494A7
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432646; cv=none; b=RmAB2uoMjTGI37lAS4nV1neHmcA6KkD27AmAGO54gi+5lBX5dTBr3LU0H2K9FNZE8gQ9gqUVoFbCr02CtYQTi9/ld1AebyJ6bPJm0Xf/CfvxbwaXeQpz2iATAVj6gdkNUV9L3cpJD/Uj9vZOCuVEF/gZj0Mixki/bTLfv+c/5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432646; c=relaxed/simple;
	bh=M/NyQgjGXBaNreFjHyLA402m2eagNzOE5eYuTkfJG8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N8epdSwTuyvcWrPMAfF6bRYO4iXlkKZw1ZZE1RnB7iZFIVotr24xBZTwuvsJHaOSUy7tfvFnRl7t8Ojr6Np8Mj0n9kjRpI74nPnaV/ratYS3Aq/O5lmdFCZQxcMptdQBdjddLwZp+wflg6JhNZWY4vJ43miBlIy/J8DxV49XjnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VWJ7ayf8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc54c57a92so20469215ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432644; x=1722037444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rky9lB8r38gMZ+TqqtRst26vC75RUEgf6EDR/NOmmsM=;
        b=VWJ7ayf8QKyjGG/QhRF+XCbRmHMnELh3uwSBUOVWI4Rdi+8KdaW3smSE9UWhwMkJll
         0vr1QBG4vQSn3cdA96fYAuq7WUAHVH8VtiYgHdAGKB6PgdIxGZ7SD1hpsQQaBFMINpiF
         GQCS9RqHLpcv7HpIbPncUM3fUkdIIO4savj7NjOZwm0V1ClwDUj5yJ4/YD+vgV9CJSH7
         SgooQscw90CRiSdx9b8oj5axGstm5P0S+MYv2+TMvEzr9DI9MdLTqB7Im/uxtYGpWFjd
         uVIIp49Ml1YrpJ3XmjLTwR5p1eOw0GWLDnWhyGlPoPzt/MS7hUBZeOvS428RB/hvmPjt
         JJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432644; x=1722037444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rky9lB8r38gMZ+TqqtRst26vC75RUEgf6EDR/NOmmsM=;
        b=sQ3Fw6cAnu2KGCGHULzvuBCNPFCSFFXDDgUgu5/gxAOO9X4QC52d/AV+EWwTJjTIwn
         P75DweYTZRVnpzshHWtGyn/qmBaiGLd4snM/B1feKvkOld6Lv/cEl1RXb3wwXVtiBh0t
         H8zSlxDnHZE5PexWwMftFwKLnggUUb/xeOkm6xLlS+fLlxny/Weul2h7LAZO2yJPa2kP
         NZSv0RSHp2DBJCLdo08gY/7T9w4fW1TMosuIZr4Rh9ab2qw2YnALyiUK7MkHXGnUY7Cd
         g1J8KVgZdiAh3zjXl4/XCLLc/JJjRiGIjT+hTx8/1FwvQ1uNSqY6J1hyG5RpD8FB82BX
         9jHg==
X-Gm-Message-State: AOJu0Yz54saspLMjxudaJ4CAVjrK3citwnFxEQambvqeJNXvbo5BDoK2
	emOrQJ9HjNF3GVHAtmyYhexEC9IH+13zjXBHbx6ca5rjXakqI5IIWh8Fr9E/F1d2M8WJSLz+EgM
	Pjw==
X-Google-Smtp-Source: AGHT+IHqLL4iTsWdNjx6HxdWSeX/rS7x3vjnktjhHaCJPZN8EdE2np/68Z7gXEq3b6USSD8ByBeBiZlEqhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32cf:b0:1f9:ddfe:fdde with SMTP id
 d9443c01a7336-1fd745c27admr911935ad.9.1721432644115; Fri, 19 Jul 2024
 16:44:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:45 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-9-seanjc@google.com>
Subject: [PATCH 8/8] KVM: selftests: Test x2APIC ICR reserved bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Actually test x2APIC ICR reserved bits instead of deliberately skipping
them.  The behavior that is observed when IPI virtualization is enabled is
the architecturally correct behavior, KVM is the one who was wrong, i.e.
KVM was missing reserved bit checks.

Fixes: 4b88b1a518b3 ("KVM: selftests: Enhance handling WRMSR ICR register in x2APIC mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xapic_state_test.c   | 23 ++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 928d65948c48..d701fe9dd686 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -31,6 +31,10 @@ static void xapic_guest_code(void)
 	}
 }
 
+#define X2APIC_RSVD_BITS_MASK  (GENMASK_ULL(31, 20) | \
+				GENMASK_ULL(17, 16) | \
+				GENMASK_ULL(13, 13))
+
 static void x2apic_guest_code(void)
 {
 	asm volatile("cli");
@@ -41,7 +45,10 @@ static void x2apic_guest_code(void)
 		uint64_t val = x2apic_read_reg(APIC_IRR) |
 			       x2apic_read_reg(APIC_IRR + 0x10) << 32;
 
-		x2apic_write_reg(APIC_ICR, val);
+		if (val & X2APIC_RSVD_BITS_MASK)
+			x2apic_write_reg_fault(APIC_ICR, val);
+		else
+			x2apic_write_reg(APIC_ICR, val);
 		GUEST_SYNC(val);
 	} while (1);
 }
@@ -72,24 +79,14 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
 	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
 	if (!x->is_x2apic)
 		val &= (-1u | (0xffull << (32 + 24)));
+	else if (val & X2APIC_RSVD_BITS_MASK)
+		return;
 
 	TEST_ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
 }
 
-#define X2APIC_RSVED_BITS_MASK  (GENMASK_ULL(31,20) | \
-				 GENMASK_ULL(17,16) | \
-				 GENMASK_ULL(13,13))
-
 static void __test_icr(struct xapic_vcpu *x, uint64_t val)
 {
-	if (x->is_x2apic) {
-		/* Hardware writing vICR register requires reserved bits 31:20,
-		 * 17:16 and 13 kept as zero to avoid #GP exception. Data value
-		 * written to vICR should mask out those bits above.
-		 */
-		val &= ~X2APIC_RSVED_BITS_MASK;
-	}
-
 	/*
 	 * The BUSY bit is reserved on both AMD and Intel, but only AMD treats
 	 * it is as _must_ be zero.  Intel simply ignores the bit.  Don't test
-- 
2.45.2.1089.g2a221341d9-goog


