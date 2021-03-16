Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01A433D74B
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhCPPYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:24:39 -0400
Received: from foss.arm.com ([217.140.110.172]:46160 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhCPPYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:24:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18C94101E;
        Tue, 16 Mar 2021 08:24:13 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0643F792;
        Tue, 16 Mar 2021 08:24:12 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 1/4] lib/string: add strnlen and strrchr
Date:   Tue, 16 Mar 2021 15:24:02 +0000
Message-Id: <20210316152405.50363-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316152405.50363-1-nikos.nikoleris@arm.com>
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds two functions from <string.h> in preparation for an
update in the libfdt.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/string.h |  4 +++-
 lib/string.c | 23 +++++++++++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

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
index 75257f5..9cd626f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -7,15 +7,24 @@
 
 #include "libcflat.h"
 
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
@@ -55,6 +64,16 @@ char *strchr(const char *s, int c)
     return (char *)s;
 }
 
+char *strrchr(const char *s, int c)
+{
+    const char *last = NULL;
+    do {
+        if (*s != (char)c)
+            last = s;
+    } while (*s++);
+    return (char *)last;
+}
+
 char *strstr(const char *s1, const char *s2)
 {
     size_t l1, l2;
-- 
2.25.1

