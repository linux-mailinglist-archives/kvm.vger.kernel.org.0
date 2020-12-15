Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5FD2DB0A6
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 16:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbgLOP4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 10:56:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730483AbgLOPzj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 10:55:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608047651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tPEqUf9K/9QpL3MMNAVvudGcFr4JwyB646HzAagpF+Q=;
        b=aS95BRmN62TySJIblZRYPGlFEMwqIDRr1LfzD8/6l1Rng4f4kAE3grU7ee2W2dRN/o8WNm
        qz+De8UqC6WIMZMeTm49+I31qRnWZ00MSaBGxhV9BGmX7gZKyuQjij+DfKBfe40dc336pj
        vUsWQ+whTwKsmC6z5t6q5ff45OcH2WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-XRpPflBjPsmL5JDWg5sD-Q-1; Tue, 15 Dec 2020 10:54:06 -0500
X-MC-Unique: XRpPflBjPsmL5JDWg5sD-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C2A7192CC41;
        Tue, 15 Dec 2020 15:54:03 +0000 (UTC)
Received: from x1.home (ovpn-112-193.phx2.redhat.com [10.3.112.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 917E81962E;
        Tue, 15 Dec 2020 15:54:00 +0000 (UTC)
Date:   Tue, 15 Dec 2020 08:53:59 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     zhukeqian <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        "Marc Zyngier" <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when
 promote pinned_scope
Message-ID: <20201215085359.053e73ed@x1.home>
In-Reply-To: <d2073c05-b6c9-04b4-782c-b89680834633@huawei.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
        <20201210073425.25960-5-zhukeqian1@huawei.com>
        <20201214170459.50cb8729@omen.home>
        <d2073c05-b6c9-04b4-782c-b89680834633@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Dec 2020 17:37:11 +0800
zhukeqian <zhukeqian1@huawei.com> wrote:

> Hi Alex,
> 
> On 2020/12/15 8:04, Alex Williamson wrote:
> > On Thu, 10 Dec 2020 15:34:22 +0800
> > Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >   
> >> When we pin or detach a group which is not dirty tracking capable,
> >> we will try to promote pinned_scope of vfio_iommu.
> >>
> >> If we succeed to do so, vfio only report pinned_scope as dirty to
> >> userspace next time, but these memory written before pin or detach
> >> is missed.
> >>
> >> The solution is that we must populate all dma range as dirty before
> >> promoting pinned_scope of vfio_iommu.  
> > 
> > Please don't bury fixes patches into a series with other optimizations
> > and semantic changes.  Send it separately.
> >   
> OK, I will.
> 
> >>
> >> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index bd9a94590ebc..00684597b098 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -1633,6 +1633,20 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
> >>  	return group;
> >>  }
> >>  
> >> +static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n;
> >> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> >> +
> >> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +		unsigned long nbits = dma->size >> pgshift;
> >> +
> >> +		if (dma->iommu_mapped)
> >> +			bitmap_set(dma->bitmap, 0, nbits);
> >> +	}
> >> +}  
> > 
> > 
> > If we detach a group which results in only non-IOMMU backed mdevs,
> > don't we also clear dma->iommu_mapped as part of vfio_unmap_unpin()
> > such that this test is invalid?  Thanks,  
> 
> Good spot :-). The code will skip bitmap_set under this situation.
> 
> We should set the bitmap unconditionally when vfio_iommu is promoted,
> as we must have IOMMU backed domain before promoting the vfio_iommu.
> 
> Besides, I think we should also mark dirty in vfio_remove_dma if dirty
> tracking is active. Right?

There's no remaining bitmap to mark dirty if the vfio_dma is removed.
In this case it's the user's responsibility to collect remaining dirty
pages using the VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP support in the
VFIO_IOMMU_UNMAP_DMA ioctl.  Thanks,

Alex

> >> +
> >>  static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> >>  {
> >>  	struct vfio_domain *domain;
> >> @@ -1657,6 +1671,10 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
> >>  	}
> >>  
> >>  	iommu->pinned_page_dirty_scope = true;
> >> +
> >> +	/* Set all bitmap to avoid missing dirty page */
> >> +	if (iommu->dirty_page_tracking)
> >> +		vfio_populate_bitmap_all(iommu);
> >>  }
> >>  
> >>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,  
> > 
> > .
> >   
> 

