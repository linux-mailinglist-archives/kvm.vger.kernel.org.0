Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA0421D18
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 06:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJEEDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 00:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhJEEDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 00:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633406518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DlPXPp7f/SqcU484a3jYLDZk6nPasGsDeSJIwRqsrqA=;
        b=dtLUYsnBMEdt4sstoqDXO1PJCuSs3Jr3SwGzdOyMpg8KoL40XrriQaPNT46b8rr50NRXdC
        whFWgI9dE6gTimo8C0+HPsSbSK3UwyuHFH1Bo1RzHPrMHth9YonLytKaNV9uOCP0OGfZpr
        a0ukUOPvjg7csAkiFdOzUc7ymQ/G5ZI=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-fACls_YBNsC9MdWAPsiB4g-1; Tue, 05 Oct 2021 00:01:57 -0400
X-MC-Unique: fACls_YBNsC9MdWAPsiB4g-1
Received: by mail-ot1-f69.google.com with SMTP id l32-20020a9d1ca0000000b00546e6ec87afso13629097ota.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 21:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DlPXPp7f/SqcU484a3jYLDZk6nPasGsDeSJIwRqsrqA=;
        b=s2p2GLZ1GtBPH9gtKHJJFBAUUsrNhVhqD7YaT7cuwa8c1AHFHaEWgeW8ZLWe9vkSmI
         k7Fd4tXpcqf/KWYZNE4wIZ9KA0xQwitDGJPsu0azgNs/qZGBtxXzWewDxU2EWkh2hqzH
         ZGpXvIEHCBzmsbnXn1pKqntOsl3uln111fShwlL8wVDWgckIiRAMVbeI8K3K4fX30EPA
         Vulsx8wDDL7kiaz7y+ze9pt2BIk465fiyyPt8KBdMR7wbSxPZQiOojTRqImyXM062PRa
         vOA2FZ5ex6kgwLDJ0ShVqF0txAp1tv28D6na8m1qbCpBrDwlhDf85PahnjozY7yep1jU
         t/OQ==
X-Gm-Message-State: AOAM53162meFP0DveGupavIGdh40YDQG2/3GnHpbD15SjSeVOV02fzSU
        +tU+Mf0DInA238vsIGx5BIVjeLwBHvXoV+V0M3FwoE3rgp2D51KgwDWgfyikIko+mNhp0KNT0bQ
        Ll7P5XubRs0V1
X-Received: by 2002:aca:2802:: with SMTP id 2mr670393oix.105.1633406516358;
        Mon, 04 Oct 2021 21:01:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9/Hn5QcBWSIopkft/013m2god4FuRDb/u46D8iabRt1d0BdIgXJgRK2aDba5c7B5ovQOfdA==
X-Received: by 2002:aca:2802:: with SMTP id 2mr670382oix.105.1633406516201;
        Mon, 04 Oct 2021 21:01:56 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id b19sm3317114otk.75.2021.10.04.21.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 21:01:55 -0700 (PDT)
Date:   Mon, 4 Oct 2021 22:01:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211004220154.519181c6.alex.williamson@redhat.com>
In-Reply-To: <20211004223641.GO964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <20211004162543.0fff3a96.alex.williamson@redhat.com>
        <20211004223641.GO964074@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 Oct 2021 19:36:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 04, 2021 at 04:25:43PM -0600, Alex Williamson wrote:
> > On Fri,  1 Oct 2021 20:22:22 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > If vfio_create_group() searches the group list and returns an already
> > > existing group it does not put back the iommu_group reference that the
> > > caller passed in.
> > > 
> > > Change the semantic of vfio_create_group() to not move the reference in
> > > from the caller, but instead obtain a new reference inside and leave the
> > > caller's reference alone. The two callers must now call iommu_group_put().
> > > 
> > > This is an unlikely race as the only caller that could hit it has already
> > > searched the group list before attempting to create the group.
> > > 
> > > Fixes: cba3345cc494 ("vfio: VFIO core")
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > >  drivers/vfio/vfio.c | 18 +++++++++---------
> > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 1cb12033b02240..bf233943dc992f 100644
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -338,6 +338,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
> > >  		list_del(&unbound->unbound_next);
> > >  		kfree(unbound);
> > >  	}
> > > +	iommu_group_put(group->iommu_group);
> > >  	kfree(group);
> > >  }
> > >  
> > > @@ -389,6 +390,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> > >  	atomic_set(&group->opened, 0);
> > >  	init_waitqueue_head(&group->container_q);
> > >  	group->iommu_group = iommu_group;
> > > +	/* put in vfio_group_unlock_and_free() */
> > > +	iommu_group_ref_get(iommu_group);  
> 
>       ^^^^^^^^^^^^^^^^^
> 
> > >  	group->type = type;
> > >  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> > >  
> > > @@ -396,8 +399,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> > >  
> > >  	ret = iommu_group_register_notifier(iommu_group, &group->nb);
> > >  	if (ret) {
> > > -		kfree(group);
> > > -		return ERR_PTR(ret);
> > > +		group = ERR_PTR(ret);
> > > +		goto err_put_group;
> > >  	}
> > >  
> > >  	mutex_lock(&vfio.group_lock);
> > > @@ -432,6 +435,9 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
> > >  
> > >  	mutex_unlock(&vfio.group_lock);
> > >  
> > > +err_put_group:
> > > +	iommu_group_put(iommu_group);
> > > +	kfree(group);  
> > 
> > ????
> > 
> > In the non-error path we're releasing the caller's reference which is
> > now their responsibility to release,  
> 
> This release is paried with the get in the same function added one
> hunk above

Note that this is the common exit path until the last patch in the
series pulls returning the successfully created/found group above the
error condition exit paths.  As it stands, this patch unconditionally
releases the reference it claims to newly create.  Thanks,

Alex
 
> > but in any case we're freeing the object that we return?  That
> > can't be right.  
> 
> Yes, that is a rebasing mistake pulling this back from the last patch
> that had a "return ret" here, thanks
> 
> > > @@ -776,10 +780,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> > >  
> > >  	/* a newly created vfio_group keeps the reference. */  
> > 
> > This comment is now incorrect.  Thanks,  
> 
> Indeed
> 
> Jason
> 

