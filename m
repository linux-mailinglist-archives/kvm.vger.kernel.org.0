Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F273326CE0B
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgIPVJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 17:09:14 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:46866 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgIPPzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 11:55:51 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f62268e0000>; Wed, 16 Sep 2020 22:51:58 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 07:51:58 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Wed, 16 Sep 2020 07:51:58 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Sep
 2020 14:51:53 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Sep 2020 14:51:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4zWGn1q4HFRNfso59/1wfwsFyoacB8o3UZLeUk5xX7qUiEzf19xOC4sd8oZA6fl5kfPFEwNW0BJtE2vm541tnbuBIcs5WyuDjMk+0PcIs9Xe+xpNkUNxKwaGVS64GT/s2I8UGJ3u5RDea86jQXZQquj3EsVpfhpd4Iuk9Rf5Z/JUh4NyK4chVZwTRvPObLmmeBeuBi8GAVbZ6Rn2wK0du35/vHg4be3aannjmWC9G6d22B/C1ir5fhGezV9K1OURCF+oZcY2nV8rUV/vwyRSpQfsxw8HXbbSEbhPzj6cqGza5tPYFUgVz0iFoSj6SPfij4qKBAQxm2JYVOmk2YNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU//TsGNgG8pQRpzvoeQ9c5kyycP12joHbP/jZaHfuw=;
 b=oFvfSR66soEIA0gt+5kVDQcqD9Zn8Gdy0ucZjn8zTFNLh3tLb/tikPKOodR6hoFOpkfrryr8Tn7iXd9p9h+btH9DRBnCp0tUgz3cfZ0fAQash69Y58WDtLG8mz2ilJ0A3mBCI+mDsyFbPNd/9JVoLO9N8PY1omFHpbCUoEDqXL7PpY5YygDE/pDzi8sQoW75AWmUibZ3ifFGLn8OggV2lPbrCDb+C5ifN8AZMOhA9mrV2i6CXN03fgLhlaWxyMWB9UQgatLWwveYyG6Uv9uWJ1UGHklyjBpgr867z1SW2DrfNJ5G4ULwfAGeGxnTH1H3x7kIlwnoYkb4zOMD1o4HgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3306.namprd12.prod.outlook.com (2603:10b6:5:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 14:51:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 14:51:50 +0000
Date:   Wed, 16 Sep 2020 11:51:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916145148.GD6199@nvidia.com>
References: <20200914162247.GA63399@otc-nc-03>
 <20200914163354.GG904879@nvidia.com> <20200914105857.3f88a271@x1.home>
 <20200914174121.GI904879@nvidia.com> <20200914122328.0a262a7b@x1.home>
 <20200914190057.GM904879@nvidia.com> <20200914163310.450c8d6e@x1.home>
 <20200915142906.GX904879@nvidia.com>
 <MWHPR11MB1645934DB27033011316059B8C210@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200916083217.GA5316@myrica>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200916083217.GA5316@myrica>
X-ClientProxiedBy: MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 14:51:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIYmi-0003HY-7g; Wed, 16 Sep 2020 11:51:48 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f07e7bf0-8260-409b-e664-08d85a500ad2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3306:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33069546DEA7C4BFA699EDEFC2210@DM6PR12MB3306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPoxmRyGxUvZxEGKyqRoTz/WzpWleIzqIoXNwqVL5GOHaX4ux3ya6GkNPjDXbsfqth6fbZEdyB4LHLh4hnJa4iIPivYQlj44OtWI55k4p1f70JANaM7vz7wpAuBoMXk7aSAO3s0jrBowMwAntl6Z3FDH3EOAI0bZRVG7m3TWuCnh2+ysumAVytwWnn9grIW5xxAMreHtFUFV6HyZZuvZOtWJF8bwTi61NzndmVAyjNhu6kk4pYYTM7oTZjAWTXKcMOMRrMXi6K21bDXVBK/0Uaj28Ln9WqeJxHHgeYKijDm2PC4mCyzXqOgMBPWICZ+c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(4744005)(54906003)(5660300002)(86362001)(1076003)(478600001)(6916009)(66476007)(66946007)(66556008)(33656002)(83380400001)(9786002)(9746002)(2906002)(316002)(26005)(186003)(36756003)(2616005)(8676002)(8936002)(7416002)(4326008)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uB9HPA4t+bem5IF/6kUqHEvbz/hjg1Lr+mZqTBAEhqOITX1W+9QRj9+y2956+IvhNmAXZmEapLK8nrneH7kv+ZmdKswLbc1/MYQFv98X4CJ4TDVppScRVvKFAOiq0SfxCkZZOTnZ7GhuNvDs0I0WT/sDJOahEsjqZKj/uMSKU+Ke1jCicxFuhsY+nHb7sc773a6NL16Eg4t50DfzTt1iJtVchZDYVCigA18f8a7sehQ8h1wCG7Rv2fSJOV8e5Z76R/sxOXv6g64Maqgj+5Toda/GBlehWm8IJaPTmxtdagUbLIF4TG/LB37E4LTpQtiDhQgi9JY73JpZ4TSJpqcaRPmLrCgcC+onzdxr33uWyQBE+4sGaBzuoW0nNfIGod+x80eXKdUksctsu2O5LEW69RjiZ0lT+a/HJkjymue2O+ULdXZsmB4wVrbEX6nMcejYUKVqBVHj7RUKQ0CnlI/NKCsEwasW4p4FIxjpin7acGEpVQpT27VCFP4HXUPlhei+Vc9rTJ1TCJxT3uOQidQLFk/y+YazctJlpM9iY46Ya12PRuKCqzKFX8NdULXyZy/2+6uho4RuyDZ9XJyXJtAA4KhDB97f4N2I/StWwmJp99h8NGmBDDzjoRouW/fq7zy87AIPxnN5l9qAsdVZIUcf0Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: f07e7bf0-8260-409b-e664-08d85a500ad2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 14:51:50.3799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA9vr3bON4eJWfV+OVRVBMaY6V2kRIFcaZz4wGcYYJZ2Xki8eM8bTzwtL3kWIzxK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3306
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600267918; bh=RU//TsGNgG8pQRpzvoeQ9c5kyycP12joHbP/jZaHfuw=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=LpJr02Ececg425MIpU1XoDl3oHv7hCTq/VCBEsfVMEmlf45WIdSqsUcdcAuROmnWm
         j8YQ7NUJ93ASa9Zmm9zEFmv/aopQicf1twUqTZ6J/VKdAW6Pc1DYft0GYZJSDvAnS9
         DNWo1g6WRHoMyllwJXWWzuZ1FG6XW5pQgx/IFd5ekLnvWH0pee0GiVzFYPwfBpR2rl
         5kDCjrqvuR3cCE/X+HYiB6s8CyatRjSJWY3dfSFrz5lG0+bhd4BIOLaP1fiZvPn0jl
         +05sZPIMuKQoc0AijZryTFRDRWvUrJ5soLyb5huCx+0eQtVrYvp2ygV7tXKLbhO4P+
         mF+jbNNfwtrsQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 16, 2020 at 10:32:17AM +0200, Jean-Philippe Brucker wrote:
> And this is the only PASID model for Arm SMMU (and AMD IOMMU, I believe):
> the PASID space of a PCI function cannot be shared between host and guest,
> so we assign the whole PASID table along with the RID. Since we need the
> BIND, INVALIDATE, and report APIs introduced here to support nested
> translation, a /dev/sva interface would need to support this mode as well.

Well, that means this HW cannot support PASID capable 'SIOV' style
devices in guests.

I admit whole function PASID delegation might be something vfio-pci
should handle - but only if it really doesn't fit in some /dev/sva
after we cover the other PASID cases.

Jason
