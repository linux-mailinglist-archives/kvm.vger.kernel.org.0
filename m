Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE96C80CB
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCXPLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjCXPLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF218A81
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 205AF62B78
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 15:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86019C4339B;
        Fri, 24 Mar 2023 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679670664;
        bh=dItKPt/faZM+g2W4tQMQlg9MnXhL+x6/Lr6mKjoHBhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MO7zbVOsAj4ia66zi/7DBfHvBM3RXBonN9QSnF9LteLRtMsbdyra2LbB+FObqctUy
         B0EwYXNJ32F+8/VbLFlK4jduKAqbtZZbdDTj7ASPO9CkIWaOsgN8D4wEbc73d2DJze
         mA95SCHnzqEoRGVh51rRtJiBBn5o+aRbi8lwZ6AtIYFT9a05I9mtDbc9M6rP27nh5e
         l/zjDtu9P7Qg/7L5CEh5z3a5k8eivuAE8IVVAIW6ki0WQsEcncmJd0IGGNM3FhRBnb
         SQ3MO8ug7T0fs59CYyI2C6roDxmjIjibIoKU3aRKZrk40GS0Nicfbil6aItHg+5yew
         Ty6Gv0LEb5oXQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihN-002qBP-Ac;
        Fri, 24 Mar 2023 14:47:21 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v3 18/18] KVM: arm64: selftests: Augment existing timer test to handle variable offset
Date:   Fri, 24 Mar 2023 14:47:04 +0000
Message-Id: <20230324144704.4193635-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow a user to specify the global offset on the command-line.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 176ab41dd01b..8ef370924a02 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -47,6 +47,7 @@ struct test_args {
 	int nr_iter;
 	int timer_period_ms;
 	int migration_freq_ms;
+	struct kvm_arm_counter_offset offset;
 };
 
 static struct test_args test_args = {
@@ -54,6 +55,7 @@ static struct test_args test_args = {
 	.nr_iter = NR_TEST_ITERS_DEF,
 	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
 	.migration_freq_ms = TIMER_TEST_MIGRATION_FREQ_MS,
+	.offset = { .reserved = 1 },
 };
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
@@ -382,6 +384,13 @@ static struct kvm_vm *test_vm_create(void)
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
+	if (!test_args.offset.reserved) {
+		if (kvm_has_cap(KVM_CAP_COUNTER_OFFSET))
+			vm_ioctl(vm, KVM_ARM_SET_COUNTER_OFFSET, &test_args.offset);
+		else
+			TEST_FAIL("no support for global offset\n");
+	}
+
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
@@ -413,6 +422,7 @@ static void test_print_help(char *name)
 		TIMER_TEST_PERIOD_MS_DEF);
 	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
 		TIMER_TEST_MIGRATION_FREQ_MS);
+	pr_info("\t-o: Counter offset (in counter cycles, default: 0)\n");
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -420,7 +430,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:o:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
@@ -439,6 +449,10 @@ static bool parse_args(int argc, char *argv[])
 		case 'm':
 			test_args.migration_freq_ms = atoi_non_negative("Frequency", optarg);
 			break;
+		case 'o':
+			test_args.offset.counter_offset = strtol(optarg, NULL, 0);
+			test_args.offset.reserved = 0;
+			break;
 		case 'h':
 		default:
 			goto err;
-- 
2.34.1

