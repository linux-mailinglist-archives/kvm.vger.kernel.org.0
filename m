Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BE0126B72
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfLSS4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 13:56:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730825AbfLSS4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 13:56:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576781790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=50ypp4twcT7h3+0B/Lg/fNtkFrCt7aoByDDwvMuuMiQ=;
        b=UMVp1uj/8lekcWC7bYg83gA1r3mrlTp4DcKXsdgNKKi+8y/74TYDlqxdrhdNq/J9m2Akf+
        ceyUGY4n59N/ERy+49oQW0wYW1aVazhgbREkQzjDO0hR/fHDRQo06eiOTd8g1XXbWG6Lxl
        CGHybQegGPtcSmSHcu0de4IkICr/ftE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-w_dsgI9dOZK8MOwxNR9XOA-1; Thu, 19 Dec 2019 13:56:26 -0500
X-MC-Unique: w_dsgI9dOZK8MOwxNR9XOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04ABA107ACC9;
        Thu, 19 Dec 2019 18:56:24 +0000 (UTC)
Received: from x1.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D127100EBAA;
        Thu, 19 Dec 2019 18:56:22 +0000 (UTC)
Date:   Thu, 19 Dec 2019 11:56:21 -0700
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
Message-ID: <20191219115621.67e2fe7c@x1.home>
In-Reply-To: <6667e0b4-f3da-6283-3f27-c1cba3d13117@nvidia.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
        <1576527700-21805-5-git-send-email-kwankhede@nvidia.com>
        <20191217051513.GE21868@joy-OptiPlex-7040>
        <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
        <20191218143902.3c9b06df@x1.home>
        <6667e0b4-f3da-6283-3f27-c1cba3d13117@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 00:12:30 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 12/19/2019 3:09 AM, Alex Williamson wrote:
> > On Tue, 17 Dec 2019 14:54:14 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 12/17/2019 10:45 AM, Yan Zhao wrote:  
> >>> On Tue, Dec 17, 2019 at 04:21:39AM +0800, Kirti Wankhede wrote:  
> >>>> +		} else if (range.flags &
> >>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >>>> +			uint64_t iommu_pgmask;
> >>>> +			unsigned long pgshift = __ffs(range.pgsize);
> >>>> +			unsigned long *bitmap;
> >>>> +			long bsize;
> >>>> +
> >>>> +			iommu_pgmask =
> >>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> >>>> +
> >>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> >>>> +			    (range.pgsize - 1))
> >>>> +				return -EINVAL;
> >>>> +
> >>>> +			if (range.iova & iommu_pgmask)
> >>>> +				return -EINVAL;
> >>>> +			if (!range.size || range.size > SIZE_MAX)
> >>>> +				return -EINVAL;
> >>>> +			if (range.iova + range.size < range.iova)
> >>>> +				return -EINVAL;
> >>>> +
> >>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
> >>>> +						   range.bitmap_size);
> >>>> +			if (bsize)
> >>>> +				return ret;
> >>>> +
> >>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);
> >>>> +			if (!bitmap)
> >>>> +				return -ENOMEM;
> >>>> +
> >>>> +			ret = copy_from_user(bitmap,
> >>>> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
> >>>> +			if (ret)
> >>>> +				goto bitmap_exit;
> >>>> +
> >>>> +			iommu->dirty_page_tracking = false;  
> >>> why iommu->dirty_page_tracking is false here?
> >>> suppose this ioctl can be called several times.
> >>>      
> >>
> >> This ioctl can be called several times, but once this ioctl is called
> >> that means vCPUs are stopped and VFIO devices are stopped (i.e. in
> >> stop-and-copy phase) and dirty pages bitmap are being queried by user.  
> > 
> > Do not assume how userspace works or its intent.  If dirty tracking is
> > on, it should remain on until the user turns it off.  We cannot assume
> > userspace uses a one-shot approach.  Thanks,
> >   
> 
> Dirty tracking should be on until user turns it off or user reads 
> bitmap, right? This ioctl is used to read bitmap.

No, dirty bitmap tracking is on until the user turns it off, period.
Retrieving the bitmap is probably only looking at a portion of the
container address space at a time, anything else would place
impractical requirements on the user allocated bitmap.  We also need to
support a usage model where the user is making successive calls, where
each should report pages dirtied since the previous call.  If the user
is required to re-enable tracking, there's an irreconcilable gap
between the call to retrieve the dirty bitmap and their opportunity to
re-enable dirty tracking.  It's fundamentally broken to automatically
disable tracking on read.  Thanks,

Alex

