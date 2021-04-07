Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDF93574AF
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbhDGS7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:59:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242302AbhDGS7q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHgFc3x2N5Ea4Wy96VF136gRYci3iHTFc0yTtoimnOw=;
        b=YaXTiKBVuBga9Q4XBkYwlflV2iVPcA1A0rhngPEbbf7JyZdyd8CXP4FAPq7qawSujO8K7q
        UD8B8tHotaJYPnBS0LyL3de2u0Be3sa/vXCUsyWUBoAgD+O41n74mK5RmMDAp0E0uzxZ6q
        7rEpJrAjZTDXc8f+tSK7o43kN0gGBHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-OvLqyH-IONuMeLrac1iBew-1; Wed, 07 Apr 2021 14:59:30 -0400
X-MC-Unique: OvLqyH-IONuMeLrac1iBew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABF8E107ACC7;
        Wed,  7 Apr 2021 18:59:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE06C6A033;
        Wed,  7 Apr 2021 18:59:25 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
Date:   Wed,  7 Apr 2021 20:59:11 +0200
Message-Id: <20210407185918.371983-2-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move secondary_entry helper functions out of .init and into .text,
since secondary_entry isn't run at "init" time.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S   | 62 +++++++++++++++++++++++++++-----------------------
 arm/cstart64.S | 22 +++++++++++-------
 2 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index d88a98362940..653ab1e8a141 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -96,32 +96,7 @@ start:
 	bl	exit
 	b	halt
 
-
-.macro set_mode_stack mode, stack
-	add	\stack, #S_FRAME_SIZE
-	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
-	isb
-	mov	sp, \stack
-.endm
-
-exceptions_init:
-	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
-	bic	r2, #CR_V		@ SCTLR.V := 0
-	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
-	ldr	r2, =vector_table
-	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
-
-	mrs	r2, cpsr
-
-	/* first frame reserved for svc mode */
-	set_mode_stack	UND_MODE, r0
-	set_mode_stack	ABT_MODE, r0
-	set_mode_stack	IRQ_MODE, r0
-	set_mode_stack	FIQ_MODE, r0
-
-	msr	cpsr_cxsf, r2		@ back to svc mode
-	isb
-	mov	pc, lr
+.text
 
 enable_vfp:
 	/* Enable full access to CP10 and CP11: */
@@ -133,8 +108,6 @@ enable_vfp:
 	vmsr	fpexc, r0
 	mov	pc, lr
 
-.text
-
 .global get_mmu_off
 get_mmu_off:
 	ldr	r0, =auxinfo
@@ -235,6 +208,39 @@ asm_mmu_disable:
 
 	mov     pc, lr
 
+/*
+ * Vectors
+ */
+
+.macro set_mode_stack mode, stack
+	add	\stack, #S_FRAME_SIZE
+	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
+	isb
+	mov	sp, \stack
+.endm
+
+exceptions_init:
+	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
+	bic	r2, #CR_V		@ SCTLR.V := 0
+	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
+	ldr	r2, =vector_table
+	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
+
+	mrs	r2, cpsr
+
+	/*
+	 * Input r0 is the stack top, which is the exception stacks base
+	 * The first frame is reserved for svc mode
+	 */
+	set_mode_stack	UND_MODE, r0
+	set_mode_stack	ABT_MODE, r0
+	set_mode_stack	IRQ_MODE, r0
+	set_mode_stack	FIQ_MODE, r0
+
+	msr	cpsr_cxsf, r2		@ back to svc mode
+	isb
+	mov	pc, lr
+
 /*
  * Vector stubs
  * Simplified version of the Linux kernel implementation
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 0a85338bcdae..d39cf4dfb99c 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -89,10 +89,12 @@ start:
 	msr	cpacr_el1, x4
 
 	/* set up exception handling */
+	mov	x4, x0				// x0 is the addr of the dtb
 	bl	exceptions_init
 
 	/* complete setup */
-	bl	setup				// x0 is the addr of the dtb
+	mov	x0, x4				// restore the addr of the dtb
+	bl	setup
 	bl	get_mmu_off
 	cbnz	x0, 1f
 	bl	setup_vm
@@ -109,13 +111,6 @@ start:
 	bl	exit
 	b	halt
 
-exceptions_init:
-	adrp	x4, vector_table
-	add	x4, x4, :lo12:vector_table
-	msr	vbar_el1, x4
-	isb
-	ret
-
 .text
 
 .globl get_mmu_off
@@ -251,6 +246,17 @@ asm_mmu_disable:
 
 /*
  * Vectors
+ */
+
+exceptions_init:
+	adrp	x0, vector_table
+	add	x0, x0, :lo12:vector_table
+	msr	vbar_el1, x0
+	isb
+	ret
+
+/*
+ * Vector stubs
  * Adapted from arch/arm64/kernel/entry.S
  */
 .macro vector_stub, name, vec
-- 
2.26.3

