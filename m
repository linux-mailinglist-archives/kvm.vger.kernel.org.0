Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AE26BCE46
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 12:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCPLeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 07:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCPLdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 07:33:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6182E1C7DA;
        Thu, 16 Mar 2023 04:33:43 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k2so1380696pll.8;
        Thu, 16 Mar 2023 04:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678966422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OMcGys+aUXZl6oMblnaGMEvtWXDzLim778FcaXE7Inc=;
        b=O8RdRpU3hGI+zAweNOcR8MwIgFdQmRprKaVs/zHc40mJ+uJ5RrCvgAUnx6vtFRySi/
         zctMafM1qYuoV47yK9JEN7f/pFY9SmQ7lF5MMalJRGI609O9NAeKXWSTM4Aq+e+dsStZ
         KtgF0PCCu3S8cj+dPM2Mlsyhtw4bKMwa9ZkTA3vj3wrwcNZPcnL+jaZl57FNT4Cp2lVV
         Z5d8qXLZyiPjPmmhgSBpUpVHyA5LZYOsM07dwVmm9NMJEQ03LgYaiyVR0Tgk1RCsVyaN
         0Ss/2AzFpH7ReQVzQ8BnK6J96hQiRtmEIG8vUo43G9vU5ns6XXYFQ/DAA/iTA4U0ofjL
         E14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678966422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OMcGys+aUXZl6oMblnaGMEvtWXDzLim778FcaXE7Inc=;
        b=YQZeRw867V0UppGF8INhKEyRwru5Akwig5rse8iyw7nnu4QCLRRK6Yzl5BURUzFo8Q
         6GdifsUrfwkj3A3MiSyJK+OvYvogVduNDw9k8jCz3I5jPniUz3nfO0aVSI6d4Q+QyAqL
         o+3mJYCigYaf6BjXOeO3cpUQPOc6IdLH0Uai7FRgmOYueODI8w4hQi8SK1Yq7KunZWv8
         J6jKFJmQPstvuYxeMMt+fccvMSn5NaEYuYJe4puHPoXbJpw6Gsp/k3MD5vhnBT9nTRPr
         Ie8NUXXG6ASo8pVyjtn8bzZjV3hkjI2K9fqOaSojDgeFQGb0fS769tGRSb7LlvF06iGZ
         2IMA==
X-Gm-Message-State: AO0yUKVhWOYelZzt05JQr08mI1vveqNfOCuZSIC3MHkkjpe6oYLbTuzL
        qwXQZM+pTc5Hyo3XeNIHR54=
X-Google-Smtp-Source: AK7set/8RKrY6mdVqQX5kkbs82yDrytygXzmxvnuKmX25zSH/ZIXewjxF5c5znPWXBMQWs4cmUtfZQ==
X-Received: by 2002:a05:6a20:7347:b0:d6:17fc:9f66 with SMTP id v7-20020a056a20734700b000d617fc9f66mr3725155pzc.18.1678966422522;
        Thu, 16 Mar 2023 04:33:42 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y18-20020aa78052000000b005a8bf239f5csm5222974pfm.193.2023.03.16.04.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 04:33:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Fix emulation on counters' bit width
Date:   Thu, 16 Mar 2023 19:33:12 +0800
Message-Id: <20230316113312.54714-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to the latest Intel SDM, the bit width of a PMU counter
is specified via CPUID only if the vCPU has FW_WRITE[bit 13] on
IA32_PERF_CAPABILITIES. Moreover, if this bit is deliberately removed
from KVM's user space, the only valid value written to is EAX[31:0].

Opportunistically BIT_ULL() is applied.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cc77a0681800..0d45dc55326b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -178,7 +178,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	else
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
 
-	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
+	pmu->counter_bitmask[KVM_PMC_GP] = BIT_ULL(48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
 	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	pmu->version = 1;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..1c9d87856c37 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -516,6 +516,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid10_edx edx;
 	u64 perf_capabilities;
 	u64 counter_mask;
+	bool fw_wr = fw_writes_is_enabled(vcpu);
 	int i;
 
 	pmu->nr_arch_gp_counters = 0;
@@ -545,7 +546,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 					 kvm_pmu_cap.num_counters_gp);
 	eax.split.bit_width = min_t(int, eax.split.bit_width,
 				    kvm_pmu_cap.bit_width_gp);
-	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
+	pmu->counter_bitmask[KVM_PMC_GP] =
+		BIT_ULL(fw_wr ? eax.split.bit_width : 32) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length,
 				      kvm_pmu_cap.events_mask_len);
 	pmu->available_event_types = ~entry->ebx &
@@ -561,7 +563,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
-			((u64)1 << edx.split.bit_width_fixed) - 1;
+			BIT_ULL(fw_wr ? edx.split.bit_width_fixed : 32) - 1;
 		setup_fixed_pmc_eventsel(pmu);
 	}
 

base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.39.2

