Return-Path: <kvm+bounces-11855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 964AB87C65C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:33:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C714281E6A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46AAE23758;
	Thu, 14 Mar 2024 23:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YKpTtA5h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D71B940
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458813; cv=none; b=kTiOH5zrqsYMaIRcBl9A7LPteXcMGunJKEBYpqMsPWR/t8j6Crd8VX4tsZOR1bGbILTrZef1tod+d+Oq1Owb43EJFJxygnuzqM+sYZFpn8OBbFtwLooOmvR/FJxDFgXEorCnh+9z1JkPnh7IVn7UKYIGJuoZKx4COrDeu22Us5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458813; c=relaxed/simple;
	bh=meFKVgZcplsrdf4nThtnD2hQo2z4gltSGTp4DLCnmJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b4idMfT6aSG4WdYv1qAN9otXAM1X/D0nJw+N7LfFP48irBefkxGilLKL5z0ikix2IYC8qi9Klbu5dYKEfTHGH50a6W7Y7iiaVof5dt2ijroiEEXUeELHH6Cv6aF8yaEjbBM5KYZaRM0nWuiJG8nrHDBBiYKyQ+HTfYuGinp8XA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YKpTtA5h; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a54004e9fso29376057b3.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458811; x=1711063611; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oB3ZfcSJ5G1gMIeNmqomMwFWPYu8/DXA5zj+kntGd24=;
        b=YKpTtA5hr+jr+CBQWoKSxidJLely1oaPaScPz7o7y0zxRdBggmjFrU1JivphrW9UTa
         PHkGjxx/pqZin797ThccwJEMwy7VI28g19gzfaCML5CLa5nP49IEWbiZAMfwhvxpQqlZ
         f5pkTmB03wShEmrGl7BmxQSEME7CcBrVj55TWhZgHHtH3Xc/55nizKivnjC/Zbz52LoN
         KLQXrPVhSlzEtDAs7wvNRTkiBT4EJ4Udop3BxjwXWjCTtE5n2pT+7prbWT5bS+utu4wc
         nmgU7lp8jtjZoOf+Ic+c6BB2YHnktVJ5mlj2GAEM7qIz+HGiKK5gmNMjYFLjNe3bA+/s
         IuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458811; x=1711063611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oB3ZfcSJ5G1gMIeNmqomMwFWPYu8/DXA5zj+kntGd24=;
        b=UDvU9ohjNl1FSJ6bSxBEKVuJtvNN1JH2mCgWOFpOHCAOTekBzZkklKwWfvwiZvO6WF
         zOvKWXnYqiQMEgxmGzBPV3LuOui4EEM+v9SidAu8ktu6BorX0EkTzDwb3oqEQwgyVjBf
         87QsypJQFbDNLU/Jf/pwzj6bVDwo/qHS83qO2awPEb4+R+V9ua/YjnHJpfwvdPJmoj8P
         dg7Np2qwDzv+TrPcriRvJe32arlyvdgpIB8wMeCr5TFdgcj5vcLf9Ff9Pl1voYWy0U2J
         UR0VbzeYTy/J7s7Z4UI8ZVIk7pOU6ywTmzo2c2w4ir7lklnqQBgQXs7fItijXTPED5um
         Hg1w==
X-Forwarded-Encrypted: i=1; AJvYcCVwNDC4EHd5F5vWinQFoCZiYf/mJxUvf01VflWp9uVz672StDf644Lb/b/WBuOHW8/aq3Hripxbuk9KAqCTknX/qPfE
X-Gm-Message-State: AOJu0YwQn4qbCgxsBUPDTdcUnln+1J+QQ6xed0oEF07XEFHsnILyGIgB
	Lo8sna4V9sDBX2rJJD3B0iuZ6h8TTF/cueBYDxsZKU09Xv183gPV1UQuyVj+50DBR5mCmpDSsd1
	lfw==
X-Google-Smtp-Source: AGHT+IHtBiTnO989+qzsWd/+jqel2tzrmASDdXlpQSt9dAnbWaw8Q3AQpPaqLMF1m7pFqRCnpY9R0RVtBJU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e288:0:b0:60a:56c2:a61f with SMTP id
 l130-20020a0de288000000b0060a56c2a61fmr797989ywe.8.1710458810918; Thu, 14 Mar
 2024 16:26:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:25 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-7-seanjc@google.com>
Subject: [PATCH 06/18] KVM: selftests: Rework platform_info_test to actually
 verify #GP
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

Rework platform_info_test to actually handle and verify the expected #GP
on RDMSR when the associated KVM capability is disabled.  Currently, the
test _deliberately_ doesn't handle the #GP, and instead lets it escalated
to a triple fault shutdown.

In addition to verifying that KVM generates the correct fault, handling
the #GP will be necessary (without even more shenanigans) when a future
change to the core KVM selftests library configures the IDT and exception
handlers by default (the test subtly relies on the IDT limit being '0').

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/platform_info_test.c | 66 +++++++++----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/platform_info_test.c b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
index cdad7e2124c8..6300bb70f028 100644
--- a/tools/testing/selftests/kvm/x86_64/platform_info_test.c
+++ b/tools/testing/selftests/kvm/x86_64/platform_info_test.c
@@ -26,40 +26,18 @@
 static void guest_code(void)
 {
 	uint64_t msr_platform_info;
+	uint8_t vector;
 
-	for (;;) {
-		msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
-		GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
-				MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-		GUEST_SYNC(0);
-		asm volatile ("inc %r11");
-	}
-}
+	GUEST_SYNC(true);
+	msr_platform_info = rdmsr(MSR_PLATFORM_INFO);
+	GUEST_ASSERT_EQ(msr_platform_info & MSR_PLATFORM_INFO_MAX_TURBO_RATIO,
+			MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
 
-static void test_msr_platform_info_enabled(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
+	GUEST_SYNC(false);
+	vector = rdmsr_safe(MSR_PLATFORM_INFO, &msr_platform_info);
+	GUEST_ASSERT_EQ(vector, GP_VECTOR);
 
-	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, true);
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		break;
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-	default:
-		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
-		break;
-	}
-}
-
-static void test_msr_platform_info_disabled(struct kvm_vcpu *vcpu)
-{
-	vm_enable_cap(vcpu->vm, KVM_CAP_MSR_PLATFORM_INFO, false);
-	vcpu_run(vcpu);
-	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
+	GUEST_DONE();
 }
 
 int main(int argc, char *argv[])
@@ -67,16 +45,38 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	uint64_t msr_platform_info;
+	struct ucall uc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_MSR_PLATFORM_INFO));
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
 	msr_platform_info = vcpu_get_msr(vcpu, MSR_PLATFORM_INFO);
 	vcpu_set_msr(vcpu, MSR_PLATFORM_INFO,
 		     msr_platform_info | MSR_PLATFORM_INFO_MAX_TURBO_RATIO);
-	test_msr_platform_info_enabled(vcpu);
-	test_msr_platform_info_disabled(vcpu);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			vm_enable_cap(vm, KVM_CAP_MSR_PLATFORM_INFO, uc.args[1]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+			break;
+		}
+	}
+
+done:
 	vcpu_set_msr(vcpu, MSR_PLATFORM_INFO, msr_platform_info);
 
 	kvm_vm_free(vm);
-- 
2.44.0.291.gc1ea87d7ee-goog


