Return-Path: <kvm+bounces-29565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1059ACEBC
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 652901C213B3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B1B1CC174;
	Wed, 23 Oct 2024 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u2ea6r3d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838D1CACE8
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697209; cv=none; b=KvM/P7VkJb0OQpZEr/VXMf1s9PwXuoBlcM47MUuSpwAZ+/gwQuGlZGM7rvTWR5UbIP7bvnIW7lP0sVs8ns94EPYyqRUEMBZOqLZW7COmIAsxQ5mt3OLnGmyEdoGeVT40Jk5Nm1L4FCMuV3Jndi4DpZI90YN4DIeozvdu6uT0f5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697209; c=relaxed/simple;
	bh=B5fYkslRkwaBuwyV1YpAJJzIGleZ/3nKyW4XhZgaP44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mKlDnEmVVsY3eUZK+w2tmtFmRXhqETp1SpXtMybFkTQ0xNAuHd0JjISrTuUNwhAvemGuaRqYsc7q9TQkGKu5e5iiVhepwyWa1JcQtsA7bISCZtjrWNzmYbCphpdFu5G50Gbrb+Z5znHU+AIsRNCtYnsiO9QGsdd4YZAAS3Px0zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u2ea6r3d; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e24a31ad88aso10082349276.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697207; x=1730302007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2EE3sVxYqIJ1dH+QTH0uydlcXtt1ReqMB1Nu0t+juU=;
        b=u2ea6r3d2DUU5+bl/sZVLf2mxi4D/rLDtSW5oIpRnXZb/HE/6PCPVq9h2iNazmbHQt
         oXU8vIRfe5neBGFo32fAMSkNM0Mb17GrEAwcENC0Hl3j7pO6z012RFw+WuuJ3P4uS4+b
         WUEpkKYcOUd7u6KBgAfofZdt8skvAeLRlspJAmGEtZwXjh6WV6G6TwfupgDMdKTlw3ZJ
         +DljepbT8XN3emQglF5nQSPxF801+XKvQ/jXBNxwOBO9HVfrLTlbZmwfNtacsxTaPEwm
         2JEpDGCi9PZGt0W/RfH/Ssk2Iv8TnZ4GEHAYxDKNTR8BH6O7LFVcO1qjzdPRkaD9cSOU
         F9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697207; x=1730302007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2EE3sVxYqIJ1dH+QTH0uydlcXtt1ReqMB1Nu0t+juU=;
        b=Gv1y7VWm5IAwQ2ZF1H3cu39anrd2toIm3OYhrIRRanl+HNm/xilmqQRrdL21v5iV0C
         kJ8OheoIkq70S2jZJdbGY3RNNDD6xIfUfbybZVbhLgLsoLH/t5N3Uw6ZGrG8wX275P8u
         0IvGG9GsNUIzYFowdXTfT+WDp7bTYCk/EopXmT/RyF4r6ivtytppmYfrvSVG3SnXb5Zm
         +lot8nyuYeJLJSi8Pkzwnt6f+Q/X3RDahkCfFSyrkfPv48hF2oACawXc67xSH8IZhXMN
         fhMcR9A59kmGqSA6ke6pryu+/jjE6r0Jys7FYCWk5mphBaEtAZ3txS/vJ5cZSnLNYmF4
         k3dg==
X-Forwarded-Encrypted: i=1; AJvYcCW0xtP4AR+Osal/FEYZpATzwAgBcn3TQBiI9aCp5Yztv1N7GulzSOD1v3M5qNGed3IPgQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YypHQaD+Aqk/82DAFA+vxBPn/aS9YSMIeM/g/BcQcSFiCOnfiWn
	WF+Sk5bMpw7onD6M0IFPT0OzzoiP3CmwYWfwqUOer9SyYRYuYMvLgYvdi0g8yJ8ihYsfeMDc0gv
	4AtJ3bw==
X-Google-Smtp-Source: AGHT+IFIvoDWzY92c7Ql5MqDK4/LO8cFIPrnyxqxIgb86cVrW0eQyRyYu3QqngJF51cWPwSpHNgspMn0AOrE
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:df45:0:b0:e28:e510:6ab1 with SMTP id
 3f1490d57ef6-e2e3a6c91cemr1496276.8.1729697206388; Wed, 23 Oct 2024 08:26:46
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:38 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-5-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: fpu: Fix the input/output args for
 inline asm in fpu.c
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The macros fpu_reg_{read,write} post-increment the '__val'
pointer register as a part of 'stp' and 'ldp' instructions.
As a result, mark it with "+r" for the compiler to treat it
as read-write operand.

On the contrary, sve_reg_read() never updates the value of the
pointer/register. Hence, mark this as "r" for the compiler to
treat it as read-only operand.

Without these adjustments, the compiler can potentially perform
optimizations over the registers holding the pointers that could
lead to data aborts.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index f327a349..f44ed82a 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -55,7 +55,7 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q26, q27, [%0], #32\n\t"	\
 		     "stp q28, q29, [%0], #32\n\t"	\
 		     "stp q30, q31, [%0], #32\n\t"	\
-		     : "=r" (__val)			\
+		     : "+r" (__val)			\
 		     :					\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
@@ -89,8 +89,8 @@ do {							\
 		     "ldp q26, q27, [%0], #32\n\t"	\
 		     "ldp q28, q29, [%0], #32\n\t"	\
 		     "ldp q30, q31, [%0], #32\n\t"	\
+		     : "+r" (__val)			\
 		     :					\
-		     : "r" (__val)			\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
 			"v8", "v9", "v10", "v11",	\
@@ -140,8 +140,8 @@ do {							\
 		     "str z29, [%0, #29, MUL VL]\n"	\
 		     "str z30, [%0, #30, MUL VL]\n"	\
 		     "str z31, [%0, #31, MUL VL]\n"	\
-		     : "=r" (__val)			\
 		     :					\
+		     : "r" (__val)			\
 		     : "z0", "z1", "z2", "z3",		\
 			"z4", "z5", "z6", "z7",		\
 			"z8", "z9", "z10", "z11",	\
-- 
2.47.0.105.g07ac214952-goog


