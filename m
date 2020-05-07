Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26A41C9924
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 20:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEGSUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 14:20:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57105 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGSUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 14:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588875604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgewtUy9bTNyZauHpI56baWIlBcAHHHwwe5CUmUNguk=;
        b=f24JsHq8PIKEvtblQYnI2TrRqm+Qen4tcuhV/o0POV/9Dvx9dcPvhu98fjIUaxy4scESW9
        u5Szl+Dbj7tRAhXWoEX8rov856u3+DmqzAaDIyn1OXOxQbIbPitrqZRpABgA4ojjJQQMYl
        LL/RQjaXv2KXVISaf69TOgPnWrMgFk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-1X-11krePSqtA8qFXcj8yA-1; Thu, 07 May 2020 14:20:00 -0400
X-MC-Unique: 1X-11krePSqtA8qFXcj8yA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C257107ACCD;
        Thu,  7 May 2020 18:19:58 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98CB970559;
        Thu,  7 May 2020 18:19:56 +0000 (UTC)
Date:   Thu, 7 May 2020 12:19:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v18 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200507121956.45b2500f@x1.home>
In-Reply-To: <24223faa-15ac-bd71-6c5d-9d0401fbd839@nvidia.com>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
        <1588607939-26441-5-git-send-email-kwankhede@nvidia.com>
        <20200506081510.GC19334@joy-OptiPlex-7040>
        <24223faa-15ac-bd71-6c5d-9d0401fbd839@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 May 2020 01:12:25 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/6/2020 1:45 PM, Yan Zhao wrote:
> > On Mon, May 04, 2020 at 11:58:56PM +0800, Kirti Wankhede wrote:  
> 
> <snip>
> 
> >>   /*
> >>    * Helper Functions for host iova-pfn list
> >>    */
> >> @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   			vfio_unpin_page_external(dma, iova, do_accounting);
> >>   			goto pin_unwind;
> >>   		}
> >> +
> >> +		if (iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift =
> >> +					 __ffs(vfio_pgsize_bitmap(iommu));
> >> +  
> > hi Kirti,
> > may I know if there's any vfio_pin_pages() happpening during NVidia's vGPU migration?
> > the code would enter into deadlock as I reported in last version.
> >   
> 
> Hm, you are right and same is the case in vfio_iommu_type1_dma_rw_chunk().
> 
> Instead of calling vfio_pgsize_bitmap() from lots of places, I'm 
> thinking of saving pgsize_bitmap in struct vfio_iommu, which should be 
> populated whenever domain_list is updated. Alex, will that be fine?

I've wondered why we don't already cache this, so yes, that's fine, but
the cached value will only be valid when evaluated under iommu->lock.
Thanks,

Alex

