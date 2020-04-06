Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5E19F09B
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 09:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDFHMc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 6 Apr 2020 03:12:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:35572 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgDFHMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 03:12:32 -0400
IronPort-SDR: 1TfkQoUIvGf76bGEZo6Hjf8MTM1B+Fofehs/b7LXlYCvGIW4HGgJhQI491yAw5eFihH/peRvaT
 UD5WUx1kmCBw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 00:12:31 -0700
IronPort-SDR: q7b4Rl2dOcvLvA9MVLTPLwqWk3MsHEYDhQCDmDuSHmjdtOvvI/1worceTUiao1ett5w4UxPAvh
 l/0KZc6yM4Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,350,1580803200"; 
   d="scan'208";a="250806340"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga003.jf.intel.com with ESMTP; 06 Apr 2020 00:12:30 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Apr 2020 00:12:30 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Mon, 6 Apr 2020 15:12:27 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2 09/22] vfio/common: init HostIOMMUContext
 per-container
Thread-Topic: [PATCH v2 09/22] vfio/common: init HostIOMMUContext
 per-container
Thread-Index: AQHWBkpwPIB1pnyyvEKzxsLxObMvUahjYc6AgAhVRjA=
Date:   Mon, 6 Apr 2020 07:12:27 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A222FCD@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-10-git-send-email-yi.l.liu@intel.com>
 <55a767fb-ed98-bc30-5de1-0791f1ce8642@redhat.com>
In-Reply-To: <55a767fb-ed98-bc30-5de1-0791f1ce8642@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> From: Auger Eric <eric.auger@redhat.com>
> Sent: Wednesday, April 1, 2020 3:51 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> Subject: Re: [PATCH v2 09/22] vfio/common: init HostIOMMUContext per-container
> 
> Hi Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > In this patch, QEMU firstly gets iommu info from kernel to check the
> > supported capabilities by a VFIO_IOMMU_TYPE1_NESTING iommu. And inits
> > HostIOMMUContet instance.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/vfio/common.c | 99
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 99 insertions(+)
> >
> > diff --git a/hw/vfio/common.c b/hw/vfio/common.c index
> > 5f3534d..44b142c 100644
> > --- a/hw/vfio/common.c
> > +++ b/hw/vfio/common.c
> > @@ -1226,10 +1226,89 @@ static int
> vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
> >      return 0;
> >  }
> >
> > +/**
> > + * Get iommu info from host. Caller of this funcion should free
> > + * the memory pointed by the returned pointer stored in @info
> > + * after a successful calling when finished its usage.
> > + */
> > +static int vfio_get_iommu_info(VFIOContainer *container,
> > +                         struct vfio_iommu_type1_info **info) {
> > +
> > +    size_t argsz = sizeof(struct vfio_iommu_type1_info);
> > +
> > +    *info = g_malloc0(argsz);
> > +
> > +retry:
> > +    (*info)->argsz = argsz;
> > +
> > +    if (ioctl(container->fd, VFIO_IOMMU_GET_INFO, *info)) {
> > +        g_free(*info);
> > +        *info = NULL;
> > +        return -errno;
> > +    }
> > +
> > +    if (((*info)->argsz > argsz)) {
> > +        argsz = (*info)->argsz;
> > +        *info = g_realloc(*info, argsz);
> > +        goto retry;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +static struct vfio_info_cap_header *
> > +vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t
> > +id) {
> > +    struct vfio_info_cap_header *hdr;
> > +    void *ptr = info;
> > +
> > +    if (!(info->flags & VFIO_IOMMU_INFO_CAPS)) {
> > +        return NULL;
> > +    }
> > +
> > +    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
> > +        if (hdr->id == id) {
> > +            return hdr;
> > +        }
> > +    }
> > +
> > +    return NULL;
> > +}
> > +
> > +static int vfio_get_nesting_iommu_cap(VFIOContainer *container,
> > +                   struct vfio_iommu_type1_info_cap_nesting
> > +*cap_nesting) {
> > +    struct vfio_iommu_type1_info *info;
> > +    struct vfio_info_cap_header *hdr;
> > +    struct vfio_iommu_type1_info_cap_nesting *cap;
> > +    int ret;
> > +
> > +    ret = vfio_get_iommu_info(container, &info);
> > +    if (ret) {
> > +        return ret;
> > +    }
> > +
> > +    hdr = vfio_get_iommu_info_cap(info,
> > +                        VFIO_IOMMU_TYPE1_INFO_CAP_NESTING);
> > +    if (!hdr) {
> > +        g_free(info);
> > +        return -errno;
> > +    }
> > +
> > +    cap = container_of(hdr,
> > +                struct vfio_iommu_type1_info_cap_nesting, header);
> > +    *cap_nesting = *cap;
> > +
> > +    g_free(info);
> > +    return 0;
> > +}
> > +
> >  static int vfio_init_container(VFIOContainer *container, int group_fd,
> >                                 Error **errp)  {
> >      int iommu_type, ret;
> > +    uint64_t flags = 0;
> >
> >      iommu_type = vfio_get_iommu_type(container, errp);
> >      if (iommu_type < 0) {
> > @@ -1257,6 +1336,26 @@ static int vfio_init_container(VFIOContainer
> *container, int group_fd,
> >          return -errno;
> >      }
> >
> > +    if (iommu_type == VFIO_TYPE1_NESTING_IOMMU) {
> > +        struct vfio_iommu_type1_info_cap_nesting nesting = {
> > +                                         .nesting_capabilities = 0x0,
> > +                                         .stage1_formats = 0, };
> > +
> > +        ret = vfio_get_nesting_iommu_cap(container, &nesting);
> > +        if (ret) {
> > +            error_setg_errno(errp, -ret,
> > +                             "Failed to get nesting iommu cap");
> > +            return ret;
> > +        }
> > +
> > +        flags |= (nesting.nesting_capabilities & VFIO_IOMMU_PASID_REQS) ?
> > +                 HOST_IOMMU_PASID_REQUEST : 0;
> I still don't get why you can't transform your iommu_ctx into a  pointer and do
> container->iommu_ctx = g_new0(HostIOMMUContext, 1);
> then
> host_iommu_ctx_init(container->iommu_ctx, flags);
> 
> looks something similar to (hw/vfio/common.c). You may not even need to use a
> derived VFIOHostIOMMUContext object (As only VFIO does use that object)? Only
> the ops do change, no new field?
>         region->mem = g_new0(MemoryRegion, 1);
>         memory_region_init_io(region->mem, obj, &vfio_region_ops,
>                               region, name, region->size);

In this way, the vfio hook can easily get the VFIOContainer from
HostIOMMUContext when call in the hook provided by vfio. e.g. the
one below.

+static int vfio_host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx,
+                                           uint32_t min, uint32_t max,
+                                           uint32_t *pasid)
+{
+    VFIOContainer *container = container_of(iommu_ctx,
+                                            VFIOContainer, iommu_ctx);
 
Regards,
Yi Liu
