Return-Path: <kvm+bounces-11854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C69C87C65A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C81B6B22B61
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1530E1BC23;
	Thu, 14 Mar 2024 23:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEorJR7P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90090182D8
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458811; cv=none; b=hne+IoCJ00dC0sNXszeePBlT82PEvhc/Xwf0jVbHv96JUd+Kg6m2oDW+CqDiAKQ6rkwqrbwmFH8bZjPPCABKBUW5ARlwajRxfXZXkUAvTWdnJAVpjYi8O+r0sMeVMs9p4W6ozxggUKmSdh5h5fok+MRTK9UuHWtZA9JiJBgMVDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458811; c=relaxed/simple;
	bh=kL1anMirud9R6581IlVg1+Shvk0whf3zxCiXUgx5dcE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LRITzfMeFaXf/Dyo1EfLFzcDYoGvXX6Zogp+WisWkEnG+AYFFPMcq0JrIJpL3Mnz+3FVHodaQjKYe16Ap1m4Y2Wthp2uCA4Hxt6u9BUPIzECcoKSBF12Q+2281a5qzM1K8lsWNE4ULKaeFVDGYRyfHycOmrUhOekptKd3YjqGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tEorJR7P; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6f49e1d2fso365275b3a.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458809; x=1711063609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k1ceQ+0+7x0dggVxu3pfjgACx/CpWN/VJ25BN1jj24Q=;
        b=tEorJR7Pk1777OeprdZbHu64T980PUw6+gbCBdyq6AI8mEqhZk+IIW7sv8D/hGtICO
         WfsWa2vNGz2yrQS1j4tnw5KU2d/uCBwyAElNJzLhXJ0mDgT+Pcc5YWMicGDLCqogAltV
         BJQaQmMIrOXe3mFalISbKFEthhyY3Y2i9hb4RxNP0HjNv4fW9d8yDpTH/1Vgngd5ibR5
         U0E1T8peGUELMZmG3zKZ4QkeEChbtoDhamuj7k1FO6RT7MhqHn31DydpBm06AjprUonS
         mWryYCeoNBPzsNla5hqVyRzkQEkD8KgkS/J0gjq/fmlrXSKlSWqEuZuMKnJHF1Dj3AcE
         hGXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458809; x=1711063609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k1ceQ+0+7x0dggVxu3pfjgACx/CpWN/VJ25BN1jj24Q=;
        b=OdwwceK67TpWeGEsVxOAc5nQlbxgiv76S2L7uf+VTEtF72aS5AynhKiDSTQbyX6ow2
         3lyEs2wNfYBUbGNzt3qCoEG1t+Z2Y16aDw374sy4jabZrO5dJlZG5jOYybjr0t9rreBl
         OdjWSfdliUOU/VY8P5NnAZkbgw3HYTRsNm59VIPk2SVc5q2750qJPegyCVpG4o4giOeI
         pliRgUMu4srZlsUvAvGOknKQ3oxmIWu4qS5g1nEEcSr8EjPopCD5C46Fnb5b0uQRJ4yh
         Y2w1a0XUJwIEi39+E+aDd2xTYMrAUXR3veJGh9KTJXtQNUVtAVlgVy8uU9RsbxdKZliq
         3MJA==
X-Forwarded-Encrypted: i=1; AJvYcCUrKAKD9H+MnIdHvV2nAZwBPzY+2y+UHNd9H04eox9xI1px8nZFzk5lLtMjAJJ6PYr97j251bgTIaR58B9MeuhQ9KMx
X-Gm-Message-State: AOJu0YzhfgJlxxaFwGgCTLVQcxaA1+bHDj/Q5aY23s57YmjAlxlbv+7W
	qGEVYE+Omett7ILOp4Y6qY9wimIkyvzChK3pa03o3FYcwo7Ncz1k5qKB/rQSAAmRuLy/4SAsPwI
	Qug==
X-Google-Smtp-Source: AGHT+IFa6Xo5alB77JWBKkmfaT2866W5+uuYd+R94MhsO58PTc0FssqvQ3Br5ekzS9Hb9uDd/sllma8cTz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23c6:b0:6e6:c374:f104 with SMTP id
 g6-20020a056a0023c600b006e6c374f104mr152102pfc.0.1710458808854; Thu, 14 Mar
 2024 16:26:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:24 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-6-seanjc@google.com>
Subject: [PATCH 05/18] KVM: selftests: Move platform_info_test's main assert
 into guest code
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

As a first step toward gracefully handling the expected #GP on RDMSR in
platform_info_test, move the test's assert on the non-faulting RDMSR
result into the guest itself.  This will allow using a unified flow for
the host userspace side of things.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index 87011965dc41..cdad7e2124c8 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -29,7 +29,9 @@ static void guest_code(void)
 
 	for (;;) {
 		msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
-		GUEST_SYNC(msr_platform_info);
+		GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
+				MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
+		GUEST_SYNC(0);
 		asm volatile ("inc %r11");
 	}
 }
@@ -42,13 +44,15 @@ static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
 	vcpu_run(vcpu);
 	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
-	get_ucall(vcpu, &uc);
-	TEST_ASSERT(uc.cmd == UCALL_SYNC,
-			"Received ucall other than UCALL_SYNC: %lu", uc.cmd);
-	TEST_ASSERT((uc.args[1] & MSR_PLATFORM_INFO_MAX_TURBO_RATIO) ==
-		MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
-		"Expected MSR_PLATFORM_INFO to have max turbo ratio mask: %i.",
-		MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	default:
+		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+		break;
+	}
 }
 
 static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
-- 
2.44.0.291.gc1ea87d7ee-goog


