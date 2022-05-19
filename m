Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA76652D9B4
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbiESQCM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbiESQCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5685837A3A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652976125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NZH7hfl6vfJQvQPcCVNymrIHQhqI3m58VxIHbk465NE=;
        b=W0SW6g4z+1gA3+ttIMrwxb2VyabimPHzVaS5xsMuh0f/w/PVINQkK35aW5th+WkM+UAMEt
        IpSBXCZR7Zo+Qb+JOH7046u9gEDQHs3qFGRme8iaOwd9WupSdnyRFmkRUh+CG1SHVjcHjF
        0lizAgC8uhg2DvIYbdV/Dy9B7PBFC/g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-6rHd0BstP6SMnn0fy3mX3Q-1; Thu, 19 May 2022 12:02:04 -0400
X-MC-Unique: 6rHd0BstP6SMnn0fy3mX3Q-1
Received: by mail-wr1-f70.google.com with SMTP id bv12-20020a0560001f0c00b0020e359b3852so1699847wrb.14
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NZH7hfl6vfJQvQPcCVNymrIHQhqI3m58VxIHbk465NE=;
        b=t4E9zZqPv2YrPkOFiqEGblvWf62oI283ap0oByUnxR3sfUeVnZ+xPMwn0trSg4FNy5
         tt17WwOg6GLaL3Zpv5hlYR3lvdQEhKtBHG1rJI+L8MAdeluDmMVcVv+AQEjNT5edSSf9
         1LiMTI1JtxwpHhkmia/VNuCheWe9eFjmv00HgPAaYavzBkLYR1iDqPxSIVq+sRByHxgG
         fWKLqJCxnm0sVOK2xQjOAVstmfz5W2DQvoy1cDPzXAdhAQh2ykb/WzWxEJSbHrcRd0s1
         /Q5YAElWGQhorC17IhHfhrhK/Wq9LeXWm+9rwFfgZjJeDOYqLJqGGbYkxuNIr2XHR13F
         KvLw==
X-Gm-Message-State: AOAM532eJ2u22RifLG/M1mZkiVWikRv45CEfJFXg11a59mpEGuu737gI
        umdO/TXSgNMPMsURjOEcnPUGU5Oa/n8beHyFnncfcr9yGSlyGnZnrrnwO8TS1i0Wbytxrojwf4A
        Tma9F7M2609Fu
X-Received: by 2002:adf:a459:0:b0:20d:3c9:44a1 with SMTP id e25-20020adfa459000000b0020d03c944a1mr4478136wra.560.1652976122827;
        Thu, 19 May 2022 09:02:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfaTxBGffiQS1K5SPYGSh+Hqc2CC5rhht/NtIVbX1ASsRHqCyzPJqAaWAuYVRBZHUkPgJv9A==
X-Received: by 2002:adf:a459:0:b0:20d:3c9:44a1 with SMTP id e25-20020adfa459000000b0020d03c944a1mr4478108wra.560.1652976122459;
        Thu, 19 May 2022 09:02:02 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id m26-20020a7bce1a000000b003942a244f3fsm7766568wmc.24.2022.05.19.09.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:02:01 -0700 (PDT)
Date:   Thu, 19 May 2022 18:02:00 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 09/23] lib/printf: Support for
 precision modifier in printing strings
Message-ID: <20220519160200.2shxxux6it63rzz6@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-10-nikos.nikoleris@arm.com>
 <20220519145233.okvw5no6eduk4yvc@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519145233.okvw5no6eduk4yvc@gator>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 04:52:33PM +0200, Andrew Jones wrote:
> On Fri, May 06, 2022 at 09:55:51PM +0100, Nikos Nikoleris wrote:
> > This follows the typical format of:
> > 
> > printf("%.Ns", *str);
> > 
> > Where N might be a decimal digit string or '*'. This feature is used
> > by a future change.
> > 
> > See also: man 3 printf
> > 
> > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > ---
> >  lib/printf.c | 84 ++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 71 insertions(+), 13 deletions(-)
> > 
> > diff --git a/lib/printf.c b/lib/printf.c
> > index 1269723..724befa 100644
> > --- a/lib/printf.c
> > +++ b/lib/printf.c
> > @@ -19,6 +19,7 @@ typedef struct strprops {
> >      char pad;
> >      int npad;
> >      bool alternate;
> > +    int precision;
> >  } strprops_t;
> >  
> >  static void addchar(pstream_t *p, char c)
> > @@ -43,7 +44,7 @@ static void print_str(pstream_t *p, const char *s, strprops_t props)
> >  	}
> >      }
> >  
> > -    while (*s)
> > +    while (*s && props.precision--)
> >  	addchar(p, *s++);
> >  
> >      if (npad < 0) {
> > @@ -147,9 +148,61 @@ static int fmtnum(const char **fmt)
> >      return num;
> >  }
> >  
> > +static inline int isdigit(int c)
> > +{
> > +    return '0' <= c && c <= '9';
> > +}
> 
> We desperately need to add ctype to our library. We've already got
> isblank, isalpha, and isalnum local to argv.c and I see later you
> add isspace. I'll post a patch now that introduces ctype.[ch] with
> the ones used by argv. Then, when you respin this series you can
> add your ctype functions there.
> 
> > +
> > +/*
> > + * Adapted from drivers/firmware/efi/libstub/vsprintf.c
> > + */
> > +static int skip_atoi(const char **s)
> > +{
> > +    int i = 0;
> > +
> > +    do {
> > +	i = i*10 + *((*s)++) - '0';
> > +    } while (isdigit(**s));
> > +
> > +    return i;
> > +}
> > +
> > +/*
> > + * Adapted from drivers/firmware/efi/libstub/vsprintf.c
> > + */
> > +static int get_int(const char **fmt, va_list *ap)
> > +{
> > +    if (isdigit(**fmt)) {
> > +	return skip_atoi(fmt);
> > +    }
> > +    if (**fmt == '*') {
> > +	++(*fmt);
> > +	/* it's the next argument */
> > +	return va_arg(*ap, int);
> > +    }
> > +    return 0;
> > +}
> > +
> >  int vsnprintf(char *buf, int size, const char *fmt, va_list va)
> >  {
> >      pstream_t s;
> > +    va_list args;
> > +
> > +    /*
> > +     * We want to pass our input va_list to helper functions by reference,
> > +     * but there's an annoying edge case. If va_list was originally passed
> > +     * to us by value, we could just pass &ap down to the helpers. This is
> > +     * the case on, for example, X86_32.
> > +     * However, on X86_64 (and possibly others), va_list is actually a
> > +     * size-1 array containing a structure. Our function parameter ap has
> > +     * decayed from T[1] to T*, and &ap has type T** rather than T(*)[1],
> > +     * which is what will be expected by a function taking a va_list *
> > +     * parameter.
> > +     * One standard way to solve this mess is by creating a copy in a local
> > +     * variable of type va_list and then passing a pointer to that local
> > +     * copy instead, which is what we do here.
> > +     */
> > +    va_copy(args, va);
> >  
> >      s.buffer = buf;
> >      s.remain = size - 1;
> > @@ -160,6 +213,7 @@ int vsnprintf(char *buf, int size, const char *fmt, va_list va)
> >  	strprops_t props;
> >  	memset(&props, 0, sizeof(props));
> >  	props.pad = ' ';
> > +	props.precision = -1;
> >  
> >  	if (f != '%') {
> >  	    addchar(&s, f);
> > @@ -172,11 +226,14 @@ int vsnprintf(char *buf, int size, const char *fmt, va_list va)
> >  	    addchar(&s, '%');
> >  	    break;
> >  	case 'c':
> > -            addchar(&s, va_arg(va, int));
> > +	    addchar(&s, va_arg(args, int));
> >  	    break;
> >  	case '\0':
> >  	    --fmt;
> >  	    break;
> > +	case '.':
> > +	    props.precision = get_int(&fmt, &args);
> > +	    goto morefmt;
> >  	case '#':
> >  	    props.alternate = true;
> >  	    goto morefmt;
> > @@ -204,54 +261,55 @@ int vsnprintf(char *buf, int size, const char *fmt, va_list va)
> >  	case 'd':
> >  	    switch (nlong) {
> >  	    case 0:
> > -		print_int(&s, va_arg(va, int), 10, props);
> > +		print_int(&s, va_arg(args, int), 10, props);
> >  		break;
> >  	    case 1:
> > -		print_int(&s, va_arg(va, long), 10, props);
> > +		print_int(&s, va_arg(args, long), 10, props);
> >  		break;
> >  	    default:
> > -		print_int(&s, va_arg(va, long long), 10, props);
> > +		print_int(&s, va_arg(args, long long), 10, props);
> >  		break;
> >  	    }
> >  	    break;
> >  	case 'u':
> >  	    switch (nlong) {
> >  	    case 0:
> > -		print_unsigned(&s, va_arg(va, unsigned), 10, props);
> > +		print_unsigned(&s, va_arg(args, unsigned), 10, props);
> >  		break;
> >  	    case 1:
> > -		print_unsigned(&s, va_arg(va, unsigned long), 10, props);
> > +		print_unsigned(&s, va_arg(args, unsigned long), 10, props);
> >  		break;
> >  	    default:
> > -		print_unsigned(&s, va_arg(va, unsigned long long), 10, props);
> > +		print_unsigned(&s, va_arg(args, unsigned long long), 10, props);
> >  		break;
> >  	    }
> >  	    break;
> >  	case 'x':
> >  	    switch (nlong) {
> >  	    case 0:
> > -		print_unsigned(&s, va_arg(va, unsigned), 16, props);
> > +		print_unsigned(&s, va_arg(args, unsigned), 16, props);
> >  		break;
> >  	    case 1:
> > -		print_unsigned(&s, va_arg(va, unsigned long), 16, props);
> > +		print_unsigned(&s, va_arg(args, unsigned long), 16, props);
> >  		break;
> >  	    default:
> > -		print_unsigned(&s, va_arg(va, unsigned long long), 16, props);
> > +		print_unsigned(&s, va_arg(args, unsigned long long), 16, props);
> >  		break;
> >  	    }
> >  	    break;
> >  	case 'p':
> >  	    props.alternate = true;
> > -	    print_unsigned(&s, (unsigned long)va_arg(va, void *), 16, props);
> > +	    print_unsigned(&s, (unsigned long)va_arg(args, void *), 16, props);
> >  	    break;
> >  	case 's':
> > -	    print_str(&s, va_arg(va, const char *), props);
> > +	    print_str(&s, va_arg(args, const char *), props);
> >  	    break;
> >  	default:
> >  	    addchar(&s, f);
> >  	    break;
> >  	}
> >      }
> > +    va_end(args);
> >      *s.buffer = 0;
> >      return s.added;
> >  }
> > -- 
> > 2.25.1
> >
> 
> I think I should also post a patches that finally reformat these older
> files. The tab+4spaces stuff must go!
> 
> When we get ctype we'll want to move out isdigit, but otherwise
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Actually, I'd prefer we make the feature work correctly for %d/%x/%#
from the beginning. It probably wouldn't take much to ensure precision
acts as a minimum (with zero padding when necessary) for numbers.

Thanks,
drew

