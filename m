Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBDA21A217
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGIO2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:28:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726475AbgGIO2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 10:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594304885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DpsUJFICgB7EMC3lYRDessWHLvK4ZYdQtzGGZMiS0cU=;
        b=JfroPV9SSXD0PnGZUN7iiafFZkmbTYsBJSR1rHlKHe1NVt/Hm785Gdi5XqDg7bof+AG9EP
        hdg+Z1JvPhcQ7q+8z9pPd8ID2Jp//2QaYy+ZDBpjXcbIiueps30cMdjRhGz/FD2JWOpiHU
        mFI221lOHhj+XF5ORZ5H5EfVGv9EjXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-M9NElO_dNJyWb5HRvbO6zA-1; Thu, 09 Jul 2020 10:28:01 -0400
X-MC-Unique: M9NElO_dNJyWb5HRvbO6zA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AB541932481;
        Thu,  9 Jul 2020 14:27:59 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 288235D9C9;
        Thu,  9 Jul 2020 14:27:52 +0000 (UTC)
Date:   Thu, 9 Jul 2020 08:27:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Message-ID: <20200709082751.320742ab@x1.home>
In-Reply-To: <DM5PR11MB143584D5A0AAE13E0D2D04B7C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
        <20200708135444.4eac48a4@x1.home>
        <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
        <DM5PR11MB14357DC99EFCDE7E02944E2EC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <MWHPR11MB1645F822D9267005AE5BCE528C640@MWHPR11MB1645.namprd11.prod.outlook.com>
        <DM5PR11MB143577F0C21EDB82B82EEB35C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <DM5PR11MB143584D5A0AAE13E0D2D04B7C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jul 2020 07:16:31 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> After more thinking, looks like adding a r-b tree is still not enough to
> solve the potential problem for free a range of PASID in one ioctl. If
> caller gives [0, MAX_UNIT] in the free request, kernel anyhow should
> loop all the PASIDs and search in the r-b tree. Even VFIO can track the
> smallest/largest allocated PASID, and limit the free range to an accurate
> range, it is still no efficient. For example, user has allocated two PASIDs
> ( 1 and 999), and user gives the [0, MAX_UNIT] range in free request. VFIO
> will limit the free range to be [1, 999], but still needs to loop PASID 1 -
> 999, and search in r-b tree.

That sounds like a poor tree implementation.  Look at vfio_find_dma()
for instance, it returns a node within the specified range.  If the
tree has two nodes within the specified range we should never need to
call a search function like vfio_find_dma() more than three times.  We
call it once, get the first node, remove it.  Call it again, get the
other node, remove it.  Call a third time, find no matches, we're done.
So such an implementation limits searches to N+1 where N is the number
of nodes within the range.

> So I'm wondering can we fall back to prior proposal which only free one
> PASID for a free request. how about your opinion?

Doesn't it still seem like it would be a useful user interface to have
a mechanism to free all pasids, by calling with exactly [0, MAX_UINT]?
I'm not sure if there's another use case for this given than the user
doesn't have strict control of the pasid values they get.  Thanks,

Alex

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, July 9, 2020 10:26 AM
> > 
> > Hi Kevin,
> >   
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Thursday, July 9, 2020 10:18 AM
> > >  
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Thursday, July 9, 2020 10:08 AM
> > > >
> > > > Hi Kevin,
> > > >  
> > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > Sent: Thursday, July 9, 2020 9:57 AM
> > > > >  
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Thursday, July 9, 2020 8:32 AM
> > > > > >
> > > > > > Hi Alex,
> > > > > >  
> > > > > > > Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Sent: Thursday, July 9, 2020 3:55 AM
> > > > > > >
> > > > > > > On Wed, 8 Jul 2020 08:16:16 +0000 "Liu, Yi L"
> > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > >  
> > > > > > > > Hi Alex,
> > > > > > > >  
> > > > > > > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > > > > > > Sent: Friday, July 3, 2020 2:28 PM
> > > > > > > > >
> > > > > > > > > Hi Alex,
> > > > > > > > >  
> > > > > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > > > > > > >
> > > > > > > > > > On Wed, 24 Jun 2020 01:55:19 -0700 Liu Yi L
> > > > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > > > >  
> > > > > > > > > > > This patch allows user space to request PASID
> > > > > > > > > > > allocation/free,  
> > > > e.g.  
> > > > > > > > > > > when serving the request from the guest.
> > > > > > > > > > >
> > > > > > > > > > > PASIDs that are not freed by userspace are
> > > > > > > > > > > automatically freed  
> > > > > > when  
> > > > > > > > > > > the IOASID set is destroyed when process exits.  
> > > > > > > > [...]  
> > > > > > > > > > > +static int vfio_iommu_type1_pasid_request(struct
> > > > > > > > > > > +vfio_iommu  
> > > > > > *iommu,  
> > > > > > > > > > > +					  unsigned long arg) {
> > > > > > > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > > > > > > +	unsigned long minsz;
> > > > > > > > > > > +
> > > > > > > > > > > +	minsz = offsetofend(struct  
> > > vfio_iommu_type1_pasid_request,  
> > > > > > > range);  
> > > > > > > > > > > +
> > > > > > > > > > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > > > > > > > > +		return -EFAULT;
> > > > > > > > > > > +
> > > > > > > > > > > +	if (req.argsz < minsz || (req.flags &  
> > > > > > > ~VFIO_PASID_REQUEST_MASK))  
> > > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > > +
> > > > > > > > > > > +	if (req.range.min > req.range.max)  
> > > > > > > > > >
> > > > > > > > > > Is it exploitable that a user can spin the kernel for a
> > > > > > > > > > long time in the case of a free by calling this with [0,
> > > > > > > > > > MAX_UINT] regardless of their  
> > > > > > > actual  
> > > > > > > > > allocations?
> > > > > > > > >
> > > > > > > > > IOASID can ensure that user can only free the PASIDs
> > > > > > > > > allocated to the  
> > > > > > user.  
> > > > > > > but  
> > > > > > > > > it's true, kernel needs to loop all the PASIDs within the
> > > > > > > > > range provided by user.  
> > > > > > > it  
> > > > > > > > > may take a long time. is there anything we can do? one
> > > > > > > > > thing may limit  
> > > > > > the  
> > > > > > > range  
> > > > > > > > > provided by user?  
> > > > > > > >
> > > > > > > > thought about it more, we have per-VM pasid quota (say
> > > > > > > > 1000), so even if user passed down [0, MAX_UNIT], kernel
> > > > > > > > will only loop the
> > > > > > > > 1000 pasids at most. do you think we still need to do something on it?  
> > > > > > >
> > > > > > > How do you figure that?  vfio_iommu_type1_pasid_request()
> > > > > > > accepts the user's min/max so long as (max > min) and passes
> > > > > > > that to vfio_iommu_type1_pasid_free(), then to
> > > > > > > vfio_pasid_free_range() which loops as:
> > > > > > >
> > > > > > > 	ioasid_t pasid = min;
> > > > > > > 	for (; pasid <= max; pasid++)
> > > > > > > 		ioasid_free(pasid);
> > > > > > >
> > > > > > > A user might only be able to allocate 1000 pasids, but
> > > > > > > apparently they can ask to free all they want.
> > > > > > >
> > > > > > > It's also not obvious to me that calling ioasid_free() is only
> > > > > > > allowing the user to free their own passid.  Does it?  It
> > > > > > > would be a pretty  
> > > > >
> > > > > Agree. I thought ioasid_free should at least carry a token since
> > > > > the user  
> > > > space is  
> > > > > only allowed to manage PASIDs in its own set...
> > > > >  
> > > > > > > gaping hole if a user could free arbitrary pasids.  A r-b tree
> > > > > > > of passids might help both for security and to bound spinning in a loop.  
> > > > > >
> > > > > > oh, yes. BTW. instead of r-b tree in VFIO, maybe we can add an
> > > > > > ioasid_set parameter for ioasid_free(), thus to prevent the user
> > > > > > from freeing PASIDs that doesn't belong to it. I remember Jacob
> > > > > > mentioned it  
> > > > before.  
> > > > > >  
> > > > >
> > > > > check current ioasid_free:
> > > > >
> > > > >         spin_lock(&ioasid_allocator_lock);
> > > > >         ioasid_data = xa_load(&active_allocator->xa, ioasid);
> > > > >         if (!ioasid_data) {
> > > > >                 pr_err("Trying to free unknown IOASID %u\n", ioasid);
> > > > >                 goto exit_unlock;
> > > > >         }
> > > > >
> > > > > Allow an user to trigger above lock paths with MAX_UINT times
> > > > > might still  
> > > > be bad.
> > > >
> > > > yeah, how about the below two options:
> > > >
> > > > - comparing the max - min with the quota before calling ioasid_free().
> > > >   If max - min > current quota of the user, then should fail it. If
> > > >   max - min < quota, then call ioasid_free() one by one. still trigger
> > > >   the above lock path with quota times.  
> > >
> > > This is definitely wrong. [min, max] is about the range of the PASID
> > > value, while quota is about the number of allocated PASIDs. It's a bit
> > > weird to mix two together.  
> > 
> > got it.
> >   
> > > btw what is the main purpose of allowing batch PASID free requests?
> > > Can we just simplify to allow one PASID in each free just like how is
> > > it done in allocation path?  
> > 
> > it's an intention to reuse the [min, max] range as allocation path. currently, we
> > don't have such request as far as I can see.
> >   
> > > >
> > > > - pass the max and min to ioasid_free(), let ioasid_free() decide. should
> > > >   be able to avoid trigger the lock multiple times, and ioasid has have a
> > > >   track on how may PASIDs have been allocated, if max - min is larger than
> > > >   the allocated number, should fail anyway.  
> > >
> > > What about Alex's r-b tree suggestion? Is there any downside in you mind?  
> > 
> > no downside, I was just wanting to reuse the tracks in ioasid_set. I can add a r-b
> > for allocated PASIDs and find the PASIDs in the r-b tree only do free for the
> > PASIDs found in r-b tree, others in the range would be ignored.
> > does it look good?
> > 
> > Regards,
> > Yi Liu
> >   
> > > Thanks,
> > > Kevin  
> 

