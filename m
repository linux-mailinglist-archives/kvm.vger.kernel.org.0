Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108DF2F539A
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 20:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbhAMTqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 14:46:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbhAMTqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 14:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610567097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4Z3jFP0BCotXt6cyfJnWEDzVW1oD6mwzBUvUy4fLBA=;
        b=EeN7nNuC+E6RYa20CrB7R+OUAd4Cj6WESjqb3/8d03SxBlsMhUuhaQhRpjbuBDCpnd9EZW
        rrcRC0NSNWfzBeZ9v1Cp/t/M73qbDUq/8fhvqXPPph6ZX152fC+X4HYV34OjCgY2bFZvem
        gnFTfH4MpoL5dmn4YHcHNtJfcCZpt84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-q3_kgtXPOnK2x06xHOTccA-1; Wed, 13 Jan 2021 14:44:56 -0500
X-MC-Unique: q3_kgtXPOnK2x06xHOTccA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD7B015722;
        Wed, 13 Jan 2021 19:44:54 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA9B117001;
        Wed, 13 Jan 2021 19:44:53 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:44:53 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 3/5] vfio: detect closed container
Message-ID: <20210113124453.0ff1c756@omen.home.shazbot.org>
In-Reply-To: <20210113122609.2bedad55@omen.home.shazbot.org>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
        <20210108123905.30d647d4@omen.home>
        <b7b51ee2-b7f6-61c4-c00d-166d9f56cbe7@oracle.com>
        <20210113122609.2bedad55@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 12:26:09 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 11 Jan 2021 16:12:18 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
> > On 1/8/2021 2:39 PM, Alex Williamson wrote:  
> > > On Tue,  5 Jan 2021 07:36:51 -0800
> > > Steve Sistare <steven.sistare@oracle.com> wrote:
> > >     
> > >> Add a function that detects if an iommu_group has a valid container.
> > >>
> > >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> > >> ---
> > >>  drivers/vfio/vfio.c  | 12 ++++++++++++
> > >>  include/linux/vfio.h |  1 +
> > >>  2 files changed, 13 insertions(+)
> > >>
> > >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > >> index 262ab0e..f89ab80 100644
> > >> --- a/drivers/vfio/vfio.c
> > >> +++ b/drivers/vfio/vfio.c
> > >> @@ -61,6 +61,7 @@ struct vfio_container {
> > >>  	struct vfio_iommu_driver	*iommu_driver;
> > >>  	void				*iommu_data;
> > >>  	bool				noiommu;
> > >> +	bool				closed;
> > >>  };
> > >>  
> > >>  struct vfio_unbound_dev {
> > >> @@ -1223,6 +1224,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
> > >>  
> > >>  	filep->private_data = NULL;
> > >>  
> > >> +	container->closed = true;
> > >>  	vfio_container_put(container);
> > >>  
> > >>  	return 0;
> > >> @@ -2216,6 +2218,16 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
> > >>  
> > >> +bool vfio_iommu_group_contained(struct iommu_group *iommu_group)
> > >> +{
> > >> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> > >> +	bool ret = group && group->container && !group->container->closed;
> > >> +
> > >> +	vfio_group_put(group);
> > >> +	return ret;
> > >> +}
> > >> +EXPORT_SYMBOL_GPL(vfio_iommu_group_contained);    
> > > 
> > > This seems like a pointless interface, the result is immediately stale.
> > > Anything that relies on the container staying open needs to add itself
> > > as a user.  We already have some interfaces for that, ex.
> > > vfio_group_get_external_user().  Thanks,    
> > 
> > The significant part here is container->closed, which is only set if userland closes the
> > container fd, which is a one-way trip -- the fd for this instance can never be opened 
> > again.  The container object may still have other references, and not be destroyed yet.
> > In patch 5, kernel code that waits for the RESUME ioctl calls this accessor to test if 
> > the ioctl will never arrive.  
> 
> Ok, that makes sense, the "contained" naming notsomuch.  You mention on
> 5/5 that you considered defining a new backend interface to call from
> the core, but considered it overkill.  I'm not sure what you're
> imagining that would be overkill.  We can pretty simply add an optional
> callback to struct vfio_iommu_drivers_ops that would allow the iommu
> driver to be notified when the container fd is released.  That seems
> quite simple and avoids the inverted calling structure presented here.

A callback into the iommu backend would also allow you to use a
waitqueue and wake_up for the blocking mechanism while vaddr is
invalid.  Seems like an improvement over the polling model.  Thanks,

Alex

