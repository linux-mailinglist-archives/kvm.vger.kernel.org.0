Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954153464FF
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhCWQYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:24:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233049AbhCWQXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 12:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616516621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQGyXcT3h3Fra4FoZCMnTXACZvTXM9jgtfisKIcA6HM=;
        b=c8hsqqIvCGd7bExLmkN2saMTHRMxdZJ1lWJlxpBj/gBDufSteH8gMcBA14dCYTN0r+Yy7X
        sPJEovEUbdPTCbQGaELAUvwY3S2gcbrUrGuQpHv+E95fEbD33/NGO/AsuKqQGU9CXQpHpa
        b8aCKecqzAHlwGXyD5ZuiUN+DAK8BdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-ZCa_56_mP5OpwkTpiPtsuA-1; Tue, 23 Mar 2021 12:23:39 -0400
X-MC-Unique: ZCa_56_mP5OpwkTpiPtsuA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8236C190D340
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 16:23:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 960F55D6AD;
        Tue, 23 Mar 2021 16:23:37 +0000 (UTC)
Date:   Tue, 23 Mar 2021 17:23:34 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] compiler: Add builtin overflow flag
Message-ID: <20210323162334.pylagyghpkginrzq@kamzik.brq.redhat.com>
References: <20210323135801.295407-1-drjones@redhat.com>
 <9f0b7493-bc1d-6fb7-9fd9-30fd4c294c7f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f0b7493-bc1d-6fb7-9fd9-30fd4c294c7f@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:22:58PM +0100, Thomas Huth wrote:
> On 23/03/2021 14.58, Andrew Jones wrote:
> > Checking for overflow can difficult, but doing so may be a good
> > idea to avoid difficult to debug problems. Compilers that provide
> > builtins for overflow checking allow the checks to be simple
> > enough that we can use them more liberally. The idea for this
> > flag is to wrap a calculation that should have overflow checking,
> > allowing compilers that support it to give us some extra robustness.
> > For example,
> > 
> >    #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
> >        bool overflow = __builtin_mul_overflow(x, y, &z);
> >        assert(!overflow);
> >    #else
> >        /* Older compiler, hopefully we don't overflow... */
> >        z = x * y;
> >    #endif
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >   lib/linux/compiler.h | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> > index 2d72f18c36e5..311da9807932 100644
> > --- a/lib/linux/compiler.h
> > +++ b/lib/linux/compiler.h
> > @@ -8,6 +8,20 @@
> >   #ifndef __ASSEMBLY__
> > +#define GCC_VERSION (__GNUC__ * 10000           \
> > +		     + __GNUC_MINOR__ * 100     \
> > +		     + __GNUC_PATCHLEVEL__)
> > +
> > +#ifdef __clang__
> > +#if __has_builtin(__builtin_mul_overflow) && \
> > +    __has_builtin(__builtin_add_overflow) && \
> > +    __has_builtin(__builtin_sub_overflow)
> > +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> > +#endif
> > +#elif GCC_VERSION >= 50100
> > +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> > +#endif
> > +
> >   #include <stdint.h>
> >   #define barrier()	asm volatile("" : : : "memory")
> > 
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> 
> ... but I wonder:
> 
> 1) Whether we still want to support those old compilers that do not have
> this built-in functions yet ... maybe it's time to declare the older systems
> as unsupported now?

I think the CentOS7 test is a good one to have. If for nobody else, then
the people maintaining and testing RHEL7. So, I'd rather we keep a simple
fallback in place, but hope that its use is limited.

> 
> 2) Whether it would make more sense to provide static-inline functions for
> these arithmetic operations that take care of the overflow handling, so that
> we do not have #ifdefs in the .c code later all over the place?

We could add macro wrappers for the arbitrary integral type builtin forms
and/or the predicates forms.

I can take a stab at that and send a v2.

Thanks,
drew

