Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB2244A5D
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 15:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgHNNYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 09:24:01 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18507 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgHNNYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 09:24:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3690390000>; Fri, 14 Aug 2020 06:23:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Aug 2020 06:24:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Aug 2020 06:24:00 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Aug
 2020 13:23:56 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 14 Aug 2020 13:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqyFQ6zaYvLksZpvkSChUHoEK+0n6Xekh2eTioRsJIp9eDCyMmNBgoLgAoT9BUoLCZU3WksXd+JZG7ltsytwUIx7YySuCHFDOwgfLFQLUS6AiKmRjZz4rSAzxzjszKHUiEbzQN/jB98X4STmvluMj60G6vvhVRdN+a6/dcyZWrGuB878Jl4T/TVB4dYWQ2GKXNUmntJlAmpC8qsZnbwWU8/oWS/eqQVH1+2scudEj69/M5dzmM+7CVQLyWTaJ7yuAXaJ4XAhHxqefUipj0w8iAVdjFHYlpfAoml9uDzRBl3O4P5EhwWd/k9fe9+C35fKxKRxmmuXiQ9D6vwnHdUPHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEKxcsretAumhsNSa8bIZOc54WVwzRso/kPsg3TKsO4=;
 b=Ypz3DNGi8zDfn7bqnpGXQa0q6f3fKoxY0Y5dLcoopvUyLk9Da3OHzC0o01+zvJ32tA5N60wVe8MlacCot1qG63+LLPw5wS1UvaMb7AkzTrfAEljRlb2iLCL1wlSQMea3pYHAJ+f2hESMyysKwABPOkbyqDW+QvkB3sdjz6iNuPWLYsYgyK17IWtcOAtsxHRK7kguZwFPVYsAF5aGYxOJkvB9tfHByT7mDkM+PqZBPC3jupFaiYUi3iLFPCKmPKz2v0v/ObVWSd5wTcEZH7PfApG9W/3XoLh41KBfnDg7WF0ZBtxrxsgGWigapOj3Zqzm5RrkLtMKWi1WTgRQ+HJ09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Fri, 14 Aug
 2020 13:23:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.022; Fri, 14 Aug 2020
 13:23:55 +0000
Date:   Fri, 14 Aug 2020 10:23:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200814132352.GD1152540@nvidia.com>
References: <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <b59ce5b0-5530-1f30-9852-409f7c9f630a@redhat.com>
 <MWHPR11MB1645DDC2C87D533B2A09A2D58C420@MWHPR11MB1645.namprd11.prod.outlook.com>
 <ecc76dfb-7047-c1ab-e244-d73f05688f20@redhat.com>
 <MWHPR11MB1645F911EFB993C9067B58DD8C430@MWHPR11MB1645.namprd11.prod.outlook.com>
 <e3f45862-c3a5-8bac-e04d-7be0e76908a9@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e3f45862-c3a5-8bac-e04d-7be0e76908a9@redhat.com>
X-ClientProxiedBy: YT1PR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0084.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:23:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k6ZgW-006g4D-Hy; Fri, 14 Aug 2020 10:23:52 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91f91e23-4f8a-4dea-97e6-08d840554ab8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739951C8F61BCB7E0CF8D5EC2400@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rx9ntj5s/YxTlq8w58Ye17B7AL8ZlpdUWvLZN5lTUBte12kiEjAcTCRNA6nMYNcq4u7cZan8vKavOJ/LHDG6/YORBHCuOQRhRe44ONxoaJ3hvO+poUq4+eMJ8maCCdL/U7FDYOJNFlvJLcYV9bAAZ9MPGg7o8ppRwoU/B4kWu3uOqvEq9bvGgO+g4jfVmK4C3bOspYFg9Bvm0aY0rkPBnIR5C1OGz2goVaapp1fjPldWnPnsbO0lQJp9gRdllkwUqd8LqWfvF+ZOeTB2VoR48zrcLtPwPlZaATzJ6wqIp53ivtSu3WAlOfF971T/x466Bbro93aUng30wr8NSQOEcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(7406005)(7416002)(9786002)(8676002)(86362001)(66556008)(66476007)(83380400001)(54906003)(66946007)(36756003)(426003)(9746002)(1076003)(26005)(33656002)(478600001)(186003)(2616005)(6916009)(316002)(5660300002)(2906002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5By5nfU1qiFuHk/gvKijgwEUkYT6NNCd0P/3m3TXoDZct+d1BWt/iL31ljnqeqlLuOiiyv2y0tWA6nOtAcyrshsYcKZMQwEkpzb1U894FL8ehXejoDAaoc+6yTe+ahnZEmRkTevmp47zVtaj+Hc1KVu8j2gwWhFXzB2WiN3I+y6OCBoCJl82i7vZAbSotKy2Bmew4+g5h2QtDHlC3T1ZGLyjePjqWmt/yNGBw+nQfFzdN+UjgQeeloVfoGQmGisdutZsboDUkGjvwJbXdTz9s2DDZL7FcmsMz6v/ZWhmzclHIMa/Rq9ivOPMAVF0AUzmOVxLn1raPqhOSVeFV0l/uE6d07Mqhq9iUpdsiWSLExQ7IQpTKXgyTF51OuOtGh8+A+/bHrGl/W5jhJAEt9/aDX+ovncykvRyOhopU9Mj6sC7z7G9XS5xty+XNvd1H+JC1MbWNE7i9ObN8nlO7//HOFDpaUR9KPTHik9pt8uc9B9XyHOD2tSg1yv8r1OJ7RAnjhb6pTaCQa2BAgnwcePnYPb3ShVSR9B71uT9/Pj8rtQYTCmZCalnmktJVONt5Y/v78kY+JPOL6umL0cvP6pAhN/GQ8KXEpEtT+beLgTrKv8Sq1pn8VYvmW/1lZrmcKagkMDzRDxklhe0GkFnIu2k6g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f91e23-4f8a-4dea-97e6-08d840554ab8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:23:55.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ByLX3ujHu9id5kk0A4x7645RFRKxgGRZ7p59soY+OalWvpWK87OIDoe1LM45Chr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597411385; bh=6gmnzK6qTJemowiU5IvwpbIyEbCOVRDkJXgG0Re9620=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-Originating-IP:X-MS-PublicTrafficType:
         X-MS-Office365-Filtering-Correlation-Id:X-MS-TrafficTypeDiagnostic:
         X-LD-Processed:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=C4ZfU0/WJfDfNgttPA+KKcxuSyk2HkbA6SXE/wP0PWBNU7SkR5/yft6onf7sFP3+a
         4YS/KmuCggKYAWHNyspTrEb1DJEngjQKDj1SX8N/cLoGELAYyn0LEsFDuR/n0S6thc
         54zDZ31J5zbnvOhPd47hI42amaBlyT7eu6WU1gmwxYXib3gZ3b4Rz+ESOx5pYl+3uM
         vtVG4uNcNAm0zeaGk7H5WRwiDJXaelZF4rOREWneIVectHq9ojBjdKq3EmaJGfTXY3
         IH8Z1fS61Hgpx/unSVgXgRP/ZnHn5xzDcQZstOagRMlChVKFVBX1idLM5Hg/mDRHZW
         Ep7WoVeUPhu6Q==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:01:58PM +0800, Jason Wang wrote:
>=20
> On 2020/8/13 =E4=B8=8B=E5=8D=881:26, Tian, Kevin wrote:
> > > From: Jason Wang <jasowang@redhat.com>
> > > Sent: Thursday, August 13, 2020 12:34 PM
> > >=20
> > >=20
> > > On 2020/8/12 =E4=B8=8B=E5=8D=8812:05, Tian, Kevin wrote:
> > > > > The problem is that if we tie all controls via VFIO uAPI, the oth=
er
> > > > > subsystem like vDPA is likely to duplicate them. I wonder if ther=
e is a
> > > > > way to decouple the vSVA out of VFIO uAPI?
> > > > vSVA is a per-device (either pdev or mdev) feature thus naturally s=
hould
> > > > be managed by its device driver (VFIO or vDPA). From this angle som=
e
> > > > duplication is inevitable given VFIO and vDPA are orthogonal passth=
rough
> > > > frameworks. Within the kernel the majority of vSVA handling is done=
 by
> > > > IOMMU and IOASID modules thus most logic are shared.
> > >=20
> > > So why not introduce vSVA uAPI at IOMMU or IOASID layer?
> > One may ask a similar question why IOMMU doesn't expose map/unmap
> > as uAPI...
>=20
>=20
> I think this is probably a good idea as well. If there's anything missed =
in
> the infrastructure, we can invent. Besides vhost-vDPA, there are other
> subsystems that relaying their uAPI to IOMMU API. Duplicating uAPIs is
> usually a hint of the codes duplication. Simple map/unmap could be easy b=
ut
> vSVA uAPI is much more complicated.

A way to create the vSVA objects unrelated to VFIO and then pass those
objects for device use into existing uAPIs, to me, makes alot of
sense.

You should not have to use the VFIO API just to get vSVA.

Or stated another way, the existing user driver should be able to get
a PASID from the vSVA components as well as just create a PASID from
the local mm_struct.

The same basic argument goes for all the points - the issue is really
the only uAPI we have for this stuff is under VFIO, and the better
solution is to disagregate that uAPI, not to try and make everything
pretend to be a VFIO device.

Jason
