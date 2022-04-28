Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A4F513CE2
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351942AbiD1Uyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351520AbiD1Uyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:37 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F616E8E3;
        Thu, 28 Apr 2022 13:51:22 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id x77so3772341qkb.3;
        Thu, 28 Apr 2022 13:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sQKHNYNSaa8eVu3kbpnXB5Rjl+Crzx3Drn4KGQNwqro=;
        b=qpGoiNXe750pj7oN+UmBJziCkqdcVG5QXlsSYEfZFqiFPKdxAncuQ4qzZl+C1dK3vF
         +fnIWbtzzm8KXD1pXswEiFqVlxDmBO6OPTvX/kSkDYvnMiTNm/Rx4i6KuC3HcWXgSqlZ
         WXhzPizIOkK4Eq7xh7ZZe1yOqpEDRckCZH/U2eYn1qnkZSSZL0jAMe27S0wOc4FBqC4R
         tVpDoRZn9VD3P1AiuPm0pSoeNk/sfdbExZrX+8hXTcWgEWN/Ot3abFTBzWOVt4Yqe2rM
         hjrPlSqiBhEoF7WTdlP6isicxlsh6/fQ3uBjs+6aVas41uwjPzSBt1OtYQLw1unHJVMF
         jGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sQKHNYNSaa8eVu3kbpnXB5Rjl+Crzx3Drn4KGQNwqro=;
        b=7TDSOnvfu9wVk8uR0u8+hflBqDRCqZVs38KiKvKkse533yWqo0r/9L3WEbhbPr4scm
         HGzCrxl1zdiRAn1L/d+uGHM4Z/E4SbOQGi+ZypYYzzManSRA1EaFwbIiLRNyLnQUGfaA
         eVVWydGXPagbeY2TF4v/WVQ1Os7N9qiYz1Z6ARv2omBfD9Hc4iXfHuGq3z4K+qLTr9Ag
         EQTy5vwJxh4gHJ+K1sezHBjiwIf5eiYBh/M1gw26CJsT7OGlR3k6cdCYDvOhzZCtdn0h
         qF+8FyxnOnRu2Q++42q/kq5BZj9TzA2yRLfopyvnU5V1UUOot15uWoBfv9jO8nlp39y6
         +a4g==
X-Gm-Message-State: AOAM532pzMJaO/PaGqERByCoZBXp5rtBCNUfu6APpMGXH4EkqmJp5FXh
        TYpzwQx6rzd1Ks7hEcxksTRfmwSpF3Y=
X-Google-Smtp-Source: ABdhPJwHrUtpAiCOeYV3C40ju4BgJ7ox7zRmhHOgb1AqO0tv76fMXO6QVzbYQRclVAeod2a8jIjeLw==
X-Received: by 2002:a05:620a:459f:b0:69f:6a25:f054 with SMTP id bp31-20020a05620a459f00b0069f6a25f054mr12085962qkb.560.1651179081004;
        Thu, 28 Apr 2022 13:51:21 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id h5-20020a05622a170500b002f3818c7b92sm549709qtk.49.2022.04.28.13.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:20 -0700 (PDT)
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
Subject: [PATCH 1/5] lib/bitmap: extend comment for bitmap_(from,to)_arr32()
Date:   Thu, 28 Apr 2022 13:51:12 -0700
Message-Id: <20220428205116.861003-2-yury.norov@gmail.com>
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

On LE systems bitmaps are naturally ordered, therefore we can potentially
use bitmap_copy routines when converting from 32-bit arrays, even if host
system is 64-bit. But it may lead to out-of-bond access due to unsafe
typecast, and the bitmap_(from,to)_arr32 comment doesn't explain that
clearly

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 983dc3f2d57b..dbdf1685debf 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -271,8 +271,12 @@ static inline void bitmap_copy_clear_tail(unsigned long *dst,
 }
 
 /*
- * On 32-bit systems bitmaps are represented as u32 arrays internally, and
- * therefore conversion is not needed when copying data from/to arrays of u32.
+ * On 32-bit systems bitmaps are represented as u32 arrays internally. On LE64
+ * machines the order of hi and lo parts of numbers match the bitmap structure.
+ * In both cases conversion is not needed when copying data from/to arrays of
+ * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead
+ * to out-of-bound access. To avoid that, both LE and BE variants of 64-bit
+ * architectures are not using bitmap_copy_clear_tail().
  */
 #if BITS_PER_LONG == 64
 void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
-- 
2.32.0

