Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E782C5CE5
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 21:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbgKZUNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 15:13:50 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:2920 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgKZUNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 15:13:49 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc00c7c0000>; Fri, 27 Nov 2020 04:13:48 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 26 Nov
 2020 20:13:43 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.51) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 26 Nov 2020 20:13:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L26C7VQslw+DeVtJ1OGyPT0EI113Ez1clyK8iQtvAhElOmUQa935i9/RsxvzJX8FvbbowNK4Rzk51CPop7qMKjAm6VAvkRIp0CVImWQcmewDSS5zDUsbIntX/R6l61sM+P0bnlbsbiPtfGlDSaxfpSJDTIZec1kvebjrPNuQ71ECsBYaIiJNlNafmQi9m7jDNg6OZpnAojEenHjUHWN0QN9I27znKyLQn1hRl64Vvrq6/c6Yt+kOMBc6DiQQDFJsiT/2OFQYToZkmXly9GKNnN+f/cP3a0cTQuwA2xCTBb0wlf48p1mRy2QL0vpUcpZ2LBa7xk81kdIZppnZvf999g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sf1yVU111k14EgqQ+AF881i5HFrGUpCIMbTA50Yn5T8=;
 b=iVCjB034rSMMOtEcy5owrJZtC1ZJvkFrrzdTsAzL+/Pdsr9JkdvCjQYuhFmX0ESeIFemdBliimUNHGnNVaxayCQanptF2J8ICwak9DXlgo1oR/mRuAbTk+turAVSp+6hjntk5Pu0KdB0PZdBk7Sx7TMK/icqYq2lfy2WSmfKMu6FRQqUzANjcC5ReMDPC2vQL1U1x8kxU0RoTcNOuUSGjrYcHwF/rXi9wQywpivMGtCUkPdC7FOeyG5ddwd8RjIa61Uwu5POMXhdngKJYzNbHJYtuU3po7MPLZHHZ6lP0yyl+VcyGzaKYFOi+mUNiHQVjihoqOPpLUYDPy65o82Oyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Thu, 26 Nov
 2020 20:13:40 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3611.024; Thu, 26 Nov 2020
 20:13:40 +0000
Date:   Thu, 26 Nov 2020 16:13:39 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201126201339.GA552508@nvidia.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com> <20201117155757.GA13873@xz-x1>
 <57f51f08-1dec-e3d6-b636-71c8a00142fb@amd.com> <20201117181754.GC13873@xz-x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201117181754.GC13873@xz-x1>
X-ClientProxiedBy: MN2PR19CA0036.namprd19.prod.outlook.com
 (2603:10b6:208:178::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0036.namprd19.prod.outlook.com (2603:10b6:208:178::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 20:13:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kiNe7-002LG2-87; Thu, 26 Nov 2020 16:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606421628; bh=Sf1yVU111k14EgqQ+AF881i5HFrGUpCIMbTA50Yn5T8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=neS3ZB2nyvQjAB0Va68ANtOrnl69Ce6YE9k+VWV9ztryWGgqcYuk0C80TGiv3jK9p
         3g007dMOLPlmR7j+Cls/p7Bs4Zff1rnzcBFBoFyrQdGTfJe1TU3XhLDkfYeRP8nR/Y
         b4cGU88m8/OYtXEwMoxhJ0BB+9DzO06q5WP5J0QrhtsOGrQarWzaNuSvCg0GEdS94u
         HWd5Xkv0fxDjilGeXoXFdxy0iieazd7Hy8/vytIwCoGVYIfOruV4wAhKQElp0+l1Ta
         ZVczqSsZqzfGQMT/vNI7xA/tRpuQ7ejYJ2RScTClZuroMgBVFrrozX5iJyN+EOsEdo
         cDxi0M1RLVSdw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 17, 2020 at 01:17:54PM -0500, Peter Xu wrote:
 
> Logically this patch should fix that, just like the dpdk scenario where mmio
> regions were accessed from userspace (qemu).  From that pov, I think this patch
> should help.
> 
> Acked-by: Peter Xu <peterx@redhat.com>

Thanks Peter

Is there more to do here?

Jason
