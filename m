Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7CA288D46
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 17:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389460AbgJIPs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 11:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389144AbgJIPs1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 11:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602258505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owaindMyLhIAH/J2944aY891LF7tAEUEV8ivsVgZfgw=;
        b=CVp36DfzJr4+AJpAtcga7ED/KVB1SJ9eWH88KtbCarSsSjTWXP7Dpd6JoPO6davNo+oVEh
        VkvHKvts4B7InFohfXx0i7AiuLk0Jnw4MdrXKYjpzTShcqgnPDATHCcNiqsu9D2T/+GR7P
        xuCBWf5Vsn6svUH6qSAW4hwQMbp58aM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-UJFqftlUPC-QpjCRkZOVoA-1; Fri, 09 Oct 2020 11:48:23 -0400
X-MC-Unique: UJFqftlUPC-QpjCRkZOVoA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3521A8015B0;
        Fri,  9 Oct 2020 15:48:22 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CC021A887;
        Fri,  9 Oct 2020 15:48:10 +0000 (UTC)
Date:   Fri, 9 Oct 2020 17:48:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/10] s390x/pci: get zPCI function info from host
Message-ID: <20201009174807.6d800999.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-11-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-11-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:15 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> We use the capability chains of the VFIO_DEVICE_GET_INFO ioctl to retrieve
> the CLP information that the kernel exports.
> 
> To be compatible with previous kernel versions we fall back on previous
> predefined values, same as the emulation values, when the ioctl is found
> to not support capability chains. If individual CLP capabilities are not
> found, we fall back on default values for only those capabilities missing
> from the chain.
> 
> This patch is based on work previously done by Pierre Morel.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/meson.build             |   1 +
>  hw/s390x/s390-pci-bus.c          |  10 +-
>  hw/s390x/s390-pci-vfio.c         | 197 +++++++++++++++++++++++++++++++++++++++
>  include/hw/s390x/s390-pci-bus.h  |   1 +
>  include/hw/s390x/s390-pci-clp.h  |  12 ++-
>  include/hw/s390x/s390-pci-vfio.h |  19 ++++
>  6 files changed, 233 insertions(+), 7 deletions(-)
>  create mode 100644 hw/s390x/s390-pci-vfio.c
>  create mode 100644 include/hw/s390x/s390-pci-vfio.h

(...)

> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> new file mode 100644
> index 0000000..43684c6
> --- /dev/null
> +++ b/hw/s390x/s390-pci-vfio.c
> @@ -0,0 +1,197 @@
> +/*
> + * s390 vfio-pci interfaces
> + *
> + * Copyright 2020 IBM Corp.
> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include <sys/ioctl.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_zdev.h>
> +
> +#include "qemu/osdep.h"
> +#include "hw/s390x/s390-pci-bus.h"
> +#include "hw/s390x/s390-pci-clp.h"
> +#include "hw/s390x/s390-pci-vfio.h"
> +#include "hw/vfio/pci.h"
> +
> +#ifndef DEBUG_S390PCI_VFIO
> +#define DEBUG_S390PCI_VFIO  0
> +#endif
> +
> +#define DPRINTF(fmt, ...)                                          \
> +    do {                                                           \
> +        if (DEBUG_S390PCI_VFIO) {                                  \
> +            fprintf(stderr, "S390pci-vfio: " fmt, ## __VA_ARGS__); \
> +        }                                                          \
> +    } while (0)

Not really a fan of DPRINTF. Can you maybe use trace events instead?

Other than that, looks good to me.

