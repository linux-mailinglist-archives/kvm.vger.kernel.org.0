Return-Path: <kvm+bounces-2872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E05EF7FEB78
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C4681C20D08
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A643B7B7;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CIa7t8Ts"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8909010E5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=826NVfu+eMIjcXlJxCUcn0InDpeD0W3LQtFugetdO7M=;
	b=CIa7t8Tsix2R1yj+uOBflqvPOC2sXWVo8ryRvHfEicHLPxxf7mGIheE4oWLhkA/BN1jZ3E
	BqtM3sCSwyq2ckYBV5LuCOqYWAc1FD6Nl1qKSHw6vm7D/AvrTFh1CPJdFMooUYhE5zYdCH
	sT1BZaFZowbUhvz/j3KT7j2TSUjhCio=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-chliv4KDO16qZ7ZqvsUF7w-1; Thu, 30 Nov 2023 04:07:57 -0500
X-MC-Unique: chliv4KDO16qZ7ZqvsUF7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 385A5101A550;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 297BF1C060AE;
	Thu, 30 Nov 2023 09:07:57 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 11/18] arm/arm64: assembler.h: Replace size with end address for dcache_by_line_op
Date: Thu, 30 Nov 2023 04:07:13 -0500
Message-Id: <20231130090722.2897974-12-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

Commit b5f659be4775 ("arm/arm64: Remove dcache_line_size global
variable") moved the dcache_by_line_op macro to assembler.h and changed
it to take the size of the regions instead of the end address as
parameter. This was done to keep the file in sync with the upstream
Linux kernel implementation at the time.

But in both places where the macro is used, the code has the start and
end address of the region, and it has to compute the size to pass it to
dcache_by_line_op. Then the macro itsef computes the end by adding size
to start.

Get rid of this massaging of parameters and change the macro to the end
address as parameter directly.

Besides slightly simplyfing the code by remove two unneeded arithmetic
operations, this makes the macro compatible with the current upstream
version of Linux (which was similarly changed to take the end address in
commit 163d3f80695e ("arm64: dcache_by_line_op to take end parameter
instead of size")), which will allow us to reuse (part of) the Linux C
wrappers over the assembly macro.

The change has been tested with the same snippet of code used to test
commit 410b3bf09e76 ("arm/arm64: Perform dcache clean + invalidate after
turning MMU off").

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S              |  1 -
 arm/cstart64.S            |  1 -
 lib/arm/asm/assembler.h   | 11 +++++------
 lib/arm64/asm/assembler.h | 11 +++++------
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 2ecebd1d..98d61230 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -226,7 +226,6 @@ asm_mmu_disable:
 	ldr	r0, [r0]
 	ldr	r1, =__phys_end
 	ldr	r1, [r1]
-	sub	r1, r1, r0
 	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
 
 	mov     pc, lr
diff --git a/arm/cstart64.S b/arm/cstart64.S
index 5ba2fb27..7fb44f42 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -264,7 +264,6 @@ asm_mmu_disable:
 	ldr	x0, [x0, :lo12:__phys_offset]
 	adrp	x1, __phys_end
 	ldr	x1, [x1, :lo12:__phys_end]
-	sub	x1, x1, x0
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 
 	ret
diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
index 4200252d..db5f0f55 100644
--- a/lib/arm/asm/assembler.h
+++ b/lib/arm/asm/assembler.h
@@ -25,17 +25,16 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size).
+ * [addr, end).
  *
  * 	op:		operation to execute
  * 	domain		domain used in the dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
@@ -45,7 +44,7 @@
 	.err
 	.endif
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	blo	9998b
 	dsb	\domain
 	.endm
diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
index aa8c65a2..1e09d65a 100644
--- a/lib/arm64/asm/assembler.h
+++ b/lib/arm64/asm/assembler.h
@@ -28,25 +28,24 @@
 
 /*
  * Macro to perform a data cache maintenance for the interval
- * [addr, addr + size). Use the raw value for the dcache line size because
+ * [addr, end). Use the raw value for the dcache line size because
  * kvm-unit-tests has no concept of scheduling.
  *
  * 	op:		operation passed to dc instruction
  * 	domain:		domain used in dsb instruction
  * 	addr:		starting virtual address of the region
- * 	size:		size of the region
- * 	Corrupts:	addr, size, tmp1, tmp2
+ * 	end:		the end of the region (non-inclusive)
+ * 	Corrupts:	addr, tmp1, tmp2
  */
 
-	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
+	.macro dcache_by_line_op op, domain, addr, end, tmp1, tmp2
 	raw_dcache_line_size \tmp1, \tmp2
-	add	\size, \addr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\addr, \addr, \tmp2
 9998:
 	dc	\op, \addr
 	add	\addr, \addr, \tmp1
-	cmp	\addr, \size
+	cmp	\addr, \end
 	b.lo	9998b
 	dsb	\domain
 	.endm
-- 
2.40.1


