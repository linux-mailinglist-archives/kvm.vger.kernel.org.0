Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50224A6472
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 20:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbiBATBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 14:01:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241471AbiBATBV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 14:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643742080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r1eAmaC6nbw5SHDAQ63+cFrjxWN6o33rHt0BCHNnB+E=;
        b=MwY4Fuqquj2D8FjZnZCcqJo2vAcl1urqCNOAxeafzEaEjHktJhJq93w3/4TZYTUDu5G244
        BFEjT7UpXWQ6tdNN/BCxuRXH78t68qo/1OUh6tY5rqhpgDHP84ORd4uNQN+O+a10JrFSK0
        4to2/luq3cO1qJGoqcWhfk0iAJoUMHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-pWt_tkg3PbGrP60HWOXV2g-1; Tue, 01 Feb 2022 14:01:19 -0500
X-MC-Unique: pWt_tkg3PbGrP60HWOXV2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82ACF84B9A5
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 19:01:18 +0000 (UTC)
Received: from gator.home (unknown [10.40.194.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3474B5D9D5;
        Tue,  1 Feb 2022 19:01:17 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests] arm64: Fix compiling with ancient compiler
Date:   Tue,  1 Feb 2022 20:01:16 +0100
Message-Id: <20220201190116.182415-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
the build fails with

  lib/libcflat.a(alloc.o): In function `mult_overflow':
  /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'

According to kernel commit fb8722735f50 ("arm64: support __int128 on
gcc 5+") GCC5+ will not emit __multi3 for __int128 multiplication,
so let's just fallback to the non-__int128 overflow check when we
use gcc versions older than 5.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/alloc.c b/lib/alloc.c
index f4266f5d064e..70228aa32c6c 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,6 +1,7 @@
 #include "alloc.h"
 #include "asm/page.h"
 #include "bitops.h"
+#include <linux/compiler.h>
 
 void *malloc(size_t size)
 {
@@ -13,7 +14,7 @@ static bool mult_overflow(size_t a, size_t b)
 	/* 32 bit system, easy case: just use u64 */
 	return (u64)a * (u64)b >= (1ULL << 32);
 #else
-#ifdef __SIZEOF_INT128__
+#if defined(__SIZEOF_INT128__) && (!defined(__aarch64__) || GCC_VERSION >= 50000)
 	/* if __int128 is available use it (like the u64 case above) */
 	unsigned __int128 res = a;
 	res *= b;
-- 
2.34.1

