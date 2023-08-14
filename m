Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DAA77B7CD
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjHNLwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjHNLvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE22EA;
        Mon, 14 Aug 2023 04:51:35 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-68783b2e40bso2897393b3a.3;
        Mon, 14 Aug 2023 04:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013895; x=1692618695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Isc+tGprLo3aak9bWJdMKknXw+IJrOLcgnKWJJM4lY=;
        b=TnNoGgFotOm7S+iWt84C2+bCoMsxRYGXYWfdmRTgOwmTnsb3CobNvjSOCKYtC16Cla
         DPNSjOtqnkSg5MrFihzNupOUmMMKqtMJ1c61CIwnMUJXyyzELKjxY7oGoR9M+OkUdIqv
         L5GpBfKSSCt2tbPrDHLkuNZLt+gQDb9g6xTt3IOoFBlnWIZXdOaMfRVHsTeeEOz24gzJ
         FKyTJ8G4vs4t3JGIJE/oDeCMlaWAWYToEn60GwVxm7uyl138w2qs5/izcfEBBNaGpiIl
         UkxtlNaZbo6B2X+dixpcK0yz7E9AEks1K4uMOYq9bzXrDO2qNEdho6jyMHPL3RVpDZLU
         44FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013895; x=1692618695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Isc+tGprLo3aak9bWJdMKknXw+IJrOLcgnKWJJM4lY=;
        b=DdX8TJpycaU9970A+dSCzw4XFMf5/17jCINELDyV7j3JQGipCb++zXQB+xkTZWYEYr
         ouZx8PzkokH8CHFvNJ0qpks0bCSjzl3atYp6+MBkdOK4HNfsIkwZ/mwq6t4w38QDL3Vk
         maukn2KaoRE7eqO0U8X3914xrMgKs8Ctuq+gZLo8EbKjbyPl0Q1TAfCXnUddBrYL2BhX
         Z6iGsUnW/WI6/1jHx8tpirpxHYTnOqUD8lKBALhtUXXTzZfZ5HJbYEWQYEWDXHukXYl3
         vANsQVzpQn1364Y+szMxwac0InJAT4OWhfm6OuvaB9vez9Cf3mzJTIARGH2KZ5WuFI5w
         3cxQ==
X-Gm-Message-State: AOJu0YxWDygqoqECbQ0dbgR+ESKSCWdq/5gfVMLLvQiKDmDULeu6iLEI
        BjDtsrGSQ7gAkcp12I8RIvw=
X-Google-Smtp-Source: AGHT+IGPVokJ/z0kOtUc2p2hGpNzMsgHljlX9ntMujLgO+jlTFpot/ArWe0qBYrRjMZLs08tpNVnUA==
X-Received: by 2002:a05:6a20:12d1:b0:13d:ac08:6b72 with SMTP id v17-20020a056a2012d100b0013dac086b72mr10160283pzg.18.1692013895007;
        Mon, 14 Aug 2023 04:51:35 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:34 -0700 (PDT)
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
Subject: [PATCH v3 04/11] KVM: selftests: Test Intel PMU architectural events on fixed counters
Date:   Mon, 14 Aug 2023 19:51:01 +0800
Message-Id: <20230814115108.45741-5-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Update test to cover Intel PMU architectural events on fixed counters.
Per Intel SDM, PMU users can also count architecture performance events
on fixed counters (specifically, FIXED_CTR0 for the retired instructions
and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
indicates that an architecture event is not available, the corresponding
fixed counter will also not count that event.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 .../kvm/x86_64/pmu_basic_functionality_test.c | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
index c04eb0bdf69f..daa45aa285bb 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -47,6 +47,7 @@ static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
 
 static void guest_measure_loop(uint64_t event_code)
 {
+	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
 	uint32_t counter_msr;
@@ -73,6 +74,26 @@ static void guest_measure_loop(uint64_t event_code)
 		}
 	}
 
+	if (pmu_version < 2 || nr_fixed_counter < 1)
+		goto done;
+
+	if (event_code == intel_arch_events[INTEL_ARCH_INSTRUCTIONS_RETIRED])
+		i = 0;
+	else if (event_code == intel_arch_events[INTEL_ARCH_CPU_CYCLES])
+		i = 1;
+	else
+		goto done;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	GUEST_SYNC(_rdpmc(RDPMC_FIXED_BASE | i));
+
+done:
 	GUEST_DONE();
 }
 
-- 
2.39.3

