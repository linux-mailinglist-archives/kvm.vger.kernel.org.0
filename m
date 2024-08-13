Return-Path: <kvm+bounces-24040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA19B950A95
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 902A11F24034
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551AE1A2C23;
	Tue, 13 Aug 2024 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D4z3MiRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F15D1A0B0F
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723567397; cv=none; b=oX6SxByi/19gE2QPC+mouGxnvNJov6gNRdo6mEtnkLKevQn3H9YaCXKteYnj5R1pVQDzlwH7Z+3+DYWVTLYaPveUCKyogOb/1HB+1kBMGzn68/OUj5Btv34vAf25Ern7S6Z0w2j0Uin1q8ZDtRbTPQAFX+R6lY2862zXfmXWMbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723567397; c=relaxed/simple;
	bh=wp8ilGtEC5HoVPNr1Q63fyFx7A1XCnL/1USICxculdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BUYZwLPwsfguwZHUtwHdZGRvSJBzREoFfYYIq0AYg1iO6YhqSgXt1/jeWFutiYHFJWsMEweUu97JIDr1jFBFSMA4NAx2XsQq6+jMmtldNdgCTHSlXIrVVA1LA0/kXq0si5ejRHcvoAK5DQMLBelk22FSOWVxUEK3OAR4mRRJhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D4z3MiRZ; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-39b15a6bb6dso545555ab.0
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723567395; x=1724172195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mPGqkkq2aWYbtCMuKwdj8IcAE9Lnnrt5gTRInxMoxq0=;
        b=D4z3MiRZgRBJyccZgvgioIeaZ3cmrjCMQOS4nws5pEylP3Ppo+cWGGRr3Y7yaJKBTS
         KK4+W8pHBtvVdyp10VzMVU5sogJi+NnvUcV9Zgl5iXgtVm4yL+69kd25j7foC27tB8Iz
         RhaKIYriLikFbWEul2mJdfjtdD5kA4aMm5ry+BzunkdB3hmZv+N90mhzh+ccYGcbcBXy
         HSq/uJmFFULSe62uRHAHJ4GFquOY1PwuE8Hn86lOBoD/O9ib0KA/Eipj/Iu0am69BVdb
         vhlGwe3IPRu7MIhhOaCDVBOXhgHul1cKc/Kot7D8aXhAeCI9sb3C+Y725LrKaz/mIxM+
         LBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723567395; x=1724172195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mPGqkkq2aWYbtCMuKwdj8IcAE9Lnnrt5gTRInxMoxq0=;
        b=WYqpdU9QWb7GjOxoHCUyvno1fVKvxOvmX1ydWLHEoKrpz1uogtIYykjh5hPX4xl+/Q
         VR6z7xOWE1Sj060KMW432KAm1RwaMR5gGqKFYg58AEAQoqghVgNNOGHyIG1Z1l2nd6yS
         KN6NgBJrN4UX4GhyIuZJt98L2IraoMOiPUi9GywlpizofYxVmDDJS5N36UYEfprkzxPV
         2vcY0sNfcj+oSMQxIsuLhWNvxB4r/UQvVyZdPlS1ROooBy97r4KDA28dvzvNG7BvmIBB
         6TkPJ+4+r2a5pFUh5s+/qSIRuQ+SyXOLTry/jUnKiLVD61eUrRYolgi2wmOj23S/It5I
         BlcA==
X-Gm-Message-State: AOJu0Yyjo4fhVI0bjO6RWfxh0eGey7W2KHfZimo4awml4dIIQyLBC7p4
	wIHCEe/PURLkx3HMgSTgPx4aXqem7mRqTHgOK1SOPlq8dgOt/CGETRFJ1uzoSfFdnme+JpcWrUF
	aRYY8HnxAcXRpHwNECkKRbHNSiT13ttsoSq6FrkvHNSz8edE+E76wcKS0zkzFwfMG09hMNn7egx
	Xt4qefS2WE1vxednyX9HgbzsahmY6fSO6puCGG2uWoX7AaaOcwCRTnbR0=
X-Google-Smtp-Source: AGHT+IGOK7b+04+ACDC0udDbVs6jtOtkFxc+ukVGF/fKymKvDK2AbE6djZbUj+9o0USFjjugygisisFgJDSnlR9fvg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a92:ce0c:0:b0:39c:2cf2:c0f9 with SMTP
 id e9e14a558f8ab-39c48dd3987mr538985ab.3.1723567394939; Tue, 13 Aug 2024
 09:43:14 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:42:39 +0000
In-Reply-To: <20240813164244.751597-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240813164244.751597-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240813164244.751597-2-coltonlewis@google.com>
Subject: [PATCH 1/6] KVM: x86: selftests: Fix typos in macro variable use
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Without the leading underscore, these variables are referencing a
variable in the calling scope. It only worked before by accident
because all calling scopes had a variable with the right name.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 698cb36989db..0e305e43a93b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -174,7 +174,7 @@ do {										\
 
 #define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)	\
 do {										\
-	wrmsr(pmc_msr, 0);							\
+	wrmsr(_pmc_msr, 0);							\
 										\
 	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
 		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt .", FEP);	\
@@ -331,9 +331,9 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 	       expect_gp ? "#GP" : "no fault", msr, vector)			\
 
 #define GUEST_ASSERT_PMC_VALUE(insn, msr, val, expected)			\
-	__GUEST_ASSERT(val == expected_val,					\
+	__GUEST_ASSERT(val == expected,					\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
-		       msr, expected_val, val);
+		       msr, expected, val);
 
 static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
 			     uint64_t expected_val)
-- 
2.46.0.76.ge559c4bf1a-goog


