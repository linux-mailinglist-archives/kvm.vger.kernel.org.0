Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD532DDAD
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 00:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhCDXQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 18:16:45 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6827 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhCDXQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 18:16:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60416a5b0000>; Thu, 04 Mar 2021 15:16:43 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 23:16:42 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 23:16:40 +0000
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 4 Mar 2021 23:16:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a65Jbn9kLh9ZHbS1tE7tymP84ywtpVQh8r2XX5EGpnmbPrnf3Xe1fL9j8j935nkxeqrfxOvq6oZfZG/nJy+X8L2i8C1ya5RzswCABWGci6cpo5SXMT4TSH0S4PqQI7deL67LR1KST9Kht8M3klLw7bRCmfCRFPoqunXfp/0ieWwKWBZhPVgg+C0/FIcZLvw9y1gTn3pUSRDPrQ9dQ/f+Kh85DdpUntAMMyio+Kpr0xcvlqOiORbB/SgI2QBimIU/yq9qqQV/YWFSef2kxgOVE4UND4y0Iite/6r8ap/SHKSO3+y1tikYaedbgVVLfweNQqM/6fgh/89VmxX0hm1kMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1+0Mj0+PWRPur8ByW5BoTSDyX5M16AAroqBuQK95As=;
 b=XKEhLiEtfVT2+d8aJ+6EEI5GfRrGGW0CT2XLJWkWPTOj1Ugb8ZqxzPHbb0ft+YeMVP5uC4iVErYq32Ex/ST/fYRJ9oZa3n6PbpMmY1oBEyQXOill2tiZ+Msk29IXMW1JT69580ZRLGBA+2Q/dTKG9UtdaM1BLIANIXS7Xlxu3bpL61YlK3EMj1z+s/Yhal6Aax14IPpo/5PWRYDUp7WH5nADutItnnl74TLpQzv54L93uZZFLnSsIZ6CZs5VcVYFA+RfGMwDg6MSQytzODdh2sbQGKnwvUIAVA346oZPVsnGyNgYnQKPp7s606QH3NA7jmLS6O1KnEfT13Z07a6WgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 4 Mar
 2021 23:16:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Thu, 4 Mar 2021
 23:16:36 +0000
Date:   Thu, 4 Mar 2021 19:16:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210304231633.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401268537.16443.2329805617992345365.stgit@gimli.home>
 <20210222172913.GP4247@nvidia.com>
 <20210224145506.48f6e0b4@omen.home.shazbot.org>
 <20210225000610.GP4247@nvidia.com>
 <20210225152113.3e083b4a@omen.home.shazbot.org>
 <20210225234949.GV4247@nvidia.com>
 <20210304143757.1ca42cfc@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210304143757.1ca42cfc@omen.home.shazbot.org>
X-ClientProxiedBy: BL0PR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:207:3d::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0064.namprd02.prod.outlook.com (2603:10b6:207:3d::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 23:16:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lHxCr-007Wg5-RN; Thu, 04 Mar 2021 19:16:33 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614899803; bh=l1+0Mj0+PWRPur8ByW5BoTSDyX5M16AAroqBuQK95As=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=HhzQzv0nc6VsapvLIygnsK5osAdTx77EBgumebyr+jeBdWVU2iDq9xMsVTcay+6X9
         yDTQoSJ/EJUveofPZkRzBShSALFyOZh9E1izoft3yZOH5YggLuNEJSs6YsB9vFUFoF
         diRlgc0yFNSbuUITM0/zPjqoiePhDqJTi8M7Eu3DKV75ChoOL124bb7/QIQDEFiDFd
         rjZfBHMs8lAB8ELHkYofVkBW5tUgh6nIf++2LJjBO+GcDO7hD+UnJVPPLASpdpWOye
         K0jHG7qxB0ItlyJW52aqruIUeF0yUi339o1oau87ok9YccuN2UaRPqaiXpt5r0OqXt
         vrVmll0hH4pJA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 02:37:57PM -0700, Alex Williamson wrote:

> Therefore unless a bus driver opts-out by replacing vm_private_data, we
> can identify participating vmas by the vm_ops and have flags indicating
> if the vma maps device memory such that vfio_get_device_from_vma()
> should produce a device reference.  The vfio IOMMU backends would also
> consume this, ie. if they get a valid vfio_device from the vma, use the
> pfn_base field directly.  vfio_vm_ops would wrap the bus driver
> callbacks and provide reference counting on open/close to release this
> object.

> I'm not thrilled with a vfio_device_ops callback plumbed through
> vfio-core to do vma-to-pfn translation, so I thought this might be a
> better alternative.  Thanks,

Maybe you could explain why, because I'm looking at this idea and
thinking it looks very complicated compared to a simple driver op
callback?

The implementation of such an op for vfio_pci is one line trivial, why
do we need allocated memory and a entire shim layer instead? 

Shim layers are bad.

We still need a driver op of some kind because only the driver can
convert a pg_off into a PFN. Remember the big point here is to remove
the sketchy follow_pte()...

Jason
