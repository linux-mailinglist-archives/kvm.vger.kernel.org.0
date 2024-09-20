Return-Path: <kvm+bounces-27217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB10297D96D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 19:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFDAC1C21E2D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 17:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE42186E38;
	Fri, 20 Sep 2024 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mYMr4gkr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB31D185B42
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726854471; cv=none; b=Ucxv7bjSQA/OCmlnFezWTmEbwuQ96ngEZk/9qPGjAlWy/HEp34LcQWtr4izCJFreycifrEEblNygxaqVcrdJPkFX/EbGJnDniYhMYsOSL8JJqs3s7CEq4Nb6u6zvz2adXf3Y45ybb1Yew+FV51MbW1ctVTU3/2EDkMJp/hdRkDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726854471; c=relaxed/simple;
	bh=Brbx6usZhtXw07DVlXsA/D7+GJR0JaS+a0u4m3RwFBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/XzeFPiYJQp7xDA6V362Y3HzRFB8f+RlxPwBdp5xCCc2vYMxQ6dasNGxKUxqsVk27cTf2w1HVB0IRBR3EdqhKVDVvE5MzRkmnvJE/GXmbw7/Tm42zmW6OEOVdlvJ9JBM2Q+acK9zgxrp0wID3S+HRBk09Znq1Ec9VFkGAkMrXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mYMr4gkr; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a0987c35f2so27743155ab.2
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 10:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726854469; x=1727459269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=os3Yqql37R8r3BEesV69Cp0Wu//D+lGOxICBFWLJF5s=;
        b=mYMr4gkrWgJZRt1uMxN8XZSr19CqOcdizVivvso8wsQwwAUvf3Sb8Dc88TEg+Cxd/T
         8JWe8PZhSdG7u16LiJ0JDE9VavYiECeFqOf++9KcedLNAp5Y0f4FzggJtL6S24VEmmj1
         uTJNyjHyP62ZBDxNZJNUHCcWNUkOokXGmeH3iolSvCIeLc7HY4njOHXk3paCLQxwlhb+
         KWHmp9iawA2w2Q4PPGMfVXJ8RgmMOhULq7+lgRrYvEJsGySeA1zBX5aCqEWvr0DTBfHq
         dU7HPQ61IgPkrT3LP6TwC1/3048MoUzpoptHwzevwJDUPILh2zlCc5wIi29UqGnZj9hT
         SsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726854469; x=1727459269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=os3Yqql37R8r3BEesV69Cp0Wu//D+lGOxICBFWLJF5s=;
        b=vwxCTBUB7JbSqW+tyzopk1/syztEUjWx2CEa6sf6/5bDROTQqILMBz/rvczSBM+70e
         ysG14WytEjmtVh3/wO15VleU4wJX8oCuW1gulU2x8a+TXUuB5z1pZlzEgAPhtO8KTuo9
         Y2RSPI+rRqVdSnGlWw+SKLJdQFXtRfUi8psk7hKVaP5t1htMVuhJmCARxgnyz0n9IPjG
         Fr0u7Z6g0IC+FdG3x6JZRuLy+/k7kFekbL2kNul1gwV/qrrh/2qUWQ1jjVpVEuBwyE4n
         mIRc4ASxuS8qBaYoZcBvBR4+ShM5aLwUhhvKfon+JgseMs8XAvfKofJQuULFJE7V/tbs
         EOfw==
X-Gm-Message-State: AOJu0Yw4/oaarT5fGE/INh48PbV74UGFjxfr2zDXRFvEFBs68n+pARfQ
	bTkVJSzvFdgSn+DN8+wiDCR1EhlIxHXek6YiaBJs46YgH3MXxVXAsvoCfWB2Ko52UXNS3GciFUO
	XwqsZp9oenUr+hNrjcflV2oJO/iK83YltpQaIR2rsytNerQv/uhaE09LUapnzDGA5YDn1pocssA
	5L0yZ1S1L3VjoDyazezE5I+A9J0xuRbzJA9O2fov52XEGiWuIvOrCzmmw=
X-Google-Smtp-Source: AGHT+IFnhhl9BCVqz7UHoFG7yjq72HDbwzVFbb4MeEheIBAhExRul8dePWOtmi+TJc2JiJ2AJgNwLAkuPyQFmMIgfQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a92:c268:0:b0:3a0:9cbe:d246 with SMTP
 id e9e14a558f8ab-3a0c8c9d4cfmr286865ab.2.1726854468526; Fri, 20 Sep 2024
 10:47:48 -0700 (PDT)
Date: Fri, 20 Sep 2024 17:47:39 +0000
In-Reply-To: <20240920174740.781614-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240920174740.781614-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240920174740.781614-5-coltonlewis@google.com>
Subject: [PATCH v5 4/5] x86: perf: Refactor misc flag assignments
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
2.46.0.792.g87dc391469-goog


