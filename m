Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED725513CEE
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352009AbiD1Uyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351949AbiD1Uyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:40 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A9FC0E5B;
        Thu, 28 Apr 2022 13:51:24 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id e128so4539075qkd.7;
        Thu, 28 Apr 2022 13:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1EpAoNh3djiR0hepuMZWh5K1dw4NUP6DaD4hagEgG3I=;
        b=f0Z5dX7wbl0R92CisFojyWE8K6d/92OfvlFaiM4rI3zIxB5QCKji7UaeMDC0t4yZQm
         aikCalRWglJhYnECZgsmp2vVjMNf7pvH/1P6OIgFcJynEQTRsg+Ysmz5ePKgLkwGXQtv
         aBn5NFDhHfffiGtIKiX9W8bb7QrCc0tLvbagvulxDyJrnoVVS3QU/NcLk/nplpXf7Vwy
         SgmR6hZulUr7Xu8zxii1h1hFau4ctQCbELlTGxSbEGJg4MVe7yNm2GTKJdpLgQfRvQMC
         w6DIL0w4Z0FlEZMtkeq6GTt5Mb8nGIUycBHj7rqt1GKpqWiYBRAP8R06GIyp4DCn8yje
         J08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EpAoNh3djiR0hepuMZWh5K1dw4NUP6DaD4hagEgG3I=;
        b=jz6wjKrMfFcTV6a8neDjuQs9JTFLPwCvKsrmHBzABMl8w9UvZuIONSvZReqZ0S65fT
         lcWTcmPOdW/gApar3W3OtOFZoi48wPCiWDWAEhHRvhmFrfarqh9Q8ogRQdlqBV8dGKpy
         C9ZJYCXAJ+sBrziiJpJzEndcfz79ZicyaK2MOumtjcwr6AtRt8WD98+pOGoDgZQ14/wb
         qpyxstYsHMBHasmmFsWXnnJOVQD0B3rl8UA/S58E4EuVlT6ODLc4dLb67C6wAvfaoKnN
         7uMBn14Lh0Pogx4l+PfyHOKDXlfj1zGuzkGYm1IVSfzqMfA5QRNBGbMHKRw+8UeslKuy
         puZg==
X-Gm-Message-State: AOAM530vo2uzv/I/rPdHpzAlf1nSGLeCwHtKd6VFo7gpEXp4+WTnN5TU
        x6KtPd/YvFy1bqE/4Lev7ClTtIX0D6w=
X-Google-Smtp-Source: ABdhPJxXLTFxVkZ3KgwG5707+YbXl4dlJCsL8/vtRybqZmkDB4puHhN7Wh7fO6njap7k2zXxkTsQpQ==
X-Received: by 2002:a05:620a:2715:b0:69f:9e98:7501 with SMTP id b21-20020a05620a271500b0069f9e987501mr3591382qkp.346.1651179083615;
        Thu, 28 Apr 2022 13:51:23 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id g10-20020ac8580a000000b002f35323f82csm613818qtg.30.2022.04.28.13.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:23 -0700 (PDT)
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
Subject: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Date:   Thu, 28 Apr 2022 13:51:14 -0700
Message-Id: <20220428205116.861003-4-yury.norov@gmail.com>
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

Test newly added bitmap_{from,to}_arr64() functions similarly to
already existing bitmap_{from,to}_arr32() tests.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/test_bitmap.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index 0c82f07f74fc..d5923a640457 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -585,6 +585,30 @@ static void __init test_bitmap_arr32(void)
 	}
 }
 
+static void __init test_bitmap_arr64(void)
+{
+	unsigned int nbits, next_bit;
+	u64 arr[EXP1_IN_BITS / 64];
+	DECLARE_BITMAP(bmap2, EXP1_IN_BITS);
+
+	memset(arr, 0xa5, sizeof(arr));
+
+	for (nbits = 0; nbits < EXP1_IN_BITS; ++nbits) {
+		memset(bmap2, 0xff, sizeof(arr));
+		bitmap_to_arr64(arr, exp1, nbits);
+		bitmap_from_arr64(bmap2, arr, nbits);
+		expect_eq_bitmap(bmap2, exp1, nbits);
+
+		next_bit = find_next_bit(bmap2, round_up(nbits, BITS_PER_LONG), nbits);
+		if (next_bit < round_up(nbits, BITS_PER_LONG))
+			pr_err("bitmap_copy_arr64(nbits == %d:"
+				" tail is not safely cleared: %d\n", nbits, next_bit);
+
+		if (nbits < EXP1_IN_BITS - 64)
+			expect_eq_uint(arr[DIV_ROUND_UP(nbits, 64)], 0xa5a5a5a5);
+	}
+}
+
 static void noinline __init test_mem_optimisations(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
@@ -852,6 +876,7 @@ static void __init selftest(void)
 	test_copy();
 	test_replace();
 	test_bitmap_arr32();
+	test_bitmap_arr64();
 	test_bitmap_parse();
 	test_bitmap_parselist();
 	test_bitmap_printlist();
-- 
2.32.0

