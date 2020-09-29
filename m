Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C570927D74E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 21:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgI2Twp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 15:52:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727758AbgI2Two (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 15:52:44 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601409163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gMdwuCpOh/nwgsUZha8J6mJLEGqGIPS0qTYJXjMijtQ=;
        b=dUyGd1XQgceYwHhJ0QVKBqbo4+KgA1+mQOQv2xsZBR7ZpkGaPMHMRpaf0Hee9w2ExADFUd
        mEhAlU62rHBJLMrOyZQPmT1Ro/I1aLsRByFfEDSVRZeNS0Y0YvjoXGtByuIKWx5uSsj39z
        wV427l2MqaCgxufLIp1XrqT6aKv1euo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-USZBNIvZPDuob-6Qjivajg-1; Tue, 29 Sep 2020 15:52:41 -0400
X-MC-Unique: USZBNIvZPDuob-6Qjivajg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE2491882FC7;
        Tue, 29 Sep 2020 19:52:38 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DACB760C13;
        Tue, 29 Sep 2020 19:52:30 +0000 (UTC)
Date:   Tue, 29 Sep 2020 13:52:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        Zhengxiao.zx@alibaba-inc.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yan.y.zhao@intel.com, kvm@vger.kernel.org,
        eskultet@redhat.com, ziye.yang@intel.com, qemu-devel@nongnu.org,
        cohuck@redhat.com, shuangtai.tst@alibaba-inc.com,
        dgilbert@redhat.com, zhi.a.wang@intel.com, mlevitsk@redhat.com,
        pasic@linux.ibm.com, aik@ozlabs.ru, eauger@redhat.com,
        felipe@nutanix.com, jonathan.davies@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com
Subject: Re: [PATCH Kernel v24 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200929135230.6cfb24aa@x1.home>
In-Reply-To: <20200929082702.GA181243@stefanha-x1.localdomain>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
        <20200929082702.GA181243@stefanha-x1.localdomain>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 09:27:02 +0100
Stefan Hajnoczi <stefanha@gmail.com> wrote:

> On Fri, May 29, 2020 at 02:00:46AM +0530, Kirti Wankhede wrote:
> > * IOCTL VFIO_IOMMU_DIRTY_PAGES to get dirty pages bitmap with
> >   respect to IOMMU container rather than per device. All pages pinned by
> >   vendor driver through vfio_pin_pages external API has to be marked as
> >   dirty during  migration. When IOMMU capable device is present in the
> >   container and all pages are pinned and mapped, then all pages are marked
> >   dirty.  
> 
> From what I can tell only the iommu participates in dirty page tracking.
> This places the responsibility for dirty page tracking on IOMMUs. My
> understanding is that support for dirty page tracking is currently not
> available in IOMMUs.
> 
> Can a PCI device implement its own DMA dirty log and let an mdev driver
> implement the dirty page tracking using this mechanism? That way we
> don't need to treat all pinned pages as dirty all the time.

Look at the last patch in this series, there we define a mechanism
whereby the act of a vendor driver pinning pages both marks those pages
dirty and indicates a mode in the vfio type1 container where the scope
of dirty pages is limited to those pages pinned by the driver.  The
vfio_dma_rw() interface does the same.  We could clearly implement a
more lightweight interface for this as well, one without pinning or
memory access, but there are no proposed users for such an interface
currently.  Thanks,

Alex

