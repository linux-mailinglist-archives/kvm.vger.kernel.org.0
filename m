Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E8D344B45
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhCVQ1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 12:27:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231846AbhCVQ1b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 12:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616430449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hB4ao7MgBVQEa0+4DPXxKWvIIlNaPGOvZXTUciQhDGE=;
        b=IglHJyZrrvYrV56PXO2lQQcYTxnqI0n1FfxmmcbrYt34ANAD2qSQXZ/weBDuWAoSpzdict
        gIqtIwqa9g6Y94YM67eEBdz0z0miXjT8zLbe3WKn7HmcK8bgsv/DiJ8tSbOdNmM8U/Q4SE
        nENmoNxQ7EHvwbMi8ueqSDCWk3xyCIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-Hb1HaCVTMeuRLKHGoSJ0qQ-1; Mon, 22 Mar 2021 12:27:26 -0400
X-MC-Unique: Hb1HaCVTMeuRLKHGoSJ0qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F378E84BA43;
        Mon, 22 Mar 2021 16:27:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368A35C1A3;
        Mon, 22 Mar 2021 16:27:23 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvm-unit-tests v2] arm/arm64: Zero BSS and stack at startup
Date:   Mon, 22 Mar 2021 17:27:21 +0100
Message-Id: <20210322162721.108514-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far we've counted on QEMU or kvmtool implicitly zeroing all memory.
With our goal of eventually supporting bare-metal targets with
target-efi we should explicitly zero any memory we expect to be zeroed
ourselves. This obviously includes the BSS, but also the bootcpu's
stack, as the bootcpu's thread-info lives in the stack and may get
used in early setup to get the cpu index. Note, this means we still
assume the bootcpu's cpu index to be zero. That assumption can be
removed later.

Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S   | 20 ++++++++++++++++++++
 arm/cstart64.S | 22 +++++++++++++++++++++-
 arm/flat.lds   |  4 ++++
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index ef936ae2f874..9eb11ba4dcaf 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -15,12 +15,32 @@
 
 #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
 
+.macro zero_range, tmp1, tmp2, tmp3, tmp4
+	mov	\tmp3, #0
+	mov	\tmp4, #0
+9998:	cmp	\tmp1, \tmp2
+	beq	9997f
+	strd	\tmp3, \tmp4, [\tmp1], #8
+	b	9998b
+9997:
+.endm
+
 .arm
 
 .section .init
 
 .globl start
 start:
+	/* zero BSS */
+	ldr	r4, =bss
+	ldr	r5, =ebss
+	zero_range r4, r5, r6, r7
+
+	/* zero stack */
+	ldr	r5, =stacktop
+	sub	r4, r5, #THREAD_SIZE
+	zero_range r4, r5, r6, r7
+
 	/*
 	 * set stack, making room at top of stack for cpu0's
 	 * exception stacks. Must start wtih stackptr, not
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 0428014aa58a..2a691f8f5065 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -12,6 +12,15 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
+#include <asm/thread_info.h>
+
+.macro zero_range, tmp1, tmp2
+9998:	cmp	\tmp1, \tmp2
+	b.eq	9997f
+	stp	xzr, xzr, [\tmp1], #16
+	b	9998b
+9997:
+.endm
 
 .section .init
 
@@ -51,7 +60,18 @@ start:
 	b	1b
 
 1:
-	/* set up stack */
+	/* zero BSS */
+	adrp	x4, bss
+	add	x4, x4, :lo12:bss
+	adrp    x5, ebss
+	add     x5, x5, :lo12:ebss
+	zero_range x4, x5
+
+	/* zero and set up stack */
+	adrp    x5, stacktop
+	add     x5, x5, :lo12:stacktop
+	sub	x4, x5, #THREAD_SIZE
+	zero_range x4, x5
 	mov	x4, #1
 	msr	spsel, x4
 	isb
diff --git a/arm/flat.lds b/arm/flat.lds
index 25f8d03cba87..4d43cdfeab41 100644
--- a/arm/flat.lds
+++ b/arm/flat.lds
@@ -17,7 +17,11 @@ SECTIONS
 
     .rodata   : { *(.rodata*) }
     .data     : { *(.data) }
+    . = ALIGN(16);
+    PROVIDE(bss = .);
     .bss      : { *(.bss) }
+    . = ALIGN(16);
+    PROVIDE(ebss = .);
     . = ALIGN(64K);
     PROVIDE(edata = .);
 
-- 
2.26.3

