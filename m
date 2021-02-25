Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B43247BF
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 01:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhBYAG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 19:06:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10940 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhBYAG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 19:06:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6036e9f90001>; Wed, 24 Feb 2021 16:06:17 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 00:06:16 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 00:06:14 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 00:06:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmwfna/Ck5qmBzweSQRJhLwa3YoCsoRU0FNIAXz9W/AZv6S4koZSuoDVP+81kc5TJ08BZbfs7lNELmUjSCdvSURLXEb6KkiMvx3JJG1g0mkuqoD5+LryxzSp26M+AQbRvYsEPRE+Eiu3+13C3uSfPhnVELoIeNrvWLfGH4TZLVs78MKMuyJ4VEH4UElQYCZO9ItsrHfI+4QXDFKtzw0/6yFtqndtXq5kVRij5g2eb689xeQFCPU3PeKwvhlxxQ48ayOjp+icObAUPspN5XvZNcFILAT5BhiQO26gRqKc0NTtRtW0cRuCj1gRnE21I1MZBE+d4+IWiD4Ysp5DIiEqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHi6xI/xLXftsyt2CiE8rvkm+LSwdKu5yXdlp/xNo5A=;
 b=W60aCsMx8bQAvvhQxfb/qomT1QaXZ7QHNIN7VtfTQqBAB7Xnrntgw5hBEPA2XIndLfgfd04WfJraKQ3YnPbhH25Bvw/4qCKRIxm5fEBk8RFFSajZ1a/Q2L++h7vCLTPrL5Br1iOAjSu9uaZr+CW8AbvZ+fpwlnnopxfqs2T2xP/1hD0M4yDyqLzzlp44Gcjtskj1bw5+z4mPXY8UM722o8YdbWqkzr66FqboTcrrzhQxQdCEEMkOU2iyWl8qo2LIV+1Vo9eRW+GVhXNzhslwVldpV18xDWVz0i9q4fIZAkGSPsQU8rFNOsW689RQoF3n5i6nCxpEmRu54zr6EHNcTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1884.namprd12.prod.outlook.com (2603:10b6:3:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 25 Feb
 2021 00:06:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 00:06:12 +0000
Date:   Wed, 24 Feb 2021 20:06:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210225000610.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401268537.16443.2329805617992345365.stgit@gimli.home>
 <20210222172913.GP4247@nvidia.com>
 <20210224145506.48f6e0b4@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210224145506.48f6e0b4@omen.home.shazbot.org>
X-ClientProxiedBy: BL0PR02CA0091.namprd02.prod.outlook.com
 (2603:10b6:208:51::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0091.namprd02.prod.outlook.com (2603:10b6:208:51::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 00:06:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lF4AU-00Gt60-IT; Wed, 24 Feb 2021 20:06:10 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614211577; bh=dHi6xI/xLXftsyt2CiE8rvkm+LSwdKu5yXdlp/xNo5A=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=hLLAQM1f1kBdK4SFIjwhnVv8lvzzi1vvf6kPRfIZ6E0Xdoa55SZAEs3TKndNOdp+s
         +/xszgxYVaYtVtUuC9rTQiy5pinva8qvytrqygSH3ltyQCjkWx5vXSTPAuhwPfYEUG
         2JYjhzARLCNghBGSyUcE9QlgR9fx2LbGnxviGIyMnizda0uhXEHy8hcZhh44kyPY9U
         3m9P3Dh+0c38De/VazxgynCe5YyeWppthN48mrd9zn878PFI3B3SAQRzR3UoBv0Er4
         a+qSvR243o3U9I62MARZzxQAPprUFM+uBJ+DAADSAgwFgCFJMyon33wjBRFatq1i/N
         JCGgWtX6CiGHA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 02:55:06PM -0700, Alex Williamson wrote:

> > The only use of the special ops would be if there are multiple types
> > of mmap's going on, but for this narrow use case those would be safely
> > distinguished by the vm_pgoff instead
> 
> We potentially do have device specific regions which can support mmap,
> for example the migration region.  We'll need to think about how we
> could even know if portions of those regions map to a device.  We could
> use the notifier to announce it and require the code supporting those
> device specific regions manage it.

So, the above basically says any VFIO VMA is allowed for VFIO to map
to the IOMMU.

If there are places creating mmaps for VFIO that should not go to the
IOMMU then they need to return NULL from this function.

> I'm not really clear what you're getting at with vm_pgoff though, could
> you explain further?

Ah, so I have to take a side discussion to explain what I ment.

The vm_pgoff is a bit confused because we change it here in vfio_pci:

    vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;

But the address_space invalidation assumes it still has the region
based encoding:

+	vfio_device_unmap_mapping_range(vdev->device,
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
+			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));

Those three indexes are in the vm_pgoff numberspace and so vm_pgoff
must always be set to the same thing - either the
VFIO_PCI_INDEX_TO_OFFSET() coding or the physical pfn. 

Since you say we need a limited invalidation this looks like a bug to
me - and it must always be the VFIO_PCI_INDEX_TO_OFFSET coding.

So, the PCI vma needs to get switched to use the
VFIO_PCI_INDEX_TO_OFFSET coding and then we can always extract the
region number from the vm_pgoff and thus access any additional data,
such as the base pfn or a flag saying this cannot be mapped to the
IOMMU. Do the reverse of VFIO_PCI_INDEX_TO_OFFSET and consult
information attached to that region ID.

All places creating vfio mmaps have to set the vm_pgoff to
VFIO_PCI_INDEX_TO_OFFSET().

But we have these violations that need fixing:

drivers/vfio/fsl-mc/vfio_fsl_mc.c:      vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
drivers/vfio/platform/vfio_platform_common.c:   vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;

Couldn't see any purpose to this code, cargo cult copy? Just delete
it.

drivers/vfio/pci/vfio_pci.c:    vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;

Used to implement fault() but we could get the region number and
extract the pfn from the vfio_pci_device's data easy enough.

I manually checked that other parts of VFIO not under drivers/vfio are
doing it OK, looks fine.

Jason
