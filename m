Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31A1C94B3
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 17:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEGPRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 11:17:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54523 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726860AbgEGPRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 11:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588864635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z/OlOzT8kXQ9tIV1zzNzkxq8AeByeB5Iybv/LYpMqOY=;
        b=B09M4sQNDoyQkpvFWzQbYAO7WD8zs6e/bvAgF5aK6/okOVxDRkZe9XJJhEjI5/J6x1xg+C
        kKTB+FSg2kZCy9xFQYDC0LG2TdjGXGqxvdPDSzNsaL3CWHZyu4HGddB4/kjaDzusk2ubia
        QQJDl4jZQfSZgoPMSYM8GrwMjxCirZA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-YmlexjKBPbq3u_QbS9JsXQ-1; Thu, 07 May 2020 11:17:13 -0400
X-MC-Unique: YmlexjKBPbq3u_QbS9JsXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1625B473;
        Thu,  7 May 2020 15:17:11 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFC8D9323;
        Thu,  7 May 2020 15:17:07 +0000 (UTC)
Date:   Thu, 7 May 2020 09:17:06 -0600
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
Subject: Re: [PATCH Kernel v18 6/7] vfio iommu: Add migration capability to
 report supported features
Message-ID: <20200507091706.4ca1508e@x1.home>
In-Reply-To: <79f1a586-52be-ab72-493a-3a3c5ae6e252@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
        <1588607939-26441-7-git-send-email-kwankhede@nvidia.com>
        <20200506162738.6e08dbf2@w520.home>
        <79f1a586-52be-ab72-493a-3a3c5ae6e252@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 May 2020 11:07:26 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/7/2020 3:57 AM, Alex Williamson wrote:
> > On Mon, 4 May 2020 21:28:58 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> Added migration capability in IOMMU info chain.
> >> User application should check IOMMU info chain for migration capability
> >> to use dirty page tracking feature provided by kernel module.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
> >>   include/uapi/linux/vfio.h       | 14 ++++++++++++++
> >>   2 files changed, 29 insertions(+)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 8b27faf1ec38..b38d278d7bff 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -2378,6 +2378,17 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
> >>   	return ret;
> >>   }
> >>   
> >> +static int vfio_iommu_migration_build_caps(struct vfio_info_cap *caps)
> >> +{
> >> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
> >> +
> >> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
> >> +	cap_mig.header.version = 1;
> >> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
> >> +
> >> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
> >> +}
> >> +
> >>   static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   				   unsigned int cmd, unsigned long arg)
> >>   {
> >> @@ -2427,6 +2438,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   		if (ret)
> >>   			return ret;
> >>   
> >> +		ret = vfio_iommu_migration_build_caps(&caps);
> >> +		if (ret)
> >> +			return ret;
> >> +
> >>   		if (caps.size) {
> >>   			info.flags |= VFIO_IOMMU_INFO_CAPS;
> >>   
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index e3cbf8b78623..df9ce8aaafab 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -1013,6 +1013,20 @@ struct vfio_iommu_type1_info_cap_iova_range {
> >>   	struct	vfio_iova_range iova_ranges[];
> >>   };
> >>   
> >> +/*
> >> + * The migration capability allows to report supported features for migration.
> >> + *
> >> + * The structures below define version 1 of this capability.
> >> + */
> >> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> >> +
> >> +struct vfio_iommu_type1_info_cap_migration {
> >> +	struct	vfio_info_cap_header header;
> >> +	__u32	flags;
> >> +	/* supports dirty page tracking */
> >> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
> >> +};
> >> +  
> > 
> > What about exposing the maximum supported dirty bitmap size and the
> > supported page sizes?  Thanks,
> >   
> 
> How should user application use that?

How does a user application currently discover that only a PAGE_SIZE
dirty bitmap granularity is supported or that the when performing an
unmap while requesting the dirty bitmap, those unmaps need to be
chunked to no more than 2^31 * PAGE_SIZE?  I don't see anything in the
uapi that expresses these restrictions.

It seems we're currently relying on the QEMU implementation to
coincide with bitmap granularity support, with no mechanism other than
trial and error to validate or expand that support.  Likewise, I think
it's largely a coincidence that KVM also has the same slot size
restrictions, so we're unlikely to see an unmap exceeding this limit,
but our api does not restrict an unmap to only cover a single mapping.
We probably also need to think about whether we need to expose a
mapping chunk limitation separately or if it should be extrapolated
from the migration support (we might have non-migration reasons to
limit it at some point).

If we leave these as assumptions then we risk breaking userspace or
limiting the usefulness of expending this support.  If we include
within the uapi a mechanism for learning about these restrictions, then
it becomes a userspace problem to follow the uapi and take advantage of
the uapi provided.  Thanks,

Alex

