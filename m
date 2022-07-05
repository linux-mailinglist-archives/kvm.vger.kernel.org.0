Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3082E56788D
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 22:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiGEUmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGEUmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 16:42:36 -0400
Received: from mx2.absolutedigital.net (mx2.absolutedigital.net [50.242.207.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 219D2120AE;
        Tue,  5 Jul 2022 13:42:35 -0700 (PDT)
Received: from lancer.cnet.absolutedigital.net (lancer.cnet.absolutedigital.net [10.7.5.10])
        by luxor.inet.absolutedigital.net (8.14.4/8.14.4) with ESMTP id 265Kg5Z7028293
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Tue, 5 Jul 2022 16:42:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by lancer.cnet.absolutedigital.net (8.17.1/8.17.1) with ESMTPS id 265KgHAl008523
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 5 Jul 2022 16:42:18 -0400
Date:   Tue, 5 Jul 2022 16:42:17 -0400 (EDT)
From:   Cal Peake <cp@absolutedigital.net>
To:     Alex Williamson <alex.williamson@redhat.com>
cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCHv2] vgaarb: Add module param to allow for choosing the
 boot VGA device
In-Reply-To: <20220705101535.569f5cac.alex.williamson@redhat.com>
Message-ID: <93acb310-ede4-cd9d-e470-2375971a451@absolutedigital.net>
References: <8498ea9f-2ba9-b5da-7dc4-1588363f1b62@absolutedigital.net> <20220704213829.GA16883@bhelgaas> <20220705101535.569f5cac.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 5 Jul 2022, Alex Williamson wrote:

> > > +	ret = sscanf(input, "%x:%x.%x", &bus, &dev, &func);
> > > +	if (ret != 3) {
> > > +		pr_warn("Improperly formatted PCI ID: %s\n", input);
> > > +		return;
> > > +	}
> 
> See pci_dev_str_match()

Hi Alex, thanks for the feedback. I'll add this if we wind up going with 
some version of my patch.

> > > +	if (boot_vga && boot_vga->is_chosen_one)
> > > +		return false;
> > > +
> > > +	if (bootdev_id == PCI_DEVID(pdev->bus->number, pdev->devfn)) {
> > > +		vgadev->is_chosen_one = true;
> > > +		return true;
> > > +	}
> 
> This seems too simplistic, for example PCI code determines whether the
> ROM is a shadow ROM at 0xc0000 based on whether it's the
> vga_default_device() where that default device is set in
> vga_arbiter_add_pci_device() based on the value returned by
> this vga_is_boot_device() function.  A user wishing to specify the boot
> VGA device doesn't magically make that device's ROM shadowed into this
> location.
> 

I think I understand what you're saying. We're not telling the system what 
the boot device is, it's telling us?

> I also don't see how this actually enables VGA routing to the user
> selected device, where we generally expect the boot device already has
> this enabled.
> 
> Furthermore, what's the initialization state of the selected device, if
> it has not had its option ROM executed, is it necessarily in a state to
> accept VGA commands?  If we're changing the default VGA device, are we
> fully uncoupling from any firmware notions of the console device?
> Thanks,

Unfortunately, I'm not the best qualified to answer these questions. My 
understanding is mostly surface-level until I start digging into the code.

I think the answer to most of them though might be that the UEFI firmware
initializes both cards.

During POST, I do get output on both GPUs. One gets the static BIOS text 
(Copyright AMI etc.) -- this is the one selected as boot device -- and the 
other gets the POST-code counting up.

Once the firmware hands off to the bootloader, whichever GPU has the 
active display (both GPUs go to the same display, the input source gets 
switched depending on whether I'm using the host or the VM) is where 
the bootloader output is.

When the bootloader hands off to the kernel, the boot device chosen by the 
firmware gets the kernel output. If that's the host GPU, then everything 
is fine.

If that's the VM GPU, then it gets the kernel output until the vfio-pci 
driver loads and then all output stops. Back on the host GPU, the screen 
is black until the X server spawns[1] but I get no VTs.

With my patch, telling the arbiter that the host GPU is always the boot 
device results in everything just working.

With all that said, if you feel this isn't the right way to go, do you 
have any thoughts on what would be a better path to try?

Thanks,

-- 
Cal Peake

[1] I said in a previous email that this only happened when I set 
VGA_ARB_MAX_GPUS=1, but after doing some more testing just now, it seems I 
was wrong and the X server was just taking longer than expected to load.
