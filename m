Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF16A675A
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 06:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjCAFew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 00:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjCAFer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 00:34:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02BA28865
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:46 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id k3-20020a170902ce0300b0019ca6e66303so6400294plg.18
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 21:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677648886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=doJHREwFqM2JMRmYYm/Qs7NX61miXXm1Yp1snN9XpN4=;
        b=Lq/2e/jazDMl9/fQ68ofxu+DdZlhRYZaTqKaqr3FjnwgolpOt6EO0XfCvTYIsu8UZK
         d1LHDkqJqKoyt6tNK2tH2e7boPdvkX4GBaRGgR9+zsrr4WeI0iNEf0dyBOqwOLkLe5+O
         vgkNNRzV3GtXyJGQSO40M18SLJodHpgp9fn2uomyFCBzZJ2cyXUGfXqvDZkZqbCxyjds
         SOD1d90VrW9j2w0/8jOvawb3lrfZyymLriFo+kfQglohrk7G+nx7ennN1diapOwef5WG
         UCyEH4Aaft0M77jlYknFLLHcKj2TfiYAkBIL77XxqZj9Iqqr5AvLbZFnWtazyMLeynQI
         jkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677648886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=doJHREwFqM2JMRmYYm/Qs7NX61miXXm1Yp1snN9XpN4=;
        b=irmp/Waprp0MPqj/vQCq0p9S973GcDPf78fThBioeb99gJ72MoHNJ569wzbVqzmZV2
         siuIMqkN+GRCeugXVEagB04S7xvBH6Ch91/NyPt8x6d0V6V63DR0X4RQ88bmBZOjd6hS
         5WHQrzrEl6+8rnOYguLhxsgOHl9ZzOex/9olr5kcNaloInJsEWWFhP3rkQXpegMdbves
         kOjKBtSml/HyBNRE2oSXycYYmZFdLaVH/gdq5QOd89qJpSSizEJRuiENPhpJQXQZJ3by
         llRGHLO55FcBz0hx93K9TDFTpSib77/FvBOyUYbfRdfLHYjB39hjS7zquai4mTPDFKBi
         pLlA==
X-Gm-Message-State: AO0yUKWJBYaAhmTRTAgZr8/n4fARDGoSbbDjzqf+Q9Ezr/ItoXbN4DmN
        R6rt2XduF0TZfXLl6veSWQ0at5Z2axWC5U+6tQLmIh00BSh60/DvroVPJhDJZnm7ctHW3tNiHVq
        ozdEJixqGUsAw+D6xusbNiVG81Jd+JFH+pzZ06RJrLZWdY/aHbhgvr5AwEsyXin5KDdG3
X-Google-Smtp-Source: AK7set/MygwT3iCb4gKlnzK42RMvwufLoNGgQy/h/Fw27wHDfGzghfamjlEsiKLtjw+pO1PD8O2NWVvfT9nlBbpe
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:fae:b0:237:64dc:5acd with SMTP
 id 43-20020a17090a0fae00b0023764dc5acdmr2164900pjz.7.1677648886099; Tue, 28
 Feb 2023 21:34:46 -0800 (PST)
Date:   Wed,  1 Mar 2023 05:34:21 +0000
In-Reply-To: <20230301053425.3880773-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301053425.3880773-5-aaronlewis@google.com>
Subject: [PATCH 4/8] KVM: selftests: Copy printf.c to KVM selftests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a local version of vsprintf() for the guest to use.

The file printf.c was lifted from arch/x86/boot/printf.c.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/lib/printf.c | 307 +++++++++++++++++++++++
 1 file changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/printf.c

diff --git a/tools/testing/selftests/kvm/lib/printf.c b/tools/testing/selftests/kvm/lib/printf.c
new file mode 100644
index 000000000000..1237beeb9540
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/printf.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * Oh, it's a waste of space, but oh-so-yummy for debugging.  This
+ * version of printf() does not include 64-bit support.  "Live with
+ * it."
+ *
+ */
+
+#include "boot.h"
+
+static int skip_atoi(const char **s)
+{
+	int i = 0;
+
+	while (isdigit(**s))
+		i = i * 10 + *((*s)++) - '0';
+	return i;
+}
+
+#define ZEROPAD	1		/* pad with zero */
+#define SIGN	2		/* unsigned/signed long */
+#define PLUS	4		/* show plus */
+#define SPACE	8		/* space if plus */
+#define LEFT	16		/* left justified */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
+
+#define __do_div(n, base) ({ \
+int __res; \
+__res = ((unsigned long) n) % (unsigned) base; \
+n = ((unsigned long) n) / (unsigned) base; \
+__res; })
+
+static char *number(char *str, long num, int base, int size, int precision,
+		    int type)
+{
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char c, sign, locase;
+	int i;
+
+	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters */
+	locase = (type & SMALL);
+	if (type & LEFT)
+		type &= ~ZEROPAD;
+	if (base < 2 || base > 16)
+		return NULL;
+	c = (type & ZEROPAD) ? '0' : ' ';
+	sign = 0;
+	if (type & SIGN) {
+		if (num < 0) {
+			sign = '-';
+			num = -num;
+			size--;
+		} else if (type & PLUS) {
+			sign = '+';
+			size--;
+		} else if (type & SPACE) {
+			sign = ' ';
+			size--;
+		}
+	}
+	if (type & SPECIAL) {
+		if (base == 16)
+			size -= 2;
+		else if (base == 8)
+			size--;
+	}
+	i = 0;
+	if (num == 0)
+		tmp[i++] = '0';
+	else
+		while (num != 0)
+			tmp[i++] = (digits[__do_div(num, base)] | locase);
+	if (i > precision)
+		precision = i;
+	size -= precision;
+	if (!(type & (ZEROPAD + LEFT)))
+		while (size-- > 0)
+			*str++ = ' ';
+	if (sign)
+		*str++ = sign;
+	if (type & SPECIAL) {
+		if (base == 8)
+			*str++ = '0';
+		else if (base == 16) {
+			*str++ = '0';
+			*str++ = ('X' | locase);
+		}
+	}
+	if (!(type & LEFT))
+		while (size-- > 0)
+			*str++ = c;
+	while (i < precision--)
+		*str++ = '0';
+	while (i-- > 0)
+		*str++ = tmp[i];
+	while (size-- > 0)
+		*str++ = ' ';
+	return str;
+}
+
+int vsprintf(char *buf, const char *fmt, va_list args)
+{
+	int len;
+	unsigned long num;
+	int i, base;
+	char *str;
+	const char *s;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/* min. # of digits for integers; max
+				   number of chars for from string */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+
+	for (str = buf; *fmt; ++fmt) {
+		if (*fmt != '%') {
+			*str++ = *fmt;
+			continue;
+		}
+
+		/* process flags */
+		flags = 0;
+	      repeat:
+		++fmt;		/* this also skips first '%' */
+		switch (*fmt) {
+		case '-':
+			flags |= LEFT;
+			goto repeat;
+		case '+':
+			flags |= PLUS;
+			goto repeat;
+		case ' ':
+			flags |= SPACE;
+			goto repeat;
+		case '#':
+			flags |= SPECIAL;
+			goto repeat;
+		case '0':
+			flags |= ZEROPAD;
+			goto repeat;
+		}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = va_arg(args, int);
+			if (field_width < 0) {
+				field_width = -field_width;
+				flags |= LEFT;
+			}
+		}
+
+		/* get the precision */
+		precision = -1;
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt))
+				precision = skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				precision = va_arg(args, int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
+			qualifier = *fmt;
+			++fmt;
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+		case 'c':
+			if (!(flags & LEFT))
+				while (--field_width > 0)
+					*str++ = ' ';
+			*str++ = (unsigned char)va_arg(args, int);
+			while (--field_width > 0)
+				*str++ = ' ';
+			continue;
+
+		case 's':
+			s = va_arg(args, char *);
+			len = strnlen(s, precision);
+
+			if (!(flags & LEFT))
+				while (len < field_width--)
+					*str++ = ' ';
+			for (i = 0; i < len; ++i)
+				*str++ = *s++;
+			while (len < field_width--)
+				*str++ = ' ';
+			continue;
+
+		case 'p':
+			if (field_width == -1) {
+				field_width = 2 * sizeof(void *);
+				flags |= ZEROPAD;
+			}
+			str = number(str,
+				     (unsigned long)va_arg(args, void *), 16,
+				     field_width, precision, flags);
+			continue;
+
+		case 'n':
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			continue;
+
+		case '%':
+			*str++ = '%';
+			continue;
+
+			/* integer number formats - set up the flags and "break" */
+		case 'o':
+			base = 8;
+			break;
+
+		case 'x':
+			flags |= SMALL;
+		case 'X':
+			base = 16;
+			break;
+
+		case 'd':
+		case 'i':
+			flags |= SIGN;
+		case 'u':
+			break;
+
+		default:
+			*str++ = '%';
+			if (*fmt)
+				*str++ = *fmt;
+			else
+				--fmt;
+			continue;
+		}
+		if (qualifier == 'l')
+			num = va_arg(args, unsigned long);
+		else if (qualifier == 'h') {
+			num = (unsigned short)va_arg(args, int);
+			if (flags & SIGN)
+				num = (short)num;
+		} else if (flags & SIGN)
+			num = va_arg(args, int);
+		else
+			num = va_arg(args, unsigned int);
+		str = number(str, num, base, field_width, precision, flags);
+	}
+	*str = '\0';
+	return str - buf;
+}
+
+int sprintf(char *buf, const char *fmt, ...)
+{
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vsprintf(buf, fmt, args);
+	va_end(args);
+	return i;
+}
+
+int printf(const char *fmt, ...)
+{
+	char printf_buf[1024];
+	va_list args;
+	int printed;
+
+	va_start(args, fmt);
+	printed = vsprintf(printf_buf, fmt, args);
+	va_end(args);
+
+	puts(printf_buf);
+
+	return printed;
+}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

