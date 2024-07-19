Return-Path: <kvm+bounces-21980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5031B937E1A
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A431281878
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E16514B07A;
	Fri, 19 Jul 2024 23:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IgFEX+ii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE514A606
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432644; cv=none; b=GgOpjD0qCIDH/U+7XOxjdoOOCcqAy/pOghUdIZ+lJsZzsjKQ1Gab3n9VXZGrLhzMLbPxA8Gt9KADBXhX7VSJNBtg4H7/PweOVmiPu5b20b3kOL2A9xPsg1kbmW2C6JSJ5vMijeZtdX8xKZHg1YzOK46irecZ7nNxHPWtgXARAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432644; c=relaxed/simple;
	bh=vGX+QjydJu3zU32DeuD0uDs+BGgsKqP86RvQO+BJ6uk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Thu58ggMUXmCnP8imtGtx/dDYkSOQFn3NlKrp9gp2qZ50ZZaa78EfN7zkRY6iQg3aCIv26Catuzxrgcu6Bx+X11l0Vkx4VzANdM0jenMKt4ABsp89xsPaDj8uaKHhEST/NoDy6C9+bimucTOY0OYIDGVPxCdmpFrlXEttN1dREk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IgFEX+ii; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd774c3b8eso1750045ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432642; x=1722037442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZUvOecK3sLTMz6qm67Q0shiPwc10UQD2irey1Qg3WXo=;
        b=IgFEX+iim849Wzc++CNUkvAjvUB6Xb6zPl8eSF8bOwiDDAZkZZqS39BN9fNQ5y/btR
         StMXYkjGqLpS1nq47f1nDQBoDneL22/ZQDYjDnluYzgKINVZyPNjH2tLe85lN0uhafvS
         yS1O0IrDeOdzrCmP5T9gVSNHhkAXk9SSN6z4GZkKT0EKmVwkRPbEQj1Cr87W9jIyJFKV
         WNPyFFCG5Efqs34trfgO0FeJXI8p61CqMbzD2tuQYrcx/Xwkm5Pea9QUjljngZ5zdNv6
         IELnPCCL03fRlTONGDJxlb1ul75lZ0p9e1I81oGnizxC6fYpWwlOae5QIsEtkv8H+o9a
         FfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432642; x=1722037442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUvOecK3sLTMz6qm67Q0shiPwc10UQD2irey1Qg3WXo=;
        b=TKCi+8nioWp79/sMrVUO/r+IVs7NhhOuj+IwSPw91646QPZZeJv0UZJWjszliBBvlw
         XZa2FepFqxUnLmUKaudX0kc8VoWIKWkb9X78LMWD+XeFaUEpTiiSBdJj8CsaknvsQ5d7
         qJ6d152clthBUD9JSGYZlIfPXKoFMiwLCJDQsDQwvKAZGL2WkO1zPKF7xOorY5YYnCPi
         8wv014qcs6lwN9+C+fSg8SWByQjqj7hUTTeb9tp2slE3LWqkoe8Ozzoqi6hCDulVJgFd
         4Nzcl0l7tO+ABM22c2iVJdIe0qpTJONWbjPMIIFtd8glthnjtb0dZfbMCkcdornVKQty
         +/jQ==
X-Gm-Message-State: AOJu0YyY+s9PvR48l8enJR84Rvd+02lHO/t7PQBUxKvzQ88aBtl5B6mn
	KWR8HQoH7oJ6sr6TF8EBiZ8glxOC85ZH1q2MLPxaT4/j+jSifJYecXFdwKF5fWGPAg5tepGG5HV
	N9A==
X-Google-Smtp-Source: AGHT+IGnhKiwC1lWgStU0irxOJLtvwWl6nqop+oW+igV346cVb8SlQ4Ca/NDQl0jX64yTdSTKHgW0Kp/9hM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea10:b0:1fb:526a:5d60 with SMTP id
 d9443c01a7336-1fd74d87f6dmr880325ad.4.1721432642189; Fri, 19 Jul 2024
 16:44:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:44 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-8-seanjc@google.com>
Subject: [PATCH 7/8] KVM: selftests: Skip ICR.BUSY test in xapic_state_test if
 x2APIC is enabled
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


