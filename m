Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9529649F38
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiLLM7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 07:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiLLM70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:26 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E380C108A;
        Mon, 12 Dec 2022 04:59:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so12111208pjo.3;
        Mon, 12 Dec 2022 04:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5m/rCe97xq/FcJFWy/8y2nBtJ5MNmBfj7N4aCVlUd4=;
        b=aQa7/0t1BOC1wyJTP4l/5k5VRYHAS4mj4MbMCdo52rXUjEFmh5BuErXME4RBHRRDcg
         u7KoPi9+pQNixKbjPcKiJxjZRfT6sZuqpLCB83q5v+tQu82uH/iR2t0hOxWjLhr36Etk
         J+zCwb+9B3yVsKfBqMke4duedRNU7kDqmgpvoynIrK0uMkrDzuP8NZFEuCDCQ9+y6qID
         H/hcEEFwAUdshE7UmXMsyPXKoy1i1VGHaqNJ0ZdiPhhAeB3iY9ShKFI6fjFEqZMkz7PQ
         Y5h3N/fuaqpLacmLlPTIXi9ghuUasf0Cj6oJRDVJ9cjHnFzKHv9dFxFNVn/NhqezqitB
         zsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5m/rCe97xq/FcJFWy/8y2nBtJ5MNmBfj7N4aCVlUd4=;
        b=ds1fp1a2PRXOUkIuYptDsiDO5hdBq1BFeSXut+qxZ7Ba+PoTTPvUlsZDA504SUur+t
         4cNXnjFlY3sItA0RP6rNjSdhCvRcw1aIlT+4RwFIGyj97vIvlghPzrVQVVJq8vr4NzJh
         Z0WhNyXL4JlNSLnTegcVlk/tWhjWIUKttdLIm63bEucQIZxUDpBNCzefm5T8J3JINVRh
         tYT1KWpCgKedVT4ImKhlFjsgNjq7tOrE+7gDqmZbVFtRPVu+PZ0MK/GdAqk9tpYxbjW7
         jxChja/2Ze0UkMBb1TFsbslTQcPScp4fRtnY1CaFUAlO91I9hUtcqF7YYi9Ym/g1AK7a
         i+Pw==
X-Gm-Message-State: ANoB5pmMdnrELhqtjX306wjPO1fs69+r2wPCG/gTi+ZIyJlHtHu3Je4q
        osABvo3juEUpeG69wLZ/9b8=
X-Google-Smtp-Source: AA0mqf4cANmL1rZ+LV2ViIGMf4hLKWJe0EK2HscwOWu8nKVRjk43Ohwr92YK6ECnzQ67pHeezQqndw==
X-Received: by 2002:a17:902:bd02:b0:188:fc0c:b736 with SMTP id p2-20020a170902bd0200b00188fc0cb736mr16904622pls.67.1670849963312;
        Mon, 12 Dec 2022 04:59:23 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 4/8] KVM: x86/pmu: Add Intel CPUID-hinted Topdown Slots event
Date:   Mon, 12 Dec 2022 20:58:40 +0800
Message-Id: <20221212125844.41157-5-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
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

This event counts the total number of available slots for an unhalted
logical processor. Software can use this event as the denominator for the
top-level metrics of the Top-down Microarchitecture Analysis method.

Although the MSR_PERF_METRICS MSR required for topdown events is not
currently available in the guest, relying only on the data provided by
the slots event is sufficient for pmu users to perceive differences in
cpu pipeline machine-width across micro-architectures.

The standalone slots event, like the instruction event, can be counted
with gp counter or fixed counter 3 (if any). As the last CPUID-hinted
Architectural Performance Events, its availability is also controlled by
CPUID.AH.EBX. On the Linux, perf user may encode "-e cpu/event=0xa4,
umask=0x01/" or "-e cpu/slots/" to count slots events.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b746381307c7..d86a6ba8c3f9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -31,10 +31,11 @@
  * 4 - PERF_COUNT_HW_CACHE_MISSES
  * 5 - PERF_COUNT_HW_BRANCH_INSTRUCTIONS
  * 6 - PERF_COUNT_HW_BRANCH_MISSES
+ * 7 - CPUID-hinted Topdown Slots event (available on gp counter)
  *
  * the second part of hw_events is defined by the generic kernel perf:
  *
- * 7 - PERF_COUNT_HW_REF_CPU_CYCLES
+ * 8 - PERF_COUNT_HW_REF_CPU_CYCLES
  */
 static struct kvm_pmu_hw_event intel_arch_events[] = {
 	[0] = { 0x3c, 0x00 },
@@ -44,12 +45,13 @@ static struct kvm_pmu_hw_event intel_arch_events[] = {
 	[4] = { 0x2e, 0x41 },
 	[5] = { 0xc4, 0x00 },
 	[6] = { 0xc5, 0x00 },
+	[7] = { 0xa4, 0x01 },
 	/* The above index must match CPUID 0x0A.EBX bit vector */
-	[7] = { 0x00, 0x03 },
+	[8] = { 0x00, 0x03 },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */
-static int fixed_pmc_events[] = {1, 0, 7};
+static int fixed_pmc_events[] = {1, 0, 8};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
@@ -109,7 +111,7 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 			continue;
 
 		/* disable event that reported as not present by cpuid */
-		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
+		if (i < 8 && !(pmu->available_event_types & (1 << i)))
 			return false;
 
 		break;
-- 
2.38.2

