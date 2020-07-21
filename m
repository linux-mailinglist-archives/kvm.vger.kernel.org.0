Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7E228C1B
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 00:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgGUWnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 18:43:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40306 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbgGUWnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 18:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595371394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQt7o/tu0J33BtVCH3pQiWNfrbS5094FWCur3ksI/04=;
        b=e38JPTg6lPZfxypSyr6YC8kjBkvJbiZ+PcnXIF0BegufHRwZIcSHi+nZiLmhyjx46XhLaP
        MfZn/rkAufnDuOwknfqgzUvQjEI2Yn1rVCZmC39FDCNioTFMLGWYnineVqSHYu9DmIxuHU
        /xWpkCyUjyZcnR3MuhVgnipChyjlS6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-1lYjGpvkPquHIeoGx1DyTg-1; Tue, 21 Jul 2020 18:43:10 -0400
X-MC-Unique: 1lYjGpvkPquHIeoGx1DyTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51457107ACCA;
        Tue, 21 Jul 2020 22:43:07 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D8E778547;
        Tue, 21 Jul 2020 22:43:05 +0000 (UTC)
Date:   Tue, 21 Jul 2020 16:43:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        "Wang Haibin" <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200721164304.0ce76b2e@x1.home>
In-Reply-To: <450612c3-2a92-9034-7958-ee7f3c1a8c52@huawei.com>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
        <450612c3-2a92-9034-7958-ee7f3c1a8c52@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jul 2020 10:43:21 +0800
Xiang Zheng <zhengxiang9@huawei.com> wrote:

> Hi Kirti,
> 
> Sorry to disturb you since this patch set has been merged, and I cannot
> receive the qemu-side emails about this patch set.
> 
> We are going to support migration for VFIO devices which support dirty
> pages tracking.
> 
> And we also plan to leverage SMMU HTTU feature to do the dirty pages
> tracking for the devices which don't support dirty pages tracking.
> 
> For the above two cases, which side determines to choose IOMMU driver or
> vendor driver to do dirty bitmap tracking, Qemu or VFIO?
> 
> In brief, if both IOMMU and VFIO devices support dirty pages tracking,
> we can check the capability and prefer to track dirty pages on device
> vendor driver which is more efficient.
> 
> The qusetion is which side to do the check and selection? In my opinion,
> Qemu/userspace seems more suitable.

Dirty page tracking is consolidated at the vfio container level.
Userspace has no basis for determining or interface for selecting a
dirty bitmap provider, so I would disagree that QEMU should play any
role here.  The container dirty bitmap tries to provide the finest
granularity available based on the support of all the devices/groups
managed by the container.  If there are groups attached to the
container that have not participated in page pinning, then we consider
all DMA mappings within the container as persistently dirty.  Once all
of the participants subscribe to page pinning, the dirty scope is
reduced to the pinned pages.  IOMMU support for dirty page logging would
introduce finer granularity yet, which we would probably prefer over
page pinning, but interfaces for this have not been devised.

Ideally userspace should be unaware of any of this, the benefit would
be seen transparently by having a more sparsely filled dirty bitmap,
which more accurately reflects how memory is actually being dirtied.
Thanks,

Alex

