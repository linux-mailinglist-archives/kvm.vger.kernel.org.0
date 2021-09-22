Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C592141544E
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238588AbhIVX6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:58:14 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:24672
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238573AbhIVX6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:58:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar3stCrzUjodqsOSg7xrBya+04Y8HuhF5LJL+Oldi54KGxI52XtHM4uT3xEBXEIsHjxjXnNF0hYczJpVo0Q63sMxtlVfRzE5NMf6ZLpQHBScCsP6ggJqaW+nCGlBHueE1nVmPD15DHawzA4/AEeYB2sT8+JNeHttCJSECSKYfsgknr4EMjsUkd3kTEYRgi2p/iwhyEowIpUMW5Oa9R+EwnL+UArJfXE5XLRxVANjiL7nLP7t9GIr7e0NDxjPvU96iJ1c7AvYocwl+bhSUZdMjd88u3B3Idq+chqmDE4lDKoqsmNJD0LIcw/4auD7pLoBmpsTJ7P8FCmqss6rW+Xa0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KxqUSrK0Cdw6mo37oQXNxDaLOv+2Zg4QylH0ryRBLjQ=;
 b=OL/T8sCcsT0hs4zGhi6nxnbIiGERYZ9tjIo4pCe+yGVWe+s2noDJbQkpipc7XyywvQLT2f4IAvRucADYb7PSecQA3+9JXkJrDIWicFC1oLeWemIefYKBfxhGGzzb3PaqtNhVO3FfVKyGAnFE5H9C12dWtu4clNiHabpnhzDhMHMfGwcSg6u3fgfHIyy4U/xKp1Sy3yybH8Kqh5tLN18jUgWs2ZvuM6jYo8osoSWCyeiCLgnoijXGKPm6tnVXSVOXv7Id0Q31m8qKevSiCbu+Ficb51NHXuYmInjgkTHdEThjbQqsZoXUU9mYO0bzX5vaw2vweCjIpjLqz7dysQKg3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxqUSrK0Cdw6mo37oQXNxDaLOv+2Zg4QylH0ryRBLjQ=;
 b=Eu1JWfXTGkI3fHgd6XbHwi6aFigFzqocxkQOgmBlFFp0McTcbJgqYiDq2tPfAb34mk2Rzrcm/8Idn1ocaqksSR4y9cO70FL+0sW9UbgPIEcE/J9sJjQhcLwRj4iS3rfpOldlP+hYvPNoZH0h6cMz7rQ921S1ZXmVyXeJSkFFo0F6aITmXDg93EZq/lX1SEiz51ReXYTMaunyJ8wHBRO5z6fl8A+d/XjqVfWn6xONbx73mz8v8Pj0ko/MQr1V1Ou3TnLSjIv4XGNy5VXdCDVllXX2bAh0dNnFH+rvIo2CK+OlwEUWHuSmApQSISPYPaBCQZNSVoLD9F1UfQiG4RjClw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 22 Sep
 2021 23:56:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 23:56:41 +0000
Date:   Wed, 22 Sep 2021 20:56:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <20210922235639.GD964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005337.GC327412@nvidia.com>
 <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922122252.GG327412@nvidia.com>
 <20210922141036.5cd46b2b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922141036.5cd46b2b.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:208:236::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0060.namprd05.prod.outlook.com (2603:10b6:208:236::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Wed, 22 Sep 2021 23:56:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTC6R-004BtJ-SH; Wed, 22 Sep 2021 20:56:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c637aac-70e6-4222-04b3-08d97e249f73
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5111A8FF9636DBF0F49BA619C2A29@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DECkup0em7oeXHsyd9dCCSH9notbGblNMR9gcX3xim3n8TGmeFwrVSQRLdLdV1QZsbZcwCPy41QlxwPXA9g+9v5aiRBZC4B/38eKGeRkvysQ3AHJc2MRqcxwksbLDvLtAxyyMLirH9QuE2FPbc5TmpB330Zv1KMnHt2HwtUnjlwZHDuL999KAsqqU2WCW18x+EXRos/XTweltNaaxr0jFCdDGEigMOAgupQDBd1A5u8urLdLSluVT3DRNRBMO8zjLifIN3fMrQF4/StsCXs631eakD22Zt0juGu4k4emHv/Zru9XhZd+08vcxG1uIWvEj+/Ja3TM3BIeX41GpUocgGnFZ5f1rw5Qr9h+wF5BoSePLCYgiUwUstJgD2WxdeeSW6Qo62RG509E4QZFpXVLFSy4qoVgKyMP5v5P4MHb4VIraEqSkGjjij9qKTbrYV47ahfqep0TJkLyoeOJdchYdwKZwOXE4NCsAE7h52CxK+83VkotmWS1wosBMuOT7+8fAJdtYbd75+kvZq83CXmvyiyfNYlTKyjWQW4SJEuK1gE8+//7lFYjVtX0Kg8Ohs5pa7jDHPYZfnh12ko2hOqeOkCyiMVZ2D+HI/aJkmfr1op1AlOJqCzDhyyYhyBAaaxtP5zlgxXgCPPmXffHdPcl+0IRwvgcKcAhkytlXiqjLkmdwlvJ6o1ZzP8HySpFMnxs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(36756003)(6916009)(4326008)(2906002)(316002)(54906003)(5660300002)(33656002)(66946007)(66476007)(107886003)(8676002)(26005)(508600001)(83380400001)(1076003)(7416002)(2616005)(426003)(86362001)(8936002)(38100700002)(186003)(4744005)(9786002)(9746002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sDHllDH0m7zHp/Du6dxGTs3u1tPA36EWrwdIYaipRkdI9JRAm27lTq8eUufR?=
 =?us-ascii?Q?pz08wxGjQXuEbtIJkrlL1yxlvMbjbEwu0K7rzurBjxOA9B0f2c+22gOh6+9d?=
 =?us-ascii?Q?WOG6ugpjyQbud3pmqZDhKYQRpmXxvFrcEuRKkH2dXl8iDjAmcGrsyvkCQUXE?=
 =?us-ascii?Q?ApjrDVqLkaqW4QJGvM9dBGf86wfwjVozidCMnjY+rGBfDbeEZ/THFLwHlkRV?=
 =?us-ascii?Q?WEJPmk1b73Lqv613/HZIrC/SfaVf+NRRvooh+2VCKSlnmSz9POxWLwKlplK4?=
 =?us-ascii?Q?6/QYymnCgELZun6xfqCg6hQ8HxIY77aZ7e/+kDgxGz9b1jfWowNDEpc3M8Dz?=
 =?us-ascii?Q?xSsUIcJlylrfIwl35C8ExJdhrGRX3w3J4iak/OoJpmflrqAN40LG4EGYinDJ?=
 =?us-ascii?Q?BO2sWEi5XEEmmPFnZjxTrgTTb/01m98xe1vcwVucnmZPmiuxEtjr4QcLpdBW?=
 =?us-ascii?Q?vMSfHv/pIPKWNcX62l6wpN4qZdjJOTrVUhLndO49VPDF1M6KJTprTC814wvY?=
 =?us-ascii?Q?ZEFKTKF0n5zh3MCksNYfSqaTzd4eMF8u622GmbXttxZpCiL48RfBBsLDxHWH?=
 =?us-ascii?Q?i3VOpDOjlIGOGtdzGy46cL6/6RVPXgL6nNtUrw/tA9IXhvEvfQjsi+0Airf2?=
 =?us-ascii?Q?l7B+u0tNElOmv3KJahuZF+YoSYQXa5mjIFmemOV0oAR8gcD7GD789lHxt2tq?=
 =?us-ascii?Q?V50Yw11yrlKWZFz7jKnRvRf7wCt3nhkOSPmWk1xVZdZor3BVAYpYY2YnXVhC?=
 =?us-ascii?Q?ZgaT3CZ2vckNbNY1j+mOD9dIfuSPMBBUqF2eubAmn7lZIXeZL+oI4veG6wuC?=
 =?us-ascii?Q?TVHy+m6R9oGYwsTHd/8KZNxZDCzhd3oFc9Ye4Qqp8oIxuOAP9nY3+PklbuQh?=
 =?us-ascii?Q?BRO6gYzW2JMmIrMIE+Ad4QiljFP39HHqx+6VoL8+hXoS3fjodoFs1G+EWiDg?=
 =?us-ascii?Q?O9o3F30CDaEbIeHXiefgjLEGUDAmYP7O1CFsPAas299K1zs/4JQ6TyiaS4d4?=
 =?us-ascii?Q?PwS4DgeieceU69+TPFXP1Xqg4xb2h8EZcIg/9aCHY7skq7oI7mWd49ZyQHXh?=
 =?us-ascii?Q?5k/JzXjSQVk819stneO3qAyIZZLRYaw0Mpw9H69e7SCDim0rtGPqPOHhbxu6?=
 =?us-ascii?Q?1KFtGqC+A3eNY2jNOcivADwbIrdaiCRlhWhe604dr1qSJr73iuEJmzANp3Ou?=
 =?us-ascii?Q?iITlP1TKdxDP7obm9am4I8uwZpyUvqUAQFEgEKqofx+QIhki0YPYS1dIhqlY?=
 =?us-ascii?Q?sWawujo1wfh4z+6vvP1ioD/iNFAF5KhRNtd4sZKhprOAtw7EfAkKjoU4khRS?=
 =?us-ascii?Q?iUO3DfxN5iaEbcYW7+Z8JZqM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c637aac-70e6-4222-04b3-08d97e249f73
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 23:56:41.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKTMOFvQhc9PbnzV4ELroYIBAsvOndNfxxnooMbdpnYOUEYMMzHo/Hmd6uZmz9lV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 02:10:36PM -0600, Alex Williamson wrote:

> But why would we create vfio device interface files at all if they
> can't work?  I'm not really on board with creating a try-and-fail
> interface for a mechanism that cannot work for a given device.  The
> existence of the device interface should indicate that it's supported.

I'm a little worried about adding a struct device to vfio_device and
then making it optional.. That is a really weird situation.

I suppose you could create the sysfs presence in the struct device but
not create a cdev.

However, if we ever want to use the device fd for something else, like
querying the device driver capabilities or mode, (ie clean the
driver_api thing wrongly placed in mdev sysfs for instance), we are
blocked as the uAPI will be cdev == must support iommufd..

Jason
