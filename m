Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F8C324815
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhBYA7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 19:59:09 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15304 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbhBYA6R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 19:58:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6036f6000000>; Wed, 24 Feb 2021 16:57:36 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 00:57:36 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 00:57:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBzq0j4Qjbvx5fiVUzYmEoQPURPA1xptygD6SDFZOFXXdRbdq4zq+gRVELCq71MzwvhIyoo+1iRSURWERuvNM/CD10kBDsz7238yv7tsZ12oTaWZWqVCDKLfdmmYCH8+t0P74cm8v42EGgqNXd8TplGAcPwkap8zyLYN9OcHAVjWjuH4bHNHDY8GftjYvMJ7jfodGXHH9T9L07zFpT4DkT/AU2XyS2LbsJPGXlouSf2XoEm55qeuDauxV9Ge7ss5IUcomytzy81uNSvs2vEazkjUJ+CW3dYBY82CUYEpb39dYMrNrJqEDILzdEJR3sWeT5xXD5X/A4rWVRkijbMKLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdWgnAGjw7dJyHL4hlNRYI7E4OCVFSZEfpeNwMphoAM=;
 b=GqEuJOfsRMAQThp9x+ZzV21acH/5o2vtanAAVTmgzbv/A4Qy4PABkd0x+9dz7hyE1F16u74cpoUdrv4jNXxZcdUu2OGg15ZC4YIEbnBiz0XZD/SsesOXlBwQzuY+wgLPB6OwmKplQw/A6vPf5MVm+pn1Ju7DHRweL+gPWdVv/ktblcpT+7gy4wcz43twSXz8sGgL2emXca99AtbUqNTqContsT6PMQvUok6fr6CYJF5lxaWl64EdAPu7bax6vi7g7uM0JzjzvQxv0uiAHcqToReNUfAZ8fHTH9m90ug+HyX6Gs6Y2EWfCondF9rEBjBYSAPUHLmap1PGWTvKEfprlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2438.namprd12.prod.outlook.com (2603:10b6:4:b5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Thu, 25 Feb
 2021 00:57:35 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 00:57:34 +0000
Date:   Wed, 24 Feb 2021 20:57:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 04/10] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210225005732.GR4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401267316.16443.11184767955094847849.stgit@gimli.home>
 <20210222172230.GO4247@nvidia.com>
 <20210224145505.61a4fbc1@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210224145505.61a4fbc1@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:208:237::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0044.namprd15.prod.outlook.com (2603:10b6:208:237::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 00:57:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lF4yC-00Gtmh-WB; Wed, 24 Feb 2021 20:57:33 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614214656; bh=bdWgnAGjw7dJyHL4hlNRYI7E4OCVFSZEfpeNwMphoAM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=g+CdlpCG6km4KuGjf8MJQzjjCU8K3MyOr3tp9+SFwP7JSl6YBL3ToB6BmQ0k1ltCL
         eJrYHip6UbtOnUHDWZXmlpnEKxLl11o1GHBNNtf1rojXW6DlTnZuIhQhNHon76QmgC
         2rbmK8fv9MhZcJlFOPZv62bIN180wYEsv8+T2adyEzngm5gr4oFTIdeKyUisbXCGv8
         fxRMjA7fcBlI19in3GrqBZCmvAcLH7jpkjVTsTfnnx0GZYrUKmnTNYg++YyeJgybaK
         xWqpx5aCpaQ1sEGk/IMCDD9UpbmpoTX4nVFgASUW+Xbab6pMqkpuPJrlbDOUJKogCg
         6Jt1sEfOsRDuA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 02:55:05PM -0700, Alex Williamson wrote:

> Ok, but how does this really help us, unless you're also proposing some
> redesign of the memory_lock semaphore?  Even if we're zapping all the
> affected devices for a bus reset that doesn't eliminate that we still
> require device level granularity for other events.

Ok, I missed the device level one, forget this remark about the reflk
then, per vfio_pci_device is the right granularity

> > >  struct vfio_pci_device {
> > >  	struct pci_dev		*pdev;
> > > +	struct vfio_device	*device;  
> > 
> > Ah, I did this too, but I didn't use a pointer :)
> 
> vfio_device is embedded in vfio.c, so that worries me.

I'm working on what we talked about in the other thread to show how
VFIO looks if it follows the normal Linux container_of idiom and to
then remove the vfio_mdev.c indirection as an illustration.

I want to directly make the case the VFIO is better off following the
standard kernel designs and driver core norms so we can find an
agreement to get Max's work on vfio_pci going forward.

You were concerned about hand waving, and maintainability so I'm
willing to put in some more work to make it concrete.

I hope you'll keep an open mind

> > All the places trying to call vfio_device_put() when they really want
> > a vfio_pci_device * become simpler now. Eg struct vfio_devices wants
> > to have an array of vfio_pci_device, and get_pf_vdev() only needs to
> > return one pointer.
> 
> Sure, that example would be a good simplification.  I'm not sure see
> other cases where we're going out of our way to manage the vfio_device
> versus vfio_pci_device objects though.

What I've found is there are lots of little costs all over the
place. The above was just easy to describe in this context.

In my mind the biggest negative cost is the type erasure. Lots of
places are using 'device *', 'void *', 'kobj *' as generic handles to
things that are actually already concretely typed. In the kernel I
would say concretely typing things is considered a virtue.

Having gone through alot of VFIO now, as it relates to the
vfio_device, I think the type erasure directly hurts readability and
maintainability. It just takes too much information away from the
reader and the compiler. The core code is managable, but when you
chuck mdev into it that follows the same, it really starts hurting.

Jason
