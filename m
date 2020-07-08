Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB2C21910B
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgGHTz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:55:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36779 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgGHTz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 15:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594238126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4zYLdQwkBISSt97sZJVBWHYyMqX21StTgcEywwSVHM=;
        b=fi54/RK7YG4KV8Z+hF1d78z964SS9VdGhAlcgi+87U/h94QvF5Kj+NwJifHmmnREADTLTq
        AOgcC5Rm2KEhVG3dDnb0rj3jgamPQFqkF50hD+R4qzZ8PhvHaMYHYZ277XJrQepDvfqM4W
        Qe9zs66+Vg95zBkI68CIN8dgSI5hJTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-7z3WF3iqMRmKuVNARq36Gw-1; Wed, 08 Jul 2020 15:55:22 -0400
X-MC-Unique: 7z3WF3iqMRmKuVNARq36Gw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E18580BCC7;
        Wed,  8 Jul 2020 19:55:17 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5D246FEC4;
        Wed,  8 Jul 2020 19:54:44 +0000 (UTC)
Date:   Wed, 8 Jul 2020 13:54:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
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
Message-ID: <20200708135444.4eac48a4@x1.home>
In-Reply-To: <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jul 2020 08:16:16 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Liu, Yi L < yi.l.liu@intel.com>
> > Sent: Friday, July 3, 2020 2:28 PM
> > 
> > Hi Alex,
> >   
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, July 3, 2020 5:19 AM
> > >
> > > On Wed, 24 Jun 2020 01:55:19 -0700
> > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > >  
> > > > This patch allows user space to request PASID allocation/free, e.g.
> > > > when serving the request from the guest.
> > > >
> > > > PASIDs that are not freed by userspace are automatically freed when
> > > > the IOASID set is destroyed when process exits.  
> [...]
> > > > +static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
> > > > +					  unsigned long arg)
> > > > +{
> > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > +	unsigned long minsz;
> > > > +
> > > > +	minsz = offsetofend(struct vfio_iommu_type1_pasid_request, range);
> > > > +
> > > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > +		return -EFAULT;
> > > > +
> > > > +	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (req.range.min > req.range.max)  
> > >
> > > Is it exploitable that a user can spin the kernel for a long time in
> > > the case of a free by calling this with [0, MAX_UINT] regardless of their actual  
> > allocations?
> > 
> > IOASID can ensure that user can only free the PASIDs allocated to the user. but
> > it's true, kernel needs to loop all the PASIDs within the range provided by user. it
> > may take a long time. is there anything we can do? one thing may limit the range
> > provided by user?  
> 
> thought about it more, we have per-VM pasid quota (say 1000), so even if
> user passed down [0, MAX_UNIT], kernel will only loop the 1000 pasids at
> most. do you think we still need to do something on it?

How do you figure that?  vfio_iommu_type1_pasid_request() accepts the
user's min/max so long as (max > min) and passes that to
vfio_iommu_type1_pasid_free(), then to vfio_pasid_free_range()  which
loops as:

	ioasid_t pasid = min;
	for (; pasid <= max; pasid++)
		ioasid_free(pasid);

A user might only be able to allocate 1000 pasids, but apparently they
can ask to free all they want.

It's also not obvious to me that calling ioasid_free() is only allowing
the user to free their own passid.  Does it?  It would be a pretty
gaping hole if a user could free arbitrary pasids.  A r-b tree of
passids might help both for security and to bound spinning in a loop.
Thanks,

Alex

