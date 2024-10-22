Return-Path: <kvm+bounces-29321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6079A951E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 817AB282C62
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B4213AA35;
	Tue, 22 Oct 2024 00:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2XneRuG7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1AA12B176
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558041; cv=none; b=Fuhgug/4EteAWkxKz2nCXetR6LmMLMFx5Ur3yH0ysqVCwKA8Q5WqlMdIEMq1kZYHmp6cLAItUp+riH+3RSiJ6otw+Zi8lyHKpl1jCXBAuByJzMnl12412+OZ4khdDZ7tiQxXoKnEaBeDIy4Gujwb+KTVNUYPxxv+P+rYH5YJEsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558041; c=relaxed/simple;
	bh=/ZZM1+dJhOvu0mr/UtOV9hTqZs4pXxjwQKKx0hCIUpU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GLnc6tncoH2qL+DRqlIypu1yi8VSwnscLhdaCrfHou/15MlFjy1v3ce+W6KLFoQnLayvu8O9SkvDlgIn6B+EvUG7oeLXTPAZYj+EO+190Jzdq00PfcUyOWp6W50HR9NkaUnQq0JW7RYdpl74nDvvYpsssPegfdVhc/ATkE8TFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2XneRuG7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3d6713619so90437817b3.2
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558039; x=1730162839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=60wgcSLTXVxTzPUjoeX/E6FIWkDuwYegYI4IrChLCKo=;
        b=2XneRuG77wAX6zrNp8ejfDvvLyhrzvmReF2/azXsWlbn2+Sc6Fr9evwo5vQfSHH2ch
         ie2sVi321yxyA3Gbl0RhzlMg8PHPMA2SdSWQEBsaRUckn2n0TtX1zT6B7fVJMSlOebql
         9+orpy2qAy6jFIlxEIlNzAzqNBgErBRYlRypRJ9ZgEFgfu3rKwq3G9sZcPwn1NbojhFV
         Yig94blRaIjzicOcOn4+qxlWDsr8wLjEm/RpUSxwLMy5zduML2qc7/HkGExJdbpI1zA5
         R5XhSHdwzNZA4jqUeyII1lxfzHklpXzpDl/yx1Urep2T0JM6xKztjFEAM661YUzY75nt
         /Y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558039; x=1730162839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60wgcSLTXVxTzPUjoeX/E6FIWkDuwYegYI4IrChLCKo=;
        b=kHP6AkoXjqwPd2xFqMJeE9tU19JB+3CIETJfEuOv0315wNEPjviHcpFcvsQILhSd/t
         WDQyEWhyqa6Zqe4WcI0AZSRoBKMnIwQH4991M8KwaIWOmt0KjsRTLMrlwxdr2KLuIupg
         mV6mGNndR54Py1L47Akxw+6B+vercN/Dbxykfirhmy6Lft8sL9Morqdhc197tdZLJFpv
         bpAIp7C+2dKX4IMM7YmdPGj1Z2oM4ryUmoKtuY4jl3sy78Pl3cKTsXuBkbuIdlFjtgEh
         8pdRXg+6u8YR4pxCsBM6LdZmGx0cQdqbTQQvdTsUyFPj6lhVnBZSdriCe9KOhmMxD4vk
         XXtA==
X-Forwarded-Encrypted: i=1; AJvYcCW+j/G7TUOpNcKmWhEP1+0qe3t3UbF3pft9fdrHqNr+tj0KjY0vXkp9gghOhXxGTItgCAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yydt32HS7MXfS1nXN8IqZul84Ay9tFbCtI53DojByqu/jI2F8P8
	9vOHOfdvNTfJtdNlfPfYKzGeL18SUFDYQOLh5jC+e4DjrvaF/OKeItdYFbgOtxaNuqsN0FHQ5fw
	wuvgYqw==
X-Google-Smtp-Source: AGHT+IFiyt/4iIInAWKLwhqunyPq9QHonJj64kutF9hny1NRpAVPZ5zeWGMGBu5qDtED4tv1AgjC9hWx+3+e
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:690c:3582:b0:6e3:2f0b:b595 with SMTP
 id 00721157ae682-6e5bfd58c16mr738297b3.5.1729558039164; Mon, 21 Oct 2024
 17:47:19 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:10 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-4-rananta@google.com>
Subject: [kvm-unit-tests PATCH 3/3] arm: fpu: Fix the input/output args for
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
index 587b6ea3..6b0411d3 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -54,7 +54,7 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q26, q27, [%0], #32\n\t"	\
 		     "stp q28, q29, [%0], #32\n\t"	\
 		     "stp q30, q31, [%0], #32\n\t"	\
-		     : "=r" (__val)			\
+		     : "+r" (__val)			\
 		     :					\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
@@ -87,8 +87,8 @@ do {							\
 		     "ldp q26, q27, [%0], #32\n\t"	\
 		     "ldp q28, q29, [%0], #32\n\t"	\
 		     "ldp q30, q31, [%0], #32\n\t"	\
+		     : "+r" (__val)			\
 		     :					\
-		     : "r" (__val)			\
 		     : "v0", "v1", "v2", "v3",		\
 			"v4", "v5", "v6", "v7",		\
 			"v8", "v9", "v10", "v11",	\
@@ -138,8 +138,8 @@ do {							\
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


