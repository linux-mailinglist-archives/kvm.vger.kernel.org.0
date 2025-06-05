Return-Path: <kvm+bounces-48597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AF5ACF7CC
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05485189BD89
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B0527EC76;
	Thu,  5 Jun 2025 19:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSyHtYTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F107C27C84C
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151368; cv=none; b=ZboxpPxIlV2jvKPcjkZilqZPyUYCrz95fTGl6dZG+Q6OaMel6cV4D+i37ZFMG1HTNXtm49D/HjvJayif5ju3OcI/P8pNixini1u1mWOZKF3n4TJIjZgafndSOw/xAAZTQfgifg2QiG2ACFErhkSIcVmdMjuWnkYEl01YTfVqAkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151368; c=relaxed/simple;
	bh=OTmgOlEFTYaA256fhbZkK4rff/f04Hq4BqmnrSkDHnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MLkPYgGXOuu+DG/d3iu1/wiJ8XQkz7qxu+BvOAPSXB2MX6Nxr3hkvv6eZWrqpQQodk9uVAocKqqzE0dX78HwrBpwUw0AueZfyClR/RmbPecWColepQwHb6AiUvFYKozYo/4vAAX/ONEoaHzYDHTBC5KCmErgz14elzmsPWbcnWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSyHtYTT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2356ce66d7cso17250765ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151366; x=1749756166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5F4y4ylrG/DcBmzKvLQRmG/aB99eZMm8yUPfcq3x7lg=;
        b=VSyHtYTTRLo45S2kVM3cFY8xytYgG8WJiZxV60q7Sd9ARVgDO8j3xnEedskHPmn5hu
         HbUYtMuHn3NdA3bR8XHmkFI4q3BvLol6bXwZQ0Y67H9gGYV0ubdUXVvxDj+Du66Mp3Mn
         ewspcqCtSIeZZ15ZyqePgJXTsezeVHSxv64b5LMpsA2dPUg2um7OOjPVwq7qMvRQLG7N
         9hNoKjcQggCaIoh76naHEj5qaTeUgfEKw3MzwpvhayimlMeuVsS8dbPU8ZPCgSzbJ+ZA
         ANf4lX97afZdJthboZYFl2yEQl1JnlxUkJsMz9OuSnjBic25yKsdQhz+WPKxphvnXvLB
         0ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151366; x=1749756166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5F4y4ylrG/DcBmzKvLQRmG/aB99eZMm8yUPfcq3x7lg=;
        b=rpgZQaBFpBgpej3HLgMTPOPoTgHurx585QdGFnqJgefHGlgyDDRlnYqsBLXCNqaIqy
         wy2htL5OXpDSF5fnPN7seJczy+DHD1S1oRDVUEDSTdM2HFokBYGn9IGDQb3Fd0Yu4+t6
         G6zceZAfMKwQpPKijPECK3F4Wj/8Tct7khZrpHhr+PlRlBjKED4UckcSn6hngPD/BQoU
         0pm7gz1wgvDO1D+i6G/e4lzDqvCLHgG771e+TjzryEXOXHp1ltLsnz+ccjFKI0omFfAC
         niW5DWbnyB6vyX9XoZqUgM4ahjR2Yhqj5E4xTjipLWN7/M+l3y4r6GxGmU78q3vTzLda
         3W5Q==
X-Gm-Message-State: AOJu0YzJUu3Mj4TcIRZqN7Q/OX+iu3iWXWDuihOGH//C8m/2mAIRJXA4
	vF/puD5oZVZF56hdMwdcYtNMmaF8BUYzLxQDr8EMHh8iht7WDQFZsm2QlMY8b0B6DsA2L26Pwd6
	ps+rMqQ==
X-Google-Smtp-Source: AGHT+IGo8Hk4MijQuym1ciHA9a+XdH3ofiNyW0Vcju/hdvaHpVcU4rL7msw1LM27hEkJuZuEr4f0RE2BwN8=
X-Received: from plbju5.prod.google.com ([2002:a17:903:4285:b0:234:45eb:5e18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5ca:b0:235:f18f:2924
 with SMTP id d9443c01a7336-23601d0705cmr9590135ad.15.1749151366266; Thu, 05
 Jun 2025 12:22:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:26 -0700
In-Reply-To: <20250605192226.532654-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192226.532654-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 8/8] x86: nSVM: Verify L1 and L2 see same
 MSR value when interception is disabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the MSR interception test to verify that L1 and L2 get the same
value on RDMSR when interception of the MSR is disabled in vmcb12's MSRPM.

Skip TSC for obvious reasons.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index a89a234e..80d5aeb1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -350,7 +350,7 @@ static int get_msrpm_bit_nr(u32 msr)
 
 static void __test_msr_intercept(struct svm_test *test)
 {
-	u64 val, arb_val = 0xef8056791234abcd; /* Arbitrary value */
+	u64 val, exp, arb_val = 0xef8056791234abcd; /* Arbitrary value */
 	int vector;
 	u32 msr;
 
@@ -417,6 +417,8 @@ static void __test_msr_intercept(struct svm_test *test)
 			continue;
 		}
 
+		exp = test->scratch;
+
 		/*
 		 * Verify that disabling interception for MSRs within an MSRPM
 		 * range behaves as expected.  Simply eat exceptions, the goal
@@ -428,6 +430,14 @@ static void __test_msr_intercept(struct svm_test *test)
 			report_fail("RDMSR 0x%x, Wanted -1 (no intercept), got 0x%lx",
 				    msr, test->scratch);
 
+		/*
+		 * Verify L1 and L2 see the same MSR value.  Skip TSC to avoid
+		 * false failures, as it's constantly changing.
+		 */
+		if (val != exp && msr != MSR_IA32_TSC)
+			report_fail("RDMSR 0x%x, wanted val '0%lx', got val '0x%lx'",
+				    msr, exp, val);
+
 		test->scratch = BIT_ULL(34) | msr;
 		vmmcall();
 
@@ -497,6 +507,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 		case 2:
 			restore_msrpm_bit(bit_nr + 1, all_set);
 			__clear_bit(bit_nr, msr_bitmap);
+			(void)rdmsr_safe(msr, &test->scratch);
 			return false;
 		case 4:
 			restore_msrpm_bit(bit_nr, all_set);
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


