Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690CC4B56E6
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbiBNQhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:37:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356452AbiBNQhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:37:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75E4560DB4
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644856606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2OEa72EQ8Dzcgxpa3aeT06+a/RxJ+ZVfGvY5y5gC+rw=;
        b=W9u6O7ecg4mIg8FVYPBw65l46+GcKxwdjH8r67+6PLvI7/MzQcSRpwV9BePp6F7tLpTIpt
        VFORSLYjQv0wVKBokhopJ26NqV6DWUhoA9i/1Aj60I1ilNbKZHMDpFnhLRzBxgcMd3YQYK
        dw0IYzdklO1YQ+dg9EB5XJw75Ab3z7c=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-NtihZFZ5PRuwdEqVhAMjtg-1; Mon, 14 Feb 2022 11:36:45 -0500
X-MC-Unique: NtihZFZ5PRuwdEqVhAMjtg-1
Received: by mail-ed1-f71.google.com with SMTP id l3-20020a50cbc3000000b0041083c11173so5260038edi.4
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2OEa72EQ8Dzcgxpa3aeT06+a/RxJ+ZVfGvY5y5gC+rw=;
        b=gEDR7mnmhowXuoTI3DfhlY07DX4M/YbxcTAiOjaOPUQjA9WPCzohRZTuUHGxzIsMFM
         oDjR4YfRe6yzIPkZdtySOj+1AUTlaDq24cEsS5OJ9ZH2ZJkHZVQCNXY7hA/lsiRR4TtJ
         H0BCY+aU2NLAapYP5kvUd3nZqdSavm8Fd48aaoqpQTus/LNwljINiacg5tJlGjFvJVwJ
         yRkaSNsTjGB+rvJ7wcJUJlRNr1FPD5Ruh3SznviREoE5cTIeJjM9I43Vm900185foCKB
         PvqXArNRSXDCDUAxqGcxdeLTFqb67l2qRm169bSKc1ycNSCX/QaiSit0RhbLx+oZ/aF2
         F13Q==
X-Gm-Message-State: AOAM530zsFuW7f422/Dnt2BmviTH9dXrq4/7SPQ1rlMZ7oy+XxCm1kkX
        5ixNT1cazJ8e8OnRqUOiTaCsjdtFaS3x5JD9s0pmBwv9kWkF/yLJ4qkP8X7ACv/zsTjFTbXuAAr
        p9X+3sBbQQPMX
X-Received: by 2002:a17:906:7a48:: with SMTP id i8mr351609ejo.278.1644856604093;
        Mon, 14 Feb 2022 08:36:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8AsGG0zLOHHh2Gpt4Zd+gFtAhjKFIMum3Q6d9b06t2yCvf4ZN1s1xT1ZMPCF5uxAo97Fw6Q==
X-Received: by 2002:a17:906:7a48:: with SMTP id i8mr351595ejo.278.1644856603831;
        Mon, 14 Feb 2022 08:36:43 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id r16sm9953228edv.80.2022.02.14.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 08:36:43 -0800 (PST)
Date:   Mon, 14 Feb 2022 17:36:41 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <20220214163641.tx3mzunt5oecxrxl@gator>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgqBPSV+CMyzfNlv@monolith.localdoman>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 04:20:13PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> (CC'ing Marc, he know more about 32 bit guest support than me)
> 
> On Mon, Feb 14, 2022 at 03:24:44PM +0100, Andrew Jones wrote:
> > On Mon, Feb 14, 2022 at 02:06:04PM +0000, Alexandru Elisei wrote:
> > > Hi Drew,
> > > 
> > > On Mon, Feb 14, 2022 at 02:52:26PM +0100, Andrew Jones wrote:
> > > > On Mon, Feb 14, 2022 at 12:05:06PM +0000, Alexandru Elisei wrote:
> > > > > The "linux,initrd-start" and "linux,initrd-end" properties encode the start
> > > > > and end address of the initrd. The size of the address is encoded in the
> > > > > root node #address-cells property and can be 1 cell (32 bits) or 2 cells
> > > > > (64 bits). Add support for parsing a 64 bit address.
> > > > > 
> > > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > ---
> > > > >  lib/devicetree.c | 18 +++++++++++++-----
> > > > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > > > index 409d18bedbba..7cf64309a912 100644
> > > > > --- a/lib/devicetree.c
> > > > > +++ b/lib/devicetree.c
> > > > > @@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
> > > > >  int dt_get_initrd(const char **initrd, u32 *size)
> > > > >  {
> > > > >  	const struct fdt_property *prop;
> > > > > -	const char *start, *end;
> > > > > +	u64 start, end;
> > > > >  	int node, len;
> > > > >  	u32 *data;
> > > > >  
> > > > > @@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > >  	if (!prop)
> > > > >  		return len;
> > > > >  	data = (u32 *)prop->data;
> > > > > -	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > > +	start = fdt32_to_cpu(*data);
> > > > > +	if (len == 8) {
> > > > > +		data++;
> > > > > +		start = (start << 32) | fdt32_to_cpu(*data);
> > > > > +	}
> > > > >  
> > > > >  	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
> > > > >  	if (!prop) {
> > > > > @@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > > >  		return len;
> > > > >  	}
> > > > >  	data = (u32 *)prop->data;
> > > > > -	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > > +	end = fdt32_to_cpu(*data);
> > > > > +	if (len == 8) {
> > > > > +		data++;
> > > > > +		end = (end << 32) | fdt32_to_cpu(*data);
> > > > > +	}
> > > > >  
> > > > > -	*initrd = start;
> > > > > -	*size = (unsigned long)end - (unsigned long)start;
> > > > > +	*initrd = (char *)start;
> > > > > +	*size = end - start;
> > > > >  
> > > > >  	return 0;
> > > > >  }
> > > > > -- 
> > > > > 2.35.1
> > > > >
> > > > 
> > > > I added this patch on
> > > 
> > > Thanks for the quick reply!
> > > 
> > > > 
> > > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > > index 7cf64309a912..fa8399a7513d 100644
> > > > --- a/lib/devicetree.c
> > > > +++ b/lib/devicetree.c
> > > > @@ -305,6 +305,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > >         data = (u32 *)prop->data;
> > > >         start = fdt32_to_cpu(*data);
> > > >         if (len == 8) {
> > > > +               assert(sizeof(long) == 8);
> > > 
> > > I'm sketchy about arm with LPAE, but wouldn't it be legal to have here a 64
> > > bit address, even if the architecture is 32 bits? Or was the assert added
> > > more because kvm-unit-tests doesn't support LPAE on arm?
> > 
> > It's possible, but only if we choose to manage it. We're (I'm) lazy and
> > require physical addresses to fit in the pointers, at least for the test
> > framework. Of course a unit test can feel free to play around with larger
> > physical addresses if it wants to.
> > 
> > > 
> > > >                 data++;
> > > >                 start = (start << 32) | fdt32_to_cpu(*data);
> > > >         }
> > > > @@ -321,7 +322,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > >                 end = (end << 32) | fdt32_to_cpu(*data);
> > > >         }
> > > >  
> > > > -       *initrd = (char *)start;
> > > > +       *initrd = (char *)(unsigned long)start;
> > > 
> > > My bad here, I forgot to test on arm. Tested your fix and the compilation
> > > error goes away.
> > 
> > I'm actually kicking myself a bit for the hasty fix, because the assert
> > would be better done at the end and written something like this
> > 
> >  assert(sizeof(long) == 8 || !(end >> 32));
> > 
> > I'm not sure it's worth adding another patch on top for that now, though.
> > By the lack of new 32-bit arm unit tests getting submitted, I'm not even
> > sure it's worth maintaining 32-bit arm at all...
> 
> As far as I know, 32 bit guests are still very much supported and
> maintained for KVM, so I think it would still be very useful to have the
> tests.

But we don't really have that many tests and, while people have started
submitting more tests now, which is great, they're only submitting them
for AArch64. I wonder how much kvm-unit-tests is helping with AArch32
guest support, if at all.

Thanks,
drew

> 
> Thanks,
> Alex
> 
> > 
> > Thanks,
> > drew
> > 
> > > 
> > > Thanks,
> > > Alex
> > > 
> > > >         *size = end - start;
> > > >  
> > > >         return 0;
> > > > 
> > > > 
> > > > To fix compilation on 32-bit arm.
> > > > 
> > > > 
> > > > And now merged through misc/queue.
> > > > 
> > > > Thanks,
> > > > drew
> > > > 
> > > 
> > 
> 

