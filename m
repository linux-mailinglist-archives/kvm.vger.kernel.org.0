Return-Path: <kvm+bounces-21977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A416937E14
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7597E1C213DF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8C914A0AA;
	Fri, 19 Jul 2024 23:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cKRfBVO9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA2149E14
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432639; cv=none; b=I5FERSeVX3JTfEbLn5qsnPZ/50OVooHwKvOjYnK5YXDdEqXv/WDz49YOrfGtSLbEjbYSrzQO8jYB2XhcC3jJVWxs22yL4rQqFf3PEERTv1DiyTRkJzynVp1+4BQaBnNXGfzpOKm5ma/11n7tDU0Bvr1SFqBcpaItAyWMx5Y0NFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432639; c=relaxed/simple;
	bh=L5K4LhEvErOvub+DyS3BuApRHh5XgLwLfLGmErCpdIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BBI55JNYoM21nifnWVVRBr06PcDjEkfCRS3Wv4958kOk8HA3978HI5uoS2yenNOIXFw9ox+l0sKllHpuCMM673jvSBvCKD6rQ1TCxYp2ZSrsV+K+OHP2yny/E18yJ6jJOAwOgUXwSBawTRGCSiUbPPodBSP07wUyFP6zgDq0Sbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cKRfBVO9; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-650ab31aabdso62151687b3.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432636; x=1722037436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=szsmqea3Ly+/pHf0iLcDxQ8R3kri7Zn2BloJwbPXzbQ=;
        b=cKRfBVO9uW3KH4IWeqnJv1Q6J/rkUKH7lgTsQiOSqXHvbkCSXQGD4g0fwOwKT05jeU
         YBUO2xk1cEPW+ulo5QCgatStBgQkw5CqJUeoch4ZP0PWgohQ5VpFxpmvngbFOW6w8Aol
         O44pfnUI7xAu5LJ39PI3M1QdiKVA63wMUd2HvedKjR2evyQOKGA9ubfY2p+NSPnrpyvw
         v552avnLc7skp2ON9z/Qb0HWEw5XE+y/cK/FbMpWf5L2N7TPOP4xCfI0btsEuNu2MGZs
         bIMrXgOQ2tKd1hk2Aux213mMT7eI1Ce5K9vW19CarrzOrsR165jBBZnKT/tVMCfCyITT
         awPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432636; x=1722037436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=szsmqea3Ly+/pHf0iLcDxQ8R3kri7Zn2BloJwbPXzbQ=;
        b=fNcaDMSzEb815tHR/x1IYv70IEnfI2Iv6XP5lRBsfMxVD5E3SBKk7gGZxoSoP4oacA
         I/+GpzSmqD5tcnGnrVGZHglVSE5ae4SwKis40hDhXcHAJgkG1uMgTJ8XWhBBmuwhJ+0O
         zJYN8l8TGR7FIB5yfrr1STfOGjXHf1w0zaQghpC9USInQXC/yGReZ8ETIUWb8vW2AVHm
         T9fZk4SxQmJNHlIz6kvs3Lq1o6GJH//KxBn1q8D73s67DjdUMr8vqXPBTYh7ZBD9Pfhh
         yC8P3xCP1SN21SQuucUWKQgoFrxXlB4ToD4Z9VA10nSKeHYw8Wrv0JuOs3RlVMcbrNyV
         vgIA==
X-Gm-Message-State: AOJu0YyJIkingQkuD64GHSXtOwXgh84mqbRDP0/mk7J9A6hwL8iP5k7V
	Y2F38ewr+YrgBjtfVGo2hafBbCSxx/7Kzb6Cp9z4WJ9eT7cdfJLGwzP4M/T7pseWtfcpMGkbA3u
	0Vg==
X-Google-Smtp-Source: AGHT+IHyklNc/kciJMRQw56X5UOMRuQVOpb5WnfAPHuAp+SM9Knp643EKgohR9My7VTvqkjf450OIUMnKJ0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:804e:0:b0:e03:53a4:1a7 with SMTP id
 3f1490d57ef6-e087046cademr8377276.10.1721432636436; Fri, 19 Jul 2024 16:43:56
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:41 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-5-seanjc@google.com>
Subject: [PATCH 4/8] KVM: selftests: Open code vcpu_run() equivalent in
 guest_printf test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Open code a version of vcpu_run() in the guest_printf test in anticipation
of adding UCALL_ABORT handling to _vcpu_run().  The guest_printf test
intentionally generates asserts to verify the output, and thus needs to
bypass common assert handling.

Open code a helper in the guest_printf test, as it's not expected that any
other test would want to skip _only_ the UCALL_ABORT handling.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_print_test.c  | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 8092c2d0f5d6..bcf582852db9 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -107,6 +107,21 @@ static void ucall_abort(const char *assert_msg, const char *expected_assert_msg)
 		    expected_assert_msg, &assert_msg[offset]);
 }
 
+/*
+ * Open code vcpu_run(), sans the UCALL_ABORT handling, so that intentional
+ * guest asserts guest can be verified instead of being reported as failures.
+ */
+static void do_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	do {
+		r = __vcpu_run(vcpu);
+	} while (r == -1 && errno == EINTR);
+
+	TEST_ASSERT(!r, KVM_IOCTL_ERROR(KVM_RUN, r));
+}
+
 static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 		     const char *expected_assert)
 {
@@ -114,7 +129,7 @@ static void run_test(struct kvm_vcpu *vcpu, const char *expected_printf,
 	struct ucall uc;
 
 	while (1) {
-		vcpu_run(vcpu);
+		do_vcpu_run(vcpu);
 
 		TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
 			    "Unexpected exit reason: %u (%s),",
@@ -159,7 +174,7 @@ static void test_limits(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_limits);
 	run = vcpu->run;
-	vcpu_run(vcpu);
+	do_vcpu_run(vcpu);
 
 	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
 		    "Unexpected exit reason: %u (%s),",
-- 
2.45.2.1089.g2a221341d9-goog


