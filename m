Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1807A325A6E
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 00:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhBYXuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 18:50:40 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13901 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhBYXui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 18:50:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603837a50001>; Thu, 25 Feb 2021 15:49:57 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 23:49:56 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 23:49:54 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 23:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCgMq8J/FQwKLbihVCjySQEMkyHtYEnY3R+MK1GTm/OflTwzS9a43VSYwAoHHo9KOY38qpbEF15uPNegILWpz7HoqrjQkGoGe2zkaaxFPpkPVvDkkytyUHaJafHFXHZf3mNnJkMGZXIoypRlQwrXKCdDPESiPR9FteGvu0Zgai8hI7zAUBkm5w1KDt0BOR00mRNNfbeE7RgharwFpI5E3i7yqDRf8+8u/PVc2/dhi8vEFPpgM/GL1cq3uH7ejp/CngbDkIIEa5qMZaRCDc+zSkPZ4cjpS/quPBp3wKw4uV4pqUT1NEvGqIA6hWrwJwGPb92CllHOytxW6+LNR3VasQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0AM1I0CLj5S5RDDUgpqwBFRRdfe3YD1iMSOiQGh5ZU=;
 b=lcC1seQl46rx82kgcb241nYfmJ+Uasd6lm25srAAeBZVi3oHzHWxeN1JgN687NtknjLufeeb8muZQxnZ3iaSS5d0tQXciBxf7kdjsszlhix0ahucfkk3o6m+B2tg5o5dlyr92pxpc84jq/3qeJoLoZAsSxH2uN0GOQ75vdwlt0aJ9kriCPYJQ4IPUtZdYWY9Jw7wsZpBC+61ltcKGwcpZ5c8stSe16IUhGb7QP+Z053oyFssi+SkY7xGUULnN+Ky4y5AtU8vStOXoGF3T5XYiFIqFEuMDtUhOqoxxONMO2pRzi1h7ievtweh6mwzu+akSd2F+4i1T+HeQ18XXMu8gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1833.namprd12.prod.outlook.com (2603:10b6:3:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 25 Feb
 2021 23:49:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 23:49:52 +0000
Date:   Thu, 25 Feb 2021 19:49:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210225234949.GV4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401268537.16443.2329805617992345365.stgit@gimli.home>
 <20210222172913.GP4247@nvidia.com>
 <20210224145506.48f6e0b4@omen.home.shazbot.org>
 <20210225000610.GP4247@nvidia.com>
 <20210225152113.3e083b4a@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210225152113.3e083b4a@omen.home.shazbot.org>
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0004.namprd05.prod.outlook.com (2603:10b6:208:91::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Thu, 25 Feb 2021 23:49:51 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lFQOD-000OU3-QJ; Thu, 25 Feb 2021 19:49:49 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614296997; bh=d0AM1I0CLj5S5RDDUgpqwBFRRdfe3YD1iMSOiQGh5ZU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=c059HxktSNMH3JkZJHNqNqjU8zFFQUivn6hdOASbofTF3SQqQD5rb1xECRwzWQcrr
         pvSUIJSeKHsb6WusvUDQk42xhCAHMtgXuGWKbb85L0Li2gD+w4MiXL3Z+GU58TnIi7
         0vIa99+yr4hciyAYFjF1RATSh8EKsO4ufu1c/1pNhRLSMYuo4t4x42604q+llGM9bP
         hH1bMg4A/CrtYBIO1y/dMk3WeGl0PqZmqlaA93Y3wpPatILeTcUeJLDQLARkJ3kKzm
         n46LWYPT/ClipyOBMcGs88OeQ/4Ht+E0hWZFys8EHjyEiiuz17rO8f34/dpo+HE1CA
         fKuFsJcD3Uh4g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 03:21:13PM -0700, Alex Williamson wrote:

> This is where it gets tricky.  The vm_pgoff we get from
> file_operations.mmap is already essentially describing an offset from
> the base of a specific resource.  We could convert that from an absolute
> offset to a pfn offset, but it's only the bus driver code (ex.
> vfio-pci) that knows how to get the base, assuming there is a single
> base per region (we can't assume enough bits per region to store
> absolute pfn).  Also note that you're suggesting that all vfio mmaps
> would need to standardize on the vfio-pci implementation of region
> layouts.  Not that most drivers haven't copied vfio-pci, but we've
> specifically avoided exposing it as a fixed uAPI such that we could have
> the flexibility for a bus driver to implement regions offsets however
> they need.

Okay, well the bus driver owns the address space and the bus driver is
in control of the vm_pgoff. If it doesn't want to zap then it doesn't
need to do anything

vfio-pci can consistently use the index encoding and be fine
 
> So I'm not really sure what this looks like.  Within vfio-pci we could
> keep the index bits in place to allow unmmap_mapping_range() to
> selectively zap matching vm_pgoffs but expanding that to a vfio
> standard such that the IOMMU backend can also extract a pfn looks very
> limiting, or ugly.  Thanks,

Lets add a op to convert a vma into a PFN range. The map code will
pass the vma to the op and get back a pfn (or failure).

pci will switch the vm_pgoff to an index, find the bar base and
compute the pfn.

It is starting to look more and more like dma buf though

Jason
