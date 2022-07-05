Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA66E567403
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiGEQPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGEQPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 12:15:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA0B51D0D9
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 09:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657037741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4Q/2dqWDjkZY0WPpT8x7ipzlESmHSOD8ijO+/Hy+KY=;
        b=TSmLqdHKZ4IeyxvY9yCQhIaKg1co+yhvqPD3Btc1uCv+UKMwgkO2Y+HTBpmeNGJy+acCWP
        tPuyWUUwXmFLDXsTlbK8hdWCpdF97UgrcGO+TDrXaRp1qd0xSg/we4xTW1gGniL7hhdR+h
        vRZuSZ0wL6bPCjIqPy/8IeghK99KQp8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-YSIaRLWdPziu3VLEivoAsg-1; Tue, 05 Jul 2022 12:15:38 -0400
X-MC-Unique: YSIaRLWdPziu3VLEivoAsg-1
Received: by mail-il1-f197.google.com with SMTP id y13-20020a056e021bed00b002dc2f0ab426so186986ilv.14
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 09:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=g4Q/2dqWDjkZY0WPpT8x7ipzlESmHSOD8ijO+/Hy+KY=;
        b=NHrSu7wk88fZMZAQBcLkjSwuWnM4+D0lyMzPanWSLfyqEbiLf0qKYRa5TyPVEAm/Ia
         wN+t75qPKt53OfHpmqA9i6LMBTZYyXWNfZYjMCsKWIFPb4rdOq3wWtkJKiUBQx/TCQ0X
         lSKnlKZd1lXPx1c1+HNTxbI+SuGHIkxuRg3MexcsBE1/VwGUPL3CiESqeT6w9O+SmNGv
         5SUqMHT8xcCn8MrHZclSWRmm50UV/530ZDreZWMLazvvGT1G6btbY0mf4yqPVTWzT9IC
         wcpAyguyOn1EjsOP9IeAb2HSxIkoilYEWenR6oYHpq5GLQPIW+Gi4hchqsYHtqQRCUxj
         sjOQ==
X-Gm-Message-State: AJIora9VMk0LoDtoCbfqQXdbCIaoi9CTQWLZHRKCESNULLX/cCTFs46y
        MRozhHvbkY/M46Qc6Z883TBoBg4MH2tQ0/HcQsNEIHr+fPWbASyaH6zDMPcCiIDZ6I1m4YycYR0
        3/lV56qHJjEnK
X-Received: by 2002:a05:6e02:1c0d:b0:2da:8116:a568 with SMTP id l13-20020a056e021c0d00b002da8116a568mr20607898ilh.98.1657037737497;
        Tue, 05 Jul 2022 09:15:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1stpDHQwLlqX6IsIE8fqhgKCLFZJ9+qtyeJtYkZuouyxb5//Yrsfidgv3tpizzsc+RHLWWz6A==
X-Received: by 2002:a05:6e02:1c0d:b0:2da:8116:a568 with SMTP id l13-20020a056e021c0d00b002da8116a568mr20607880ilh.98.1657037737230;
        Tue, 05 Jul 2022 09:15:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id co14-20020a0566383e0e00b0033efe711a37sm224071jab.35.2022.07.05.09.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 09:15:36 -0700 (PDT)
Date:   Tue, 5 Jul 2022 10:15:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Cal Peake <cp@absolutedigital.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCHv2] vgaarb: Add module param to allow for choosing the
 boot VGA device
Message-ID: <20220705101535.569f5cac.alex.williamson@redhat.com>
In-Reply-To: <20220704213829.GA16883@bhelgaas>
References: <8498ea9f-2ba9-b5da-7dc4-1588363f1b62@absolutedigital.net>
        <20220704213829.GA16883@bhelgaas>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Jul 2022 16:38:29 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Alex, Cornelia, kvm]
> 
> On Mon, Jul 04, 2022 at 05:12:44PM -0400, Cal Peake wrote:
> > Add module parameter 'bootdev' to the VGA arbiter to allow the user
> > to choose which PCI device should be selected over any others as the
> > boot VGA device.
> > 
> > When using a multi-GPU system with one or more GPUs being used in
> > conjunction with VFIO for passthrough to a virtual machine, if the
> > VGA arbiter settles on a passthrough GPU as the boot VGA device,
> > once the VFIO PCI driver claims that GPU, all display output is lost
> > and the result is blank screens and no VT access.  
> 
> I cc'd KVM folks in case they have anything to add here because I'm
> not a VFIO passthrough expert.
> 
> It sounds like the problem occurs when the VFIO driver claims the GPU.
> I assume that happens after boot, when setting up for the virtual
> machine?  If so, is there a way to avoid the problem at run-time so
> the admin doesn't have to decide at boot-time which GPU will be passed
> through to a VM?  Is it possible or desirable to pass through GPU A to
> VM A, then after VM A exits, pass through GPU B to VM B?
> 
> > Signed-off-by: Cal Peake <cp@absolutedigital.net>
> > ---
> >  .../admin-guide/kernel-parameters.txt         |  7 ++++
> >  drivers/pci/vgaarb.c                          | 40 +++++++++++++++++++
> >  2 files changed, 47 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 2522b11e593f..21ac87f4a8a9 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -6518,6 +6518,13 @@
> >  			This is actually a boot loader parameter; the value is
> >  			passed to the kernel using a special protocol.
> >  
> > +	vgaarb.bootdev=	[PCI] Specify the PCI ID (e.g. 0e:00.0) of the
> > +			device to use as the boot VGA device, overriding
> > +			the heuristic used to normally determine which
> > +			of the eligible VGA devices to use. If the device
> > +			specified is not valid or not eligible, then we
> > +			fallback to the heuristic.
> > +
> >  	vm_debug[=options]	[KNL] Available with CONFIG_DEBUG_VM=y.
> >  			May slow down system boot speed, especially when
> >  			enabled on systems with a large amount of memory.
> > diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> > index f80b6ec88dc3..d3689b7dc63d 100644
> > --- a/drivers/pci/vgaarb.c
> > +++ b/drivers/pci/vgaarb.c
> > @@ -35,6 +35,34 @@
> >  
> >  #include <linux/vgaarb.h>
> >  
> > +static char *bootdev __initdata;
> > +module_param(bootdev, charp, 0);
> > +MODULE_PARM_DESC(bootdev, "Force boot device to the specified PCI ID");
> > +
> > +/*
> > + * Initialize to the last possible ID to have things work as normal
> > + * when no 'bootdev' option is supplied. We especially do not want
> > + * this to be zero (0) since that is a valid PCI ID (00:00.0).
> > + */
> > +static u16 bootdev_id = 0xffff;
> > +
> > +static void __init parse_bootdev(char *input)
> > +{
> > +	unsigned int bus, dev, func;
> > +	int ret;
> > +
> > +	if (input == NULL)
> > +		return;
> > +
> > +	ret = sscanf(input, "%x:%x.%x", &bus, &dev, &func);
> > +	if (ret != 3) {
> > +		pr_warn("Improperly formatted PCI ID: %s\n", input);
> > +		return;
> > +	}

See pci_dev_str_match()

> > +
> > +	bootdev_id = PCI_DEVID(bus, PCI_DEVFN(dev, func));
> > +}
> > +
> >  static void vga_arbiter_notify_clients(void);
> >  /*
> >   * We keep a list of all vga devices in the system to speed
> > @@ -53,6 +81,7 @@ struct vga_device {
> >  	bool bridge_has_one_vga;
> >  	bool is_firmware_default;	/* device selected by firmware */
> >  	unsigned int (*set_decode)(struct pci_dev *pdev, bool decode);
> > +	bool is_chosen_one;		/* device specified on command line */
> >  };
> >  
> >  static LIST_HEAD(vga_list);
> > @@ -605,6 +634,7 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
> >  
> >  	/*
> >  	 * We select the default VGA device in this order:
> > +	 *   User specified device (see module param bootdev=)
> >  	 *   Firmware framebuffer (see vga_arb_select_default_device())
> >  	 *   Legacy VGA device (owns VGA_RSRC_LEGACY_MASK)
> >  	 *   Non-legacy integrated device (see vga_arb_select_default_device())
> > @@ -612,6 +642,14 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
> >  	 *   Other device (see vga_arb_select_default_device())
> >  	 */
> >  
> > +	if (boot_vga && boot_vga->is_chosen_one)
> > +		return false;
> > +
> > +	if (bootdev_id == PCI_DEVID(pdev->bus->number, pdev->devfn)) {
> > +		vgadev->is_chosen_one = true;
> > +		return true;
> > +	}

This seems too simplistic, for example PCI code determines whether the
ROM is a shadow ROM at 0xc0000 based on whether it's the
vga_default_device() where that default device is set in
vga_arbiter_add_pci_device() based on the value returned by
this vga_is_boot_device() function.  A user wishing to specify the boot
VGA device doesn't magically make that device's ROM shadowed into this
location.

I also don't see how this actually enables VGA routing to the user
selected device, where we generally expect the boot device already has
this enabled.

Furthermore, what's the initialization state of the selected device, if
it has not had its option ROM executed, is it necessarily in a state to
accept VGA commands?  If we're changing the default VGA device, are we
fully uncoupling from any firmware notions of the console device?
Thanks,

Alex


> > +
> >  	/*
> >  	 * We always prefer a firmware default device, so if we've already
> >  	 * found one, there's no need to consider vgadev.
> > @@ -1544,6 +1582,8 @@ static int __init vga_arb_device_init(void)
> >  	int rc;
> >  	struct pci_dev *pdev;
> >  
> > +	parse_bootdev(bootdev);
> > +
> >  	rc = misc_register(&vga_arb_device);
> >  	if (rc < 0)
> >  		pr_err("error %d registering device\n", rc);
> > -- 
> > 2.35.3
> >   
> 

