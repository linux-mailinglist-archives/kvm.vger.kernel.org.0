Return-Path: <kvm+bounces-29563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 337F89ACEB8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABC7286DAA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B7F1CACF2;
	Wed, 23 Oct 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c5iJRAnV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C401E51D
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697207; cv=none; b=dW/6I23KuPXBIkOjUGaAkyxOBzku1zUGS4+/WeYZ9+Xr3CJyRNBgGP+VxerDC0I2q8peBbxz5Md9Vf9IryKWTk+ZtDZvdHw23mvNn1LrfYMBfp5AreLQmVM4hmQRWnSAFCwe0WyIJN3T/FiRBWZJG65qCdrFZqlfQpLAeDjpIXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697207; c=relaxed/simple;
	bh=3W9iajvimea6YrR9U732pMuKRx3PZLGRnnVS589DTvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LOIUQBF+f7p4ibqPBg8KIyM+HkQQLuO1gyHUgd3eMmp1LNrOuIfpbGHJsWSRIlDgwNmX/0nC5+PK6KMRCb5j/7OMaZKXeM++MJeeIC6DNdJc9bp5Z/S25bj1ULIsj5bCcoy89Nas5BCz7UDKb2AxU0oKBfjXQr3RZdW0kYfh9h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c5iJRAnV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2bd09d2505so7277405276.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697204; x=1730302004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=c5iJRAnV3Fi4lYXeoXbKQPKWwovOzhYCc7sZo9bpxAhvPLbExgqWjK/KFIIiKQAuBU
         cls+xavghVNYuH1042htv/kbU2HgDQT07ozuJ6M3fFAdqT8s6OE7z+iLVixM5oGa8ADJ
         pIoRkf5fIbv1l7Ot/HWh36gR8vPw0b1kpmYi78aa+/ONsNBRXWe2gqwjWzX3Ov6ER02J
         WamC9Fuc/rTkgOqRjcLJIpbzoiBPXocjThvzeRKc8PeneZyreuX22clYk8US5MYuSxkB
         97tKfUIQv1xo1BIWOm38vuPNnSzeWnsfa8y3wlrdt0jBfsu2NxeXsl+xKTGgbBRJlUlc
         OgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697204; x=1730302004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=en13Uu3du32cTX95RijS/fAXGMVqF0mOc4SHGef/TiEcYZHRNaQ6u13//ngW/tD5Oc
         KQnjBeLFULPnEdqRJkwobvt+9mPKIHZU6djoQzf3lV9eEEQBZMSzXMvXVbPxII//Pru7
         O221i2PgFQoQiIkttcjj4l6Ie6ODm20QugKwIBVioyzc5cg3th84yMAcMQtTQ2YTmRAU
         JpBiEEERTsrm4ykIimZqdYo+9hviOZV9Nr3TU/UwQ1PsYDn2UMgGYxCO30zEtUK+KUOT
         salFnPrPnItsKvKRwpCSksWlROvUIcKa7Pwcn2YkI9klsenj/ehg9hxzwYcNZ2wgQ8zf
         E3cA==
X-Forwarded-Encrypted: i=1; AJvYcCWmQ9i5h5t3yjqo5T7eHOTxS9jhLpgwk+CY1JlscNKJmT1+wGPpDTlirr3Egs8BF5rxWro=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQaxCLq3xtviM54rbSWSxW39UPRqha+FUkyOoitmqD45Tj05CE
	Eyb12lMXFuGRpcRuUm2PRkd8xz+yPfJboEBLQZGqHcNmJVnBZ41eziFMG48pf1WW1g+ZKbEN/ru
	oBVZxAw==
X-Google-Smtp-Source: AGHT+IFh0UYQGtbCtvsET0xrrd1Y/kAJ4FbXvNEzhh8lcJJcZvj2pTt+HaP9rNqWRxjhbRVfontBWLjAHjHZ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:acce:0:b0:e28:8f62:e735 with SMTP id
 3f1490d57ef6-e2e3a5f5d18mr1688276.1.1729697204137; Wed, 23 Oct 2024 08:26:44
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:36 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-3-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 2/4] arm: fpu: Convert 'q' registers to 'v'
 to satisfy clang
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Clang doesn't seem to support 'q' register notation in the clobbered
list, and hence throws the following error:

arm/fpu.c:235:3: error: unknown register name 'q0' in asm
                fpu_reg_read(outdata);
                ^
arm/fpu.c:59:10: note: expanded from macro 'fpu_reg_read'
                     : "q0", "q1", "q2", "q3",          \
                       ^
arm/fpu.c:281:3: error: unknown register name 'q0' in asm
                fpu_reg_write(*indata);
                ^
arm/fpu.c:92:10: note: expanded from macro 'fpu_reg_write'
                     : "q0", "q1", "q2", "q3",          \
                       ^
2 errors generated.

Hence, replace 'q' with 'v' registers for the clobbered list.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arm/fpu.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arm/fpu.c b/arm/fpu.c
index edbd9a94..587b6ea3 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -56,16 +56,16 @@ static inline bool arch_collect_entropy(uint64_t *random)
 		     "stp q30, q31, [%0], #32\n\t"	\
 		     : "=r" (__val)			\
 		     :					\
-		     : "q0", "q1", "q2", "q3",		\
-			"q4", "q5", "q6", "q7",		\
-			"q8", "q9", "q10", "q11",	\
-			"q12", "q13", "q14",		\
-			"q15", "q16", "q17",		\
-			"q18", "q19", "q20",		\
-			"q21", "q22", "q23",		\
-			"q24", "q25", "q26",		\
-			"q27", "q28", "q29",		\
-			"q30", "q31", "memory");	\
+		     : "v0", "v1", "v2", "v3",		\
+			"v4", "v5", "v6", "v7",		\
+			"v8", "v9", "v10", "v11",	\
+			"v12", "v13", "v14",		\
+			"v15", "v16", "v17",		\
+			"v18", "v19", "v20",		\
+			"v21", "v22", "v23",		\
+			"v24", "v25", "v26",		\
+			"v27", "v28", "v29",		\
+			"v30", "v31", "memory");	\
 })
 
 #define fpu_reg_write(val)				\
@@ -89,16 +89,16 @@ do {							\
 		     "ldp q30, q31, [%0], #32\n\t"	\
 		     :					\
 		     : "r" (__val)			\
-		     : "q0", "q1", "q2", "q3",		\
-			"q4", "q5", "q6", "q7",		\
-			"q8", "q9", "q10", "q11",	\
-			"q12", "q13", "q14",		\
-			"q15", "q16", "q17",		\
-			"q18", "q19", "q20",		\
-			"q21", "q22", "q23",		\
-			"q24", "q25", "q26",		\
-			"q27", "q28", "q29",		\
-			"q30", "q31", "memory");	\
+		     : "v0", "v1", "v2", "v3",		\
+			"v4", "v5", "v6", "v7",		\
+			"v8", "v9", "v10", "v11",	\
+			"v12", "v13", "v14",		\
+			"v15", "v16", "v17",		\
+			"v18", "v19", "v20",		\
+			"v21", "v22", "v23",		\
+			"v24", "v25", "v26",		\
+			"v27", "v28", "v29",		\
+			"v30", "v31", "memory");	\
 } while (0)
 
 #ifdef CC_HAS_SVE
-- 
2.47.0.105.g07ac214952-goog


