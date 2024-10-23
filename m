Return-Path: <kvm+bounces-29564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BCB9ACEBB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:27:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08F5AB24366
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 078CB1CB53D;
	Wed, 23 Oct 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tEQDW2TP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3E91C8FB5
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697208; cv=none; b=W9l3AvEi2ZIYMExdnXvmDCBINPEP48N/g7jqDOrgKnOU3OZtw/iQF+1KTBsI2CYIFQqA480hEh/ywWl1fpTMfkexfYjunS4u0hHVjF+R+OlstGd9vf+EGm11j2ZVTfNbe6QOPeXX4JZVJpcmV6AtDf6+BQUBwrqTr6XZipIrt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697208; c=relaxed/simple;
	bh=sTMEe8hKVyhG4n3/J0S0bVeWZJkoFNBIjGAvrfLzml8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OL9uMRDiGag1wyRPNBp9eAMlx26qJJxRuZIBWUCu2E4Dl8A7jK/8grnMzAVW2goAEOlqmwj25X8+jzCkPs+cuKjP82+3JuUmMjdTV1gVbXL5q0zRA5tmH2/g2IDk4uw6N8WM54vG20XXbpuhLQEYHBbKgaYWD6qYjVyH42uUcL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tEQDW2TP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e35199eb2bso129953787b3.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697205; x=1730302005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NioyoNb1tbeyUGY4RlitjUeF9A4E3KRPhc6ahZCNVQ=;
        b=tEQDW2TP4aSlWq5iJGF0obfpW9K++suPbFYXR9gRcqeoXCNrINNmWcQAwiUErUHrhe
         EIQ4Q6L7hkC1Lpi1ZDYUr2jcNgeIENl8cX60FUD6uwSxaGGh6Q3sDyqoW5Ntl2LHT0ro
         0FBr4Tkgmv4riw3M7uh54fA7Rwz/I3JdXpDkzmriMSnjFBEGYfC9z+NzykFXC5qRDh7s
         NvVt3bXraKyVCzUFpXelc73Q7EliBIJ+mzXCN5isJ1DqSdCzOntiawjk9NlN0LGoBGUs
         yCbqSTvwxPnKkpVWkNgJgnfpSsXkb1+5mxKivDQlPkLvXqorouaqK1yjThx5wdVBxZSR
         3P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697205; x=1730302005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NioyoNb1tbeyUGY4RlitjUeF9A4E3KRPhc6ahZCNVQ=;
        b=B8zjfedPHcdVbPB3zLhF0YnGKrr4JeOriyQRAA1nNvjWhjKJHuKQsJY4Kcq9524Wv8
         2nmbwK3yQCdI1wpmDKpo54jBEAx9eHcmbUmWEWokfAhDIAsCVAzCINyA1M9l00D53C9i
         KNZi6LLzMsJ1wN9dJhmGuUX2LsvN50D2sPdcepRdPT2/LYkblKleWx0fccmXz7U0/294
         EL6WuOSvnNIwpV0gmgpCv8jYYLImZTWxv0eu4/j2S4LjRD6bWL6zjEtOR8h0/WWAQzKD
         gZAie0OVF2c2kDvStb2oynxAXn6gIiSvmhzNyr3n5wQ2HYCt0u2m/Jf56QiQoQovXZAl
         H4eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTC7EmGs6/oJXZQW9/o3usniFlhU4Mat2S9qLmdgNFIQ5xuzcZHhQ52C/kQQT2AbrJ7gM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDonuTO8c7MtaWf0i167ERqbG9PHLs4t19miHYcDmdPkVz8Th5
	9/ghOrY/F7rGHkU3xmYkLnOlW1GcwPNU5eyjrgDV8BafnmIUdG9pNmObmXpaVAKqoalKN5EEQ6f
	zHXGrfw==
X-Google-Smtp-Source: AGHT+IE9OyKSIQFj5g+9JOMt/US00gq7iSxNgRTSGWr8GfQo9rufdELdBzRinCot5ZkBU1YALlbhI9gWX/bZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a5b:947:0:b0:e28:f454:7de5 with SMTP id
 3f1490d57ef6-e2e3a6b78d6mr6103276.6.1729697205144; Wed, 23 Oct 2024 08:26:45
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:37 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-4-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 3/4] arm: fpu: Add '.arch_extension fp' to
 fpu macros
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since the tests are built with '-mgeneral-regs-only', clang-18 tends to
push 'q' registers out of the scope and hence, the following error is
observed:

arm/fpu.c:281:3: error: instruction requires: fp-armv8
  281 |                 fpu_reg_write(*indata);
      |                 ^
arm/fpu.c:74:15: note: expanded from macro 'fpu_reg_write'
   74 |         asm volatile("ldp q0, q1, [%0], #32\n\t"        \
      |                      ^
<inline asm>:1:2: note: instantiated into assembly here
    1 |         ldp q0, q1, [x8], #32
      |         ^

Hence, explicitly add fp support where these registers are used.

Reported-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index 587b6ea3..f327a349 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -38,7 +38,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_read(val)				\
 ({							\
 	uint64_t *__val = (val);			\
-	asm volatile("stp q0, q1, [%0], #32\n\t"	\
+	asm volatile(".arch_extension fp\n"		\
+		     "stp q0, q1, [%0], #32\n\t"	\
 		     "stp q2, q3, [%0], #32\n\t"	\
 		     "stp q4, q5, [%0], #32\n\t"	\
 		     "stp q6, q7, [%0], #32\n\t"	\
@@ -71,7 +72,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_write(val)				\
 do {							\
 	uint64_t *__val = (val);			\
-	asm volatile("ldp q0, q1, [%0], #32\n\t"	\
+	asm volatile(".arch_extension fp\n"		\
+		     "ldp q0, q1, [%0], #32\n\t"	\
 		     "ldp q2, q3, [%0], #32\n\t"	\
 		     "ldp q4, q5, [%0], #32\n\t"	\
 		     "ldp q6, q7, [%0], #32\n\t"	\
-- 
2.47.0.105.g07ac214952-goog


