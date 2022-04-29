Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39125514FD1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378543AbiD2PtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378606AbiD2Psw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:48:52 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BCF2DD5C;
        Fri, 29 Apr 2022 08:45:33 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id y3so6043700qtn.8;
        Fri, 29 Apr 2022 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0AmjJCTGkqpH0j7OWbnycCS3KV9E1uQeOq85BlTLnmc=;
        b=XwuIlexwM4dve930lSDOFEEf8Fxpdc0edILk7OXe0i5iZsUvd8Kg4yOkWhq/1D5Zpb
         E/20A/6oLFskOXdZkX3hn3IcHYE+aMA16wtMf4t0oLTtFMNvwUINAtmubsIIxQKiPI9V
         RiFd66irxRypZPujMrHMpRsrmjXCk8rvcBzpsHj1H0Z92ZhL0XQoY7ePvVEx0UyE1/VG
         4ijejAM0ZvIoOGau468wAgDUqTtxbHGmwn8U/IVPcEwP+kExK4vZJemXU+9LjyHg4vUR
         gxk3cM8uCcqajmnnVSbLEWVuQ7kG7UGPbypmf7lMIvrukvEZomFgKLXUcjxAT2+F+VOU
         QapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0AmjJCTGkqpH0j7OWbnycCS3KV9E1uQeOq85BlTLnmc=;
        b=bPrwilbymtPf3RHF6Dm7u/pa1k5n+hMjHCCgwr38CZ7lr5kHELe7qg4Zz3xSfvuwG+
         4YMnO2I64+NDsh5TesFUJx3C6R8eup7hMXDweuim5HHTVQyom1h+AFTXutUcbP0VWwlP
         6Z7fKq7lxWynqRVNCIlmIJnhRI9CDBm0mg10XWHUlbi2zzagN5DJwvFlkFsMh9Rn3auH
         VlP9dky0gofs+z+RM70X3EMHyx6ggLKCyF1vv6GL+YD1TiRsF9ofcxSKWr4y9vSa4477
         219KwhRYxJnbGHSJ/1l/pxQ/ywPv3dMhoEDxp3ZJQRKN/GLamSs4MgdPMNZkwjvSC3rO
         fazg==
X-Gm-Message-State: AOAM530rJdR5fzeiFfzZuqxUaOVADpREp51XeShJ6tVv0vWU3+suHcM3
        sYqWXpFc/HqZO62SJvqijpU=
X-Google-Smtp-Source: ABdhPJyRmBUlkHBi31CCfAyzBtaCMOUxbplBygVKF9dcYX8Y/qQ8x9HZhfy3XO8SG3RpRveTr5TFdA==
X-Received: by 2002:a05:622a:1a8e:b0:2f3:96db:3d8f with SMTP id s14-20020a05622a1a8e00b002f396db3d8fmr5128qtc.379.1651247132562;
        Fri, 29 Apr 2022 08:45:32 -0700 (PDT)
Received: from localhost ([2601:c4:c432:945:a9d2:6c22:f2f3:7503])
        by smtp.gmail.com with ESMTPSA id u17-20020a05620a431100b0069fb9f98b26sm635934qko.69.2022.04.29.08.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 08:45:32 -0700 (PDT)
Date:   Fri, 29 Apr 2022 08:45:33 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] lib: add bitmap_{from,to}_arr64
Message-ID: <YmwIHRhS2f1QTW3b@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-3-yury.norov@gmail.com>
 <YmvhLbIoHDhEhJFq@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmvhLbIoHDhEhJFq@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 03:59:25PM +0300, Andy Shevchenko wrote:
> On Thu, Apr 28, 2022 at 01:51:13PM -0700, Yury Norov wrote:
> > Manipulating 64-bit arrays with bitmap functions is potentially dangerous
> > because on 32-bit BE machines the order of halfwords doesn't match.
> > Another issue is that compiler may throw a warning about out-of-boundary
> > access.
> > 
> > This patch adds bitmap_{from,to}_arr64 functions in addition to existing
> > bitmap_{from,to}_arr32.
> 
> ...
> 
> > +	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> > +			(const unsigned long *) (buf), (nbits))
> 
> Drop spaces after castings. Besides that it might be placed on a single line.
> 
> ...

OK
 
> 
> > +	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> > +			(const unsigned long *) (bitmap), (nbits))
> 
> Ditto.
> 
> ...
> 
> > +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> > +{
> > +	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
> > +
> > +	while (bitmap < end) {
> > +		*buf = *bitmap++;
> > +		if (bitmap < end)
> > +			*buf |= (u64)(*bitmap++) << 32;
> > +		buf++;
> > +	}
> >  
> > +	/* Clear tail bits in last element of array beyond nbits. */
> > +	if (nbits % 64)
> > +		buf[-1] &= GENMASK_ULL(nbits, 0);
> 
> Hmm... if nbits is > 0 and < 64, wouldn't be this problematic, since
> end == bitmap? Or did I miss something?

BITS_TO_LONGS(0) == 0
BITS_TO_LONGS(1..32) == 1
BITS_TO_LONGS(33..64) == 2

The only potential problem with buf[-1] is nbits == 0, but fortunately
(0 % 64) == 0, and it doesn't happen.

Thanks,
Yury

> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
