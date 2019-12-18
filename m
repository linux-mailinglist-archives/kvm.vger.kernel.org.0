Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4771254DC
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLRVjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:39:12 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25394 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726387AbfLRVjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 16:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576705150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9TtCci2FuLajUtFOw5B/HodtCZRSzWxgnpe0HYK4bg=;
        b=e/PHyS+WzhcioDHG9fRTHI83wk3APbJCx+9CCS8qu8du02DJwvLP3D9rCEsvsBFrmXZ3ie
        5FQ0lMlfvJiayczd6EVY1XceHcKAxru0qqGHeeS4HxDiZaFdRshbIobdZ1G91NThJKBjJz
        9g616ZkG29WSP1yAiZZ40+Ze2nJnNoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-TtPgruxiOy2jW2yv518w1w-1; Wed, 18 Dec 2019 16:39:07 -0500
X-MC-Unique: TtPgruxiOy2jW2yv518w1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08FF7801E6D;
        Wed, 18 Dec 2019 21:39:05 +0000 (UTC)
Received: from x1.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36C0426DEC;
        Wed, 18 Dec 2019 21:39:03 +0000 (UTC)
Date:   Wed, 18 Dec 2019 14:39:02 -0700
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
Subject: Re: [PATCH v10 Kernel 4/5] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20191218143902.3c9b06df@x1.home>
In-Reply-To: <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
        <1576527700-21805-5-git-send-email-kwankhede@nvidia.com>
        <20191217051513.GE21868@joy-OptiPlex-7040>
        <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Dec 2019 14:54:14 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 12/17/2019 10:45 AM, Yan Zhao wrote:
> > On Tue, Dec 17, 2019 at 04:21:39AM +0800, Kirti Wankhede wrote:  
> >> +		} else if (range.flags &
> >> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >> +			uint64_t iommu_pgmask;
> >> +			unsigned long pgshift = __ffs(range.pgsize);
> >> +			unsigned long *bitmap;
> >> +			long bsize;
> >> +
> >> +			iommu_pgmask =
> >> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> >> +
> >> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> >> +			    (range.pgsize - 1))
> >> +				return -EINVAL;
> >> +
> >> +			if (range.iova & iommu_pgmask)
> >> +				return -EINVAL;
> >> +			if (!range.size || range.size > SIZE_MAX)
> >> +				return -EINVAL;
> >> +			if (range.iova + range.size < range.iova)
> >> +				return -EINVAL;
> >> +
> >> +			bsize = verify_bitmap_size(range.size >> pgshift,
> >> +						   range.bitmap_size);
> >> +			if (bsize)
> >> +				return ret;
> >> +
> >> +			bitmap = kmalloc(bsize, GFP_KERNEL);
> >> +			if (!bitmap)
> >> +				return -ENOMEM;
> >> +
> >> +			ret = copy_from_user(bitmap,
> >> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
> >> +			if (ret)
> >> +				goto bitmap_exit;
> >> +
> >> +			iommu->dirty_page_tracking = false;  
> > why iommu->dirty_page_tracking is false here?
> > suppose this ioctl can be called several times.
> >   
> 
> This ioctl can be called several times, but once this ioctl is called 
> that means vCPUs are stopped and VFIO devices are stopped (i.e. in 
> stop-and-copy phase) and dirty pages bitmap are being queried by user.

Do not assume how userspace works or its intent.  If dirty tracking is
on, it should remain on until the user turns it off.  We cannot assume
userspace uses a one-shot approach.  Thanks,

Alex

