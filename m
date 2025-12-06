Return-Path: <kvm+bounces-65402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 808F0CA9B2E
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 376FE3248284
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4521FC110;
	Sat,  6 Dec 2025 00:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DskE6ray"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DC8252906
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980266; cv=none; b=k9kHMPtKP9Dl+AVd1BRgWPRm41G73Jfjtbd/vKuG1+Rcq2+zUPuwziDphOyCsXMZQ7KYYxD6iL0llLKh4DeKZcH13STaf/Ubvnt6ijU6K2m7iDzOaMWRig129a8Q08KZwgC8dYgl4PqomrDgsBplJbXJPcl5F85uvBpisgMVIqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980266; c=relaxed/simple;
	bh=tgwd5Esq4wpmewehCZ8NiFmYgLVHlgDnHG/ez6ZtIJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ra9XNhYHxohQ9VJ8QLpX173Ti7y53osDoC87ftgkiCKq85GDzpFZXFf2sIV+tUzpk/sFh+1U9YnyaqQ14op/Nq60zkBjDO56iL9edAEHWf0oLbACPtitVFL9rCknUsfogEU2bnS5wSvPg2pPOdxltmwg5xHjQ/k1L78yUWWiGLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DskE6ray; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34566e62f16so3089736a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980264; x=1765585064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=b3rwpX75fYsvQxObK18NSjc+CmweVuoOUNJF4J3Ucww=;
        b=DskE6rayxgJCh16+iTeDIsI6fXNSQV0iczfaKlwm732BE5bWrN0W6QysFfPAUmI4Da
         /J1pjEhNq+8Mr4Q4IsCNlIujltCq2SoTosP4xHZhE8OzNjbAvWpWEIu91FsOtBwwJodZ
         gtOZ3uhqjzObJ9526oouzRVw/77Iz5JCMl4MP4Z6nOWKFsXIF6ZVbYC/polyYmGYRlTK
         30XwYKCyZxuVsQ5e7tPgc1OwNDcEVGAdUpaKCKofcby/Ju7hbz2cy7tUVyiaIVDVNdsB
         m9QOG9fQ0vzQQSRhsgn41XKb1XJ67QDLhShOxozCsNcAAdIJI3qfdIi0prXdmtDkepTv
         T5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980264; x=1765585064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b3rwpX75fYsvQxObK18NSjc+CmweVuoOUNJF4J3Ucww=;
        b=iqCnZJn/4GEiJtT9LXDm56NMvLxTfL2VCez2ll9SYhw29YGnuzFmbfWq8u0044tbMG
         lsK26J6S+5NJy8N0H76dU42FX7QBBfyMup8z5dm/gYuN5WN3sH7IGE2LL+gjf2xMKOOz
         55QlPDpcD/mbHXagrUhRzaF/jdf57oHRr+9v8F4hpuQi1EsAzXj/UXwILYLMP/SThOdb
         pzwWsxwGXxg9pkuF3bVTi3wRleENXdaKgW2goR5OGCmpmai2nwpeudVbri15GRtqZ7Gh
         RxJQQV0os+QlAPX8tQsm/lOvdE2cpjdACNsChHtyDQOINpXUZE/An9nTOIdlCRHqKXwZ
         hepw==
X-Forwarded-Encrypted: i=1; AJvYcCV45wLQTtRJWv4eXl9kmmFHavclqUUUxYy1GnSTxsV4YNKmpM0g21V3pjOaWfHGPQh8Ra0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBkzvR4fhPK1QPJHCHIZaEwyctYSL+1vqr88pwsaJ+5dvAQ3pT
	MOtq+PzixIrlXV7UxadgxHn1o7fWsbg8ndZN7KE5OmJd1hsaBZCY+LzOUkC7pJXDJ5Q2lXZ8O51
	Mn8cdLg==
X-Google-Smtp-Source: AGHT+IHEsD7fkDDlHKveCIETTAnzxygk5RYBYlDb1QrkU4F4qH52QVESGYT3XJZIm6BuCoPrCdtcsD42SZs=
X-Received: from pjbbf17.prod.google.com ([2002:a17:90b:b11:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2750:b0:349:9dc4:fa35
 with SMTP id 98e67ed59e1d1-349a2622069mr652583a91.25.1764980263863; Fri, 05
 Dec 2025 16:17:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:45 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-10-seanjc@google.com>
Subject: [PATCH v6 09/44] perf/x86/core: Add APIs to switch to/from mediated
 PMI vector (for KVM)
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

Add APIs (exported only for KVM) to switch PMIs to the dedicated mediated
PMU IRQ vector when loading guest context, and back to perf's standard NMI
when the guest context is put.  I.e. route PMIs to
PERF_GUEST_MEDIATED_PMI_VECTOR when the guest context is active, and to
NMIs while the host context is active.

While running with guest context loaded, ignore all NMIs (in perf).  Any
NMI that arrives while the LVTPC points at the mediated PMU IRQ vector
can't possibly be due to a host perf event.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c            | 32 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_event.h |  5 +++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index fa6c47b50989..abe6a129a87f 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -55,6 +55,8 @@ DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events) = {
 	.pmu = &pmu,
 };
 
+static DEFINE_PER_CPU(bool, guest_lvtpc_loaded);
+
 DEFINE_STATIC_KEY_FALSE(rdpmc_never_available_key);
 DEFINE_STATIC_KEY_FALSE(rdpmc_always_available_key);
 DEFINE_STATIC_KEY_FALSE(perf_is_hybrid);
@@ -1749,6 +1751,25 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+void perf_load_guest_lvtpc(u32 guest_lvtpc)
+{
+	u32 masked = guest_lvtpc & APIC_LVT_MASKED;
+
+	apic_write(APIC_LVTPC,
+		   APIC_DM_FIXED | PERF_GUEST_MEDIATED_PMI_VECTOR | masked);
+	this_cpu_write(guest_lvtpc_loaded, true);
+}
+EXPORT_SYMBOL_FOR_MODULES(perf_load_guest_lvtpc, "kvm");
+
+void perf_put_guest_lvtpc(void)
+{
+	this_cpu_write(guest_lvtpc_loaded, false);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+}
+EXPORT_SYMBOL_FOR_MODULES(perf_put_guest_lvtpc, "kvm");
+#endif /* CONFIG_PERF_GUEST_MEDIATED_PMU */
+
 static int
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
@@ -1756,6 +1777,17 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 	u64 finish_clock;
 	int ret;
 
+	/*
+	 * Ignore all NMIs when the CPU's LVTPC is configured to route PMIs to
+	 * PERF_GUEST_MEDIATED_PMI_VECTOR, i.e. when an NMI time can't be due
+	 * to a PMI.  Attempting to handle a PMI while the guest's context is
+	 * loaded will generate false positives and clobber guest state.  Note,
+	 * the LVTPC is switched to/from the dedicated mediated PMI IRQ vector
+	 * while host events are quiesced.
+	 */
+	if (this_cpu_read(guest_lvtpc_loaded))
+		return NMI_DONE;
+
 	/*
 	 * All PMUs/events that share this PMI handler should make sure to
 	 * increment active_events for their events.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 49a4d442f3fc..4cd38b9da0ba 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -651,6 +651,11 @@ static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+extern void perf_load_guest_lvtpc(u32 guest_lvtpc);
+extern void perf_put_guest_lvtpc(void);
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
-- 
2.52.0.223.gf5cc29aaa4-goog


