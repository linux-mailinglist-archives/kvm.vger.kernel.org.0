Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD2B699778
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBPObc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBPOb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1FF4BEB6
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:31:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1CC1B8285B
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816DBC433EF;
        Thu, 16 Feb 2023 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557884;
        bh=b2cqCZetPzP86Bj0UI7SfqqUnTqFfWWQASExM82mRyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4NGkaDV/9pZ1MMtC4HU6k03a1JDjApKussUBnCFrOeq7QnBeRWjNMeH8l0sidUn+
         aEy0t6uzXH8Z0+9QAPrAoF2jhru3XNniJriAP2Xl1RdF0swTSthY20t/b+Sa4VRhqg
         t445GSwsOSOQkfd9MyC45P7nU1VOnoLmWxvQhcOIxCsXN30vmE/oYqaOWn4jaaqGz5
         r7dudhqx3UiLSXsaUnNTr28x+VvFbpQ1bs6lrMjSJfQXMKh2cLEHbo9Ie5shtEOazl
         8wajJaTNt6EyxUeBbI9S8gSLljD2yGLatpsY5sGdvp32p/wDUkNKIwYUT3kDMWrMvy
         sqDv9wTG1TfLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8w-00AuwB-Lh;
        Thu, 16 Feb 2023 14:21:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 15/16] KVM: arm64: selftests: Augment existing timer test to handle variable offsets
Date:   Thu, 16 Feb 2023 14:21:22 +0000
Message-Id: <20230216142123.2638675-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
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

Allow a user to specify the physical and virtual offsets on the
command-line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 26556a266021..62af0e7d10b4 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -47,6 +47,7 @@ struct test_args {
 	int nr_iter;
 	int timer_period_ms;
 	int migration_freq_ms;
+	struct kvm_arm_counter_offsets offsets;
 };
 
 static struct test_args test_args = {
@@ -54,6 +55,7 @@ static struct test_args test_args = {
 	.nr_iter = NR_TEST_ITERS_DEF,
 	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
 	.migration_freq_ms = TIMER_TEST_MIGRATION_FREQ_MS,
+	.offsets = { .flags = 0 },
 };
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
@@ -372,6 +374,13 @@ static struct kvm_vm *test_vm_create(void)
 	vm_init_descriptor_tables(vm);
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
+	if (test_args.offsets.flags) {
+		if (kvm_has_cap(KVM_CAP_COUNTER_OFFSETS))
+			vm_ioctl(vm, KVM_ARM_SET_CNT_OFFSETS, &test_args.offsets);
+		else
+			__TEST_REQUIRE(test_args.offsets.flags, "no support for global offsets");
+	}
+
 	for (i = 0; i < nr_vcpus; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
@@ -403,6 +412,10 @@ static void test_print_help(char *name)
 		TIMER_TEST_PERIOD_MS_DEF);
 	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
 		TIMER_TEST_MIGRATION_FREQ_MS);
+	pr_info("\t-o: Virtual counter offset (in counter cycles, default: %llu)\n",
+		test_args.offsets.virtual_offset);
+	pr_info("\t-O: Physical counter offset (in counter cycles, default: %llu)\n",
+		test_args.offsets.physical_offset);
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -410,7 +423,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:o:O:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
@@ -429,6 +442,14 @@ static bool parse_args(int argc, char *argv[])
 		case 'm':
 			test_args.migration_freq_ms = atoi_non_negative("Frequency", optarg);
 			break;
+		case 'o':
+			test_args.offsets.virtual_offset = strtol(optarg, NULL, 0);
+			test_args.offsets.flags |= KVM_COUNTER_SET_VOFFSET_FLAG;
+			break;
+		case 'O':
+			test_args.offsets.physical_offset = strtol(optarg, NULL, 0);
+			test_args.offsets.flags |= KVM_COUNTER_SET_POFFSET_FLAG;
+			break;
 		case 'h':
 		default:
 			goto err;
-- 
2.34.1

