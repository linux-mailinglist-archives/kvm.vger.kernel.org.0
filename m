Return-Path: <kvm+bounces-54144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D58B1CCC8
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 21:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC4937AF0EF
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA932BEC39;
	Wed,  6 Aug 2025 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="krqFVzHx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0002BE64D
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510256; cv=none; b=D0SmkhYHisFiukhtM6J2yL/4ML4+rjH4y1dc4Op8YIO53bRlb11o8YKnbBeiRcQflb0FkiY+bT91PE/ciCIKyIQw+kqpb5UqJTN89JDfXCe+ct7/DNbdRxg9u0TgCoB0s6hO4VRvjPp5mWRnMRrltlN9YFh2P/6Le97eI+1+7eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510256; c=relaxed/simple;
	bh=jUBl1OA0dbcCe9Exxx/O066eDYx/qkeyxg/XjKFA/3U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=izBSCc09/Y632WssNJgcGEYYnEMBfCCYGWg/bODK2tQfx3p3vDH0I2sHSV5Sf1tuTQCWXaXRj8ScH5BwZHB3GVfwYmqh16hWWHtPqx7T1NHXVPKb7cTe6hJNM33Try1Ve775pTo1R25uqUtIgUdptyCrQ7F1TudFKmvEdUCcAMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=krqFVzHx; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bef13c254so290733b3a.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510252; x=1755115052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3IAofGMjgJOHx6SdMcFjG4jFgSxJevKv5cJ/ErNkHsk=;
        b=krqFVzHx48sFUhkTmv5ZdxVvJJbo9yybHXbJml4FKAfQUxzOY4jH1x4IujuldA6FMr
         C0+zX0xKrvTclXv7jhBwPGfFMBwKz14JTJaEdBZ+70bCTbFbTQ5Xcu0limwYhQffnRT1
         FCaCbpNmWYehwuLFuoJuSmpfOfKEHjXyqoWRlcCcYUhWpxWox9SHW9jhq5ivmdwOnlOi
         M8VHe2C3cxVOVnnB16o4ieO9NP8RP8SSHnDvNPO8i3ftSat6W9nnq7VOVBrTtE1bSHEA
         GW1sz/GYRCc8mL0hoHmzkx1cVT3yt0t/1gWrYDYckq2x7Gw1de223JzLbu7xVcmqkXsS
         Ng6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510252; x=1755115052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3IAofGMjgJOHx6SdMcFjG4jFgSxJevKv5cJ/ErNkHsk=;
        b=q7qPXn73RV8kgW6kX8y1upo8YSBRPsu4/8GYDW8JDwFvYwz/ONpJJOsf42Qt8AvuZS
         VgZ6H1i1chQ5j2TWo4I8H0+I9gsjrkmOcLT2qeWUTLAx1Qh3LOM/9YeFNLvSJnuDwwDj
         da3UfW+CR3fr/BpscGrbQc7JvJ5zGqKZ8nXOaOUEgnuWWAZLYjy4aSRG4vBdFVY7elY6
         G6DhdFjRDdQLpgnZ8Ib9UwJF4e9jvVxNa9Eiwj1mPuwAPuspEONa7NcpYE+TNCy8IaCy
         dH2BprAkflZBQUjfW/3Z2fYFUF4F+X7OKDS0P0GdGB6Yu/0sjhetL0l5jhJVjM6HePg4
         rVew==
X-Forwarded-Encrypted: i=1; AJvYcCWHolLip3IZGsOX17pmdvJZ32/4Dd5K98r9YBgMyRUun+o8cEPmVrMtiurncUMyIqb9vBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYM32ihfyWkjET0+7ibXawdv70QASH0ZalTA7X5h5HkzM6aA01
	ahC8ysWuT4+ZuhgG8seE0C3w8+1cfn6OKl4agUBFEVtJ89wlNlsh9OPVcgXw4dF4cwHLalChpV6
	rbskXtw==
X-Google-Smtp-Source: AGHT+IGg8m1AYQ1T/bkneerdDiI2IWHPXHDhUcioTumR7faJkpYOSLNXQVSuuMxt1I5dkPrSi8WAHfNQ8i8=
X-Received: from pgc3.prod.google.com ([2002:a05:6a02:2f83:b0:b42:2da2:8848])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a103:b0:23f:f712:4103
 with SMTP id adf61e73a8af0-24041364f38mr1167741637.18.1754510252085; Wed, 06
 Aug 2025 12:57:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:24 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-3-seanjc@google.com>
Subject: [PATCH v5 02/44] perf: Add generic exclude_guest support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Only KVM knows the exact time when a guest is entering/exiting. Expose
two interfaces to KVM to switch the ownership of the PMU resources.

All the pinned events must be scheduled in first. Extend the
perf_event_sched_in() helper to support extra flag, e.g., EVENT_GUEST.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d4528554528d..3a98e11d8efc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2866,14 +2866,15 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 
 static void perf_event_sched_in(struct perf_cpu_context *cpuctx,
 				struct perf_event_context *ctx,
-				struct pmu *pmu)
+				struct pmu *pmu,
+				enum event_type_t event_type)
 {
-	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_PINNED);
+	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_PINNED | event_type);
 	if (ctx)
-		 ctx_sched_in(ctx, pmu, EVENT_PINNED);
-	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, pmu, EVENT_PINNED | event_type);
+	ctx_sched_in(&cpuctx->ctx, pmu, EVENT_FLEXIBLE | event_type);
 	if (ctx)
-		 ctx_sched_in(ctx, pmu, EVENT_FLEXIBLE);
+		ctx_sched_in(ctx, pmu, EVENT_FLEXIBLE | event_type);
 }
 
 /*
@@ -2929,7 +2930,7 @@ static void ctx_resched(struct perf_cpu_context *cpuctx,
 	else if (event_type & EVENT_PINNED)
 		ctx_sched_out(&cpuctx->ctx, pmu, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, task_ctx, pmu);
+	perf_event_sched_in(cpuctx, task_ctx, pmu, 0);
 
 	for_each_epc(epc, &cpuctx->ctx, pmu, 0)
 		perf_pmu_enable(epc->pmu);
@@ -4147,7 +4148,7 @@ static void perf_event_context_sched_in(struct task_struct *task)
 		ctx_sched_out(&cpuctx->ctx, NULL, EVENT_FLEXIBLE);
 	}
 
-	perf_event_sched_in(cpuctx, ctx, NULL);
+	perf_event_sched_in(cpuctx, ctx, NULL, 0);
 
 	perf_ctx_sched_task_cb(cpuctx->task_ctx, task, true);
 
-- 
2.50.1.565.gc32cd1483b-goog


