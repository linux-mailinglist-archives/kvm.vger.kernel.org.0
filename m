Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC557364F
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiGMMZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbiGMMZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:36 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8D8C1FED;
        Wed, 13 Jul 2022 05:25:34 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 73so10270312pgb.10;
        Wed, 13 Jul 2022 05:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXqovdDSl/MXsNZWjftmy81y+mPSnXdzim3KrCIDlE0=;
        b=LLUGPEi/RmbpZwk9P9m5HPEB9sm6XJcxnSoyd8dxAk1RNNLJ4kiniTUwgPSb0SOGsM
         kP+pNwDVu/sTpyz6I3D/+OMo6wkcGTfbDIRFNQ691ukX50uy0TldoRp8f4t0i9vvxOzH
         80ChLc51D1OvQtifYaQiYdhlY71ZzVH4iI0PPvhDUdqEMt49vaXvOzPsk+nlGDBD8GEe
         SJmwD0W3bG9akHMxtA7QQzlCpwE4MGD2Z64Xa527qvNuflNkm74pUzI7MYDf0YeXcycX
         6Yw8pLPAeUttos0Pqjkze0stGX3eqjEUcqHG3fv//3b6A5eCuYtiOmloxFrTqD6Z+69U
         S9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXqovdDSl/MXsNZWjftmy81y+mPSnXdzim3KrCIDlE0=;
        b=HOVViA/Y5RW1/ssLS2ONKdAJwYxQR4Wr+sGQNogb8Z3xOtfLg5u63pvB4JENer/qDN
         7ZbPkPsBvNFf8wgzM54BFRDwFIB10sqb5BfRSuvktUzSz/+WcyHgHZ2NqbB3xgsKO8L+
         PJBw7ydjr5rS2ErUtC1kyfedoc/kLtytcoLFQErYFWpkNw0mZ4FgxfUOAe7FC9IPpnlg
         VEk/IYPa9sg29ZbVsXK2IhxQ2GiBKB4BxHhMr/DzqYTqgsgk/OKYuKgTyrKIIdB0d/91
         9eXL0aUVSwnkZF8kyXrQ4bxgMweNdXWxrNm60/iu0RCmemuBMv77+cyDdK9kuVaHnjh1
         Z9JQ==
X-Gm-Message-State: AJIora+G6OsmxC3mUktNwv5byABEqLj8osQqo+4KK2NnKiRjBPY0ZDpX
        M0KY3MoZ/5qKGQDgRWNcUIc=
X-Google-Smtp-Source: AGRyM1sk8JQ44ful7LGxlOnlp8i/NXsMnI/Tct++/5RfdnANJujj/ifyPCW1uswJ2UUvzKZRMWYw3w==
X-Received: by 2002:a63:df49:0:b0:412:58fe:2332 with SMTP id h9-20020a63df49000000b0041258fe2332mr2603882pgj.505.1657715134057;
        Wed, 13 Jul 2022 05:25:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:33 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 3/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
Date:   Wed, 13 Jul 2022 20:25:02 +0800
Message-Id: <20220713122507.29236-4-likexu@tencent.com>
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

In the extreme case of host counters multiplexing and contention, the
perf_event requested by the guest's pebs counter is not allocated to any
actual physical counter, in which case hw.idx is bookkept as -1,
resulting in an out-of-bounds access to host_cross_mapped_mask.

Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 53ccba896e77..1588627974fa 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -783,20 +783,19 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 {
 	struct kvm_pmc *pmc = NULL;
-	int bit;
+	int bit, hw_idx;
 
 	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
 			 X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 
 		if (!pmc || !pmc_speculative_in_use(pmc) ||
-		    !intel_pmc_is_enabled(pmc))
+		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
 			continue;
 
-		if (pmc->perf_event && pmc->idx != pmc->perf_event->hw.idx) {
-			pmu->host_cross_mapped_mask |=
-				BIT_ULL(pmc->perf_event->hw.idx);
-		}
+		hw_idx = pmc->perf_event->hw.idx;
+		if (hw_idx != pmc->idx && hw_idx != -1)
+			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
 	}
 }
 
-- 
2.37.0

