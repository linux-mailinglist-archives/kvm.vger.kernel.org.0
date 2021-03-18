Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF3340C7C
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCRSIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:08:12 -0400
Received: from foss.arm.com ([217.140.110.172]:45654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhCRSIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 14:08:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB220101E;
        Thu, 18 Mar 2021 11:08:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3736B3F70D;
        Thu, 18 Mar 2021 11:08:02 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr and strtoul
Date:   Thu, 18 Mar 2021 18:07:24 +0000
Message-Id: <20210318180727.116004-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318180727.116004-1-nikos.nikoleris@arm.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds two functions from <string.h> and one from <stdlib.h>
in preparation for an update in libfdt.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/stdlib.h | 12 +++++++++
 lib/string.h |  4 ++-
 lib/string.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 9 deletions(-)
 create mode 100644 lib/stdlib.h

diff --git a/lib/stdlib.h b/lib/stdlib.h
new file mode 100644
index 0000000..e8abe75
--- /dev/null
+++ b/lib/stdlib.h
@@ -0,0 +1,12 @@
+/*
+ * Header for libc stdlib functions
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+#ifndef _STDLIB_H_
+#define _STDLIB_H_
+
+unsigned long int strtoul(const char *nptr, char **endptr, int base);
+
+#endif /* _STDLIB_H_ */
diff --git a/lib/string.h b/lib/string.h
index 493d51b..8da687e 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -7,12 +7,14 @@
 #ifndef __STRING_H
 #define __STRING_H
 
-extern unsigned long strlen(const char *buf);
+extern size_t strlen(const char *buf);
+extern size_t strnlen(const char *buf, size_t maxlen);
 extern char *strcat(char *dest, const char *src);
 extern char *strcpy(char *dest, const char *src);
 extern int strcmp(const char *a, const char *b);
 extern int strncmp(const char *a, const char *b, size_t n);
 extern char *strchr(const char *s, int c);
+extern char *strrchr(const char *s, int c);
 extern char *strstr(const char *haystack, const char *needle);
 extern void *memset(void *s, int c, size_t n);
 extern void *memcpy(void *dest, const void *src, size_t n);
diff --git a/lib/string.c b/lib/string.c
index 75257f5..f77881f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -6,16 +6,26 @@
  */
 
 #include "libcflat.h"
+#include "stdlib.h"
 
-unsigned long strlen(const char *buf)
+size_t strlen(const char *buf)
 {
-    unsigned long len = 0;
+    size_t len = 0;
 
     while (*buf++)
 	++len;
     return len;
 }
 
+size_t strnlen(const char *buf, size_t maxlen)
+{
+    const char *sc;
+
+    for (sc = buf; maxlen-- && *sc != '\0'; ++sc)
+        /* nothing */;
+    return sc - buf;
+}
+
 char *strcat(char *dest, const char *src)
 {
     char *p = dest;
@@ -55,6 +65,16 @@ char *strchr(const char *s, int c)
     return (char *)s;
 }
 
+char *strrchr(const char *s, int c)
+{
+    const char *last = NULL;
+    do {
+        if (*s == (char)c)
+            last = s;
+    } while (*s++);
+    return (char *)last;
+}
+
 char *strstr(const char *s1, const char *s2)
 {
     size_t l1, l2;
@@ -135,13 +155,21 @@ void *memchr(const void *s, int c, size_t n)
     return NULL;
 }
 
-long atol(const char *ptr)
+static int isspace(int c)
+{
+    return c == ' ' || c == '\t' || c == '\f' || c == '\n' || c == '\r';
+}
+
+unsigned long int strtoul(const char *nptr, char **endptr, int base)
 {
     long acc = 0;
-    const char *s = ptr;
+    const char *s = nptr;
     int neg, c;
 
-    while (*s == ' ' || *s == '\t')
+    if (base < 0 || base == 1 || base > 32)
+        goto out; // errno = EINVAL
+
+    while (isspace(*s))
         s++;
     if (*s == '-'){
         neg = 1;
@@ -152,20 +180,46 @@ long atol(const char *ptr)
             s++;
     }
 
+    if (base == 0 || base == 16) {
+        if (*s == '0') {
+            s++;
+            if (*s == 'x') {
+                 s++;
+                 base = 16;
+            } else if (base == 0)
+                 base = 8;
+        } else if (base == 0)
+            base = 10;
+    }
+
     while (*s) {
-        if (*s < '0' || *s > '9')
+        if (*s >= '0' && *s < '0' + base && *s <= '9')
+            c = *s - '0';
+        else if (*s >= 'a' && *s < 'a' + base - 10)
+            c = *s - 'a' + 10;
+        else if (*s >= 'A' && *s < 'A' + base - 10)
+            c = *s - 'A' + 10;
+        else
             break;
-        c = *s - '0';
-        acc = acc * 10 + c;
+        acc = acc * base + c;
         s++;
     }
 
     if (neg)
         acc = -acc;
 
+ out:
+    if (endptr)
+        *endptr = (char *)s;
+
     return acc;
 }
 
+long atol(const char *ptr)
+{
+    return strtoul(ptr, NULL, 10);
+}
+
 extern char **environ;
 
 char *getenv(const char *name)
-- 
2.25.1

