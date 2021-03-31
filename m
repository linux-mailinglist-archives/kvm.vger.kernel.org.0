Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEF03466D8
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhCWRzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhCWRyf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 13:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616522074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zRuszIT5rQbqYA0k4j2pUZ/qfqnNj6Z8T7IjpQIB3Ak=;
        b=d3k/erQqEG70aYT3pniYutDLO1J9z4zTlIrqgwYJO8ji4weXavwSV3GkhMePwWFiCBqpob
        /V6Y/pT3oRNzlJOzJCLrTZpLy82/YFgVdQCAOfZBXavhrv3CksY2MantzbP9WXjLME5EOz
        3Edbphc4O8NqpGppmEjbslJCOn9rQ2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-UEOK9XM5MqWMwh_UVp-GKA-1; Tue, 23 Mar 2021 13:54:32 -0400
X-MC-Unique: UEOK9XM5MqWMwh_UVp-GKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F09D87A83F
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 17:54:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A9325DEAD;
        Tue, 23 Mar 2021 17:54:26 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests v2] compiler: Add builtin overflow flag and predicate wrappers
Date:   Tue, 23 Mar 2021 18:54:24 +0100
Message-Id: <20210323175424.368223-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking for overflow can be difficult, but doing so may be a good
idea to avoid difficult to debug problems. Compilers that provide
builtins for overflow checking allow the checks to be simple
enough that we can use them more liberally. The idea for this
flag is to wrap a calculation that should have overflow checking,
allowing compilers that support it to give us some extra robustness.
For example,

  #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
      bool overflow = __builtin_mul_overflow(x, y, &z);
      assert(!overflow);
  #else
      /* Older compiler, hopefully we don't overflow... */
      z = x * y;
  #endif

This is a bit ugly though, so when possible we can just use the
predicate wrappers, which have an always-false fallback, e.g.

  /* Old compilers won't assert on overflow. Oh, well... */
  assert(!check_mul_overflow(x, y));
  z = x * y;

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

v2: Added predicate wrappers

 lib/linux/compiler.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 2d72f18c36e5..aa2e3710cf1d 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -8,6 +8,39 @@
 
 #ifndef __ASSEMBLY__
 
+#define GCC_VERSION (__GNUC__ * 10000           \
+		     + __GNUC_MINOR__ * 100     \
+		     + __GNUC_PATCHLEVEL__)
+
+#ifdef __clang__
+#if __has_builtin(__builtin_add_overflow) && \
+    __has_builtin(__builtin_sub_overflow) && \
+    __has_builtin(__builtin_mul_overflow)
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#define check_add_overflow(a, b) ({			\
+	typeof((a) + (b)) __d;				\
+	__builtin_add_overflow(a, b, &__d);		\
+})
+#define check_sub_overflow(a, b) ({			\
+	typeof((a) - (b)) __d;				\
+	__builtin_sub_overflow(a, b, &__d);		\
+})
+#define check_mul_overflow(a, b) ({			\
+	typeof((a) * (b)) __d;				\
+	__builtin_mul_overflow(a, b, &__d);		\
+})
+#endif
+#elif GCC_VERSION >= 50100
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#define check_add_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) + (b)))0)
+#define check_sub_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) - (b)))0)
+#define check_mul_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) * (b)))0)
+#else
+#define check_add_overflow(a, b) (0)
+#define check_sub_overflow(a, b) (0)
+#define check_mul_overflow(a, b) (0)
+#endif
+
 #include <stdint.h>
 
 #define barrier()	asm volatile("" : : : "memory")
-- 
2.26.3

