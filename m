Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3234DC50
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 01:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhC2XLU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 19:11:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhC2XLR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 19:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617059477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XhtxNP5tJzdHY/ymMrCncNhNVnZQrNACrTMh/EDPCmE=;
        b=NAfvIdTgUnRwhh35b8MPmfsVMjyk44I7Z7eGt6+knVpXGmnSzEgxGvMHQkKVocFjhlAN3y
        QxjV/YiWvWJUWj5I6q2RienSSpB4+nyv4CSBB83ZwiIVKVsjul/nP2YFlsTYLmiXSGYmyO
        FfodfCIrp8m8pWTS7wz/A68m2j99bRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-MSu-jZjgOAmlu0mbo5C-cg-1; Mon, 29 Mar 2021 19:11:02 -0400
X-MC-Unique: MSu-jZjgOAmlu0mbo5C-cg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2911180FCAA;
        Mon, 29 Mar 2021 23:10:59 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EDF65D9CC;
        Mon, 29 Mar 2021 23:10:54 +0000 (UTC)
Date:   Mon, 29 Mar 2021 17:10:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210329171053.7a2ebce3@omen.home.shazbot.org>
In-Reply-To: <20210323193213.GM2356281@nvidia.com>
References: <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
        <20210319150809.31bcd292@omen.home.shazbot.org>
        <20210319225943.GH2356281@nvidia.com>
        <20210319224028.51b01435@x1.home.shazbot.org>
        <20210321125818.GM2356281@nvidia.com>
        <20210322104016.36eb3c1f@omen.home.shazbot.org>
        <20210323193213.GM2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 16:32:13 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 22, 2021 at 10:40:16AM -0600, Alex Williamson wrote:
> 
> > Of course if you start looking at features like migration support,
> > that's more than likely not simply an additional region with optional
> > information, it would need to interact with the actual state of the
> > device.  For those, I would very much support use of a specific
> > id_table.  That's not these.  
> 
> What I don't understand is why do we need two different ways of
> inserting vendor code?

Because a PCI id table only identifies the device, these drivers are
looking for a device in the context of firmware dependencies.

> > > new_id and driver_override should probably be in that disable list
> > > too..  
> > 
> > We don't have this other world yet, nor is it clear that we will have
> > it.  
> 
> We do today, it is obscure, but there is a whole set of config options
> designed to disable the unsafe kernel features. Kernels booted with
> secure boot and signed modules tend to enable a lot of them, for
> instance. The people working on the IMA stuff tend to enable a lot
> more as you can defeat the purpose of IMA if you can hijack the
> kernel.
> 
> > What sort of id_table is the base vfio-pci driver expected to use?  
> 
> If it has a match table it would be all match, this is why I called it
> a "universal driver"
> 
> If we have a flavour then the flavour controls the activation of
> VFIO, not new_id or driver_override, and in vfio flavour mode we can
> have an all match table, if we can resolve how to choose between two
> drivers with overlapping matches.
> 
> > > > > This is why I want to try for fine grained autoloading first. It
> > > > > really is the elegant solution if we can work it out.    
> > > > 
> > > > I just don't see how we create a manageable change to userspace.    
> > > 
> > > I'm not sure I understand. Even if we add a new sysfs to set some
> > > flavour then that is a pretty trivial change for userspace to move
> > > from driver_override?  
> > 
> > Perhaps for some definition of trivial that I'm not familiar with.
> > We're talking about changing libvirt and driverctl and every distro and
> > user that's created a custom script outside of those.  Even changing
> > from "vfio-pci" to "vfio-pci*" is a hurdle.  
> 
> Sure, but it isn't like a major architectural shift, nor is it
> mandatory unless you start using this new hardware class.
> 
> Userspace changes when we add kernel functionality.. The kernel just
> has to keep working the way it used to for old functionality.

Seems like we're bound to keep igd in the core as you propose below.

> > > Well, I read through the Intel GPU driver and this is how I felt it
> > > works. It doesn't even check the firmware bit unless certain PCI IDs
> > > are matched first.  
> > 
> > The IDs being only the PCI vendor ID and class code.    
> 
> I don't mean how vfio works, I mean how the Intel GPU driver works.
> 
> eg:
> 
> psb_pci_probe()
>  psb_driver_load()
>   psb_intel_opregion_setup()
>            if (memcmp(base, OPREGION_SIGNATURE, 16)) {
> 
> i915_pci_probe()
>  i915_driver_probe()
>   i915_driver_hw_probe()
>    intel_opregion_setup()
> 	if (memcmp(buf, OPREGION_SIGNATURE, 16)) {
> 
> All of these memcmp's are protected by exact id_tables hung off the
> pci_driver's id_table.
> 
> VFIO is the different case. In this case the ID match confirms that
> the config space has the ASLS dword at the fixed offset. If the ID
> doesn't match nothing should read the ASLS offset.
> 
> > > For NVIDIA GPU Max checked internally and we saw it looks very much
> > > like how Intel GPU works. Only some PCI IDs trigger checking on the
> > > feature the firmware thing is linked to.  
> > 
> > And as Alexey noted, the table came up incomplete.  But also those same
> > devices exist on platforms where this extension is completely
> > irrelevant.  
> 
> I understood he ment that NVIDI GPUs *without* NVLINK can exist, but
> the ID table we have here is supposed to be the NVLINK compatible
> ID's.

Those IDs are just for the SXM2 variants of the device that can
exist on a variety of platforms, only one of which includes the
firmware tables to activate the vfio support.

> > So because we don't check for an Intel specific graphics firmware table
> > when binding to Realtek NIC, we can leap to the conclusion that there
> > must be a concise id_table we can create for IGD support?  
> 
> Concise? No, but we can see *today* what the ID table is supposed to
> be by just loooking and the three probe functions that touch
> OPREGION_SIGNATURE.
> 
> > There's a giant assumption above that I'm missing.  Are you expecting
> > that vendors are actually going to keep up with submitting device IDs
> > that they claim to have tested and support with vfio-pci and all other
> > devices won't be allowed to bind?  That would single handedly destroy
> > any non-enterprise use cases of vfio-pci.  
> 
> Why not? They do it for the in-tree GPU drivers today! The ID table
> for Intel GPU is even in a *header file* and we can just #include it
> into vfio igd as well.

Are you volunteering to maintain the vfio-pci-igd id_table, complete
with the implicit expectation that those devices are known to work?
Part of the disconnect we have here might be the intended level of
support.  There's a Kconfig option around vfio igd support for more
than one reason.

I think you're looking for a significant inflection in vendor's stated
support for vfio use cases, beyond the "best-effort, give it a try",
that we currently have.  In some ways I look forward to that, so long
as users can also use it as they do today (maybe not enterprise users).
I sort of see imposing an id_table on igd support as trying to impose
that "vendor condoned" use case before we actually have a vendor
condoning it (or signing up to maintain an id table).

> > So unless you want to do some bitkeeper archaeology, we've always
> > allowed driver probes to fail and fall through to the next one, not
> > even complaining with -ENODEV.  In practice it hasn't been an issue
> > because how many drivers do you expect to have that would even try to
> > claim a device.    
> 
> Do you know of anything using this ability? It might be helpful

I don't.

> > Ordering is only important when there's a catch-all so we need to
> > figure out how to make that last among a class of drivers that will
> > attempt to claim a device.  The softdep is a bit of a hack to do
> > that, I'll admit, but I don't see how the alternate driver flavor
> > universe solves having a catch-all either.  
> 
> Haven't entirely got there yet, but I think the catch all probably has
> to be handled by userspace udev/kmod in some way, as it is the only
> thing that knows if there is a more specific module to load. This is
> the biggest problem..
> 
> And again, I feel this is all a big tangent, especially now that HCH
> wants to delete the nvlink stuff we should just leave igd alone.

Determining which things stay in vfio-pci-core and which things are
split to variant drivers and how those variant drivers can match the
devices they intend to support seems very inline with this series.  If
igd stays as part of vfio-pci-core then I think we're drawing a
parallel to z-pci support, where a significant part of that support is
a set of extra data structures exposed through capabilities to support
userspace use of the device.  Therefore extra regions or data
structures through capabilities, where we're not changing device
access, except as required for the platform (not the device) seem to be
things that fit within the core, right?  Thanks,

Alex

