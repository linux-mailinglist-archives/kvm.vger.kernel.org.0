Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35F65092BB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382791AbiDTW2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382779AbiDTW21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:28:27 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ABE40E70;
        Wed, 20 Apr 2022 15:25:32 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id x20so2410392qvl.10;
        Wed, 20 Apr 2022 15:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0aCn71l79sWRnE6PzUFhlzrvw/Z81bCS4EyB61dWEL0=;
        b=BeT9QhYpFDK/CREoEjtw3QLmD+QNTZYuSZtoOHzOZeF9Wk/6j2V2H3kA3wL4UYGuWk
         bStsY3ZHW3fS86+/Qp4uKXdOHItAD8ztT8NsEfukqkzFoAfgcOUgd8yUM/nDHnF4sklJ
         dd6QdPuIkebTGaheYNDy0f/odnNV+3d7kYB8XcetsILmO7TE8+NomUZDVgQl64wBbJf/
         mbVLw/7/pX+8Dp52EgtlUHsndFzWYaOF/ijzguYNdcuGEeh12jdHmoJ/N1X0f+mzK33N
         O5k3n+n4mMqME0y1UH9WUXDcYro2Drz38nXYidMQhdGlFfmvQMttCXCbAA5q4kt0hGho
         cesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aCn71l79sWRnE6PzUFhlzrvw/Z81bCS4EyB61dWEL0=;
        b=KQgoCrvHO/U93ut8PIUrUXW+F+L7GF7FMeU5NgD80kWhphjMgbGU8TTF6jkJCswGxZ
         nwchzNYw5JYNT8u5gLTH58qfu9DwknPQ4lKP7GOIlDHNX9kt0ahxFWFThSXJbzF6hm+K
         YsYSd0iKNi/SaUb2vVThGih1UKEyLkJUk6QzY0jRfDXS5ePU5SsJwzyoL9sg3veElUn3
         l+TG4m01XgbD+VSa1rUPPAYEGwfTTRQkPhn+yAqMReRV7bmhzU5Ly6VxuLfYAZt3MFN9
         n5YqCiy/k7k4lPu5EKa35wJvcRK7iejrs2CUR1zTh+pYsRBL3bPWwFynsKpaeJsS3kjb
         t2zw==
X-Gm-Message-State: AOAM532vFpdoTJJtLPAy4/NSSDihy1lSReVyABVnGVH07SJ5WlwFPxkz
        NUygIyla/TvwDBiYwXqr2axde2fOeeQ=
X-Google-Smtp-Source: ABdhPJzKjiKgZgtEl0vYGkFkHYaxfwEQ6T08SLZ3cvCfSIFo6Vw62fRxM9StAFAMUIujrWHH+gVNUA==
X-Received: by 2002:ad4:58c9:0:b0:444:4bb4:651a with SMTP id dh9-20020ad458c9000000b004444bb4651amr16938759qvb.49.1650493531208;
        Wed, 20 Apr 2022 15:25:31 -0700 (PDT)
Received: from localhost ([2601:c4:c432:60a:188a:94a5:4e52:4f76])
        by smtp.gmail.com with ESMTPSA id w6-20020a05622a190600b002f1f91ad3e7sm2539168qtc.22.2022.04.20.15.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:25:30 -0700 (PDT)
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
Subject: [PATCH 1/4] lib/bitmap: extend comment for bitmap_(from,to)_arr32()
Date:   Wed, 20 Apr 2022 15:25:27 -0700
Message-Id: <20220420222530.910125-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220420222530.910125-1-yury.norov@gmail.com>
References: <20220420222530.910125-1-yury.norov@gmail.com>
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
clearly.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index a89b626d0fbe..10d805c2893c 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -271,8 +271,12 @@ static inline void bitmap_copy_clear_tail(unsigned long *dst,
 }
 
 /*
- * On 32-bit systems bitmaps are represented as u32 arrays internally, and
- * therefore conversion is not needed when copying data from/to arrays of u32.
+ * On 32-bit systems bitmaps are represented as u32 arrays internally. On LE64
+ * machines the order of hi and lo parts of nubmers match the bitmap structure.
+ * In both cases conversion is not needed when copying data from/to arrays of
+ * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead to the
+ * out-of-bound access. To avoid that, both LE and BE variants of 64-bit
+ * architectures are not using bitmap_copy_clear_tail().
  */
 #if BITS_PER_LONG == 64
 void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
-- 
2.32.0

