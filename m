Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7669732B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbjBOBIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjBOBHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:55 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B5B30EB9
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:33 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ec8c88d75so153438287b3.12
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/4pVme0YnvFkbmhGf1BNKoMvu6OdpqpHsZJlFNEmDZU=;
        b=ObqpJ3X4Zzzxcthx2JxQal7z6qTNzX0aROAeY+JqG1bSWZY5Eiu6wXNgAa1sJK4lp6
         BtjQCAheEnQDtcSI9+r2CfvzWHwsKFkiiiOElApjEDSk7ja4AX/Tsg3GePdBGX1TpxhH
         8RcFt91LUTW5UZzn+gaVrvMsveq0lmd1LdeCVKxyrLkdmSEzd3anP2KIw9YGNSiNsZoB
         7CYeHJCpj3CA+3IK5usRsXbXrlgz/CnR49SXSfnOLPv0T5fzBqfrgRgQAdvnG7lMoLdy
         mvpc8qoiQomiDHpToX8qlVk45/hmvVZDfWJoUtHP1t3KaeOl+8VXiq9tKR5z2CUzzTX8
         91gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4pVme0YnvFkbmhGf1BNKoMvu6OdpqpHsZJlFNEmDZU=;
        b=7/CzTcc1LyhHp5imu0ciiGZWwLXs9aksDSduf/xO+dsAidsOEy8hxuHCVx2qYBgsjG
         ihTSsXCV7RIVotOT5ujFb5LLj2z9SjWyHP7O6RnoKdmmnBXoM/nKFAzVD2ZVNizQNZb0
         wiyBaw4zgCVKp0C2Gu8T/mFhibXxBeHRQYVu0K/D6LE3MbANL7LF2ikmDo7w9XV65RH/
         BbFEXlZQA/P+Kv4izU2zLj3sqZ1/Vd+2rOVigpHgTnVMpJ7/ixKA1Ga43jG3eHspJgDF
         OkDyPrmiv4CmkQuX+Ellr+sFvAFP+X6hopkXk38seQNbNDEjoKdTMgysYpx4GGGadm1T
         VOGA==
X-Gm-Message-State: AO0yUKXWQQboAskPN+qAei6sLXfoV4kQ68Yq/CX+3Jf4dCyEBP5B0VSE
        w5zqfP1pOCo64AUm/QqF+d1tLDTYW1r+
X-Google-Smtp-Source: AK7set/yth4yrA5ctQs+Ets8c+gX8SkJ+jqv3vTU0OJChXY9EOPoTKuziDGTG20vcC7yRb46VfVl/mtRqm08
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:4e6:b0:910:5688:3360 with SMTP id
 w6-20020a05690204e600b0091056883360mr58485ybs.375.1676423253392; Tue, 14 Feb
 2023 17:07:33 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:11 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-11-rananta@google.com>
Subject: [REPOST PATCH 10/16] selftests: KVM: aarch64: Add KVM EVTYPE filter
 PMU test
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

