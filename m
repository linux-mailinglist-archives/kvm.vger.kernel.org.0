Return-Path: <kvm+bounces-31797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E54E9C7BD6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D08728283D
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 19:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386FF20650F;
	Wed, 13 Nov 2024 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P4V4bJaE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD87B20515A
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524523; cv=none; b=cZtkJwh5UtsopS62tNNp/hmjj+/0ujac6zPQ3JGYLfnNOgTad4rzeTtIQE+DBUv1Ty+EjIIAUQFyf71cJPYwKxFSwozmQTTivHwHp59T1bFBR58OjiNcC2HLtjW9Jt2X3gWCZ7trFiYgnA4Fbj38rjjN3I/nKRTUoVg3daFU3ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524523; c=relaxed/simple;
	bh=NbcQuU5q+usE1Vfx+epUjEaR55c3/0PQVXgf9pjjXZ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rP8EUZavljGCosXmle+HXIKJAIPIIDHeUXU5zpvwd0ImLDI1UpOfsVc8yVF0sF/CHvAFOPZfYBxHuYMNojWvV7qQo2MlQLy/Yv5ChN8BdialRFx4rcrZhCTnJphgedkn8UjY/dOHsGrtWM9lZk7DrjRQbsIb4BbnQXzNjNVq0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P4V4bJaE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea33140094so128159717b3.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731524521; x=1732129321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps8myr2QRGzBkspMaTCSz6a/NGAbW5KYOWNi6Q8v63A=;
        b=P4V4bJaEg+EZ1BU+BW9+6Dm+sQ58YOOoyVBFV13wsThULFbLBOc2LiLcJPuYasvrKw
         F43D+F9W1EhoNGk0DSgwGk6PmkBVbDCYPFuqWHN8Pg6WC9rVzAmYeijgolfBCo7hjI2O
         TBMRGM7oQ9Cw9WWIdvC2PyqYOxNjOth/2rI0yGA2h+THLceRxr8OGoRonJBcQepAUbu2
         lgoBd/nZ8VdpODqFTwu68gWavwuhldr/17qWrmx2kbxM91ucMcqWixkdQpgxMCOmlB6b
         mYLecDVUzJiuc/jGlJw4zjuU6w0mW/ZsWCfb0iZI6u8XjymKFJfE95GBum/SOmSOUotz
         UkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731524521; x=1732129321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ps8myr2QRGzBkspMaTCSz6a/NGAbW5KYOWNi6Q8v63A=;
        b=QlXALgO9HbXvJT0fL4CVy6mL8ss6DgUuI5XLPeFDOVhdTTV9KAJa2c0e6OkhOeL8I2
         E15PBKe3SfwoLTpQGIT5Wh9I4h6Cv68G9e1CrmGbTeXOWFov2wXwYuEDHctk7/p5ykNq
         Ib3YSdSZbfQa4TubaixVkvOsxvpohk7GVW3GtqhykdqBcerL9hyrb4NkPp6d9n6WeP+V
         qz34d73dfyRtEfk/4LOfUJiXx1tDS5jUVUiRyQt3hdnU2wZqAIfbqEC9ONZltj6n1oDu
         BOsbUZ9DbcOHI/RnN6kAoIenyUXsh56sV/zAJHyzPGDDb4NJsdgTh0ZX56OFHrPIbv1V
         KebA==
X-Gm-Message-State: AOJu0YyT4S0mFNhQyYctagQqS5XzByNrddutuFBQUO1CS9nPHss9Ju92
	qALW9Uh4fanFLF1CRki5/8Cu3MJrX+cD3z3tjkOq12X7uh1tOPTrKJanq5GBb77oRn72pDBIcUe
	eE/+pibLsEUS8Msiq9AidH3EtK3hJ56Xri7uMMlSrUZVNlq5YR6ouaAGmK4SuJy28NlqEZuc7sg
	7pT5S0NWt9JpZ6rpoite+qbDAOPN1XoapHRYpyQENm1k6m0JBaEYyS9jc=
X-Google-Smtp-Source: AGHT+IGMwJxojcrbV2XaWtAxjGZhIMKLD/TWp2TYO47jqONg2YGViPdlhPH/gu+8jwib2jMpO8Gmgpa+P/L1ZLf8OA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:3349:b0:6e3:d670:f62a with
 SMTP id 00721157ae682-6ecb343d0b9mr2033797b3.3.1731524520358; Wed, 13 Nov
 2024 11:02:00 -0800 (PST)
Date: Wed, 13 Nov 2024 19:01:51 +0000
In-Reply-To: <20241113190156.2145593-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241113190156.2145593-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241113190156.2145593-2-coltonlewis@google.com>
Subject: [PATCH v8 1/5] arm: perf: Drop unused functions
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
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm/include/asm/perf_event.h |  7 -------
 arch/arm/kernel/perf_callchain.c  | 17 -----------------
 2 files changed, 24 deletions(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index bdbc1e590891e..c08f16f2e2435 100644
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
index 1d230ac9d0eb5..a2601b1ef3182 100644
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
2.47.0.338.g60cca15819-goog


