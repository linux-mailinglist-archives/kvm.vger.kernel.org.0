Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33519694EAF
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjBMSDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjBMSCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:02:55 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0255166D0
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:47 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id e16-20020a6b5010000000b00719041c51ebso8831216iob.12
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4pVme0YnvFkbmhGf1BNKoMvu6OdpqpHsZJlFNEmDZU=;
        b=IUlIvqk99wOkDyN8QxvxQiqVaFMxbqcgA9uNoQQZndNpq1vnhI1bsorC5l7knDzNI1
         CNDo0y4gWYWsjH8HGIUC2KbuMfUKXfm7ePcqNQpy+Qs4qo8ajWDUsOujEIEHzjn327wK
         sZ1ayR5mmnOmUCp4kpQavgmctGK3PWKE8lV3wz7hGdhQau+QWqpp26566SvWZ7ItdtGp
         m6IcH36QOlGywNrGdqHCpVGddGG8i6Xw2nKmdn1sn1BnyRI/jVLOCzIkw/xbo4NTXMGy
         /IjMPtH0X6J6GrDvjXmIAlRLaq0mI7ZT34see0s7lbyDyBucG6Lo7pboRUp5GpzbE3TB
         P77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4pVme0YnvFkbmhGf1BNKoMvu6OdpqpHsZJlFNEmDZU=;
        b=Y0AyRn0rAz0rGxtayjg2nB4IiObeNs2pMt2mQfImickds0864P031+RtGgJObyiDSb
         M3GmCGr6n/YDyPbz7CGZQXTeJZBY1LPu6OBXeKgee+VeICJKGDfA4XsE3dT4W/knfD4w
         XeqHtxS5KUvoagb9Lc0ljl+/XXemgTDyvI1FjA0P3Ez6x6ObrveWK/LYDLdGa0FkGIAn
         v6QYwHZwv8R4tu8Ae+CrhnKW0HaKvYy3MIdDTdioSLAmQ4Ddpg2NsoZM+l8K5d1pAJwp
         QtAV1l+kzKSgnag2Om0XI7/9f6U7yjyMnVQ7Dp0/YUr13op4PDwRokXhNOdom3631enU
         +wZQ==
X-Gm-Message-State: AO0yUKX6wjGBbjYPHy9X5WwlXbYFdyOQBMpBryxhpXsn1t3fM3deXW9y
        5ArgP4Vpz2+rw/9gTYfjOhLdQ5mBWcUh
X-Google-Smtp-Source: AK7set/zRoXeDH2o2OgI5SNOkKe9Bljn/xqjOVO+iFT8+upLAFbhCUFo5GurkgO+YcVUEBjj4XoXzR5ZKsrW
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:9409:0:b0:310:9fc1:a92b with SMTP id
 c9-20020a929409000000b003109fc1a92bmr2739337ili.0.1676311367115; Mon, 13 Feb
 2023 10:02:47 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:02:28 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-8-rananta@google.com>
Subject: [PATCH 07/13] selftests: KVM: aarch64: Add KVM EVTYPE filter PMU test
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM doest't allow the guests to modify the filter types
such counting events in nonsecure/secure-EL2, EL3, and
so on. Validate the same by force-configuring the bits
in PMXEVTYPER_EL0, PMEVTYPERn_EL0, and PMCCFILTR_EL0
registers.

The test extends further by trying to create an event
for counting only in EL2 and validates if the counter
is not progressing.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 3dfb770b538e9..5c166df245589 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -15,6 +15,10 @@
  * of allowing or denying the events. The guest validates it by
  * checking if it's able to count only the events that are allowed.
  *
+ * 3. KVM doesn't allow the guest to count the events attributed with
+ * higher exception levels (EL2, EL3). Verify this functionality by
+ * configuring and trying to count the events for EL2 in the guest.
+ *
  * Copyright (c) 2022 Google LLC.
  *
  */
@@ -23,6 +27,7 @@
 #include <test_util.h>
 #include <vgic.h>
 #include <asm/perf_event.h>
+#include <linux/arm-smccc.h>
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
 
@@ -259,6 +264,7 @@ struct vpmu_vm {
 enum test_stage {
 	TEST_STAGE_COUNTER_ACCESS = 1,
 	TEST_STAGE_KVM_EVENT_FILTER,
+	TEST_STAGE_KVM_EVTYPE_FILTER,
 };
 
 struct guest_data {
@@ -678,6 +684,70 @@ static void guest_event_filter_test(unsigned long *pmu_filter)
 	}
 }
 
+static void guest_evtype_filter_test(void)
+{
+	int i;
+	struct pmc_accessor *acc;
+	uint64_t typer, cnt;
+	struct arm_smccc_res res;
+
+	pmu_enable();
+
+	/*
+	 * KVM blocks the guests from creating events for counting in Secure/Non-Secure Hyp (EL2),
+	 * Monitor (EL3), and Multithreading configuration. It applies the mask
+	 * ARMV8_PMU_EVTYPE_MASK against guest accesses to PMXEVTYPER_EL0, PMEVTYPERn_EL0,
+	 * and PMCCFILTR_EL0 registers to prevent this. Check if KVM honors this using all possible
+	 * ways to configure the EVTYPER.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		acc = &pmc_accessors[i];
+
+		/* Set all filter bits (31-24), readback, and check against the mask */
+		acc->write_typer(0, 0xff000000);
+		typer = acc->read_typer(0);
+
+		GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) == ARMV8_PMU_EVTYPE_MASK,
+				typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_PMU_EVTYPE_MASK);
+
+		/*
+		 * Regardless of ARMV8_PMU_EVTYPE_MASK, KVM sets perf attr.exclude_hv
+		 * to not count NS-EL2 events. Verify this functionality by configuring
+		 * a NS-EL2 event, for which the couunt shouldn't increment.
+		 */
+		typer = ARMV8_PMUV3_PERFCTR_INST_RETIRED;
+		typer |= ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
+		acc->write_typer(0, typer);
+		acc->write_cntr(0, 0);
+		enable_counter(0);
+
+		/* Issue a hypercall to enter EL2 and return */
+		memset(&res, 0, sizeof(res));
+		smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
+
+		cnt = acc->read_cntr(0);
+		GUEST_ASSERT_3(cnt == 0, cnt, typer, i);
+	}
+
+	/* Check the same sequence for the Cycle counter */
+	write_pmccfiltr(0xff000000);
+	typer = read_pmccfiltr();
+	GUEST_ASSERT_2((typer | ARMV8_PMU_EVTYPE_EVENT) == ARMV8_PMU_EVTYPE_MASK,
+				typer | ARMV8_PMU_EVTYPE_EVENT, ARMV8_PMU_EVTYPE_MASK);
+
+	typer = ARMV8_PMU_INCLUDE_EL2 | ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
+	write_pmccfiltr(typer);
+	reset_cycle_counter();
+	enable_cycle_counter();
+
+	/* Issue a hypercall to enter EL2 and return */
+	memset(&res, 0, sizeof(res));
+	smccc_hvc(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	cnt = read_cycle_counter();
+	GUEST_ASSERT_2(cnt == 0, cnt, typer);
+}
+
 static void guest_code(void)
 {
 	switch (guest_data.test_stage) {
@@ -687,6 +757,9 @@ static void guest_code(void)
 	case TEST_STAGE_KVM_EVENT_FILTER:
 		guest_event_filter_test(guest_data.pmu_filter);
 		break;
+	case TEST_STAGE_KVM_EVTYPE_FILTER:
+		guest_evtype_filter_test();
+		break;
 	default:
 		GUEST_ASSERT_1(0, guest_data.test_stage);
 	}
@@ -1014,10 +1087,22 @@ static void run_kvm_event_filter_test(void)
 	run_kvm_event_filter_error_tests();
 }
 
+static void run_kvm_evtype_filter_test(void)
+{
+	struct vpmu_vm *vpmu_vm;
+
+	guest_data.test_stage = TEST_STAGE_KVM_EVTYPE_FILTER;
+
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
+	run_vcpu(vpmu_vm->vcpu);
+	destroy_vpmu_vm(vpmu_vm);
+}
+
 static void run_tests(uint64_t pmcr_n)
 {
 	run_counter_access_tests(pmcr_n);
 	run_kvm_event_filter_test();
+	run_kvm_evtype_filter_test();
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

