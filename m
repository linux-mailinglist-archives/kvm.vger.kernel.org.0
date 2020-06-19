Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D058201442
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391470AbgFSPGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:06:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40517 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391454AbgFSPGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592579194;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lr+LUOaLSBgm41JBpkX79KrfQBxFPphNoXJMk//1n6g=;
        b=OzJifZ3HrW0zP7g1jhAs49nT9SgA5eYVeWnD7h2xPxrEF2LH00yt+/H38GKbtadKpM5Rbt
        5Skr2kr8/D1r1gxV2kJJ4bSqlXPulKWaCi52XF0qVR8CnEE3SQQZeMnvQ4McMOlhhRDWG1
        ObgkEKdsdrv/OvjTRSwb/9snIsdGhx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-Nn_I5OnqOAaEp7tXeJv0cQ-1; Fri, 19 Jun 2020 11:06:07 -0400
X-MC-Unique: Nn_I5OnqOAaEp7tXeJv0cQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 178EF106C01C;
        Fri, 19 Jun 2020 15:06:05 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C135C1D0;
        Fri, 19 Jun 2020 15:05:59 +0000 (UTC)
Date:   Fri, 19 Jun 2020 16:05:56 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, cohuck@redhat.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200619150556.GW700896@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619144541.GM17085@umbus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619144541.GM17085@umbus.fritz.box>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 20, 2020 at 12:45:41AM +1000, David Gibson wrote:
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
> > Silently changing the user's request configuration like this
> 
> It doesn't, though.  register_sugar_prop() effectively registers a
> default, so if the user has explicitly specified something, that will
> take precedence.

Don't assume that the user has set "disable-legacy=off". People who want to
have a transtional device are almost certainly pasing "-device virtio-blk-pci",
because historical behaviour is that this is sufficient to give you a
transitional device. Changing the default of disable-legacy=on has not
honoured the users' requested config.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

