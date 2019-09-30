Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF86AC24A6
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbfI3PtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfI3PtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:49:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95E7B307D96D;
        Mon, 30 Sep 2019 15:49:22 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5D2019C70;
        Mon, 30 Sep 2019 15:49:21 +0000 (UTC)
Date:   Mon, 30 Sep 2019 09:49:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: Re: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
Message-ID: <20190930094921.6be8d967@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0B560E@SHSMSX104.ccr.corp.intel.com>
References: <1567670923-4599-1-git-send-email-yi.l.liu@intel.com>
        <20190925203723.044d3bf0@x1.home>
        <A2975661238FB949B60364EF0F2C25743A0B560E@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 30 Sep 2019 15:49:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Sep 2019 12:41:03 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Thursday, September 26, 2019 10:37 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v2 13/13] vfio/type1: track iommu backed group attach
> > 
> > On Thu,  5 Sep 2019 16:08:43 +0800
> > Liu Yi L <yi.l.liu@intel.com> wrote:
> >   
> > > With the introduction of iommu aware mdev group, user may wrap a PF/VF
> > > as a mdev. Such mdevs will be called as wrapped PF/VF mdevs in following
> > > statements. If it's applied on a non-singleton iommu group, there would
> > > be multiple domain attach on an iommu_device group (equal to iommu backed
> > > group). Reason is that mdev group attaches is finally an iommu_device
> > > group attach in the end. And existing vfio_domain.gorup_list has no idea
> > > about it. Thus multiple attach would happen.
> > >
> > > What's more, under default domain policy, group attach is allowed only
> > > when its in-use domain is equal to its default domain as the code below:
> > >
> > > static int __iommu_attach_group(struct iommu_domain *domain, ..)
> > > {
> > > 	..
> > > 	if (group->default_domain && group->domain != group->default_domain)
> > > 		return -EBUSY;
> > > 	...
> > > }
> > >
> > > So for the above scenario, only the first group attach on the
> > > non-singleton iommu group will be successful. Subsequent group
> > > attaches will be failed. However, this is a fairly valid usage case
> > > if the wrapped PF/VF mdevs and other devices are assigned to a single
> > > VM. We may want to prevent it. In other words, the subsequent group
> > > attaches should return success before going to __iommu_attach_group().
> > >
> > > However, if user tries to assign the wrapped PF/VF mdevs and other
> > > devices to different VMs, the subsequent group attaches on a single
> > > iommu_device group should be failed. This means the subsequent group
> > > attach should finally calls into __iommu_attach_group() and be failed.
> > >
> > > To meet the above requirements, this patch introduces vfio_group_object
> > > structure to track the group attach of an iommu_device group (a.ka.
> > > iommu backed group). Each vfio_domain will have a group_obj_list to
> > > record the vfio_group_objects. The search of the group_obj_list should
> > > use iommu_device group if a group is mdev group.
> > >
> > > 	struct vfio_group_object {
> > > 		atomic_t		count;
> > > 		struct iommu_group	*iommu_group;
> > > 		struct vfio_domain	*domain;
> > > 		struct list_head	next;
> > > 	};
> > >
> > > Each time, a successful group attach should either have a new
> > > vfio_group_object created or count increasing of an existing
> > > vfio_group_object instance. Details can be found in
> > > vfio_domain_attach_group_object().
> > >
> > > For group detach, should have count decreasing. Please check
> > > vfio_domain_detach_group_object().
> > >
> > > As the vfio_domain.group_obj_list is within vfio container(vfio_iommu)
> > > scope, if user wants to passthru a non-singleton to multiple VMs, it
> > > will be failed as VMs will have separate vfio containers. Also, if
> > > vIOMMU is exposed, it will also fail the attempts of assigning multiple
> > > devices (via vfio-pci or PF/VF wrapped mdev) to a single VM. This is
> > > aligned with current vfio passthru rules.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 167  
> > ++++++++++++++++++++++++++++++++++++----  
> > >  1 file changed, 154 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index 317430d..6a67bd6 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -75,6 +75,7 @@ struct vfio_domain {
> > >  	struct iommu_domain	*domain;
> > >  	struct list_head	next;
> > >  	struct list_head	group_list;
> > > +	struct list_head	group_obj_list;
> > >  	int			prot;		/* IOMMU_CACHE */
> > >  	bool			fgsp;		/* Fine-grained super pages */
> > >  };
> > > @@ -97,6 +98,13 @@ struct vfio_group {
> > >  	bool			mdev_group;	/* An mdev group */
> > >  };
> > >
> > > +struct vfio_group_object {
> > > +	atomic_t		count;
> > > +	struct iommu_group	*iommu_group;
> > > +	struct vfio_domain	*domain;
> > > +	struct list_head	next;
> > > +};
> > > +  
> > 
> > So vfio_domain already has a group_list for all the groups attached to
> > that iommu domain.  We add a vfio_group_object list, which is also
> > effectively a list of groups attached to the domain, but we're tracking
> > something different with it.  All groups seem to get added as a
> > vfio_group_object, so why do we need both lists?  
> 
> yeah. It's functional workable. But looks ugly. The key purpose of this
> patch is to prevent duplicate domain attach for a single iommu group.
> Got another idea, see if it matches what we expect. Let me explain.
> 
> Existing group_list tracks iommu group attachment regardless of group
> type (mdev iommu group and iommu backed iommu group). For mdev
> iommu group, we actually have two sub-types. mdev iommu groups with
> iommu_device and groups w/o iommu_device. My idea here is to do a
> slight change against mdev iommu groups with iommu_device since it is
> the case we are handling. For such iommu groups, we can detect it and
> use its iommu_device group to do check in the domain->group_list. e.g.
> for such a group,
>      *) if found its iommu_device group has been attached, then return.
>      *) if failed to find a matched attach, we create a vfio_group and
>           finish the rest of the domain attach
> With this proposal, mdev iommu groups with iommu_device will not have
> vfio_group added in the domain->group_list. It will be tracked by its
> iommu_device group. For normal mdev iommu groups, it will still have its
> own vfio_group added in the domain->group_list.
> 
> To achieve it, we need to detect iommu_group type at the beginning of
> vfio_iommu_type1_attach_group (), which means to move the bus_type
> check to the beginning. I guess it may have simpler change. Thoughts?

Sounds better, but you'll have to give it a try to know for sure.  I'd
like to have a more cohesive approach, ideally reducing the complexity
even for singleton iommu-backed mdevs.
 
> > As I suspected when
> > we discussed this last, this adds complexity for something that's
> > currently being proposed as a sample driver.  
> 
> yeah, I was also hesitated to do it. However, if a user wants to wrap its
> PCI device as a mdev, it will more or less face the usage on non-singleton
> groups. If the new proposal is not that complex, I guess we can try to
> make it happen.

I suspect that iommu-backed mdevs that we actually want to support are
likely going to be in singleton iommu groups and the type1 code has
become overly complicated with mdev support already.  I'm therefore
certainly more open to approaches that try to unify group handling.

[snip]
> > > @@ -1469,6 +1576,39 @@ static int vfio_iommu_type1_attach_group(void  
> > *iommu_data,  
> > >  		bus = iommu_device->bus;
> > >  	}
> > >
> > > +	/*
> > > +	 * Check if iommu backed group attached to a domain within current
> > > +	 * container. If yes, increase the count; If no, go ahead with a
> > > +	 * new domain attach process.
> > > +	 */
> > > +	group_obj = NULL;  
> > 
> > How could it be otherwise?  
> 
> Oops, this comment should be better described. My point is if group_obj
> is not found, then this vfio_iommu_type1_attach_group() call should go
> with normal domain attach. And this means the codes behind below comment
> should be finished before return.

I think my review comment wasn't specifically a misunderstanding of the
code comment phrasing, but the fact that group_obj cannot be other than
NULL already to reach this point in the code.  IOW, I'm noting that
setting it to NULL here is redundant.  Thanks,

Alex
