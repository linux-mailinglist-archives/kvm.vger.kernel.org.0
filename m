Return-Path: <kvm+bounces-26597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D1D975D25
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:26:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BACE0B2386F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2441BD007;
	Wed, 11 Sep 2024 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c0mycJvD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C51BC073
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726093517; cv=none; b=VP+vGQ576zmKWiz4x3ctUPSOWBeSleZ89xFbhJwxvQ0IefGbHCV8ywTpVaZ2k6PYwAW1PGiwBhLyyatqjypVkoo2aGQMMmtZYuVDcOEDgNHHH5xuh0qCgwqhpz+MQiiaPvT/j5efXHnfWW2q1diZC8HpqZXRRzvl+xMYCykHqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726093517; c=relaxed/simple;
	bh=Aav80nw+Oj48/H0OfvSqZnp5S221N6H/skMuhsyP0SY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ItEvsVLYfpKQWB6j8woPbmnZW3psEChGEYrDO5q6s975vE9z2u8NjvnSDkEybxi3CwHT/lkcOq2SqHcElFeafcjEFuJJ54Tx3NfPJZfb2JkIY4CS8LJ0N5SrijEFnZxwoC0ClEGzd7ly69rgt829AinWwvBDl9WtYaWIuX8bQbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c0mycJvD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b3d35ccfbso727926276.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726093515; x=1726698315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qY7jazBJP8pJhg0f/dQ9sIJIXrzux0tRJtWLf7xpCl4=;
        b=c0mycJvDFOq+qLXq5JbVOqDpxZqiWDU+BHqaICyOgLyOi4LlBTncSrKaoJrd+viNld
         Dlmlu5IMED21E1mH7WhIWAARcAoxEo72gv4o0aUjm4DfyNcmL4HSIZAn32oDpQk/NM5y
         mim9nRPqv3B8MNGEW7YTIW5TPqB5xJWYtr59GsKfabat9tw+lDKKOXw8QHM0dCeesOlB
         SgTEWpddSBQkKquFkQjmyX5A6t/REiQVWLRxEBtORj82hX30/nCn2rXg0ofW6alKxkaK
         VcMU8O9AzJaG7OSD2ybazB/QmbZKxLCgLjyTkjwHa/xZDcWiR/yIy5vrnVJMZ8K5v0ZY
         mgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726093515; x=1726698315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qY7jazBJP8pJhg0f/dQ9sIJIXrzux0tRJtWLf7xpCl4=;
        b=AY2P/eKxurf5HqEsCoXCzC2xM9BOSqWhcPgtc9QB/lbGaitT5xCtWKBYOxuph4eSbL
         8EQjaszSEs7HsTwgHdRbkDbdDzriBAKRDxxqS55cV9zIyhhiLNcDroWfB+HW/mWrmwwr
         gNS+ki6OfPmcMvmNtdFeSce7FiGF8dRZJfgnhz0xOyx9xMMZozgBapi6WIG77Nq1jU4U
         4zAxI+geMYHhZALxfltzdNDn8Jkn1QB5tfHX4kZP2C/aagkrwlNeF1nOR7L001oxmADs
         wdLCSJVGb+HE6phCUmXUte75O8Htjjax4yKVO+MGmC5/6xKx67ClosyzJjQ/Qln03KMb
         cPLw==
X-Gm-Message-State: AOJu0YxJWfBi2PuVAdReqwiGnUOuX9H07ZruyDviRsINd2tPL1qLo+TD
	DGiqHJoiETgyRVkL1cC74MyZQwoPB+LfPs5y6ME5jXPVkffk+tWuVfkxMWXoFCCvI4z9JRN0SIN
	9rHZo9p+V1sDphatHHmqwma+Ljv67f9DcYvy/A3CGnqI+goC57+v2njkZqO2lr88TuaCZ88hitN
	oQxKUSZUyAOFK3PpHPwVnU5PQKMG8cdMZsbipgccOk9o2JUrKxiwN7mJ8=
X-Google-Smtp-Source: AGHT+IEJ4qXFa/RnEyqgs+UMl0d9RUxwmlrJg7JrBYtR4wSiyNcS6y1wcbWXE0ormIQyuX+hDspZQAPbFzn+ORG1EA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:27c1:b0:e1a:22d5:d9eb with
 SMTP id 3f1490d57ef6-e1d9db894c5mr1072276.1.1726093513931; Wed, 11 Sep 2024
 15:25:13 -0700 (PDT)
Date: Wed, 11 Sep 2024 22:24:31 +0000
In-Reply-To: <20240911222433.3415301-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911222433.3415301-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911222433.3415301-5-coltonlewis@google.com>
Subject: [PATCH v2 4/5] x86: perf: Refactor misc flag assignments
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
---
 arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
 arch/x86/include/asm/perf_event.h |  2 ++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 760ad067527c..d51e5d24802b 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2948,16 +2948,34 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
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
+	if (guest_state & PERF_GUEST_USER)
+		flags |= PERF_RECORD_MISC_GUEST_USER;
+	else if (guest_state & PERF_GUEST_ACTIVE)
+		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
+
+	return flags;
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
@@ -2965,9 +2983,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
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
2.46.0.598.g6f2099f65c-goog


