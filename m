Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7108E4FB7B4
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344531AbiDKJiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344499AbiDKJiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886221FA5E;
        Mon, 11 Apr 2022 02:36:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id md4so6444310pjb.4;
        Mon, 11 Apr 2022 02:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tZcfzZgYqnwUaISJso/WiOm3/p4z9HQxM83jz1FUzY=;
        b=PzPOpCiRv8YmVKpGICfHx3vCkITpU5ZuKpr0MKZL8pQWNlSlbTQHjh9GFECbI62IMZ
         irKVpEOyghkp9zwBSXjJ9c9uvKyM3LM7hqlM9nHStEC5UoxUd8W8JPprIm4Szv/Xl2bq
         QAGzfLu04e//GS35Fr9r5stXfYpxHhcvaVOpka7h3hB3UQ+zMChZ5+lSgBN3KKzmh8dv
         1v50Yyld97WV6mSkZlzEzE47eecLc6OtrMfP21mZybc5pqFZtlOdC49CNymI+QRKC5Wu
         C4ERtGb9yp5lhp61svBqFIj7ah3pUFoSue0YpLHkbEG5mjCykNSSl1E80sdA3u5q3lU4
         ZXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tZcfzZgYqnwUaISJso/WiOm3/p4z9HQxM83jz1FUzY=;
        b=0pIrDAgZpFRy1MuKAvT8ShrwInrOOr050aTZiFLE6UsodO3tmkggUbaDTgSnAyLeiu
         JN0bEsot8ngzVkblSAyAF1xvB1lzml+JRfd0upB0XYqkDnRRE8E//gjlFUM8GzjeoPYA
         qiEJ5gw/GfRe/77jOsf+N0R+9nm3xDPIqWjOyrjCAljOaVbAu7eQ3iGqesuaQtIFr6Al
         1WFHnWEKWo1syVU1qIeZnM+eX7JrHVV5NQPbIWs/i1e+jarFVs66koyO8eom6XGjEkP8
         /fCeJkO7G8GUCSMxTsxXzBLLkQDdxnhNudZyBKhJr+jcKxlpUyo9rdP8p5VLuGumpByA
         UGrA==
X-Gm-Message-State: AOAM532/OkQl1O+gsLdMmT/wNR5i2jdqRLfszEhG/0z/K2GK1X8ZKMLt
        2yHBy3SMtDjqt/Jp+vQW3kU=
X-Google-Smtp-Source: ABdhPJzK3dCr4hP0qqFSaxd8Pt8QOJ+XajNM1FrbFRw8oNY52A6JrgP/cUQ/6uqz789Hp6MVtsbABg==
X-Received: by 2002:a17:90a:510c:b0:1cb:97a3:57b5 with SMTP id t12-20020a17090a510c00b001cb97a357b5mr5275074pjh.36.1649669764932;
        Mon, 11 Apr 2022 02:36:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:36:04 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 07/11] KVM: x86/pmu: Use only the uniformly exported interface reprogram_counter()
Date:   Mon, 11 Apr 2022 17:35:33 +0800
Message-Id: <20220411093537.11558-8-likexu@tencent.com>
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

Since reprogram_counter(), reprogram_{gp, fixed}_counter() currently have
the same incoming parameter "struct kvm_pmc *pmc", the callers can simplify
the conetxt by using uniformly exported interface, which makes reprogram_
{gp, fixed}_counter() static and eliminates EXPORT_SYMBOL_GPL.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 6 ++----
 arch/x86/kvm/pmu.h           | 2 --
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 4 ++--
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 23c7f3cfcc6b..598b19223965 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -240,7 +240,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc)
+static void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
@@ -282,9 +282,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static void reprogram_fixed_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
@@ -312,7 +311,6 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc)
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi);
 }
-EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmc *pmc)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 9ea01fe02802..f4a799816c51 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -135,8 +135,6 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc);
-void reprogram_fixed_counter(struct kvm_pmc *pmc);
 void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 2794a29b3f54..ebec2b478ac1 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -265,7 +265,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			reprogram_gp_counter(pmc);
+			reprogram_counter(pmc);
 		}
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ce71ad29643c..1f910b349978 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -52,7 +52,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_fixed_counter(pmc);
+		reprogram_counter(pmc);
 	}
 }
 
@@ -454,7 +454,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
 				pmc->eventsel = data;
-				reprogram_gp_counter(pmc);
+				reprogram_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.35.1

