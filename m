Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8F20080B
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgFSLrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:47:31 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37924 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731384AbgFSLr2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 07:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592567247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDJADSxWgFpnsQhGGo+Y26ipmydYeWZDAFsCiyoQkqI=;
        b=KjbOio1swEQrsxsjrfGVrnA02+JpwL654+UqoUPqDg2AI9kwWlFzTY1nM1pqlMCeZ2xWvu
        lUs9AP8jcnXHJgEXxD4Z5kvBIc0yv/WacKe/yNlvnYvtRw1HCrEeVA70nJKbT15R+0n9oU
        kqPkR+5JPnApARX0NUTcadV4VFWW+Kk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-ef3x3Kl2Mr6rnjzpX7atrQ-1; Fri, 19 Jun 2020 07:47:25 -0400
X-MC-Unique: ef3x3Kl2Mr6rnjzpX7atrQ-1
Received: by mail-wr1-f70.google.com with SMTP id f5so4140905wrv.22
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 04:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fDJADSxWgFpnsQhGGo+Y26ipmydYeWZDAFsCiyoQkqI=;
        b=BVSFOq3zei1WixdkaHLXm0mjiJqIaeWIml+W7eVuohIVHeH5GiGHQOD7xtAq6Di57e
         ghhZ9E7Hce4oxdvkZO6gmz8gjcS1ahZiqbH6WDFkkoUPU/pmFQa1lrtdXpbWDw7JDfBJ
         xmmyRzSKD0mzHoXBslyp6qGbZm74f2X8P+u05B76fwypYc14j2FZ48esCCnVHvaK0vrP
         5yxHHvbUQZhrqG95A0/cWVT/8uVehIcujU2HI3DY3aPBQ9mZwnutrsXMzXouJoM9bDo/
         jgY4F/px1dTQR44d1524nS9W9rH8IKCxCuIK0On0AgVUi0xhrL+3K4WYFe9ZY0z1G/BL
         bU8A==
X-Gm-Message-State: AOAM533bCNhneHCAU7oCmKVh8jBIGQQeDPC0lI1wUb5fYVTJOq8vQc/U
        uVE2RVnCnNk/6xFT0hduO8q4Q0OGrhcqeafXEql8O9xAsX4siGLx7TaX0fcSIn3hwUWOUVF92MY
        29GP4aiRkKkZm
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr3631268wrs.35.1592567244402;
        Fri, 19 Jun 2020 04:47:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznQGnECWymBeyrfl3qGQ1U09JtwTagONqKA0qZQVXG0ytZb1kr14EWONVwdIDjj42TPeYaFA==
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr3631251wrs.35.1592567244208;
        Fri, 19 Jun 2020 04:47:24 -0700 (PDT)
Received: from redhat.com (bzq-79-178-18-124.red.bezeqint.net. [79.178.18.124])
        by smtp.gmail.com with ESMTPSA id u9sm6745769wme.16.2020.06.19.04.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 04:47:23 -0700 (PDT)
Date:   Fri, 19 Jun 2020 07:47:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200619074630-mutt-send-email-mst@kernel.org>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619074432-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619074432-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 07:46:14AM -0400, Michael S. Tsirkin wrote:
> On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrangé wrote:
> > On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > > The default behaviour for virtio devices is not to use the platforms normal
> > > DMA paths, but instead to use the fact that it's running in a hypervisor
> > > to directly access guest memory.  That doesn't work if the guest's memory
> > > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > > 
> > > So, if a host trust limitation mechanism is enabled, then apply the
> > > iommu_platform=on option so it will go through normal DMA mechanisms.
> > > Those will presumably have some way of marking memory as shared with the
> > > hypervisor or hardware so that DMA will work.
> > > 
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  hw/core/machine.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > index a71792bc16..8dfc1bb3f8 100644
> > > --- a/hw/core/machine.c
> > > +++ b/hw/core/machine.c
> > > @@ -28,6 +28,8 @@
> > >  #include "hw/mem/nvdimm.h"
> > >  #include "migration/vmstate.h"
> > >  #include "exec/host-trust-limitation.h"
> > > +#include "hw/virtio/virtio.h"
> > > +#include "hw/virtio/virtio-pci.h"
> > >  
> > >  GlobalProperty hw_compat_5_0[] = {
> > >      { "virtio-balloon-device", "page-poison", "false" },
> > > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
> > >           * areas.
> > >           */
> > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > > +
> > > +        /*
> > > +         * Virtio devices can't count on directly accessing guest
> > > +         * memory, so they need iommu_platform=on to use normal DMA
> > > +         * mechanisms.  That requires disabling legacy virtio support
> > > +         * for virtio pci devices
> > > +         */
> > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
> > >      }
> > 
> > Silently changing the user's request configuration like this is a bad idea.
> > The "disable-legacy" option in particular is undesirable as that switches
> > the device to virtio-1.0 only mode, which exposes a different PCI ID to
> > the guest.
> > 
> > If some options are incompatible with encryption, then we should raise a
> > fatal error at startup, so applications/admins are aware that their requested
> > config is broken.
> > 
> > Regards,
> > Daniel
> 
> Agreed - my suggestion is an on/off/auto property, auto value
> changes automatically, on/off is validated.


In fact should we extend all bit properties to allow an auto value?

> 
> > -- 
> > |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> > |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> > |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

