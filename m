Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D82A1C6EC3
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 12:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEFKyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 06:54:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725882AbgEFKyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 06:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588762460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9//tHt6cJR5VhOE5k3wA+oIAxXhJd4WDDfFvhLWI5Q=;
        b=HIhbM2wV0s0nhbxan9VrSMWVf+SOf8Ic/ZFPZEqcMAVkirAHdzMfxswuCyu0WBhQCb5gii
        1dM8r9KsUD/w4sJ2HI2ye622+BLHQ5eD53wRLdmERXWFTl7kikcL7C8Q0VGFb1oPpQvG7J
        xCECQBH4xog1WtvUqJPyUmQ8BNlJ7aA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-bl0BdUidNqO3EW6VgeHAcA-1; Wed, 06 May 2020 06:54:17 -0400
X-MC-Unique: bl0BdUidNqO3EW6VgeHAcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D48F81895A2A;
        Wed,  6 May 2020 10:54:14 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D077863F90;
        Wed,  6 May 2020 10:54:07 +0000 (UTC)
Date:   Wed, 6 May 2020 12:54:05 +0200
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
Subject: Re: [PATCH Kernel v18 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200506125405.745bb99e.cohuck@redhat.com>
In-Reply-To: <1588607939-26441-5-git-send-email-kwankhede@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
        <1588607939-26441-5-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 21:28:56 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> - Start dirty pages tracking while migration is active
> - Stop dirty pages tracking.
> - Get dirty pages bitmap. Its user space application's responsibility to
>   copy content of dirty pages from source to destination during migration.
> 
> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> structure. Bitmap size is calculated considering smallest supported page
> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> 
> Bitmap is populated for already pinned pages when bitmap is allocated for
> a vfio_dma with the smallest supported page size. Update bitmap from
> pinning functions when tracking is enabled. When user application queries
> bitmap, check if requested page size is same as page size used to
> populated bitmap. If it is equal, copy bitmap, but if not equal, return
> error.
> 
> Fixed below error by changing pgsize type from uint64_t to size_t.
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors:
> drivers/vfio/vfio_iommu_type1.c:197: undefined reference to `__udivdi3'
> 
> drivers/vfio/vfio_iommu_type1.c:225: undefined reference to `__udivdi3'

Move that below the '---' delimiter so that it does not end up in the
commit? (Crediting the build bot is fine, but the details are not
really useful when you look at the code later.)

> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 260 insertions(+), 6 deletions(-)

> @@ -2278,6 +2435,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> +		struct vfio_iommu_type1_dirty_bitmap dirty;
> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> +		int ret = 0;
> +
> +		if (!iommu->v2)
> +			return -EACCES;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> +				    flags);
> +
> +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (dirty.argsz < minsz || dirty.flags & ~mask)
> +			return -EINVAL;
> +
> +		/* only one flag should be set at a time */
> +		if (__ffs(dirty.flags) != __fls(dirty.flags))
> +			return -EINVAL;
> +

Shouldn't you also check whether the flag that is set is actually
valid? (maybe dirty.flags & ~VFIO_IOMMU_DIRTY_PAGES_FLAG_MASK and do a
switch/case over dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_MASK)

