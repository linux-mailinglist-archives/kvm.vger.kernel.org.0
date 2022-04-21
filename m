Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37585099BA
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385996AbiDUHna convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 21 Apr 2022 03:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386102AbiDUHnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:43:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4DED1C10D
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:40:29 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-320-RjXwMqAnPfqhoyE6QW4dlQ-1; Thu, 21 Apr 2022 08:40:26 +0100
X-MC-Unique: RjXwMqAnPfqhoyE6QW4dlQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Thu, 21 Apr 2022 08:40:25 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Thu, 21 Apr 2022 08:40:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yury Norov' <yury.norov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/4] lib: add bitmap_{from,to}_arr64
Thread-Topic: [PATCH 2/4] lib: add bitmap_{from,to}_arr64
Thread-Index: AQHYVQdrgrXWaR3sCEGGbig0LA6aC6z5+Nxw
Date:   Thu, 21 Apr 2022 07:40:25 +0000
Message-ID: <b7fe319a66914a9e88d2830101e6319f@AcuMS.aculab.com>
References: <20220420222530.910125-1-yury.norov@gmail.com>
 <20220420222530.910125-3-yury.norov@gmail.com>
In-Reply-To: <20220420222530.910125-3-yury.norov@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yury Norov
> Sent: 20 April 2022 23:25
> 
> Manipulating 64-bit arrays with bitmap functions is potentially dangerous
> because on 32-bit BE machines the order of halfwords doesn't match. Another
> issue is that compiler may throw a warning about out-of-boundary access.
> 
> This patch adds bitmap_{from,to}_arr64 functions in addition to existing
> bitmap_{from,to}_arr32.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  include/linux/bitmap.h | 23 +++++++++++++++++----
>  lib/bitmap.c           | 47 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 10d805c2893c..f78c534fb814 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -292,6 +292,24 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
>  			(const unsigned long *) (bitmap), (nbits))
>  #endif
> 
> +/*
> + * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
> + * machines the order of hi and lo parts of nubmers match the bitmap structure.
> + * In both cases conversion is not needed when copying data from/to arrays of
> + * u64.
> + */
> +#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)

I think I'd change the condition to (inverting it):
#if (BITS_PER_LONG == 64) || defined(__LITTLE_ENDIAN)
since that is the condition when the layout matches.

> +void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
> +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
> +#else
> +#define bitmap_from_arr64(bitmap, buf, nbits)			\
> +	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> +			(const unsigned long *) (buf), (nbits))
> +#define bitmap_to_arr64(buf, bitmap, nbits)			\
> +	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> +			(const unsigned long *) (bitmap), (nbits))
> +#endif
> +
>  static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
>  			const unsigned long *src2, unsigned int nbits)
>  {
> @@ -596,10 +614,7 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
>   */
>  static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
>  {
> -	dst[0] = mask & ULONG_MAX;
> -
> -	if (sizeof(mask) > sizeof(unsigned long))
> -		dst[1] = mask >> 32;
> +	bitmap_from_arr64(dst, &mask, 64);
>  }

I'd leave this alone.

> 
>  /**
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index d9a4480af5b9..aea9493f4216 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1533,5 +1533,52 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
>  		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
>  }
>  EXPORT_SYMBOL(bitmap_to_arr32);
> +#endif
> +
> +#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
> +/**
> + * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
> + *	@bitmap: array of unsigned longs, the destination bitmap
> + *	@buf: array of u64 (in host byte order), the source bitmap
> + *	@nbits: number of bits in @bitmap
> + */
> +void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits)
> +{
> +	while (nbits > 0) {

This looks like a for look to me...

> +		u64 val = *buf++;
> +
> +		*bitmap++ = (unsigned long)val;
> +		if (nbits > 32)
> +			*bitmap++ = (unsigned long)(val >> 32);

No need for either cast.

> +		nbits -= 64;
> +	}
> 
> +	/* Clear tail bits in last word beyond nbits. */
> +	if (nbits % BITS_PER_LONG)
> +		bitmap[-1] &= BITMAP_LAST_WORD_MASK(nbits);
> +}
> +EXPORT_SYMBOL(bitmap_from_arr64);
> +
> +/**
> + * bitmap_to_arr64 - copy the contents of bitmap to a u64 array of bits
> + *	@buf: array of u64 (in host byte order), the dest bitmap
> + *	@bitmap: array of unsigned longs, the source bitmap
> + *	@nbits: number of bits in @bitmap
> + */
> +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> +{
> +	unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
> +
> +	while (bitmap < end) {

Another for loop...

> +		*buf = *bitmap++;
> +		if (bitmap < end)
> +			*buf |= *bitmap++ << 32;

That is UB.
Did you even compile this??

	David

> +		buf++;
> +	}
> +
> +	/* Clear tail bits in last element of array beyond nbits. */
> +	if (nbits % 64)
> +		buf[-1] &= GENMASK_ULL(nbits, 0);
> +}
> +EXPORT_SYMBOL(bitmap_to_arr64);
>  #endif
> --
> 2.32.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

