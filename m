Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8C69429E
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBMKSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjBMKSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:39 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D68F817160
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:24 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16A2A1E2F;
        Mon, 13 Feb 2023 02:19:07 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 769A63F703;
        Mon, 13 Feb 2023 02:18:23 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 17/30] lib/printf: Support for precision modifier in printf
Date:   Mon, 13 Feb 2023 10:17:46 +0000
Message-Id: <20230213101759.2577077-18-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This follows the typical format of:

printf("%.Ns", *str);

Where N might be a decimal digit string or '*'. This feature is used
by a future change.

See also: man 3 printf

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/printf.c | 95 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 78 insertions(+), 17 deletions(-)

diff --git a/lib/printf.c b/lib/printf.c
index 383799ec..d600199b 100644
--- a/lib/printf.c
+++ b/lib/printf.c
@@ -6,6 +6,7 @@
  */
 
 #include "libcflat.h"
+#include "ctype.h"
 
 #define BUFSZ 2000
 
@@ -19,6 +20,7 @@ typedef struct strprops {
 	char pad;
 	int npad;
 	bool alternate;
+	int precision;
 } strprops_t;
 
 static void addchar(pstream_t *p, char c)
@@ -43,7 +45,7 @@ static void print_str(pstream_t *p, const char *s, strprops_t props)
 		}
 	}
 
-	while (*s)
+	while (*s && props.precision--)
 		addchar(p, *s++);
 
 	if (npad < 0) {
@@ -73,12 +75,13 @@ static void print_int(pstream_t *ps, long long n, int base, strprops_t props)
 		n /= base;
 	}
 
+	while (p == buf || (p - buf < props.precision))
+		*p++ = '0';
+	props.precision = -1;
+
 	if (s)
 		*p++ = '-';
 
-	if (p == buf)
-		*p++ = '0';
-
 	for (i = 0; i < (p - buf) / 2; ++i) {
 		char tmp;
 
@@ -104,8 +107,13 @@ static void print_unsigned(pstream_t *ps, unsigned long long n, int base,
 	}
 
 	if (p == buf)
+		props.alternate = false;
+
+	while (p == buf || (p - buf < props.precision))
 		*p++ = '0';
-	else if (props.alternate && base == 16) {
+	props.precision = -1;
+
+	if (props.alternate && base == 16) {
 		if (props.pad == '0') {
 			addchar(ps, '0');
 			addchar(ps, 'x');
@@ -147,9 +155,56 @@ static int fmtnum(const char **fmt)
 	return num;
 }
 
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static int skip_atoi(const char **s)
+{
+	int i = 0;
+
+	do {
+		i = i*10 + *((*s)++) - '0';
+	} while (isdigit(**s));
+
+	return i;
+}
+
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static int get_int(const char **fmt, va_list *ap)
+{
+	if (isdigit(**fmt))
+		return skip_atoi(fmt);
+
+	if (**fmt == '*') {
+		++(*fmt);
+		/* it's the next argument */
+		return va_arg(*ap, int);
+	}
+	return 0;
+}
+
 int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 {
 	pstream_t s;
+	va_list args;
+
+	/*
+	 * We want to pass our input va_list to helper functions by reference,
+	 * but there's an annoying edge case. If va_list was originally passed
+	 * to us by value, we could just pass &ap down to the helpers. This is
+	 * the case on, for example, X86_32.
+	 * However, on X86_64 (and possibly others), va_list is actually a
+	 * size-1 array containing a structure. Our function parameter ap has
+	 * decayed from T[1] to T*, and &ap has type T** rather than T(*)[1],
+	 * which is what will be expected by a function taking a va_list *
+	 * parameter.
+	 * One standard way to solve this mess is by creating a copy in a local
+	 * variable of type va_list and then passing a pointer to that local
+	 * copy instead, which is what we do here.
+	 */
+	va_copy(args, va);
 
 	s.buffer = buf;
 	s.remain = size - 1;
@@ -160,6 +215,7 @@ int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 		strprops_t props;
 		memset(&props, 0, sizeof(props));
 		props.pad = ' ';
+		props.precision = -1;
 
 		if (f != '%') {
 			addchar(&s, f);
@@ -172,11 +228,15 @@ morefmt:
 			addchar(&s, '%');
 			break;
 		case 'c':
-			addchar(&s, va_arg(va, int));
+			addchar(&s, va_arg(args, int));
 			break;
 		case '\0':
 			--fmt;
 			break;
+		case '.':
+			props.pad = ' ';
+			props.precision = get_int(&fmt, &args);
+			goto morefmt;
 		case '#':
 			props.alternate = true;
 			goto morefmt;
@@ -204,54 +264,55 @@ morefmt:
 		case 'd':
 			switch (nlong) {
 			case 0:
-				print_int(&s, va_arg(va, int), 10, props);
+				print_int(&s, va_arg(args, int), 10, props);
 				break;
 			case 1:
-				print_int(&s, va_arg(va, long), 10, props);
+				print_int(&s, va_arg(args, long), 10, props);
 				break;
 			default:
-				print_int(&s, va_arg(va, long long), 10, props);
+				print_int(&s, va_arg(args, long long), 10, props);
 				break;
 			}
 			break;
 		case 'u':
 			switch (nlong) {
 			case 0:
-				print_unsigned(&s, va_arg(va, unsigned), 10, props);
+				print_unsigned(&s, va_arg(args, unsigned int), 10, props);
 				break;
 			case 1:
-				print_unsigned(&s, va_arg(va, unsigned long), 10, props);
+				print_unsigned(&s, va_arg(args, unsigned long), 10, props);
 				break;
 			default:
-				print_unsigned(&s, va_arg(va, unsigned long long), 10, props);
+				print_unsigned(&s, va_arg(args, unsigned long long), 10, props);
 				break;
 			}
 			break;
 		case 'x':
 			switch (nlong) {
 			case 0:
-				print_unsigned(&s, va_arg(va, unsigned), 16, props);
+				print_unsigned(&s, va_arg(args, unsigned int), 16, props);
 				break;
 			case 1:
-				print_unsigned(&s, va_arg(va, unsigned long), 16, props);
+				print_unsigned(&s, va_arg(args, unsigned long), 16, props);
 				break;
 			default:
-				print_unsigned(&s, va_arg(va, unsigned long long), 16, props);
+				print_unsigned(&s, va_arg(args, unsigned long long), 16, props);
 				break;
 			}
 			break;
 		case 'p':
 			props.alternate = true;
-			print_unsigned(&s, (unsigned long)va_arg(va, void *), 16, props);
+			print_unsigned(&s, (unsigned long)va_arg(args, void *), 16, props);
 			break;
 		case 's':
-			print_str(&s, va_arg(va, const char *), props);
+			print_str(&s, va_arg(args, const char *), props);
 			break;
 		default:
 			addchar(&s, f);
 			break;
 		}
 	}
+	va_end(args);
 	*s.buffer = 0;
 	return s.added;
 }
-- 
2.25.1

