Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB89383257
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240918AbhEQOrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240216AbhEQOlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/7s/OVXJF86S2E6zBLr3qRXWpASbmrPhsviQK1vnao=;
        b=aCzHUkThl8X5qZOP5YxLAQghyXW2pe5jFUt7IXzTFOTNKSgECW2iN5y98Kaic8Wzk84rYN
        Lm6pMzdEXxCbWsLxbhx5AgN+BAW92N7BX93nDl+U009YdH7Y3m/LJC8xUyPVaN29o5P744
        kPqIHvW3T1I1R+9GwHfII+Z0Uz/49ao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-3Y52N8dbMDC6kGdbvMoEow-1; Mon, 17 May 2021 10:39:52 -0400
X-MC-Unique: 3Y52N8dbMDC6kGdbvMoEow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2099910229EB;
        Mon, 17 May 2021 14:39:08 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D02F85D6D7;
        Mon, 17 May 2021 14:39:06 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PULL kvm-unit-tests 03/10] arm/arm64: Move setup_vm into setup
Date:   Mon, 17 May 2021 16:38:53 +0200
Message-Id: <20210517143900.747013-4-drjones@redhat.com>
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate our setup calls to reduce the amount we need to do from
init::start. Also remove a couple of pointless comments from setup().

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S    | 6 ------
 arm/cstart64.S  | 5 -----
 lib/arm/setup.c | 7 +++++--
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index b2c0ba061cd5..bf3c78157e6a 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -81,12 +81,7 @@ start:
 	/* complete setup */
 	pop	{r0-r1}
 	bl	setup
-	bl	get_mmu_off
-	cmp	r0, #0
-	bne	1f
-	bl	setup_vm
 
-1:
 	/* run the test */
 	ldr	r0, =__argc
 	ldr	r0, [r0]
@@ -108,7 +103,6 @@ enable_vfp:
 	vmsr	fpexc, r0
 	mov	pc, lr
 
-.global get_mmu_off
 get_mmu_off:
 	ldr	r0, =auxinfo
 	ldr	r0, [r0, #4]
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 7963e1fea979..27251fe8b5cd 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -93,11 +93,7 @@ start:
 
 	/* complete setup */
 	bl	setup				// x0 is the addr of the dtb
-	bl	get_mmu_off
-	cbnz	x0, 1f
-	bl	setup_vm
 
-1:
 	/* run the test */
 	adrp	x0, __argc
 	ldr	w0, [x0, :lo12:__argc]
@@ -111,7 +107,6 @@ start:
 
 .text
 
-.globl get_mmu_off
 get_mmu_off:
 	adrp	x0, auxinfo
 	ldr	x0, [x0, :lo12:auxinfo + 8]
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 751ba980000a..9c16f6004e9f 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -16,6 +16,8 @@
 #include <alloc.h>
 #include <alloc_phys.h>
 #include <alloc_page.h>
+#include <vmalloc.h>
+#include <auxinfo.h>
 #include <argv.h>
 #include <asm/thread_info.h>
 #include <asm/setup.h>
@@ -233,7 +235,6 @@ void setup(const void *fdt)
 		freemem += initrd_size;
 	}
 
-	/* call init functions */
 	mem_init(PAGE_ALIGN((unsigned long)freemem));
 	cpu_init();
 
@@ -243,7 +244,6 @@ void setup(const void *fdt)
 	/* mem_init must be called before io_init */
 	io_init();
 
-	/* finish setup */
 	timer_save_state();
 
 	ret = dt_get_bootargs(&bootargs);
@@ -256,4 +256,7 @@ void setup(const void *fdt)
 		memcpy(env, initrd, initrd_size);
 		setup_env(env, initrd_size);
 	}
+
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		setup_vm();
 }
-- 
2.30.2

