Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5C8565FB6
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 01:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGDXU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 19:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbiGDXU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 19:20:56 -0400
X-Greylist: delayed 824 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Jul 2022 16:20:55 PDT
Received: from mx2.absolutedigital.net (mx2.absolutedigital.net [50.242.207.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF2CA1057F
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 16:20:55 -0700 (PDT)
Received: from lancer.cnet.absolutedigital.net (lancer.cnet.absolutedigital.net [10.7.5.10])
        by luxor.inet.absolutedigital.net (8.14.4/8.14.4) with ESMTP id 264N6k0P020448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 4 Jul 2022 19:06:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by lancer.cnet.absolutedigital.net (8.17.1/8.17.1) with ESMTPS id 264N71sQ024557
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 4 Jul 2022 19:07:01 -0400
Date:   Mon, 4 Jul 2022 19:07:01 -0400 (EDT)
From:   Cal Peake <cp@absolutedigital.net>
To:     Bjorn Helgaas <helgaas@kernel.org>
cc:     Randy Dunlap <rdunlap@infradead.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCHv2] vgaarb: Add module param to allow for choosing the
 boot VGA device
In-Reply-To: <20220704213829.GA16883@bhelgaas>
Message-ID: <17b4da8c-8847-857e-21ca-b8a53446c362@absolutedigital.net>
References: <20220704213829.GA16883@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Jul 2022, Bjorn Helgaas wrote:

> I cc'd KVM folks in case they have anything to add here because I'm
> not a VFIO passthrough expert.
> 
> It sounds like the problem occurs when the VFIO driver claims the GPU.
> I assume that happens after boot, when setting up for the virtual
> machine?

No, this is during boot, long before a VM is launched. As you can kinda 
see from these lines from early on in the boot process:

[   22.066610] amdgpu 0000:0e:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=none:owns=none
[   25.726469] vfio-pci 0000:0f:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none

The vfio-pci driver claims the device like it was a typical GPU driver, 
but since it isn't, the display output functionality of the card stops 
because part of the vfio-pci driver's job is to make sure the card is in 
an unused, preferably pristine-as-possible state for when the VM takes 
control of it.

If we go back earlier in the boot process, you'll see that second line again:

[    9.226635] vfio-pci 0000:0f:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
[    9.238385] vfio_pci: add [10de:1f06[ffffffff:ffffffff]] class 0x000000/00000000
[    9.251529] vfio_pci: add [10de:10f9[ffffffff:ffffffff]] class 0x000000/00000000
[    9.264328] vfio_pci: add [10de:1ada[ffffffff:ffffffff]] class 0x000000/00000000
[    9.277162] vfio_pci: add [10de:1adb[ffffffff:ffffffff]] class 0x000000/00000000

If that device is the one selected by the arbiter as boot device, then 
that is the point where display output stops and everything goes to black.

>  If so, is there a way to avoid the problem at run-time so the admin 
> doesn't have to decide at boot-time which GPU will be passed through to 
> a VM?

With the way that many people like me run this kind of setup, the 
passthrough GPU gets reserved at boot-time anyway with the passing of a 
line like:

vfio_pci.ids=10de:1f06,10de:10f9,10de:1ada,10de:1adb

on the kernel command-line from the bootloader. Doing a similar 
reservation for the host GPU with something like 'vgaarb.bootdev=0e:00.0' 
alongside it should be no big deal to anyone running a setup like this.

You can bind/unbind devices to the vfio-pci driver at run-time using 
sysfs[1], but as far as I can tell, there is no way to change the boot VGA 
device at run-time.

>  Is it possible or desirable to pass through GPU A to VM A, then after 
> VM A exits, pass through GPU B to VM B?

Yeah, there are many ways one can run this setup. Some run with a single 
GPU that gets passed-through and the host is headless. There's probably 
some with more than two GPUs with multiple VMs each getting their own.

The setup I'm running is pretty common: dedicated GPU for the host 
(doesn't need to be anything special, just needs to handle workstation 
duties) and a dedicated GPU for a Windows VM for gaming (something quite 
powerful for those high FPS :-)

As you can see, statically assigning the devices ahead of time is okay. 
The real problem (for me anyway) is there's no way in the UEFI/BIOS to 
tell the firmware which device should be used for boot. Sometimes it picks 
the first GPU, sometimes the second. If if picks wrong, I get an unusable 
system because the VGA arbiter deems the GPU selected by the firmware to 
be the best choice for boot VGA device.

-- 
Cal Peake

[1] /sys/bus/pci/drivers/vfio-pci
