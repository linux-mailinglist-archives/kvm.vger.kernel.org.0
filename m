Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B5057364E
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiGMMZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbiGMMZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A7C3AF4;
        Wed, 13 Jul 2022 05:25:41 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so10288943pgs.3;
        Wed, 13 Jul 2022 05:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vDEqN9x4jRvJS83n9tjgBw0tzXpZmoWu6o7+jYdFVOY=;
        b=K2Ep1JD9ExPzt6o06X+uL7DcvXrvOUxWB5TOD0FraSIK/10HBUp2sLWFTlQZs2jJr+
         gTYJd0Y1SBwKqa4iT4og+CA/UlPzFyAJZPA8MEDwMC+0uCFkTng2LLrXSpjSQtZ/dJlS
         PBozM9skxjRkryWbWL5C6oArRL/L4nuzRJ0oTj4tP/WUKiriASFGr15ELyWlr0jZQp/q
         Jh2Ymdu66QvMmEKL5Rb3pJQBRr2na8fV5ZVdKqDLYWXnWULIxWaZBfxOgIpdxh3mFZZf
         JGZmN419Mf1A9Htpey+T137ffkYmBiriVNm5775IOIPFs/iZV0XfndABWYpxoqziGWRm
         F3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vDEqN9x4jRvJS83n9tjgBw0tzXpZmoWu6o7+jYdFVOY=;
        b=KrD/2FC7dP5BIJhXMuudbWqAFOuzvA4AgfhnUE6NYYDhiN4bCnhEsRh52OErY7lVIx
         aCS5WZypVzr4PRx+jxyt0m0F2/xa5I/zr/lOCL6abfUE7GKY1Li+49u9thXqiGveyrWl
         JJh8kQuh/bfySZeGcewS5OC21iDSLDEy1FbTDCZkfMeeGbhEcoVEKyxhgiytoigW+wZM
         mtWeHraeTQRaEzPXlddYNbC0F50MwQamyt0yGdngXpu+P5NfFhbxohh+L0fhMtKkA5fc
         otDysHot4ObW5w+0Ra5P5TSG6ipUOol0prAfgC+mO7QfdJIZ0VT3IpqJHNEgqee4/s3f
         u9TQ==
X-Gm-Message-State: AJIora/JzrOYF4qFuzTfFoY4jVIt/HOm8qUBuHiKQi9ymrI6um4QiCn4
        xv+5M3Chcxlj/UBF9iLjoXI=
X-Google-Smtp-Source: AGRyM1tfgKzg6Zl3D6EHKV1RAJXtNWseDWAQ3ME2LWwiUktteGmqgwm3gL85FzcQsXzUjBoNPE835A==
X-Received: by 2002:a63:4d61:0:b0:412:6081:4bbf with SMTP id n33-20020a634d61000000b0041260814bbfmr2743515pgl.109.1657715140717;
        Wed, 13 Jul 2022 05:25:40 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:40 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 6/7] KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
Date:   Wed, 13 Jul 2022 20:25:05 +0800
Message-Id: <20220713122507.29236-7-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220713122507.29236-1-likexu@tencent.com>
References: <20220713122507.29236-1-likexu@tencent.com>
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
reprogram_pmi, and then defers the actual execution with the help of
vcpu KVM_REQ_PMU request.

Opportunistically update a comment for pmu->reprogram_pmi.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2c03fe208093..681d3ac8d75c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -101,7 +101,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	bool skip_pmi = false;
 
-	/* Ignore counters that have been reprogrammed already. */
+	/* Ignore counters that have not been reprogrammed. */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
@@ -289,6 +289,13 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 }
 
 void reprogram_counter(struct kvm_pmc *pmc)
+{
+	__set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+}
+EXPORT_SYMBOL_GPL(reprogram_counter);
+
+static void __reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
@@ -330,7 +337,6 @@ void reprogram_counter(struct kvm_pmc *pmc)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-EXPORT_SYMBOL_GPL(reprogram_counter);
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
@@ -340,11 +346,12 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
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
@@ -522,7 +529,7 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 	prev_count = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
 
-	reprogram_counter(pmc);
+	__reprogram_counter(pmc);
 	if (pmc->counter < prev_count)
 		__kvm_perf_overflow(pmc, false);
 }
-- 
2.37.0

