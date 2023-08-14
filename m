Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88677B7D9
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjHNLwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjHNLv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:57 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3660CEA;
        Mon, 14 Aug 2023 04:51:56 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id ca18e2360f4ac-77acb04309dso203621439f.2;
        Mon, 14 Aug 2023 04:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013915; x=1692618715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20tjvbePUAfEV6JgW2FKzFkjTz/aXRRiD/7BadIt25E=;
        b=DoCvn378mtZOPxRQN3nFkhu40qYpfHAUGuQG0BNtR2t5Bf4w2XrOuoFjflOGVN3B2+
         8gN+ojhWJjUdCHs0Ax4Xtqfk3IPdx4xTC+r6VJg+1xBcTKXPtL2e9XF83VHHqjgS3ML6
         dXolPRCenT2oukRMBWwX/mDHKe+YyH3Cl/0T/FMhaOCh88rJifTJZyN2hbDC6TlFRraP
         RygcspI0k3u2yNKAoF6sqFYjMsxAx+JV79nPwf3Sq8+Ge/bowkD3A1xgqlUZEzI7vpyW
         649oEDRbb9PdkRKjTbvpFBPj5Soqc/EgnA29ooQaKi6bKA/hVsPd9/QobNR0hhUeLHlh
         GACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013915; x=1692618715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20tjvbePUAfEV6JgW2FKzFkjTz/aXRRiD/7BadIt25E=;
        b=NF21ne4j+tHex/vDIU5d9BbkDoCxlGif4Ctkwoo4uqRLbeBpVrWjSSTwE0/uQYSvbi
         t1LtL6pmycY9eaQ0nGM244IAkzL8a16O9drn42eFlHce19ydi+9dpp59zxGfa4GDx5En
         LxcI81bsLCvO7eMI7xYJSnkzb5Gc3dVjrcQsTBgIuxPFMFVret7aFl1BdM2CxbSkfR+I
         o7qQNOnKBFXI6Ci+TluqE6LfKxzorddkAY+QjjbIwVBHcQIw2S10WwCxQL1bSiObT4Au
         pswIVA+07JF84/9qjGAWEzjF+i/v0QFIeF4b7GuqYA1eKBrYaSFdm8hvxoPNhgAnfHdg
         oARg==
X-Gm-Message-State: AOJu0YzZu0zQTkLj8a+cZqnd2oVw77nQwxJ6bdnlfZkHHppVlpQGPeio
        KKtI/3zFmhO8ZioNg78LJNI=
X-Google-Smtp-Source: AGHT+IF+ErgJvZY8p1Nd9FZsjgYqCnBE3X9FfVE1ZHWA+Zxg3CWlhnJPydkghkGgTW1nhhu/ZLoaFg==
X-Received: by 2002:a05:6e02:12e9:b0:346:5bd7:4a17 with SMTP id l9-20020a056e0212e900b003465bd74a17mr16644925iln.17.1692013915595;
        Mon, 14 Aug 2023 04:51:55 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:55 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/11] KVM: selftests: Test AMD Guest PerfMonV2
Date:   Mon, 14 Aug 2023 19:51:08 +0800
Message-Id: <20230814115108.45741-12-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Add test case for AMD Guest PerfMonV2. Also test Intel
MSR_CORE_PERF_GLOBAL_STATUS and MSR_CORE_PERF_GLOBAL_OVF_CTRL.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 48 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index cb2a7ad5c504..02bd1fe3900b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -58,7 +58,9 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
 
 static void guest_measure_loop(uint64_t event_code)
 {
+	uint64_t global_ovf_ctrl_msr, global_status_msr, global_ctrl_msr;
 	uint8_t nr_gp_counters, pmu_version = 1;
+	uint8_t gp_counter_bit_width = 48;
 	uint64_t event_sel_msr;
 	uint32_t counter_msr;
 	unsigned int i;
@@ -68,6 +70,12 @@ static void guest_measure_loop(uint64_t event_code)
 		pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
 		event_sel_msr = MSR_P6_EVNTSEL0;
 
+		if (pmu_version > 1) {
+			global_ovf_ctrl_msr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
+			global_status_msr = MSR_CORE_PERF_GLOBAL_STATUS;
+			global_ctrl_msr = MSR_CORE_PERF_GLOBAL_CTRL;
+		}
+
 		if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
 			counter_msr = MSR_IA32_PMC0;
 		else
@@ -76,6 +84,17 @@ static void guest_measure_loop(uint64_t event_code)
 		nr_gp_counters = AMD64_NR_COUNTERS;
 		event_sel_msr = MSR_K7_EVNTSEL0;
 		counter_msr = MSR_K7_PERFCTR0;
+
+		if (this_cpu_has(X86_FEATURE_AMD_PMU_EXT_CORE) &&
+		    this_cpu_has(X86_FEATURE_AMD_PERFMON_V2)) {
+			nr_gp_counters = this_cpu_property(X86_PROPERTY_AMD_PMU_NR_CORE_COUNTERS);
+			global_ovf_ctrl_msr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR;
+			global_status_msr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
+			global_ctrl_msr = MSR_AMD64_PERF_CNTR_GLOBAL_CTL;
+			event_sel_msr = MSR_F15H_PERF_CTL0;
+			counter_msr = MSR_F15H_PERF_CTR0;
+			pmu_version = 2;
+		}
 	}
 
 	for (i = 0; i < nr_gp_counters; i++) {
@@ -84,14 +103,39 @@ static void guest_measure_loop(uint64_t event_code)
 		      ARCH_PERFMON_EVENTSEL_ENABLE | event_code);
 
 		if (pmu_version > 1) {
-			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
+			wrmsr(global_ctrl_msr, BIT_ULL(i));
 			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+			wrmsr(global_ctrl_msr, 0);
 			GUEST_SYNC(_rdpmc(i));
 		} else {
 			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 			GUEST_SYNC(_rdpmc(i));
 		}
+
+		if (pmu_version > 1 && _rdpmc(i)) {
+			wrmsr(global_ctrl_msr, 0);
+			wrmsr(counter_msr + i, 0);
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+			GUEST_ASSERT(!_rdpmc(i));
+
+			wrmsr(global_ctrl_msr, BIT_ULL(i));
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+			GUEST_ASSERT(_rdpmc(i));
+
+			if (host_cpu_is_intel)
+				gp_counter_bit_width =
+					this_cpu_property(X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH);
+
+			wrmsr(global_ctrl_msr, 0);
+			wrmsr(counter_msr + i, (1ULL << gp_counter_bit_width) - 2);
+			wrmsr(global_ctrl_msr, BIT_ULL(i));
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+			GUEST_ASSERT(rdmsr(global_status_msr) & BIT_ULL(i));
+
+			wrmsr(global_ctrl_msr, 0);
+			wrmsr(global_ovf_ctrl_msr, BIT_ULL(i));
+			GUEST_ASSERT(!(rdmsr(global_status_msr) & BIT_ULL(i)));
+		}
 	}
 
 	if (host_cpu_is_amd || pmu_version < 2)
-- 
2.39.3

