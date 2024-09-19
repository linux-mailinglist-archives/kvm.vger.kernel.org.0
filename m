Return-Path: <kvm+bounces-27185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6377E97CDFC
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 21:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D32B28542B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 19:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18DCB38F97;
	Thu, 19 Sep 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RxR4ls4p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD09623749
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 19:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726772887; cv=none; b=Eh5SZLkPtWrE8n2pw49NUx3hQaSLIGlW1niGNfGXM0CzmTlw+v6fmZYpX1d0edbBxVquKuDAcjIra5ZKxAngj+0eBlRSwihf0Lc11D1a/mwX29v2rNQ5G6dCTLQ5H/OVMvK7od747LL+/rSXudBn//hANqBUrpe7U7lvgiIzq3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726772887; c=relaxed/simple;
	bh=5Y45c2QmHSpUy9kSzxpEB6TrwN4M0m5LC0e0soV2VJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IXw8e3Ne35CIMHOibhELUrnVzFRUu5FmOmsd4xrVmcWSMfy9Bwk2BRBUVJ2XEdzHKi3rZp1mJCU56hlvCeeGpIra3mXOJv4wawzWdMzL34Sck6mXd8RkxYanVosx8NAI7osDBAEuaC9jeIw55w5TP0U/lsYw/ULE+SAKLIbIVcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RxR4ls4p; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-69a0536b23aso19060337b3.3
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 12:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726772885; x=1727377685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1u8+tIRQu1/+Yzznd3YfSwPNzKiT5HV8vjSuz+hJEoI=;
        b=RxR4ls4p8bFeJSSYxOikP5ILaIYSN3cFzZ8R3gfEt1QwKFBc++rvo21YTQ9USNYNwp
         /rc0XSP+F/bpZ5dEU06U2feTOPaNEJjJqV4YpyRZN9/6TbkcWgpNLnWAHBWuMbivOi95
         I3bUI/ROi4aTsVyMt5Wc5zAAxEnJ+5dpP4xvmMeji5TT/XEfIiknCwb77YCzYm+qkwJP
         m7+OTnn+kyoSep0CgWSsgMD01Fb1GPAxrSmWkOrVu4XXmYcufqx+NSSNvkwzU1yOoBwq
         ai3j3DdNAf4s8bvU+yatQG2ZXgJXgbu3eSQTO4lfdE1e6sOw1JgG4wlYrLYZhcqq2mH6
         fPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726772885; x=1727377685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1u8+tIRQu1/+Yzznd3YfSwPNzKiT5HV8vjSuz+hJEoI=;
        b=QBRFwdWPvRSpVNIKMk9jUjVNQUwrUPNe7z0VWKTjvaAOWT8cP48QLWLz2G2EjN9K60
         E0bIRFUWZA4LJrgH4G57yBXT+4RuB2vO8XWpOJ7pIIOUDHndbK0v8c6IWmOCigAFTnc3
         HhTSkwbnRilcxpTviHzV7EDWM6Bn6P1UX9fc8nHuJG6tjjmFnRz14Q+JtbvG1yzJ0aCr
         4KYXXQ33CT4uk3HG8IXSnTZm7qr46EUS9Pgp9SKN+6B7/BzGJepyDiXCoDR5pFGUqkty
         8kHpa3lQ/KwEBlUTWe+mWh/ougEqkLt0FC8Dajq4NMg2BpXME0rhONqkkvM+2swsPC1p
         Bs2g==
X-Gm-Message-State: AOJu0Yx9AKsIYmK0+v51Cn35PKUlhhIsKBanqE2atazpmWo4MRhDBmTe
	g7VmI2DnLbJ5tvyBl64z/5xoN9fn73rGHnqh/aGHt8XHq8iwdMlJF2OpZ1PXUF4VqjdSbcIIVoh
	8SsULZ+gPfBfru9UZZB77LE1gZTzOQoqvJO1jjfxx4m8OABOUYqzcgdwlQCYeeFjeV2/vzk9Jp1
	qBW7sm743YcKeaASCgHyM4Oklrep5q0nRhbKFwpTIAezdqo0rjVWgRxyo=
X-Google-Smtp-Source: AGHT+IGDiKrctQsFm0erPBgmwBCKnufFRGsSs3qB+YNCGyJVR/2h6144NBut+d+5hRqNGNQ/pKN4LdcbFv0AmZEt/Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a81:a88a:0:b0:6db:c6eb:bae9 with SMTP
 id 00721157ae682-6dfeed1dec3mr31057b3.2.1726772884551; Thu, 19 Sep 2024
 12:08:04 -0700 (PDT)
Date: Thu, 19 Sep 2024 19:07:46 +0000
In-Reply-To: <20240919190750.4163977-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240919190750.4163977-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240919190750.4163977-2-coltonlewis@google.com>
Subject: [PATCH v4 1/5] arm: perf: Drop unused functions
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

For arm's implementation, perf_instruction_pointer() and
perf_misc_flags() are equivalent to the generic versions in
include/linux/perf_event.h so arch/arm doesn't need to provide its
own versions. Drop them here.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/perf_event.h |  7 -------
 arch/arm/kernel/perf_callchain.c  | 17 -----------------
 2 files changed, 24 deletions(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index bdbc1e590891..c08f16f2e243 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -8,13 +8,6 @@
 #ifndef __ARM_PERF_EVENT_H__
 #define __ARM_PERF_EVENT_H__
 
-#ifdef CONFIG_PERF_EVENTS
-struct pt_regs;
-extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
-extern unsigned long perf_misc_flags(struct pt_regs *regs);
-#define perf_misc_flags(regs)	perf_misc_flags(regs)
-#endif
-
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
 	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 1d230ac9d0eb..a2601b1ef318 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -96,20 +96,3 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	arm_get_current_stackframe(regs, &fr);
 	walk_stackframe(&fr, callchain_trace, entry);
 }
-
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
-{
-	return instruction_pointer(regs);
-}
-
-unsigned long perf_misc_flags(struct pt_regs *regs)
-{
-	int misc = 0;
-
-	if (user_mode(regs))
-		misc |= PERF_RECORD_MISC_USER;
-	else
-		misc |= PERF_RECORD_MISC_KERNEL;
-
-	return misc;
-}
-- 
2.46.0.792.g87dc391469-goog


