Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FC4701E3
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242546AbhLJNkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242219AbhLJNkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:05 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341CC0698D3;
        Fri, 10 Dec 2021 05:36:24 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f125so8165984pgc.0;
        Fri, 10 Dec 2021 05:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPJmLUi31J8DVvwW27bwLQAclrYgTNO/l7XlHDErWH8=;
        b=lDPtVeIQW7EAG/bV0n/pt0p/7tEtWe3gbPlIEhDOi1Q9o0Zd6aj9nRF5qvDvoUPTm+
         4iPKOvYUtlgQ3m3bX8HOOgRXWYgZ2zGXJcC2xpL9p/Nhrt+/bZM27zw2HWXYysScPV66
         x5PynNooFx5L5o8fjRqTFt5NH4CkiV9hKFgkd3CqHVNYz8Uc3thdav3TZyW+DcH1bfE1
         Phoe2UdDdnZ04oA8VLors9uLkkq9ZrHiBIsPRHHULragDiUspPvWqg0ECuiNDKCC7RLh
         7RXkIpD1Cz9Lt6gLqfOGZXU7UDAENJ9J3MBC18zkT3PNCqj+KyfKQP7F/7zy3KaR2t0O
         hOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPJmLUi31J8DVvwW27bwLQAclrYgTNO/l7XlHDErWH8=;
        b=kVyyfDOLTzy3VYvN97xZvp+nxKsRFTXANtlhQSIQyoWOv5uLYr7MBIqAvDQ6XRagsR
         rQtc0okwnQqcjmEefoNmhZYSYAEL0wovkyit6h7tL6M00CDNHCAtsiqYMLcc4y0ECfe5
         q76XxCIC0gZZURVegoIXFIY1TM33eguPLeZ1cLnt9LmJi3LwnAsVfoefHIWlmcd1pAbC
         PIiX7CoEXjxfbnvn4saVkc4gEidFyLth6prbt9/JVeb0W3x/hYOOXm2JEmO7egigu3lO
         sw4G5U4WraYpln8RoRVf8Bcj/TqRQZiDKZgw5LFcDSQGklJmV6qqtJY4ipfGX3Gub/SW
         nq+A==
X-Gm-Message-State: AOAM532AgvNgi2zXSahm8YY3tsEohSGwjOyrJehEZpzD/3YmOQ+M+fbJ
        KKJtjLsyeUWN3npqjNhg2gsthoTOoj4=
X-Google-Smtp-Source: ABdhPJwriXrc9QVyzYXAg68Jg3cGP+H6ih+uze043nynywAy9JBCRymoUGXAlWf6UaZg3YIG0TyUsw==
X-Received: by 2002:a63:8bc4:: with SMTP id j187mr4270265pge.189.1639143383564;
        Fri, 10 Dec 2021 05:36:23 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 13/17] KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
Date:   Fri, 10 Dec 2021 21:35:21 +0800
Message-Id: <20211210133525.46465-14-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

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
index a780b84b431d..179b0b6af3b2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -472,17 +472,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
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
index 267be4f5d9d5..3ad0f3901352 100644
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
2.33.1

