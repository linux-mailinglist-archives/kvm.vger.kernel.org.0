Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14FA52BCDF
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiERN0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237894AbiERNZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B061BB9B0;
        Wed, 18 May 2022 06:25:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gg20so2033916pjb.1;
        Wed, 18 May 2022 06:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PNVifhlsJTNl8PHU0BT9euUzgdNmiddZWSYrnTIcJzQ=;
        b=MF+gnc5KsYvIGrzPwk+bA8ymch4CyqFuoGL260G/ppzd6l3wv5zoMQ+G7v2HiqM3rE
         9gDoS2JqsK98dUjp9bBpJhB9kQCZQZt3Jm88n9x/wSz4v088Rr7nWKqPf8ik/2upnq7Y
         BC09UcoBubbzDc1fy7rnzoun1XFfztGtEPRmm+Q1nCfhjI9QcOZelyupkBSdb+JLqCqR
         eQVqoLfVE57GIUJ1g5SsVt6BTNWw/J3bR4kRbUsfS4OJ6CT9xlS5ekXlCOYI2JS69SlA
         WPLGgZrXex9gVROkG1tNSsbAXGD92YT9oW2DjVbHB1DvlVSG0/iEDc8cQnY31JRFr0Cp
         kxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNVifhlsJTNl8PHU0BT9euUzgdNmiddZWSYrnTIcJzQ=;
        b=66tZWwCcln2fugpNGDIgmQ3uerb10IA7B5New9g1Yan0Ml5n/SibcNot+ljTWkrQTD
         Sb4KwWlKcQEEeDvDNNKBPSNiZU3j0uYoiVLIeIg7Qc5SG6BgZ8ZedJJRWDMftxM1D9Sn
         /XFxJJNWeqsEFpXox9bf2WoAibcKQrrQf1X2Gt3FlAkZFXt9dXcgQ+mB/4zG7Kvpa7rT
         WyLTPOmqvBk2YAKsgyPgx5hZA2Fk720a9g0zxHSNjWEzRkuIYncb4DkpOcCZudGQRbwI
         F11pDKeMfz4cCZJ1FdNISBxPa2zcIxQ0/YQV4hYbGokQKdjkN3gvcaEygSoqCUIZHiY6
         V9Vg==
X-Gm-Message-State: AOAM532cP3roVnv5rRv1yEz5tvF86q+6p5gdqewG8O1BhCPMOTozjjGF
        1++EnKujo1F3OWL4uyl48i/56kusTIfiuw==
X-Google-Smtp-Source: ABdhPJx8iEmIEI8Jai0U8daZ2nqrWK8PcTuoqaomNBMs2vTw1HgF1gOZfySkhJK+q31Pvbo58K7JUQ==
X-Received: by 2002:a17:902:ab8b:b0:160:df9e:99fa with SMTP id f11-20020a170902ab8b00b00160df9e99famr25840735plr.108.1652880335790;
        Wed, 18 May 2022 06:25:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:35 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 07/11] KVM: x86/pmu: Use only the uniform interface reprogram_counter()
Date:   Wed, 18 May 2022 21:25:08 +0800
Message-Id: <20220518132512.37864-8-likexu@tencent.com>
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

Since reprogram_counter(), reprogram_{gp, fixed}_counter() currently have
the same incoming parameter "struct kvm_pmc *pmc", the callers can simplify
the conetxt by using uniformly exported interface, which makes reprogram_
{gp, fixed}_counter() static and eliminates EXPORT_SYMBOL_GPL.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 6 ++----
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 131fbab612ca..c2f00f07fbd7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -275,7 +275,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc)
+static void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
@@ -317,9 +317,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static void reprogram_fixed_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
@@ -347,7 +346,6 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc)
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi);
 }
-EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
 void reprogram_counter(struct kvm_pmc *pmc)
 {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fa4539e470b3..b5ba846fee88 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -287,7 +287,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			reprogram_gp_counter(pmc);
+			reprogram_counter(pmc);
 		}
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5e10a1ef435d..75aa2282ae93 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -52,7 +52,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		reprogram_fixed_counter(pmc);
+		reprogram_counter(pmc);
 	}
 }
 
@@ -485,7 +485,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
 				pmc->eventsel = data;
-				reprogram_gp_counter(pmc);
+				reprogram_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.36.1

