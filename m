Return-Path: <kvm+bounces-21991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B796A937E34
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73A762823C0
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88A214B971;
	Fri, 19 Jul 2024 23:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zD+eUP1W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B372F14B947
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433088; cv=none; b=JVCMXFyW2zPIPk2/qmo67Dz0jhxhdpuwc9+j4zkK8SVBfrUNB7Wny7oRScQ/vGWdER4ZOSCicprnuxTs7ZByY4D3F+dxGp2rhqinRa3u/kskFzv7APfO53LmM1NV1ZLKMKJ0973hD+h/Lw+i9LPGpHjFYii2ENLITQ+9kUulUzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433088; c=relaxed/simple;
	bh=M/NyQgjGXBaNreFjHyLA402m2eagNzOE5eYuTkfJG8U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jrMttNuwGot/gZCuQNg7yqU6N/MrWNPO6Pjqa9iG8WgItrT/ld1kLAnDTzisRibDDOgqTMZUpO2k2wkttEEV6Rl2ESOLjPECyDUhPktrVUp3K852P8oxFXqyCCFsxsEJKtFqQ9LzQZHhvE1rlGkNOSo6gTs7AlauCbI90TKghhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zD+eUP1W; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5652f7d4so23106175ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433085; x=1722037885; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rky9lB8r38gMZ+TqqtRst26vC75RUEgf6EDR/NOmmsM=;
        b=zD+eUP1WU7wGtbT4m/PC+U/wBpDtGL4qu9fL1n2HR3cPceaYkiEThnGBJOjyLhdv9i
         WfIwiJmjthRQjNYEdf3X7M1EzFBF2ba+EGTKG+OsJ+DgXPb7Hb/xdmYduFxA0lIQ7G/o
         aoNhsVBGTz+MWJEKbAIen3NJ3R/d5y+ttABkELN3e4VHR1KIqvtQ3WoVP7fGexIlCNFM
         vr3W8J7jc5dcsb7RgIP84LmuKwHAPerACUsKAubTLSY5uIlLzhLoMqWNRIsNtOvhLRk3
         Z0kwzzK8Kqcu7jwW2Cqu6gDrWpu4iP+B3oVPNslxLMs4YbFECs7A3qAApxDGN+0VnS9J
         4+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433085; x=1722037885;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rky9lB8r38gMZ+TqqtRst26vC75RUEgf6EDR/NOmmsM=;
        b=BAJqOMK8sFjtOugz5YEEl/RBM3yEtiQr84tjmG/anV7J4eGz1Q9pvXGk/lcSSRlqni
         oLchRITGpE9dmk35giLU46D3MHfHqU079LPQkCSDK9erzZ8bjV2YhPV9CUTBm7laQMlD
         PYQK9LlwohEdOsl03O12Oc1M3WUWE/tnOF4pkuRYbihO/qpCz60roQKhEe3yn2FRpRXa
         IpPuEnKVjfnb+t1v5apKa9dCMaaBOZ8nC+CPqYTAESnOUVyDixxXR9jAxWw+eWMes9IR
         w5iOsbza0pt0rIB+MQr+RaItmG7DEBBJXYwWJ442oK1uaKtuSradYfJ2ZM+8jQF80MIW
         uy2g==
X-Gm-Message-State: AOJu0Yyw8TD79zZ5UblulbTFA2aDcTdBkjOP7cF9s2OaGGCLotHdxolX
	goRAB6JZKqy+QcAOi8hfVxVFpVY07EKJYkXknp1kuomonteRb+m38b5AVj3461Q1VndHfXPj2ox
	VDg==
X-Google-Smtp-Source: AGHT+IGSRWf9jMvU/TzDtViOp5LXg8rQIWEJDZtRAQmAnRvU6S8IZvjXlJh7nuKM59TgEcdGyP5wOFgiCak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cecb:b0:1fa:9149:4979 with SMTP id
 d9443c01a7336-1fd7453544amr1146075ad.2.1721433085107; Fri, 19 Jul 2024
 16:51:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:51:05 -0700
In-Reply-To: <20240719235107.3023592-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719235107.3023592-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-9-seanjc@google.com>
Subject: [PATCH v2 08/10] KVM: selftests: Test x2APIC ICR reserved bits
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


