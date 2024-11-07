Return-Path: <kvm+bounces-31150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4299C0E54
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 516581C2274D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 19:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED806218927;
	Thu,  7 Nov 2024 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iu/pKJab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1776A217F4C
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 19:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006272; cv=none; b=ZJHrzE48FagnUzjjJrnibgsnRViU9qjdH5phrHn8K3M0PWdzDVHhsx6AMoPCb00rnCBj10d3facPfNhE2+3bAYeimaRpdG+AUxH5et3EXMKN3IbdwVtK4cxv1bfLDKzoGewkshWkYDis0I62BcR/vZ6wGCH+IdaWghilBnBmqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006272; c=relaxed/simple;
	bh=1Re1Qmn2xqkTcxE4kgLz4OOHluPeURBKwUWonyc3oA8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EnF6kmEepdkX+mpvfkpkbyqkiElAr5YOlrhkU2xJ9n3yUzBwmmMb877XZ+bB4S37lLiZuTtFq631G3cVUiOpW4SA+e/QKoopcEbSdtKxkZ7EcpBtSs41pTjn05l8+SsZKqwXj+k9HMQga/ItQmQmeWUBL7/fmdSKIcPcgszSksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iu/pKJab; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a3c9886eccso15307085ab.2
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 11:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731006269; x=1731611069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nMMU6XVNr2hZZbXBXpeZIOveQYdt9smU5ZS15hc1ZTw=;
        b=Iu/pKJabjuROPzxb+e+AID5U5mQlJycuSjDd9PV4K705wc5RY9+DUnIZDDR/TCjfPd
         ekHOXiBnI/ufgeLQ4kRSGIymKH1kZhXmyv93aSfLgd6YQ0OK8+9UoARcWPv+y8Y0pm2S
         hn2TVbsV3pTtQeRLfOD+zCLOzg8c0wN1cKCQLxBopXc67gq0x5M00als6iyfMaTB66Kd
         4o7mIB2Fkx9QefxZNaaosOfTXda7EIDM1GDtENFqeQeMcRTrG6XFiPzSTF1alt42C5fH
         ufuZx3vnCKuGMvk1xroYs3R65XYA73qbESSvLvan/ucX/imrmTzgqCVtgZXsAilCW9uB
         rHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731006269; x=1731611069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMMU6XVNr2hZZbXBXpeZIOveQYdt9smU5ZS15hc1ZTw=;
        b=Vi8StkxBP3hvQrtFeQXGYTkdneHI0fVAhPaJqUqfjrS2O2z++E+Vem9s0YBDSvHHTH
         AMgVqTERfNi0QTJRE2Pc68Xb1GGTCv8GhLboUC9vWbpvQUE+Vj3G0JvEOzblnn4xR942
         VBg9EafgushQqZPgD9QOAZSTwDcyLb6FN8+Wz47+FcNHNPZ8DgV8Sa+Hqldrb6TDMB0X
         VtI6EGvTtvJYzdsYA1v30vS/U29m1oS9inHBIZXu3jnxn/9+N4BQEpj3sCx9ZFiRM93v
         FPZ7ybpDVPtk3R4KVI7IiPjFhZKvH4FY3q3nZU/bAoIE/SkWgMq/tnDJBL0zTwTgsMoi
         CahQ==
X-Gm-Message-State: AOJu0YwZDPQe7DUnuhuV7VV2Y27740uWRBqt7qQBUmgjxiOHBVNonnQk
	Qs59tkAZoq7n+BjY3qCjfto2VyiWqzETAqkzUBhLfmB6i60IHRz9ZNggmZ5FXgNoE46F7VlJR2N
	fDUcaJINFExjljcv38TimLsy8y8fRRSEHFeOyeTve3RcB2ddOvaWqeEDA4PxA5QAnurUzED/jPf
	vPEc2wwx8Hz1nQ25d4U50GKchSQ7ArSq1ys+R4BOci3RcAGNjcFw52zKo=
X-Google-Smtp-Source: AGHT+IGk8o1Kolvzif7abhodsa0UQDRBeg0LTLwxblT9qcEU5Wpk1+d5hb0oOxJJFfemEOegIAlQ+QjJB899aR6iQA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a92:c24a:0:b0:3a3:4377:bafd with SMTP
 id e9e14a558f8ab-3a6f1a71786mr28105ab.5.1731006268975; Thu, 07 Nov 2024
 11:04:28 -0800 (PST)
Date: Thu,  7 Nov 2024 19:03:36 +0000
In-Reply-To: <20241107190336.2963882-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107190336.2963882-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107190336.2963882-6-coltonlewis@google.com>
Subject: [PATCH v7 5/5] perf: Correct perf sampling with guest VMs
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

Previously any PMU overflow interrupt that fired while a VCPU was
loaded was recorded as a guest event whether it truly was or not. This
resulted in nonsense perf recordings that did not honor
perf_event_attr.exclude_guest and recorded guest IPs where it should
have recorded host IPs.

Rework the sampling logic to only record guest samples for events with
exclude_guest = 0. This way any host-only events with exclude_guest
set will never see unexpected guest samples. The behaviour of events
with exclude_guest = 0 is unchanged.

Note that events configured to sample both host and guest may still
misattribute a PMI that arrived in the host as a guest event depending
on KVM arch and vendor behavior.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/perf_event.h |  4 ----
 arch/arm64/kernel/perf_callchain.c  | 28 ----------------------------
 arch/x86/events/core.c              | 16 ++++------------
 include/linux/perf_event.h          | 21 +++++++++++++++++++--
 kernel/events/core.c                | 21 +++++++++++++++++----
 5 files changed, 40 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 31a5584ed423..ee45b4e77347 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -10,10 +10,6 @@
 #include <asm/ptrace.h>
 
 #ifdef CONFIG_PERF_EVENTS
-struct pt_regs;
-extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
-extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
-#define perf_arch_misc_flags(regs)	perf_misc_flags(regs)
 #define perf_arch_bpf_user_pt_regs(regs) &regs->user_regs
 #endif
 
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 01a9d08fc009..9b7f26b128b5 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -38,31 +38,3 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 
 	arch_stack_walk(callchain_trace, entry, current, regs);
 }
-
-unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
-{
-	if (perf_guest_state())
-		return perf_guest_get_ip();
-
-	return instruction_pointer(regs);
-}
-
-unsigned long perf_arch_misc_flags(struct pt_regs *regs)
-{
-	unsigned int guest_state = perf_guest_state();
-	int misc = 0;
-
-	if (guest_state) {
-		if (guest_state & PERF_GUEST_USER)
-			misc |= PERF_RECORD_MISC_GUEST_USER;
-		else
-			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
-	} else {
-		if (user_mode(regs))
-			misc |= PERF_RECORD_MISC_USER;
-		else
-			misc |= PERF_RECORD_MISC_KERNEL;
-	}
-
-	return misc;
-}
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 9fdc5fa22c66..d85e12ca4263 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3005,9 +3005,6 @@ static unsigned long code_segment_base(struct pt_regs *regs)
 
 unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
 {
-	if (perf_guest_state())
-		return perf_guest_get_ip();
-
 	return regs->ip + code_segment_base(regs);
 }
 
@@ -3035,17 +3032,12 @@ unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
 
 unsigned long perf_arch_misc_flags(struct pt_regs *regs)
 {
-	unsigned int guest_state = perf_guest_state();
 	unsigned long misc = common_misc_flags(regs);
 
-	if (guest_state) {
-		misc |= perf_arch_guest_misc_flags(regs);
-	} else {
-		if (user_mode(regs))
-			misc |= PERF_RECORD_MISC_USER;
-		else
-			misc |= PERF_RECORD_MISC_KERNEL;
-	}
+	if (user_mode(regs))
+		misc |= PERF_RECORD_MISC_USER;
+	else
+		misc |= PERF_RECORD_MISC_KERNEL;
 
 	return misc;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 772ad352856b..368ea0e9577c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1655,8 +1655,9 @@ extern void perf_tp_event(u16 event_type, u64 count, void *record,
 			  struct task_struct *task);
 extern void perf_bp_event(struct perf_event *event, void *data);
 
-extern unsigned long perf_misc_flags(struct pt_regs *regs);
-extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_misc_flags(struct perf_event *event, struct pt_regs *regs);
+extern unsigned long perf_instruction_pointer(struct perf_event *event,
+					      struct pt_regs *regs);
 
 #ifndef perf_arch_misc_flags
 # define perf_arch_misc_flags(regs) \
@@ -1667,6 +1668,22 @@ extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 # define perf_arch_bpf_user_pt_regs(regs) regs
 #endif
 
+#ifndef perf_arch_guest_misc_flags
+static inline unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
+{
+	unsigned long guest_state = perf_guest_state();
+
+	if (!(guest_state & PERF_GUEST_ACTIVE))
+		return 0;
+
+	if (guest_state & PERF_GUEST_USER)
+		return PERF_RECORD_MISC_GUEST_USER;
+	else
+		return PERF_RECORD_MISC_GUEST_KERNEL;
+}
+# define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
+#endif
+
 static inline bool has_branch_stack(struct perf_event *event)
 {
 	return event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2c44ffd6f4d8..c62164a2ff23 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7022,13 +7022,26 @@ void perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 #endif
 
-unsigned long perf_misc_flags(struct pt_regs *regs)
+static bool should_sample_guest(struct perf_event *event)
 {
+	return !event->attr.exclude_guest && perf_guest_state();
+}
+
+unsigned long perf_misc_flags(struct perf_event *event,
+			      struct pt_regs *regs)
+{
+	if (should_sample_guest(event))
+		return perf_arch_guest_misc_flags(regs);
+
 	return perf_arch_misc_flags(regs);
 }
 
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
+unsigned long perf_instruction_pointer(struct perf_event *event,
+				       struct pt_regs *regs)
 {
+	if (should_sample_guest(event))
+		return perf_guest_get_ip();
+
 	return perf_arch_instruction_pointer(regs);
 }
 
@@ -7849,7 +7862,7 @@ void perf_prepare_sample(struct perf_sample_data *data,
 	__perf_event_header__init_id(data, event, filtered_sample_type);
 
 	if (filtered_sample_type & PERF_SAMPLE_IP) {
-		data->ip = perf_instruction_pointer(regs);
+		data->ip = perf_instruction_pointer(event, regs);
 		data->sample_flags |= PERF_SAMPLE_IP;
 	}
 
@@ -8013,7 +8026,7 @@ void perf_prepare_header(struct perf_event_header *header,
 {
 	header->type = PERF_RECORD_SAMPLE;
 	header->size = perf_sample_data_size(data, event);
-	header->misc = perf_misc_flags(regs);
+	header->misc = perf_misc_flags(event, regs);
 
 	/*
 	 * If you're adding more sample types here, you likely need to do
-- 
2.47.0.277.g8800431eea-goog


