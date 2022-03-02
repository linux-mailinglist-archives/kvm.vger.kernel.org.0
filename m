Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F64CA2FA
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbiCBLPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241318AbiCBLOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:46 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD28606D7;
        Wed,  2 Mar 2022 03:13:59 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d17so1696438pfl.0;
        Wed, 02 Mar 2022 03:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmHHVLhMLkneE+EGE4WwFIYlUm+9Kc8ZOrRDwiqbOwU=;
        b=k+QjHLMylb+UECl9c9j5EOTXOO/4ZUxCc2JlFkdTLTwl+EHmaL0+gzRcFA3w0uJWQy
         W7kpFz2sIUO61eqATqvOlqR1NN1Ppy7kgCRWCvu4hv0gFqP7Be24VVG3VnOGPuOHltWQ
         G1Dc4MIcWuyNZ+J9PD6LBHyyDoioRvQPcBfxWPmEbzodsG5kiRvuzS9EyWBRe9CvnFGg
         7QoHooFx+TTYqiTxpBDHzNMmRJB3kSnhjh5kZA4vlFZLOfFoEKmrBxH6tINhMw00kLRb
         vJyuGVIA77mBmEaN/B9TSw9/mNRZC7o0cwEUSPz5WF5P7s8O4t37v61VXv8znoTQAGQe
         82gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmHHVLhMLkneE+EGE4WwFIYlUm+9Kc8ZOrRDwiqbOwU=;
        b=1Y0++Yz8W5ExAFohaCUvaRYWFE6tfb1toU92uI7JiTpE7sX88cLh6Z0eubzo+hx2AJ
         eIdsZWJvsqnA3w71ITniAJ5mDeDvrMq4lSaG+pEFHVOJjv1iimgCqk8MY3Iq+mGdMpCK
         LE0U1kmGIcxZEfruoU4+U05zUOzUeICNd3zYJTTSPKAgZRC4GdPTbsllp+5q/W+zGDVr
         di1aE/0y1uYUC+cb3htM4j61xHT0GCkMVlC8Li+GkGJB7xzBqpFnkjxsBbur/pMLWyi+
         PExvJyn5u5w+0qaqH3nDSXb4kbl+eBmGjhMneAM8UI3rdJAFSz11J14cL87CWnwvrsV2
         DP/A==
X-Gm-Message-State: AOAM533YcznWVXDdqtEQFk2YnCObuINzq/tL6rIdpfhfjlVUe7jGcazm
        nNGns8Yw5nReHyQYlFkSf6U=
X-Google-Smtp-Source: ABdhPJxYh2IHOjNAazTukrTlaFnJlAWETGRItlCRNd/OOAMWSCEErTZoYtYyTCZat+lb4T8M6RVZjA==
X-Received: by 2002:a63:c011:0:b0:378:74a6:9c31 with SMTP id h17-20020a63c011000000b0037874a69c31mr15963077pgg.585.1646219639456;
        Wed, 02 Mar 2022 03:13:59 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:59 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 06/12] KVM: x86/pmu: Use only the uniformly exported interface reprogram_counter()
Date:   Wed,  2 Mar 2022 19:13:28 +0800
Message-Id: <20220302111334.12689-7-likexu@tencent.com>
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
index 282e6e859c46..5299488b002c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -215,7 +215,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc)
+static void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
@@ -258,9 +258,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
 			      (eventsel & HSW_IN_TX),
 			      (eventsel & HSW_IN_TX_CHECKPOINTED));
 }
-EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static void reprogram_fixed_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
@@ -288,7 +287,6 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc)
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
 }
-EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmc *pmc)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 70a982c3cdad..201b99628423 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,8 +140,6 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc);
-void reprogram_fixed_counter(struct kvm_pmc *pmc);
 void reprogram_counter(struct kvm_pmc *pmc);
 
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 7ff9ccaca0a4..a18bf636fbce 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -266,7 +266,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		if (!(data & pmu->reserved_bits)) {
 			pmc->eventsel = data;
-			reprogram_gp_counter(pmc);
+			reprogram_counter(pmc);
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3ddbfdd16cd0..19b78a9d9d47 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -52,7 +52,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_fixed_counter(pmc);
+		reprogram_counter(pmc);
 	}
 }
 
@@ -449,7 +449,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				return 0;
 			if (!(data & pmu->reserved_bits)) {
 				pmc->eventsel = data;
-				reprogram_gp_counter(pmc);
+				reprogram_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.35.1

