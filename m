Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9428512568
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 00:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiD0WpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 18:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbiD0WpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 18:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04ED0255AF
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 15:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651099314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Q6+PayGphb3zKZnUdKR+LTCV+SuNJxanUj+aw0RLUU=;
        b=QMsTBO/bJ0KJNNJLxNLu+HlJ2GzGEeW4Yti+cG3p2r1AFDPs5rTUceRXPpYrA1cjyZZTip
        MThM676sM04QTel8y1t5oKAACe5YIxAZlis4daDaleA7vSuQra4cRJPK+ibXMfF1F/DvZN
        FifnL9+4+S8O4tnblIsFwFOZk7IO08k=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-hOpyWhdeNUaza5D1o24PvQ-1; Wed, 27 Apr 2022 18:41:53 -0400
X-MC-Unique: hOpyWhdeNUaza5D1o24PvQ-1
Received: by mail-il1-f198.google.com with SMTP id v14-20020a056e020f8e00b002caa6a5d918so757163ilo.15
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 15:41:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4Q6+PayGphb3zKZnUdKR+LTCV+SuNJxanUj+aw0RLUU=;
        b=kr9Zm4Y4G7d5F2iEJySCL/fsaUbD3UfJP5WKrfs3RQEEhFRdMEdUxy/XwbC1imikrz
         EA+SB6NFp9bbTbpF1I5piqdAKbFwJx2g0UmLDqB519LzR6Y/28Xi5ZU/Xa//E3FMrWBi
         MR6EuS+a4Tg0rU+N6No7M9RxtdfQ/jANaW1S5qv62MyY32dSurkudIh8w3PXLEj/1KXU
         U5db0+h7/T9KBH3tn2KbfoMgU7dQbacpW9Q7rL8Tark55IkZ0P200K8rEorh62CrVrG0
         MmppQVQrYWF88s0NeCjb2Ac33BS6V/BSUM1nhdV5vLaI2FBgH2Pui7lwtSH3MQRfFHyY
         H37g==
X-Gm-Message-State: AOAM533U5UStAGmUE6dHmXlecDmw9tgrrGFn4jEjcvwts0zSsp5rtjyP
        r/tIlt+Ms0WXeOjmDi6ZfZ72NxqtUMduExTE8sutxVd4nj8t6f2Trj9tYpwSeTgN0MljFjjiBWp
        Q0l9AbvtzlLiV
X-Received: by 2002:a05:6602:1211:b0:654:94db:fa48 with SMTP id y17-20020a056602121100b0065494dbfa48mr12622901iot.48.1651099311089;
        Wed, 27 Apr 2022 15:41:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxWQb90mvXltObvc4vVxwPkTBtgpQEpfxBIyrAqvOvyNj0f9DUNqMXetDikuTEcPJOCq9Hsw==
X-Received: by 2002:a05:6602:1211:b0:654:94db:fa48 with SMTP id y17-20020a056602121100b0065494dbfa48mr12622885iot.48.1651099310872;
        Wed, 27 Apr 2022 15:41:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g5-20020a5d8c85000000b0065726e18c0csm12223712ion.22.2022.04.27.15.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 15:41:50 -0700 (PDT)
Date:   Wed, 27 Apr 2022 16:41:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jake Oshins <jakeo@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM
 boot time
Message-ID: <20220427164147.330a0bc8.alex.williamson@redhat.com>
In-Reply-To: <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
References: <BYAPR21MB12705103ED8F2B7024A22438BFF49@BYAPR21MB1270.namprd21.prod.outlook.com>
        <YmgheiPOApuiLcK6@lpieralisi>
        <BYAPR21MB127041D9BF1A4708B620BA30BFFB9@BYAPR21MB1270.namprd21.prod.outlook.com>
        <SN4PR2101MB0878E466880C047D3A0D0C92ABFB9@SN4PR2101MB0878.namprd21.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 19:25:43 +0000
Jake Oshins <jakeo@microsoft.com> wrote:

> > -----Original Message-----
> > From: Dexuan Cui <decui@microsoft.com>
> > Sent: Tuesday, April 26, 2022 11:32 AM
> > To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Cc: Jake Oshins <jakeo@microsoft.com>; Bjorn Helgaas <helgaas@kernel.org>;
> > bhelgaas@google.com; Alex Williamson <alex.williamson@redhat.com>;
> > wei.liu@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> > linux-hyperv@vger.kernel.org; linux-pci@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Michael Kelley (LINUX) <mikelley@microsoft.com>;
> > robh@kernel.org; kw@linux.com; kvm@vger.kernel.org
> > Subject: RE: [PATCH] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce
> > VM boot time
> >   
> > > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > > Sent: Tuesday, April 26, 2022 9:45 AM  
> > > > ...
> > > > Sorry I don't quite follow. pci-hyperv allocates MMIO for the bridge
> > > > window in hv_pci_allocate_bridge_windows() and registers the MMIO
> > > > ranges to the core PCI driver via pci_add_resource(), and later the
> > > > core PCI driver probes the bus/device(s), validates the BAR sizes
> > > > and the pre-initialized BAR values, and uses the BAR configuration.
> > > > IMO the whole process doesn't require the bit PCI_COMMAND_MEMORY to
> > > > be pre-set, and there should be no issue to delay setting the bit to
> > > > a PCI device device's .probe() -> pci_enable_device().  
> > >
> > > IIUC you want to bootstrap devices with PCI_COMMAND_MEMORY clear
> > > (otherwise PCI core would toggle it on and off for eg BAR sizing).
> > >
> > > Is that correct ?  
> > 
> > Yes, that's the exact purpose of this patch.
> > 
> > Do you see any potential architectural issue with the patch?
> > From my reading of the core PCI code, it looks like this should be safe.
> > 
> > Jake has some concerns that I don't quite follow.
> > @Jake, could you please explain the concerns with more details?
> >   
> 
> First, let me say that I really don't know whether this is an issue.
> I know it's an issue with other operating system kernels.  I'm
> curious whether the Linux kernel / Linux PCI driver would behave in a
> way that has an issue here.
> 
> The VM has a window of address space into which it chooses to put PCI
> device's BARs.  The guest OS will generally pick the value that is
> within the BAR, by default, but it can theoretically place the device
> in any free address space.  The subset of the VM's memory address
> space which can be populated by devices' BARs is finite, and
> generally not particularly large.

AIUI, if the firmware has programmed the BAR addresses, Linux will
generally try to leave them alone, it's only unprogrammed devices or
when using the pci=realloc option that we'll try to shuffle things
around.

If you talk to bare metal system firmware developers, you might find
disagreement regarding whether the OS or system firmware owns the
device address space, which I believe also factors into our handling of
the memory space enable bit of the command register.  Minimally, system
firmware is required to allocate resources and enable boot devices, and
often these are left enabled after the hand-off to the OS.  This might
include some peripherals, for instance legacy emulation on a USB
keyboard might leave the USB host controller enabled.  There are also
more devious use cases, where there might be device monitoring running
across the bus under the OS, perhaps via SMI or other means, where if
we start moving devices around, that could theoretically break.

However, I don't really see any obvious problems with your proposal
that we simply leave the memory enable bit in the hand-off state.

> Imagine a VM that is configured with 25 NVMe controllers, each of
> which requires 64KiB of address space.  (This is just an example.)
> At first boot, all of these NVMe controllers are packed into address
> space, one after the other.
> 
> While that VM is running, one of the 25 NVMe controllers fails and is
> replaced with an NVMe controller from a separate manufacturer, but
> this one requires 128KiB of memory, for some reason.  Perhaps it
> implements the "controller buffer" feature of NVMe.  It doesn't fit
> in the hole that was vacated by the failed NVMe controller, so it
> needs to be placed somewhere else in address space.  This process
> continues over months, with several more failures and replacements.
> Eventually, the address space is very fragmented.
> 
> At some point, there is an attempt to place an NVMe controller into
> the VM but there is no contiguous block of address space free which
> would allow that NVMe controller to operate.  There is, however,
> enough total address space if the other, currently functioning, NVMe
> controllers are moved from the address space that they are using to
> other ranges, consolidating their usage and reducing fragmentation.
> Let's call this a rebalancing of memory resources.
> 
> When the NVMe controllers are moved, a new value is written into
> their BAR.  In general, the PCI spec would require that you clear the
> memory enable bit in the command register (PCI_COMMAND_MEMORY) during
> this move operation, both so that there's never a moment when two
> devices are occupying the same address space and because writing a
> 64-bit BAR atomically isn't possible.  This is the reason that I
> originally wrote the code in this driver to unmap the device from the
> VM's address space when the memory enable bit is cleared.
> 
> What I don't know is whether this sequence of operations can ever
> happen in Linux, or perhaps in a VM running Linux.  Will it rebalance
> resources in order to consolidate address space?  If it will, will
> this involve clearing the memory enable bit to ensure that two
> devices never overlap?

Once the OS is running and drivers are attached to devices, any
reshuffling of resources for those devices would require coordination
of the driver to release the resources and reprogram them.  Even if an
atomic update of the BAR were possible, that can't account for possible
in-flight use cases, such as p2p DMA.

There were a couple sessions from the 2019 Linux Plumbers conference
that might be useful to review regarding these issues.  IIRC the
first[1] was specifically looking at whether we could do partial BAR
allocations for NVMe devices, where we might have functionality but
reduced performance or features with a partial mapping.  In your
example, perhaps we're replacing a device with one that has twice the
BAR space, but is functional with only half that, so we can slide it
into the same slot as the previous device.  This would likely mean
enlightening the PCI core with device or class specific information.
I've not followed whether anything occurred here.

The second[2] (next session, same recording) discusses problems around
resource allocation and dynamic reallocation.  Again, I haven't
followed further discussions here, but I don't expect much has changed.
Thanks,

Alex

[1]https://youtu.be/ozlQ1XQreac?list=PLVsQ_xZBEyN1PDehCCAiztGf45K_D6txS&t=6481
[2]https://youtu.be/ozlQ1XQreac?list=PLVsQ_xZBEyN1PDehCCAiztGf45K_D6txS&t=7980

