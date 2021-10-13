Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8CC42C6A3
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbhJMQpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:45:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233947AbhJMQpe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 12:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mL+fHkvU5ifZdgSzGi3QgOi+fdiYfh+Bf2KPv6X8Ihs=;
        b=Bp/TN3SUNSbLkrqlCBo8lVkk8wURt2amXi9YZE5MvvsrCKnZt1uYKTuKDkNJaXxEerxNs/
        nAuoqVr4eD4PrsmebpDFYVCsI++29uVrqoOXx7S6Y6FDUQWMux3VyYwnGIXEmt30JmB62U
        cqXN5p9UmBx9ynG5m28ES+hwmDSM+qY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-eogGlG-eO9q9eajwxV_n2g-1; Wed, 13 Oct 2021 12:43:29 -0400
X-MC-Unique: eogGlG-eO9q9eajwxV_n2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D15E1927800;
        Wed, 13 Oct 2021 16:43:28 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4ECD5DA60;
        Wed, 13 Oct 2021 16:43:19 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, ahmeddan@amazon.com
Subject: [PATCH kvm-unit-tests 2/2] lib: Introduce strtoll/strtoull
Date:   Wed, 13 Oct 2021 18:42:59 +0200
Message-Id: <20211013164259.88281-3-drjones@redhat.com>
In-Reply-To: <20211013164259.88281-1-drjones@redhat.com>
References: <20211013164259.88281-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/stdlib.h |  2 ++
 lib/string.c | 51 +++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/lib/stdlib.h b/lib/stdlib.h
index 33c00e8a5204..28496d7ae333 100644
--- a/lib/stdlib.h
+++ b/lib/stdlib.h
@@ -9,5 +9,7 @@
 
 long int strtol(const char *nptr, char **endptr, int base);
 unsigned long int strtoul(const char *nptr, char **endptr, int base);
+long long int strtoll(const char *nptr, char **endptr, int base);
+unsigned long long int strtoull(const char *nptr, char **endptr, int base);
 
 #endif /* _STDLIB_H_ */
diff --git a/lib/string.c b/lib/string.c
index ffc7c7e4f855..27106dae0b0b 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -168,9 +168,10 @@ static int isspace(int c)
     return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
 }
 
-static unsigned long __strtol(const char *nptr, char **endptr,
-                              int base, bool is_signed) {
-    unsigned long acc = 0;
+static unsigned long long __strtoll(const char *nptr, char **endptr,
+                                    int base, bool is_signed,
+                                    bool is_longlong) {
+    unsigned long long ull = 0;
     const char *s = nptr;
     int neg, c;
 
@@ -210,36 +211,58 @@ static unsigned long __strtol(const char *nptr, char **endptr,
         else
             break;
 
-        if (is_signed) {
-            long sacc = (long)acc;
-            assert(!check_mul_overflow(sacc, base));
-            assert(!check_add_overflow(sacc * base, c));
+        if (!is_longlong) {
+            if (is_signed) {
+                long sl = (long)ull;
+                assert(!check_mul_overflow(sl, base));
+                assert(!check_add_overflow(sl * base, c));
+            } else {
+                unsigned long ul = (unsigned long)ull;
+                assert(!check_mul_overflow(ul, base));
+                assert(!check_add_overflow(ul * base, c));
+            }
         } else {
-            assert(!check_mul_overflow(acc, base));
-            assert(!check_add_overflow(acc * base, c));
+            if (is_signed) {
+                long long sll = (long long)ull;
+                assert(!check_mul_overflow(sll, base));
+                assert(!check_add_overflow(sll * base, c));
+            } else {
+                assert(!check_mul_overflow(ull, base));
+                assert(!check_add_overflow(ull * base, c));
+            }
         }
 
-        acc = acc * base + c;
+        ull = ull * base + c;
         s++;
     }
 
     if (neg)
-        acc = -acc;
+        ull = -ull;
 
     if (endptr)
         *endptr = (char *)s;
 
-    return acc;
+    return ull;
 }
 
 long int strtol(const char *nptr, char **endptr, int base)
 {
-    return __strtol(nptr, endptr, base, true);
+    return __strtoll(nptr, endptr, base, true, false);
 }
 
 unsigned long int strtoul(const char *nptr, char **endptr, int base)
 {
-    return __strtol(nptr, endptr, base, false);
+    return __strtoll(nptr, endptr, base, false, false);
+}
+
+long long int strtoll(const char *nptr, char **endptr, int base)
+{
+    return __strtoll(nptr, endptr, base, true, true);
+}
+
+unsigned long long int strtoull(const char *nptr, char **endptr, int base)
+{
+    return __strtoll(nptr, endptr, base, false, true);
 }
 
 long atol(const char *ptr)
-- 
2.31.1

