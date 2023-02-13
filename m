Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B436942AF
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjBMKTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjBMKTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:19:30 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E07316AF7
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:19:18 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BFA81F37;
        Mon, 13 Feb 2023 02:19:17 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC5643F703;
        Mon, 13 Feb 2023 02:18:33 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 26/30] arm64: Use code from the gnu-efi when booting with EFI
Date:   Mon, 13 Feb 2023 10:17:55 +0000
Message-Id: <20230213101759.2577077-27-nikos.nikoleris@arm.com>
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
 arm/efi/crt0-efi-aarch64.S | 19 +++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 223c1092..cbd6b511 100644
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
index d50e78dd..5d0dc04a 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -111,10 +111,17 @@ section_table:
 
 	.align		12
 _start:
-	stp		x29, x30, [sp, #-32]!
+	stp		x29, x30, [sp, #-16]!
+
+	/* Align sp; this is necessary due to way we store cpu0's thread_info */
 	mov		x29, sp
+	mov		x30, sp
+	and		x30, x30, #THREAD_MASK
+	mov		sp, x30
+	str		x29, [sp, #-16]!
+
+	stp		x0, x1, [sp, #-16]!
 
-	stp		x0, x1, [sp, #16]
 	mov		x2, x0
 	mov		x3, x1
 	adr		x0, ImageBase
@@ -123,8 +130,12 @@ _start:
 	bl		_relocate
 	cbnz		x0, 0f
 
-	ldp		x0, x1, [sp, #16]
+	ldp		x0, x1, [sp], #16
 	bl		efi_main
 
-0:	ldp		x29, x30, [sp], #32
+	/* Restore sp */
+	ldr		x30, [sp], #16
+	mov             sp, x30
+
+0:	ldp		x29, x30, [sp], #16
 	ret
-- 
2.25.1

