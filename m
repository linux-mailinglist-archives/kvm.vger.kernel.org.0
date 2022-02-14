Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B12A4B5335
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 15:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242631AbiBNOZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 09:25:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiBNOZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 09:25:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 668754A902
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644848691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wze/pOxU071zBfSSYwszBPcAvyZ+Rsfse07Mt3tnPg=;
        b=eQ7sSKfmPyrGnJbJpgj9R3bd+FMLMAano/BNMt9zOo1gdH4rEDpB3M+4SmHipjAEYMqGH1
        3qQmZiAtDv+T60JzkQChmAadjopIOggKF1hcgmsykOEFN6tCDwsbGxdhWOzi+TNp3NNHQC
        8tcNTH+5xfGoJj7tBZ/X9SslLqwGQA8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-q0_RgjowMpC4m5_KNSAP4w-1; Mon, 14 Feb 2022 09:24:50 -0500
X-MC-Unique: q0_RgjowMpC4m5_KNSAP4w-1
Received: by mail-ej1-f72.google.com with SMTP id mp5-20020a1709071b0500b0069f2ba47b20so5836552ejc.19
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 06:24:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0wze/pOxU071zBfSSYwszBPcAvyZ+Rsfse07Mt3tnPg=;
        b=50iQGberH1fCgkES9fa+O+gZ+A904iCBGeKIWjk/86p256/3eVzt8uo2PDsiURdd/g
         2c8PNzXus9k61ZQQsg7vlJJslDwqS54WToXtB6ymj0mlrqhx7vgVKdL6UqJMVHYvmzDz
         QjBL0fA24ppjZhfJAOXd7rQMMi9rTVFCGIFaN8wo7n84KaE78AmvNsj2ACLZ44AslUAD
         SWJOSQN0fYcnM2rvbsOBgEEOH1RQF6b7hPfP4taffoZpUnZZqP7rvF+Gg381WLPKmuMd
         tIVJz2ohtawvOFSqfhhtTCdOPR3KvC6Gz4XYgW8gxWTQ/cioWuVECJ6uxpyZ59rPI7TF
         dUuw==
X-Gm-Message-State: AOAM531uzjiD/UDDJ7+Bm9lwv6NEZRI5LFjOJ6M4B95GcpaRVG3aPuUO
        CSXwVlGdr++j7KeaY/z1BTbLzKowMj6zo4gucdO+gT6bAkWm0L8WMGPCJmXMHAiCVksnKsCLUSP
        2jk0haSf/UBVA
X-Received: by 2002:a17:907:a40c:: with SMTP id sg12mr5362596ejc.216.1644848689240;
        Mon, 14 Feb 2022 06:24:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXJQrb/1Slqb5cDkZXkufhCWXep3suAkJbSpYCxCjdypeUfm+9g1sR4gWEV8DntzyMHsZcDg==
X-Received: by 2002:a17:907:a40c:: with SMTP id sg12mr5362584ejc.216.1644848689035;
        Mon, 14 Feb 2022 06:24:49 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id z14sm4030733edc.62.2022.02.14.06.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 06:24:48 -0800 (PST)
Date:   Mon, 14 Feb 2022 15:24:44 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220214142444.saeogrpgpx6kaamm@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgphzKLQLb5pMYoP@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:06:04PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Feb 14, 2022 at 02:52:26PM +0100, Andrew Jones wrote:
> > On Mon, Feb 14, 2022 at 12:05:06PM +0000, Alexandru Elisei wrote:
> > > The "linux,initrd-start" and "linux,initrd-end" properties encode the start
> > > and end address of the initrd. The size of the address is encoded in the
> > > root node #address-cells property and can be 1 cell (32 bits) or 2 cells
> > > (64 bits). Add support for parsing a 64 bit address.
> > > 
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > ---
> > >  lib/devicetree.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > index 409d18bedbba..7cf64309a912 100644
> > > --- a/lib/devicetree.c
> > > +++ b/lib/devicetree.c
> > > @@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
> > >  int dt_get_initrd(const char **initrd, u32 *size)
> > >  {
> > >  	const struct fdt_property *prop;
> > > -	const char *start, *end;
> > > +	u64 start, end;
> > >  	int node, len;
> > >  	u32 *data;
> > >  
> > > @@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > >  	if (!prop)
> > >  		return len;
> > >  	data = (u32 *)prop->data;
> > > -	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > +	start = fdt32_to_cpu(*data);
> > > +	if (len == 8) {
> > > +		data++;
> > > +		start = (start << 32) | fdt32_to_cpu(*data);
> > > +	}
> > >  
> > >  	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
> > >  	if (!prop) {
> > > @@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > >  		return len;
> > >  	}
> > >  	data = (u32 *)prop->data;
> > > -	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > +	end = fdt32_to_cpu(*data);
> > > +	if (len == 8) {
> > > +		data++;
> > > +		end = (end << 32) | fdt32_to_cpu(*data);
> > > +	}
> > >  
> > > -	*initrd = start;
> > > -	*size = (unsigned long)end - (unsigned long)start;
> > > +	*initrd = (char *)start;
> > > +	*size = end - start;
> > >  
> > >  	return 0;
> > >  }
> > > -- 
> > > 2.35.1
> > >
> > 
> > I added this patch on
> 
> Thanks for the quick reply!
> 
> > 
> > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > index 7cf64309a912..fa8399a7513d 100644
> > --- a/lib/devicetree.c
> > +++ b/lib/devicetree.c
> > @@ -305,6 +305,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> >         data = (u32 *)prop->data;
> >         start = fdt32_to_cpu(*data);
> >         if (len == 8) {
> > +               assert(sizeof(long) == 8);
> 
> I'm sketchy about arm with LPAE, but wouldn't it be legal to have here a 64
> bit address, even if the architecture is 32 bits? Or was the assert added
> more because kvm-unit-tests doesn't support LPAE on arm?

It's possible, but only if we choose to manage it. We're (I'm) lazy and
require physical addresses to fit in the pointers, at least for the test
framework. Of course a unit test can feel free to play around with larger
physical addresses if it wants to.

> 
> >                 data++;
> >                 start = (start << 32) | fdt32_to_cpu(*data);
> >         }
> > @@ -321,7 +322,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> >                 end = (end << 32) | fdt32_to_cpu(*data);
> >         }
> >  
> > -       *initrd = (char *)start;
> > +       *initrd = (char *)(unsigned long)start;
> 
> My bad here, I forgot to test on arm. Tested your fix and the compilation
> error goes away.

I'm actually kicking myself a bit for the hasty fix, because the assert
would be better done at the end and written something like this

 assert(sizeof(long) == 8 || !(end >> 32));

I'm not sure it's worth adding another patch on top for that now, though.
By the lack of new 32-bit arm unit tests getting submitted, I'm not even
sure it's worth maintaining 32-bit arm at all...

Thanks,
drew

> 
> Thanks,
> Alex
> 
> >         *size = end - start;
> >  
> >         return 0;
> > 
> > 
> > To fix compilation on 32-bit arm.
> > 
> > 
> > And now merged through misc/queue.
> > 
> > Thanks,
> > drew
> > 
> 

