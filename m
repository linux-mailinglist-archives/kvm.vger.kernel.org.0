Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A34CD0B8
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiCDJGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiCDJGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:23 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192331A7D96;
        Fri,  4 Mar 2022 01:05:25 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id z4so6969870pgh.12;
        Fri, 04 Mar 2022 01:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7u4/+OWRDtdSxhZ8BxjAbkrMgUfVSEhIGA3igG40qk=;
        b=fulmij5kSl9KfVN9HTY6eGUBprAsUrtsQfUANsxayY46Nne98rI3h0IXdDWH55NqCd
         v+mPGCS2W2aTCKkPbLz4OISdpz72JNVmp2V4u23iUvGBDGbvkrrazmLCj2IM2roCbCr4
         W7OEPguYAWb9MNHjB5fz0tPURUZFnjS9fBAYNGqVG+emCRLt11CEhV3VqttHbclCgEYH
         MQh8KClTFF0JVOxSibgYO4zvxhl4XfRb2FkTgclPEgqj+nPtAJV25xD/mFP9WtvJGarU
         aLCT9El/vsJAtrGWasCc2MaTYPhDVfDheB9ooCYNLzt1k7/BCZFAkvlR6H8q5ZdvMJF8
         6VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7u4/+OWRDtdSxhZ8BxjAbkrMgUfVSEhIGA3igG40qk=;
        b=PEC/YJkPe/vvSAWffS5xgWR1DDQjeJl2NMl/fl8cfLRX+dJvlmXwzk6DCPNjxn31MJ
         7325btAYTzlit0EkenEJzqiycXFPPZkywL3peZjs6nA7+9AGhkwuPX/LPMC6c12oxVyi
         vm0bBzZx0QLOaVXLLxxyW+uk+Pf9cDvnh9sZdi+9MIoe3goE4M6x6ZBcHe8rTJVjufAP
         hgnLNHkc0PabXW1CZe6gDntpLNB45PKi0mnC+FfsKlyYsOWPgAW1yxEtgVU7cfpsO69r
         gDTr1ItRTlGR/vSnvBtNNisW++4nkKtVTZ7VSBD7VhWLLb1W+8knwR32+WMhYOvoWnar
         B7hA==
X-Gm-Message-State: AOAM532hA4hMpuZmdbP9yzgQN7rIf/dVWS7JmfyZ9nUXdhIsMwBvATId
        J8kbOVx6rIXP/8y4jHvyOiQ=
X-Google-Smtp-Source: ABdhPJz0q2kIXC0tIeLRXAEGlOzzLJz6QD8JQXQgtanjwD2koJgwF/qZ5qc3bO/7qpH3zxYGDMPttQ==
X-Received: by 2002:a63:d201:0:b0:372:c882:210f with SMTP id a1-20020a63d201000000b00372c882210fmr33654948pgg.198.1646384724541;
        Fri, 04 Mar 2022 01:05:24 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:24 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 13/17] KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
Date:   Fri,  4 Mar 2022 17:04:23 +0800
Message-Id: <20220304090427.90888-14-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

From: Like Xu <like.xu@linux.intel.com>

It allows this inline function to be reused by more callers in
more files, such as pmu_intel.c.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/pmu.c | 11 -----------
 arch/x86/kvm/pmu.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f16dfd7431d1..917d2cbb9ede 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -479,17 +479,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 28c3a826f169..386c8120d4ee 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -147,6 +147,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
-- 
2.35.1

