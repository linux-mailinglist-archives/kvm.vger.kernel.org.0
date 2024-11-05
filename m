Return-Path: <kvm+bounces-30811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBBD9BD64E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E22D1F24AA4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C71213EFF;
	Tue,  5 Nov 2024 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RCpiLJSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D645215F45
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836596; cv=none; b=TLPxTcD5gagw7AJKNJkGlIsozWAIF9GgDbdqXimqyddM8F3uYaSCRKpG4j97xQBXZ64KW4Y6Pp7AYAN1boVOYKgoJNgb9ASIPy3dYQlOwiglRZe/jkC6KGWUSjObePv+2UJi++num6nu+R6dpNtiaC1ANUW+T4bWGBtEYaC7O1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836596; c=relaxed/simple;
	bh=L5dg5GAs/HO43xeeUw0eVVB1COvg02FxEjYWig5XfNQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HvRirl8WTFiotiiIt8pWqodu7lle0b2+uvCyUV5ixMMSJ4jya1usI492deovyQSFzq6B+X+0JvLsZkq4HMRpSnPPRcJVyQ599NYBQJzplZUph1V49zsZlUHd77FocqZ6FH4Iw7+7WIRd1BtkHJ7xu1bWgXuArcqkzhMKcvtZDpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RCpiLJSD; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-83abb2b6d42so568515839f.3
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730836593; x=1731441393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g+A/E6dh30+B+DuVgwcV18/qvNhG5j8MCeVP9K0OnPU=;
        b=RCpiLJSDRAnKCYCgYmtr5aFffKKqzBMFps5OWsprH430AJEXOmBRpUZ0KcMvAngKd7
         3pgKqRMpdHGqpY1xZu45ttA6AtdrKEJ7nwIZR2rzSMJOX2Sa6cyiIKKiddgwLiIs+hG4
         poG5XdRTT5K+4i+s2B6lA+HFfVGUqpOQkOpekcZyNo3ljbCNQeJ8EP9iRSZNvduMWxso
         MQeJAQpRbKyZpBEpx1L9j44VDce99yUYzUGG+yexEXSiyTlUY9krhYEiMjLHGcaTd3Te
         MyuxTH+KXdc9SQfLHSB9MJhdBG6R7VH30iNMX4UwwxSmF31QJ4BZxE0tO3611jWXNxW/
         Zt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730836593; x=1731441393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+A/E6dh30+B+DuVgwcV18/qvNhG5j8MCeVP9K0OnPU=;
        b=OPxw2QSl5g/fpMuChhSTYT2hkYLOaZi4MUlEzfNKAHdfsZMJGtQrl44Ut2FnxH/nWI
         FbxCssMMJ+/Fs6U4tsrgO25bi3AddEOryl33QzXqW3tcskciMd7tFkv0T1+lYfIQCk6p
         q0nYeLcd8UmrhzOh/S6li2h9ZLxhatRgWoepjYFxQHEPeJliCLQrqg+Yn+uZ+8eaZAnx
         Jz1mVtT5XVEuvmzjip3msEbFzGnwTYMySWwInmlRhTptC/ZR2U/QiXvAb69jUgkukO7E
         1I+zZdqRmAVKsTgMrXt6ZSOYCtKzx6s+zyrYwxVRLU6ZE8wqFFF6i6D2ePwKGQrEtJKX
         c+Hg==
X-Gm-Message-State: AOJu0YykftqcelGMBt2USt39J1GM0P5Eg4YCRyu63MPMFLYTxd0B48K5
	5ILMAdkoEOTCiD8+no6a9QcqgqUkRdJd4N7HlEqkS/JOD2E5sr3VEQFs7ZLPYjHWWWf5CRAocV7
	wDxedfFdcxb2b1bbxWnPEBBS3ExvT5rlgebtcuG8hqIPR0BZRaSDQZFBOGt5RD82oDXtbZd/vgl
	PMDUX/DuHyIzPtRjgGWuo5pH5WLYszNdC0tkBX8tZmhnb8MdlGvUN6Gpg=
X-Google-Smtp-Source: AGHT+IHwq3hF4ElsT4RerqS5KSh2j8l+o/SOi33LC2KdnD9j/u2Nkb6pf++GYEETuSfSuC1nI4Yu4HiUAJoPcaH3GQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:210d:b0:4db:e5f0:ceaf with
 SMTP id 8926c6da1cb9f-4de0257ba11mr134988173.0.1730836593213; Tue, 05 Nov
 2024 11:56:33 -0800 (PST)
Date: Tue,  5 Nov 2024 19:56:01 +0000
In-Reply-To: <20241105195603.2317483-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105195603.2317483-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105195603.2317483-5-coltonlewis@google.com>
Subject: [PATCH v6 4/5] x86: perf: Refactor misc flag assignments
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
 arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
 arch/x86/include/asm/perf_event.h |  2 ++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index d19e939f3998..24910c625e3d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3011,16 +3011,34 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
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
@@ -3028,9 +3046,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
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
2.47.0.199.ga7371fff76-goog


