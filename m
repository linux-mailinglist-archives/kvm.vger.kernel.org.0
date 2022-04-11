Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096174FB79D
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbiDKJiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344482AbiDKJiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362F11CB01;
        Mon, 11 Apr 2022 02:35:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h10so2415668pfr.10;
        Mon, 11 Apr 2022 02:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1HjOAA3/s+9ocNaxlobLMFx0uOzkw+/5i/yA7VNMqIo=;
        b=kj+7Kayu6XO0P8/10CiI1rbp2wxjxKVwJklaMia5F76mJgq6NKZcSbPLfPb4u6I/Uc
         eCk9QoxEdfhDoMQmxfNlWIazFMid/sp/+B+O/1mQFs1DaadK0343Ep0+zbRwLc4f7l1v
         mrgnGNHdc0qx9m5MpLk8hB5asu+0X38Y19CdAbJ81TxAPS4c6JtdC9H/vLgvWaRg7BJE
         Xr+Y1d7qt4vEUwAojs6W+Hrx7GxRCwaUYZLiGj17w/B0Tvt35SmB5P2QJ8uuCq0m4oHj
         d5YW5x5AzU2WypTKtbvpwVPDkgmdekUpkJbb7gIPw20wer5tFVp8k1vCLD7be7D9nDt1
         kIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1HjOAA3/s+9ocNaxlobLMFx0uOzkw+/5i/yA7VNMqIo=;
        b=KlvvkWk46NneW5EKyCFHfhXLKJPm6+q0fljgyy9Hf9uKvTnPtwr44v+Rrr6rjAzjxO
         84BaeQTe3WWoqoQyAN3JZOpSHoovW9A7y7Et55qnbZ4uDxxNhcv54KGttFLk3BOErdfJ
         0MCOoWAw/XpDSn6sbFY2cb+HfhWaqWVG1lj8TNob5kK2Los0zVv4/piIW7a2BGty4oHm
         m760z+lxo7x520VlhFC7cZrJ3J3pGKSWblT2N1xBm+G8lKAvO3xCFtMlnpO5AZvbA+lC
         ROqBBPuYoFHEguUMmxKpPVHPjosNnphZGoBhiDoe+dg2VmJdDabxVQhEA3XjXhv2Zc9Q
         GKpg==
X-Gm-Message-State: AOAM53018Nht1QDVby+2K0hPlEDT11ckKeKSjws4uiZvl/Iie5jgrK+W
        Q6K4ZHQBy0HNYXtLqp01vIs=
X-Google-Smtp-Source: ABdhPJyH5Qcq+nfklvHhQHZd0lOEC9S7f6mUrVaTUK6lHEXtdkrzTllk5JQJIKHuIWyNv9eJXg47fA==
X-Received: by 2002:a05:6a00:1a10:b0:4fa:ed5a:6697 with SMTP id g16-20020a056a001a1000b004faed5a6697mr31958082pfv.81.1649669758716;
        Mon, 11 Apr 2022 02:35:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 05/11] KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
Date:   Mon, 11 Apr 2022 17:35:31 +0800
Message-Id: <20220411093537.11558-6-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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

Because inside reprogram_gp_counter() it is bound to assign the requested
eventel to pmc->eventsel, this assignment step can be moved forward, thus
simplifying the passing of parameters to "struct kvm_pmc *pmc" only.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 7 +++----
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 6 ++++--
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 51035bd29511..419f44847520 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -240,17 +240,16 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	pmc->eventsel = eventsel;
-
 	pmc_pause_counter(pmc);
 
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
@@ -315,7 +314,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 void reprogram_counter(struct kvm_pmc *pmc)
 {
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc);
 	else {
 		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dbcac971babb..5ec34b940fa1 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -135,7 +135,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
+void reprogram_gp_counter(struct kvm_pmc *pmc);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmc *pmc);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 57ab4739eb19..2794a29b3f54 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -263,8 +263,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
 		data &= ~pmu->reserved_bits;
-		if (data != pmc->eventsel)
-			reprogram_gp_counter(pmc, data);
+		if (data != pmc->eventsel) {
+			pmc->eventsel = data;
+			reprogram_gp_counter(pmc);
+		}
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2feff54e2e45..3bf8a22ea2e5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -453,7 +453,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				pmc->eventsel = data;
+				reprogram_gp_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.35.1

