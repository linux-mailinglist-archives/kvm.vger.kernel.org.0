Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1B513CEC
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351948AbiD1Uyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351947AbiD1Uyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:40 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BCEC0E56;
        Thu, 28 Apr 2022 13:51:23 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c1so4517345qkf.13;
        Thu, 28 Apr 2022 13:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zpgfCNwBAsrogBT5FIwlctJ6I9aylyUTQSQGzBNw7UE=;
        b=YxOSNBL6nSIQ7v7mCasMnn/bP6CMqLNJ8WGk4NxtWHnECZmVKW/DgP4i98vJ3KhOzH
         9awvJHK2cHlol65shu0uCVDrKeyX28DXB0fq7Sb0oDN6W5hSwZc7HaGufr0fMWkKBys4
         ufSsEWkRPbvp7ZeYw1lSx2YmZlyMvMyhiqzqefoZALTPEeKYUM25zfTfKMUjK0udvXOL
         LRtye+pc1zTsExCmyKZylIEMzpgE/HdRvTwtwoQGCMsTDGwgu5CLXdutn/5wQuFC5n7m
         ybI27bT7GLwpv04qt5gkGdCJMcVrY+EbfqfCkZv9Rx9YOvUyjOEOqLbF2UDRqZ6kjAOl
         8dzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zpgfCNwBAsrogBT5FIwlctJ6I9aylyUTQSQGzBNw7UE=;
        b=CgzPzLUGTHE61QpeIJZpLddydPRW0UG24oteBpr0hFOiNCdM6iK7YVdRY9XEBbDy3z
         2wANW7aCCvF0VE2hEXlv43mW65js0I74x4FZguvmgli1zpAd/SdyNRhyakiny5Ck3gH/
         NbEcXJoZ+wiwR4MLKgK9wXDxe+eWz/qF/OYOKkKugys7UT2SLYsHc441w2UIEbJb9VO/
         9ntrtQyMybj279MYIsxwwyi0cAA0Yjk079t3M+AUkwiKrcCUKs07RMkrHm+EhWEiXaEA
         oFGz3XKCB/aJxSYCxt4/uidjbTVF//Gw+kDpRDnzaqA9lz1HNDEK2t8kRJThi+e0Kayj
         vk7A==
X-Gm-Message-State: AOAM533aw9m6EmRg+O1cwmv0GFLlzdg+s+Da9BgmRtpiM/Jmw3J8DiTL
        cZNRhyI5w54eCKDx70nX3s/o+1JP1Bk=
X-Google-Smtp-Source: ABdhPJxVUW2mvkjQPeXy8dWRrYoJYUaXbEW9WhlX3Vu7KwtIimgwuoFC8gZ/3PiSVGf7kDcuUDT21Q==
X-Received: by 2002:ae9:e317:0:b0:69f:b249:6beb with SMTP id v23-20020ae9e317000000b0069fb2496bebmr1900711qkf.14.1651179082224;
        Thu, 28 Apr 2022 13:51:22 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id m190-20020a378ac7000000b0069f8d810f16sm465776qkd.85.2022.04.28.13.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:21 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/5] lib: add bitmap_{from,to}_arr64
Date:   Thu, 28 Apr 2022 13:51:13 -0700
Message-Id: <20220428205116.861003-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220428205116.861003-1-yury.norov@gmail.com>
References: <20220428205116.861003-1-yury.norov@gmail.com>
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

Manipulating 64-bit arrays with bitmap functions is potentially dangerous
because on 32-bit BE machines the order of halfwords doesn't match.
Another issue is that compiler may throw a warning about out-of-boundary
access.

This patch adds bitmap_{from,to}_arr64 functions in addition to existing
bitmap_{from,to}_arr32.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 23 ++++++++++++++++----
 lib/bitmap.c           | 48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index dbdf1685debf..57f1c74239d5 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -292,6 +292,24 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 			(const unsigned long *) (bitmap), (nbits))
 #endif
 
+/*
+ * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
+ * machines the order of hi and lo parts of numbers match the bitmap structure.
+ * In both cases conversion is not needed when copying data from/to arrays of
+ * u64.
+ */
+#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
+void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
+#else
+#define bitmap_from_arr64(bitmap, buf, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
+			(const unsigned long *) (buf), (nbits))
+#define bitmap_to_arr64(buf, bitmap, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (buf),		\
+			(const unsigned long *) (bitmap), (nbits))
+#endif
+
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
@@ -601,10 +619,7 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
  */
 static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
 {
-	dst[0] = mask & ULONG_MAX;
-
-	if (sizeof(mask) > sizeof(unsigned long))
-		dst[1] = mask >> 32;
+	bitmap_from_arr64(dst, &mask, 64);
 }
 
 /**
diff --git a/lib/bitmap.c b/lib/bitmap.c
index d9a4480af5b9..027b63a655fd 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1533,5 +1533,53 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
 }
 EXPORT_SYMBOL(bitmap_to_arr32);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+/**
+ * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
+ *	@bitmap: array of unsigned longs, the destination bitmap
+ *	@buf: array of u64 (in host byte order), the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits)
+{
+	int n;
+
+	for (n = nbits; n > 0; n -= 64) {
+		u64 val = *buf++;
+
+		*bitmap++ = val;
+		if (n > 32)
+			*bitmap++ = val >> 32;
+	}
+
+	/* Clear tail bits in last word beyond nbits. */
+	if (nbits % BITS_PER_LONG)
+		bitmap[-1] &= BITMAP_LAST_WORD_MASK(nbits);
+}
+EXPORT_SYMBOL(bitmap_from_arr64);
+
+/**
+ * bitmap_to_arr64 - copy the contents of bitmap to a u64 array of bits
+ *	@buf: array of u64 (in host byte order), the dest bitmap
+ *	@bitmap: array of unsigned longs, the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
+{
+	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
+
+	while (bitmap < end) {
+		*buf = *bitmap++;
+		if (bitmap < end)
+			*buf |= (u64)(*bitmap++) << 32;
+		buf++;
+	}
 
+	/* Clear tail bits in last element of array beyond nbits. */
+	if (nbits % 64)
+		buf[-1] &= GENMASK_ULL(nbits, 0);
+}
+EXPORT_SYMBOL(bitmap_to_arr64);
 #endif
-- 
2.32.0

