Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD26D340C7D
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhCRSIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:08:13 -0400
Received: from foss.arm.com ([217.140.110.172]:45674 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhCRSIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 14:08:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27DAE31B;
        Thu, 18 Mar 2021 11:08:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B4983F70D;
        Thu, 18 Mar 2021 11:08:09 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH v2 4/4] devicetree: Parse correctly the stdout-path
Date:   Thu, 18 Mar 2021 18:07:27 +0000
Message-Id: <20210318180727.116004-5-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318180727.116004-1-nikos.nikoleris@arm.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The stdout-path property in the device tree is a string of the form

"UART_NODE:OPTS"

Where UART_NODE is a compatible serial port and OPTS specify
parameters such as the baud. Fix the way we parse the node and, at
least for now, ignore options as we don't act on them.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/string.h     |  1 +
 lib/devicetree.c | 15 +++++++++------
 lib/string.c     |  7 +++++++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/lib/string.h b/lib/string.h
index 8da687e..e1febfe 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -15,6 +15,7 @@ extern int strcmp(const char *a, const char *b);
 extern int strncmp(const char *a, const char *b, size_t n);
 extern char *strchr(const char *s, int c);
 extern char *strrchr(const char *s, int c);
+extern char *strchrnul(const char *s, int c);
 extern char *strstr(const char *haystack, const char *needle);
 extern void *memset(void *s, int c, size_t n);
 extern void *memcpy(void *dest, const void *src, size_t n);
diff --git a/lib/devicetree.c b/lib/devicetree.c
index 1020324..409d18b 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -265,21 +265,24 @@ int dt_get_bootargs(const char **bootargs)
 
 int dt_get_default_console_node(void)
 {
-	const struct fdt_property *prop;
+	const char *p, *q;
 	int node, len;
 
 	node = fdt_path_offset(fdt, "/chosen");
 	if (node < 0)
 		return node;
 
-	prop = fdt_get_property(fdt, node, "stdout-path", &len);
-	if (!prop) {
-		prop = fdt_get_property(fdt, node, "linux,stdout-path", &len);
-		if (!prop)
+	p = fdt_getprop(fdt, node, "stdout-path", &len);
+	if (!p) {
+		p = fdt_getprop(fdt, node, "linux,stdout-path", &len);
+		if (!p)
 			return len;
 	}
 
-	return fdt_path_offset(fdt, prop->data);
+	q = strchrnul(p, ':');
+	len = q - p;
+
+	return fdt_path_offset_namelen(fdt, p, len);
 }
 
 int dt_get_initrd(const char **initrd, u32 *size)
diff --git a/lib/string.c b/lib/string.c
index f77881f..30592c5 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -75,6 +75,13 @@ char *strrchr(const char *s, int c)
     return (char *)last;
 }
 
+char *strchrnul(const char *s, int c)
+{
+    while (*s && *s != (char)c)
+        s++;
+    return (char *)s;
+}
+
 char *strstr(const char *s1, const char *s2)
 {
     size_t l1, l2;
-- 
2.25.1

