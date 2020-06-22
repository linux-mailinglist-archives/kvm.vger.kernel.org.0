Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55635203533
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgFVK5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:57:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727027AbgFVK5z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 06:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592823473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNtLcQUUpe7Kiye03+uWIKIsvdaKDl9k+0TDPFxbq+o=;
        b=U3iDN9dr+T9bDTQ3C+CMqHQd3FYAXDcEEa4mMwbVtZAnMbPnFR/XqbZf6NNEwTGA/urRU1
        RpjugOOe3tbUkfw9q7dqk6redrSY8TfnLMtml7cGM1YSD2vzLohSviAHxV0N7QW+mmV1mT
        ZVEswTwlhrWcmsTgjDKMIon/nPGAzPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-vvHedkppPJSm-k8IcpII3w-1; Mon, 22 Jun 2020 06:57:51 -0400
X-MC-Unique: vvHedkppPJSm-k8IcpII3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CE488730E9;
        Mon, 22 Jun 2020 10:57:50 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0517E5C220;
        Mon, 22 Jun 2020 10:57:42 +0000 (UTC)
Date:   Mon, 22 Jun 2020 12:57:40 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
Message-ID: <20200622105740.isyt5hhj5sxwfj4d@kamzik.brq.redhat.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
 <a86a71c7-8c5e-7216-0a74-7bdc36355c02@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a86a71c7-8c5e-7216-0a74-7bdc36355c02@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 11:33:24AM +0200, Janosch Frank wrote:
> On 6/15/20 11:31 AM, Pierre Morel wrote:
> > We often need to retrieve hexadecimal kernel parameters.
> > Let's implement a shared utility to do it.
> 
> Often?
> 
> My main problem with this patch is that it doesn't belong into the s390
> library. atol() is already in string.c so htol() can be next to it.
> 
> util.c already has parse_keyval() so you should be able to extend it a
> bit for hex values and add a function below that goes through argv[].
> 
> CCing Andrew as he wrote most of the common library

I'd prefer we add strtol(), rather than htol(), as we try to add
common libc functions when possible. It could live in the same
files at atol (string.c/libcflat.h), but we should considering
adding a stdlib.c file some day.

Also, if we had strtol(), than parse_key() could use it with base=0
instead of atol(). That would get pretty close to the implementation
of kernel_arg(). We'd just need to add a

  char *find_key(const char *key, char **array, int array_len)

type of a function to do the command line iterating. Then,

  ret = parse_keyval(find_key("foo", argv, argc), &val);

should be the same as kernel_arg() if find_key returns NULL when
the key isn't found and parse_keyval learns to return -2 when s
is NULL.

Thanks,
drew


> 
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
> >  lib/s390x/kernel-args.h | 18 +++++++++++++
> >  s390x/Makefile          |  1 +
> >  3 files changed, 79 insertions(+)
> >  create mode 100644 lib/s390x/kernel-args.c
> >  create mode 100644 lib/s390x/kernel-args.h
> > 
> > diff --git a/lib/s390x/kernel-args.c b/lib/s390x/kernel-args.c
> > new file mode 100644
> > index 0000000..2d3b2c2
> > --- /dev/null
> > +++ b/lib/s390x/kernel-args.c
> > @@ -0,0 +1,60 @@
> > +/*
> > + * Retrieving kernel arguments
> > + *
> > + * Copyright (c) 2020 IBM Corp
> > + *
> > + * Authors:
> > + *  Pierre Morel <pmorel@linux.ibm.com>
> > + *
> > + * This code is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2.
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <string.h>
> > +#include <asm/arch_def.h>
> > +#include <kernel-args.h>
> > +
> > +static const char *hex_digit = "0123456789abcdef";
> > +
> > +static unsigned long htol(char *s)
> > +{
> > +	unsigned long v = 0, shift = 0, value = 0;
> > +	int i, digit, len = strlen(s);
> > +
> > +	for (shift = 0, i = len - 1; i >= 0; i--, shift += 4) {
> > +		digit = s[i] | 0x20;	/* Set lowercase */
> > +		if (!strchr(hex_digit, digit))
> > +			return 0;	/* this is not a digit ! */
> > +
> > +		if (digit <= '9')
> > +			v = digit - '0';
> > +		else
> > +			v = digit - 'a' + 10;
> > +		value += (v << shift);
> > +	}
> > +
> > +	return value;
> > +}
> > +
> > +int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val)
> > +{
> > +	int i, ret;
> > +	char *p, *q;
> > +
> > +	for (i = 0; i < argc; i++) {
> > +		ret = strncmp(argv[i], str, strlen(str));
> > +		if (ret)
> > +			continue;
> > +		p = strchr(argv[i], '=');
> > +		if (!p)
> > +			return -1;
> > +		q = strchr(p, 'x');
> > +		if (!q)
> > +			*val = atol(p + 1);
> > +		else
> > +			*val = htol(q + 1);
> > +		return 0;
> > +	}
> > +	return -2;
> > +}
> > diff --git a/lib/s390x/kernel-args.h b/lib/s390x/kernel-args.h
> > new file mode 100644
> > index 0000000..a88e34e
> > --- /dev/null
> > +++ b/lib/s390x/kernel-args.h
> > @@ -0,0 +1,18 @@
> > +/*
> > + * Kernel argument
> > + *
> > + * Copyright (c) 2020 IBM Corp
> > + *
> > + * Authors:
> > + *  Pierre Morel <pmorel@linux.ibm.com>
> > + *
> > + * This code is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2.
> > + */
> > +
> > +#ifndef KERNEL_ARGS_H
> > +#define KERNEL_ARGS_H
> > +
> > +int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val);
> > +
> > +#endif
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index ddb4b48..47a94cc 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
> >  cflatobjs += lib/s390x/interrupt.o
> >  cflatobjs += lib/s390x/mmu.o
> >  cflatobjs += lib/s390x/smp.o
> > +cflatobjs += lib/s390x/kernel-args.o
> >  
> >  OBJDIRS += lib/s390x
> >  
> > 
> 
> 



