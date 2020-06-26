Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169AB20B025
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 13:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgFZLB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 07:01:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728130AbgFZLBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 07:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593169313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=54AFfCAwRZMabq3p21YNLO9j9iX9H+8Mbtv8XIhgcY4=;
        b=OuH6ruZCAYjE7QmonU3a7nD/j9BDLndjfOp6x27S04kotDbjVRn4ProSFs6nixObKn0AQk
        B7aFOylnHJVav0rgowsAwwkXbPU9KWv+KWOqaq40UupTOLTySQNgo/ejTJO1W7y2ACKY+J
        06dWF2kpBEdDhJQv0wrEL7+s2cwIuDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-mku7AJ7rNAa1Mp-RJOTPew-1; Fri, 26 Jun 2020 07:01:50 -0400
X-MC-Unique: mku7AJ7rNAa1Mp-RJOTPew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A6AE18A0763;
        Fri, 26 Jun 2020 11:01:48 +0000 (UTC)
Received: from work-vm (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E916960E1C;
        Fri, 26 Jun 2020 11:01:36 +0000 (UTC)
Date:   Fri, 26 Jun 2020 12:01:34 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        cohuck@redhat.com, pasic@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Subject: Re: [PATCH v3 1/9] host trust limitation: Introduce new host trust
 limitation interface
Message-ID: <20200626110134.GF3087@work-vm>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-2-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619020602.118306-2-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.3 (2020-06-14)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Gibson (david@gibson.dropbear.id.au) wrote:
> Several architectures have mechanisms which are designed to protect guest
> memory from interference or eavesdropping by a compromised hypervisor.  AMD
> SEV does this with in-chip memory encryption and Intel has a similar
> mechanism.  POWER's Protected Execution Framework (PEF) accomplishes a
> similar goal using an ultravisor and new memory protection features,
> instead of encryption.
> 
> To (partially) unify handling for these, this introduces a new
> HostTrustLimitation QOM interface.

This does make some sense to me from a SEV point of view, so

Acked-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  backends/Makefile.objs               |  2 ++
>  backends/host-trust-limitation.c     | 29 ++++++++++++++++++++++++
>  include/exec/host-trust-limitation.h | 33 ++++++++++++++++++++++++++++
>  include/qemu/typedefs.h              |  1 +
>  4 files changed, 65 insertions(+)
>  create mode 100644 backends/host-trust-limitation.c
>  create mode 100644 include/exec/host-trust-limitation.h
> 
> diff --git a/backends/Makefile.objs b/backends/Makefile.objs
> index 28a847cd57..af761c9ab1 100644
> --- a/backends/Makefile.objs
> +++ b/backends/Makefile.objs
> @@ -21,3 +21,5 @@ common-obj-$(CONFIG_LINUX) += hostmem-memfd.o
>  common-obj-$(CONFIG_GIO) += dbus-vmstate.o
>  dbus-vmstate.o-cflags = $(GIO_CFLAGS)
>  dbus-vmstate.o-libs = $(GIO_LIBS)
> +
> +common-obj-y += host-trust-limitation.o
> diff --git a/backends/host-trust-limitation.c b/backends/host-trust-limitation.c
> new file mode 100644
> index 0000000000..96a381cd8a
> --- /dev/null
> +++ b/backends/host-trust-limitation.c
> @@ -0,0 +1,29 @@
> +/*
> + * QEMU Host Trust Limitation interface
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "exec/host-trust-limitation.h"
> +
> +static const TypeInfo host_trust_limitation_info = {
> +    .name = TYPE_HOST_TRUST_LIMITATION,
> +    .parent = TYPE_INTERFACE,
> +    .class_size = sizeof(HostTrustLimitationClass),
> +};
> +
> +static void host_trust_limitation_register_types(void)
> +{
> +    type_register_static(&host_trust_limitation_info);
> +}
> +
> +type_init(host_trust_limitation_register_types)
> diff --git a/include/exec/host-trust-limitation.h b/include/exec/host-trust-limitation.h
> new file mode 100644
> index 0000000000..03887b1be1
> --- /dev/null
> +++ b/include/exec/host-trust-limitation.h
> @@ -0,0 +1,33 @@
> +/*
> + * QEMU Host Trust Limitation interface
> + *
> + * Copyright: David Gibson, Red Hat Inc. 2020
> + *
> + * Authors:
> + *  David Gibson <david@gibson.dropbear.id.au>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or
> + * later.  See the COPYING file in the top-level directory.
> + *
> + */
> +#ifndef QEMU_HOST_TRUST_LIMITATION_H
> +#define QEMU_HOST_TRUST_LIMITATION_H
> +
> +#include "qom/object.h"
> +
> +#define TYPE_HOST_TRUST_LIMITATION "host-trust-limitation"
> +#define HOST_TRUST_LIMITATION(obj)                                    \
> +    INTERFACE_CHECK(HostTrustLimitation, (obj),                       \
> +                    TYPE_HOST_TRUST_LIMITATION)
> +#define HOST_TRUST_LIMITATION_CLASS(klass)                            \
> +    OBJECT_CLASS_CHECK(HostTrustLimitationClass, (klass),             \
> +                       TYPE_HOST_TRUST_LIMITATION)
> +#define HOST_TRUST_LIMITATION_GET_CLASS(obj)                          \
> +    OBJECT_GET_CLASS(HostTrustLimitationClass, (obj),                 \
> +                     TYPE_HOST_TRUST_LIMITATION)
> +
> +typedef struct HostTrustLimitationClass {
> +    InterfaceClass parent;
> +} HostTrustLimitationClass;
> +
> +#endif /* QEMU_HOST_TRUST_LIMITATION_H */
> diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
> index ce4a78b687..f75c7eb2f2 100644
> --- a/include/qemu/typedefs.h
> +++ b/include/qemu/typedefs.h
> @@ -51,6 +51,7 @@ typedef struct FWCfgIoState FWCfgIoState;
>  typedef struct FWCfgMemState FWCfgMemState;
>  typedef struct FWCfgState FWCfgState;
>  typedef struct HostMemoryBackend HostMemoryBackend;
> +typedef struct HostTrustLimitation HostTrustLimitation;
>  typedef struct I2CBus I2CBus;
>  typedef struct I2SCodec I2SCodec;
>  typedef struct IOMMUMemoryRegion IOMMUMemoryRegion;
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

