Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8685E649F3C
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiLLNAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiLLM7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 07:59:41 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E23E96;
        Mon, 12 Dec 2022 04:59:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t17so11942852pjo.3;
        Mon, 12 Dec 2022 04:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9Y0ocwG9zsjdx0J9icRyIrQgGVTmoJrYRtW0USxDT4=;
        b=fz4/d0WM30pFVK77zeklGc4Rvk2A3SLGoDBg8Mv2EZDKnx79zXZaX62GWoKn1a+cEb
         eUS1AiQvyeWhCvJ97KJrkxO8Y+8O9HivOlIanbMEK/ZfMFcaEpBirpWyfHe+ni2Hcwg8
         JjRiHLfsLepHQH0xzJGw2ZXoJ2TZoJFvw4eknnQq1EMrnswQ/oofuCXkrLtBArtY1A9E
         MgPJHCQl3546Swh3hCiGHrshzB62tA+zoVwsKbA6p2bdC8vtk/K3l+41bH2oKf57ww8y
         3e9fBV2Z74OiTdrKGmQbvmUoiJkmOsffUl8MArFLBurrvS/2qC3h/gSZ22TAc2rN3dqd
         L3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9Y0ocwG9zsjdx0J9icRyIrQgGVTmoJrYRtW0USxDT4=;
        b=E95UurlgE7fHrXFqA2ZBJzTtpmBScDpW1LARean2cDurMSBOe1YloyHAZB+aPvCv9p
         46K6Y/Fy1FgpfKkYlL7nUgPP7s0lHbG4tdXtgv6uMmB7n8aqSWPZ0TrHCY5FQEOO0rIl
         uD7xfq0AB1FzASQEheudRjno/Pn8vI5JM76cBBG+2yiLBvkp5jU7GHsQqAwlnN1hIYx6
         Auxf2v33YcMYWwRn5VgrUQtTiSHF4hxoGvbg2iIz9yA9Je3UWvkiIx4YqMn6gpUgYfrn
         CbKeDXNISuDtpyCZRFlaKcInwXuu/pKdH+QjIF6T5jea9RR1cqfsKio2Gw8ln7U+fUEx
         oUBQ==
X-Gm-Message-State: ANoB5plOPRbC//crzsdYUojgwu5TpQKdEKJsHHp71TrHNInNJgXMHfUy
        +z9AH3XW/SIvlHo0e14lEl4=
X-Google-Smtp-Source: AA0mqf45rp7nvp2txzzXp+3WgpaoxYAsQ305+KFHfNFhX5uLlAub1xPrSfRdyjynq7N4PytMnVdI3Q==
X-Received: by 2002:a17:902:f64d:b0:189:603d:ea71 with SMTP id m13-20020a170902f64d00b00189603dea71mr16863149plg.58.1670849966211;
        Mon, 12 Dec 2022 04:59:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00186f608c543sm6273927plb.304.2022.12.12.04.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 04:59:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RFC 5/8] KVM: x86/pmu: Add kernel-defined slots event to enable Fixed Counter3
Date:   Mon, 12 Dec 2022 20:58:41 +0800
Message-Id: <20221212125844.41157-6-likexu@tencent.com>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20221212125844.41157-1-likexu@tencent.com>
References: <20221212125844.41157-1-likexu@tencent.com>
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

The Topdown Slots event can be enabled on gp counter or fixed counter3 and
it does not differ from other fixed counters in terms of the use of count
and sampling modes (except for the hardware logic for event accumulation).

According to commit 6017608936c1 ("perf/x86/intel: Add Icelake support"),
KVM or any perf in-kernel user needs to reprogram fixed counter3 via the
kernel-defined Topdown Slots event for real fixed counter3 on the host.

Opportunistically fix a typo, s/msrs_to_saved_all/msrs_to_save_all/.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 4 +++-
 arch/x86/kvm/x86.c              | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa4eb8cfcd7e..413f2e104543 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -513,7 +513,7 @@ struct kvm_pmc {
 #define KVM_INTEL_PMC_MAX_GENERIC	8
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define KVM_PMC_MAX_FIXED	3
+#define KVM_PMC_MAX_FIXED	4
 #define KVM_AMD_PMC_MAX_GENERIC	6
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d86a6ba8c3f9..637fd709f5f4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -36,6 +36,7 @@
  * the second part of hw_events is defined by the generic kernel perf:
  *
  * 8 - PERF_COUNT_HW_REF_CPU_CYCLES
+ * 9 - Kernel-defined Topdown Slots event (available on fixed counter 3)
  */
 static struct kvm_pmu_hw_event intel_arch_events[] = {
 	[0] = { 0x3c, 0x00 },
@@ -48,10 +49,11 @@ static struct kvm_pmu_hw_event intel_arch_events[] = {
 	[7] = { 0xa4, 0x01 },
 	/* The above index must match CPUID 0x0A.EBX bit vector */
 	[8] = { 0x00, 0x03 },
+	[9] = { 0x00, 0x04 },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */
-static int fixed_pmc_events[] = {1, 0, 8};
+static int fixed_pmc_events[] = {1, 0, 8, 9};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 312aea1854ae..0b61cb58c877 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1435,7 +1435,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
@@ -7001,8 +7001,8 @@ static void kvm_init_msr_list(void)
 	u32 dummy[2];
 	unsigned i;
 
-	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
-			 "Please update the fixed PMCs in msrs_to_saved_all[]");
+	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 4,
+			 "Please update the fixed PMCs in msrs_to_save_all[]");
 
 	num_msrs_to_save = 0;
 	num_emulated_msrs = 0;
-- 
2.38.2

