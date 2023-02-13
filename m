Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073D2694EB2
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjBMSDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjBMSDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:03:08 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EA79032
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a17-20020a256611000000b00889c54916f2so13279447ybc.14
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRn8pqb+ZATFzovvOq02T9w/U2XDHj1IusmF+T0soEI=;
        b=Odev8Z6Kqs3GEhehIpX1NfnNvtpHcHO5P823Sx9vCSEvBaW+zpJ3MeA2k0DrQgW/hq
         qzZ0Hg7nt5uxsTCap5L4HuaZBZQTI3E1Zi5MUcXkCuJGIpYie9eqKdEIoyCQHFLzDhhG
         xlq5vIQJd3CcnFweyuBak5BSdKhSKWTI0i0kyNFGzwKtEuzFKbtmWbuUQceIbBCCHYyi
         kxFKKFTLFjxiMhp6TugfvW8TYUKvke2doRbaM8GV/h9rrqEyRRaZMrWlf3IqbBqhJGsH
         wTSTc75k7otoY5g1eF6K6WOJDyw2YWSdz0xPc0gMpyTcUXxLWhaGv9Wjfw3hc+h3rdFW
         vu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRn8pqb+ZATFzovvOq02T9w/U2XDHj1IusmF+T0soEI=;
        b=LoZyP8AiESySt5/fd1nNl5y4yz75XgPgR3dlmroA+euIqy1/4CQahnJtlcgi+fG/pV
         oaoC+GNE4MIS6SmKXphOi4JHXNaLrYyvyoJT69t16r6hWGTRNc4bn6k/Ng4bgDAGfrKH
         Bd1g51K25Q8jM7p34KMLpXNaCo/9fLO/9rMcjwMtdlOEGo6BwMc2TCK3WEjv3bP8kedo
         uCu5P1lG0ZSApa7R1YN24qFl8+9iYz5g55JmAepH2YO3/2Gwz89MPF4CkTe0x2VPxyBs
         GGhMTAStjVLQrFSjmkM26psUKLhCB7ReLGPysadpR4NUAqs996RfRsK+qdL3R27z4CCv
         YN4g==
X-Gm-Message-State: AO0yUKX6a8k3W44d1j7PcpY8rpyczKe6a6j8frRCb1nsP6aAx47Nhvca
        j7a2ZKG/+JhYxjeQR9HeD7+UA6wAlpDV
X-Google-Smtp-Source: AK7set8RHgzHP8c22NX4XX8rTz8mK48f2xqsC6kI1cPrwBMOEbu/WcXWtj02YO8LfVZHw/DkvQKxZKKZMH8A
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:690c:788:b0:52f:184a:da09 with SMTP id
 bw8-20020a05690c078800b0052f184ada09mr23ywb.2.1676311370417; Mon, 13 Feb 2023
 10:02:50 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:02:31 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-11-rananta@google.com>
Subject: [PATCH 10/13] selftests: KVM: aarch64: Test chained events for PMU
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the vPMU's vCPU migration test to validate
chained events, and their overflow conditions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 76 ++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 066dc17fa3906..de725f4339ad5 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -23,7 +23,7 @@
  * migrating the guest vCPU to random pCPUs in the system, and check
  * if the vPMU is still behaving as expected. The sub-tests include
  * testing basic functionalities such as basic counters behavior,
- * overflow, and overflow interrupts.
+ * overflow, overflow interrupts, and chained events.
  *
  * Copyright (c) 2022 Google LLC.
  *
@@ -61,6 +61,8 @@
 #define PRE_OVERFLOW_32		(GENMASK(31, 0) - COUNT_TO_OVERFLOW + 1)
 #define PRE_OVERFLOW_64		(GENMASK(63, 0) - COUNT_TO_OVERFLOW + 1)
 
+#define ALL_SET_64		GENMASK(63, 0)
+
 #define GICD_BASE_GPA	0x8000000ULL
 #define GICR_BASE_GPA	0x80A0000ULL
 
@@ -639,6 +641,75 @@ static void test_cycles_count(bool expect_count, bool test_overflow)
 	pmu_disable_reset();
 }
 
+static void test_chained_count(int pmc_idx)
+{
+	int i, chained_pmc_idx;
+	struct pmc_accessor *acc;
+	uint64_t pmcr_n, cnt, cntr_val;
+
+	/* The test needs at least two PMCs */
+	pmcr_n = get_pmcr_n();
+	GUEST_ASSERT_1(pmcr_n >= 2, pmcr_n);
+
+	/*
+	 * The chained counter's idx is always chained with (pmc_idx + 1).
+	 * pmc_idx should be even as the chained event doesn't count on
+	 * odd numbered counters.
+	 */
+	GUEST_ASSERT_1(pmc_idx % 2 == 0, pmc_idx);
+
+	/*
+	 * The max counter idx that the chained counter can occupy is
+	 * (pmcr_n - 1), while the actual event sits on (pmcr_n - 2).
+	 */
+	chained_pmc_idx = pmc_idx + 1;
+	GUEST_ASSERT(chained_pmc_idx < pmcr_n);
+
+	enable_counter(chained_pmc_idx);
+	pmu_irq_init(chained_pmc_idx);
+
+	/* Configure the chained event using all the possible ways*/
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		acc = &pmc_accessors[i];
+
+		/* Test if the chained counter increments when the base event overflows */
+
+		cntr_val = 1;
+		acc->write_cntr(chained_pmc_idx, cntr_val);
+		acc->write_typer(chained_pmc_idx, ARMV8_PMUV3_PERFCTR_CHAIN);
+
+		/* Chain the counter with pmc_idx that's configured for an overflow */
+		test_instructions_count(pmc_idx, true, true);
+
+		/*
+		 * pmc_idx is also configured to run for all the ARRAY_SIZE(pmc_accessors)
+		 * combinations. Hence, the chained chained_pmc_idx is expected to be
+		 * cntr_val + ARRAY_SIZE(pmc_accessors).
+		 */
+		cnt = acc->read_cntr(chained_pmc_idx);
+		GUEST_ASSERT_4(cnt == cntr_val + ARRAY_SIZE(pmc_accessors),
+				pmc_idx, i, cnt, cntr_val + ARRAY_SIZE(pmc_accessors));
+
+		/* Test for the overflow of the chained counter itself */
+
+		cntr_val = ALL_SET_64;
+		acc->write_cntr(chained_pmc_idx, cntr_val);
+
+		test_instructions_count(pmc_idx, true, true);
+
+		/*
+		 * At this point, an interrupt should've been fired for the chained
+		 * counter (which validates the overflow bit), and the counter should've
+		 * wrapped around to ARRAY_SIZE(pmc_accessors) - 1.
+		 */
+		cnt = acc->read_cntr(chained_pmc_idx);
+		GUEST_ASSERT_4(cnt == ARRAY_SIZE(pmc_accessors) - 1,
+				pmc_idx, i, cnt, ARRAY_SIZE(pmc_accessors));
+	}
+
+	pmu_irq_exit(chained_pmc_idx);
+}
+
 static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 {
 	switch (event) {
@@ -665,6 +736,9 @@ static void test_basic_pmu_functionality(void)
 	/* Test overflow with interrupts on generic and cycle counters */
 	test_instructions_count(0, true, true);
 	test_cycles_count(true, true);
+
+	/* Test chained events */
+	test_chained_count(0);
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

