Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54402CE95E
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 09:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgLDISu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 03:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725866AbgLDISu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 03:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607069843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OMu6Ts4aXegHwTfI5K4+wIFUI7ZOjwyzufO+hy2X5v0=;
        b=htnOy2Y24XjqrC7RQU8BoFsfYIvzB32OXMiASal+Xx6aS7I9BR3o0y7adUWYs2I0I7n1Pv
        m1H5dkttGWaSv1T28YKFm0KPyvr70a1bbReh4J5RRQS5IAmWlLFsKXvOp28c7mGiTo93e+
        vtbrnsn8w4rEfb0013c2zC1cY90ynnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-PkCGHXBdOoW3IS7HMSFR1g-1; Fri, 04 Dec 2020 03:17:21 -0500
X-MC-Unique: PkCGHXBdOoW3IS7HMSFR1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3581800D53;
        Fri,  4 Dec 2020 08:17:19 +0000 (UTC)
Received: from gondolin (ovpn-113-97.ams2.redhat.com [10.36.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 700395C1CF;
        Fri,  4 Dec 2020 08:17:09 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:17:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, brijesh.singh@amd.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
Message-ID: <20201204091706.4432dc1e.cohuck@redhat.com>
In-Reply-To: <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-13-david@gibson.dropbear.id.au>
        <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 09:10:36 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 04.12.20 06:44, David Gibson wrote:
> > The default behaviour for virtio devices is not to use the platforms normal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memory
> > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > 
> > So, if a securable guest memory mechanism is enabled, then apply the
> > iommu_platform=on option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with
> > the hypervisor or hardware so that DMA will work.
> > 
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  hw/core/machine.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index a67a27d03c..d16273d75d 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -28,6 +28,8 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/securable-guest-memory.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> >  
> >  GlobalProperty hw_compat_5_1[] = {
> >      { "vhost-scsi", "num_queues", "1"},
> > @@ -1169,6 +1171,17 @@ void machine_run_board_init(MachineState *machine)
> >           * areas.
> >           */
> >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > +
> > +        /*
> > +         * Virtio devices can't count on directly accessing guest
> > +         * memory, so they need iommu_platform=on to use normal DMA
> > +         * mechanisms.  That requires also disabling legacy virtio
> > +         * support for those virtio pci devices which allow it.
> > +         */
> > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
> > +                                   "on", true);
> > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform",
> > +                                   "on", false);  
> 
> I have not followed all the history (sorry). Should we also set iommu_platform
> for virtio-ccw? Halil?
> 

That line should add iommu_platform for all virtio devices, shouldn't
it?

