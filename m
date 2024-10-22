Return-Path: <kvm+bounces-29320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 250169A951C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:48:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55A8283028
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93694136671;
	Tue, 22 Oct 2024 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lYUGgy/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5083CD6
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558040; cv=none; b=itZQ+blknmY9JdcWW/ls8qorXjzX95970LOy++1kGb0btTF5STKxX/sVhT7rX2TIMAxqVWxGQSPhDbA0doDSyC9vqYFr8ElYTSbwry7WD+SmWa0IrK0ZQTHRztPNrjtNiB816tn5yfUcirzW3ElvpJpEcgu1K01QuKVAmDTs5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558040; c=relaxed/simple;
	bh=3W9iajvimea6YrR9U732pMuKRx3PZLGRnnVS589DTvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I+/W1EyFpc2ZFgUVGhZOkZwLmQmG3lNCEcVF0DXFdEDM94b3r47uM0LF+Z1oRRixlCNVGa7FZRoQDiPqc6B9qp40KOCJjXTx9Lit4AMplHxgXfvNi22cRXosYeXJmPEVGrD9Yu5eLroGwIx9CAINAiGR2k4RiunnTgeG0iRwMyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lYUGgy/Q; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-83aecd993faso4021639f.0
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558038; x=1730162838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=lYUGgy/QGwm5mMpygqQrfSTCgpdB085DCm4QVpnUSHMhxvYfVPDpEGIjps5tIZotlk
         Mn3k17DOA7Pwd9Qf1rLwSR9JC7+zuET2QHoSPcFop04KwGzVzcKpMMAZxJOvmtfEPg8Y
         1iEZjtbpjFfxHo+mCu+eljsnP2VA6GyZNA25cUEH9vvvfjVmhsx+0WpfageveMyFcZLm
         ILD1VfHvupHGObuJG5aRUEkaHaXneUEF3TsDO2+a6fPSIsvgg8YI/uHaXRPxXRmNc2Wn
         EkWTy2JmwBWENsZMr3g1YcP9cGModOQgqISlwjLfnMkjtlRWEPhJG0YYespkufIhd0aU
         GOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558038; x=1730162838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fFBeTk/ypl/mbwDh0gs/JhAq5wRwgc/prGa+mqCvt5o=;
        b=Ku/A0mamU9d+psz4FAlwta2TOywjDjsvNRMinVSecmIVOulrquZBoMzDAhVZtFpClb
         98DzPxw30YAHAWt5ur4+8nKhNTcHg/zEGLCpZ3uv/Bh65up3D+kqsMevv81XXA/avIoT
         eAUvNnkqSLRbcv60ZsjryvjBEfTq+MSmRVdtBpPVe8ic1OPF9gWBi+ifXH64wuKPRqVy
         ipHqGpG22ebNQlqUVV9bLXPdv7A5wP59Ks85lGOYq2yi0rSBcVPsNFi95Qd5a5iyoj1S
         Kmw/QpGm43aQYsjhhHkR08wAFbUEd7thQiXk8UIVzzy7ixOzxysr/jxcZvaXU22t1UAY
         GIvA==
X-Forwarded-Encrypted: i=1; AJvYcCVf2Q1cCK8lOJsAphIL+VZjnwRbEsZUh3xkx40W10tMU8V+mrhSWOdbtbabCbVXVt5nNBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdguEES5S6OwNskmY6MhgP7W297GqvQCMX+IieeyI6oX+HqAEy
	dw8vTSLIvrGS4xUMOSpLOm1ndLjrl2KYPU10ZR9ucWON8vgNgCIf5kh+fvtzmGrxKgi4rp+d731
	cQOjQFA==
X-Google-Smtp-Source: AGHT+IGzqRDsg2PzRLzqCFl7gr4a8ftn+I8+zYOg3xTOpEKFCEBYRQxWqZwKNprPXM6RvFGVT+CQWKASwGCx
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a02:a613:0:b0:4db:e3a0:c40e with SMTP id
 8926c6da1cb9f-4dc44251858mr9721173.0.1729558038062; Mon, 21 Oct 2024 17:47:18
 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:09 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-3-rananta@google.com>
Subject: [kvm-unit-tests PATCH 2/3] arm: fpu: Convert 'q' registers to 'v' to
 satisfy clang
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


