Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05919B4E5
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 19:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732350AbgDARvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 13:51:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29099 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732121AbgDARvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 13:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585763473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PG0mI5eHkGbwvq67u35+FOh/HVp+TxwItkfZypfOujk=;
        b=BiCQSPS0QRX8xLbmhbG88CGz185wJbhGaLIznGv8ZFXmwIkccYAcMeN+wWpL4ojCSAf6iB
        53nhvt/EmIUSF56MQGD7qFOtcy2MzRjELoC8upEnt1BS4Eok7aHWumiH2++GESZFQQicx9
        jd8VeprEewXaUA6vw/18NdpoCEGz3z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-S-w7g0gUNguSjwdTEXGsLA-1; Wed, 01 Apr 2020 13:51:09 -0400
X-MC-Unique: S-w7g0gUNguSjwdTEXGsLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EA1D10CE786;
        Wed,  1 Apr 2020 17:51:06 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80F4519C69;
        Wed,  1 Apr 2020 17:51:04 +0000 (UTC)
Date:   Wed, 1 Apr 2020 11:51:03 -0600
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
Subject: Re: [PATCH v17 Kernel 6/7] vfio iommu: Adds flag to indicate dirty
 pages tracking capability support
Message-ID: <20200401115103.4e8f81d9@w520.home>
In-Reply-To: <ba5227f9-bf22-3a7b-638d-c434f18495f4@nvidia.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
        <1585587044-2408-7-git-send-email-kwankhede@nvidia.com>
        <20200330145814.32d9b652@w520.home>
        <6c6e6625-6dfd-d885-23fe-511744816d5b@nvidia.com>
        <20200331131539.390259e1@w520.home>
        <ba5227f9-bf22-3a7b-638d-c434f18495f4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Apr 2020 22:55:57 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 4/1/2020 12:45 AM, Alex Williamson wrote:
> > On Wed, 1 Apr 2020 00:38:49 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 3/31/2020 2:28 AM, Alex Williamson wrote:  
> >>> On Mon, 30 Mar 2020 22:20:43 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>      
> >>>> Flag VFIO_IOMMU_INFO_DIRTY_PGS in VFIO_IOMMU_GET_INFO indicates that driver
> >>>> support dirty pages tracking.
> >>>>
> >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>>> ---
> >>>>    drivers/vfio/vfio_iommu_type1.c | 3 ++-
> >>>>    include/uapi/linux/vfio.h       | 5 +++--
> >>>>    2 files changed, 5 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>>> index 266550bd7307..9fe12b425976 100644
> >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>> @@ -2390,7 +2390,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>>>    			info.cap_offset = 0; /* output, no-recopy necessary */
> >>>>    		}
> >>>>    
> >>>> -		info.flags = VFIO_IOMMU_INFO_PGSIZES;
> >>>> +		info.flags = VFIO_IOMMU_INFO_PGSIZES |
> >>>> +			     VFIO_IOMMU_INFO_DIRTY_PGS;
> >>>>    
> >>>>    		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
> >>>>    
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index e3cbf8b78623..0fe7c9a6f211 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -985,8 +985,9 @@ struct vfio_device_feature {
> >>>>    struct vfio_iommu_type1_info {
> >>>>    	__u32	argsz;
> >>>>    	__u32	flags;
> >>>> -#define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
> >>>> -#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> >>>> +#define VFIO_IOMMU_INFO_PGSIZES   (1 << 0) /* supported page sizes info */
> >>>> +#define VFIO_IOMMU_INFO_CAPS      (1 << 1) /* Info supports caps */
> >>>> +#define VFIO_IOMMU_INFO_DIRTY_PGS (1 << 2) /* supports dirty page tracking */
> >>>>    	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
> >>>>    	__u32   cap_offset;	/* Offset within info struct of first cap */
> >>>>    };  
> >>>
> >>>
> >>> As I just mentioned in my reply to Yan, I'm wondering if
> >>> VFIO_CHECK_EXTENSION would be a better way to expose this.  The
> >>> difference is relatively trivial, but currently the only flag
> >>> set by VFIO_IOMMU_GET_INFO is to indicate the presence of a field in
> >>> the returned structure.  I think this is largely true of other INFO
> >>> ioctls within vfio as well and we're already using the
> >>> VFIO_CHECK_EXTENSION ioctl to check supported IOMMU models, and IOMMU
> >>> cache coherency.  We'd simply need to define a VFIO_DIRTY_PGS_IOMMU
> >>> value (9) and return 1 for that case.  Then when we enable support for
> >>> dirt pages that can span multiple mappings, we can add a v2 extensions,
> >>> or "MULTI" variant of this extension, since it should be backwards
> >>> compatible.
> >>>
> >>> The v2/multi version will again require that the user provide a zero'd
> >>> bitmap, but I don't think that should be a problem as part of the
> >>> definition of that version (we won't know if the user is using v1 or
> >>> v2, but a v1 user should only retrieve bitmaps that exactly match
> >>> existing mappings, where all bits will be written).  Thanks,
> >>>
> >>> Alex
> >>>      
> >>
> >> I look at these two ioctls as : VFIO_CHECK_EXTENSION is used to get
> >> IOMMU type, while VFIO_IOMMU_GET_INFO is used to get properties of a
> >> particular IOMMU type, right?  
> > 
> > Not exclusively, see for example VFIO_DMA_CC_IOMMU,
> >   
> >> Then I think VFIO_IOMMU_INFO_DIRTY_PGS should be part of
> >> VFIO_IOMMU_GET_INFO and when we add code for v2/multi, a flag should be
> >> added to VFIO_IOMMU_GET_INFO.  
> > 
> > Which burns through flags, which is a far more limited resource than
> > our 32bit extension address space, especially when we're already
> > planning for one or more extensions to this support.  Thanks,
> >   
> 
> To use flag from VFIO_IOMMU_GET_INFO was your original suggestion, only 
> 3 bits are used here as of now.

Sorry, I'm not infallible.  Perhaps I was short sighted and thought we
might only need one flag, perhaps I forgot about the check-extension
ioctl.  Are there any technical reasons to keep it on the get-info
ioctl?  As I'm trying to look ahead for how we're going to fill the
gaps of this initial implementation, it seems to me that what we're
exposing here is in line with what we've used check-extension for in
the past, and it offers us essentially unlimited extensions to burn
through, while we're clearly limited on the get-info flags.  We do have
the precedent of the reset flag on the device_get_info ioctl, but I'm
largely under the impression that was a mistake and queuing up multiple
missing features in addition to the base flags feels like compounding
another mistake.  Thanks,

Alex

