Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320783460AC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhCWN6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhCWN6I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 09:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616507887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XzJmK4D7Fm6Tgm/8V9hEExZ1Vha0jtYTosH2Xs3SWKk=;
        b=GtDjPdJedzf0eAuHY4jyMXAGW1ZIxgGhxALpYy+xiHqcETcOEct5/jIYbPLYKDaSADrnWn
        MlaObSIhdgIPs35yt+GFO5Cs44G6bQ7ZoSSNS3MWtDvjCs2DSh/AAZrB4bIe20j9jawWvg
        polM9GUzKxh93sQW4+jukiELolvbXAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-Zt63J2q_Mk-XBnIVqkCHqw-1; Tue, 23 Mar 2021 09:58:05 -0400
X-MC-Unique: Zt63J2q_Mk-XBnIVqkCHqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C5EB1007467
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 13:58:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28A9719C45;
        Tue, 23 Mar 2021 13:58:02 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: [PATCH kvm-unit-tests] compiler: Add builtin overflow flag
Date:   Tue, 23 Mar 2021 14:58:01 +0100
Message-Id: <20210323135801.295407-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking for overflow can difficult, but doing so may be a good
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

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/linux/compiler.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 2d72f18c36e5..311da9807932 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -8,6 +8,20 @@
 
 #ifndef __ASSEMBLY__
 
+#define GCC_VERSION (__GNUC__ * 10000           \
+		     + __GNUC_MINOR__ * 100     \
+		     + __GNUC_PATCHLEVEL__)
+
+#ifdef __clang__
+#if __has_builtin(__builtin_mul_overflow) && \
+    __has_builtin(__builtin_add_overflow) && \
+    __has_builtin(__builtin_sub_overflow)
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+#elif GCC_VERSION >= 50100
+#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
+#endif
+
 #include <stdint.h>
 
 #define barrier()	asm volatile("" : : : "memory")
-- 
2.26.3

