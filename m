Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716BF4CA2F0
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbiCBLOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241274AbiCBLOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:41 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F949606CC;
        Wed,  2 Mar 2022 03:13:52 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cx5so1490877pjb.1;
        Wed, 02 Mar 2022 03:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jcf+uMQaYXb0fRvoASavmL6ans1TjeGObPHTY/XJvVE=;
        b=lieA7yUZsIYEOQAauQIyIWHHgg+Stvhravead9k08rzBmrkV02ZAVqPcSapAwzOelu
         Gr37N/FKZe61X0yE/jiLe9GDpgyC2nUdfOdIImeeuEfZ5nxOOuoXPVLo4CHgrmRaicLV
         vRKII+ZwtDSRiI5D19MKgWHEmuK+FVvM2ZFUlvuRoTZDrBA+CxeYUYmiVxN/6vPhP5fT
         nx8H3qkJdIUCrJFj1/rRb+wy+e2k6xTwtdUS0KLlqbwj0tgfOJqv+uCBw6jS27n2WPd9
         fNVpZOUemMxxpke/wCnyo3hjdjmZ5XlH2m/PgKhWkomEvDpeFJ713awdjd2X9Sip3YMq
         uCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jcf+uMQaYXb0fRvoASavmL6ans1TjeGObPHTY/XJvVE=;
        b=aeOJ0HD6lUbRcQak2BAUjYnmA7HAvppXbAeVdX+AmiSHdvGqkyumwxhvB2l/ZYuJCv
         BbnBNKBw/CfgfbLybPGMc71JP7GYZ3vhGEeDO42snuB3ehbMGBHI4nXRynDOcCj7KBg1
         9N6YHavYOvwpHgvzxBgeQtQzY55yCLlOrl7A0ihzIurCMor2bJQUSu4gSNxZVfpd3+IZ
         LCeEPu4HPdhNeyEr8jEawJmBTNMDqQUh+buRSSm54jlTH15UlqzDso7g6e7YQVOlYnHe
         NsNJwRNV6O11gy6l1zOkkZ3+d3okCiabCfbyoI7DkmP6MWQuJ8TkaGuTKeMuG6IdRKoJ
         ke5g==
X-Gm-Message-State: AOAM532+WdyDvbSWrVhK/kn+NBEfgqH+vQDABy7k7X8sZIoYyDdoHesW
        2COQVvjFTaB/OzT45H53Pvg=
X-Google-Smtp-Source: ABdhPJzmTu1Mt4/a3xoJD/CKmVsDCv3vJejVpekXhFuPdcUfkB7QzPweWxBMRy6VZwenmPNOW8SmVw==
X-Received: by 2002:a17:90b:1d12:b0:1bc:8ef5:a110 with SMTP id on18-20020a17090b1d1200b001bc8ef5a110mr26358679pjb.207.1646219631964;
        Wed, 02 Mar 2022 03:13:51 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:51 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 03/12] KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
Date:   Wed,  2 Mar 2022 19:13:25 +0800
Message-Id: <20220302111334.12689-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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
index fda963161951..0ce33a2798cd 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -288,18 +288,13 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
+void reprogram_counter(struct kvm_pmc *pmc)
 {
-	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
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
@@ -318,8 +313,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 			clear_bit(bit, pmu->reprogram_pmi);
 			continue;
 		}
-
-		reprogram_counter(pmu, bit);
+		reprogram_counter(pmc);
 	}
 
 	/*
@@ -505,13 +499,12 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 
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
index 7a7b8d5b775e..b529c54dc309 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -142,7 +142,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
-void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
+void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4e5b1eeeb77c..20f2b5f5102b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -56,16 +56,32 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	pmu->fixed_ctr_ctrl = data;
 }
 
+static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	if (pmc_idx < INTEL_PMC_IDX_FIXED)
+		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
+				  MSR_P6_EVNTSEL0);
+	else {
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
2.35.1

