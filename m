Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD75177AE
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiEBUKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 16:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiEBUK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 16:10:29 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1469A63E8;
        Mon,  2 May 2022 13:07:00 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id jt15so1774207qvb.8;
        Mon, 02 May 2022 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3wD5SALNmRJFLj9tUWRsXDgRKKhZDunmdZcipLQpV4=;
        b=Uq36JCx5K0KFPY82rUyOkrL7gpRtRpV8qwV7pUpi7ZblohNY77FDprju+2thZr/DCz
         IURVugcQ4/25LVRJWq2wza3H8mhAYjZccCf85fJulyduF3r1Hj9qKXuEAWrDIO0FSZU9
         qdT1iBcAiRavaiLaO7zwRAx+RePYqKUbXADQASvw23Wbs5RYgyEouE0PT1PlS3XMekJD
         mq959KdKlcnZNxUc0kLS+puVh9HfuTCZGeIB40KD946fqq2idzrHT/i0INSqoSwWgZ4r
         sIxxSwzeu/FTCOK34gRXAKzTlfe5zuUbbsJ1gpXVKh1pLs+L6qRolofrTnUCT/KcWM8D
         5c1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3wD5SALNmRJFLj9tUWRsXDgRKKhZDunmdZcipLQpV4=;
        b=FiTKpLjSyYo287zEIjZ68hBEuYpwehF7nO5fpALuhJM2Q6k4ZRtChVtT8+eWrDXqJH
         q68BlUwfGIEWDhB3N2mbd+lNlIhz4gER39jZ52DB4qPcGxfim6B7p3b7tS5zxc/MW6VY
         5ai5LG+gMUIQB8eJv+WKo4N1GtSKEluw519ChYRUnxDr+4Fk+Woz6IUR7UTQ0lc+jl3f
         4OhAhX9Lg/zDVU0AeXPT7NJKSbKBimWkYj+1kzpN0GYlUG8860yzKODGhtDhpbo2F9EH
         3yA7J2knHphQCWr0rIGCI09+D1QSlsQW9xYFMGlM4XLNflIF3daqsoq0HJrMXSt6hPul
         f7PQ==
X-Gm-Message-State: AOAM533KgfShIurQry7Hp5lBUr+SI4grfY3negFKipC2LjgLQyNo39Zv
        RSBKTP51INdLO6mxvIRqD2k=
X-Google-Smtp-Source: ABdhPJyn1OXV0CXpTEdhtUwpy1u82XZ916qh1IHA1s6fQUtXW4a+i8V6Kt7lDT4N+V9R07MrAOeWMA==
X-Received: by 2002:a05:6214:c8d:b0:44b:f11e:63d with SMTP id r13-20020a0562140c8d00b0044bf11e063dmr11038124qvr.7.1651522019148;
        Mon, 02 May 2022 13:06:59 -0700 (PDT)
Received: from localhost ([2601:c4:c432:9a9:ce8e:a55c:4848:4d10])
        by smtp.gmail.com with ESMTPSA id u18-20020a05620a121200b0069fc13ce1e2sm4779593qkj.19.2022.05.02.13.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:06:58 -0700 (PDT)
Date:   Mon, 2 May 2022 13:06:56 -0700
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
Message-ID: <YnA54HzrdfOr2QYl@yury-laptop>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-3-yury.norov@gmail.com>
 <YmvhLbIoHDhEhJFq@smile.fi.intel.com>
 <YmwIHRhS2f1QTW3b@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmwIHRhS2f1QTW3b@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 08:45:35AM -0700, Yury Norov wrote:
> On Fri, Apr 29, 2022 at 03:59:25PM +0300, Andy Shevchenko wrote:
> > On Thu, Apr 28, 2022 at 01:51:13PM -0700, Yury Norov wrote:
> > > Manipulating 64-bit arrays with bitmap functions is potentially dangerous
> > > because on 32-bit BE machines the order of halfwords doesn't match.
> > > Another issue is that compiler may throw a warning about out-of-boundary
> > > access.
> > > 
> > > This patch adds bitmap_{from,to}_arr64 functions in addition to existing
> > > bitmap_{from,to}_arr32.
> > 
> > ...
> > 
> > > +	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> > > +			(const unsigned long *) (buf), (nbits))
> > 
> > Drop spaces after castings. Besides that it might be placed on a single line.
> > 
> > ...
> 
> OK
>  
> > 
> > > +	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> > > +			(const unsigned long *) (bitmap), (nbits))
> > 
> > Ditto.
> > 
> > ...
> > 
> > > +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> > > +{
> > > +	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
> > > +
> > > +	while (bitmap < end) {
> > > +		*buf = *bitmap++;
> > > +		if (bitmap < end)
> > > +			*buf |= (u64)(*bitmap++) << 32;
> > > +		buf++;
> > > +	}
> > >  
> > > +	/* Clear tail bits in last element of array beyond nbits. */
> > > +	if (nbits % 64)
> > > +		buf[-1] &= GENMASK_ULL(nbits, 0);
> > 
> > Hmm... if nbits is > 0 and < 64, wouldn't be this problematic, since
> > end == bitmap? Or did I miss something?
> 
> BITS_TO_LONGS(0) == 0
> BITS_TO_LONGS(1..32) == 1
> BITS_TO_LONGS(33..64) == 2
> 
> The only potential problem with buf[-1] is nbits == 0, but fortunately
> (0 % 64) == 0, and it doesn't happen.
> 
> Thanks,
> Yury

Are there any other concerns? If no, I'll fix formatting and append it to
bitmap-for-next.

Thanks,
Yury
