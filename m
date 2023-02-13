Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C604169429F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjBMKSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjBMKSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:40 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D6D912F32
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:25 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CA3B1E32;
        Mon, 13 Feb 2023 02:19:08 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD4C13F703;
        Mon, 13 Feb 2023 02:18:24 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 18/30] lib/printf: Add support for printing wide strings
Date:   Mon, 13 Feb 2023 10:17:47 +0000
Message-Id: <20230213101759.2577077-19-nikos.nikoleris@arm.com>
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

This change adds support for wide strings (u16*) to printf()
variants. This feature is used by a future change.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/printf.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/lib/printf.c b/lib/printf.c
index d600199b..27041bb4 100644
--- a/lib/printf.c
+++ b/lib/printf.c
@@ -58,6 +58,102 @@ static void print_str(pstream_t *p, const char *s, strprops_t props)
 	}
 }
 
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static u32 utf16_to_utf32(const u16 **s16)
+{
+	u16 c0, c1;
+
+	c0 = *(*s16)++;
+	/* not a surrogate */
+	if ((c0 & 0xf800) != 0xd800)
+		return c0;
+	/* invalid: low surrogate instead of high */
+	if (c0 & 0x0400)
+		return 0xfffd;
+	c1 = **s16;
+	/* invalid: missing low surrogate */
+	if ((c1 & 0xfc00) != 0xdc00)
+		return 0xfffd;
+	/* valid surrogate pair */
+	++(*s16);
+	return (0x10000 - (0xd800 << 10) - 0xdc00) + (c0 << 10) + c1;
+}
+
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static size_t utf16s_utf8nlen(const u16 *s16, size_t maxlen)
+{
+	size_t len, clen;
+
+	for (len = 0; len < maxlen && *s16; len += clen) {
+		u16 c0 = *s16++;
+
+		/* First, get the length for a BMP character */
+		clen = 1 + (c0 >= 0x80) + (c0 >= 0x800);
+		if (len + clen > maxlen)
+			break;
+		/*
+		 * If this is a high surrogate, and we're already at maxlen, we
+		 * can't include the character if it's a valid surrogate pair.
+		 * Avoid accessing one extra word just to check if it's valid
+		 * or not.
+		 */
+		if ((c0 & 0xfc00) == 0xd800) {
+			if (len + clen == maxlen)
+				break;
+			if ((*s16 & 0xfc00) == 0xdc00) {
+				++s16;
+				++clen;
+			}
+		}
+	}
+
+	return len;
+}
+
+/*
+ * Adapted from drivers/firmware/efi/libstub/vsprintf.c
+ */
+static void print_wstring(pstream_t *p, const u16 *s, strprops_t props)
+{
+	const u16 *ws = (const u16 *)s;
+	size_t pos = 0, size = p->remain + 1, len = utf16s_utf8nlen(ws, props.precision);
+
+	while (len-- > 0) {
+		u32 c32 = utf16_to_utf32(&ws);
+		u8 *s8;
+		size_t clen;
+
+		if (c32 < 0x80) {
+			addchar(p, c32);
+			continue;
+		}
+
+		/* Number of trailing octets */
+		clen = 1 + (c32 >= 0x800) + (c32 >= 0x10000);
+
+		len -= clen;
+		s8 = (u8 *)(p->buffer - p->added + pos);
+
+		/* Avoid writing partial character */
+		addchar(p, '\0');
+		pos += clen;
+		if (pos >= size)
+			continue;
+
+		/* Set high bits of leading octet */
+		*s8 = (0xf00 >> 1) >> clen;
+		/* Write trailing octets in reverse order */
+		for (s8 += clen; clen; --clen, c32 >>= 6)
+			*s8-- = 0x80 | (c32 & 0x3f);
+		/* Set low bits of leading octet */
+		*s8 |= c32;
+	}
+}
+
 static char digits[16] = "0123456789abcdef";
 
 static void print_int(pstream_t *ps, long long n, int base, strprops_t props)
@@ -305,7 +401,10 @@ morefmt:
 			print_unsigned(&s, (unsigned long)va_arg(args, void *), 16, props);
 			break;
 		case 's':
-			print_str(&s, va_arg(args, const char *), props);
+			if (nlong)
+				print_wstring(&s, va_arg(args, const u16 *), props);
+			else
+				print_str(&s, va_arg(args, const char *), props);
 			break;
 		default:
 			addchar(&s, f);
-- 
2.25.1

