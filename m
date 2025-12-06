Return-Path: <kvm+bounces-65396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4A8CA9B07
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4D9CF3011B2A
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65389230D35;
	Sat,  6 Dec 2025 00:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pVau5ElV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D66A21CC68
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980256; cv=none; b=t9xNS6iPjy0vQCDQw4YAmTUOdW9D0XDHxXaHk+PkNCx6Jbib+YhkMq5aNPEFhqWO4qp4/iHA980Tx+zIsEYsSTFuTIs9ta6h6vpADopuQTr2vYubugsafFkqmqAgAUI2ytXffSJzHxh/F9AfYnLoqv/rtL7lOwY/Xb7z/f3EMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980256; c=relaxed/simple;
	bh=LI1sDcOO4Y4+JFloEIGoQdv+YZQhyxul+6jzUgodhT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CEoe15oy8uX9Pb0Q0AwD0aUN6do6YvHNJZMhi0SLGCRZWxxLkuiNl3FGdrlj2uWjG42BLMOfImn/vLX/ggkf0MMC2QZMgn8Ys2W/ZOuM4PBAE1rl0prnhuGvUpIVJSt2haKj6b3Y0kE8kUlvtpNT6dTRBkQbYaukQDRElLF1xXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pVau5ElV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b90740249dso4095148b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980253; x=1765585053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8zDbYh8g4andZgSq5KjxfJP+Yx1X56NwE8CC/T+SiEI=;
        b=pVau5ElVfZwx0/su8cO5Rqh691AFnnWz6RrzYp3Sy65JPI1sKLjj3nW7KYdYWSmgsA
         wqN6uooeeNSfiSWQFYEKWRKU9ZwvgOCJBkSzZIj08kSsx/88FS4ffQzGkIwZoDTYK2fe
         YJIMyGVKJKi5DgVWO1duCxNlrtonrWGH83SxF98yGTP5vVDKUHMvdqQZABZ36WTJ29iL
         RI5r+azoW8h5jtBTj9Xq5a58S16XF3XksydgNWse0hYPABjSLnLJS5pjFaYDr/N18kw3
         ozAvHONmGu+4ouR4dU08quepnzo35TueGFCL97Yv3oFX4i5vB0N70+o+A0xMxMmtCF/0
         Iiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980253; x=1765585053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8zDbYh8g4andZgSq5KjxfJP+Yx1X56NwE8CC/T+SiEI=;
        b=K90e1d7XPiTwLTd7IHHswBf8ijD3jHTc4O3phtmqS45+b6PtYR5FmqIoW34oj4Wqs2
         Mh1RBh42RT+7x3KO41yywP5PwcjW5hbfJbt9kURkk9VVgEfjvZnE9PajAntFzMjJhQ8R
         KXh/4R9E7+cc+IW3UncnKPg3Pl6onK/ApNcjhReunaQFCKuKwboOQhPusNvdkT3BAfeT
         axja5ef8QiA1ThIau4MymRmD0mMmfHvhkf1us90TaAuxtl4J0/YDlalGhKddvUFIDhh/
         4SbQlWgN0Bgmtz1SDnph4JvA6G35leJMeu9mDQkszDsF59Gf/Yj3+uWqK9IPjLAXWorb
         u0ww==
X-Forwarded-Encrypted: i=1; AJvYcCUchb/dFN4FHV/5en+dZxZPCbSAafb9G9yQ40kXLrdRdX/nVMNlSYytwNQ+aCiN6AnCD8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCUxh1D6VssFQKWuZtKWO9w2Qmrx50KgxoPJd3a95+INh49YX6
	6X3z/Ho8Y2Qk0eDQmkbSAwFlwUEJYl8qH1P6i/TH8ZPSRQKnBBCR9g6ENwCWcnkjeT4vNoaxuME
	NiW0cTg==
X-Google-Smtp-Source: AGHT+IF/oM705F739LTH8aiHz6AKpqWGtQrIi8ngNpofrp5S2I+xWIdijTs20meiR96WS9wVH7kHD0C0BxI=
X-Received: from pgce2.prod.google.com ([2002:a05:6a02:1c2:b0:bd0:79b2:aa3f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7b23:b0:366:1880:7e06
 with SMTP id adf61e73a8af0-36618807e8dmr621575637.0.1764980252791; Fri, 05
 Dec 2025 16:17:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:39 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-4-seanjc@google.com>
Subject: [PATCH v6 03/44] perf: Move security_perf_event_free() call to __free_event()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the freeing of any security state associated with a perf event from
_free_event() to __free_event(), i.e. invoke security_perf_event_free() in
the error paths for perf_event_alloc().  This will allow adding potential
error paths in perf_event_alloc() that can occur after allocating security
state.

Note, kfree() and thus security_perf_event_free() is a nop if
event->security is NULL, i.e. calling security_perf_event_free() even if
security_perf_event_alloc() fails or is never reached is functionality ok.

Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1e37ab90b815..e34112df8b31 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5602,6 +5602,8 @@ static void __free_event(struct perf_event *event)
 {
 	struct pmu *pmu = event->pmu;
 
+	security_perf_event_free(event);
+
 	if (event->attach_state & PERF_ATTACH_CALLCHAIN)
 		put_callchain_buffers();
 
@@ -5665,8 +5667,6 @@ static void _free_event(struct perf_event *event)
 
 	unaccount_event(event);
 
-	security_perf_event_free(event);
-
 	if (event->rb) {
 		/*
 		 * Can happen when we close an event with re-directed output.
-- 
2.52.0.223.gf5cc29aaa4-goog


