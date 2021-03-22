Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50147343D81
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCVKJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229703AbhCVKJc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 06:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616407771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=drF4XCT2aXRa2El8gC6yu0c3/SgAj1FErRGzJKhlcrk=;
        b=F7ZPKNWmydS/Gbf5xgVCkQ2awnvQhCWsLleskNEXxkV2OmLXZhlPemOS0m1gbX8LDvm9C9
        7shkhbGeFuGaVNgla+32gS3+aszCFnPeC1A0tE3awGhjcwu4q0avR3zWL1CbHGMMoX6Stp
        hhgHthLzcsp5B5kFI5GS35DFzOSuYns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-4Hv0ElROPEyLLHZoO_gHsA-1; Mon, 22 Mar 2021 06:09:29 -0400
X-MC-Unique: 4Hv0ElROPEyLLHZoO_gHsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6FC8801817;
        Mon, 22 Mar 2021 10:09:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BFBD63634;
        Mon, 22 Mar 2021 10:09:25 +0000 (UTC)
Date:   Mon, 22 Mar 2021 11:09:21 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210322100921.cd7kvxpkrfkdrq53@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
 <eef64e07-4862-36eb-bd79-06ec71cc510f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef64e07-4862-36eb-bd79-06ec71cc510f@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 09:52:43AM +0000, Nikos Nikoleris wrote:
> > > +unsigned long int strtoul(const char *nptr, char **endptr, int base)
> > >   {
> > >       long acc = 0;
> > > -    const char *s = ptr;
> > > +    const char *s = nptr;
> > >       int neg, c;
> > > -    while (*s == ' ' || *s == '\t')
> > > +    if (base < 0 || base == 1 || base > 32)
> > > +        goto out; // errno = EINVAL
> > 
> > I changed this to
> > 
> >   assert(base == 0 || (base >= 2 && base <= 36));
> > 
> > Any reason why you weren't allowing bases 33 - 36?
> > 
> 
> I was going through the manpage for strtoul and I got confused. 36 is the
> right value.
> 
> I wasn't sure if we should assert, the manpage seems to imply that it will
> return without converting and set the errno and endptr. I guess it might be
> better to assert().

Yeah, I think so for our little test framework. Anything that would result
in EINVAL means fix your test code. assert should help find those things
more quickly.

> 
> > > +
> > > +    while (isspace(*s))
> > >           s++;
> > >       if (*s == '-'){
> > >           neg = 1;
> > > @@ -152,20 +180,46 @@ long atol(const char *ptr)
> > >               s++;
> > >       }
> > > +    if (base == 0 || base == 16) {
> > > +        if (*s == '0') {
> > > +            s++;
> > > +            if (*s == 'x') {
> > 
> > I changed this to (*s == 'x' || *s == 'X')
> > 
> 
> Here my intent was to not parse 0X as a valid prefix for base 16, 0X is not
> in the manpage.

It's a manpage bug. strtol's manpage does specify it and libc's strtoul
allows it.

> > > +long atol(const char *ptr)
> > > +{
> > > +    return strtoul(ptr, NULL, 10);
> > 
> > Since atol should be strtol, I went ahead and also added strtol.
> > 
> 
> Not very important but we could also add it to stdlib.h?

Yeah, atol should go to stdlib, but I think that's another cleanup patch
we can do later. I'd actually like to kill libcflat and start using
standard headers for everything. At least for starters we could create
all the standard headers we need and move all the prototypes out of
libcflat but keep libcflat as a header full of #includes.

Thanks,
drew

