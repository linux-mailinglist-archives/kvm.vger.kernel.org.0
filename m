Return-Path: <kvm+bounces-54149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F46B1CCD2
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 21:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C89DA1891A9B
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCADA2BEC44;
	Wed,  6 Aug 2025 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i8IBTCHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10B2C15BD
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510265; cv=none; b=pjKgON9kF71rzI7S4EnesCXkZfXfMwopLZ+soVMMzqy61TfDEgTMUiLWfkrtt/KHMw9DCoRjJ5dFKK0XW6+HgAQrwhH7l78uFizpsKMHp5aH6XNpDXDW3nvZmzYp41NF90kmskb7ynT83YTTv6uod2Sl+pXFPgfeXKNFLQ68LNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510265; c=relaxed/simple;
	bh=p9dwRoIkAdNKqXS3ork0V3QcmE8t7/wykyfY7BDBXjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HIZ2957u04JC14bm8Asq7476cIBac7ecjJHan6ZPocvdmVmdwgorC+4W7YHwAXQIVu8dWG8z1nRaSLpJp8OpjNlCC0ELcMiwfWzSVVa9x6D24eXjD9oIaSiRZC4CBFErSgZ1RJdTTSF5ynv3F7lJh4DjXxmPG+414sAcieu6U4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i8IBTCHs; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24249098fd0so2371975ad.0
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510261; x=1755115061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1cgAGvW2Sa5tNwASy1Md3TT+4FZc1wpWNQfNLgFp1cE=;
        b=i8IBTCHsEt2DrcIcxVFbp7SFIHxRMBVKZRXNlv/Q/OQyKdNwpIdP2db8o7nwlILQTK
         QuBOlCA7EPm3sQ6zh+Ss1qlwCp5NrB9BPwMNlIRBQrUQSQ9ioC3tM1VaKbcXHyk6snqd
         hmXG7JGUCTvbHS6fpouMnHMYIHSPsl/9lmsPqc9U5Pft9REnjvnuhXAs/kVIzTydoauk
         ol6Gl5XL9veybgYrnhyj9jS/RgHO4kUfNU2+bp0KYPkkERRQ1/BWcXGfPWwVi9wjT41J
         QDtvF4djT+6eu1kP6aR7CzKHhr57d0b1TfkAMPhHLqV14Umg+NWAmNN/XmLEPeyXN8Un
         2pNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510261; x=1755115061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1cgAGvW2Sa5tNwASy1Md3TT+4FZc1wpWNQfNLgFp1cE=;
        b=YcyYk1kBOkAC3GOft6uptPOpwx4xoClwzjU8HYi5ECvk309dqNDM4HxEfCHi7+VP4f
         D+fWiItSHZH2dVzI0a0xxz76dD2SrkV8tnQ1i8PDde9nuN4WqqFCQYX2zCdzRrkT4fRx
         15Iev5307ZytnCK+8KFDKzzw+VRnbkwgbHlP8CrOucuJDo+yVjnDNEv0hKKKf4skNd8j
         VNMKKiFhh8Gv+rtVp7pQjWSjs/IxOMklhqsP68UFPPyA2JyxAPLCbJnJnN+/RR1I5F8k
         ZJSR1yxXf8T5m9EIC812pH3KoaUTBRap5hapuoeFC7YCTkIp534EUytkEyzjSVyphZvs
         jdNA==
X-Forwarded-Encrypted: i=1; AJvYcCWiXLivuEqB1p3MIesoeS/xfnBv1pxdLFRRDWe4bR5/KB07+lRzcjkXgG3rcSBZZIPOUjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDqU9fGTbtMYRbjfTiOp6lGuLCiPb8oj+168GWz9QU1BxrPgrT
	qflU89ec5xVfbincmafT6IQ14C2PMr0xsTEEnyfhx823Nr16wYMPS1n42+JAGeqB3DhD70/Dx6u
	PV+nu7A==
X-Google-Smtp-Source: AGHT+IEQshj25YWfgh8jlPDalwm585npWoyFxUPXBG4oqUn1ilItXjqTi+CTUz913BcUQcsY19RFz/4rdM8=
X-Received: from plrj9.prod.google.com ([2002:a17:903:289:b0:242:abd5:b3bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c405:b0:240:b879:fed2
 with SMTP id d9443c01a7336-2429f55daaamr65961135ad.16.1754510261485; Wed, 06
 Aug 2025 12:57:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:29 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-8-seanjc@google.com>
Subject: [PATCH v5 07/44] perf: Add APIs to load/put guest mediated PMU context
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

Add exported APIs to load/put a guest mediated PMU context.  KVM will
load the guest PMU shortly before VM-Enter, and put the guest PMU shortly
after VM-Exit.

On the perf side of things, schedule out all exclude_guest events when the
guest context is loaded, and schedule them back in when the guest context
is put.  I.e. yield the hardware PMU resources to the guest, by way of KVM.

Note, perf is only responsible for managing host context.  KVM is
responsible for loading/storing guest state to/from hardware.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: shuffle patches around, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h |  2 ++
 kernel/events/core.c       | 61 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0958b6d0a61c..42d019d70b42 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1925,6 +1925,8 @@ extern u64 perf_event_pause(struct perf_event *event, bool reset);
 #ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
 int perf_create_mediated_pmu(void);
 void perf_release_mediated_pmu(void);
+void perf_load_guest_context(unsigned long data);
+void perf_put_guest_context(void);
 #endif
 
 #else /* !CONFIG_PERF_EVENTS: */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6875b56ddd6b..77398b1ad4c5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -469,10 +469,19 @@ static cpumask_var_t perf_online_pkg_mask;
 static cpumask_var_t perf_online_sys_mask;
 static struct kmem_cache *perf_event_cache;
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+static DEFINE_PER_CPU(bool, guest_ctx_loaded);
+
+static __always_inline bool is_guest_mediated_pmu_loaded(void)
+{
+	return __this_cpu_read(guest_ctx_loaded);
+}
+#else
 static __always_inline bool is_guest_mediated_pmu_loaded(void)
 {
 	return false;
 }
+#endif
 
 /*
  * perf event paranoia level:
@@ -6379,6 +6388,58 @@ void perf_release_mediated_pmu(void)
 	atomic_dec(&nr_mediated_pmu_vms);
 }
 EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
+
+/* When loading a guest's mediated PMU, schedule out all exclude_guest events. */
+void perf_load_guest_context(unsigned long data)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(__this_cpu_read(guest_ctx_loaded)))
+		return;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
+	}
+
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx)
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+
+	__this_cpu_write(guest_ctx_loaded, true);
+}
+EXPORT_SYMBOL_GPL(perf_load_guest_context);
+
+void perf_put_guest_context(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(!__this_cpu_read(guest_ctx_loaded)))
+		return;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx)
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, NULL, EVENT_GUEST);
+
+	if (cpuctx->task_ctx)
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+
+	__this_cpu_write(guest_ctx_loaded, false);
+}
+EXPORT_SYMBOL_GPL(perf_put_guest_context);
 #else
 static int mediated_pmu_account_event(struct perf_event *event) { return 0; }
 static void mediated_pmu_unaccount_event(struct perf_event *event) {}
-- 
2.50.1.565.gc32cd1483b-goog


