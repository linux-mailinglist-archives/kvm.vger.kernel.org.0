Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4A41EDB7
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 14:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354433AbhJAMpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 08:45:11 -0400
Received: from mail-bn1nam07on2052.outbound.protection.outlook.com ([40.107.212.52]:12005
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353947AbhJAMpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 08:45:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPjKzokxFncJ3J8qrZ8SPCdtgUd9stIIRDf6khhSnuk2v6n61GV3M/bgy1TeDRJWK5Zzq4MllEcqlv7hBwizwvVvo5UCphXHvXsecPu0y+prrQFdSArJtruMh6gbG6SPeSX2HJUSS1EkGRRkMCw+lqbtk7tRqxOWhQaqmKsW/feEPpju8hndphaSeSanCzi4JIDJxG/TaskNHL1MB0Gu7BcK5VKdfvPfOvPy0Dvk2Ufxs2d/oeETZrYdO+QoFO7NKrk+cHoHkBUvWYfMoNvAe0J5clBa3JXB4YME5Ij1JtEvE92/Z166oCNobrDel8+smVJKCtlfLwPosktVfVjEKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T47JWvKdKniBPqWNE8dBIrTHX6kQ+847Sibkum+9UGo=;
 b=Zt1hNuaD7aOFoEs+1XvO8qyoWdyImb5mUPXNWnfpCkcVJft02gRse6iobSR9+YkrGoEV26xiqC5OZnBSsEhijamJjTxwSxzi/TE6Fag5c12Ul9Ww1fOs86WwOVPYTd0uwmlVde2Wrbs6JiZ2qBanuZnbQvyX0++NMUJwa2QVHMIJqrYjTH3QzykI3fp209Bj6jdahOauiQppS5+qXNabKVQK8Lb66BEkyDrsX58fdhrkPQyTjlSd19nZZWBgiriCpyZfNZLZWehN32VtvN6KCiXLxh8N5oblIUujRlyUygcfoiMJX8YMVuEmVBgb2NKzrOnAGVIEkaVHgVSLWPUnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T47JWvKdKniBPqWNE8dBIrTHX6kQ+847Sibkum+9UGo=;
 b=DE+5EJZvs7h0qpYhDWqYFIZGEzoSOkL2tjPBsWPm7pKddLx5JND/FqwAmkm579wYIVzetpZpR3otqPqEemaOVIizYrSF/ZhoPhK7cq/YnSHBvspKZIphMGSHsaanjqmaOopERb+vhCXeZXP/b5xOrQ5wv0CfY8QDvT904s9QvCtX4rP9tWs3955+v0iizKC5CFrQx1LiNWzQ+I8ol6nHl/FpmRjOGI2watJ1ZqjhaU5S34ODBGbl0pWINrdbPaOhtFiJ176WPGl5csSkdr6ExW13BMjXdF/bfK6qoJHTZW3rSAnEmyhoTF82bIMROrYLxHezpeBs8wDc1oQq5kTQyQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 12:43:23 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 12:43:23 +0000
Date:   Fri, 1 Oct 2021 09:43:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <20211001124322.GN964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
 <20210929122457.GP964074@nvidia.com>
 <YVUqpff7DUtTLYKx@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVUqpff7DUtTLYKx@yekko>
X-ClientProxiedBy: BL1PR13CA0159.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0159.namprd13.prod.outlook.com (2603:10b6:208:2bd::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Fri, 1 Oct 2021 12:43:23 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWHso-008PiH-Bj; Fri, 01 Oct 2021 09:43:22 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ea59dc0-dae7-4485-e743-08d984d90e4b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52560E180CAFD19B622BF8C1C2AB9@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtNUNyhN8L8xpHOJoit8ODNQFIZo8ySiH1b7vMR+u3SDZXXncmeNkUljuuNhN3PzidMMx/GoSsuSQsSL5O5PNWaIv8MbiDuKaiU/v0aD44FuDwP00w8LBtqVyDJ/Eo+Lyg0twz1QXJSE8wwoyIzOgYDU+dMHc1stURIOkenT0iH1WFJAmk1btBGqsxtZ73OQ38Y60uWKNHmas+BNhFO40oeDa4WH488uiTZn1FesCp74qfsAsTE5QA/WW+lK0I/guRRfHiidZnD05tZnn5R7HmvzA3z3ZhUgxO4Mt83kqAIjmy3+A7XgmGJXyD3P5papTFZC+cBX0IcA0N562S1aREVsIA8TNo/EjpRCYZ28oDuoMwdWHXFxQhB4504uzKI96nm+jiGTI4uM/x0aZaioWolTzEfhRxYBYv/Yaqb+cBh01ZD6/z/uY5trIZY2/Gt+p5vGJuqGT+sgE7Vlblj/47Zw+jI2oW6VjOpBrIpW37nm5FZ4JiDaLPh1rLkjbDn9qPYQD2JLM7xBkzwgzGERb9TLqW9uUEzyScACrQakEvuH8gtYhMIhPoRux+GV0+tLfhbWl90pwBK8MoxvcqFu5mpXbshcu2UD4xEaFHygLDtXpY5yc6bUNeSkjeNmC3jTwccDzEAUt7zVUh0irFd+aFf+q7BhJwIdWwGz392D9agrL05T4w6Yr3RjzEtbyXJbjIPZ3QIP1PwLuZnRVMbyOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(86362001)(426003)(36756003)(107886003)(8936002)(1076003)(33656002)(26005)(6916009)(5660300002)(2616005)(4326008)(9746002)(66946007)(66476007)(508600001)(66556008)(9786002)(7416002)(8676002)(38100700002)(2906002)(316002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UUX5mLGje05Mcjz9YJKtCXrb4objHRb4cqbbr2+7dPgM30rDCgAMQPlRWzQM?=
 =?us-ascii?Q?O+0f5u1iwg2gmgU6hDOukGVfImZmT19RML4ptRPzXcP/v5VQsm4dR96h/Z72?=
 =?us-ascii?Q?z+uTp/Bu4HcPTBeLrYA9BbvChlhuVn/rDnYCskaJYvz2M2KkHE+yrYyV7otP?=
 =?us-ascii?Q?+EU0YPUnhUYalnovqL4YvInK1MXz/jDcKO1mMuFYrlVj2s5SKFjKXMYPmnru?=
 =?us-ascii?Q?37UFdDcXxvMpwV/zCZkynJVC8P/Uup0YC3guK13ZZufyOj87b8IH/FOF3E3w?=
 =?us-ascii?Q?D3+i9qyf9T7XMi2qjuCszYBYp/zR24cRjzuuLuntmqsr8tmyZwu0FKKNUt5Q?=
 =?us-ascii?Q?VBjE+357/j3523JtBdrEZ6f4/D2RbqrwIv3X8giDHo6+DZjwkpQ6KYtJPZa0?=
 =?us-ascii?Q?vpwQH/OgtNwb9iThShjsdVQXxbon/DNW4ptuMFstG9dhqg24JYvx+woRKSoV?=
 =?us-ascii?Q?9LauWEn4W9BvTsN1S87mx9/FK9OB11xDegL/6VpwjeEjwt87XA0zr7Dph28T?=
 =?us-ascii?Q?LiBcVHwhTgaiT02LPVLH00ukXPOWTvM2PawoM4+MXSRU/0IrWfocA3x2NFbI?=
 =?us-ascii?Q?zDtHs0712C3pnk0D2/B0MdvYWlXoI9wSf5ylOISqSUUmAtk5/4LPE0MsZ/yC?=
 =?us-ascii?Q?KjhZkuSTvdtd0EgRdJs728JdZVLk4mXukliynkB4TMmItmcaxGg0wWSOustm?=
 =?us-ascii?Q?tSpqPPgQ3AnE3d5ubo9iqSntzOYO2v7m9F/kb4tDO1axOGz4w+3nQMjO1EzS?=
 =?us-ascii?Q?pR+meNX0gVBXatV3b52uP3TEzIRGL06ux7nwGdTNmc8IAcu35BDrEGLBj0N/?=
 =?us-ascii?Q?OLLcRT+10aeF0kQB3jm8pSdCH9QtyM70T8xkoPLvd6wKrSmcMYN9kpug7/06?=
 =?us-ascii?Q?QnjKnnKJ6YtU3QBZxgSlf/IgCvWkQeZggLa1afVyM5dPoiSjBZQ0AyVcG6NE?=
 =?us-ascii?Q?FqcNjPbVpL7IZ+8IUdJ9NcdzOB9V30ihAK4dEMvHUiNi0ABeawbGl2jcg4pK?=
 =?us-ascii?Q?FumePUyGAQECLV5Qv6DJUdFV64N9QqwJ/F0otYaEDkL4MVRpfVPKPlCUdADs?=
 =?us-ascii?Q?dXg1MAd04WnUq01Muo51t/VADga01ln/F1ErnmLNAKB77XOBHUe7vWDxU7xa?=
 =?us-ascii?Q?k2zA9UB6C/8HxrE7A5Z16V4WZ/s3bnj8PddRFbY2vdSWa6tCZ+nU2M3qk71d?=
 =?us-ascii?Q?mNxh59BlMtl4PBLbtlSviP2B/OkCMVmTandBuuM15Od+MXGb+DjaT5vxmMoD?=
 =?us-ascii?Q?GassRVnyPZ3F8lJa2RidAjjSO+YZRM982yKi3dFambNOpg97ieOIwwC+KXct?=
 =?us-ascii?Q?IZtsShWwWkE79xaJyN+SkEQl1cx8cj6lOpTvkd5NbWMc5Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea59dc0-dae7-4485-e743-08d984d90e4b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 12:43:23.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOkSG1vYDotwECsZH3/UOdgBQEC28NIqILAa97/hMdicIGPw/qG0bZdmuzRYwc44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 01:10:29PM +1000, David Gibson wrote:
> On Wed, Sep 29, 2021 at 09:24:57AM -0300, Jason Gunthorpe wrote:
> 65;6402;1c> On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:
> > 
> > > > +struct iommufd_device {
> > > > +	unsigned int id;
> > > > +	struct iommufd_ctx *ictx;
> > > > +	struct device *dev; /* always be the physical device */
> > > > +	u64 dev_cookie;
> > > 
> > > Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
> > > unique, couldn't you just use the cookie directly as the index into
> > > the xarray?
> > 
> > ID is the kernel value in the xarray - xarray is much more efficient &
> > safe with small kernel controlled values.
> > 
> > dev_cookie is a user assigned value that may not be unique. It's
> > purpose is to allow userspace to receive and event and go back to its
> > structure. Most likely userspace will store a pointer here, but it is
> > also possible userspace could not use it.
> > 
> > It is a pretty normal pattern
> 
> Hm, ok.  Could you point me at an example?

For instance user_data vs fd in io_uring

RDMA has many similar examples.

More or less anytime you want to allow the kernel to async retun some
information providing a 64 bit user_data lets userspace have an easier
time to deal with it.

Jason 


