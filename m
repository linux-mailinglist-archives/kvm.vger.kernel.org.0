Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026A02032F9
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFVJJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:09:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgFVJJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 05:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592816988;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHjtREysJc4CmQKvOmx6dIBNDYuHnka3AwW0ds/rfSU=;
        b=IZMc0cueKjqLz0ob8nUhQZ04YQppTm3oVnS6f4tt49D69TYgbWWPgeoRggnq1aDnf0wR38
        hVyh6GW6l/DdOxhvk75pUTA3u0uQGfIGW56Q+/pBhQS90vjUMYc1H3hhQKqktbK+MgYVhA
        mSmG5P/EM8EsjQSO6A2mqNHnTKnwZ1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-oG97Q2aXO6-kmmgE-sV6nw-1; Mon, 22 Jun 2020 05:09:46 -0400
X-MC-Unique: oG97Q2aXO6-kmmgE-sV6nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43A1683DE2E;
        Mon, 22 Jun 2020 09:09:44 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D638C5C221;
        Mon, 22 Jun 2020 09:09:33 +0000 (UTC)
Date:   Mon, 22 Jun 2020 10:09:30 +0100
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
Message-ID: <20200622090930.GB736373@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619144541.GM17085@umbus.fritz.box>
 <20200619150556.GW700896@redhat.com>
 <20200620082427.GP17085@umbus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200620082427.GP17085@umbus.fritz.box>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 20, 2020 at 06:24:27PM +1000, David Gibson wrote:
> On Fri, Jun 19, 2020 at 04:05:56PM +0100, Daniel P. Berrangé wrote:
> > On Sat, Jun 20, 2020 at 12:45:41AM +1000, David Gibson wrote:
> > > On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrangé wrote:
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
> > > > Silently changing the user's request configuration like this
> > > 
> > > It doesn't, though.  register_sugar_prop() effectively registers a
> > > default, so if the user has explicitly specified something, that will
> > > take precedence.
> > 
> > Don't assume that the user has set "disable-legacy=off". People who want to
> > have a transtional device are almost certainly pasing "-device virtio-blk-pci",
> > because historical behaviour is that this is sufficient to give you a
> > transitional device. Changing the default of disable-legacy=on has not
> > honoured the users' requested config.
> 
> Umm.. by this argument we can never change any default, ever.  But we
> do that routinely with new machine versions.  How is changing based on
> a machine option different from that?

It isn't really different. Most of the time we get away with it and no one
sees a problem. Some of the changes made though, do indeed break things,
and libvirt tries to override QEMU's changes in defaults where they are
especially at risk of causing breakage. The virtio device model is one such
change I'd consider especially risky as there are clear guest OS driver
support compatibility issues there, with it being a completely different
PCI device ID & impl.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

