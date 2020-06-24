Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37815206E5A
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 09:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390002AbgFXH4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 03:56:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33445 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388029AbgFXH4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 03:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592985369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGLpjtaK4gx9ypihPopUPCr5NEjJhJ3CIRNBT38ZCPg=;
        b=etmDsZ+yPntmX+kR+AYiQnbzBxgzv8IFuoiI/UkWlQ42cb9s7nC/7BL9adtLTTlNy55vWu
        JgIyQZDcnX6YWgyAXNL04gYeXSLvEc6OVR7ivbd8u0vEYEnH2nvcJT0zo3kMdmMNRcN40P
        MYLmfSKyAW4yDvMNyODpz4U+icT3bqI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-Faqxr5GSOHOxmsXAmJ9tDQ-1; Wed, 24 Jun 2020 03:56:05 -0400
X-MC-Unique: Faqxr5GSOHOxmsXAmJ9tDQ-1
Received: by mail-wr1-f69.google.com with SMTP id m14so2157860wrj.12
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 00:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jGLpjtaK4gx9ypihPopUPCr5NEjJhJ3CIRNBT38ZCPg=;
        b=cCOD7YDoO5GQySxSt/mM0r8M/NRwF0P6Zix+5RE3T3SbE4LP3kbz0hzh6WQnRMBFke
         srMXHILKv29PJL5TQdtaSXwlCO7n5sRCo8NjjFot7cMue8XjsnlTbvS9LXoi4Z1m0uyv
         qnDs39Pg207+W/j7E++Fa0iDORhw4ezdpbaZtSzfyznWupxP5rEb8ifBwC2Ku9JZJTRi
         o7lOo38cz3xlMmuBwDdOFsOB2mxCus7Yf1IC77M4RGpOArCjnem1RSS/WCZEFMMwlXcn
         QOYhcgdE+TEoPuQkYEEopHO0uHmt39n0tENB3XClFJeSPOcZLxZ/P74XAW57abrS2QBJ
         gyUQ==
X-Gm-Message-State: AOAM530FR5E53kG5zx8UgRhQjGO1klolDCJMKSzvikaDjpzNHT9U4IDc
        FJXGiV5u0Eg0nceJU3V3++YWk2okj5QBGTARhnn0Sn8oWGqKuCJmrLpBC6MD5QbAz+H/i/vKKAO
        wdzYcm9kB4YHi
X-Received: by 2002:a5d:6651:: with SMTP id f17mr16581139wrw.29.1592985364628;
        Wed, 24 Jun 2020 00:56:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQierUv/ZViS8VI68a8MUeEYG60ndQYpclpxQhLzof5wumctFwEDuPBGfgqDfPpwi858vT7g==
X-Received: by 2002:a5d:6651:: with SMTP id f17mr16581112wrw.29.1592985364323;
        Wed, 24 Jun 2020 00:56:04 -0700 (PDT)
Received: from redhat.com ([82.166.20.53])
        by smtp.gmail.com with ESMTPSA id c18sm1057269wmk.18.2020.06.24.00.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 00:56:03 -0700 (PDT)
Date:   Wed, 24 Jun 2020 03:55:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     pair@us.ibm.com, brijesh.singh@amd.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        dgilbert@redhat.com, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, pbonzini@redhat.com,
        Richard Henderson <rth@twiddle.net>, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200624034932-mutt-send-email-mst@kernel.org>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619074432-mutt-send-email-mst@kernel.org>
 <20200619074630-mutt-send-email-mst@kernel.org>
 <20200619121638.GK700896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619121638.GK700896@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 01:16:38PM +0100, Daniel P. Berrang� wrote:
> On Fri, Jun 19, 2020 at 07:47:20AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Jun 19, 2020 at 07:46:14AM -0400, Michael S. Tsirkin wrote:
> > > On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. BerrangÃ© wrote:
> > > > On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > > > > The default behaviour for virtio devices is not to use the platforms normal
> > > > > DMA paths, but instead to use the fact that it's running in a hypervisor
> > > > > to directly access guest memory.  That doesn't work if the guest's memory
> > > > > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > > > > 
> > > > > So, if a host trust limitation mechanism is enabled, then apply the
> > > > > iommu_platform=on option so it will go through normal DMA mechanisms.
> > > > > Those will presumably have some way of marking memory as shared with the
> > > > > hypervisor or hardware so that DMA will work.
> > > > > 
> > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > ---
> > > > >  hw/core/machine.c | 11 +++++++++++
> > > > >  1 file changed, 11 insertions(+)
> > > > > 
> > > > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > > > index a71792bc16..8dfc1bb3f8 100644
> > > > > --- a/hw/core/machine.c
> > > > > +++ b/hw/core/machine.c
> > > > > @@ -28,6 +28,8 @@
> > > > >  #include "hw/mem/nvdimm.h"
> > > > >  #include "migration/vmstate.h"
> > > > >  #include "exec/host-trust-limitation.h"
> > > > > +#include "hw/virtio/virtio.h"
> > > > > +#include "hw/virtio/virtio-pci.h"
> > > > >  
> > > > >  GlobalProperty hw_compat_5_0[] = {
> > > > >      { "virtio-balloon-device", "page-poison", "false" },
> > > > > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
> > > > >           * areas.
> > > > >           */
> > > > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > > > > +
> > > > > +        /*
> > > > > +         * Virtio devices can't count on directly accessing guest
> > > > > +         * memory, so they need iommu_platform=on to use normal DMA
> > > > > +         * mechanisms.  That requires disabling legacy virtio support
> > > > > +         * for virtio pci devices
> > > > > +         */
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> > > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
> > > > >      }
> > > > 
> > > > Silently changing the user's request configuration like this is a bad idea.
> > > > The "disable-legacy" option in particular is undesirable as that switches
> > > > the device to virtio-1.0 only mode, which exposes a different PCI ID to
> > > > the guest.
> > > > 
> > > > If some options are incompatible with encryption, then we should raise a
> > > > fatal error at startup, so applications/admins are aware that their requested
> > > > config is broken.
> > >
> > > Agreed - my suggestion is an on/off/auto property, auto value
> > > changes automatically, on/off is validated.
> > 
> > In fact should we extend all bit properties to allow an auto value?
> 
> If "auto" was made the default that creates a similar headache, as to
> preserve existing configuration semantics we expose to apps, libvirt
> would need to find all the properties changed to use "auto" and manually
> set them back to on/off explicitly.
> 
> Regards,
> Daniel

It's QEMU's job to try and have more or less consistent semantics across
versions. QEMU does not guarantee not to change any option defaults
though.

My point is to add ability to differentiate between property values
set by user and ones set by machine type for compatibility.


-- 
MST

