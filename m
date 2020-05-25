Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA071E10B4
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390935AbgEYOlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:41:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46551 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390928AbgEYOlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590417694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqkg1jDCwm+p6v+Tu6WyELF7ni9j35HF99yDHkpEXsw=;
        b=hkZdjVffJr4y4sHihbL87sTZzG9+J27GK8v4Oa59mBAFQevjQro8e1MiGr/t/j8IJk2VPc
        epbSFlCUgbtcOHyYI9KWkJGjSe4Cbag5O7GTSU1lGgov1tqZUNCepsHjIrDl+6tWVN0AnR
        5/vyMZCciANSnovLp/OXsFn7b4UaHG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-zHspUxfPMe23EkzGUFNbPQ-1; Mon, 25 May 2020 10:41:31 -0400
X-MC-Unique: zHspUxfPMe23EkzGUFNbPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 856F0800688;
        Mon, 25 May 2020 14:41:28 +0000 (UTC)
Received: from gondolin (ovpn-112-215.ams2.redhat.com [10.36.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E12B6ED99;
        Mon, 25 May 2020 14:41:21 +0000 (UTC)
Date:   Mon, 25 May 2020 16:41:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v23 4/8] vfio iommu: Add ioctl definition for
 dirty pages tracking
Message-ID: <20200525164117.7d078845.cohuck@redhat.com>
In-Reply-To: <1589998088-3250-5-git-send-email-kwankhede@nvidia.com>
References: <1589998088-3250-1-git-send-email-kwankhede@nvidia.com>
        <1589998088-3250-5-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 May 2020 23:38:04 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> All pages pinned by vendor driver through this API should be considered as
> dirty during migration. When container consists of IOMMU capable device and
> all pages are pinned and mapped, then all pages are marked dirty.
> Added support to start/stop dirtied pages tracking and to get bitmap of all
> dirtied pages for requested IO virtual address range.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 56 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)

(...)

> +/**
> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *                                     struct vfio_iommu_type1_dirty_bitmap)
> + * IOCTL is used for dirty pages logging.
> + * Caller should set flag depending on which operation to perform, details as
> + * below:
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START flag set, instructs
> + * the IOMMU driver to log pages that are dirtied or potentially dirtied by
> + * device; designed to be used when a migration is in progress. Dirty pages are

s/device/the device/

> + * loggeded until logging is disabled by user application by calling the IOCTL

s/loggeded/logged/

> + * with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag set, instructs
> + * the IOMMU driver to stop logging dirtied pages.
> + *
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set
> + * returns the dirty pages bitmap for IOMMU container for a given IOVA range.
> + * User must specify the IOVA range and the pgsize through the structure

s/User/The user/

> + * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
> + * supports to get bitmap of smallest supported pgsize only and can be modified

s/to get/getting a/

s/smallest/the smallest/

> + * in future to get bitmap of specified pgsize. The user must provide a zeroed

"a bitmap of any specified supported pgsize" ?

> + * memory area for the bitmap memory and specify its size in bitmap.size.
> + * One bit is used to represent one page consecutively starting from iova
> + * offset. The user should provide page size in bitmap.pgsize field. A bit set
> + * in the bitmap indicates that the page at that offset from iova is dirty.
> + * The caller must set argsz to a value including the size of structure
> + * vfio_iommu_type1_dirty_bitmap_get, but excluding the size of the actual
> + * bitmap. If dirty pages logging is not enabled, an error will be returned.

(...)

With the nits fixed,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

