Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D87E32DE5D
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 01:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhCEAgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 19:36:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15873 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhCEAgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 19:36:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60417d1d0003>; Thu, 04 Mar 2021 16:36:45 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 00:36:45 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 5 Mar 2021 00:36:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGmyDLMTCmyLM7RnVutLJizWiA3Qz6McpKN+g9Ja1FPiUSK5fTKTTvFcVeB57oMUes7fJIFT6wtCbrJLViYnQG9mCDTc7gdvOwPZGNZOk91L3JsCprwYLrRDGx7Y+MU47VhvO4KWYtWXGNkctikVY1HmDmNCZaCX5/PkCKbAjtOFIj+DP2JxMq/t+YQYXIxAcS6ASjKH83jMDcPPNzgfoLqJqIJwRT1GPaVh+p+QwS5PRPL2MfkynupB2KHZVSNybL/Abxs0OzleDm8sqlQQ9XIYGTW7UsIpOSuGQcXVCfWZe9wgbJ96IvzJL44PUzJvHoXnUZNPxKG2XOOfkqvp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vyh9LWTDJIo2GFCbfvqALL248gDhDJRdUGVTiIZxeHw=;
 b=BevzVPaA1KMthBvjGmlDGePxkTObzvsiFBlV89xd2lmmy71luOJaIGRB5VX3vVD8RBRnENGuYM7EcqzWGN/ypqAmV3fkXhvUM7XxFkTjg8PU0jGWf6SrCaWnvHTG85hE8WIuvmgdbmRC9t0YMad7Ziyh4ezKfgId0MxlFhZ8xk8AceKay0I/q+st9GKsLg+QwRmeMR1oE9ronk5t3lmhwEXWevoddfH6WmaitOSYG+zmpMfIWYAs1DYadFvylXj20EvcAqbwExaVQF/ED8yrHy9yBN9p+Zzho3vqvA1Qop71UZFSLLTleHDIiePqxLUZrvUiKkulEyH6ahjXiReCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4266.namprd12.prod.outlook.com (2603:10b6:5:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Fri, 5 Mar
 2021 00:36:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Fri, 5 Mar 2021
 00:36:43 +0000
Date:   Thu, 4 Mar 2021 20:36:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210305003642.GR4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401268537.16443.2329805617992345365.stgit@gimli.home>
 <20210222172913.GP4247@nvidia.com>
 <20210224145506.48f6e0b4@omen.home.shazbot.org>
 <20210225000610.GP4247@nvidia.com>
 <20210225152113.3e083b4a@omen.home.shazbot.org>
 <20210225234949.GV4247@nvidia.com>
 <20210304143757.1ca42cfc@omen.home.shazbot.org>
 <20210304231633.GP4247@nvidia.com>
 <20210304170731.72039a23@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210304170731.72039a23@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:208:134::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:208:134::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 00:36:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lHySQ-007ZPP-A2; Thu, 04 Mar 2021 20:36:42 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614904605; bh=Vyh9LWTDJIo2GFCbfvqALL248gDhDJRdUGVTiIZxeHw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=CiJ64o7VuJgoYZdSz1m4Z3eSG1tDZrlhFP2vzTg8mvYGzyoqbEwk6HjS2AwuXsa+l
         FLHnxAs3vlzW76edJX/P8HByyDr5bUmmxbyw6Ws0uuvy1qTBDzWz8vKrMunCIMPRQr
         TdcXDYwJ3ZUrNJz0BB7YzqdRt39Pmnh6tpWKbaDepTkC5/wtJYsi3dc/6j3ELvKOkW
         6pNk6trSgbgVdJoV7pFRQlawfQUYuTf9MW50M0cwIzzeA38+NQFbEElxKEmTAYz7/f
         nK37j86aWjHO97XxzAqe4Jl7FrDvyQGSathpvkk7PrfnRPynTiKrW2ebINWaGUzFpg
         d9e64b6JTdzlQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 05:07:31PM -0700, Alex Williamson wrote:
> On Thu, 4 Mar 2021 19:16:33 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Mar 04, 2021 at 02:37:57PM -0700, Alex Williamson wrote:
> > 
> > > Therefore unless a bus driver opts-out by replacing vm_private_data, we
> > > can identify participating vmas by the vm_ops and have flags indicating
> > > if the vma maps device memory such that vfio_get_device_from_vma()
> > > should produce a device reference.  The vfio IOMMU backends would also
> > > consume this, ie. if they get a valid vfio_device from the vma, use the
> > > pfn_base field directly.  vfio_vm_ops would wrap the bus driver
> > > callbacks and provide reference counting on open/close to release this
> > > object.  
> > 
> > > I'm not thrilled with a vfio_device_ops callback plumbed through
> > > vfio-core to do vma-to-pfn translation, so I thought this might be a
> > > better alternative.  Thanks,  
> > 
> > Maybe you could explain why, because I'm looking at this idea and
> > thinking it looks very complicated compared to a simple driver op
> > callback?
> 
> vfio-core needs to export a vfio_vma_to_pfn() which I think assumes the
> caller has already used vfio_device_get_from_vma(), but should still
> validate the vma is one from a vfio device before calling this new
> vfio_device_ops callback.

Huh? Validate? Why?

Something like this in the IOMMU stuff:

   struct vfio_device *vfio = vfio_device_get_from_vma(vma)

   if (!vfio->vma_to_pfn)
        return -EINVAL;
   vfio->ops->vma_to_pfn(vfio, vma, offset_from_vma_start)

Is fine, why do we need to over complicate?

I don't need to check that the vma belongs to the vfio because it is
the API contract that the caller will guarantee that.

This is the kernel, I can (and do!) check these sorts of things by
code inspection when working on stuff - I can look at every
implementation and every call site to prove these things.

IMHO doing an expensive check like that is a style of defensive
programming the kernel community frowns upon.

> vfio-pci needs to validate the vm_pgoff value falls within a BAR
> region, mask off the index and get the pci_resource_start() for the
> BAR index.

It needs to do the same thing fault() already does, which is currently
one line..

> Then we need a solution for how vfio_device_get_from_vma() determines
> whether to grant a device reference for a given vma, where that vma may
> map something other than device memory. Are you imagining that we hand
> out device references independently and vfio_vma_to_pfn() would return
> an errno for vm_pgoff values that don't map device memory and the IOMMU
> driver would release the reference?

That seems a reasonable place to start

> prevent using unmmap_mapping_range().  The IOMMU backend, once it has a
> vfio_device via vfio_device_get_from_vma() can know the format of
> vm_private_data, cast it as a vfio_vma_private_data and directly use
> base_pfn, accomplishing the big point.  They're all operating in the
> agreed upon vm_private_data format.  Thanks,

If we force all drivers into a mandatory (!) vm_private_data format
then every driver has to be audited and updated before the new pfn
code can be done. If any driver in the future makes a mistake here
(and omitting the unique vm_private_data magics is a very easy mistake
to make) then it will cause a kernel crash in an obscure scenario.

It is the "design the API to be hard to use wrong" philosophy.

Jason
