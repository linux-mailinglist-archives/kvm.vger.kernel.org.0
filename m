Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDF359DDF9
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358782AbiHWLyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358685AbiHWLwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A62D571E;
        Tue, 23 Aug 2022 02:32:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r69so11784629pgr.2;
        Tue, 23 Aug 2022 02:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=CAfa2n1KTOfIPyRv+epAHCxbtQ7Xsz015iAg4y1XQaI=;
        b=Wd7ldfFhVFtiRs1Gcwu96YKIrY8Gq3FVAlGT9F3hBwayZrVYO0GH2Rd5eJ6CrOt42S
         z1z6y7tvtrOr2tOl+cO3IUBPAWGPLX1x+YuLOoeQnaHSGSCEwDPFxHRdZxlv57c4uDde
         Xe+I6eSxBb+8M3GRcEWVhmeENqcBAy+O21O2aFp7JoXVSbAovWH+yshuHghUF3zke3Mp
         E7UyTMQHvoeBmEhVEOWTiMei3WSg1Zb/6KmHGNv8oBi6jolxwIhh7n6tckv2dwIlzFwl
         o/Tx6BmCA0yzQTOCws5a5EDh7OXlmqGHigkyAdrgG41pAZGdkJXq7FDCToEeAQTjaEeD
         2cOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=CAfa2n1KTOfIPyRv+epAHCxbtQ7Xsz015iAg4y1XQaI=;
        b=NIJUnlYGojwsEoiWsbPkmG6M1i8g8aNOEVLYZfcsLr942QKbQbdH/Ex02zkiGYuRHF
         1LQGVd0kTwRbMTSX6ce4ap8EKz8UzTHoPtrfprKSRwmwX0m89p4sLaZUmc9HtenroVTb
         gc2d3vSol/dcoNA/f4tY5tH4yxnPLVuIPomeVi9hG0hjMUBirlUae+IajuWN8G+11u9r
         Nd8xpE9lbUQ4nzgkOt6ncYHDFKv4albNQE+EDu1i2+CHT6Qm2e5XzHWRRXM0PF42Hb04
         gnvfqVDlYe8nqxnHCxjBVeXFG7nPLbZIq+/FVyvLnUW2rUC+VPogbeSUpQ6V9f/nLxtd
         SchQ==
X-Gm-Message-State: ACgBeo2RTnOFZ5Rv3bW1/TVD34V4yGMTtdJq6EmxkwkVaCRBRt3PVBGg
        aX+znj1MtfUaqkFu9nzxQHy0YfAdFog=
X-Google-Smtp-Source: AA6agR5OKXfHmRfMtQ6PyilKMX43lH3PA2Vu+bqjib+lxTHFZnMVsib9S66F1x7+8+CNnuiC0ENrjQ==
X-Received: by 2002:a05:6a02:10e:b0:42a:b42b:5692 with SMTP id bg14-20020a056a02010e00b0042ab42b5692mr7416921pgb.67.1661247173287;
        Tue, 23 Aug 2022 02:32:53 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:53 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 5/8] KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
Date:   Tue, 23 Aug 2022 17:32:18 +0800
Message-Id: <20220823093221.38075-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
References: <20220823093221.38075-1-likexu@tencent.com>
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

During a KVM-trap from vm-exit to vm-entry, requests from different
sources will try to create one or more perf_events via reprogram_counter(),
which will allow some predecessor actions to be undone posteriorly,
especially repeated calls to some perf subsystem interfaces. These
repetitive calls can be omitted because only the final state of the
perf_event and the hardware resources it occupies will take effect
for the guest right before the vm-entry.

To realize this optimization, KVM marks the creation requirements via
an inline version of reprogram_counter(), and then defers the actual
execution with the help of vcpu KVM_REQ_PMU request.

Opportunistically update related comments to avoid misunderstandings.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.c              | 16 +++++++++-------
 arch/x86/kvm/pmu.h              |  6 +++++-
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..4e568a7ef464 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -493,6 +493,7 @@ struct kvm_pmc {
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
+	 * only for creating or reusing perf_event,
 	 * eventsel value for general purpose counters,
 	 * ctrl value for fixed counters.
 	 */
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d9b9a0f0db17..6940cbeee54d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,7 +101,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
 
-	/* Ignore counters that have been reprogrammed already. */
+	/* Ignore counters that have not been reprogrammed. */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
@@ -293,7 +293,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_counter(struct kvm_pmc *pmc)
+static void __reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
@@ -335,7 +335,6 @@ void reprogram_counter(struct kvm_pmc *pmc)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-EXPORT_SYMBOL_GPL(reprogram_counter);
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
@@ -345,11 +344,12 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
 		struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, bit);
 
-		if (unlikely(!pmc || !pmc->perf_event)) {
+		if (unlikely(!pmc)) {
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
-		reprogram_counter(pmc);
+
+		__reprogram_counter(pmc);
 	}
 
 	/*
@@ -527,7 +527,7 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 	prev_count = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
 
-	reprogram_counter(pmc);
+	__reprogram_counter(pmc);
 	if (pmc->counter < prev_count)
 		__kvm_perf_overflow(pmc, false);
 }
@@ -542,7 +542,9 @@ static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 {
 	bool select_os, select_user;
-	u64 config = pmc->current_config;
+	u64 config = pmc_is_gp(pmc) ? pmc->eventsel :
+		(u64)fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
+				      pmc->idx - INTEL_PMC_IDX_FIXED);
 
 	if (pmc_is_gp(pmc)) {
 		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..d193d1dc6de0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -183,7 +183,11 @@ static inline void kvm_init_pmu_capability(void)
 					     KVM_PMC_MAX_FIXED);
 }
 
-void reprogram_counter(struct kvm_pmc *pmc);
+static inline void reprogram_counter(struct kvm_pmc *pmc)
+{
+	__set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+}
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
-- 
2.37.2

