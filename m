Return-Path: <kvm+bounces-26596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A53C975D21
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35212B24FBA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76081BC9ED;
	Wed, 11 Sep 2024 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lN07+KR0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D981BBBC3
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726093515; cv=none; b=j37mB4clbB4mjOoRBqSi7hHGOydUcUettCVqIB8W41j21duk8026gpH48PhYfc6PXnRTvUcT3Dt2lfzXVZ9ejdczT9fIW8aYw/CE/V+LxFmIhY8i/QEsUAXMAv7wgFsmaGizjoE2dbzq6Nw68rMrzl2V0WBXyW7Mi0GEHuU5fy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726093515; c=relaxed/simple;
	bh=Qe6ZURpmPiYgTTi7nxbvffzfT5qXIMw8HIC3oO1Vo3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=srb7Yyu19AZ56hyMWPHdEv+tXS53xXKl19jM0cgw5X4GGYj4FV0qxigfPLdbnLfEUS/EUsSqw6AK0c3tRuG1qmgVcRyBCyrMr/DNqrvYsMZmtcQUXS4grxW91U4N79YpTmDic0oBWqR9Ucxh6Qe8PY4nAyfXD3frHvofmtPTmEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lN07+KR0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6db7a8c6831so17486497b3.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726093513; x=1726698313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4XmBjdboaUqTeMgRqbSdf4DSeJIVFEq/lNcpwN1ftE=;
        b=lN07+KR076rJbAvNKbHXlC+K9jYGDh/m0feLEKennZiE7o/4IMwdIfJpXLgi8ga3fc
         7HG+6DHe+N20ufjbGFaJCGo4ZhHvQUvApUUQZMgOVlTtfDYh2yL+U+QzjE1ihb6YID7f
         3249cpFumZ40IBNEjertayqY9aCkRVVUUJu8aawI3ZNtZqGxHul60PWWHbXu3NcWfiqx
         HKWcTyjOlLDjx+w52vlECO3oRs+nUjOVi4f5YNKb97pEw65Duv13Jzg/dWYojxgoqpfj
         sPTdlpFyCaCPVtryq+GT2FFi10HcazjGsIjDsjPlyDsTQSocaIk+eAHvfiy0c+Tv26JP
         0EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726093513; x=1726698313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4XmBjdboaUqTeMgRqbSdf4DSeJIVFEq/lNcpwN1ftE=;
        b=slirvhrxh2CwwU6DWFRpCJzOPZsCYlPiRlDuiBxKuGkJuOti10pTCsy1054N4knP35
         QacJNGPmd3BXYbmhfTdzqT5xSi7ANW4VovpS+D//eLd7xw0hTCqH9f6kcOnyo1wQCtvh
         z5ON1QvEOFfK3NhVjzTf+J+8whD5RIXixNdATc2o8WQ/Ls9DLVt+h3plUIkcEsJ9VZMT
         80o80+5+WcRsN1x7w1RynDfkcCGQ0muEFYGOBGMu/TQWikObc+Gd57RkPkmnWxxxCiwP
         p5HWywkZPuz6/iGpQOeWbF49mSDMtRltqJPQlU/gENhEpnsffJXlSbdTW8qXM5NwT0Vt
         +Tlw==
X-Gm-Message-State: AOJu0YwUFQ+cznHreOlhFnPdv6syBtdIhnztkB4dAEEOF7MqGVplMZDF
	2s8nGeV/WH65+wtQqKXcC/W9P8yM6woUmvprMZ5uB8H8z4Auzldu2l4SF06KKVKsu2DDkoKKo6l
	xXueP7Bz8KaRmqOq+Thd92BTShHE6NN76E7e5gATA+JLGX9eWBEWIp6prjAqcb7rbo7Le8AXeXF
	UXXEfi8znalKQ51NFupp/v4zWHx4VC8lQTbBVF2fCoBXSLxZUB4ME7MbY=
X-Google-Smtp-Source: AGHT+IHahPlfxq0OnDlBxbNh4kFfba2/NbBP9j+SjDxLZau6fx+NZ8cgucf9q6YqSrrkRp98eVZcQ/vy+HEi7ntE2A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:6083:b0:6c3:e9e5:e6a with
 SMTP id 00721157ae682-6dbb6ba1041mr322647b3.8.1726093512763; Wed, 11 Sep 2024
 15:25:12 -0700 (PDT)
Date: Wed, 11 Sep 2024 22:24:30 +0000
In-Reply-To: <20240911222433.3415301-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911222433.3415301-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911222433.3415301-4-coltonlewis@google.com>
Subject: [PATCH v2 3/5] powerpc: perf: Use perf_arch_instruction_pointer()
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
2.46.0.598.g6f2099f65c-goog


