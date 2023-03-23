Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F06C60B2
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCWH1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjCWH1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CDB2A168;
        Thu, 23 Mar 2023 00:27:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso2751946pjc.1;
        Thu, 23 Mar 2023 00:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chk6Tj1rRZBFg6p/u1Cz16TGflXfW9DAHZR0hRI7XxQ=;
        b=W+rD1fTyQmesSPEFu9HKEt1vI65zgHbfaSHy/DB3ynMfEsFrDJbOsG5aWh6yLyVPKW
         +fqS0spogSm1i0dR8jO3M7ZOX/ZfwU0hZaBc/W1ESfQnI6hU4v9mqHorFnccu2j4gMDO
         /g7KsZKYIwcdjTPZVhFibRQCcGQhTA0GqfK0bh2EdkLhqb/B+fZNZWo7KqNIURoWIQH4
         x+89GxVtGVUiVC5JqqxrAFWdq7xr0UPtLZqHU7R6KKxCL/Q0E/Z28sucEQcd87uFGhH9
         iVU06YyZBGWsEokDpXcPDLoqkmlcRpA/sY3utsKrMrR/Q07P3Rprv4/zuFn0EBVfSAJ8
         IYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Chk6Tj1rRZBFg6p/u1Cz16TGflXfW9DAHZR0hRI7XxQ=;
        b=qztLUGpU3Uv946Ym6b1bM4rNH/70S8H48Hh9w4dYNmOUZ4h0/1BKOT2ECxYx+wk6m5
         ytrFd+ve7i1pdO6wQeQeuRF+93c3Jibjk4AUzuj4q51titI1XeUMDizXgacsMUglS0zo
         klPJR5qYwRDrn5FjJ+yCWbRo4xyyFmpuNmIm4OJ7CkX2VJV8jCUcShBZoyKBqI7rfSZ0
         8AAo1JGsh9w3YPloQ8+ty3A/C3sH48UxHdY+lCxsqsKDJANA0FxFRjea8hnq+//JTzQe
         nSTL8bizY/rbd4X/1YNGduWb+FjVphypITswxAaEmslDmkJYPD65mSQavIoFd14uTdOG
         JK2Q==
X-Gm-Message-State: AO0yUKWiyRKjz2sHuVKOdcBulj7XW4mzlWxw/L0SAKvZ3KYeIPVgWvBR
        zOMHsyLHfGPoIrwnjmYSYDc=
X-Google-Smtp-Source: AK7set/oSLzdNvM3QVVWbJ2qcN5VQOEkJ4HoYhcdiCiTz1Qh69Lbu+ECg4MlEiB29cUGHRoIvInZVw==
X-Received: by 2002:a17:903:120a:b0:19e:7d67:84e6 with SMTP id l10-20020a170903120a00b0019e7d6784e6mr6576914plh.0.1679556459548;
        Thu, 23 Mar 2023 00:27:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:39 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/7] KVM: selftests: Test Intel PMU architectural events on fixed counters
Date:   Thu, 23 Mar 2023 15:27:09 +0800
Message-Id: <20230323072714.82289-3-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230323072714.82289-1-likexu@tencent.com>
References: <20230323072714.82289-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 37 +++++++++++++++++--
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index faab0a91e191..75434aa2a0ec 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -25,6 +25,9 @@
 #define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
 #define EVT_LEN_OFS_BIT 24
 #define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
+#define INTEL_PMC_IDX_FIXED 32
+#define RDPMC_FIXED_BASE BIT_ULL(30)
+#define FIXED_CTR_NUM_MASK GENMASK_ULL(4, 0)
 
 #define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
 
@@ -43,6 +46,14 @@ static const uint64_t arch_events[] = {
 	[7] = ARCH_EVENT(0xa4, 0x1), /* Topdown Slots */
 };
 
+/* Association of Fixed Counters with Architectural Performance Events */
+static int fixed_events[] = {1, 0, 7};
+
+static uint64_t evt_code_for_fixed_ctr(uint8_t idx)
+{
+	return arch_events[fixed_events[idx]];
+}
+
 static struct kvm_vcpu *new_vcpu(void *guest_code)
 {
 	struct kvm_vm *vm;
@@ -88,8 +99,8 @@ static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
 }
 
 static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
-				       bool supported, uint32_t ctr_base_msr,
-				       uint64_t evt_code)
+				       uint8_t max_fixed_num, bool supported,
+				       uint32_t ctr_base_msr, uint64_t evt_code)
 {
 	uint32_t global_msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	unsigned int i;
@@ -108,6 +119,23 @@ static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
 		GUEST_SYNC(supported == !!_rdpmc(i));
 	}
 
+	/* No need to test independent arch events on fixed counters. */
+	if (version > 1 && max_fixed_num > 1 &&
+	    (evt_code == evt_code_for_fixed_ctr(0) ||
+	     evt_code == evt_code_for_fixed_ctr(1))) {
+		i = (evt_code == evt_code_for_fixed_ctr(0)) ? 0 : 1;
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr(global_msr, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+		wrmsr(global_msr, 0);
+
+		GUEST_SYNC(supported == !!_rdpmc(RDPMC_FIXED_BASE | i));
+	}
+
 	GUEST_DONE();
 }
 
@@ -131,9 +159,10 @@ static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
 	is_supported = !(entry->ebx & BIT_ULL(idx)) &&
 		(((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
 
-	vcpu_args_set(vcpu, 5, entry->eax & PMU_VERSION_MASK,
+	vcpu_args_set(vcpu, 6, entry->eax & PMU_VERSION_MASK,
 		      (entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT,
-		      is_supported, ctr_msr, arch_events[idx]);
+		      (entry->edx & FIXED_CTR_NUM_MASK), is_supported,
+		      ctr_msr, arch_events[idx]);
 }
 
 static void intel_check_arch_event_is_unavl(uint8_t idx)
-- 
2.40.0

