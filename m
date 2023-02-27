Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263846A4AC8
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 20:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjB0TYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 14:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0TYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 14:24:38 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FE81ADE0;
        Mon, 27 Feb 2023 11:24:37 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id e12-20020a4ae0cc000000b00525034ca5e9so1179986oot.0;
        Mon, 27 Feb 2023 11:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OYi4D56fLFAcp+E2w9iavlNCyepBuSBHm3EJC6EjxUM=;
        b=jp3Iq0qX64RUn1eqPAsL63InclK/VDRgzPVh8LjhRsAUZZYfIZFQQJVap7Jncdbe5Y
         1IBYI6npVMXH30FQHuZvNh3bgpjxStRb8swapkt39slyxKYzql+gfXCoIcsmXglOwIPo
         /n6xM9eRr8DKFE9wnllXbdIJ0044zb+1XM+fCoY8SO8GEs3vuWNVi1aybLbU9RvtteVg
         JZytuNwZaqKVDGlpgsubZOOkkquqgLN3+SaP72lIi9l2mzikjLOuhBKmzZYBY5MDWSoi
         rR885eAtSH4rsx94FfYknNN5VhEwsn314rmEq6JNTpYpVcGaBr4ycScEqpex8YOSU9kX
         MvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYi4D56fLFAcp+E2w9iavlNCyepBuSBHm3EJC6EjxUM=;
        b=n4T8WWYVQp+263IKQGiiSBknLfIPsMRlUfBGDC1pVcoK1IOQkq/rYz7IrVUwGFBiiD
         ALXyjm/Ivj40wptWtGIiLBordtCB/Vas+7Hwibw8tVAfWfDZRkYMyyX588IaWzNLZ/hL
         9Yr7Kl1qirLLmjXpdWZSrS/Sdf+AtHDy1VhFH4SPXBbruY8f8cmnvl+cJcCjMqf91YNl
         ultu92gE8BaAbBxPasFXHne368zkExsrtnFBHkHc5VP96omX4DCQzJR1WiZEl2vAYHo8
         CNKoVgFf/bKAoW3eo/2OAU+IJSIQ0wcE65Z899fLzieKOatcuV5QA9q3NfTrUIxpEVsR
         eGnA==
X-Gm-Message-State: AO0yUKXd+kH69F6g2mAAvWbxuUfea2kvneHuyA/91Ql8O3ImJ53XrJvu
        HtPaSt50hM2tfzKNWZCI5l8=
X-Google-Smtp-Source: AK7set/7HxEqLiFg62ktKhMqg2ZASIB55eWr5PN3v12WPb33YrNjI+Gk+K37ug65NjhqA6BhCYm3vQ==
X-Received: by 2002:a05:6820:1388:b0:51a:c9a:ee79 with SMTP id i8-20020a056820138800b0051a0c9aee79mr5373604oow.2.1677525876418;
        Mon, 27 Feb 2023 11:24:36 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id h9-20020a4aa289000000b005253a5cc3cfsm2946595ool.29.2023.02.27.11.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 11:24:35 -0800 (PST)
Date:   Mon, 27 Feb 2023 11:24:34 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/5] lib/bitmap: add test for bitmap_{from,to}_arr64
Message-ID: <Y/0DcqXBDvp7tv0r@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20230225184702.GA3587246@roeck-us.net>
 <Y/qhL8kSzzhMm+tO@yury-laptop>
 <Y/qilU0cW6ebmrnM@yury-laptop>
 <95377047-6b26-b434-fc90-2289fccc2a0b@intel.com>
 <19587ea3-e54c-e3b0-5341-eb7ee486474b@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19587ea3-e54c-e3b0-5341-eb7ee486474b@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 06:59:12AM -0800, Guenter Roeck wrote:
> On 2/27/23 06:46, Alexander Lobakin wrote:
> > From: Yury Norov <yury.norov@gmail.com>
> > Date: Sat, 25 Feb 2023 16:06:45 -0800
> > 
> > > On Sat, Feb 25, 2023 at 04:05:02PM -0800, Yury Norov wrote:
> > > > On Sat, Feb 25, 2023 at 10:47:02AM -0800, Guenter Roeck wrote:
> > > > > Hi,
> > > > > 
> > > > > On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > > > > > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > > > > > already existing bitmap_{from,to}_arr32() tests.
> > > > > > 
> > > > > > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > > > > 
> > > > > Ever since this test is in the tree, several of my boot tests show
> > > > > lots of messages such as
> > > > > 
> > > > > test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)
> > 
> > Hmmm, the whole 4 bytes weren't touched.
> > 
> > > > > test_bitmap: bitmap_to_arr64(nbits == 2): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000003)
> > > > > test_bitmap: bitmap_to_arr64(nbits == 3): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000007)
> > 
> > This is where it gets worse...
> > 
> > > > > ...
> > > > > test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)
> > > > > test_bitmap: bitmap_to_arr64(nbits == 928): tail is not safely cleared: 0xa5a5a5a580000000 (must be 0x00000000ffffffff)
> > 
> > I don't see the pattern how the actual result gets generated. But the
> > problem is in the bitmap code rather than in the subtest -- "must be"s
> > are fully correct.
> > 
> > Given that the 0xa5s are present in the upper 32 bits, it is Big Endian
> > I guess? Maybe even 32-bit Big Endian? Otherwise I'd start concerning
> > how comes it doesn't reproduce on x86_64s :D
> > 
> 
> It does reproduce on 32-bit x86 builds, and as far as I can see
> it is only seen with 32-bit little endian systems.

Hi Guenter, Alexander,

I think that the reason for the failures like this:

> test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)

is that bitmap_to_arr64 is overly optimized for 32-bit LE architectures.

Regarding this:

> test_bitmap: bitmap_to_arr64(nbits == 927): tail is not safely cleared: 0xa5a5a5a500000000 (must be 0x000000007fffffff)

I am not sure what happens, but because this again happens on 32-bit
LE only, I hope the following fix would help too.

Can you please check if the patch works for you? I don't have a 32-bit LE
machine in hand, and all my 32-bit VMs (arm and i386) refuse to load the
latest kernels for some weird reason, so it's only build-tested.

I'll give it a full-run when restore my 32-bit setups.

Thanks,
Yury

From 2881714db497aed103e310865da075e7b0ce7e1a Mon Sep 17 00:00:00 2001
From: Yury Norov <yury.norov@gmail.com>
Date: Mon, 27 Feb 2023 09:21:59 -0800
Subject: [PATCH] lib/bitmap: drop optimization of bitmap_{from,to}_arr64

bitmap_{from,to}_arr64() optimization is overly optimistic on 32-bit LE
architectures when it's wired to bitmap_copy_clear_tail().

bitmap_copy_clear_tail() takes care of unused bits in the bitmap up to
the next word boundary. But on 32-bit machines when copying bits from
bitmap to array of 64-bit words, it's expected that the unused part of
a recipient array must be cleared up to 64-bit boundary, so the last 4
bytes may stay untouched.

While the copying part of the optimization works correct, that clear-tail
trick makes corresponding tests reasonably fail when nbits % 64 <= 32:

test_bitmap: bitmap_to_arr64(nbits == 1): tail is not safely cleared: 0xa5a5a5a500000001 (must be 0x0000000000000001)

Fix it by removing bitmap_{from,to}_arr64() optimization for 32-bit LE
arches.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 0a97953fd2210 ("lib: add bitmap_{from,to}_arr64")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 8 +++-----
 lib/bitmap.c           | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 40e53a2ecc0d..5abc993903fb 100644
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
+ * conversion is not needed when copying data from/to arrays of u64.
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

