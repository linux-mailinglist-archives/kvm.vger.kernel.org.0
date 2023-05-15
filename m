Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB9B7040CF
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 00:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245365AbjEOWPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 18:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244405AbjEOWPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 18:15:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 852A8C2
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 15:15:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D8112F4;
        Mon, 15 May 2023 15:16:18 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 204BB3F840;
        Mon, 15 May 2023 15:15:33 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     luc.maranget@inria.fr
Subject: [kvm-unit-tests PATCH] arm64: Make vector_table and vector_stub weak symbols
Date:   Mon, 15 May 2023 23:15:17 +0100
Message-Id: <20230515221517.646549-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
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

This changes allows a test to define and override the declared symbols,
taking control of the whole vector_table or a vector_stub.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart64.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index e4ab7d06..eda0daa5 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -275,8 +275,11 @@ exceptions_init:
 /*
  * Vector stubs
  * Adapted from arch/arm64/kernel/entry.S
+ * Declare as weak to allow external tests to redefine and override a
+ * vector_stub.
  */
 .macro vector_stub, name, vec
+.weak \name
 \name:
 	stp	 x0,  x1, [sp, #-S_FRAME_SIZE]!
 	stp	 x2,  x3, [sp,  #16]
@@ -369,7 +372,13 @@ vector_stub	el0_error_32, 15
 	b	\label
 .endm
 
+
+/*
+ * Declare as weak to allow external tests to redefine and override the
+ * default vector table.
+ */
 .align 11
+.weak vector_table
 vector_table:
 	ventry	el1t_sync			// Synchronous EL1t
 	ventry	el1t_irq			// IRQ EL1t
-- 
2.25.1

