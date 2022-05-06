Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFC351DA0A
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442043AbiEFONO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442042AbiEFONH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:13:07 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 490B868317
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 07:09:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D71A15A1;
        Fri,  6 May 2022 07:09:24 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26F783F885;
        Fri,  6 May 2022 07:09:23 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     jade.alglave@arm.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 19/23] arm64: Use code from the gnu-efi when booting with EFI
Date:   Fri,  6 May 2022 15:08:51 +0100
Message-Id: <20220506140855.353337-20-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arm/efi/crt0-efi-aarch64.S defines the header and the handover
sequence from EFI to a efi_main. This change includes the whole file
in arm/cstart64.S when we compile with EFI support.

In addition, we change the handover code in arm/efi/crt0-efi-aarch64.S
to align the stack pointer. This alignment is necessary because we
make assumptions about cpu0's stack alignment and most importantly we
place its thread_info at the bottom of this stack.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/cstart64.S             |  6 ++++++
 arm/efi/crt0-efi-aarch64.S | 17 +++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 55b41ea..08cf02f 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -15,6 +15,10 @@
 #include <asm/thread_info.h>
 #include <asm/sysreg.h>
 
+#ifdef CONFIG_EFI
+#include "efi/crt0-efi-aarch64.S"
+#else
+
 .macro zero_range, tmp1, tmp2
 9998:	cmp	\tmp1, \tmp2
 	b.eq	9997f
@@ -107,6 +111,8 @@ start:
 	bl	exit
 	b	halt
 
+#endif
+
 .text
 
 /*
diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index d50e78d..11a062d 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -111,10 +111,19 @@ section_table:
 
 	.align		12
 _start:
-	stp		x29, x30, [sp, #-32]!
+	stp		x29, x30, [sp, #-16]!
+
+	// Align sp; this is necessary due to way we store cpu0's thread_info
 	mov		x29, sp
+	and		x29, x29, #THREAD_MASK
+	mov		x30, sp
+	mov		sp, x29
+	str		x30, [sp, #-32]!
+
+	mov             x29, sp
 
 	stp		x0, x1, [sp, #16]
+
 	mov		x2, x0
 	mov		x3, x1
 	adr		x0, ImageBase
@@ -126,5 +135,9 @@ _start:
 	ldp		x0, x1, [sp, #16]
 	bl		efi_main
 
-0:	ldp		x29, x30, [sp], #32
+	// Restore sp
+	ldr		x30, [sp]
+	mov             sp, x30
+
+0:	ldp		x29, x30, [sp], #16
 	ret
-- 
2.25.1

