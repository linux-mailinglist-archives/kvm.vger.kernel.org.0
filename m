Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A65619A693
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 09:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgDAHvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 03:51:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54291 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731680AbgDAHvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 03:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585727463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zKmkcFAeYkQC5+2s/XUIkEeLKqrQCJQCL5NCupQG9sM=;
        b=HW3gUo3XIgy3dxb+Q6ReePu2IzBp3KLXsg7RXGhcH2ohWjusszKBXSdyTQ9BfO9Rtk2tSd
        YaxxnGMHLUiNgWALLr6JR+Wm/CX6DIHIP+RqUgK/XRf8XGU43dF2eJ0NsQg+zTsVw8IjeC
        WaNCUG5VZg3vVzARk5frVEcSAHBJIO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-E1aw_hGBMYm1ayf1pDI5-Q-1; Wed, 01 Apr 2020 03:50:59 -0400
X-MC-Unique: E1aw_hGBMYm1ayf1pDI5-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 136F48017CC;
        Wed,  1 Apr 2020 07:50:58 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AA5E05D9CD;
        Wed,  1 Apr 2020 07:50:46 +0000 (UTC)
Subject: Re: [PATCH v2 09/22] vfio/common: init HostIOMMUContext per-container
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-10-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <55a767fb-ed98-bc30-5de1-0791f1ce8642@redhat.com>
Date:   Wed, 1 Apr 2020 09:50:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-10-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 3/30/20 6:24 AM, Liu Yi L wrote:
> In this patch, QEMU firstly gets iommu info from kernel to check the
> supported capabilities by a VFIO_IOMMU_TYPE1_NESTING iommu. And inits
> HostIOMMUContet instance.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/vfio/common.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 5f3534d..44b142c 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -1226,10 +1226,89 @@ static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
>      return 0;
>  }
>  
> +/**
> + * Get iommu info from host. Caller of this funcion should free
> + * the memory pointed by the returned pointer stored in @info
> + * after a successful calling when finished its usage.
> + */
> +static int vfio_get_iommu_info(VFIOContainer *container,
> +                         struct vfio_iommu_type1_info **info)
> +{
> +
> +    size_t argsz = sizeof(struct vfio_iommu_type1_info);
> +
> +    *info = g_malloc0(argsz);
> +
> +retry:
> +    (*info)->argsz = argsz;
> +
> +    if (ioctl(container->fd, VFIO_IOMMU_GET_INFO, *info)) {
> +        g_free(*info);
> +        *info = NULL;
> +        return -errno;
> +    }
> +
> +    if (((*info)->argsz > argsz)) {
> +        argsz = (*info)->argsz;
> +        *info = g_realloc(*info, argsz);
> +        goto retry;
> +    }
> +
> +    return 0;
> +}
> +
> +static struct vfio_info_cap_header *
> +vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
> +{
> +    struct vfio_info_cap_header *hdr;
> +    void *ptr = info;
> +
> +    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
> +        return NULL;
> +    }
> +
> +    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
> +        if (hdr->id == id) {
> +            return hdr;
> +        }
> +    }
> +
> +    return NULL;
> +}
> +
> +static int vfio_get_nesting_iommu_cap(VFIOContainer *container,
> +                   struct vfio_iommu_type1_info_cap_nesting *cap_nesting)
> +{
> +    struct vfio_iommu_type1_info *info;
> +    struct vfio_info_cap_header *hdr;
> +    struct vfio_iommu_type1_info_cap_nesting *cap;
> +    int ret;
> +
> +    ret = vfio_get_iommu_info(container, &info);
> +    if (ret) {
> +        return ret;
> +    }
> +
> +    hdr = vfio_get_iommu_info_cap(info,
> +                        VFIO_IOMMU_TYPE1_INFO_CAP_NESTING);
> +    if (!hdr) {
> +        g_free(info);
> +        return -errno;
> +    }
> +
> +    cap = container_of(hdr,
> +                struct vfio_iommu_type1_info_cap_nesting, header);
> +    *cap_nesting = *cap;
> +
> +    g_free(info);
> +    return 0;
> +}
> +
>  static int vfio_init_container(VFIOContainer *container, int group_fd,
>                                 Error **errp)
>  {
>      int iommu_type, ret;
> +    uint64_t flags = 0;
>  
>      iommu_type = vfio_get_iommu_type(container, errp);
>      if (iommu_type < 0) {
> @@ -1257,6 +1336,26 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>          return -errno;
>      }
>  
> +    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
> +        struct vfio_iommu_type1_info_cap_nesting nesting = {
> +                                         .nesting_capabilities = 0x0,
> +                                         .stage1_formats = 0, };
> +
> +        ret = vfio_get_nesting_iommu_cap(container, &nesting);
> +        if (ret) {
> +            error_setg_errno(errp, -ret,
> +                             "Failed to get nesting iommu cap");
> +            return ret;
> +        }
> +
> +        flags |= (nesting.nesting_capabilities & VFIO_IOMMU_PASID_REQS) ?
> +                 HOST_IOMMU_PASID_REQUEST : 0;
I still don't get why you can't transform your iommu_ctx into a  pointer
and do
container->iommu_ctx = g_new0(HostIOMMUContext, 1);
then
host_iommu_ctx_init(container->iommu_ctx, flags);

looks something similar to (hw/vfio/common.c). You may not even need to
use a derived VFIOHostIOMMUContext object (As only VFIO does use that
object)? Only the ops do change, no new field?
        region->mem = g_new0(MemoryRegion, 1);
        memory_region_init_io(region->mem, obj, &vfio_region_ops,
                              region, name, region->size);

Thanks

Eric

> +        host_iommu_ctx_init(&container->iommu_ctx,
> +                            sizeof(container->iommu_ctx),
> +                            TYPE_VFIO_HOST_IOMMU_CONTEXT,
> +                            flags);
> +    }
> +
>      container->iommu_type = iommu_type;
>      return 0;
>  }
> 

