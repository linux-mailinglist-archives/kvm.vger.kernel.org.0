Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830632A4AD8
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgKCQKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 11:10:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbgKCQKv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 11:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604419850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8+bkEGuyr8COQ+rC0p6GIuqjuQAC7lU04M54hPzJkc=;
        b=VZkARjdkTXezF2XSLVuD7Jb/50JFqELhlmmZkyIHTOM+Bpp7Wuiopt8v5s9qF65uiqOKjT
        qqDKgBm64wmhCmaskU9gBfo3Fz1GtXRUkfNNQXU7xJSrheoj/9+Hh8CLdMa0QNYBXfWTo7
        Z6LC5PhtEPYCnWple5I2I5spsNsu19U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-JP4GjR1eNhCVfCj2VHFU1w-1; Tue, 03 Nov 2020 11:10:48 -0500
X-MC-Unique: JP4GjR1eNhCVfCj2VHFU1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50CED1028D40;
        Tue,  3 Nov 2020 16:10:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 424525DA33;
        Tue,  3 Nov 2020 16:10:44 +0000 (UTC)
Date:   Tue, 3 Nov 2020 17:10:38 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: Add support for configuring
 the translation granule
Message-ID: <20201103161038.32orgisio5xy5cn2@kamzik.brq.redhat.com>
References: <20201102113444.103536-1-nikos.nikoleris@arm.com>
 <20201102113444.103536-2-nikos.nikoleris@arm.com>
 <20201103130443.d7zt2zdzbg6hgq7c@kamzik.brq.redhat.com>
 <938dd93e-653b-492d-e8d9-d19fc54cb1f5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <938dd93e-653b-492d-e8d9-d19fc54cb1f5@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 03:49:32PM +0000, Nikos Nikoleris wrote:
> > > diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
> > > index 46af552..2a06207 100644
> > > --- a/lib/arm64/asm/page.h
> > > +++ b/lib/arm64/asm/page.h
> > > @@ -10,38 +10,51 @@
> > >    * This work is licensed under the terms of the GNU GPL, version 2.
> > >    */
> > > +#include <config.h>
> > >   #include <linux/const.h>
> > > -#define PGTABLE_LEVELS		2
> > >   #define VA_BITS			42
> > 
> > Let's bump VA_BITS to 48 while we're at it.

I tried my suggestion to go to 48 VA bits, but it seems to break
things for 64K pages.

> > 
> > > +#define PAGE_SIZE		CONFIG_PAGE_SIZE
> > 
> > I see now how we had '%d' in the other patch for PAGE_SIZE
> > instead of %ld. To keep a UL like it is for arm and x86,
> > then we can add the UL to CONFIG_PAGE_SIZE in configure.
> > 
> 
> I realised the problem as soon as I reorderd the two changes. I have now
> added UL to CONFIG_PAGE_SIZE.
> 
> > > +#if PAGE_SIZE == 65536
> > >   #define PAGE_SHIFT		16
> > > -#define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
> > > +#elif PAGE_SIZE == 16384
> > > +#define PAGE_SHIFT		14
> > > +#elif PAGE_SIZE == 4096
> > > +#define PAGE_SHIFT		12
> 
> I've also reordered things a little in <libclat.h> so that I can use SZ_4K,
> SZ_16K and SZ_64K here too.

Sounds good to me, as long as we can have PAGE_SIZE and PAGE_SHIFT
defined in assembly too.

Thanks,
drew

