Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210CF52BD69
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbiERNZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbiERNZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145AF1BB119;
        Wed, 18 May 2022 06:25:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so3954991pjb.1;
        Wed, 18 May 2022 06:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1ZqPC8Q+OBn7Et1W+ctCRyzN+Ix/zx/2p0NyHASta4=;
        b=L316v0jf+KqXihW55HFFIBcX/C+19YQ3ACbXIFLKH3lrmSgLuBS5ZRtXqssuHKXVFU
         eqUpEm8yoQIc4/jl9R3JoS6OQzSfTt6U6KhgWLoocM+oq5/dI3yeQhr9WPCkyH9jM7/2
         V2jrtl1QZaVcZKxz0pD0KbmbigDvhYSifvo/jsyeVDoORYc2BEs27Qwqooi37gEZvSyC
         DMWh4gnziqnNiPYCSZc8ZUY/250cHt4eBK1kpQcTsgX7JqzEgSERnALdTzR07iouwrJG
         W7I6LaSrjz5e8YhRI+rpH9FfQ7iov0yuEZltOJVKQpDKFlsvmTkaOT2TyYY6hnUT1WxN
         6kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1ZqPC8Q+OBn7Et1W+ctCRyzN+Ix/zx/2p0NyHASta4=;
        b=FSjn7FUc+acsIqAjb/70nxZ0MXfAyV2zqIF+OiL9LpWyYm/QPkC4WbNmnuOYlI/I0E
         PF6R3OP+AUuMWEF1oYaS0u+jO+DpsoIxXoS6PlhE+sSx66pngHHyuIc+t3Xzh0Rv12zW
         +AlPiFR3c0X50qQkkpiCDTuUJzwDSR+dafuL9bJGJJxHBiLu5lCttz8tl23gdBUjXIA5
         J6T7+wERnn3ycsPbBD2EhiIhxcL8jUqLpUtYp4zledBZupIwfvwMHEWc6YARlqbL72Bd
         DgMBUWhHdSsoiQw+kuZzY4SiIanBv4PNHRsHyQcf4MXLyTsC0wAjZtdKrAH5SBjUronP
         OYeA==
X-Gm-Message-State: AOAM532f8eUcnSp3404HRWodKY1NMlkhGaARryP68kk9ZFy17J1dWg2f
        3HDJvTQP693dzP+DAydbois=
X-Google-Smtp-Source: ABdhPJxhIMWgz7/P7Tklx0Pbdtn9yYq6SQ2/50grRQuCYGxzVJEehpqHPLMOcNiDrNF6XtvLlTLTDw==
X-Received: by 2002:a17:902:6b44:b0:154:4bee:c434 with SMTP id g4-20020a1709026b4400b001544beec434mr27733901plt.43.1652880328465;
        Wed, 18 May 2022 06:25:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 04/11] KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
Date:   Wed, 18 May 2022 21:25:05 +0800
Message-Id: <20220518132512.37864-5-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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

Passing the reference "struct kvm_pmc *pmc" when creating
pmc->perf_event is sufficient. This change helps to simplify the
calling convention by replacing reprogram_{gp, fixed}_counter()
with reprogram_counter() seamlessly.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 17 +++++------------
 arch/x86/kvm/pmu.h           |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 32 ++++++++++++++++++--------------
 3 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 24624654e476..ba767b4921e3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -347,18 +347,13 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
+void reprogram_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc *pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, pmc_idx);
-
-	if (!pmc)
-		return;
-
 	if (pmc_is_gp(pmc))
 		reprogram_gp_counter(pmc, pmc->eventsel);
 	else {
-		int idx = pmc_idx - INTEL_PMC_IDX_FIXED;
-		u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
+		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
+		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
 
 		reprogram_fixed_counter(pmc, ctrl, idx);
 	}
@@ -377,8 +372,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
-
-		reprogram_counter(pmu, bit);
+		reprogram_counter(pmc);
 	}
 
 	/*
@@ -551,13 +545,12 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 prev_count;
 
 	prev_count = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
 
-	reprogram_counter(pmu, pmc->idx);
+	reprogram_counter(pmc);
 	if (pmc->counter < prev_count)
 		__kvm_perf_overflow(pmc, false);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dbf4c83519a4..0fd2518227f7 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -174,7 +174,7 @@ static inline void kvm_init_pmu_capability(void)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
+void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 84b326c4dce9..33448482db50 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -56,16 +56,32 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	pmu->fixed_ctr_ctrl = data;
 }
 
+static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	if (pmc_idx < INTEL_PMC_IDX_FIXED) {
+		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
+				  MSR_P6_EVNTSEL0);
+	} else {
+		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
+
+		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
+	}
+}
+
 /* function is called when global control register has been updated. */
 static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 {
 	int bit;
 	u64 diff = pmu->global_ctrl ^ data;
+	struct kvm_pmc *pmc;
 
 	pmu->global_ctrl = data;
 
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
-		reprogram_counter(pmu, bit);
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
+		pmc = intel_pmc_idx_to_pmc(pmu, bit);
+		if (pmc)
+			reprogram_counter(pmc);
+	}
 }
 
 static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
@@ -101,18 +117,6 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
-static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
-{
-	if (pmc_idx < INTEL_PMC_IDX_FIXED)
-		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
-				  MSR_P6_EVNTSEL0);
-	else {
-		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
-
-		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
-	}
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.36.1

