Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E549D6F1730
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346063AbjD1MFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346060AbjD1MFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:34 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3B1B5BAE
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 855461595;
        Fri, 28 Apr 2023 05:06:01 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 923523F5A1;
        Fri, 28 Apr 2023 05:05:16 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 25/29] arm64: Use code from the gnu-efi when booting with EFI
Date:   Fri, 28 Apr 2023 13:04:01 +0100
Message-Id: <20230428120405.3770496-26-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
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

