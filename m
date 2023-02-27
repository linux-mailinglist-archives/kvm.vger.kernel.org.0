Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B26D6A4D7E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjB0Vpg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjB0Vpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:45:34 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842141BAEE;
        Mon, 27 Feb 2023 13:45:31 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id v1-20020a9d6041000000b0068d4a8a8d2dso4393520otj.12;
        Mon, 27 Feb 2023 13:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfkr/Dz64psO49jb2sCIBi5L9nMCTcssTUOvBykXPRI=;
        b=osPgSKZIbWUPkX1P6DGPStyaykfwRRNQLUanbiOzRTVtfAGgGoCmk0qW1/ogsWl/C3
         nM1RfW8sEe3wIIcCn5RPFCZEL9usYO4wi3Q9ZQCGR8JDMCLsUH0a8bpTgdYj2XKaWrVC
         7I4tXl8nOPXwEdQqM95zfA0hEFY4rWYvheusgUuQQRBTJ56NoYVKOByTzYt0fwF76GbK
         dfEZDHj6yL1A4WJsUzRKyq0B+h8ZXfusKhL9kGWIaBLam3J7p8LRU2So6FbfUEVvBMPM
         jLIVIzCIAN8pu66WoA9I8vtCsQc9ChImXVWV6Qi8/Y0rdZeNB9iNYCQwUO/fq4wqgUVM
         aUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfkr/Dz64psO49jb2sCIBi5L9nMCTcssTUOvBykXPRI=;
        b=DP/b9jnCQaElRDQt3LNq8n8GDANU+uRnVTKHMzBoAgxqwYvPsvPspg1gBN3rebDnSw
         LwEmJxVY0uiYs5ZrzOjjpUw1aE0K928knaChS4cqAQB2FXRvRPNzOgRKSKbYXqRtdJjN
         C0a97xJ9i1ecDajgJbk8NLF1/p5NaJ1erue8TZNcE8F3MHrWw/Fr7wiiC5OPC0yxGM+X
         xCxa+GuK4QGkwkqDtd3CCBLOMVYmg7Qk2/xvw/HrtVTU/5urPv465EqPYhWo58jwI5To
         vNNcmtgmkYeHKQ2kIQrfx+Q5xpMlIA6jYjZCUhokv1ey+nbGvuAkO8GwMa4f12pIMTbX
         9GSg==
X-Gm-Message-State: AO0yUKWSXcKI8JInMWYEl73BoF9H5ouKgawV7Mnt7Lvgp8Aw+mBQCxMz
        3VCEma/9rl7jRhu/Htf8UAPZ12M6DgU=
X-Google-Smtp-Source: AK7set/gCu6d0ZKgwZbN/D4iSrNnH4erq2Uz6ro8buqv2WpMpkbspRDKy8GVV1SdvXPhjoF/xmMH8w==
X-Received: by 2002:a05:6830:601b:b0:693:d7bf:dbe8 with SMTP id bx27-20020a056830601b00b00693d7bfdbe8mr5279912otb.10.1677534330410;
        Mon, 27 Feb 2023 13:45:30 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id m17-20020a4add11000000b00524faf3d2d7sm2102658oou.41.2023.02.27.13.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:45:29 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/2] lib/bitmap: drop optimization of bitmap_{from,to}_arr64
Date:   Mon, 27 Feb 2023 13:45:24 -0800
Message-Id: <20230227214524.914050-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230227214524.914050-1-yury.norov@gmail.com>
References: <20230227214524.914050-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
architectures when it's wired to bitmap_copy_clear_tail().

bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
the next word boundary. But on 32-bit machines when copying bits from
bitmap to array of 64-bit words, it's expected that the unused part of
a recipient array must be cleared up to 64-bit boundary, so the last 4
bytes may stay untouched when nbits % 64 <= 32.

While the copying part of the optimization works correct, that clear-tail
trick makes corresponding tests reasonably fail:

test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)

Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
arches.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/lkml/20230225184702.GA3587246@roeck-us.net/
Fixes: 0a97953fd221 ("lib: add bitmap_{from,to}_arr64")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/bitmap.h | 8 +++-----
 lib/bitmap.c           | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 40e53a2ecc0d..7d4c90eb3df4 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -302,12 +302,10 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 #endif
 
 /*
- * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
- * machines the order of hi and lo parts of numbers match the bitmap structure.
- * In both cases conversion is not needed when copying data from/to arrays of
- * u64.
+ * On 64-bit systems bitmaps are represented as u64 arrays internally. So,
+ * the conversion is not needed when copying data from/to arrays of u64.
  */
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+#if BITS_PER_LONG == 32
 void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
 void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
 #else
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1c81413c51f8..ddb31015e38a 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1495,7 +1495,7 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 EXPORT_SYMBOL(bitmap_to_arr32);
 #endif
 
-#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+#if BITS_PER_LONG == 32
 /**
  * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
  *	@bitmap: array of unsigned longs, the destination bitmap
-- 
2.34.1

