Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B64B215AB7
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgGFP3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:29:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729197AbgGFP3N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 11:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594049352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fue+J+SZ+TQDmSB0+3L8vErWlImPiK/hYfN6zC83Q4g=;
        b=AmJ9U+Ot+UkZHcaEnjDX0DRmMOwJjduW4a2lILXR++zJn7cCvstbz9XYcxphLv5Gi7J6yn
        JOuR1peAUtOkSeyjCHCyROHgxFZ+dhRA20BfV8T/9igDKG/Lw8XHWz3PCB/oWZhCLDBMSK
        pPp3gEsadSlS5Uy7LPEFqF5+vRVsQ0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-0DfCHj40NE-sE7mqyIK4mQ-1; Mon, 06 Jul 2020 11:29:08 -0400
X-MC-Unique: 0DfCHj40NE-sE7mqyIK4mQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E993107B274;
        Mon,  6 Jul 2020 15:29:07 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EF46275E3D;
        Mon,  6 Jul 2020 15:28:54 +0000 (UTC)
Date:   Mon, 6 Jul 2020 17:28:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v5 11/21] virtio-pci: Proxy for virtio-mem
Message-ID: <20200706172851.2d3062d9.cohuck@redhat.com>
In-Reply-To: <20200626072248.78761-12-david@redhat.com>
References: <20200626072248.78761-1-david@redhat.com>
        <20200626072248.78761-12-david@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Jun 2020 09:22:38 +0200
David Hildenbrand <david@redhat.com> wrote:

> Let's add a proxy for virtio-mem, make it a memory device, and
> pass-through the properties.
> 
> Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/virtio/Makefile.objs    |   1 +
>  hw/virtio/virtio-mem-pci.c | 129 +++++++++++++++++++++++++++++++++++++
>  hw/virtio/virtio-mem-pci.h |  33 ++++++++++
>  include/hw/pci/pci.h       |   1 +
>  4 files changed, 164 insertions(+)
>  create mode 100644 hw/virtio/virtio-mem-pci.c
>  create mode 100644 hw/virtio/virtio-mem-pci.h

(...)

> diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
> new file mode 100644
> index 0000000000..b325303b32
> --- /dev/null
> +++ b/hw/virtio/virtio-mem-pci.c
> @@ -0,0 +1,129 @@
> +/*
> + * Virtio MEM PCI device
> + *
> + * Copyright (C) 2020 Red Hat, Inc.
> + *
> + * Authors:
> + *  David Hildenbrand <david@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + * See the COPYING file in the top-level directory.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "virtio-mem-pci.h"
> +#include "hw/mem/memory-device.h"
> +#include "qapi/error.h"
> +
> +static void virtio_mem_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> +{
> +    VirtIOMEMPCI *mem_pci = VIRTIO_MEM_PCI(vpci_dev);
> +    DeviceState *vdev = DEVICE(&mem_pci->vdev);
> +

As we were having that discussion for other devices recently: I think
you want to use 

    virtio_pci_force_virtio_1(vpci_dev);

here. (Or do it via the names in the type, as virtio-fs does, but I
think I like forcing it better.)

> +    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
> +    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
> +}

