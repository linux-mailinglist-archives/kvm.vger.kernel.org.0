Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CB95B0210
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 12:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiIGKtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 06:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiIGKtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 06:49:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9833C861D1;
        Wed,  7 Sep 2022 03:49:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c198so4351057pfc.13;
        Wed, 07 Sep 2022 03:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=KEiBaoH8BEFroOX7977NTfxNkLv87R80XoxhrOTm94o=;
        b=cUIfE25JIN21oOq1fgNr5PeFI9PWq1WRdKeSjjTHBzKD2vrfVcciv99nWm+TvGx3mb
         /jtYFU/TXEkmlLC24VEExHdmNR8OalX7PBYkPcH1dqB/G5AceCZFLSs/fwfgkcFj9UnC
         1A4v4qPwOlOodbxoxZFlm6m+4E7QnAhk/U7WP1n6R3id0dVZ13bV57UdMwXpIucCDqJg
         kA0anLUYT2h40kBEVHBaKnHik9T5y8iyvptLR3T5FeY0EpmTbdx0ApHyeOYjqJT+nH25
         GE6Q5pag/FhSj7TtV+Jr7KqgfTdGV+ZZEMhSXQQl0NmFXtcVxagVh57sJVqEzmESbJwp
         sdjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KEiBaoH8BEFroOX7977NTfxNkLv87R80XoxhrOTm94o=;
        b=iA8pu81Z3fyJhq+njpXJu2ZhwTUPdBqnCufHvQ6TUDgnmCDNu3flg+VXdkFOeOa5Vx
         ivpu9bUodbEfjOWqoG8pV5qbJkP7t2BXOBJP+rfaK9DBpIKy9cMoW1RSPj0696J4JOZ6
         75tLNG0iNp7j0l6bBU6bexMIcAcgDajwHXjxpl2TXTTYlru2vExglt9mPUA8NPeoXt1R
         H5WvtV+5n+qyNxQC3/UMxlPAOePE5e4ceYNEU9G8FvE8kIrKHq4PXIfKZrV6aUUCJSYw
         UxsDF4GyMBz8nAe7H6cVWDJnJfGlvBKbRUYCUjVm8MeXdm81GYyyWDg7tAn/5wlMRdIK
         eaKQ==
X-Gm-Message-State: ACgBeo3ygIyEaERph2jrqMGGCpcd0mSD8XMgbvaZRlbC6NeEHvNjlDbN
        5GhUhExpE8O2IVU5WN21mx5TlB4Fk5LgnA==
X-Google-Smtp-Source: AA6agR42F7XDh2ic8iNGiYRTb81uwV3BmUQbQsm7FbaD7TtrwqrgkPdg3ahpBnEqGpj/qmFWA1JmVg==
X-Received: by 2002:a05:6a00:ad1:b0:530:2cb7:84de with SMTP id c17-20020a056a000ad100b005302cb784demr3250486pfl.3.1662547740154;
        Wed, 07 Sep 2022 03:49:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b0053e22fc5b4fsm4044044pfj.0.2022.09.07.03.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 03:48:59 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 3/3] KVM: x86/pmu: Limit the maximum number of supported AMD GP counters
Date:   Wed,  7 Sep 2022 18:48:38 +0800
Message-Id: <20220907104838.8424-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220907104838.8424-1-likexu@tencent.com>
References: <20220907104838.8424-1-likexu@tencent.com>
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

The AMD PerfMonV2 specification allows for a maximum of 16 GP counters,
which is clearly not supported with zero code effort in the current KVM.

A local macro (named like INTEL_PMC_MAX_GENERIC) is introduced to
take back control of this virt capability, which also makes it easier to
statically partition all available counters between hosts and guests.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/pmu.c          | 7 ++++---
 arch/x86/kvm/x86.c              | 3 +++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 70b8266b0474..5c941ace8f67 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -506,6 +506,7 @@ struct kvm_pmc {
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
+#define KVM_AMD_PMC_MAX_GENERIC	AMD64_NUM_COUNTERS_CORE
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..e696979ee395 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -271,9 +271,10 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > INTEL_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
 
-	for (i = 0; i < AMD64_NUM_COUNTERS_CORE ; i++) {
+	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
@@ -286,7 +287,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	for (i = 0; i < AMD64_NUM_COUNTERS_CORE; i++) {
+	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd64003ee0e0..1d28d147fc34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1438,10 +1438,13 @@ static const u32 msrs_to_save_all[] = {
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
+
+	/* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */
 	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
-- 
2.37.3

