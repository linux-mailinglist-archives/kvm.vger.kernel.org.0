Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C5326332
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 14:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZNQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 08:16:32 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19272 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBZNQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 08:16:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6038f4840000>; Fri, 26 Feb 2021 05:15:48 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Feb
 2021 13:15:47 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Feb
 2021 13:15:45 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 26 Feb 2021 13:15:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT1A3eKS+fbx4i9vcgh+TULUlrcIJwIxoAmD7U+hc3e5M3sLjlGby06EF86HSb8lzMDFp2kxfxJK1QSN3cdAoHL8Y/3KYumzQo1a1Uq8Ool8IsnuHTdrkU9e18T/TNNtxAHZbwEzNikxV/FiBPmoq8ZBwAVzeN4u6CfJX2lSSZf4hdhaGYb2nYiqxPoplylMI+TqquKoUegh4Y7ypJ/xf/YkbN9r3x0cGjFIVD034iDBRLP6XJhzqpnTGoa0lqiC3Mtd7XOMTd13mkms+8H0c/GsbiG0y+0WBSY5O/PiK8aEfZOS7jwYAuHWhHJ+6KYkFolXGJziGSnHoU1A6gWOzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mMqB3DlSEPfPUmiJ2G36doXPv9/ibiqfrnYrng0lXo=;
 b=UmXXy5yE7OGsF8Dl18Qo0//ekaYeHpWE0RZQf0Q1CZnIeSdW2sigD0IY/MQpOhtqkQXfRSQSAWTLani4lCEcheWYgG50gZBCs1g71+x1wFMAzdLqRsUQkts2tf8nxTK9zWnJnT6X0mSlVIaFhvsTdvpUWcjCI/VSISoc8ew47T8jMZ+1noxiBChrXq3hAPwKj/UWjtmQX6LEQu6JIz0N404cJHazb6vCg0EkfvM/7hfjrRnSCcb8kAIiUihROADLfbIHRzJo5haSLF5GmvHk1wIQmeWbYJ4nZARQ/01J+oTzr/FHB+wczU+J5Mj5Kl/bVl5kDu5OtPu/9GMfZ7NQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Fri, 26 Feb
 2021 13:15:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Fri, 26 Feb 2021
 13:15:43 +0000
Date:   Fri, 26 Feb 2021 09:15:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterx@redhat.com>, <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 01/10] vfio: Create vfio_fs_type with inode per device
Message-ID: <20210226131541.GY4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401263517.16443.7534035240372538844.stgit@gimli.home>
 <20210226053804.GA2764758@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210226053804.GA2764758@infradead.org>
X-ClientProxiedBy: BL0PR0102CA0038.prod.exchangelabs.com
 (2603:10b6:208:25::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0038.prod.exchangelabs.com (2603:10b6:208:25::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 13:15:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lFcy5-000oG7-Sp; Fri, 26 Feb 2021 09:15:41 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614345348; bh=3mMqB3DlSEPfPUmiJ2G36doXPv9/ibiqfrnYrng0lXo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=jjHCL6mfCiWI/SANTebvvxU0GKmIQZl59kNZK9hEq4JxhzTjqDR4XVbcy39tWEn6+
         T5rJI67cWlXqF5V6tcMjLGtjdyMnE+rfNAqD2dRTvkbUg2AFgZuJ3qBGPIxPYybhwZ
         rj8S+KA5wyP8u7mlOpqi1HS97qi7ufCxW5ZGvSPg7Pa2TfkyWTPWsxPFfUkiLpRgTp
         n9lFfbqpx0uV3rcOPH5pSgHvM1HVkt0QuSgiAOED+IYy3vsJH//EicWghei9995Byi
         vXFVe3TKHqRBYt0Z3zXrJDm7LBAjD+f7Ewcg54Q46ZtAGvmR7WPsTNkJH5Y9dAkwZr
         tCe6U3NpQDeLQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 26, 2021 at 05:38:04AM +0000, Christoph Hellwig wrote:
> On Mon, Feb 22, 2021 at 09:50:35AM -0700, Alex Williamson wrote:
> > By linking all the device fds we provide to userspace to an
> > address space through a new pseudo fs, we can use tools like
> > unmap_mapping_range() to zap all vmas associated with a device.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Adding Al:
> 
> I hate how we're are growing these tiny file systems just to allocate an
> anonymous inode all over.  Shouldn't we allow to enhance fs/anon_inodes.c
> to add a new API to allocate a new specific inode from anon_inodefs
> instead?

+1 when I was researching this I also felt this was alot of
boilerplate to just get an inode. With vfio and rdma getting this it
is at least 5 places now.

Jason
