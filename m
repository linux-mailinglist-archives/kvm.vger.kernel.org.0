Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FB02B4A09
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 16:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgKPPxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 10:53:53 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:16960 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbgKPPxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 10:53:52 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb2a08e0000>; Mon, 16 Nov 2020 23:53:50 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 15:53:47 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 16 Nov 2020 15:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS7WVEbKUg2rtgcOOXPkTt4pTds76fK50T3z21MQ8WEC/NSIy9DKtgpDNnxDOBDDG0If/e39faM0HgVX9PWo8IyorGHQcf8KiaejgXzk03ithl4FW/po0vj/IX9MnO852Dm46owmLyZnLJ1Lhb+2fv1ohZ6jVbb0aQd+ZBzmgHB5i34ea0arvHJm8nWRCUggeVmHt6rp7mPqU7lPhZHva00RVBmhtdq/UNmG+I0IpFnri0V4IM/7tpcZIvVZcSG1P7BbHSv/hzvfA0y0ByyhOabcSWWmTA7VRl07+9q9Bwz/X+nBzaWiv5IaKzrGiZntIM/i5uwqoxbbyDjstL5Adw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bd6Zo/KZcJ5FmC5bDXXm5xzoOXOWDlz9kA+rDYDFmN8=;
 b=FL2f7twr/mjRA1x1j7CFYsZVIQIYfJpjg28LfH9/Gd1T7slZrKRd/TuaLQ6MC34T4mwdqlxVje0FEYdcwo8/bbrcdi4JWLL98JmqYMitTVawtM9vk6xwS5AedBwuB0tDX3RTI8yaTfElbmigsabiPJAqc6B3T/DRZY5HdKQo3+4nV6HsNtWrIbzxYH4rg77XZaotHZPvayw5+ql0BN4WnjBzb2PwphpEQvyDvi+wsl5yAYUzlcJ9Lj9OWrXjtChDrHkX91faAMI/qlyt9OwkHjT+AOvIJma5oVIz1mGy6gEIQkDINBDMEAizfTXf5eTwcFWp75QicionKY3hHp7g1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 15:53:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 15:53:43 +0000
Date:   Mon, 16 Nov 2020 11:53:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
Message-ID: <20201116155341.GL917484@nvidia.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201105233949.GA138364@xz-x1>
X-ClientProxiedBy: BL0PR0102CA0040.prod.exchangelabs.com
 (2603:10b6:208:25::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0040.prod.exchangelabs.com (2603:10b6:208:25::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 15:53:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kegp3-006Ekn-VW; Mon, 16 Nov 2020 11:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605542030; bh=Bd6Zo/KZcJ5FmC5bDXXm5xzoOXOWDlz9kA+rDYDFmN8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=M+KjPnSwMT+c7tYsj1ETklNExTGajsjfaX/TpSi+7CL4fgLJYtufCwChaFarAOg03
         47kFUz6z+h02xi1THKenzDSTDWp9mUgVGN/avUm8EqgzHTR/QrtJNbQMgv7y3o0ECD
         nPRG7WZXJfdc9ZgV/Jgl81cI6i/PE0C2yTCld6k1qxVHzymqxVEOxxL07YgbRSLvdA
         W2egGg5R7A8dV3OmkKezHtGxr8uYYr3vGCvcCMOjGzcZDjyTlCdzhk8JScJhOed78z
         GUTaJxTQ1SUmv/zPL+/SFxxbt0uVO8woHuEsdPsCT0p0YsUeI/UbOcMat9ETmqb0ka
         X0qNauOVPNRow==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:
> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
> > Tom says VFIO device assignment works OK with KVM, so I expect only things
> > like DPDK to be broken.
> 
> Is there more information on why the difference?  Thanks,

I have nothing, maybe Tom can explain how it works?

Jason 
