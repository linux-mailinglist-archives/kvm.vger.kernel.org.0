Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF61B4A8769
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 16:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351745AbiBCPN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 10:13:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351769AbiBCPNw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 10:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643901231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TLdxf2xxzhJtwCxN9tWbCeJ4sdROGLHU7FFaUm1Dsww=;
        b=E2EbF/CDN1ZNiFwtTm3Vw2uakq6Of1VAavCtVIUj9Pk0hexFy5aiJVy1HlgLcJc7l6ybiJ
        re1+GfbyCrVyXz057GE6UVadrA5hl0SsCEDltKx1O1/0SW/TGHvr+N5cLVHiu/bXNNJKFA
        MPySR/d5OgW28BIgnlrqV1tldm6hZw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-oQ1jUsa4OUqk8Ms-hh_EYg-1; Thu, 03 Feb 2022 10:13:50 -0500
X-MC-Unique: oQ1jUsa4OUqk8Ms-hh_EYg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99C20190A7A3
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 15:13:49 +0000 (UTC)
Received: from gator.home (unknown [10.40.194.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EEFB84A33;
        Thu,  3 Feb 2022 15:13:45 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests v2] arm64: Fix compiling with ancient compiler
Date:   Thu,  3 Feb 2022 16:13:44 +0100
Message-Id: <20220203151344.437113-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
the build fails with

  lib/libcflat.a(alloc.o): In function `mult_overflow':
  /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'

According to kernel commit fb8722735f50 ("arm64: support __int128 on
gcc 5+") gcc older than 5 will emit __multi3 for __int128 multiplication.
To fix this, let's just use check_mul_overflow(), which does overflow
checking with GCC7.1+ and nothing for older gcc. We lose the fallback
for older gcc, but oh, well, the heavily negative diffstat is just too
tempting to go for another solution.

While we're cleaning up lib/alloc.c with the function deletion also take
the opportunity to clean up the include style and add an SPDX header.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/alloc.c | 41 ++++++-----------------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

diff --git a/lib/alloc.c b/lib/alloc.c
index f4266f5d064e..51d774ddf5df 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,48 +1,19 @@
-#include "alloc.h"
-#include "asm/page.h"
-#include "bitops.h"
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#include <alloc.h>
+#include <bitops.h>
+#include <asm/page.h>
+#include <linux/compiler.h>
 
 void *malloc(size_t size)
 {
 	return memalign(sizeof(long), size);
 }
 
-static bool mult_overflow(size_t a, size_t b)
-{
-#if BITS_PER_LONG == 32
-	/* 32 bit system, easy case: just use u64 */
-	return (u64)a * (u64)b >= (1ULL << 32);
-#else
-#ifdef __SIZEOF_INT128__
-	/* if __int128 is available use it (like the u64 case above) */
-	unsigned __int128 res = a;
-	res *= b;
-	res >>= 64;
-	return res != 0;
-#else
-	u64 tmp;
-
-	if ((a >> 32) && (b >> 32))
-		return true;
-	if (!(a >> 32) && !(b >> 32))
-		return false;
-	tmp = (u32)a;
-	tmp *= (u32)b;
-	tmp >>= 32;
-	if (a < b)
-		tmp += a * (b >> 32);
-	else
-		tmp += b * (a >> 32);
-	return tmp >> 32;
-#endif /* __SIZEOF_INT128__ */
-#endif /* BITS_PER_LONG == 32 */
-}
-
 void *calloc(size_t nmemb, size_t size)
 {
 	void *ptr;
 
-	assert(!mult_overflow(nmemb, size));
+	assert(!check_mul_overflow(nmemb, size));
 	ptr = malloc(nmemb * size);
 	if (ptr)
 		memset(ptr, 0, nmemb * size);
-- 
2.34.1

