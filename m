Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF43C5AE247
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 10:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbiIFIQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 04:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiIFIQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 04:16:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED955AC77;
        Tue,  6 Sep 2022 01:16:32 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id jm11so10508054plb.13;
        Tue, 06 Sep 2022 01:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lvZzbkB8rGYf/bezpe/3vKyv2rU7WXd+Ux1/gYcga4o=;
        b=GYWJ8th4c/N9EpA7TJEElb4YWiouCBzouwMMDRGFQPjw1315mk3OVOAergtHGjyOGr
         ZEoodJGQpERT5v6L3vr0pData6BmaOoQFKVbXp8DuE7AYLusuP8fRFuWkqkO6vF6Pu4d
         bXNPQdvltQVKmzt9SIxP9YSpeh4yrdqrlvJU9dlOiE526hBxWRcWCg3e+JlkrVzF3vpR
         3Q7mUfnY009XMXVo31Xp0odsaMkC7rp0696ZXPE8WrC2Lrul2DujaTsNxLfgVvHFSoyk
         alskOtLMf4hTpNDrGC4TwbzGFQ75HezjdzU86DfErVsiNGO5alupodz2b9qr//AsPHFL
         ibdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lvZzbkB8rGYf/bezpe/3vKyv2rU7WXd+Ux1/gYcga4o=;
        b=AEWQdljz56uWDLVwY/4vrKvHYt/1O0w1FRs0JvVNhOoFx9xV/M9DurrWcZ7L4+Ofas
         6yWdt5/Vq1Ab4CtVi1bzKouQDWMiEn10QrGYPWGfM51wOyavYVr+1gdZGDiruHJHndb0
         9oymKYXqqDbD5CNmbm992OO+krpSbk3JVHp+wsroiB5C9qd1cDdEsac2ChPFZ5vYVmJK
         7YL+5WajeZxfqkyAGZjKRPFDz1Q1xFYmZ2NYi42ckNPuElxa2epfLTn3NcZ/nNY1s5km
         Odz2P99YUqcaPKF3EoTsqAKl9/mG3Y7UNNASqVXje3RdKpudL7xwWXUvHzU6ml19ed/9
         FGBw==
X-Gm-Message-State: ACgBeo2sf3ohDTYC0FYGunYE3H2y4yF90Z2YCs0g7/FACGXSkOnj1qJW
        74/Ipm1BYGskPOzUMfKTisC1/VFqJgLGXQ==
X-Google-Smtp-Source: AA6agR4BwtWFwyG+6tnjYqjPBncgEEU6XGSybTdnTJmZ3YkS/NlMysGGH35yPVb+/fysBQNtThKadw==
X-Received: by 2002:a17:902:d50d:b0:173:16a0:c226 with SMTP id b13-20020a170902d50d00b0017316a0c226mr52685521plg.160.1662452192010;
        Tue, 06 Sep 2022 01:16:32 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c8-20020a621c08000000b0053e4296e1d3sm487813pfc.198.2022.09.06.01.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 01:16:31 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jamttson@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: omit "impossible" Intel counter MSRs from MSR list
Date:   Tue,  6 Sep 2022 16:16:04 +0800
Message-Id: <20220906081604.24035-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to Intel April 2022 SDM - Table 2-2. IA-32 Architectural MSRs,
combined with the address reservation ranges of PERFCTRx, EVENTSELy, and
MSR_IA32_PMCz, the theoretical effective maximum value of the Intel GP
counters is 14, instead of 18:

  14 = 0xE = min (
    0xE = IA32_CORE_CAPABILITIES (0xCF) - IA32_PMC0 (0xC1),
    0xF = IA32_OVERCLOCKING_STATUS (0x195) - IA32_PERFEVTSEL0 (0x186),
    0xF = IA32_MCG_EXT_CTL (0x4D0) - IA32_A_PMC0 (0x4C1)
  )

the source of the incorrect number may be:
  18 = 0x12 = IA32_PERF_STATUS (0x198) - IA32_PERFEVTSEL0 (0x186)
but the range covers IA32_OVERCLOCKING_STATUS, which is also architectural.

Cut the list to 14 entries to avoid false positives.

Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Jim Mattson <jamttson@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: cf05a67b68b8 ("KVM: x86: omit "impossible" pmu MSRs from MSR list")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..98cdd4221447 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1431,8 +1431,6 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_PERFCTR0 + 8, MSR_ARCH_PERFMON_PERFCTR0 + 9,
 	MSR_ARCH_PERFMON_PERFCTR0 + 10, MSR_ARCH_PERFMON_PERFCTR0 + 11,
 	MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
-	MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
-	MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
 	MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
@@ -1440,8 +1438,6 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 8, MSR_ARCH_PERFMON_EVENTSEL0 + 9,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 10, MSR_ARCH_PERFMON_EVENTSEL0 + 11,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
@@ -6943,12 +6939,12 @@ static void kvm_init_msr_list(void)
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
+		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 13:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
 			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
-		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
+		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 13:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
-- 
2.37.3

