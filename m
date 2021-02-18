Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D8031F2C1
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 00:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBRXE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 18:04:56 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13458 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhBRXEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 18:04:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602ef26b0000>; Thu, 18 Feb 2021 15:04:11 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 23:04:10 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 23:04:08 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 18 Feb 2021 23:04:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D81oP4IgwGJ3D17AblqhuGFPHcqaZfAoMyoDWqBposxq2EJwkr29V10O/wPpDZkWRuWzRR0r5nNQCzASN1PD5bFOPAy6SaNqfbMbHZnytIQBLftdh6nvSFxchoRR7YM4M+xB0nEdR12Fa8mIpJiIhb42i5LJqIHDsKoF/DmgDYVZABXJjiHOSckIMcUOyDIaNFBK5EYgfrPT/USa4QlJktJFesATFZkxVG8OIyNhKJdP4WZ1nQsOgSKurlWWr6wKKDAdhpSFTOkSwMlovGOyH3jLrjq2P5YslBg58Gas96kjsI/r45X7CKdCrzE7cD4kVvowfnfXziBoVa71CIqCNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zltih0rs0t8smXYQtMqc3w37XuUToESSe4lFwzNgNgk=;
 b=VES64IBhjN+tud/axuEbKOP3CSFcLDbV8u9d6DY2wQJdslmNX1X72zG+Jb6eM460CVnQIiEoHr8+/azVYCRrj7x9ZDMa+bmbOBjr6kKT46Xir9SvoZ2jpOylzcuHJWxGLjtuL9xA+bz9J+H881GfNAs6TBmz6HC8bT5867Is5JETwWsGFEFQGLXHnslWk9QXwK1k27K6Wq3fksXoPMRxkEUik1ZNlLq/XVj11HyEIP5FfCNIO08mWLvSZKknR47NLDLtMFLG/DuXvWZuWY0WQY2wqaFStpbG9d5Sie9Q0i0L7MxMF2hHns2x4V2QZjy4Hnfrjpdtxbwj+KZrzPDWOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3210.namprd12.prod.outlook.com (2603:10b6:5:185::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Thu, 18 Feb
 2021 23:04:06 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Thu, 18 Feb 2021
 23:04:06 +0000
Date:   Thu, 18 Feb 2021 19:04:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 1/3] vfio: Introduce vma ops registration and notifier
Message-ID: <20210218230404.GD4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
 <161315805248.7320.13358719859656681660.stgit@gimli.home>
 <20210212212057.GW4247@nvidia.com> <20210218011209.GB4247@nvidia.com>
 <20210218145606.09f08044@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210218145606.09f08044@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:160::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR13CA0004.namprd13.prod.outlook.com (2603:10b6:208:160::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Thu, 18 Feb 2021 23:04:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lCsL6-00Bend-D0; Thu, 18 Feb 2021 19:04:04 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613689451; bh=zltih0rs0t8smXYQtMqc3w37XuUToESSe4lFwzNgNgk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=B5VUxPTWU97qImEAGiu/4ru1APEfo48/bpa0Wbk8jnp8yPNq9f8ajad6ALOI4fKCT
         9EOwwJR0ZUrLbKeAJIA1UfEdeO0iB4NeK73YyvXiIVrSnrK58Dq219oP9B9T3bEG7H
         Zq5JmefELK+tZ7zkuHdOKG1jH5ShlQ9t5RU0J44etDhd7a+uNmyxHY5mjlbTY+phEB
         u9hbSBp58xnfvxNxS2cv8HzzokWWP7iL8qIpWkh13x3qPOZT/iGtCPoM8Bu9Q6wEsK
         qhykk7QAGQp3CX37ldNczJcXF/vVoWntScrm8rYrF+s14kzmIIRMTl1A8bykyZa7iu
         rQjGsZj4pO30g==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 02:56:06PM -0700, Alex Williamson wrote:

> Looks pretty slick.  I won't claim it's fully gelled in my head yet,
> but AIUI you're creating these inodes on your new pseudo fs and
> associating it via the actual user fd via the f_mapping pointer, which
> allows multiple fds to associate and address space back to this inode
> when you want to call unmap_mapping_range().  

Yes, from what I can tell all the fs/inode stuff is just mandatory
overhead to get a unique address_space pointer, as that is the only
thing this is actually using.

I have to check the mmap flow more carefully, I recall pointing to a
existing race here with Daniel, but the general idea should hold.

> That clarifies from the previous email how we'd store the inode on
> the vfio_device without introducing yet another tracking list for
> device fds.

Right, you can tell from the vma what inode it is for, and the inode
can tell you if it is a VFIO VMA or not, so no tracking lists needed
at all.

Jason
