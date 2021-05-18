Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968CC38802D
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351795AbhERTAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351742AbhERTA0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7+Of3GQlEaxF6vUCdyxydmId0hVDaVNL3IbEpWr9BNw=;
        b=NiXwDWcHLNli9dqOVB1uHBPvtLWm/BboXn0JYX34SYR6947m/oms3nYSiSkaKYQayXGTIx
        gox3RJ1odR72p658oAqEfy841qq9eXuz2uCBhfhkKYkkfYjwElbkG3dm0QbDpGqSOKsaoD
        E9RuscrJQ6d+dicsk29O7shJe4X1qUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-xyyVlO3AOVOBG8smG7_f5w-1; Tue, 18 May 2021 14:59:03 -0400
X-MC-Unique: xyyVlO3AOVOBG8smG7_f5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 164BE801106;
        Tue, 18 May 2021 18:59:00 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B5F1037F46;
        Tue, 18 May 2021 18:58:59 +0000 (UTC)
Date:   Tue, 18 May 2021 12:57:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 0/8] Add IOPF support for VFIO passthrough
Message-ID: <20210518125756.4c075300.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-1-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:12 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> Hi,
> 
> Requesting for your comments and suggestions. :-)
> 
> The static pinning and mapping problem in VFIO and possible solutions
> have been discussed a lot [1, 2]. One of the solutions is to add I/O
> Page Fault support for VFIO devices. Different from those relatively
> complicated software approaches such as presenting a vIOMMU that provides
> the DMA buffer information (might include para-virtualized optimizations),
> IOPF mainly depends on the hardware faulting capability, such as the PCIe
> PRI extension or Arm SMMU stall model. What's more, the IOPF support in
> the IOMMU driver has already been implemented in SVA [3]. So we add IOPF
> support for VFIO passthrough based on the IOPF part of SVA in this series.

The SVA proposals are being reworked to make use of a new IOASID
object, it's not clear to me that this shouldn't also make use of that
work as it does a significant expansion of the type1 IOMMU with fault
handlers that would duplicate new work using that new model.

> We have measured its performance with UADK [4] (passthrough an accelerator
> to a VM(1U16G)) on Hisilicon Kunpeng920 board (and compared with host SVA):
> 
> Run hisi_sec_test...
>  - with varying sending times and message lengths
>  - with/without IOPF enabled (speed slowdown)
> 
> when msg_len = 1MB (and PREMAP_LEN (in Patch 4) = 1):
>             slowdown (num of faults)
>  times      VFIO IOPF      host SVA
>  1          63.4% (518)    82.8% (512)
>  100        22.9% (1058)   47.9% (1024)
>  1000       2.6% (1071)    8.5% (1024)
> 
> when msg_len = 10MB (and PREMAP_LEN = 512):
>             slowdown (num of faults)
>  times      VFIO IOPF
>  1          32.6% (13)
>  100        3.5% (26)
>  1000       1.6% (26)

It seems like this is only an example that you can make a benchmark
show anything you want.  The best results would be to pre-map
everything, which is what we have without this series.  What is an
acceptable overhead to incur to avoid page pinning?  What if userspace
had more fine grained control over which mappings were available for
faulting and which were statically mapped?  I don't really see what
sense the pre-mapping range makes.  If I assume the user is QEMU in a
non-vIOMMU configuration, pre-mapping the beginning of each RAM section
doesn't make any logical sense relative to device DMA.

Comments per patch to follow.  Thanks,

Alex


> History:
> 
> v2 -> v3
>  - Nit fixes.
>  - No reason to disable reporting the unrecoverable faults. (baolu)
>  - Maintain a global IOPF enabled group list.
>  - Split the pre-mapping optimization to be a separate patch.
>  - Add selective faulting support (use vfio_pin_pages to indicate the
>    non-faultable scope and add a new struct vfio_range to record it,
>    untested). (Kevin)
> 
> v1 -> v2
>  - Numerous improvements following the suggestions. Thanks a lot to all
>    of you.
> 
> Note that PRI is not supported at the moment since there is no hardware.
> 
> Links:
> [1] Lesokhin I, et al. Page Fault Support for Network Controllers. In ASPLOS,
>     2016.
> [2] Tian K, et al. coIOMMU: A Virtual IOMMU with Cooperative DMA Buffer Tracking
>     for Efficient Memory Management in Direct I/O. In USENIX ATC, 2020.
> [3] https://patchwork.kernel.org/project/linux-arm-kernel/cover/20210401154718.307519-1-jean-philippe@linaro.org/
> [4] https://github.com/Linaro/uadk
> 
> Thanks,
> Shenming
> 
> 
> Shenming Lu (8):
>   iommu: Evolve the device fault reporting framework
>   vfio/type1: Add a page fault handler
>   vfio/type1: Add an MMU notifier to avoid pinning
>   vfio/type1: Pre-map more pages than requested in the IOPF handling
>   vfio/type1: VFIO_IOMMU_ENABLE_IOPF
>   vfio/type1: No need to statically pin and map if IOPF enabled
>   vfio/type1: Add selective DMA faulting support
>   vfio: Add nested IOPF support
> 
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |    3 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   18 +-
>  drivers/iommu/iommu.c                         |   56 +-
>  drivers/vfio/vfio.c                           |   85 +-
>  drivers/vfio/vfio_iommu_type1.c               | 1000 ++++++++++++++++-
>  include/linux/iommu.h                         |   19 +-
>  include/linux/vfio.h                          |   13 +
>  include/uapi/linux/iommu.h                    |    4 +
>  include/uapi/linux/vfio.h                     |    6 +
>  9 files changed, 1181 insertions(+), 23 deletions(-)
> 

