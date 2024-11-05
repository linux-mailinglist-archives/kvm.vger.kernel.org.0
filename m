Return-Path: <kvm+bounces-30808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 790BD9BD648
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:57:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E558283CED
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10ADC215F61;
	Tue,  5 Nov 2024 19:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a3bUT3KT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C57B2141BB
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730836593; cv=none; b=p/PZyWrfl/FT3bzdv/hc5PZEZOQyXIbd3lKxGaF9kgzIEUS8U2nfQTY9JcjC4j8K7RWkXSyGhlpq5pf52ci/W2fkD1b7CLr54BfPBodi1OimwXlZ4qqhpsRxbkfP0nPdaTrF4QDq+qLSFdI/eTnTHikW7acavqxVgFbiiEDzH0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730836593; c=relaxed/simple;
	bh=dLIL2i/Biud1ORZ7js8CqRFmSmrKZrxHun5wYBVxjTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxTZ6qHbqRAJ9bm8rsnbfxNmfEPkplZJSGvqlD549vBMlU6Uj+KAPT8OtYciarCL3jW0VNGfnWxR2ML1Z7jwx5msBiFxb/nWGJSAtBZtCYk2Vt0UVpUMzOGHPhtJZfh9Ulqk7OZaW49kWiRA20ooDgR33TS0uEeqx2+fBpkl/mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a3bUT3KT; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3a3c5a6c5e1so76049915ab.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730836590; x=1731441390; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPb0hqOBb6kblWxXXARI3ocpeztWq9KwTirxTPs2l4Y=;
        b=a3bUT3KTmTxnYZLZShXEB6OqvwhWcWJnsWtNf+5LxQ3sOPVeswhpFmdFMTnmb7fExJ
         B0gU8DdqOUDvj5oe8RczOj3L3w5i7z3tbcNzeoCFQY5PJM1FKi0ObftUDkRIgVGXb27b
         e7IcrZBVYEEGMsl+pnFM8KYlSXs4LAyQkeUi0dkVctl3ryp2o0VHKjAgbGUhutfABtLW
         WF3bO0PeiwBBM7y0okzEsfZZiqK64ELsK2grvwHCYAJEUtDpN1IOu/zNqrGI4ad26RD6
         6DHciqBOY05qbJUXvHjKvnjoVOQXuM6fiR6Zgo+ehdRBXZI3diRtt6kxVZXNjnm1ALze
         CnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730836590; x=1731441390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPb0hqOBb6kblWxXXARI3ocpeztWq9KwTirxTPs2l4Y=;
        b=kzig3gtWrtYH2p6ByMPpVTtVeSsz7Ur8TIjxEZg9J9ITvfW1GIpRwoCxXhr1e6t0fj
         Puaz6HwF0c8tVrNhgCxhiY5qWI3vCR/XzyR6v+vqMzwD6NwwTGSrn/iew74zp3X92PaG
         wBzX4uk3RIFNA6IvsOoraTVBGFrcRsAGRTfxoHDibhY2LySh5oJrO8UNM+/Cwbf22n7E
         LgK4YBpg+nxVtgG5WpCi3XSBrwpgUeg6hjogkX2ZxVuAVvqqi5Lv+ZLNT1cc8CpGgO1i
         JGMB4Wxn3gmMbR6ubmUO9U4yhuxjaXJgVb70bn3FLQZ8x0D9Zy0AgnCRh0FU8+nQAcQW
         q87A==
X-Gm-Message-State: AOJu0YySVKOJs8D+OdiLW9gaZt9KI94/pEyDnASjb2CqZmkicCMQGkwz
	fY2lH+ZK6iceyTWvqTpv/idQAe7Gja3x+dz34mw/lS9t8wrPnnAjS/GUbZRGjwuAOMiKXoW11cW
	KYiSRlIij31kD1zcsI7+Awo/oHNHKhGkmJUADqkHTmlugNgEgOqrVK7Fg1LhqtogCgV2NBJSpYI
	OXm19hGcUVQzt7KNYjkk/YZkvEIngO9K+FD2ZIlOWQAvn2iic4AVrou7A=
X-Google-Smtp-Source: AGHT+IHah6Nqgqq9N69ws0DKUP/HTUx1alzkcwBsGSQWk19UCQk0MEnTOVuN0lF159yK8HSXoS8zbdDz2TvwiOw9WA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a92:d702:0:b0:3a6:ca09:6d48 with SMTP
 id e9e14a558f8ab-3a6ca09715emr1563885ab.2.1730836590276; Tue, 05 Nov 2024
 11:56:30 -0800 (PST)
Date: Tue,  5 Nov 2024 19:55:58 +0000
In-Reply-To: <20241105195603.2317483-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105195603.2317483-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105195603.2317483-2-coltonlewis@google.com>
Subject: [PATCH v6 1/5] arm: perf: Drop unused functions
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
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
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
2.47.0.199.ga7371fff76-goog


