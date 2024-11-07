Return-Path: <kvm+bounces-31149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BE89C0E53
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:05:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87FE328280A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0255121859F;
	Thu,  7 Nov 2024 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LwFhzOVq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBD217F2C
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006271; cv=none; b=X1+r7vWa0prutWeJvpKWOAPc8yNDp4NabDBHybSfsTJFwfG1GD1aPicYJ9JxgInUGEEptD9Rro9zYc4nWB3qpIufdqhbPPv6ValFrmxhSKp5AtZCDNhFACsITEuRXOnpSaDsNqppbuOVxUCP1akfEVsswjxUFn/0OLeRRr53DM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006271; c=relaxed/simple;
	bh=7U9jlZ4qr/SgQtzb8uGojyX0Uf3RH5gEOm3dddm5pyE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h1Zg37xUI+IGhfeV2Ak9HuD2KU8IQHAx94n5Is00MtuvT3XqU9Bt6hpeA6T5LKS7ofuEiqemhfYClhHGoZahgIWMogq7NvFKHT8T3xKiLFt3tYUbQFNRk7aRS9Dlf6We6C1f+YtwQ5pB4lVOUif2o/Kut1k97uAmvxf60czDrvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LwFhzOVq; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea6aa3b68bso23454557b3.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 11:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731006268; x=1731611068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmIA3zzAwF29Of1RGzzoKivdDO9cfxtkZLWZ4k8wrj4=;
        b=LwFhzOVqlfxglbWqky7YM7mkDqIS9rp2X0Iu2W55AA7gYf3acZw4kR0WF4g6+8NF6H
         w0FJ6dOYlwndJH7iiiUEP9qgMeYYLjFFP09x0etNRdHrsQtVs3OCjEkkhoCE0+aQiApq
         yko5Muzqh+IYL/LPBHq3ErCKlbPPtsxdiwC7daw1zWJ/7HFhg+oMv0gm0GyTtRXcl+o5
         rxohn27YYJIL0KZ7F4aWvmZ9AniZhdJsF68jqoZuHH4BU0dxDtqi+Djvad/7cm9flEpB
         7/4WgzrZROFOIsU+ORQQ/S37qYXizrN/aaeiaYuQOKxmAE8hdh19IuEHCRZ3ZOV3g/WC
         v3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731006268; x=1731611068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmIA3zzAwF29Of1RGzzoKivdDO9cfxtkZLWZ4k8wrj4=;
        b=CtukWLafQQV1Ku7oJqxK0XzeHdMvQERv/iLCuc8IUI8szryZ5CCGzH8xR9GdoZ4FYr
         Beh0EN6K9x/T4o+9QWLDoccF4Gk+hBHunqMkgooQjpQSM2O9y3t1SsClwTwRQlKFc6nG
         R+A6ttebeUuNqdcALJqMGnwOaVHUUYIHBSJ9VVAettL5r+REk3s9NhdQV5lZKpff9SNf
         8VNV/L9xxbzXHL33rB6kqkVwhLCM8T6hC2invdHl/k7ulghF49oJ1icAVXlz7xhO0osn
         bsGsCjys5q0CNmMQ6PhOUbQgp4UsBZRR8q9icgxP3wRepiOOy3LodHhs26kvLTAcGY8k
         mXug==
X-Gm-Message-State: AOJu0YxvX5+UFmV77eGDkqziGmU/7xKjL8JAxR+2/T8h3+BfgTx8H9+4
	0pZby6HH9zgqHAE95HEaErdbj2sEqwbmxSPGok+1hp3ZewtCcYiGhlmrVoNrjZc5/VgM/wMW2op
	Dq5arpIu1n3Nhr3yX/F32CwjqbdPi3OZWN0ebmCIVoxAJtDoAK6URw4Rinnj2uGjt1rwSp71BWK
	1b2yfloVQCnd1uLGz95BsgZfmn+JjLSBrbTApETzpYLAc91Nr29rdeoAI=
X-Google-Smtp-Source: AGHT+IEPatL83aR4PMUsob9OXifW5dvDcVQBE6blGQgqqGrE/g3o0tifuLtLw5ypjY27t+StHZULk6h1q6SQXWXUfw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:968e:b0:6ea:34c5:1634 with
 SMTP id 00721157ae682-6eadb3f8a54mr13007b3.8.1731006267878; Thu, 07 Nov 2024
 11:04:27 -0800 (PST)
Date: Thu,  7 Nov 2024 19:03:35 +0000
In-Reply-To: <20241107190336.2963882-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107190336.2963882-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107190336.2963882-5-coltonlewis@google.com>
Subject: [PATCH v7 4/5] x86: perf: Refactor misc flag assignments
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break the assignment logic for misc flags into their own respective
functions to reduce the complexity of the nested logic.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/x86/events/core.c            | 32 +++++++++++++++++++++++--------
 arch/x86/include/asm/perf_event.h |  2 ++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index d19e939f3998..9fdc5fa22c66 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3011,16 +3011,35 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
 	return regs->ip + code_segment_base(regs);
 }
 
+static unsigned long common_misc_flags(struct pt_regs *regs)
+{
+	if (regs->flags & PERF_EFLAGS_EXACT)
+		return PERF_RECORD_MISC_EXACT_IP;
+
+	return 0;
+}
+
+unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
+{
+	unsigned long guest_state = perf_guest_state();
+	unsigned long flags = common_misc_flags(regs);
+
+	if (!(guest_state & PERF_GUEST_ACTIVE))
+		return flags;
+
+	if (guest_state & PERF_GUEST_USER)
+		return flags & PERF_RECORD_MISC_GUEST_USER;
+	else
+		return flags & PERF_RECORD_MISC_GUEST_KERNEL;
+}
+
 unsigned long perf_arch_misc_flags(struct pt_regs *regs)
 {
 	unsigned int guest_state = perf_guest_state();
-	int misc = 0;
+	unsigned long misc = common_misc_flags(regs);
 
 	if (guest_state) {
-		if (guest_state & PERF_GUEST_USER)
-			misc |= PERF_RECORD_MISC_GUEST_USER;
-		else
-			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
+		misc |= perf_arch_guest_misc_flags(regs);
 	} else {
 		if (user_mode(regs))
 			misc |= PERF_RECORD_MISC_USER;
@@ -3028,9 +3047,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
 			misc |= PERF_RECORD_MISC_KERNEL;
 	}
 
-	if (regs->flags & PERF_EFLAGS_EXACT)
-		misc |= PERF_RECORD_MISC_EXACT_IP;
-
 	return misc;
 }
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index feb87bf3d2e9..d95f902acc52 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -538,7 +538,9 @@ struct x86_perf_regs {
 
 extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
 extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
+extern unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs);
 #define perf_arch_misc_flags(regs)	perf_arch_misc_flags(regs)
+#define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
 
 #include <asm/stacktrace.h>
 
-- 
2.47.0.277.g8800431eea-goog


