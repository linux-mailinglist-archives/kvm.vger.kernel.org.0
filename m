Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7448C3574B0
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbhDGS7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:59:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhDGS7r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VX7KgusVBJDZTuoexiV/2l/Nm4sKGRNyiVpIeVJPzlA=;
        b=N5r0wGCYwfF80arcntuqH24umATYbuzGlvQta8X6R7FkOOHAK9vhCNrR9ac1ttNmmE+nlM
        uXsSRczjuydmqQv6C44ZgKshfz9Pp6OqcWKgln/EtI7OWM0EHAUrcZMfItVc/PeNyIGDPM
        9SwyMyJZB47C6xDMn+uJZuVhz5UotIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Ka2tpiFZMmCoPtYOlG84tA-1; Wed, 07 Apr 2021 14:59:35 -0400
X-MC-Unique: Ka2tpiFZMmCoPtYOlG84tA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0099791271;
        Wed,  7 Apr 2021 18:59:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A93060C5C;
        Wed,  7 Apr 2021 18:59:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 2/8] arm/arm64: Move setup_vm into setup
Date:   Wed,  7 Apr 2021 20:59:12 +0200
Message-Id: <20210407185918.371983-3-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate our setup calls to reduce the amount we need to do from
init::start. Also remove a couple of pointless comments from setup().

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S    | 6 ------
 arm/cstart64.S  | 5 -----
 lib/arm/setup.c | 7 +++++--
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 653ab1e8a141..731f841695ce 100644
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
index d39cf4dfb99c..add60a2b4e74 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -95,11 +95,7 @@ start:
 	/* complete setup */
 	mov	x0, x4				// restore the addr of the dtb
 	bl	setup
-	bl	get_mmu_off
-	cbnz	x0, 1f
-	bl	setup_vm
 
-1:
 	/* run the test */
 	adrp	x0, __argc
 	ldr	w0, [x0, :lo12:__argc]
@@ -113,7 +109,6 @@ start:
 
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
2.26.3

