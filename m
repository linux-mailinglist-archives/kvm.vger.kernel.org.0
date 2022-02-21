Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3934BE100
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356982AbiBULxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:53:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356940AbiBULxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:53:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FED1EEF8;
        Mon, 21 Feb 2022 03:52:30 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gi6so5388491pjb.1;
        Mon, 21 Feb 2022 03:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4FmNQqnLrwUNlzTz45ZJYgWcwcQmaA2toSJhtt6Wns=;
        b=OjCEdF/LCTsu90tVQFeD6wkMayy2sDYUg2XwBQCTq1+TKILsujCOkrA1PS5livTPsh
         XsnIOHlLrp8VG43jqJg4/uvmxFW0iwKnxF0U/0CWXogp0/h8xTQVPExo2uMprg9OPs2e
         gPZUNFW0uL93ryY8TVG2Oua7Z13q0WCGydodi8si7IEpdwN8n67yLd3aC7OJSHLuwocz
         Rroh+DMKMfLcPqwEr5KGBn13xrGzmB4nrgJ93V4ePebjtlj9Dzfw0+MA82W7yv4R1NS+
         WlW22Y51RhiajflwBBN+bj9BEb309tyne11GXzR1qZfzEFsULIwMoy0liwOqxYQC+5ul
         h82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4FmNQqnLrwUNlzTz45ZJYgWcwcQmaA2toSJhtt6Wns=;
        b=sJ/Q9XZkrF746ofXP2gRmzrX+YIEUhfqY1B3QLX37DYC9K5i5wnlM7JFCguXwBSk1E
         6mQvA52SGyQ1/uou7wXoVbODogYKblVgX5DRiOOSUYfasIGW2fwOjh2n8QfmiyvHusxo
         sMDYS4bKW6OL6xnvyv/qrjFfd+KTx0gGW+z3ts7bl4VkT332qW6apG5jZf0UbAvj7OOF
         AUTTSFFfqgg2y+66VXBcO8A7OSRzohONgZVjI2gLNFKyYZWt7Px2NR0qdcqZo3DdBsQd
         2HqH/0IsKQ3aQ6uwohvGcnbD7/wxzNOE2H+y6S3WQgLuOkZsbmiwmjLdTI+jjxsYt7Qb
         NECw==
X-Gm-Message-State: AOAM531KKRD5/NfEWHoycRQn2BTdUwOqwwtx0vCYEmT2IPY9ZE0jYruP
        s75Bb4qK+O9PrBRxhn6Lw3TfC1fpfbF2bQ==
X-Google-Smtp-Source: ABdhPJwE9fzZGi1JFhQXEdn2ZbTGvKc2bJ2G4U1h+EdCk/EB8F9R7OcL6g79q//0ZJ8Rts6eHp0peg==
X-Received: by 2002:a17:90a:ac1:b0:1b9:7dd3:ba5f with SMTP id r1-20020a17090a0ac100b001b97dd3ba5fmr21242387pje.178.1645444349861;
        Mon, 21 Feb 2022 03:52:29 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:29 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 06/11] KVM: x86/pmu: Use only the uniformly exported interface reprogram_counter()
Date:   Mon, 21 Feb 2022 19:51:56 +0800
Message-Id: <20220221115201.22208-7-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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
index 7c90d5d196a4..5816af6b6494 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -213,7 +213,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc)
+static void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
@@ -256,9 +256,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc)
 			      (eventsel & HSW_IN_TX),
 			      (eventsel & HSW_IN_TX_CHECKPOINTED));
 }
-EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
-void reprogram_fixed_counter(struct kvm_pmc *pmc)
+static void reprogram_fixed_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
@@ -286,7 +285,6 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc)
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
index db839578e8be..b264e8117be1 100644
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
index cc4a092f0d67..a69d2aeb7526 100644
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
2.35.0

