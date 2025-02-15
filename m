Return-Path: <kvm+bounces-38267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8497FA36B1F
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C13B87A4B2E
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417511662E7;
	Sat, 15 Feb 2025 01:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xwc9Utgg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28F015198A
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583422; cv=none; b=YZw8cvUr1T3GUZ9aCaYnxJNtPP0B0gR0nOt3rGBv2l89k4T2TJRR/pq272Inr7aAzSj0n6nG7aNR7MHSx21UCXCgVJaECbpAQls4R+tEdiEhbItyV/AEQsFppToSHfFYwrtI+eRtK5Xq7UW//JDAZUzlm0qQqInApwF2AeDtjys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583422; c=relaxed/simple;
	bh=wBwAxyjsDrm8M/5EHri0mYdbIjJnF/Fry25zvkMdd5w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MxxwiQOO8hAbDGVWPF529qODPZZHIz9ASJPc68fI4TcuEkx7ZbmsSH6bxkXfx8dOamvivfvWyc43/VBqfBcudz6YyOYkh+jXxakdwxA6mMU55t/djBQAOF7FoNopJyoqhzhCjgO6wjJqng5+08CXf+7/KMwdX6njybuumEE30UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xwc9Utgg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05bb5so5566868a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583420; x=1740188220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YkUiJlep8I7i+PvVaAgfcU9+5xfY1Qig4zfPpSQ/FZ8=;
        b=xwc9UtggMdQSbRREO7yFZmmB+0Mmy+vxf6gC/nh21rnHuUkGAYqPSyk9UQRCBA7eEu
         vhbeieGaFJPpfj2LfZ8ZnhBBeEbFLtZpk8clIvFRctYpaw1v364p5ZM8NneU656MQGPz
         Qr8pv2lZNPGh9kv03cYknuEjMi1uGf7BQHcBNf6+U2dClgz1X2YH1EsbPNbf0H0OkZbW
         jZJVSdN24hje3U70BrFVDZ/ZxLvGAB/w6jgmGnAGKKnznpmbk3URH2crGYRyS4pq6rlr
         D7WegZ2FBhHZfnyHiKrmG9zCJV14YU00Zo/Xjb+Jqsv2suWkBjoYlzNYQvko0pWNBHgG
         OIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583420; x=1740188220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YkUiJlep8I7i+PvVaAgfcU9+5xfY1Qig4zfPpSQ/FZ8=;
        b=nhVTThRHrKTf/W7SgJz1pLBoVPx1jyB9XIHoBpL5MDH+SS9NcDz75AVtu/n0GsCOlh
         e8MSabDeK7zDmA+RU6a0KMcUe42e2fN+/hsUJXlcWrvwZR0OBCDshvK74MlBMiNVTAx9
         lipeacr+zgkxjJMzFtRzbWPLt/0bIEMgCAaJDAZy28pF+cYELxthp7HFXGdWjxTcqgqW
         GGYeY8jYXbfNYf6kS3xF2LTM2ssswz8VCac50nJK1wiCWWeopcRqvHJAedcBOHR3yvKg
         x+g3zjPKV+kti3tewvT9NlgcJ6BV3WzD1ICWyg7G2QTkPHNzOyhdLnZ3ok9wjcEbj6NC
         zVww==
X-Gm-Message-State: AOJu0Yx5Qh+EJiAxTrR0Kl2j5Bvk16e6uotWQXCdAG+0SYEO1SOKUPzr
	BixhaqfGUovlZCoKmwRBo38ETFDqT7eTcFl7X9uRIBaQ3/5Vg3NFS+SpT8mlQyWS0bXMMBCw4/G
	gaA==
X-Google-Smtp-Source: AGHT+IEcZeQge10kD/WMvfM49zRkZd3xDwc3xoewhKncK3wrROwLQ+0EvvBTUQZqBzgI7VZP7BKyZmlQJLQ=
X-Received: from pjbqo15.prod.google.com ([2002:a17:90b:3dcf:b0:2eb:12d7:fedd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e05:b0:2fa:1e3e:9be5
 with SMTP id 98e67ed59e1d1-2fc407915edmr2468148a91.0.1739583420207; Fri, 14
 Feb 2025 17:37:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:30 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-14-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 13/18] x86: pmu: Improve instruction and
 branches events verification
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
__precise_count_loop(). Thus, instructions and branches events can be
verified against a precise count instead of a rough range.

Unfortunately, AMD CPUs count VMRUN as a branch instruction in guest
context, which leads to intermittent failures as the counts will vary
depending on how many asynchronous exits occur while running the measured
code, e.g. if the host takes IRQs, NMIs, etc.

So only enable this precise check for Intel processors.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/all/6d512a14-ace1-41a3-801e-0beb41425734@amd.com
[sean: explain AMD VMRUN behavior, use "INSNS"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 06d867d9..217ab938 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,6 +19,10 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
+/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
+#define EXTRA_INSNS  (3 + 3)
+#define LOOP_INSNS   (N * 10 + EXTRA_INSNS)
+#define LOOP_BRANCHES  (N)
 #define LOOP_ASM(_wrmsr)						\
 	_wrmsr "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
@@ -123,6 +127,27 @@ static inline void loop(u64 cntrs)
 		__precise_loop(cntrs);
 }
 
+static void adjust_events_range(struct pmu_event *gp_events,
+				int instruction_idx, int branch_idx)
+{
+	/*
+	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
+	 * moved in __precise_loop(). Thus, instructions and branches events
+	 * can be verified against a precise count instead of a rough range.
+	 *
+	 * Skip the precise checks on AMD, as AMD CPUs count VMRUN as a branch
+	 * instruction in guest context, which* leads to intermittent failures
+	 * as the counts will vary depending on how many asynchronous VM-Exits
+	 * occur while running the measured code, e.g. if the host takes IRQs.
+	 */
+	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
+		gp_events[instruction_idx].min = LOOP_INSNS;
+		gp_events[instruction_idx].max = LOOP_INSNS;
+		gp_events[branch_idx].min = LOOP_BRANCHES;
+		gp_events[branch_idx].max = LOOP_BRANCHES;
+	}
+}
+
 volatile uint64_t irq_received;
 
 static void cnt_overflow(isr_regs_t *regs)
@@ -833,6 +858,9 @@ static void check_invalid_rdpmc_gp(void)
 
 int main(int ac, char **av)
 {
+	int instruction_idx;
+	int branch_idx;
+
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
@@ -846,13 +874,18 @@ int main(int ac, char **av)
 		}
 		gp_events = (struct pmu_event *)intel_gp_events;
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
+		instruction_idx = INTEL_INSTRUCTIONS_IDX;
+		branch_idx = INTEL_BRANCHES_IDX;
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
 		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
 		gp_events = (struct pmu_event *)amd_gp_events;
+		instruction_idx = AMD_INSTRUCTIONS_IDX;
+		branch_idx = AMD_BRANCHES_IDX;
 		report_prefix_push("AMD");
 	}
+	adjust_events_range(gp_events, instruction_idx, branch_idx);
 
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
-- 
2.48.1.601.g30ceb7b040-goog


