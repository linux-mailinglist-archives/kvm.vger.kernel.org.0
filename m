Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1FA6942A4
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjBMKTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjBMKS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:59 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0E0410262
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E6561FC4;
        Mon, 13 Feb 2023 02:19:20 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AC643F703;
        Mon, 13 Feb 2023 02:18:36 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        ricarkol@google.com
Subject: [PATCH v4 29/30] lib: arm: Print test exit status
Date:   Mon, 13 Feb 2023 10:17:58 +0000
Message-Id: <20230213101759.2577077-30-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

The arm tests can be run under kvmtool, which doesn't emulate a chr-testdev
device. Print the test exit status to make it possible for the runner
scripts to pick it up when they have support for it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 19f93490..c15e57c4 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -149,6 +149,13 @@ extern void halt(int code);
 
 void exit(int code)
 {
+	/*
+	 * Print the test return code in the following format which is
+	 * consistent with powerpc and s390x. The runner can pick it
+	 * up when chr-testdev is not present.
+	 */
+	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
+
 	chr_testdev_exit(code);
 	psci_system_off();
 	halt(code);
-- 
2.25.1

