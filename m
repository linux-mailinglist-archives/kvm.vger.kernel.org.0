Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5035FC8B4
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJLPvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 11:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJLPvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 11:51:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93135F2506
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665589901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VEmL4QPQ3D0Tb37hjB24vN30XeOf49ixlW7Qc6HLGRk=;
        b=N2vwEeAi4pEHWErdDO3LHoZ1hlZ/9/i+Llp5S1rjHk4ldi1NWbAjgv225JVxHqOEiFEuVb
        /v8a+WwfCGnrb9cd1SlVywJ5MG3HhsdNVNWzcqAYhPDghUp9U56mpIObQcXlaBOan0AfIU
        9ZlayqvDVq7fJoNtFS+2DlWh6leHams=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-3mROqTtLMuui1SkKdzFrlA-1; Wed, 12 Oct 2022 11:51:40 -0400
X-MC-Unique: 3mROqTtLMuui1SkKdzFrlA-1
Received: by mail-wm1-f72.google.com with SMTP id h205-20020a1c21d6000000b003c56437e529so724917wmh.2
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 08:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEmL4QPQ3D0Tb37hjB24vN30XeOf49ixlW7Qc6HLGRk=;
        b=lq5a1z3Xf7WU1E+zm0QjUgAg+Mauu8FmH62mzKL0OE8aUqJR32t+n4GJhjqFmXSazv
         hUZky1DqZsqnGPqVtTknk6ncaYuIL8//98/ObX/ZITYgvPtUQ69HkMNfYEJKqtFhYXyv
         yJXOq+qk1c9PTeFrFYOLU2lKYRBTGpYh8HTM+Q/j73unwvNrYYANVmrvwM9jkD71Dl5p
         V3awW72znfdSAxlOtCUDNC48PApn8cHiQJjIJCy+haa0ZCCZptDXO1OMMgEd8gTnQGdY
         NRKnKYhpm+MNrpv295IChDFyFPQj6bgnlYGl6rHab6mvTD0r2+RtqeVPTlDpa4T7uaL5
         +aNw==
X-Gm-Message-State: ACrzQf2+ZmoXJctP8LdBhCycDxY/k+l2an8iDfchNi9JPLRPYJOKwZaI
        oMqtkxpRL5J/UDbobgqDdHf1s5fRwnXXAMny7Zsg6xaHmJtQSMTYDpGeFdJJUaDHhpOD6MVDEsC
        3iPppDONQFCqd
X-Received: by 2002:a7b:c047:0:b0:3b4:adc7:1ecb with SMTP id u7-20020a7bc047000000b003b4adc71ecbmr3255632wmc.144.1665589897405;
        Wed, 12 Oct 2022 08:51:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7N8bKAUKvYW6q1makifjzVvultjsSZhoTQJypXKec3ISNPJh+4qwpbqB9CUNsCQPvo9cbiyw==
X-Received: by 2002:a7b:c047:0:b0:3b4:adc7:1ecb with SMTP id u7-20020a7bc047000000b003b4adc71ecbmr3255614wmc.144.1665589897125;
        Wed, 12 Oct 2022 08:51:37 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id d17-20020adfe891000000b0022e62529888sm32297wrm.67.2022.10.12.08.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 08:51:36 -0700 (PDT)
Date:   Wed, 12 Oct 2022 11:51:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        wangdeming@inspur.com, xiujianfeng@huawei.com,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [GIT PULL] virtio: fixes, features
Message-ID: <20221012115023-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
 <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au>
 <87edvdm7qg.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edvdm7qg.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 13, 2022 at 01:33:59AM +1100, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> > [ Cc += Bjorn & linux-pci ]
> >
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> On Wed, Oct 12, 2022 at 05:21:24PM +1100, Michael Ellerman wrote:
> >>> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > ...
> >>> > ----------------------------------------------------------------
> >>> > virtio: fixes, features
> >>> >
> >>> > 9k mtu perf improvements
> >>> > vdpa feature provisioning
> >>> > virtio blk SECURE ERASE support
> >>> >
> >>> > Fixes, cleanups all over the place.
> >>> >
> >>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>> >
> >>> > ----------------------------------------------------------------
> >>> > Alvaro Karsz (1):
> >>> >       virtio_blk: add SECURE ERASE command support
> >>> >
> >>> > Angus Chen (1):
> >>> >       virtio_pci: don't try to use intxif pin is zero
> >>> 
> >>> This commit breaks virtio_pci for me on powerpc, when running as a qemu
> >>> guest.
> >>> 
> >>> vp_find_vqs() bails out because pci_dev->pin == 0.
> >>> 
> >>> But pci_dev->irq is populated correctly, so vp_find_vqs_intx() would
> >>> succeed if we called it - which is what the code used to do.
> >>> 
> >>> I think this happens because pci_dev->pin is not populated in
> >>> pci_assign_irq().
> >>> 
> >>> I would absolutely believe this is bug in our PCI code, but I think it
> >>> may also affect other platforms that use of_irq_parse_and_map_pci().
> >>
> >> How about fixing this in of_irq_parse_and_map_pci then?
> >> Something like the below maybe?
> >> 
> >> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> >> index 196834ed44fe..504c4d75c83f 100644
> >> --- a/drivers/pci/of.c
> >> +++ b/drivers/pci/of.c
> >> @@ -446,6 +446,8 @@ static int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *
> >>  	if (pin == 0)
> >>  		return -ENODEV;
> >>  
> >> +	pdev->pin = pin;
> >> +
> >>  	/* Local interrupt-map in the device node? Use it! */
> >>  	if (of_get_property(dn, "interrupt-map", NULL)) {
> >>  		pin = pci_swizzle_interrupt_pin(pdev, pin);
> 
> Backing up a bit. Should the virtio code be looking at pci_dev->pin in
> the first place?
> 
> Shouldn't it be checking pci_dev->irq instead?
> 
> The original commit talks about irq being 0 and colliding with the timer
> interrupt.
> 
> But all (most?) platforms have converged on 0 meaning NO_IRQ since quite
> a fews ago AFAIK.

Are you sure?

arch/arm/include/asm/irq.h:#ifndef NO_IRQ
arch/arm/include/asm/irq.h:#define NO_IRQ       ((unsigned int)(-1))



> And the timer irq == 0 is a special case AIUI:
>   https://lore.kernel.org/all/CA+55aFwiLp1z+2mzkrFsid1WZQ0TQkcn8F2E6NL_AVR+m1fZ2w@mail.gmail.com/
> 
> cheers

