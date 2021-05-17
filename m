Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7F338323A
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbhEQOqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:46:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239958AbhEQOlE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VFeQAyA2R/OhhffU6EJMz91QYjuCbiLaNvLWDUefAso=;
        b=OeBYQPp8jt+N+bw9tBeG3cx2lb44qQYlDlQphndD8eNTWaYbEm9gJPNRyg+Lps/s8i6CWW
        nZytXoflbdt4Hr61NK+h2sBv8hvCi/qibxOdzIPw6Netfqbm6gxy9SLJjfV+hbaXJT9MF4
        3swduOXHYZISjMiStKe//q2wha9Iqso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-gPqKoRhxOdGYCefb8O04Xw-1; Mon, 17 May 2021 10:39:44 -0400
X-MC-Unique: gPqKoRhxOdGYCefb8O04Xw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72905802E80;
        Mon, 17 May 2021 14:39:06 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 374515D6D7;
        Mon, 17 May 2021 14:39:04 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 02/10] arm/arm64: Reorganize cstart assembler
Date:   Mon, 17 May 2021 16:38:52 +0200
Message-Id: <20210517143900.747013-3-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move secondary_entry helper functions out of .init and into .text,
since secondary_entry isn't run at at "init" time. Actually, anything
that is used after init time should be in .text, as we may not include
.init in some build configurations.

Reviewed-by Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S   | 66 +++++++++++++++++++++++++++++---------------------
 arm/cstart64.S | 18 ++++++++------
 2 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index d88a98362940..b2c0ba061cd5 100644
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
@@ -235,6 +208,43 @@ asm_mmu_disable:
 
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
+/*
+ * exceptions_init
+ *
+ * Input r0 is the stack top, which is the exception stacks base
+ */
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
index 0a85338bcdae..7963e1fea979 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -109,13 +109,6 @@ start:
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
@@ -251,6 +244,17 @@ asm_mmu_disable:
 
 /*
  * Vectors
+ */
+
+exceptions_init:
+	adrp	x4, vector_table
+	add	x4, x4, :lo12:vector_table
+	msr	vbar_el1, x4
+	isb
+	ret
+
+/*
+ * Vector stubs
  * Adapted from arch/arm64/kernel/entry.S
  */
 .macro vector_stub, name, vec
-- 
2.30.2

