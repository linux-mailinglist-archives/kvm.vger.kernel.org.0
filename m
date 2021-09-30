Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8226B41E3EF
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbhI3WaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:30:05 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:45216
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230100AbhI3WaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyYHJJ1Z/yMvSTZBpUPz2ZxZS9s8hv35RsQ6zDaW3Iae6haTfpwhAwvrxlZ91zkUtTcsLDk0p1nZL2TnOTdT1jQjncMuu2EgnTpqf67JGqzIIw6aaE2P/345zh1JoEPksIHzJxG5HIVKb5ojy1D5Nl1pQrD7xPxeLjLGKwEVujhH6Rh7PPkq27wbYZaTdTx3Ha0T/q87UWXiHvAPv8zAmjwmVRtwqzKMWaxSVWGj4dnpUGNuQzpKSLknL69uaIT+/j/OYdZhDiAkAUycqPrzshG5V9+0uL+E2mizUAl1ThJ1mW130XL6yux6J0+4j3Ir13MHf8pNimw7BadetISL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9HfDPX3U+cacno69Kq+AhmGfX0FvDxufW3PR8N7+ZI=;
 b=Re4Eze0N9nf6/FtOTN3TxE6vEl8M11lJecd0ukIyPyQ3mQPOo+I2A1yRNcqe5nM8pdVKcIll5Es6JsBLHoXZpRJwYv7gJI1S3+KqSpKvpemU9bAC6zqASprRgtSaB9HLcarQxwGTG1zLQrAC0D1pM3rqbJOvDImd+YPuG2+otRglO4Ced4xqByJe5W0F3N/B758ANjEvhBbmgufF1KsCyq+ZpNZM6pU0Rk37lTM8QmjAyH1VqurHJoifeeuJSpU263WmSSnYWdIq0AHAXgHucYoRLH1M4TjqYFuD8/bC2SLAu8GhlJvgrAc33oPU6AEKYUxfvW5Bn3d1vfpfv3uS3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9HfDPX3U+cacno69Kq+AhmGfX0FvDxufW3PR8N7+ZI=;
 b=MxHPBDHwqTzW/uuyCR6CJr59/DXAn5oFZIUsFNapPVLiCNJpYNMC+k5l4EYTe8tmGxSwNgzvLT/MtjGJnsX9gGqv5PUbAdTX0JCR89g5GFDYR+K+oYqqjsLMurU5DK/dO+pRPy4O0aPaKDieLOUtZiw/b0aFnPg/SXahTIAS516Ovgw7u8l75VXZdQH14A0/yQ1Pml4otvsDSXOYux6iYCVYqL6wCrl3l+ZWsL9RbeMXNaDUPGXoUHm5kQx7yJMpmdNqGgsos6w3upgExAJwt/JB4j0UuNXKoewUNH1uygbXDtEQ3eg+qVOGoMoq5YNOE3ZvA0f+5vEKLv690pkKqQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 22:28:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 22:28:19 +0000
Date:   Thu, 30 Sep 2021 19:28:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210930222818.GI964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
 <20210929125716.GT964074@nvidia.com>
 <YVUqYsJTMkt1nnXL@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVUqYsJTMkt1nnXL@yekko>
X-ClientProxiedBy: BLAPR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:208:32a::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0106.namprd03.prod.outlook.com (2603:10b6:208:32a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Thu, 30 Sep 2021 22:28:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mW4XK-008DY7-Av; Thu, 30 Sep 2021 19:28:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7450b203-f7d4-4a4a-1e06-08d984619a99
X-MS-TrafficTypeDiagnostic: BL1PR12MB5364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB536492037E626F74E894CC67C2AA9@BL1PR12MB5364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9oIawdJmpk6llTAOyCImWSBw4R6WgpN/+y2Q9SUSDETILkPOi6mXmmru0zAAGX6P0Xa34tVbcLZNov96214aTYV19c1TLu80I/CZwDjAC2DMtHH/EMTAjPHfI04X+4+8cH3FPAS8aC36TsXOOm6uFQkR9Ah1X+ir0+qq9EznNLrkTD15pgnqpyr71rsHONxFo5SLuX+QeeR3aSIXiWykenMPuRVm3MDpLy/hJDAyv/4ULiBPTlfDg9R304RCvxhsMZOG1YoCrY9sHPv9QcljATBy6aHnEn6i6OkEyZle+lHAYLoiDlGNCEvSY9/wupt/RoakMFoVQdrji4Yyvqdp5SczmVLyvd7szDWo+4uEu+rnZCQQDxGSdQX6/geNyGhWoNcLmNAuq7zSRvuaUYxgZDw1/zfp+gU8hsU3SlcwiJ69Fwy5BziFfykZZTHAkrQLcqTJPlhP7DVk2IPqYPpju2orejEpev1m0SpL3wHlhDFFitnh2+u2POMXM7kZgrxsTXJPksSnVUY4KahxlWAVmivmOwkqejVvr7Gz5lt5TBw6Ex2BcKDI5TxG1hitpwxwceaIqmHjtOa5K5bBopSI5qY1IK4sUhOgyu1hED7MpAV0rkA2z9WYWm4ogdBvS88FI3Xla3k6QIgb4MAqAZ1+5kbbssvx5ywP0EKRyMTwVtTIS025M33AAOTruFatKSXPfiX2VsDTHOx0Fm8oAGChQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(2616005)(4326008)(36756003)(38100700002)(66946007)(7416002)(6916009)(8936002)(2906002)(1076003)(66556008)(316002)(54906003)(83380400001)(8676002)(9786002)(186003)(26005)(5660300002)(86362001)(508600001)(426003)(33656002)(9746002)(107886003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tn8raxUckz2dbkx8nuEjoHZ6t7mHCKoyinxsTbJa+r9zcqMTXeur0xTd8Gj9?=
 =?us-ascii?Q?dWhvfND380QXCDP5cWNuoIV4vAkxg5xMKfVL/iHCufk52qJzCGB08+KlVYAv?=
 =?us-ascii?Q?it1ARA6oSnaZ7F+8DmFthkGXcIGnHy8Ks3BgDcll234Xn+dEgHJmhgy37W4g?=
 =?us-ascii?Q?fKc4mE1xsbZPPx/kNvM3ByJnOQW0PtnhpEQwxFkoJtJM8EZLdDwxWvcT/Ql2?=
 =?us-ascii?Q?b2Rx9Yl54NPnAxMd//xnhKfFkRJ+Q/14x6QKk2KUJk3hRLBwzgBjV3r70fYj?=
 =?us-ascii?Q?IPl8CG4vqMS4bl2pnH50c72B6n08lgo45Tnk28keSI7F1V4GCT4SA5GzdfpY?=
 =?us-ascii?Q?5Y6HsOYVTYR1RAKTT8YbAEb2C1hw6wcHmYW5v2kYyPWYptUjadpGbXhP5GSc?=
 =?us-ascii?Q?+7OirYvBBrHNG7IlPqieqG76F4Ezpb0rYKnreb8o0rZlZgSwPmZ4jPPclzDB?=
 =?us-ascii?Q?axdDIG8ERVaq9BgObUQd+v//l5JBef/ZATrRuJU5+2Xq2bbN0o9i9HqVBh+4?=
 =?us-ascii?Q?OdtEVJYf8zvNMkQMOpUnJ2ZLOQ8TMTYBubUgmDJ0+oO0bE6HBj5dOLgrhkoZ?=
 =?us-ascii?Q?Dqd+9JkNsNIQjrzy6aMm97ctdDrGi4vcVzDwrmnPsoS3bX7NgP6r8jXijGQI?=
 =?us-ascii?Q?fN1/vtcVcKle5G5CwrBcdKtzBAfrN2ohnreXS6ar7lbFF5M0NPfk+K0HuPY1?=
 =?us-ascii?Q?lwySW+QF9WIi6d60XfteVkdYYzzMU1j6S4Vq1qngIqIInOT6PsDsCxbThTNt?=
 =?us-ascii?Q?mopq6YXFyZ+1UrvcPj11mAZ+ZHM1i5e9QAYbow4XbqN7Kmhl1RxtHCGmMxmQ?=
 =?us-ascii?Q?at4SHeP0hMd4eGRWDmKp71GKtL7WfePARqWKi4SdA2aQ3bAJNZvksiLGMHyK?=
 =?us-ascii?Q?H7BDGo3wBY2Ru/yaM3o3q1VQ6gRZF06FyBNa4qETp6qalWJcsifTfWerw4Ot?=
 =?us-ascii?Q?xYk7VOuBcLBxAN4OaRvxGn3DL9C+GufjFvB4q6BZhVh3p7q/WLocAEOGkuS3?=
 =?us-ascii?Q?IO0nUWfQ/ZY0on8OcSBuXXbh2ZLK1jp3DJWIgtzeHwkKbcVGDG4QMMpRwm6Q?=
 =?us-ascii?Q?g0DRuWCCqDfzXiVVmAGKChEOv//cY+KSMioLX+ULjSt9SDKA0GpXhcv49cqh?=
 =?us-ascii?Q?ZXM+Q/3eS2tQ7Dxvm6oTADVE2ukR46/+agq+RlahQII1Gp/1WtM1sTbb7TQ6?=
 =?us-ascii?Q?pXQ090XKhYMioWRoLDKcU7RlLo13dX4ZSKSSYdhZrgfG+gWW96B+2OUkv/TH?=
 =?us-ascii?Q?BNVZTDFWXbGfIy0KOWGYrLCTFq8U6xUuJhGiWKB8w0EZc4NNG0vrD9WFqsZc?=
 =?us-ascii?Q?PjjkA4rb1WZaB7MI3JKXG69w41P5Desnncbfo6HMeHEEsQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7450b203-f7d4-4a4a-1e06-08d984619a99
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 22:28:19.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nN6hZFGOll0NfB3g7ZE6n9zol6xYK2CEDJMfeWd36go/xQKKv9WiMxDXgpdPvA8q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 01:09:22PM +1000, David Gibson wrote:

> > The *admin* the one responsible to understand the groups, not the
> > applications. The admin has no idea what a group FD is - they should
> > be looking at the sysfs and seeing the iommu_group directories.
> 
> Not just the admin.  If an app is given two devices in the same group
> to use *both* it must understand that and act accordingly.

Yes, but this is true regardless of what the uAPI is, and for common
app cases where we have a single IO Page table for all devices the app
still doesn't need to care about groups since it can just assign all
devices to the same IO page table and everything works out just fine.

For instance qemu without a vIOMMU does not need to care about
groups. It opens a single iommufd, creates a single IO page table that
maps the guest physical space and assigns every device to that IO page
table. No issue.

Only if qemu is creating a vIOMMU does it need to start to look at the
groups and ensure that the group becomes visible to the guest OS. Here
the group fd doesn't really help anything

Jason


