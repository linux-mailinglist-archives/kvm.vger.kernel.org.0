Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0455A52F9C3
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 09:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbiEUHk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 03:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiEUHkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 03:40:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C4917D39F;
        Sat, 21 May 2022 00:40:19 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y41so9451809pfw.12;
        Sat, 21 May 2022 00:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yXgvzw1X7R3HihF3IFI7HYdhqndiCIe6AuxGQb67yKc=;
        b=ePPKvV82Kbx+Rtc5FoK/l+sEPohtrVvNDLK1QXehdRSaZnX8mpyqocpvwr2QsGdWJ5
         bLQ4ROLDowWcMCZ7CiGYtGgFFQgEdrFrGAvnoOGeKTLU9SETat+F4eINdzD1AjI1jP6q
         L/uJCTXtPvvvMc07rxyhgn2630pKyn8P9J5qJpKhJckR/mWyMWwWSogoQOrgxVYFoEPS
         jO/ucBwvw1bPtsZPzQCUP0q3axJvkQ609soFg7SljsJgNtGfwB9Xo3O43njj4LfEG09X
         8Pu1N9GP+SDyemv9PhvrmlBpb9r5nYPsWCLzx4roLuXNY318xpfnOeG1LxP44cVTMnqY
         waBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yXgvzw1X7R3HihF3IFI7HYdhqndiCIe6AuxGQb67yKc=;
        b=lVp4kAF7uDuZ8EiUc1yoLyAydBn4SLJJDa1zV3Sj3i/up2qZkm6/Yr+AghxSkq0hVT
         8clIEZM9958jY3iQ9W/02SNqtUI8RUeYoZGEB+MFfwI6sAEGTKrLZ/HGLOGhkf8nk8WG
         BA6M+FBmcuYreO65SUph0BDid7eEgGanH2Ll5aP284176+BLP9KyJ9ioskkQZ7rBGDMu
         ngyGxxwT18m4x6P86aTv9C9E8Fdyl2fD1d6XXcNWlPeMk9GmafK1+DJYA+ghOq9b10EJ
         x09hEFvMrY0Axf/sXHc7Jp1ahGddXXZrm7hNdX6gwp2NuEwv2PALSMh7uEgfPzTYwsLi
         aYSQ==
X-Gm-Message-State: AOAM532V/EXRachEh3IDIZ5h6vzO+DkXOfYVEMeRldlOwzPm77w8T+J9
        O40w5UrXTJt0Akg3ywn+m9E=
X-Google-Smtp-Source: ABdhPJxCSWMw/Pmp/yjU4TSydTB3KBQBSbZqHg12jWGmP+MTxJedaxk5xTCPwXKuglS2CpVMYqfUlQ==
X-Received: by 2002:a62:8349:0:b0:518:143e:235c with SMTP id h70-20020a628349000000b00518143e235cmr13565092pfe.82.1653118818520;
        Sat, 21 May 2022 00:40:18 -0700 (PDT)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id e9-20020a654789000000b003ed6b3dc52esm887826pgs.55.2022.05.21.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 00:40:17 -0700 (PDT)
Date:   Sat, 21 May 2022 00:38:05 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
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
Message-ID: <YoiW3R0nsC71hlFm@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-4-yury.norov@gmail.com>
 <20220519150929.GA3145933@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519150929.GA3145933@roeck-us.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 08:09:29AM -0700, Guenter Roeck wrote:
> On Thu, Apr 28, 2022 at 01:51:14PM -0700, Yury Norov wrote:
> > Test newly added bitmap_{from,to}_arr64() functions similarly to
> > already existing bitmap_{from,to}_arr32() tests.
> > 
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> 
> With this patch in linux-next (including next-20220519), I see lots of
> bitmap test errors when booting 32-bit ppc images in qemu. Examples:
> 
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0", got "0,65"
> ...
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-129"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65", got "0,65,128-130"
> ...
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-209"
> test_bitmap: [lib/test_bitmap.c:600] bitmaps contents differ: expected "0,65,128-143", got "0,65,128-143,208-210"
> 
> and so on. It only  gets worse from there, and ends with:
> 
> test_bitmap: parselist: 14: input is '0-2047:128/256' OK, Time: 4274
> test_bitmap: bitmap_print_to_pagebuf: input is '0-32767
> ', Time: 127267
> test_bitmap: failed 337 out of 3801 tests
> 
> Other architectures and 64-bit ppc builds seem to be fine. 

So, the problem is in previous patch. I'll fold-in the following fix
into that if no objections.

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 52b9912a71ea..97c14845f452 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1585,7 +1585,7 @@ void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)

        /* Clear tail bits in the last element of array beyond nbits. */
        if (nbits % 64)
-               buf[-1] &= GENMASK_ULL(nbits, 0);
+               buf[-1] &= GENMASK_ULL(nbits % 64, 0);
 }
 EXPORT_SYMBOL(bitmap_to_arr64);
 #endif

