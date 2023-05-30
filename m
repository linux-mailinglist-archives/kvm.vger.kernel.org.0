Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3971554D
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjE3GFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjE3GE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFACE5;
        Mon, 29 May 2023 23:04:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2564dc37c3eso1632570a91.0;
        Mon, 29 May 2023 23:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426695; x=1688018695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xqA6m3mPbeN62DVnOEmc3GlEb3DP3v9n2buE8hSS5s=;
        b=iBPgN25w0BAenP7FgUNJyYUWNb8fyATM+m8ra9RwZrSCGMUL7ICliYmhZueyeg0z0b
         G+aWLHgLVaYGNlqDYJ0kgWOTI4oZpzQtMSpITKX5001S78mzbmQTV0YMWLKqYHe7z8O8
         LBKiyUw+1RYQP8/ZLL1u60DQS71O6y5ND15ZJKTdgDtY8y5UTIRyTTEHLXXEhd0YHOX1
         JilFnHcThY6jMMV3qBAelktEPMCvFyGhWUW/UWXRjUmb6RTCNJjqFrDWh1oeH695VZv8
         48s5zrI8FC4bW0+4kFmo3NHy0irZcd81CMe9csMqE8GX+fyhMbXSQ/4dXRiNOFu4ciL/
         8aEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426695; x=1688018695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xqA6m3mPbeN62DVnOEmc3GlEb3DP3v9n2buE8hSS5s=;
        b=WYwfFsaBPpu8rpfYH9ABHhdBidoyUPI3DJtYdy3VufgydpmPZQoUWfxS6pE+8NGLAL
         AR4QoVeLoiQwO3QR39QBnUthzmXW+RKGhVnEtZEKI5QPF16iVVeyJ/1hZJZVbVJY+rIU
         GxP/DnOqztgPoFFTtKBx9ziNmE4F6rdmt2dYdGtpaKJX/3vcVqy+hkXceeldRSUjQXIN
         R/VHfnkJbNkoKuo27DJ88+0qAQUp+tGUIGgZVh7qT4LjoLoesh77A8ksG5X0U75Bjl0L
         65PmLPinbgeZGwaeErvaxpqRxzPtf1J8078nGl945WscbIasK1aF9WjC4DhWsl6RdSvv
         sYJQ==
X-Gm-Message-State: AC+VfDyPG61jrOIGVkbEI1k+u4BrHYiZ5XGDg/H29SRfnV8Kktje8G5x
        EUqxU/Af8AtCUF4uQMO0A8U=
X-Google-Smtp-Source: ACHHUZ7kloB7kZXvSeAB0Lds8D9IhXPxJr0wA4u6gfxoWBAxuNwABD+w/VxWrYLVE1IeyaqBorTgHg==
X-Received: by 2002:a17:90a:f2d8:b0:256:540d:b54a with SMTP id gt24-20020a17090af2d800b00256540db54amr9034831pjb.8.1685426694912;
        Mon, 29 May 2023 23:04:54 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:54 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: [PATCH v6 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
Date:   Tue, 30 May 2023 14:04:18 +0800
Message-Id: <20230530060423.32361-6-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Disable PMU support when running on AMD and perf reports fewer than four
general purpose counters. All AMD PMUs must define at least four counters
due to AMD's legacy architecture hardcoding the number of counters
without providing a way to enumerate the number of counters to software,
e.g. from AMD's APM:

 The legacy architecture defines four performance counters (PerfCtrn)
 and corresponding event-select registers (PerfEvtSeln).

Virtualizing fewer than four counters can lead to guest instability as
software expects four counters to be available. Rather than bleed AMD
details into the common code, just define a const unsigned int and
provide a convenient location to document why Intel and AMD have different
mins (in particular, AMD's lack of any way to enumerate less than four
counters to the guest).

According to Intel SDM, "Intel Core Solo and Intel Core Duo processors
support base level functionality identified by version ID of 1. Processors
based on Intel Core microarchitecture support, at a minimum, the base
level functionality of architectural performance monitoring." Those
antique processors mentioned above all had at least two GP counters,
subsequent processors had more and more GP counters, and given KVM's
quirky handling of MSR_P6_PERFCTR0/1, the value of MIN_NR_GP_COUNTERS
for the Intel Arch PMU can safely be 2.

Cc: Jim Mattson <jmattson@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 14 ++++++++++----
 arch/x86/kvm/svm/pmu.c       |  1 +
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dd7c7d4ffe3b..019a8ed51b12 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -36,6 +36,7 @@ struct kvm_pmu_ops {
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
+	const int MIN_NR_GP_COUNTERS;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
@@ -160,6 +161,7 @@ extern struct x86_pmu_capability kvm_pmu_cap;
 static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
 	/*
 	 * Hybrid PMUs don't play nice with virtualization without careful
@@ -174,11 +176,15 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
 
 		/*
-		 * For Intel, only support guest architectural pmu
-		 * on a host with architectural pmu.
+		 * WARN if perf did NOT disable hardware PMU if the number of
+		 * architecturally required GP counters aren't present, i.e. if
+		 * there are a non-zero number of counters, but fewer than what
+		 * is architecturally required.
 		 */
-		if ((is_intel && !kvm_pmu_cap.version) ||
-		    !kvm_pmu_cap.num_counters_gp)
+		if (!kvm_pmu_cap.num_counters_gp ||
+		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
+			enable_pmu = false;
+		else if (is_intel && !kvm_pmu_cap.version)
 			enable_pmu = false;
 	}
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 70143275e0a7..e5c69062a909 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -224,4 +224,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
+	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 99d07ccb1869..08851b49e1d4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -811,4 +811,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.cleanup = intel_pmu_cleanup,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
+	.MIN_NR_GP_COUNTERS = 2,
 };
-- 
2.40.1

