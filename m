Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A399C50A5A0
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiDUQfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiDUQey (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:34:54 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EFA24F11;
        Thu, 21 Apr 2022 09:31:42 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id d9so4071963qvm.4;
        Thu, 21 Apr 2022 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h+Iup4njVxXKcc942qQUo3kTQIMU1IrelCicFZt8H58=;
        b=qXqWNGCtLcuApxBn75B7spLD80sfE0o3XmdCfO5hcKbzQ9m7+OzzdSAdY+ZrPd/BIK
         cX70uPnztwq6UiTRex0s9LpYWQ1cUFW4JVNmlee2KzEYMOW7iiDSC/bBaF1cdgdAKBma
         iUBIwR9mYO4piEWbTq17y6JMusUZmRSOrOyU+fLbjMmFxS0y2QDbgAerQ4GaebnHAgGg
         Y4N67RrkAUxacWJ0kpeVWX7QTJwESOHB1GlPqKUkt7JmKZFFgKbZjjvFFyJ6lhqsqMyp
         TSekYTzNRnpg2IiVLZWyySgMJKkAhenX9nQnTy/RBNH7bTbFVcz79F/aVQ4UhKt/1mc3
         g5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h+Iup4njVxXKcc942qQUo3kTQIMU1IrelCicFZt8H58=;
        b=3OPJqKt/ruAGLwXUGNvPWbR/JiYn+MR7yTIW+oL4jbr3tcA1+8w39pabPPvZMg5dGo
         XP6r/WkDrY4LYYU2gphMt87eNs/16SVj35KRKH3R6Ov/rQXM8XU3yAeLd088L47TJdvm
         bKT7jZBionBkSBEVW9TuYA3ta2+JEBM19coSRs6mDlnHZIWV6eKcoo+eK9ZhTsD1LzDg
         iGZ4R5PwUZglna3NQHkhHuga20sdVgOxZNi5sCt8+UDOkh8GZfJqKBL+2uLOzeVHhT6K
         Bqr1W+aOl6upGApFotw5O5LRXpgy38RfyzBAZ7JE+mRnX2Ns3Xa+SihDLvzxiUWjAVvD
         yD3A==
X-Gm-Message-State: AOAM533UtDEEVe24m1mJwlHWgHV+Sh0Ua1SdOSyCbLAVGX9Fw+6aA8m6
        VOCOBaY0FvkZCOPGvAH6I8k=
X-Google-Smtp-Source: ABdhPJxgc7BbaOgIAf41NINgcHWA+Dath4sa22/rSqvTcy3+tzZUFEhoa8mjkyTwe4GgihVQhBl3nQ==
X-Received: by 2002:a05:6214:1ccd:b0:443:652e:69d with SMTP id g13-20020a0562141ccd00b00443652e069dmr246858qvd.114.1650558700080;
        Thu, 21 Apr 2022 09:31:40 -0700 (PDT)
Received: from localhost ([2601:c4:c432:7a1:dbb0:23b:8a79:595c])
        by smtp.gmail.com with ESMTPSA id u11-20020a05622a14cb00b002e1fd9dce3dsm3693978qtx.60.2022.04.21.09.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 09:31:39 -0700 (PDT)
Date:   Thu, 21 Apr 2022 09:31:38 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] lib: add bitmap_{from,to}_arr64
Message-ID: <YmGG6gcKl8Ft7LTI@yury-laptop>
References: <20220420222530.910125-1-yury.norov@gmail.com>
 <20220420222530.910125-3-yury.norov@gmail.com>
 <b7fe319a66914a9e88d2830101e6319f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7fe319a66914a9e88d2830101e6319f@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 07:40:25AM +0000, David Laight wrote:
> From: Yury Norov
> > Sent: 20 April 2022 23:25
> > 
> > Manipulating 64-bit arrays with bitmap functions is potentially dangerous
> > because on 32-bit BE machines the order of halfwords doesn't match. Another
> > issue is that compiler may throw a warning about out-of-boundary access.
> > 
> > This patch adds bitmap_{from,to}_arr64 functions in addition to existing
> > bitmap_{from,to}_arr32.
> > 
> > Signed-off-by: Yury Norov <yury.norov@gmail.com>
> > ---
> >  include/linux/bitmap.h | 23 +++++++++++++++++----
> >  lib/bitmap.c           | 47 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 66 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> > index 10d805c2893c..f78c534fb814 100644
> > --- a/include/linux/bitmap.h
> > +++ b/include/linux/bitmap.h
> > @@ -292,6 +292,24 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
> >  			(const unsigned long *) (bitmap), (nbits))
> >  #endif
> > 
> > +/*
> > + * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
> > + * machines the order of hi and lo parts of nubmers match the bitmap structure.
> > + * In both cases conversion is not needed when copying data from/to arrays of
> > + * u64.
> > + */
> > +#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> 
> I think I'd change the condition to (inverting it):
> #if (BITS_PER_LONG == 64) || defined(__LITTLE_ENDIAN)
> since that is the condition when the layout matches.

Sorry, I don't understand about 'layout matches'. Why this way is
better than another?
 
> > +void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
> > +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
> > +#else
> > +#define bitmap_from_arr64(bitmap, buf, nbits)			\
> > +	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> > +			(const unsigned long *) (buf), (nbits))
> > +#define bitmap_to_arr64(buf, bitmap, nbits)			\
> > +	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> > +			(const unsigned long *) (bitmap), (nbits))
> > +#endif
> > +
> >  static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
> >  			const unsigned long *src2, unsigned int nbits)
> >  {
> > @@ -596,10 +614,7 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
> >   */
> >  static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
> >  {
> > -	dst[0] = mask & ULONG_MAX;
> > -
> > -	if (sizeof(mask) > sizeof(unsigned long))
> > -		dst[1] = mask >> 32;
> > +	bitmap_from_arr64(dst, &mask, 64);
> >  }
> 
> I'd leave this alone.
 
I'd change it in sake of consistency. Let's see what others say.

> >  /**
> > diff --git a/lib/bitmap.c b/lib/bitmap.c
> > index d9a4480af5b9..aea9493f4216 100644
> > --- a/lib/bitmap.c
> > +++ b/lib/bitmap.c
> > @@ -1533,5 +1533,52 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
> >  		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
> >  }
> >  EXPORT_SYMBOL(bitmap_to_arr32);
> > +#endif
> > +
> > +#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> > +/**
> > + * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
> > + *	@bitmap: array of unsigned longs, the destination bitmap
> > + *	@buf: array of u64 (in host byte order), the source bitmap
> > + *	@nbits: number of bits in @bitmap
> > + */
> > +void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits)
> > +{
> > +	while (nbits > 0) {
> 
> This looks like a for look to me...

Can you explain why for() is better then while() here? Is generated
code better, or something else?

> > +		u64 val = *buf++;
> > +
> > +		*bitmap++ = (unsigned long)val;
> > +		if (nbits > 32)
> > +			*bitmap++ = (unsigned long)(val >> 32);
> 
> No need for either cast.

Yep, thanks.

> > +		nbits -= 64;
> > +	}
> > 
> > +	/* Clear tail bits in last word beyond nbits. */
> > +	if (nbits % BITS_PER_LONG)
> > +		bitmap[-1] &= BITMAP_LAST_WORD_MASK(nbits);
> > +}
> > +EXPORT_SYMBOL(bitmap_from_arr64);
> > +
> > +/**
> > + * bitmap_to_arr64 - copy the contents of bitmap to a u64 array of bits
> > + *	@buf: array of u64 (in host byte order), the dest bitmap
> > + *	@bitmap: array of unsigned longs, the source bitmap
> > + *	@nbits: number of bits in @bitmap
> > + */
> > +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> > +{
> > +	unsigned long *end = bitmap + BITS_TO_LONGS(nbits);

This should be const unsigned long.

> > +
> > +	while (bitmap < end) {
> 
> Another for loop...
> 
> > +		*buf = *bitmap++;
> > +		if (bitmap < end)
> > +			*buf |= *bitmap++ << 32;
> 
> That is UB.

It's -Wshift-count-overflow. Should be
        *buf |= (u64)(*bitmap++) << 32;

> Did you even compile this??

Yes. That's it, my BE32 platform is arm, and I had to disable CONFIG_WERROR
because arm breaks build with that, and forgot about it. :(

I boot-tested it on mips with the fix above with no issues.
 
> 	David
> 
> > +		buf++;
> > +	}
> > +
> > +	/* Clear tail bits in last element of array beyond nbits. */
> > +	if (nbits % 64)
> > +		buf[-1] &= GENMASK_ULL(nbits, 0);
> > +}
> > +EXPORT_SYMBOL(bitmap_to_arr64);
> >  #endif
> > --
> > 2.32.0
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
