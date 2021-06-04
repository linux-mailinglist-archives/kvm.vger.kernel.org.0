Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DC839C267
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 23:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhFDVbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 17:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229755AbhFDVbK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 17:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622842163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xEuogiJFrluRPqjpF+9tD/0FxZaF2LJJRCJA/TNp9Oc=;
        b=RiAVPoVyHvqkzshv+fJqQA0Lzs5XO8gGvSANxKHDqPbtqoHwmGzBiNCaJAT/3HsQvqOUnl
        reFJkEqkaanupddH91lNf3Nr9cw2oLMJh95iZSENpFFWkTG+p3/Pe3ubH3xHA4vVS5Rs4X
        Bt1tDlleG76Sqspj891PF+91uHjCDSQ=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-WmeSQ8FqOhWjCq-eyokO5A-1; Fri, 04 Jun 2021 17:29:22 -0400
X-MC-Unique: WmeSQ8FqOhWjCq-eyokO5A-1
Received: by mail-oi1-f197.google.com with SMTP id a29-20020a544e1d0000b02901eef9e4a58cso5261420oiy.3
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 14:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xEuogiJFrluRPqjpF+9tD/0FxZaF2LJJRCJA/TNp9Oc=;
        b=Z5Be/jxk/GYebhc/THbAWyJyJzvfkNorIODnghbQGQz3CIcmE/KUTOT09nR4/LfTLM
         6xRUs4x9sN0h18Zj5CRqpvP/+R49jLldGUHAZ4sMGy6YAf0pKajwkhAhht/RuDBDUHw3
         WLzdRBrT6Np0iRwz2p+U+0IqitqqqHoryPP1yQgFLmi4Dr8B38N8vJ0nRfcfRr+zxQyC
         hDkAdYLKFOJal3i6gwBwljz8VYtqv7wL5/Sv+CYZ2IoPoAy7HJWu5ojl+ulrG4Lniuzh
         w4IKOeEqt7HMQuVB2fwHUD6pa+rC0GD/CukP9eW3HeQOmXmrQZOVElstOy4zMWPU+SzO
         o+RA==
X-Gm-Message-State: AOAM533bPoryl8BS83irc/u3VZHbD0YtGLUqreBcVnludgt/IXwmvdzE
        Su6gd18MjMqA6YQWCx0CUJi7ogn/fvAtD2NvelyoMxNKjNHb+Eu8a4JIU9BmzuznqcCRnoIcpeM
        l4GULzFwTrPrC
X-Received: by 2002:aca:d18:: with SMTP id 24mr11829320oin.56.1622842161093;
        Fri, 04 Jun 2021 14:29:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD3fykksZ3P7cEsyJ8xzxTeqnpMVAfeCDorrF3MYeu8L7chpRaGp1o7UgXlt9aMuAsw4nMkQ==
X-Received: by 2002:aca:d18:: with SMTP id 24mr11829303oin.56.1622842160801;
        Fri, 04 Jun 2021 14:29:20 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w6sm726669otj.5.2021.06.04.14.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 14:29:20 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:29:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604152918.57d0d369.alex.williamson@redhat.com>
In-Reply-To: <20210604172207.GT1002214@nvidia.com>
References: <20210603201018.GF1002214@nvidia.com>
        <20210603154407.6fe33880.alex.williamson@redhat.com>
        <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210604122830.GK1002214@nvidia.com>
        <20210604092620.16aaf5db.alex.williamson@redhat.com>
        <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
        <20210604155016.GR1002214@nvidia.com>
        <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
        <20210604160336.GA414156@nvidia.com>
        <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
        <20210604172207.GT1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Jun 2021 14:22:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jun 04, 2021 at 06:10:51PM +0200, Paolo Bonzini wrote:
> > On 04/06/21 18:03, Jason Gunthorpe wrote:  
> > > On Fri, Jun 04, 2021 at 05:57:19PM +0200, Paolo Bonzini wrote:  
> > > > I don't want a security proof myself; I want to trust VFIO to make the right
> > > > judgment and I'm happy to defer to it (via the KVM-VFIO device).
> > > > 
> > > > Given how KVM is just a device driver inside Linux, VMs should be a slightly
> > > > more roundabout way to do stuff that is accessible to bare metal; not a way
> > > > to gain extra privilege.  
> > > 
> > > Okay, fine, lets turn the question on its head then.
> > > 
> > > VFIO should provide a IOCTL VFIO_EXECUTE_WBINVD so that userspace VFIO
> > > application can make use of no-snoop optimizations. The ability of KVM
> > > to execute wbinvd should be tied to the ability of that IOCTL to run
> > > in a normal process context.
> > > 
> > > So, under what conditions do we want to allow VFIO to giave a process
> > > elevated access to the CPU:  
> > 
> > Ok, I would definitely not want to tie it *only* to CAP_SYS_RAWIO (i.e.
> > #2+#3 would be worse than what we have today), but IIUC the proposal (was it
> > yours or Kevin's?) was to keep #2 and add #1 with an enable/disable ioctl,
> > which then would be on VFIO and not on KVM.    
> 
> At the end of the day we need an ioctl with two arguments:
>  - The 'security proof' FD (ie /dev/vfio/XX, or /dev/ioasid, or whatever)
>  - The KVM FD to control wbinvd support on
> 
> Philosophically it doesn't matter too much which subsystem that ioctl
> lives, but we have these obnoxious cross module dependencies to
> consider.. 
> 
> Framing the question, as you have, to be about the process, I think
> explains why KVM doesn't really care what is decided, so long as the
> process and the VM have equivalent rights.
> 
> Alex, how about a more fleshed out suggestion:
> 
>  1) When the device is attached to the IOASID via VFIO_ATTACH_IOASID
>     it communicates its no-snoop configuration:

Communicates to whom?

>      - 0 enable, allow WBINVD
>      - 1 automatic disable, block WBINVD if the platform
>        IOMMU can police it (what we do today)
>      - 2 force disable, do not allow BINVD ever

The only thing we know about the device is whether or not Enable
No-snoop is hard wired to zero, ie. it either can't generate no-snoop
TLPs ("coherent-only") or it might ("assumed non-coherent").  If
we're putting the policy decision in the hands of userspace they should
have access to wbinvd if they own a device that is assumed
non-coherent AND it's attached to an IOMMU (page table) that is not
blocking no-snoop (a "non-coherent IOASID").

I think that means that the IOASID needs to be created (IOASID_ALLOC)
with a flag that specifies whether this address space is coherent
(IOASID_GET_INFO probably needs a flag/cap to expose if the system
supports this).  All mappings in this IOASID would use IOMMU_CACHE and
and devices attached to it would be required to be backed by an IOMMU
capable of IOMMU_CAP_CACHE_COHERENCY (attach fails otherwise).  If only
these IOASIDs exist, access to wbinvd would not be provided.  (How does
a user provided page table work? - reserved bit set, user error?)

Conversely, a user could create a non-coherent IOASID and attach any
device to it, regardless of IOMMU backing capabilities.  Only if an
assumed non-coherent device is attached would the wbinvd be allowed.

I think that means that an EXECUTE_WBINVD ioctl lives on the IOASIDFD
and the IOASID world needs to understand the device's ability to
generate non-coherent DMA.  This wbinvd ioctl would be a no-op (or
some known errno) unless a non-coherent IOASID exists with a potentially
non-coherent device attached.
 
>     vfio_pci may want to take this from an admin configuration knob
>     someplace. It allows the admin to customize if they want.
> 
>     If we can figure out a way to autodetect 2 from vfio_pci, all the
>     better
> 
>  2) There is some IOMMU_EXECUTE_WBINVD IOCTL that allows userspace
>     to access wbinvd so it can make use of the no snoop optimization.
> 
>     wbinvd is allowed when:
>       - A device is joined with mode #0
>       - A device is joined with mode #1 and the IOMMU cannot block
>         no-snoop (today)
> 
>  3) The IOASID's don't care about this at all. If IOMMU_EXECUTE_WBINVD
>     is blocked and userspace doesn't request to block no-snoop in the
>     IOASID then it is a userspace error.

In my model above, the IOASID is central to this.
 
>  4) The KVM interface is the very simple enable/disable WBINVD.
>     Possessing a FD that can do IOMMU_EXECUTE_WBINVD is required
>     to enable WBINVD at KVM.

Right, and in the new world order, vfio is only a device driver, the
IOASID manages the device's DMA.  wbinvd is only necessary relative to
non-coherent DMA, which seems like QEMU needs to bump KVM with an
ioasidfd.
 
> It is pretty simple from a /dev/ioasid perpsective, covers todays
> compat requirement, gives some future option to allow the no-snoop
> optimization, and gives a new option for qemu to totally block wbinvd
> no matter what.

What do you imagine is the use case for totally blocking wbinvd?  In
the model I describe, wbinvd would always be a no-op/known-errno when
the IOASIDs are all allocated as coherent or a non-coherent IOASID has
only coherent-only devices attached.  Does userspace need a way to
prevent itself from scenarios where wbvind is not a no-op?

In general I'm having trouble wrapping my brain around the semantics of
the enable/automatic/force-disable wbinvd specific proposal, sorry.
Thanks,

Alex

