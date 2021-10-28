Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CED743E529
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhJ1PdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhJ1PdI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 11:33:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635435041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZshgRYyHAdt1PeMoc+6tLxE9wsgBE8CpYOKrXJsLZ+w=;
        b=O+u7OxtPriITIROKFEEctV0T8FcE2UwzSy0gtGjSyx2XYqbeJQZpkCteLaUh5Az2Ae4+mX
        6Wa/RTsVgzwlUmArkc0phxQV3E9UuCYXPVlB3MK9YPhO3zp/IyWguKUQnhQrnxGbIskZD3
        vvHUQts2il/M1rSRQSKIw85yDHGvKa0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-t9mFu1fHObOdzvzYRIH7cA-1; Thu, 28 Oct 2021 11:30:38 -0400
X-MC-Unique: t9mFu1fHObOdzvzYRIH7cA-1
Received: by mail-oi1-f198.google.com with SMTP id 7-20020aca0d07000000b002988ff10791so3275322oin.8
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZshgRYyHAdt1PeMoc+6tLxE9wsgBE8CpYOKrXJsLZ+w=;
        b=eDTjLRqUdibmxBSDca7DenzBR3AueqkfGkZLxIhVV9SN6zv9RBNixsHJWy1ZK5f+3C
         Cxpr1T9zRX1blzA/566KFZYf1/w+hWU/jTY1I8FpErIEqtHZTzH7owvW/9hbTieUZ0vE
         bc6GQdn+Wp3Z5OPA+zmI71l8/OvSiE0yffqx1Ff5Ja5gpDogDs4+XhYjJjOCzDyLB4U7
         KuQx2DUXldJARUnhwjbfxRkHMXc59BLZSQMjpdQQNAbY4xdijY12oqMjbPXCxrCGu2c6
         cYV/kC/UWkiGUM3qOEjHjwwlNX/Khb2FtYsz3Ft6gFuHk53b+TyH4tPPGbZQpuehmvOC
         e4UQ==
X-Gm-Message-State: AOAM531s3vJlfx4e8Bh4e7W4opD6LT1cVJEBZf2KewKKjzk/wxwSE54e
        pgwVvIOqN2/OAXhhktRFbK2NDbOMIS5r869u8IsT/Bu0VFN3DG9uNCQ++mwcyjCfsf0oYYiz8C4
        sz53TRx3uXB3F
X-Received: by 2002:a05:6830:1e11:: with SMTP id s17mr4074655otr.100.1635435037533;
        Thu, 28 Oct 2021 08:30:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpNMCCzEm/qWgDKhdT5NLeUiAirUH23ASGGy1T4UcITEIIqA9L5QZiXzArSRzkZFMWgtRDdw==
X-Received: by 2002:a05:6830:1e11:: with SMTP id s17mr4074605otr.100.1635435037190;
        Thu, 28 Oct 2021 08:30:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id be2sm1197935oib.1.2021.10.28.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 08:30:36 -0700 (PDT)
Date:   Thu, 28 Oct 2021 09:30:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211028093035.17ecbc5d.alex.williamson@redhat.com>
In-Reply-To: <20211027192345.GJ2744544@nvidia.com>
References: <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Oct 2021 16:23:45 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
> 
> > > As far as the actual issue, if you hadn't just discovered it now
> > > nobody would have known we have this gap - much like how the very
> > > similar reset issue was present in VFIO for so many years until you
> > > plugged it.  
> > 
> > But the fact that we did discover it is hugely important.  We've
> > identified that the potential use case is significantly limited and
> > that userspace doesn't have a good mechanism to determine when to
> > expose that limitation to the user.    
> 
> Huh?
> 
> We've identified that, depending on device behavior, the kernel may
> need to revoke MMIO access to protect itself from hostile userspace
> triggering TLP Errors or something.
> 
> Well behaved userspace must already stop touching the MMIO on the
> device when !RUNNING - I see no compelling argument against that
> position.

Not touching MMIO is not specified in our uAPI protocol, nor is it an
obvious assumption to me, nor is it sufficient to assume well behaved
userspace in the implementation of a kernel interface.

> We've been investigating how the mlx5 HW will behave in corner cases,
> and currently it looks like mlx5 vfio will not generate error TLPs, or
> corrupt the device itself due to MMIO operations when !RUNNING. So the
> driver itself, as written, probably does not currently have a bug
> here, or need changes.

This is a system level observation or is it actually looking at the
bus?  An Unsupported Request on MMIO write won't even generate an AER
on some systems, but others can trigger a fatal error on others.

That sounds like potentially good news, but either way we're still also
discussing a fundamental gap in the uAPI for quiescing multiple devices
in a coordinated way and how we actually define !_RUNNING.

> > We're tossing around solutions that involve extensions, if not
> > changes to the uAPI.  It's Wednesday of rc7.  
> 
> The P2P issue is seperate, and as I keep saying, unless you want to
> block support for any HW that does not have freeze&queice userspace
> must be aware of this ability and it is logical to design it as an
> extension from where we are now.

Is this essentially suggesting that the uAPI be clarified to state
that the base implementation is only applicable to userspace contexts
with a single migratable vfio device instance?  Does that need to
preemptively include /dev/iommu generically, ie. anything that could
potentially have an IOMMU mapping to the device?

I agree that it would be easier to add a capability to expose
multi-device compatibility than to try to retrofit one to expose a
restriction.

> > I feel like we've already been burned by making one of these
> > "reasonable quanta of progress" to accept and mark experimental
> > decisions with where we stand between defining the uAPI in the kernel
> > and accepting an experimental implementation in QEMU.    
> 
> I won't argue there..
> 
> > Now we have multiple closed driver implementations (none of which
> > are contributing to this discussion), but thankfully we're not
> > committed to supporting them because we have no open
> > implementations.  I think we could get away with ripping up the uAPI
> > if we really needed to.  
> 
> Do we need to?

I'd prefer not.

> > > > Deciding at some point in the future to forcefully block device MMIO
> > > > access from userspace when the device stops running is clearly a user
> > > > visible change and therefore subject to the don't-break-userspace
> > > > clause.      
> > > 
> > > I don't think so, this was done for reset retroactively after
> > > all. Well behaved qmeu should have silenced all MMIO touches as part
> > > of the ABI contract anyhow.  
> > 
> > That's not obvious to me and I think it conflates access to the device
> > and execution of the device.  If it's QEMU's responsibility to quiesce
> > access to the device anyway, why does the kernel need to impose this
> > restriction.  I'd think we'd generally only impose such a restriction
> > if the alternative allows the user to invoke bad behavior outside the
> > scope of their use of the device or consistency of the migration data.
> > It appears that any such behavior would be implementation specific here.  
> 
> I think if an implementation has a problem, like error TLPs, then yes,
> it must fence. The conservative specification of the uAPI is that
> userspace should not allow MMIO when !RUNNING.
> 
> If we ever get any implementation that needs this to fence then we
> should do it for all implementations just out of consistency.

Like I've indicated, this is not an obvious corollary of the !_RUNNING
state to me.  I'd tend more towards letting userspace do what they want
and only restrict as necessary to protect the host.  For example the
state of the device when !_RUNNING may be changed by external stimuli,
including MMIO and DMA accesses, but the device does not independently
advance state.

Also, I think we necessarily require config space read-access to
support migration, which begs the question specifically which regions,
if any, are restricted when !_RUNNING?  Could we get away with zapping
mmaps (sigbus on fault) but allowing r/w access?

> > > The "don't-break-userspace" is not an absolute prohibition, Linus has
> > > been very clear this limitation is about direct, ideally demonstrable,
> > > breakage to actually deployed software.  
> > 
> > And if we introduce an open driver that unblocks QEMU support to become
> > non-experimental, I think that's where we stand.  
> 
> Yes, if qemu becomes deployed, but our testing shows qemu support
> needs a lot of work before it is deployable, so that doesn't seem to
> be an immediate risk.

Good news... I guess...  but do we know what other uAPI changes might
be lurking without completing that effort?

> > > > That might also indicate that "freeze" is only an implementation
> > > > specific requirement.  Thanks,    
> > > 
> > > It doesn't matter if a theoretical device can exist that doesn't need
> > > "freeze" - this device does, and so it is the lowest common
> > > denominator for the uAPI contract and userspace must abide by the
> > > restriction.  
> > 
> > Sorry, "to the victor go the spoils" is not really how I strictly want
> > to define a uAPI contract with userspace.    
> 
> This is not the "victor go the spoils" this is meeting the least
> common denominator of HW we have today.
>
> If some fictional HW can be more advanced and can snapshot not freeze,
> that is great, but it doesn't change one bit that mlx5 cannot and will
> not work that way. Since mlx5 must be supported, there is no choice
> but to define the uAPI around its limitations.

But it seems like you've found that mlx5 is resilient to these things
that you're also deeming necessary to restrict.

> snapshot devices are strictly a superset of freeze devices, they can
> emulate freeze by doing snapshot at the freeze operation.

True.

> In all cases userspace should not touch the device when !RUNNING to
> preserve generality to all implementations.

Not and obvious conclusion to me.

> > If we're claiming that userspace is responsible for quiescing
> > devices and we're providing a means for that to occur, and userspace
> > is already responsible for managing MMIO access, then the only
> > reason the kernel would forcefully impose such a restriction itself
> > would be to protect the host and the implementation of that would
> > depend on whether this is expected to be a universal or device
> > specific limitation.    
> 
> I think the best way forward is to allow for revoke to happen if we
> ever need it (by specification), and not implement it right now.
> 
> So, I am not left with a clear idea what is still open that you see as
> blocking. Can you summarize?

It seems we have numerous uAPI questions floating around, including
whether the base specification is limited to a single physical device
within the user's IOMMU context, what the !_RUNNING state actually
implies about the device state, expectations around userspace access
to device regions while in this state, and who is responsible for
limiting such access, and uncertainty what other uAPI changes are
necessary as QEMU support is stabilized.

Why should we rush a driver in just before the merge window and
potentially increase our experimental driver debt load rather than
continue to co-develop kernel and userspace drivers and maybe also
get input from the owners of the existing out-of-tree drivers?  Thanks,

Alex

