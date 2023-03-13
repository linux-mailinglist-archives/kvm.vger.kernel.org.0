Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9677E6B7885
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 14:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCMNLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 09:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCMNLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 09:11:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667006A052
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 06:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D985F612A5
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 13:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D043C433EF;
        Mon, 13 Mar 2023 13:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678713067;
        bh=sTaX04P3HhSQ8MuwwEAOYdHMdPFB29YmwEAkpBTRmYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMEqedXqgTlE7kCdRlTXknxt8YFGGPyG3l3ZDDdTR/8CjakyBBSYqwjrIU/5UXa8P
         kbWmVqzaRWTWZD7V6wNe2BMysxpYvSQCPq6+bgruSYjUNa/7a4B9CNspI1/r4HcDYa
         nsbn1bsr8cM1+mlt2C72adW7KiC4Um6LTeVP2w/KhwsQrc6PqOqQoh+A5phbQbBC5z
         iSOFzYlck4yLkAkAiSil8BocGWmyH1cR1/rhyIgsi4aQL+KovdWOvaNtjvzEzd6D0K
         e1YMzTV8M61ZfYzMdhlrRZ3W7ka7C8ZJ/3BfVk94gOgLkDbjJ18q41RSusr+NZ7EJB
         Be2WZbImJXhYw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbj-00HEdE-TJ;
        Mon, 13 Mar 2023 12:48:55 +0000
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
Subject: [PATCH v2 18/19] KVM: arm64: selftests: Augment existing timer test to handle variable offset
Date:   Mon, 13 Mar 2023 12:48:36 +0000
Message-Id: <20230313124837.2264882-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow a user to specify the global offset on the command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 26556a266021..6d2e811fbf85 100644
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
@@ -372,6 +374,13 @@ static struct kvm_vm *test_vm_create(void)
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
 
@@ -403,6 +412,7 @@ static void test_print_help(char *name)
 		TIMER_TEST_PERIOD_MS_DEF);
 	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
 		TIMER_TEST_MIGRATION_FREQ_MS);
+	pr_info("\t-o: Counter offset (in counter cycles, default: 0)\n");
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -410,7 +420,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:o:O:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
@@ -429,6 +439,10 @@ static bool parse_args(int argc, char *argv[])
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

