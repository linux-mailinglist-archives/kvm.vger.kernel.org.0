Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAE4B6469
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 08:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbiBOHca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 02:32:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiBOHc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 02:32:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEE38C2E43
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644910337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=achRbqhyCCDQhVItiwWP6Eh3xnYDLzUmuiz1oOkMRao=;
        b=DLHiLcMVHHx+r5gYkuGDBPQUz+/hKRoEUuFGrUHZAC1V46GeXvISHzqPo9obd1+GBIFbFL
        +svf0zG9iwMshEoL83ybULkPdAH7OqK4oUVNQnhItXVBJEa7x8X+apAhJPuvNNANz8NkCc
        3r8VtRLE5JL6mPmdFeVJhZqMfROTIh8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-VUtq2J3IMva6VF9esL2-2Q-1; Tue, 15 Feb 2022 02:32:16 -0500
X-MC-Unique: VUtq2J3IMva6VF9esL2-2Q-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a056402354900b0040fb9c35a02so11850765edd.18
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:32:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=achRbqhyCCDQhVItiwWP6Eh3xnYDLzUmuiz1oOkMRao=;
        b=jwBjoy2zjnTBnWoUn02LKl2dlSmwSHjMwTWX7qWGn1St4FSr4ZJLyBmeh3NBRotEE6
         hSS/Um6Xx8UkAe0NqcSma5mweFUIul7BqkX4RvvTyBqPNe/n2ca8Q4Obl+OE3xLD4G9/
         R1bTCujjFhJ91MhYm7ZLmRHRKa/ky0IT1nZ+d56KGLphbHPkt2EmulYV9USt+QtSv7OA
         nnupn/2LHQ47JQzJ9OCBo2ffxSCb2BYa27NwvafAd6V3opLleMA4qbmgTRkTvMw+5NFQ
         2MEqHpTKcDYRRsQMaRKe+J8Cf1RVY8z8ns4aQEZNahHb7RSxNBe71LY9Sku5cchh56Jj
         /0hg==
X-Gm-Message-State: AOAM531jvetmTNE8BoHQQac6i/dKR9xjj26vEAl+b1qwhtrHrn1YoPLl
        S9wpxed7vfoZerSz6/CTJsElLnbwgcP+GCs7G1kUt/LVNEZSmFhqfWihcbzngB9jiv/4Zqo/OaD
        CLG7+P9qNKVS5
X-Received: by 2002:a17:906:82c8:: with SMTP id a8mr2015081ejy.438.1644910335216;
        Mon, 14 Feb 2022 23:32:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzh+2/D7llSlv2IUnNdNi2fmzIBrNRx9zbtD+lDt+T6TdLYC1Bn7dAu/Bps6cWx+cn4nN7Lnw==
X-Received: by 2002:a17:906:82c8:: with SMTP id a8mr2015071ejy.438.1644910335005;
        Mon, 14 Feb 2022 23:32:15 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id 5sm2730174ejq.131.2022.02.14.23.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 23:32:14 -0800 (PST)
Date:   Tue, 15 Feb 2022 08:32:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220215073212.fp5lh4gfxk7clwwc@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
 <87k0dx4c23.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0dx4c23.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 05:01:40PM +0000, Marc Zyngier wrote:
> Hi all,
> 
> On Mon, 14 Feb 2022 16:20:13 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Drew,
> > 
> > (CC'ing Marc, he know more about 32 bit guest support than me)
> > 
> > On Mon, Feb 14, 2022 at 03:24:44PM +0100, Andrew Jones wrote:
> > > On Mon, Feb 14, 2022 at 02:06:04PM +0000, Alexandru Elisei wrote:
> > > > Hi Drew,
> > > > 
> > > > On Mon, Feb 14, 2022 at 02:52:26PM +0100, Andrew Jones wrote:
> > > > > On Mon, Feb 14, 2022 at 12:05:06PM +0000, Alexandru Elisei wrote:
> > > > > > The "linux,initrd-start" and "linux,initrd-end" properties encode the start
> > > > > > and end address of the initrd. The size of the address is encoded in the
> > > > > > root node #address-cells property and can be 1 cell (32 bits) or 2 cells
> > > > > > (64 bits). Add support for parsing a 64 bit address.
> > > > > > 
> > > > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > > ---
> > > > > >  lib/devicetree.c | 18 +++++++++++++-----
> > > > > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > > > > index 409d18bedbba..7cf64309a912 100644
> > > > > > --- a/lib/devicetree.c
> > > > > > +++ b/lib/devicetree.c
> > > > > > @@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
> > > > > >  int dt_get_initrd(const char **initrd, u32 *size)
> > > > > >  {
> > > > > >  	const struct fdt_property *prop;
> > > > > > -	const char *start, *end;
> > > > > > +	u64 start, end;
> > > > > >  	int node, len;
> > > > > >  	u32 *data;
> > > > > >  
> > > > > > @@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > > >  	if (!prop)
> > > > > >  		return len;
> > > > > >  	data = (u32 *)prop->data;
> > > > > > -	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > > > +	start = fdt32_to_cpu(*data);
> > > > > > +	if (len == 8) {
> > > > > > +		data++;
> > > > > > +		start = (start << 32) | fdt32_to_cpu(*data);
> > > > > > +	}
> > > > > >  
> > > > > >  	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
> > > > > >  	if (!prop) {
> > > > > > @@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > > >  		return len;
> > > > > >  	}
> > > > > >  	data = (u32 *)prop->data;
> > > > > > -	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > > > +	end = fdt32_to_cpu(*data);
> > > > > > +	if (len == 8) {
> > > > > > +		data++;
> > > > > > +		end = (end << 32) | fdt32_to_cpu(*data);
> > > > > > +	}
> > > > > >  
> > > > > > -	*initrd = start;
> > > > > > -	*size = (unsigned long)end - (unsigned long)start;
> > > > > > +	*initrd = (char *)start;
> > > > > > +	*size = end - start;
> > > > > >  
> > > > > >  	return 0;
> > > > > >  }
> > > > > > -- 
> > > > > > 2.35.1
> > > > > >
> > > > > 
> > > > > I added this patch on
> > > > 
> > > > Thanks for the quick reply!
> > > > 
> > > > > 
> > > > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > > > index 7cf64309a912..fa8399a7513d 100644
> > > > > --- a/lib/devicetree.c
> > > > > +++ b/lib/devicetree.c
> > > > > @@ -305,6 +305,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > >         data = (u32 *)prop->data;
> > > > >         start = fdt32_to_cpu(*data);
> > > > >         if (len == 8) {
> > > > > +               assert(sizeof(long) == 8);
> > > > 
> > > > I'm sketchy about arm with LPAE, but wouldn't it be legal to have here a 64
> > > > bit address, even if the architecture is 32 bits? Or was the assert added
> > > > more because kvm-unit-tests doesn't support LPAE on arm?
> > > 
> > > It's possible, but only if we choose to manage it. We're (I'm) lazy and
> > > require physical addresses to fit in the pointers, at least for the test
> > > framework. Of course a unit test can feel free to play around with larger
> > > physical addresses if it wants to.
> > > 
> > > > 
> > > > >                 data++;
> > > > >                 start = (start << 32) | fdt32_to_cpu(*data);
> > > > >         }
> > > > > @@ -321,7 +322,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > >                 end = (end << 32) | fdt32_to_cpu(*data);
> > > > >         }
> > > > >  
> > > > > -       *initrd = (char *)start;
> > > > > +       *initrd = (char *)(unsigned long)start;
> > > > 
> > > > My bad here, I forgot to test on arm. Tested your fix and the compilation
> > > > error goes away.
> > > 
> > > I'm actually kicking myself a bit for the hasty fix, because the assert
> > > would be better done at the end and written something like this
> > > 
> > >  assert(sizeof(long) == 8 || !(end >> 32));
> > > 
> > > I'm not sure it's worth adding another patch on top for that now, though.
> > > By the lack of new 32-bit arm unit tests getting submitted, I'm not even
> > > sure it's worth maintaining 32-bit arm at all...
> > 
> > As far as I know, 32 bit guests are still very much supported and
> > maintained for KVM, so I think it would still be very useful to have the
> > tests.
> 
> I can't force people to write additional tests (or even start writing
> the first one), but I'd like to reaffirm that AArch32 support still is
> a first class citizen when it comes to KVM/arm64.
> 
> It has been tremendously useful even in the very recent past to debug
> issues that were plaguing bare metal Linux, and i don't plan to get
> rid of it anytime soon (TBH, it is too small to even be noticeable).
>

OK, let's keep 32-bit arm support in kvm-unit-tests, at least as long as
we can find hardware to test it with (I still have access to a mustang).

Does kvmtool support launching AArch32 guests? If so, then I suppose we
should also test kvmtool + 32-bit arm kvm-unit-tests.

Thanks,
drew

