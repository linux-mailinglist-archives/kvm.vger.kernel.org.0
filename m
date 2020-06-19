Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610D6200615
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgFSKNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 06:13:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52775 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729195AbgFSKNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 06:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592561584;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=9TgD00zswi6kpjxkdsGTBBsyLXcp4Zg0SPr+uYeXtzY=;
        b=S5mY+iIaXu43BWW4WtEWto9PA+8uDxcWVkjJ+wJZgqaku6qY1Am4uybsE4IstvrAF9B6fj
        Gwqdc03OWAlT8mZMiHwXXxw/qXPgyTG1vmtCVNjVYfMkPgI1+6griZvKtffD+QnGCmXuy0
        k5GuwSN/ARK2Q5uCXUg1WhsriSPLQ4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-Vl5k1qLxM66UqSBccjOoCw-1; Fri, 19 Jun 2020 06:13:00 -0400
X-MC-Unique: Vl5k1qLxM66UqSBccjOoCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A448800053;
        Fri, 19 Jun 2020 10:12:59 +0000 (UTC)
Received: from redhat.com (unknown [10.36.110.65])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F75F71661;
        Fri, 19 Jun 2020 10:12:48 +0000 (UTC)
Date:   Fri, 19 Jun 2020 11:12:45 +0100
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
Message-ID: <20200619101245.GC700896@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200619020602.118306-10-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.0 (2020-05-02)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> The default behaviour for virtio devices is not to use the platforms normal
> DMA paths, but instead to use the fact that it's running in a hypervisor
> to directly access guest memory.  That doesn't work if the guest's memory
> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> 
> So, if a host trust limitation mechanism is enabled, then apply the
> iommu_platform=on option so it will go through normal DMA mechanisms.
> Those will presumably have some way of marking memory as shared with the
> hypervisor or hardware so that DMA will work.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index a71792bc16..8dfc1bb3f8 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -28,6 +28,8 @@
>  #include "hw/mem/nvdimm.h"
>  #include "migration/vmstate.h"
>  #include "exec/host-trust-limitation.h"
> +#include "hw/virtio/virtio.h"
> +#include "hw/virtio/virtio-pci.h"
>  
>  GlobalProperty hw_compat_5_0[] = {
>      { "virtio-balloon-device", "page-poison", "false" },
> @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
>           * areas.
>           */
>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> +
> +        /*
> +         * Virtio devices can't count on directly accessing guest
> +         * memory, so they need iommu_platform=on to use normal DMA
> +         * mechanisms.  That requires disabling legacy virtio support
> +         * for virtio pci devices
> +         */
> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
>      }

Silently changing the user's request configuration like this is a bad idea.
The "disable-legacy" option in particular is undesirable as that switches
the device to virtio-1.0 only mode, which exposes a different PCI ID to
the guest.

If some options are incompatible with encryption, then we should raise a
fatal error at startup, so applications/admins are aware that their requested
config is broken.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

