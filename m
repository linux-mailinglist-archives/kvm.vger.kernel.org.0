Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343384B55F1
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356291AbiBNQUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:20:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356275AbiBNQUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:20:07 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18D695FF0B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:19:59 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FEDA13D5;
        Mon, 14 Feb 2022 08:19:58 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E07AD3F70D;
        Mon, 14 Feb 2022 08:19:56 -0800 (PST)
Date:   Mon, 14 Feb 2022 16:20:13 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <YgqBPSV+CMyzfNlv@monolith.localdoman>
References: <20220214120506.30617-1-alexandru.elisei@arm.com>
 <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214142444.saeogrpgpx6kaamm@gator>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

(CC'ing Marc, he know more about 32 bit guest support than me)

On Mon, Feb 14, 2022 at 03:24:44PM +0100, Andrew Jones wrote:
> On Mon, Feb 14, 2022 at 02:06:04PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Mon, Feb 14, 2022 at 02:52:26PM +0100, Andrew Jones wrote:
> > > On Mon, Feb 14, 2022 at 12:05:06PM +0000, Alexandru Elisei wrote:
> > > > The "linux,initrd-start" and "linux,initrd-end" properties encode the start
> > > > and end address of the initrd. The size of the address is encoded in the
> > > > root node #address-cells property and can be 1 cell (32 bits) or 2 cells
> > > > (64 bits). Add support for parsing a 64 bit address.
> > > > 
> > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > ---
> > > >  lib/devicetree.c | 18 +++++++++++++-----
> > > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > > index 409d18bedbba..7cf64309a912 100644
> > > > --- a/lib/devicetree.c
> > > > +++ b/lib/devicetree.c
> > > > @@ -288,7 +288,7 @@ int dt_get_default_console_node(void)
> > > >  int dt_get_initrd(const char **initrd, u32 *size)
> > > >  {
> > > >  	const struct fdt_property *prop;
> > > > -	const char *start, *end;
> > > > +	u64 start, end;
> > > >  	int node, len;
> > > >  	u32 *data;
> > > >  
> > > > @@ -303,7 +303,11 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > >  	if (!prop)
> > > >  		return len;
> > > >  	data = (u32 *)prop->data;
> > > > -	start = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > +	start = fdt32_to_cpu(*data);
> > > > +	if (len == 8) {
> > > > +		data++;
> > > > +		start = (start << 32) | fdt32_to_cpu(*data);
> > > > +	}
> > > >  
> > > >  	prop = fdt_get_property(fdt, node, "linux,initrd-end", &len);
> > > >  	if (!prop) {
> > > > @@ -311,10 +315,14 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > > >  		return len;
> > > >  	}
> > > >  	data = (u32 *)prop->data;
> > > > -	end = (const char *)(unsigned long)fdt32_to_cpu(*data);
> > > > +	end = fdt32_to_cpu(*data);
> > > > +	if (len == 8) {
> > > > +		data++;
> > > > +		end = (end << 32) | fdt32_to_cpu(*data);
> > > > +	}
> > > >  
> > > > -	*initrd = start;
> > > > -	*size = (unsigned long)end - (unsigned long)start;
> > > > +	*initrd = (char *)start;
> > > > +	*size = end - start;
> > > >  
> > > >  	return 0;
> > > >  }
> > > > -- 
> > > > 2.35.1
> > > >
> > > 
> > > I added this patch on
> > 
> > Thanks for the quick reply!
> > 
> > > 
> > > diff --git a/lib/devicetree.c b/lib/devicetree.c
> > > index 7cf64309a912..fa8399a7513d 100644
> > > --- a/lib/devicetree.c
> > > +++ b/lib/devicetree.c
> > > @@ -305,6 +305,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > >         data = (u32 *)prop->data;
> > >         start = fdt32_to_cpu(*data);
> > >         if (len == 8) {
> > > +               assert(sizeof(long) == 8);
> > 
> > I'm sketchy about arm with LPAE, but wouldn't it be legal to have here a 64
> > bit address, even if the architecture is 32 bits? Or was the assert added
> > more because kvm-unit-tests doesn't support LPAE on arm?
> 
> It's possible, but only if we choose to manage it. We're (I'm) lazy and
> require physical addresses to fit in the pointers, at least for the test
> framework. Of course a unit test can feel free to play around with larger
> physical addresses if it wants to.
> 
> > 
> > >                 data++;
> > >                 start = (start << 32) | fdt32_to_cpu(*data);
> > >         }
> > > @@ -321,7 +322,7 @@ int dt_get_initrd(const char **initrd, u32 *size)
> > >                 end = (end << 32) | fdt32_to_cpu(*data);
> > >         }
> > >  
> > > -       *initrd = (char *)start;
> > > +       *initrd = (char *)(unsigned long)start;
> > 
> > My bad here, I forgot to test on arm. Tested your fix and the compilation
> > error goes away.
> 
> I'm actually kicking myself a bit for the hasty fix, because the assert
> would be better done at the end and written something like this
> 
>  assert(sizeof(long) == 8 || !(end >> 32));
> 
> I'm not sure it's worth adding another patch on top for that now, though.
> By the lack of new 32-bit arm unit tests getting submitted, I'm not even
> sure it's worth maintaining 32-bit arm at all...

As far as I know, 32 bit guests are still very much supported and
maintained for KVM, so I think it would still be very useful to have the
tests.

Thanks,
Alex

> 
> Thanks,
> drew
> 
> > 
> > Thanks,
> > Alex
> > 
> > >         *size = end - start;
> > >  
> > >         return 0;
> > > 
> > > 
> > > To fix compilation on 32-bit arm.
> > > 
> > > 
> > > And now merged through misc/queue.
> > > 
> > > Thanks,
> > > drew
> > > 
> > 
> 
