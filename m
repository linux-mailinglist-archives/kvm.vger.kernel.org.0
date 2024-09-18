Return-Path: <kvm+bounces-27095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F76A97C10B
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 22:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0669283B92
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 20:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454FC1CB530;
	Wed, 18 Sep 2024 20:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xbc51nyV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2A1CA6AC
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726692842; cv=none; b=kPbOWnaanjXHLTB8r0EjNyj11rUk6IKjIIsDicMwIl1m1hAdjEnrHa6FAyquZWzrDXFrfXob9MdmIt+nYG0s1o+y6Jd3dEKvSWui+oU5Ic0EsG6u3+RHJ+EOt9T8cnNY7bUHY1/TPLEc8PKY6GBU6ZIeNVdi/mY7uneswIwkV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726692842; c=relaxed/simple;
	bh=7LFbPeFjkQq1UTJ8lEzVj85jrHSO5Ur9v/Y+l3mM/6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bqFAgWNNITZIHs5e6gexRX1u07LKoXMpdp97+UF1trfThcLbIoP7UISS9Tg6a2R1/S5r2KFaLhcS6hou5ISsAsg/gH2j4rvlgaz0623mNd0zqupvkQZ+rmmOC1oDi7Av/s52JfM1a4G4piLqPABPYLAlIeDTjOh5HVmha7U++lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xbc51nyV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159fb161fso331456276.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726692840; x=1727297640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8rJ/KpP7ZLjH/baI+Q4VTgii8fM80xVyJoccolaGcXA=;
        b=xbc51nyVoPoBM/91O6hn88PttEqptlsdCYd3AMcHMR8EGdeJ7zzkIHW1WTmB5ZjddV
         D0i3j5QPELETkSEcseB9Lp5qVvPTPK1lFfIhdzItH+ntVwq7WAXOgw5ud42eF0EPhWnJ
         kyD6LnZETLcOosC8wh8fUilEswNGEfRYeYh/AeULBE7dvRKdPZONz3kNs6umDYMcBMAG
         jKVgtqrOkODH77O5ZWcmVfs555spyK6r60j+PiuNlMVBaP2IRJVvTBLmlDkUd1qV10Fi
         DqWILT8QrwXqnccoyPwi3/HlohoAvyu1Z8h4rstQC3Xtc3O3qncV9/xiBIGTrDEV8y0d
         IEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726692840; x=1727297640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rJ/KpP7ZLjH/baI+Q4VTgii8fM80xVyJoccolaGcXA=;
        b=TSZz/ZpLVSH4VOkvqEiG8J2zJuNtDxAop2XhEPy7OQ1ihNeMhBCXBqHadR//mo/cbj
         0nVk+9+cHKd37v99IaqUcmUyDwfIUOaoDp2VSrTk4F8/sUViFiFuPtBb8KbQvAtfp/LU
         YAHFZZXGQOlpQZjqMN6GLCiALz//KHplbGg5kiU9ZLrgUWMpSD+muIVk8CAj622YzCSy
         ubVmw7Tcrn0IN+gsLTC25AxNeHtymCYARa4C4NaKMNQrctq2JrNeEQHV4F+vuLID6EBe
         nI2GTEW7XsoZBPysH4b+AI5/nVF0SxH7xmsvkvtRcF284WZMS7F74IIIZmtIged8vUU8
         ocaw==
X-Gm-Message-State: AOJu0Yz3mtu+sj4t/Nytz0N9gNk9dp+coYkYcj+TIGq1wekJkoOqXJbf
	7XUkMnJnTAFfHsImEbdXsoGCbJ8PInUbszG03+A5UmkZuUGFa+5UAt2pqcb+zebkSFu8Re1xR7+
	yMKznKx7cOJ/1W1FBSSSPsKWAA8bNvaghjC7SOUxMWuNz4JuMgjGtchE/0nb+J+BUnjRNEZ73U8
	31AjSrgIqqISiDnHwWbV/8fj93S9uuB33dhmxb3CxD6dG+/gykdD2gAM0=
X-Google-Smtp-Source: AGHT+IE19c7uHgFQDSF5lDBOr6e84MO4hTZGPdwklurCeZKa3gXSTOztaJSR5dLNDju6LDGeGsq93ws0AB9ttpRl9Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a25:f304:0:b0:e11:7105:956a with SMTP
 id 3f1490d57ef6-e1d9db9c23fmr34188276.3.1726692839006; Wed, 18 Sep 2024
 13:53:59 -0700 (PDT)
Date: Wed, 18 Sep 2024 20:53:14 +0000
In-Reply-To: <20240918205319.3517569-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240918205319.3517569-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240918205319.3517569-2-coltonlewis@google.com>
Subject: [PATCH v2 1/6] KVM: x86: selftests: Fix typos in macro variable use
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

Fixes: cd34fd8c758e ("KVM: selftests: Test PMC virtualization with forced emulation")
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
2.46.0.662.g92d0881bb0-goog


