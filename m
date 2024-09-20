Return-Path: <kvm+bounces-27216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CBE97D96C
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 19:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38B1E28348C
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 17:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46693186E2D;
	Fri, 20 Sep 2024 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3TtSwYcj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46212185946
	for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726854471; cv=none; b=dxyz+lHdhr6gkkLC2lHR82HIXAYCdZmVzLcEi4DfGTJ47g2Nxk8q2j2EKNwPDr6pmEctHCsqJpYi05NdcNWEhmQkulhI7nqOJylV4E53M0gOldGUnxDYCsmFz3IGIYY/jLcZf7qpy9mVKFwzuU1phy0jyto7DT0loYcYZudeFnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726854471; c=relaxed/simple;
	bh=nOGTMAQagWkUZdTqcYtpFuhJmVUFEuPWvMTzi18KweY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TZj5Dv1/BZyIVm3ePKaNTrA3phB5gXPOdg2LdHoaUlHcql0925Tl9fUCFrJ1kwpEsPeWtSPDS1zWCvXJ6uipGhh/3BLYb7t3ZwTY9/R2Iadl3oAApOEDBIw+hUTNsG+bmUH2nfTRfX6HY0EjKsWdGRTFrDmsDoaSxBwcSQBUPEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3TtSwYcj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ddd90f09d9so32772807b3.1
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2024 10:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726854468; x=1727459268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i5Qt5np/Ap8e8S56AX/TaOyn++MQC/aFN8Qv/OewSh4=;
        b=3TtSwYcjG8DHv+aSM+vJyYNWZM6GMFhLzJNFqBWSQ2OMfPvpvnQNq2n4E5/nHPwpfN
         iIKNvd+jSxRo9OKDCooUmARIs+jSqW3EBkflhSmzLOA83ZnXmmKFDs13IEtTUdgXGefx
         xI0cP7Jfje2jOMLT6MZNrT1g0tBKbBUMq0hOs9yqfy+X1wUD1Ys171ud6fUMkum9pkAB
         4TlthGEY8jflfnhnQS0XrBnv4lEZXaQSuGVVl8iMjtSOqe60yRc40318+fJlfUX3MgwT
         zD2MVyWKXWQRrfl07SPcKVnsOezP/IGAA1TqtSV9QXOLgg4K+l3t3XPWPUlLkOuPGjOn
         PUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726854468; x=1727459268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5Qt5np/Ap8e8S56AX/TaOyn++MQC/aFN8Qv/OewSh4=;
        b=rDAkLzF/qF5dyM69eWZ5RYjJNFr8WQr+wgvCOzXvU9lqik8m0kEiq5cGSlUqFnEBeX
         V0tZzji/lNI4RBWi4G9B9Z6WhN/G6NWPkqO3t16R7PLXQX88FYsvHVDekT/4A2Wpb0jv
         1rXtnEYib6+cmcCg3PZSM93dHbOr0Tc1xYvU8ZRtcIxWybAB4IXJmUCIBp2tT4eXq+cx
         OMfAjR3c79dCh946rMz7A9De/RkfjcMM/hADtqsrplAQxv0FytKUAAkzCIElElBXSdd9
         u73gv67R/7Kf99B5aY5pb++CH9u00GwrD6uv7FpHLMOnCMoYUPKOsP1hYhsXXYri/u6c
         +tZg==
X-Gm-Message-State: AOJu0YwixHtkGsTgo07D4BraCDGT98/xtvSlmWJ7QxaSVEGhwQv74UzB
	Pg/TAIvxj/4JmLRynjvgVSz1+TNkgWjRDzSidJYFo85zVQn8pGWOS0TdL8gE4Bwz6S9cjH65DpQ
	V//odsl+kF3yuDJhGpidvhQnkKiW9i2kn6WGUJRTt7kjw6H2OXnV64X6VkofO+GG5S6J64YxvsV
	7D9jbkgTQ0+FvV7kqpkB2W1HoAIVEy441sQ4bf3nyR99Sn36rsAQolfuA=
X-Google-Smtp-Source: AGHT+IHbJ+HRIEkO5u3cDhpGgKAhQ1szUZlm5tAMnmYkXHJJtXJeplzJtZCUnHcEvMXwbAUs2nrn0eCuaSMxzmED7g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a81:c803:0:b0:6dc:97eb:ac51 with SMTP
 id 00721157ae682-6dfeeece207mr233927b3.3.1726854467532; Fri, 20 Sep 2024
 10:47:47 -0700 (PDT)
Date: Fri, 20 Sep 2024 17:47:38 +0000
In-Reply-To: <20240920174740.781614-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240920174740.781614-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240920174740.781614-4-coltonlewis@google.com>
Subject: [PATCH v5 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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

Make sure powerpc uses the arch-specific function now that those have
been reorganized.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/powerpc/perf/callchain.c    | 2 +-
 arch/powerpc/perf/callchain_32.c | 2 +-
 arch/powerpc/perf/callchain_64.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 6b4434dd0ff3..26aa26482c9a 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -51,7 +51,7 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, perf_instruction_pointer(regs));
+	perf_callchain_store(entry, perf_arch_instruction_pointer(regs));
 
 	if (!validate_sp(sp, current))
 		return;
diff --git a/arch/powerpc/perf/callchain_32.c b/arch/powerpc/perf/callchain_32.c
index ea8cfe3806dc..ddcc2d8aa64a 100644
--- a/arch/powerpc/perf/callchain_32.c
+++ b/arch/powerpc/perf/callchain_32.c
@@ -139,7 +139,7 @@ void perf_callchain_user_32(struct perf_callchain_entry_ctx *entry,
 	long level = 0;
 	unsigned int __user *fp, *uregs;
 
-	next_ip = perf_instruction_pointer(regs);
+	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
 	perf_callchain_store(entry, next_ip);
diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index 488e8a21a11e..115d1c105e8a 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -74,7 +74,7 @@ void perf_callchain_user_64(struct perf_callchain_entry_ctx *entry,
 	struct signal_frame_64 __user *sigframe;
 	unsigned long __user *fp, *uregs;
 
-	next_ip = perf_instruction_pointer(regs);
+	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
 	perf_callchain_store(entry, next_ip);
-- 
2.46.0.792.g87dc391469-goog


