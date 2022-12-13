Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0BE64BB22
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 18:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiLMRca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 12:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiLMRcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 12:32:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9889523E96
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2TqRyv0mTDcc+B0MCoj2HfDWqQ30TKvEn4VKuug9olM=;
        b=BavzSSeuFcQOK2hO5cDVGQQdIGLB0xjCMkwj3hyD3a+6q9PEATD5cV9c+vy/KXgCNK9dYT
        DNkruBFPsM2d7SfK0505ZC8ny9uIQ17r3cD2Szu6SYV2svuS+hImJPNbIQg0GHkaaCOe5w
        t2mN8+FIThosA2s7AhVHkxqWINNOCxY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-179-eEhgGYNrMHWsWxGXoTyncw-1; Tue, 13 Dec 2022 12:31:13 -0500
X-MC-Unique: eEhgGYNrMHWsWxGXoTyncw-1
Received: by mail-il1-f198.google.com with SMTP id a13-20020a056e0208ad00b003034c36b8b5so7911088ilt.9
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 09:31:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2TqRyv0mTDcc+B0MCoj2HfDWqQ30TKvEn4VKuug9olM=;
        b=t2JdjVd9ntpynkwheP/tFBQD3aMroZOWPaRHMGZ8V4QDK7pHX9MDf9IM2IgdYOVR32
         v5Pj4I4DwxZQX4cYsFt0IK2gmegSRiVmp0j6oqL7c0ddv3Y+4fi6q32mCV968H8dZ6Zh
         okwmIuq/BuWiaINz70q4Mj7rkkjT+adj+Jhn4Et/iEoLNhaxUrgJ4f+XSIt5MKl52kLJ
         5lbR8SvbiG0hZq50t8ixiVjEgiMjNqp+3pKS82XGG0EwzhZZ0qkH1+mHVWV9TJEplEfh
         FTucC4IM1++vAp2pSR90HiLaLIOGqv0+Pd2fLpoXz3AJZCwxUGAN23bfbXItRIz9wANd
         VphA==
X-Gm-Message-State: ANoB5pkgXu68xJDydIBGzAfS0HLsYuSxkXIRGNCod38LVUjHQm4PYLoZ
        LRYHBN5ZJFW081u0/h8XGI9YQlYY2nVx+BpoBMyg0jko3RsOJaBYXINmxQamr3DUIog2sqbl76Q
        wr7Y7ANM9szFO
X-Received: by 2002:a92:d792:0:b0:303:8cff:983b with SMTP id d18-20020a92d792000000b003038cff983bmr12396582iln.14.1670952672554;
        Tue, 13 Dec 2022 09:31:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Nhlvph//bWv0tKC40Nia1Qll4EawFYub8OZYbLNr6NqK7TccvvGcVi+FfT71pT9oMGI6U0A==
X-Received: by 2002:a92:d792:0:b0:303:8cff:983b with SMTP id d18-20020a92d792000000b003038cff983bmr12396564iln.14.1670952672252;
        Tue, 13 Dec 2022 09:31:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u70-20020a022349000000b003865944247dsm1000868jau.113.2022.12.13.09.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:31:11 -0800 (PST)
Date:   Tue, 13 Dec 2022 10:31:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V1 1/2] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221213103109.67c2e2ca.alex.williamson@redhat.com>
In-Reply-To: <3f3ca4c0-b401-0d18-e911-18189ff9c1d0@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
        <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
        <20221213092610.636686fc.alex.williamson@redhat.com>
        <3f3ca4c0-b401-0d18-e911-18189ff9c1d0@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 11:54:33 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/13/2022 11:26 AM, Alex Williamson wrote:
> > On Tue, 13 Dec 2022 07:46:55 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> >> Their kernel threads could be blocked indefinitely by a misbehaving
> >> userland while trying to pin/unpin pages while vaddrs are being updated.  
> > 
> > Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> >   
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
> >>  include/uapi/linux/vfio.h       |  6 +++++-
> >>  2 files changed, 29 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 23c24fe..f81e925 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -1343,6 +1343,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>  
> >>  	mutex_lock(&iommu->lock);
> >>  
> >> +	/* Cannot update vaddr if mdev is present. */
> >> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
> >> +		goto unlock;
> >> +
> >>  	pgshift = __ffs(iommu->pgsize_bitmap);
> >>  	pgsize = (size_t)1 << pgshift;
> >>  
> >> @@ -2189,6 +2193,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>  
> >>  	mutex_lock(&iommu->lock);
> >>  
> >> +	/* Prevent an mdev from sneaking in while vaddr flags are used. */
> >> +	if (iommu->vaddr_invalid_count && type == VFIO_EMULATED_IOMMU)
> >> +		goto out_unlock;  
> > 
> > Why only mdev devices?  If we restrict that the user cannot attach a
> > group while there are invalid vaddrs, and the pin/unpin pages and
> > dma_rw interfaces are restricted to cases where vaddr_invalid_count is
> > zero, then we can get rid of all the code to handle waiting for vaddrs.
> > ie. we could still revert:
> > 
> > 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
> > 487ace134053 ("vfio/type1: implement notify callback")
> > ec5e32940cc9 ("vfio: iommu driver notify callback")
> > 
> > It appears to me it might be easiest to lead with a clean revert of
> > these, then follow-up imposing the usage restrictions, and I'd go ahead
> > and add WARN_ON error paths to the pin/unpin/dma_rw paths to make sure
> > nobody enters those paths with an elevated invalid count.  Thanks,  
> 
> Will do.  I think I will put the revert at the end, though, as dead code 
> clean up.  That patch will be larger, and if it is judged to be too large
> for stable, it can be omitted from stable.
> 
> - Steve
> 
> >> +
> >>  	/* Check for duplicates */
> >>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
> >>  		goto out_unlock;
> >> @@ -2660,6 +2668,20 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
> >>  	return ret;
> >>  }
> >>  
> >> +/*
> >> + * Disable this feature if mdevs are present.  They cannot safely pin/unpin
> >> + * while vaddrs are being updated.
> >> + */
> >> +static int vfio_iommu_can_update_vaddr(struct vfio_iommu *iommu)
> >> +{
> >> +	int ret;
> >> +
> >> +	mutex_lock(&iommu->lock);
> >> +	ret = list_empty(&iommu->emulated_iommu_groups);
> >> +	mutex_unlock(&iommu->lock);
> >> +	return ret;
> >> +}

I'd also keep this generic to what it's actually doing, ie. simply
reporting if emulated_iommu_groups are present, so it could be
something like:

static bool vfio_iommu_has_emulated(struct vfio_iommu *iommu)

OTOH, I'm not sure it actually makes sense to dynamically change
reported value, the IOMMU backend supports vaddr update, but there are
usage restrictions and there's no way that this test can't be racy w/
other user actions.  Does it have specific utility in userspace to test
for this immediately before a live-update, or would QEMU enable support
for the feature based only on some initial condition?  Thanks,

Alex


> >> +
> >>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
> >>  					    unsigned long arg)
> >>  {
> >> @@ -2668,8 +2690,9 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
> >>  	case VFIO_TYPE1v2_IOMMU:
> >>  	case VFIO_TYPE1_NESTING_IOMMU:
> >>  	case VFIO_UNMAP_ALL:
> >> -	case VFIO_UPDATE_VADDR:
> >>  		return 1;
> >> +	case VFIO_UPDATE_VADDR:
> >> +		return iommu && vfio_iommu_can_update_vaddr(iommu);
> >>  	case VFIO_DMA_CC_IOMMU:
> >>  		if (!iommu)
> >>  			return 0;
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index d7d8e09..6d36b84 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -49,7 +49,11 @@
> >>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
> >>  #define VFIO_UNMAP_ALL			9
> >>  
> >> -/* Supports the vaddr flag for DMA map and unmap */
> >> +/*
> >> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
> >> + * devices, so this capability is subject to change as groups are added or
> >> + * removed.
> >> + */
> >>  #define VFIO_UPDATE_VADDR		10
> >>  
> >>  /*  
> >   
> 

