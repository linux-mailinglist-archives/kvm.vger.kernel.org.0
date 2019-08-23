Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0059B7E3
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 22:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392682AbfHWUvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 16:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388903AbfHWUvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 16:51:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC55D88305;
        Fri, 23 Aug 2019 20:51:19 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 958F719C4F;
        Fri, 23 Aug 2019 20:51:14 +0000 (UTC)
Date:   Fri, 23 Aug 2019 14:51:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linuxarm@huawei.com>, <john.garry@huawei.com>,
        <xuwei5@hisilicon.com>, <kevin.tian@intel.com>
Subject: Re: [PATCH v8 0/6] vfio/type1: Add support for valid iova list
 management
Message-ID: <20190823145113.5ea47e22@x1.home>
In-Reply-To: <20190723160637.8384-1-shameerali.kolothum.thodi@huawei.com>
References: <20190723160637.8384-1-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 23 Aug 2019 20:51:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Jul 2019 17:06:31 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> This is to revive this series which almost made to 4.18 but got dropped
> as Alex found an issue[1] with IGD and USB devices RMRR region being
> reported as reserved regions.
> 
> Thanks to Eric for his work here[2]. It provides a way to exclude
> these regions while reporting the valid iova regions and this respin
> make use of that.
> 
> Please note that I don't have a platform to verify the reported RMRR
> issue and appreciate testing on those platforms.
> 
> Thanks,
> Shameer
> 
> [1] https://lkml.org/lkml/2018/6/5/760
> [2] https://lore.kernel.org/patchwork/cover/1083072/
> 
> v7-->v8
>   -Rebased to 5.3-rc1
>   -Addressed comments from Alex and Eric. Please see
>    individual patch history.
>   -Added Eric's R-by to patches 4/5/6
> 
> v6-->v7
>  -Rebased to 5.2-rc6 + Eric's patches
>  -Added logic to exclude IOMMU_RESV_DIRECT_RELAXABLE reserved memory
>   region type(patch #2).
>  -Dropped patch #4 of v6 as it is already part of mainline.
>  -Addressed "container with only an mdev device will have an empty list"
>   case(patches 4/6 & 5/6 - Suggested by Alex)
> 
> Old
> ----
> This series introduces an iova list associated with a vfio 
> iommu. The list is kept updated taking care of iommu apertures,
> and reserved regions. Also this series adds checks for any conflict
> with existing dma mappings whenever a new device group is attached to
> the domain.
> 
> User-space can retrieve valid iova ranges using VFIO_IOMMU_GET_INFO
> ioctl capability chains. Any dma map request outside the valid iova
> range will be rejected.
> 
> v5 --> v6
> 
>  -Rebased to 4.17-rc1
>  -Changed the ordering such that previous patch#7 "iommu/dma: Move
>   PCI window region reservation back...")  is now patch #4. This
>   will avoid any bisection issues pointed out by Alex.
>  -Added Robins's Reviewed-by tag for patch#4
> 
> v4 --> v5
> Rebased to next-20180315.
>  
>  -Incorporated the corner case bug fix suggested by Alex to patch #5.
>  -Based on suggestions by Alex and Robin, added patch#7. This
>   moves the PCI window  reservation back in to DMA specific path.
>   This is to fix the issue reported by Eric[1].
> 
> v3 --> v4
>  Addressed comments received for v3.
>  -dma_addr_t instead of phys_addr_t
>  -LIST_HEAD() usage.
>  -Free up iova_copy list in case of error.
>  -updated logic in filling the iova caps info(patch #5)
> 
> RFCv2 --> v3
>  Removed RFC tag.
>  Addressed comments from Alex and Eric:
>  - Added comments to make iova list management logic more clear.
>  - Use of iova list copy so that original is not altered in
>    case of failure.
> 
> RFCv1 --> RFCv2
>  Addressed comments from Alex:
> -Introduced IOVA list management and added checks for conflicts with 
>  existing dma map entries during attach/detach.
> 
> Shameer Kolothum (6):
>   vfio/type1: Introduce iova list and add iommu aperture validity check
>   vfio/type1: Check reserved region conflict and update iova list
>   vfio/type1: Update iova list on detach
>   vfio/type1: check dma map request is within a valid iova range
>   vfio/type1: Add IOVA range capability support
>   vfio/type1: remove duplicate retrieval of reserved regions
> 
>  drivers/vfio/vfio_iommu_type1.c | 518 +++++++++++++++++++++++++++++++-
>  include/uapi/linux/vfio.h       |  26 +-
>  2 files changed, 531 insertions(+), 13 deletions(-)
> 

Applied to the vfio next branch for v5.4 with Eric's additional reviews.
Thanks!

Alex
