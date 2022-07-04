Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD8565F23
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 23:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiGDVig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 17:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiGDVie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 17:38:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE86109B;
        Mon,  4 Jul 2022 14:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83BCEB815AD;
        Mon,  4 Jul 2022 21:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7506C3411E;
        Mon,  4 Jul 2022 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656970711;
        bh=TzsxamouTvFA9fjOheBpTB5MDhQdWqERUOoGtzJiSeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hlMJj1w996yxyx1FGItAfWUuCPkrrxJ6bNROWAT0UyClXOUe8xW+6rY5Cb59xjo5M
         AeDSJH2jHuBhiPaWxV9rUK/loybh9USXUYm3ZmOX3x7peAwI0MQK+cY4tYQJ5tXtpo
         alvjNE8BMnYxbXeC2LA7VkagFQvYwDRsLyLBXec6BzCJVebcG13Hf+ChFMk32Fx2xD
         U6XdefkkF42sLLaPZUIGy6bvZHHh0+SD6SvKmhqqczJXwmd936g5iO/ikIipY7RxUW
         ykItKgiuMEuKJhZWc2zmc1Kagpek4hPWkFy27S+U89OwLrOEBSVBukppeRMLuVa4QJ
         IgEMqyx3IxEuQ==
Date:   Mon, 4 Jul 2022 16:38:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Cal Peake <cp@absolutedigital.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCHv2] vgaarb: Add module param to allow for choosing the
 boot VGA device
Message-ID: <20220704213829.GA16883@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8498ea9f-2ba9-b5da-7dc4-1588363f1b62@absolutedigital.net>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Alex, Cornelia, kvm]

On Mon, Jul 04, 2022 at 05:12:44PM -0400, Cal Peake wrote:
> Add module parameter 'bootdev' to the VGA arbiter to allow the user
> to choose which PCI device should be selected over any others as the
> boot VGA device.
> 
> When using a multi-GPU system with one or more GPUs being used in
> conjunction with VFIO for passthrough to a virtual machine, if the
> VGA arbiter settles on a passthrough GPU as the boot VGA device,
> once the VFIO PCI driver claims that GPU, all display output is lost
> and the result is blank screens and no VT access.

I cc'd KVM folks in case they have anything to add here because I'm
not a VFIO passthrough expert.

It sounds like the problem occurs when the VFIO driver claims the GPU.
I assume that happens after boot, when setting up for the virtual
machine?  If so, is there a way to avoid the problem at run-time so
the admin doesn't have to decide at boot-time which GPU will be passed
through to a VM?  Is it possible or desirable to pass through GPU A to
VM A, then after VM A exits, pass through GPU B to VM B?

> Signed-off-by: Cal Peake <cp@absolutedigital.net>
> ---
>  .../admin-guide/kernel-parameters.txt         |  7 ++++
>  drivers/pci/vgaarb.c                          | 40 +++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 2522b11e593f..21ac87f4a8a9 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6518,6 +6518,13 @@
>  			This is actually a boot loader parameter; the value is
>  			passed to the kernel using a special protocol.
>  
> +	vgaarb.bootdev=	[PCI] Specify the PCI ID (e.g. 0e:00.0) of the
> +			device to use as the boot VGA device, overriding
> +			the heuristic used to normally determine which
> +			of the eligible VGA devices to use. If the device
> +			specified is not valid or not eligible, then we
> +			fallback to the heuristic.
> +
>  	vm_debug[=options]	[KNL] Available with CONFIG_DEBUG_VM=y.
>  			May slow down system boot speed, especially when
>  			enabled on systems with a large amount of memory.
> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
> index f80b6ec88dc3..d3689b7dc63d 100644
> --- a/drivers/pci/vgaarb.c
> +++ b/drivers/pci/vgaarb.c
> @@ -35,6 +35,34 @@
>  
>  #include <linux/vgaarb.h>
>  
> +static char *bootdev __initdata;
> +module_param(bootdev, charp, 0);
> +MODULE_PARM_DESC(bootdev, "Force boot device to the specified PCI ID");
> +
> +/*
> + * Initialize to the last possible ID to have things work as normal
> + * when no 'bootdev' option is supplied. We especially do not want
> + * this to be zero (0) since that is a valid PCI ID (00:00.0).
> + */
> +static u16 bootdev_id = 0xffff;
> +
> +static void __init parse_bootdev(char *input)
> +{
> +	unsigned int bus, dev, func;
> +	int ret;
> +
> +	if (input == NULL)
> +		return;
> +
> +	ret = sscanf(input, "%x:%x.%x", &bus, &dev, &func);
> +	if (ret != 3) {
> +		pr_warn("Improperly formatted PCI ID: %s\n", input);
> +		return;
> +	}
> +
> +	bootdev_id = PCI_DEVID(bus, PCI_DEVFN(dev, func));
> +}
> +
>  static void vga_arbiter_notify_clients(void);
>  /*
>   * We keep a list of all vga devices in the system to speed
> @@ -53,6 +81,7 @@ struct vga_device {
>  	bool bridge_has_one_vga;
>  	bool is_firmware_default;	/* device selected by firmware */
>  	unsigned int (*set_decode)(struct pci_dev *pdev, bool decode);
> +	bool is_chosen_one;		/* device specified on command line */
>  };
>  
>  static LIST_HEAD(vga_list);
> @@ -605,6 +634,7 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
>  
>  	/*
>  	 * We select the default VGA device in this order:
> +	 *   User specified device (see module param bootdev=)
>  	 *   Firmware framebuffer (see vga_arb_select_default_device())
>  	 *   Legacy VGA device (owns VGA_RSRC_LEGACY_MASK)
>  	 *   Non-legacy integrated device (see vga_arb_select_default_device())
> @@ -612,6 +642,14 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
>  	 *   Other device (see vga_arb_select_default_device())
>  	 */
>  
> +	if (boot_vga && boot_vga->is_chosen_one)
> +		return false;
> +
> +	if (bootdev_id == PCI_DEVID(pdev->bus->number, pdev->devfn)) {
> +		vgadev->is_chosen_one = true;
> +		return true;
> +	}
> +
>  	/*
>  	 * We always prefer a firmware default device, so if we've already
>  	 * found one, there's no need to consider vgadev.
> @@ -1544,6 +1582,8 @@ static int __init vga_arb_device_init(void)
>  	int rc;
>  	struct pci_dev *pdev;
>  
> +	parse_bootdev(bootdev);
> +
>  	rc = misc_register(&vga_arb_device);
>  	if (rc < 0)
>  		pr_err("error %d registering device\n", rc);
> -- 
> 2.35.3
> 
