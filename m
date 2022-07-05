Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21F5669CC
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 13:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiGELjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 07:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGELjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 07:39:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 894F413F7C
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 04:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657021174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pvPoWqIvsWl8w+U7M/aIkzJ6IsvvChEXLW+2arMSpA=;
        b=POHx8hwJKryFHEE3EkiGctr28M/hwyoUEgmUmSXQRDETq2i+8dRYgEfBwHqjXk/pJNbeBV
        E3SagL5r2xetGA8kfUtM31lcTDjZY3YetmQYKQD53yIqnp0etRKtnOg6/76wV/P341LUhV
        WzKoDQfxhEv9U615G0m8uUyt1nrFaLk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-3XzB-i95MvuKSdDbWVIN9Q-1; Tue, 05 Jul 2022 07:39:33 -0400
X-MC-Unique: 3XzB-i95MvuKSdDbWVIN9Q-1
Received: by mail-wm1-f70.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so6654603wmb.1
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 04:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8pvPoWqIvsWl8w+U7M/aIkzJ6IsvvChEXLW+2arMSpA=;
        b=p8gylON+qovpNtUeSDbU9odhmkfA7GTojVpYivdzmEHjFe8NkMuIVadNGsXCYDd1kJ
         LtRROQXoK12Wen28sNUQbnyXJiL/CbEnK94MV6Cew6f+XbtEtWFZ4j6YJ1k732pP8lP9
         QG98JraPeXgEs823h1gHI3y176A1FAmFX0qlFHCm+A57D+6dQ4xY9Us+GHzF0R+QE3Pp
         D7ztGI5wa+rMsjKkP2cPrP74b9zelBWSs2Y9NkhOplF6FKCeaAkafbUnqW2iJr63rF1M
         U4zZpLApTfaTknFKdpLzIF/qHBcw2P7j/C8YD7MtcjfBA2t9gIzzHFY1kMBtLGub3dk3
         cHLw==
X-Gm-Message-State: AJIora+0pBP5PgDqjFXajGyKjIMzOJPIeGDaY0hXbjOf4WnlMBAAlfY8
        hiIJvvZEKXymLrs7RWcbZ+Sillzh1wXYbQRGfPQzHwaHmyNX0LVkRJfLKTorL+t9p+JL8DjVVQh
        RMh4n6k5coFAQ
X-Received: by 2002:a05:6000:2c6:b0:21b:ad25:9c1b with SMTP id o6-20020a05600002c600b0021bad259c1bmr32896921wry.391.1657021172232;
        Tue, 05 Jul 2022 04:39:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v0Xx92gGvcRWsPIv9KSF1jDKYn0dtMQRjt1Mnn2btgQx1vAX/n03Joqo41BFJ7DMb28aow1Q==
X-Received: by 2002:a05:6000:2c6:b0:21b:ad25:9c1b with SMTP id o6-20020a05600002c600b0021bad259c1bmr32896901wry.391.1657021172014;
        Tue, 05 Jul 2022 04:39:32 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id l3-20020a1c7903000000b003a04962ad3esm19548302wme.31.2022.07.05.04.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 04:39:31 -0700 (PDT)
Message-ID: <86df559c732a796b2e3da0136a643a212826229f.camel@redhat.com>
Subject: Re: [PATCHv2] vgaarb: Add module param to allow for choosing the
 boot VGA device
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Cal Peake <cp@absolutedigital.net>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Huacai Chen <chenhuacai@kernel.org>, linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Date:   Tue, 05 Jul 2022 14:39:29 +0300
In-Reply-To: <17b4da8c-8847-857e-21ca-b8a53446c362@absolutedigital.net>
References: <20220704213829.GA16883@bhelgaas>
         <17b4da8c-8847-857e-21ca-b8a53446c362@absolutedigital.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-07-04 at 19:07 -0400, Cal Peake wrote:
> On Mon, 4 Jul 2022, Bjorn Helgaas wrote:
> 
> > I cc'd KVM folks in case they have anything to add here because I'm
> > not a VFIO passthrough expert.
> > 
> > It sounds like the problem occurs when the VFIO driver claims the GPU.
> > I assume that happens after boot, when setting up for the virtual
> > machine?
> 
> No, this is during boot, long before a VM is launched. As you can kinda 
> see from these lines from early on in the boot process:
> 
> [   22.066610] amdgpu 0000:0e:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=none:owns=none
> [   25.726469] vfio-pci 0000:0f:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
> 
> The vfio-pci driver claims the device like it was a typical GPU driver, 
> but since it isn't, the display output functionality of the card stops 
> because part of the vfio-pci driver's job is to make sure the card is in 
> an unused, preferably pristine-as-possible state for when the VM takes 
> control of it.
> 
> If we go back earlier in the boot process, you'll see that second line again:
> 
> [    9.226635] vfio-pci 0000:0f:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
> [    9.238385] vfio_pci: add [10de:1f06[ffffffff:ffffffff]] class 0x000000/00000000
> [    9.251529] vfio_pci: add [10de:10f9[ffffffff:ffffffff]] class 0x000000/00000000
> [    9.264328] vfio_pci: add [10de:1ada[ffffffff:ffffffff]] class 0x000000/00000000
> [    9.277162] vfio_pci: add [10de:1adb[ffffffff:ffffffff]] class 0x000000/00000000
> 
> If that device is the one selected by the arbiter as boot device, then 
> that is the point where display output stops and everything goes to black.
> 
> >  If so, is there a way to avoid the problem at run-time so the admin 
> > doesn't have to decide at boot-time which GPU will be passed through to 
> > a VM?
> 
> With the way that many people like me run this kind of setup, the 
> passthrough GPU gets reserved at boot-time anyway with the passing of a 
> line like:
> 
> vfio_pci.ids=10de:1f06,10de:10f9,10de:1ada,10de:1adb
> 
> on the kernel command-line from the bootloader. Doing a similar 
> reservation for the host GPU with something like 'vgaarb.bootdev=0e:00.0' 
> alongside it should be no big deal to anyone running a setup like this.
> 
> You can bind/unbind devices to the vfio-pci driver at run-time using 
> sysfs[1], but as far as I can tell, there is no way to change the boot VGA 
> device at run-time.
> 
> >  Is it possible or desirable to pass through GPU A to VM A, then after 
> > VM A exits, pass through GPU B to VM B?
> 
> Yeah, there are many ways one can run this setup. Some run with a single 
> GPU that gets passed-through and the host is headless. There's probably 
> some with more than two GPUs with multiple VMs each getting their own.
> 
> The setup I'm running is pretty common: dedicated GPU for the host 
> (doesn't need to be anything special, just needs to handle workstation 
> duties) and a dedicated GPU for a Windows VM for gaming (something quite 
> powerful for those high FPS :-)
> 
> As you can see, statically assigning the devices ahead of time is okay. 
> The real problem (for me anyway) is there's no way in the UEFI/BIOS to 
> tell the firmware which device should be used for boot. Sometimes it picks 
> the first GPU, sometimes the second. If if picks wrong, I get an unusable 
> system because the VGA arbiter deems the GPU selected by the firmware to 
> be the best choice for boot VGA device.
> 

My 0.2 semi unrelated cents:

On my desktop system I have two GPUS (AMD workstation GPU and a NVIDIA's gpu), 
I sometimes use each of them (or even both) with VFIO,

But regardless of VFIO, I sometimes use one and sometimes another as my main GPU
(I have all displays connected to each GPU, its quite complex setup with lot
of cables and HDMI switches, but somehow it is actually quite robust)

Choosing boot GPU would be nice to have. On my system I setup it in such way
that AMD GPU gets to be the boot GPU (I don't remember if I blacklisted the
nvidia driver or something for that), and I have a script to dynamicallly
swith them prior to starting X if in a config file I created, I specified that
I want the nvidia GPU to be the default.

So this is a use case which doesn't involve VFIO.

Best regards,
	Maxim Levitsky



