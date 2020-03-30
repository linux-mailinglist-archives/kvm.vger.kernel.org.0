Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5DB198234
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgC3RX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 13:23:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47223 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728376AbgC3RX2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 13:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585589006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rB1pQC3uSGZ4qXuUsV5aLn5yKifRsd8KJhhsQsqB01g=;
        b=AHxMhgzBpn/RKvW6TbfgjnGDxfs1NU8rwyMpkTqw0/nn1GwC1mTnPCnq8J5vnbp3/fxixE
        oc3qjWZf3MB2mkYXbZWHU3fuJ88QqLZg0jiORbjM1F7Dk9lOPMrqb1UiB7I/FzHDKuNXwv
        x9JdML+hIFwZv8DG10xo2nlzpMiWQmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-PpyKBZCnM5O_bg2jqBXAGQ-1; Mon, 30 Mar 2020 13:22:58 -0400
X-MC-Unique: PpyKBZCnM5O_bg2jqBXAGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36B2A8017CC;
        Mon, 30 Mar 2020 17:22:56 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB8A5D7664;
        Mon, 30 Mar 2020 17:22:40 +0000 (UTC)
Subject: Re: [PATCH v2 04/22] hw/iommu: introduce HostIOMMUContext
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-5-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <aa1bfbd5-e6de-6475-809e-a6ca46089aaa@redhat.com>
Date:   Mon, 30 Mar 2020 19:22:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-5-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yi,

On 3/30/20 6:24 AM, Liu Yi L wrote:
> Currently, many platform vendors provide the capability of dual stage
> DMA address translation in hardware. For example, nested translation
> on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> and etc. In dual stage DMA address translation, there are two stages
> address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> second-level) translation structures. Stage-1 translation results are
> also subjected to stage-2 translation structures. Take vSVA (Virtual
> Shared Virtual Addressing) as an example, guest IOMMU driver owns
> stage-1 translation structures (covers GVA->GPA translation), and host
> IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> translation). VMM is responsible to bind stage-1 translation structures
> to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> translation. For more background on SVA, refer the below links.
>  - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
>  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
> 
> In QEMU, vIOMMU emulators expose IOMMUs to VM per their own spec (e.g.
> Intel VT-d spec). Devices are pass-through to guest via device pass-
> through components like VFIO. VFIO is a userspace driver framework
> which exposes host IOMMU programming capability to userspace in a
> secure manner. e.g. IOVA MAP/UNMAP requests. Thus the major connection
> between VFIO and vIOMMU are MAP/UNMAP. However, with the dual stage
> DMA translation support, there are more interactions between vIOMMU and
> VFIO as below:

I think it is key to justify at some point why the IOMMU MR notifiers
are not usable for that purpose. If I remember correctly this is due to
the fact MR notifiers are not active on x86 in that use xase, which is
not the case on ARM dual stage enablement.

maybe: "Information, different from map/unmap notifications need to be
passed from QEMU vIOMMU device to/from the host IOMMU driver through the
VFIO/IOMMU layer: ..."

>  1) PASID allocation (allow host to intercept in PASID allocation)
>  2) bind stage-1 translation structures to host
>  3) propagate stage-1 cache invalidation to host
>  4) DMA address translation fault (I/O page fault) servicing etc.

> 
> With the above new interactions in QEMU, it requires an abstract layer
> to facilitate the above operations and expose to vIOMMU emulators as an
> explicit way for vIOMMU emulators call into VFIO. This patch introduces
> HostIOMMUContext to stand for hardware IOMMU w/ dual stage DMA address
> translation capability. And introduces HostIOMMUContextClass to provide
> methods for vIOMMU emulators to propagate dual-stage translation related
> requests to host. As a beginning, PASID allocation/free are defined to
> propagate PASID allocation/free requests to host which is helpful for the
> vendors who manage PASID in system-wide. In future, there will be more
> operations like bind_stage1_pgtbl, flush_stage1_cache and etc.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/Makefile.objs                      |  1 +
>  hw/iommu/Makefile.objs                |  1 +
>  hw/iommu/host_iommu_context.c         | 97 +++++++++++++++++++++++++++++++++++
>  include/hw/iommu/host_iommu_context.h | 75 +++++++++++++++++++++++++++
>  4 files changed, 174 insertions(+)
>  create mode 100644 hw/iommu/Makefile.objs
>  create mode 100644 hw/iommu/host_iommu_context.c
>  create mode 100644 include/hw/iommu/host_iommu_context.h
> 
> diff --git a/hw/Makefile.objs b/hw/Makefile.objs
> index 660e2b4..cab83fe 100644
> --- a/hw/Makefile.objs
> +++ b/hw/Makefile.objs
> @@ -40,6 +40,7 @@ devices-dirs-$(CONFIG_MEM_DEVICE) += mem/
>  devices-dirs-$(CONFIG_NUBUS) += nubus/
>  devices-dirs-y += semihosting/
>  devices-dirs-y += smbios/
> +devices-dirs-y += iommu/
>  endif
>  
>  common-obj-y += $(devices-dirs-y)
> diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
> new file mode 100644
> index 0000000..e6eed4e
> --- /dev/null
> +++ b/hw/iommu/Makefile.objs
> @@ -0,0 +1 @@
> +obj-y += host_iommu_context.o
> diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
> new file mode 100644
> index 0000000..5fb2223
> --- /dev/null
> +++ b/hw/iommu/host_iommu_context.c
> @@ -0,0 +1,97 @@
> +/*
> + * QEMU abstract of Host IOMMU
> + *
> + * Copyright (C) 2020 Intel Corporation.
> + *
> + * Authors: Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qom/object.h"
> +#include "qapi/visitor.h"
> +#include "hw/iommu/host_iommu_context.h"
> +
> +int host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx, uint32_t min,
> +                               uint32_t max, uint32_t *pasid)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!iommu_ctx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
> +
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(iommu_ctx->flags & HOST_IOMMU_PASID_REQUEST) ||
> +        !hicxc->pasid_alloc) {
At this point of the reading, I fail to understand why we need the flag.
Why isn't it sufficient to test whether the ops is set?
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->pasid_alloc(iommu_ctx, min, max, pasid);
> +}
> +
> +int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!iommu_ctx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(iommu_ctx->flags & HOST_IOMMU_PASID_REQUEST) ||
> +        !hicxc->pasid_free) {
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->pasid_free(iommu_ctx, pasid);
> +}
> +
> +void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
> +                         const char *mrtypename,
> +                         uint64_t flags)
> +{
> +    HostIOMMUContext *iommu_ctx;
> +
> +    object_initialize(_iommu_ctx, instance_size, mrtypename);
> +    iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
> +    iommu_ctx->flags = flags;
> +    iommu_ctx->initialized = true;
> +}
> +
> +static const TypeInfo host_iommu_context_info = {
> +    .parent             = TYPE_OBJECT,
> +    .name               = TYPE_HOST_IOMMU_CONTEXT,
> +    .class_size         = sizeof(HostIOMMUContextClass),
> +    .instance_size      = sizeof(HostIOMMUContext),
> +    .abstract           = true,
Can't we use the usual .instance_init and .instance_finalize?
> +};
> +
> +static void host_iommu_ctx_register_types(void)
> +{
> +    type_register_static(&host_iommu_context_info);
> +}
> +
> +type_init(host_iommu_ctx_register_types)
> diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
> new file mode 100644
> index 0000000..35c4861
> --- /dev/null
> +++ b/include/hw/iommu/host_iommu_context.h
> @@ -0,0 +1,75 @@
> +/*
> + * QEMU abstraction of Host IOMMU
> + *
> + * Copyright (C) 2020 Intel Corporation.
> + *
> + * Authors: Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef HW_IOMMU_CONTEXT_H
> +#define HW_IOMMU_CONTEXT_H
> +
> +#include "qemu/queue.h"
> +#include "qemu/thread.h"
> +#include "qom/object.h"
> +#include <linux/iommu.h>
> +#ifndef CONFIG_USER_ONLY
> +#include "exec/hwaddr.h"
> +#endif
> +
> +#define TYPE_HOST_IOMMU_CONTEXT "qemu:host-iommu-context"
> +#define HOST_IOMMU_CONTEXT(obj) \
> +        OBJECT_CHECK(HostIOMMUContext, (obj), TYPE_HOST_IOMMU_CONTEXT)
> +#define HOST_IOMMU_CONTEXT_GET_CLASS(obj) \
> +        OBJECT_GET_CLASS(HostIOMMUContextClass, (obj), \
> +                         TYPE_HOST_IOMMU_CONTEXT)
> +
> +typedef struct HostIOMMUContext HostIOMMUContext;
> +
> +typedef struct HostIOMMUContextClass {
> +    /* private */
> +    ObjectClass parent_class;
> +
> +    /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
Request the host to allocate a PASID?
"from HostIOMMUContext (a.k.a. host software)" is a bit cryptic to me.

Actually at this stage I do not understand what this HostIOMMUContext
abstracts. Is it an object associated to one guest FL context entry
(attached to one PASID). Meaning for just vIOMMU/VFIO using nested
paging (single PASID) I would use a single of such context per IOMMU MR?

I think David also felt difficult to understand the abstraction behind
this object.

> +    int (*pasid_alloc)(HostIOMMUContext *iommu_ctx,
> +                       uint32_t min,
> +                       uint32_t max,
> +                       uint32_t *pasid);
> +    /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
> +    int (*pasid_free)(HostIOMMUContext *iommu_ctx,
> +                      uint32_t pasid);
> +} HostIOMMUContextClass;
> +
> +/*
> + * This is an abstraction of host IOMMU with dual-stage capability
> + */
> +struct HostIOMMUContext {
> +    Object parent_obj;
> +#define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
> +    uint64_t flags;
> +    bool initialized;
what's the purpose of the initialized flag?
> +};
> +
> +int host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx, uint32_t min,
> +                               uint32_t max, uint32_t *pasid);
> +int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid);
> +
> +void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
> +                         const char *mrtypename,
> +                         uint64_t flags);
> +void host_iommu_ctx_destroy(HostIOMMUContext *iommu_ctx);
leftover from V1?
> +
> +#endif
> 
Thanks

Eric

