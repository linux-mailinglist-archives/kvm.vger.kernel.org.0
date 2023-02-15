Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4C9697333
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjBOBIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjBOBIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:08:13 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EF431E23
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:40 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id r16-20020a92ce90000000b0031539a8e730so5383426ilo.13
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=I9xImCmVWCFNHbTSunyTqAaQSap8s5DCNhGLVbV7DgL0T5/D1hdtBQJhSlNOe0jyPF
         voYUROttsE9l9SnEr6HvowKBOJbe3Owouy9OMVDxedlEyBXWr5K1mib2fl7gRhdLO48L
         fnbPgDfuU6IyeV5gmtkDjhnSwbDWrRJiY/rOnl9/nyjQn/kkRiKJ7TrYIVTF4wF6Riqy
         H4EGjONPbs2vlw0XIQt4v1m1JZuOeQ5uTUSmzUK+wKvS/rdrVoM46iwXIui3VhOGipia
         XgImDP9+Y9tLkAorIZjdPiohqFBlpPbzSEPNJfNVZHgYBDc7MHB0TWhNYdEakb6KtRlu
         ToZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E305a934JyKR6d0LbQnwDb1KLXy1uRhITDhO1feUNVQ=;
        b=XqlDAQAe7mTDvLyemRJgWdKzJUkCubzyW5Itzca6+1SUr41GVzDuButv1mW1cjmi7K
         M0p4wlfISuE2Eayhk9EG7bjduNXOMcOdugc+W7L77bZtPZyCEHTu4RLshlCGSB/HqNWn
         DcqD4CZAVI8N3UZ595qKaH7RtK7ZTxjq15LKdDSCD44VvbY6aF04ihh3hDesgsRd96nB
         AZlhkmLJMaXz3g45zDBwHeinpXWKuge3YPrIOMMSDRQyjtgOOyGVK01K4i1bwhvk5BmX
         seeE0WqxHlHK/tW7SywwM3MLtnkhF/R1cOZwt704uzQ9INdUcGpCTXZyAfIqPhxxkKWG
         hZoA==
X-Gm-Message-State: AO0yUKUepGivkB0/oPwggagEWsbwDppBlChVVvN8QtVntZzVwNgmbCfW
        PzsqEQNwtfZTdxJNxSKIFDnZjobI2qtV
X-Google-Smtp-Source: AK7set+b4ssQzb8aMv+uSf2RmCPqXoTCRttRjQLG+i9Fm0UeKWjHu4LVoeyGHXP+DptEEnYx2/E5xZzWwpO6
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a6b:fb01:0:b0:71c:479d:741a with SMTP id
 h1-20020a6bfb01000000b0071c479d741amr332606iog.38.1676423258679; Tue, 14 Feb
 2023 17:07:38 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:15 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-15-rananta@google.com>
Subject: [REPOST PATCH 14/16] selftests: KVM: aarch64: Add PMU test to chain
 all the counters
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

Extend the vCPU migration test to occupy all the vPMU counters,
by configuring chained events on alternate counter-ids and chaining
them with its corresponding predecessor counter, and verify against
the extended behavior.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index de725f4339ad5..fd00acb9391c8 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -710,6 +710,63 @@ static void test_chained_count(int pmc_idx)
 	pmu_irq_exit(chained_pmc_idx);
 }
 
+static void test_chain_all_counters(void)
+{
+	int i;
+	uint64_t cnt, pmcr_n = get_pmcr_n();
+	struct pmc_accessor *acc = &pmc_accessors[0];
+
+	/*
+	 * Test the occupancy of all the event counters, by chaining the
+	 * alternate counters. The test assumes that the host hasn't
+	 * occupied any counters. Hence, if the test fails, it could be
+	 * because all the counters weren't available to the guest or
+	 * there's actually a bug in KVM.
+	 */
+
+	/*
+	 * Configure even numbered counters to count cpu-cycles, and chain
+	 * each of them with its odd numbered counter.
+	 */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2) {
+			acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CHAIN);
+			acc->write_cntr(i, 1);
+		} else {
+			pmu_irq_init(i);
+			acc->write_cntr(i, PRE_OVERFLOW_32);
+			acc->write_typer(i, ARMV8_PMUV3_PERFCTR_CPU_CYCLES);
+		}
+		enable_counter(i);
+	}
+
+	/* Introduce some cycles */
+	execute_precise_instrs(500, ARMV8_PMU_PMCR_E);
+
+	/*
+	 * An overflow interrupt should've arrived for all the even numbered
+	 * counters but none for the odd numbered ones. The odd numbered ones
+	 * should've incremented exactly by 1.
+	 */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2) {
+			GUEST_ASSERT_1(!pmu_irq_received(i), i);
+
+			cnt = acc->read_cntr(i);
+			GUEST_ASSERT_2(cnt == 2, i, cnt);
+		} else {
+			GUEST_ASSERT_1(pmu_irq_received(i), i);
+		}
+	}
+
+	/* Cleanup the states */
+	for (i = 0; i < pmcr_n; i++) {
+		if (i % 2 == 0)
+			pmu_irq_exit(i);
+		disable_counter(i);
+	}
+}
+
 static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 {
 	switch (event) {
@@ -739,6 +796,9 @@ static void test_basic_pmu_functionality(void)
 
 	/* Test chained events */
 	test_chained_count(0);
+
+	/* Test running chained events on all the implemented counters */
+	test_chain_all_counters();
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

