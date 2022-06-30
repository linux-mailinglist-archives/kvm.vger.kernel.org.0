Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2F56171F
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbiF3KEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiF3KEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:04:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D88144750
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:04:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C0261C0A;
        Thu, 30 Jun 2022 03:04:20 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF1913F5A1;
        Thu, 30 Jun 2022 03:04:18 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 26/27] lib: arm: Print test exit status
Date:   Thu, 30 Jun 2022 11:03:23 +0100
Message-Id: <20220630100324.3153655-27-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 lib/arm/io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index a91f116..337cf1b 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -138,6 +138,12 @@ extern void halt(int code);
 
 void exit(int code)
 {
+	/*
+	 * Print the test return code in the format used by chr-testdev so the
+	 * runner can pick it up if there is chr-testdev is not present.
+	 */
+	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
+
 	chr_testdev_exit(code);
 	psci_system_off();
 	halt(code);
-- 
2.25.1

