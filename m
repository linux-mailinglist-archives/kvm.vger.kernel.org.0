Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942704CA302
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiCBLPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241310AbiCBLOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:54 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D18160CE5;
        Wed,  2 Mar 2022 03:14:10 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d187so1635596pfa.10;
        Wed, 02 Mar 2022 03:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a2RlQZ2iizWHD3Xw4Au9Wt4VFbR0MwR2hX1HXuetx0Y=;
        b=DtVDN+03l0niY0QlQRI4wBg/cDWpWRXI0YI+8cl7wudhDkhD3YYXqzI8Cm4xGYpedX
         zhtiUrp42Y5AoURmitVPqXkQ60aStWqqXZEsraQf8VRaUavKoDgBPDBoptOXhugybcBQ
         +qNKmz931lbcSBMmD9v+Zngi+/EEgzMQAyTX/N5QoPG039qRDPwUqGa3TcQEHL4xqMQO
         WcgoVh3iI1S1dsyfaEdrpz/aD2erdZjFLyxLGXhwbQdECOSizDDVIH2DOU4rqziaryYx
         Wn2DyTKi8uGyYnduClHsU1ceFH8B3TUQnkAnPfoKbR6QoJ8EL6jZbEe1DDIjLjOTacYh
         s4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a2RlQZ2iizWHD3Xw4Au9Wt4VFbR0MwR2hX1HXuetx0Y=;
        b=zGoxFM3lIFVOWm64D+vRmQwOu2pzyW1idf4qQJk5z/JIuBGvTMUusQIlzbEaQxvQO7
         bUOl5+0Q8NfIEcmkK+XIziZrMCt2hlKZ+L7DgMp6uzACcvbZxz4s0NOYxdNId1T+Hi3v
         V3HtwAn5D5DvnBmD1HGOah9XOzT4t1eVVgGmtzFt/c/JYhZ5+PkFBQoYZvN3Fzw7rI2q
         lsbTZ0GmpMbIeqYnSqjQmJG0gY6aTxsvYbIuK+mda0ypC2y3UpBN7DonxPzsxvCBPXIa
         n0AU80s8ikpnx7ItjkLc+yXNfq404eP7A+dJumI2hdgqqAt8nhvmtcaHb+YI60lavzDK
         aNKw==
X-Gm-Message-State: AOAM533gO685NfdvvbigF4ctmdCFUKVCCvUFheEsS56Qwrh7NX/WnQ/6
        PAhBxkj5/goEo9bVPDlHDPCIfykVogq38kBK
X-Google-Smtp-Source: ABdhPJw69Cv3Aul72fkXcwhYbwLUFHhQES3vNATuR0q5i4JW94RDILWS+JZ7A2vcG8CpOT//17EOcw==
X-Received: by 2002:a63:195a:0:b0:372:bae2:d124 with SMTP id 26-20020a63195a000000b00372bae2d124mr25311167pgz.412.1646219649853;
        Wed, 02 Mar 2022 03:14:09 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:14:09 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 10/12] KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
Date:   Wed,  2 Mar 2022 19:13:32 +0800
Message-Id: <20220302111334.12689-11-likexu@tencent.com>
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

All gp or fixed counters have been reprogrammed using PERF_TYPE_RAW,
which means that the table that maps perf_hw_id to event select values is
no longer useful, at least for AMD.

For Intel, the logic to check if the pmu event reported by Intel cpuid is
not available is still required, in which case pmc_perf_hw_id() could be
renamed to hw_event_is_unavail() and a bool value is returned to replace
the semantics of "PERF_COUNT_HW_MAX+1".

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  6 +++---
 arch/x86/kvm/pmu.h           |  2 +-
 arch/x86/kvm/svm/pmu.c       | 34 +++-------------------------------
 arch/x86/kvm/vmx/pmu_intel.c | 11 ++++-------
 4 files changed, 11 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9fb7d29e5fdd..60f44252540a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -114,9 +114,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
-	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
-		return;
-
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
@@ -190,6 +187,9 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	__u64 key;
 	int idx;
 
+	if (kvm_x86_ops.pmu_ops->hw_event_is_unavail(pmc))
+		return false;
+
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (!filter)
 		goto out;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 201b99628423..a2b4037759a2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,7 +24,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
+	bool (*hw_event_is_unavail)(struct kvm_pmc *pmc);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index a18bf636fbce..41c9b9e2aec2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,18 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-/* duplicated from amd_perfmon_event_map, K7 and above should work. */
-static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
-	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES },
-	[3] = { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES },
-	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[6] = { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
-	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
-};
-
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -138,25 +126,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool amd_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-	if (WARN_ON(pmc_is_fixed(pmc)))
-		return PERF_COUNT_HW_MAX;
-
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
-			break;
-
-	if (i == ARRAY_SIZE(amd_event_mapping))
-		return PERF_COUNT_HW_MAX;
-
-	return amd_event_mapping[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
@@ -322,7 +294,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
+	.hw_event_is_unavail = amd_hw_event_is_unavail,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d823fbe4e155..9b94674cc5fa 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -84,7 +84,7 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 	}
 }
 
-static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
+static bool intel_hw_event_is_unavail(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
@@ -98,15 +98,12 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 
 		/* disable event that reported as not present by cpuid */
 		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
-			return PERF_COUNT_HW_MAX + 1;
+			return true;
 
 		break;
 	}
 
-	if (i == ARRAY_SIZE(intel_arch_events))
-		return PERF_COUNT_HW_MAX;
-
-	return intel_arch_events[i].event_type;
+	return false;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -721,7 +718,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
+	.hw_event_is_unavail = intel_hw_event_is_unavail,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.35.1

