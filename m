Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0A7168EA
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbjE3QLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbjE3QLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:11:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D12A6137
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:11:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 933731BCB;
        Tue, 30 May 2023 09:11:14 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 497013F663;
        Tue, 30 May 2023 09:10:28 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 30/32] arm64: debug: Make inline assembly symbols global
Date:   Tue, 30 May 2023 17:09:22 +0100
Message-Id: <20230530160924.82158-31-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

efi binaries need to be compiled with fPIC. To allow symbols defined in
inline assembly to be correctly resolved, this patch makes them globally
visibile to the linker.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/debug.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arm/debug.c b/arm/debug.c
index b3e9749c..572786a9 100644
--- a/arm/debug.c
+++ b/arm/debug.c
@@ -292,11 +292,14 @@ static noinline void test_hw_bp(bool migrate)
 	hw_bp_idx = 0;
 
 	/* Trap on up to 16 debug exception unmask instructions. */
-	asm volatile("hw_bp0:\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
-	     "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n");
+	asm volatile(
+		".globl hw_bp0\n"
+		"hw_bp0:\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+			"msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr daifclr, #8\n"
+		);
 
 	for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4)
 		report(hw_bp_addr[i] == addr, "hw breakpoint: %d", i);
@@ -367,11 +370,14 @@ static noinline void test_ss(bool migrate)
 
 	asm volatile("msr daifclr, #8");
 
-	asm volatile("ss_start:\n"
+	asm volatile(
+		".globl ss_start\n"
+		"ss_start:\n"
 			"mrs x0, esr_el1\n"
 			"add x0, x0, #1\n"
 			"msr daifset, #8\n"
-			: : : "x0");
+			: : : "x0"
+		);
 
 	report(ss_addr[0] == (uint64_t)&ss_start, "single step");
 }
-- 
2.25.1

