Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA3431F1E3
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 22:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBRV5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 16:57:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhBRV5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 16:57:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613685371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UwfqdvgXW5YV2n7ZLVg99JtxtTC8HlmnYeiQHi+6cYw=;
        b=FBUo2KCglpPDX4nNYZFxzw23opABSPoXHaKTITxsZ1hhfgTPRNw3YsA8nywvKGoDlQngGb
        n9ku0tv4EoWIUi04t6hh0413kLgpk6k7+RASUHT0+905KjTlzqs9AasjlfKP1E4Ctwc1rS
        iLsnVdLCsIf+gPFkuGqA7B8As8YAOD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-m66-vAlkOGi0aAkq3DdAfA-1; Thu, 18 Feb 2021 16:56:09 -0500
X-MC-Unique: m66-vAlkOGi0aAkq3DdAfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DFA0BBEF5;
        Thu, 18 Feb 2021 21:56:07 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6DD050DDE;
        Thu, 18 Feb 2021 21:56:06 +0000 (UTC)
Date:   Thu, 18 Feb 2021 14:56:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
Message-ID: <20210218145606.09f08044@omen.home.shazbot.org>
In-Reply-To: <20210218011209.GB4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
        <161315805248.7320.13358719859656681660.stgit@gimli.home>
        <20210212212057.GW4247@nvidia.com>
        <20210218011209.GB4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Feb 2021 21:12:09 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Feb 12, 2021 at 05:20:57PM -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 12, 2021 at 12:27:39PM -0700, Alex Williamson wrote:  
> > > Create an interface through vfio-core where a vfio bus driver (ex.
> > > vfio-pci) can register the vm_operations_struct it uses to map device
> > > memory, along with a set of registration callbacks.  This allows
> > > vfio-core to expose interfaces for IOMMU backends to match a
> > > vm_area_struct to a bus driver and register a notifier for relavant
> > > changes to the device mapping.  For now we define only a notifier
> > > action for closing the device.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >  drivers/vfio/vfio.c  |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/vfio.h |   20 ++++++++
> > >  2 files changed, 140 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 38779e6fd80c..568f5e37a95f 100644
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -47,6 +47,8 @@ static struct vfio {
> > >  	struct cdev			group_cdev;
> > >  	dev_t				group_devt;
> > >  	wait_queue_head_t		release_q;
> > > +	struct list_head		vm_ops_list;
> > > +	struct mutex			vm_ops_lock;
> > >  } vfio;
> > >  
> > >  struct vfio_iommu_driver {
> > > @@ -2354,6 +2356,121 @@ struct iommu_domain *vfio_group_iommu_domain(struct vfio_group *group)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_group_iommu_domain);
> > >  
> > > +struct vfio_vma_ops {
> > > +	const struct vm_operations_struct	*vm_ops;
> > > +	vfio_register_vma_nb_t			*reg_fn;
> > > +	vfio_unregister_vma_nb_t		*unreg_fn;
> > > +	struct list_head			next;
> > > +};
> > > +
> > > +int vfio_register_vma_ops(const struct vm_operations_struct *vm_ops,
> > > +			  vfio_register_vma_nb_t *reg_fn,
> > > +			  vfio_unregister_vma_nb_t *unreg_fn)  
> > 
> > This just feels a little bit too complicated
> > 
> > I've recently learned from Daniel that we can use the address_space
> > machinery to drive the zap_vma_ptes() via unmap_mapping_range(). This
> > technique replaces all the open, close and vma_list logic in vfio_pci  
> 
> Here is my effort to make rdma use this, it removes a lot of ugly code:
> 
> https://github.com/jgunthorpe/linux/commits/rdma_addr_space
> 
> Still needs some more detailed testing.
> 
> This gives an option to detect vfio VMAs by checking
> 
>    if (vma->vm_file &&
>        file_inode(vma->vm_file) &&
>        file_inode(vma->vm_file)->i_sb->s_type == vfio_fs_type)
> 
> And all vfio VMA's can have some consistent vm_private_data, or at
> worst a consistent extended vm operations struct.

Looks pretty slick.  I won't claim it's fully gelled in my head yet,
but AIUI you're creating these inodes on your new pseudo fs and
associating it via the actual user fd via the f_mapping pointer, which
allows multiple fds to associate and address space back to this inode
when you want to call unmap_mapping_range().  That clarifies from the
previous email how we'd store the inode on the vfio_device without
introducing yet another tracking list for device fds.  I'll try to
piece together something similar for vfio, especially if we can avoid
that nasty lock switcheroo we copied from
uverbs_user_mmap_disassociate().  Thanks,

Alex

