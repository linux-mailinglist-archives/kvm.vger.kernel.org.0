Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E032E57C91E
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiGUKgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiGUKgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:15 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C922823BC;
        Thu, 21 Jul 2022 03:36:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c139so1390795pfc.2;
        Thu, 21 Jul 2022 03:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7a5h0BPFo1w7O1Ws8TVqQESIJ7aIAVxGDx6UDb0IKxQ=;
        b=d4Oanrw6RiRXIeDbtRD4Ip/L3Nx7w+hEo5R0RXxc6R0D5cO4fbz1Jk/1FdoURwS0jF
         +uBSl5rtnMlpJ5+6JyTxv7mrKR1AjBllph1RogF46Hag/ptLKoRQNOTk0sTGsnFroFoU
         4RepTrJtTNENrLZj0a6v1DG4H7XX3tMFXyh35dv6fnbb8FEuRwtL+0GmvP6o3kLkU6US
         yRp2UMlFh2NGedC+/0SdARASxxw9AqbOlUKA5C6bbXC4BG+YWBmYequXQmNOFCy6I5e/
         8JVfamgkqsBf60Pkb2xv7zBTCbhWv9lmCiTvHdVEN5SnCoRLZEzJFH7x0PtPt4jHm0dF
         wyRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7a5h0BPFo1w7O1Ws8TVqQESIJ7aIAVxGDx6UDb0IKxQ=;
        b=3Sl0RBwGLqvpSWRqEnsdby3zBBX/8ixPK0DI1UkOSK8TbUudzcSAnuSgNz4wDUZmBW
         E8k/Do0aS7omAidcnQzpKqlyDQ7IKbKcMmJQBfu1B7GgZCIaIB9Gb9GGM4FdtVQ5+sz+
         5rM10CbaurLbFj2Ntq72s4TC0ZllegdLFlQg9Ju5FEyjMicTvpxKFlUtHR2VDBGUOQ0a
         C3nfLlI9kpTLA2b9nAhkt9CR82AlYx7QE8/iVxII5qMiz5UIHJt3kaU6GdPVD6G+dFNa
         UudaqO3j3+LhCGvkZ5JdAm18CiakNGIg23kkaGA+l6v/CPnXHksRF812aGsbwvRLSs6O
         aMKg==
X-Gm-Message-State: AJIora96cpJ3PN3ZmYCTQVE01Q+kNn5IF6XPvSq86nUkC0/XEd1PsR/t
        2b4nS0woyHpZhXPeOdub07T7EU00DEZbIQ==
X-Google-Smtp-Source: AGRyM1t/4JwWePBWG9eWg4ZwAierSsn+zFEqr4AEIKZFipYyUjRBrQBfi4enl7fmrsXSCn9ThHHwSw==
X-Received: by 2002:a63:6a45:0:b0:419:cb1b:891b with SMTP id f66-20020a636a45000000b00419cb1b891bmr31165425pgc.135.1658399769087;
        Thu, 21 Jul 2022 03:36:09 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:08 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 6/7] KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
Date:   Thu, 21 Jul 2022 18:35:47 +0800
Message-Id: <20220721103549.49543-7-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index e8281d64a431..0295b763bd14 100644
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
2.37.1

