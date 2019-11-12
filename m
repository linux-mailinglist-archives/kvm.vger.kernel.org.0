Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4087CF9D05
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 23:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLWaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 17:30:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726988AbfKLWa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 17:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573597827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IFjoCXM3aDjIq+KpZvKaiyfBSifVnRLohoE7M9/BvmA=;
        b=fRNegOORrhoDJXUoHqWE0uxEHEdRzPj6Iw3Gv93FKLDPVDEYnh6MwMIdpMZsDVZa74xUhX
        yBcyia92SWLaES8BPLr/5GmJvs7vmtHI0DIZ6qgggFg6yuS8/SOBKPd85Z4Jrhj+abmrFi
        m4gTyHgwDFakWV9yev6o9QULFx1sKDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-mYuiBlk2OPOXKtpPfD_7tQ-1; Tue, 12 Nov 2019 17:30:24 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7332464A7D;
        Tue, 12 Nov 2019 22:30:22 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22F1328D3C;
        Tue, 12 Nov 2019 22:30:21 +0000 (UTC)
Date:   Tue, 12 Nov 2019 15:30:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Message-ID: <20191112153020.71406c44@x1.home>
In-Reply-To: <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: mYuiBlk2OPOXKtpPfD_7tQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 22:33:37 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> All pages pinned by vendor driver through vfio_pin_pages API should be
> considered as dirty during migration. IOMMU container maintains a list of
> all such pinned pages. Added an ioctl defination to get bitmap of such

definition

> pinned pages for requested IO virtual address range.

Additionally, all mapped pages are considered dirty when physically
mapped through to an IOMMU, modulo we discussed devices opting in to
per page pinning to indicate finer granularity with a TBD mechanism to
figure out if any non-opt-in devices remain.

> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 35b09427ad9f..6fd3822aa610 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE=09_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE=09_IO(VFIO_TYPE, VFIO_BASE + 16)
> =20
> +/**
> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *                                     struct vfio_iommu_type1_dirty_bit=
map)
> + *
> + * IOCTL to get dirty pages bitmap for IOMMU container during migration.
> + * Get dirty pages bitmap of given IO virtual addresses range using
> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is siz=
e of
> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory to =
get
> + * bitmap and should set size of allocated memory in bitmap_size field.
> + * One bit is used to represent per page consecutively starting from iov=
a
> + * offset. Bit set indicates page at that offset from iova is dirty.
> + */
> +struct vfio_iommu_type1_dirty_bitmap {
> +=09__u32        argsz;
> +=09__u32        flags;
> +=09__u64        iova;                      /* IO virtual address */
> +=09__u64        size;                      /* Size of iova range */
> +=09__u64        bitmap_size;               /* in bytes */

This seems redundant.  We can calculate the size of the bitmap based on
the iova size.

> +=09void __user *bitmap;                    /* one bit per page */

Should we define that as a __u64* to (a) help with the size
calculation, and (b) assure that we can use 8-byte ops on it?

However, who defines page size?  Is it necessarily the processor page
size?  A physical IOMMU may support page sizes other than the CPU page
size.  It might be more important to indicate the expected page size
than the bitmap size.  Thanks,

Alex

> +};
> +
> +#define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE=
 + 17)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------=
 */
> =20
>  /*

