Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FDD42EF83
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhJOLUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:20:18 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:3296
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238415AbhJOLUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:20:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/BymUebEhaZHepmaSzBeakel9YQEzjfLrizcx3AEAd9dF7TAgY7Ra/eW1S0vTZrqBd9brAGrjDyzfZF2jp5J+plbMlO5mHnZFns1qdeW2xZydymtpHqbJ4sUJMpAokLtv8nyKN/tnvFJiF2BkoxxdlGZQeSYIv96YiSsW/oGmRh5IHrESRVn9r1M/9Inr1OmMNLhBl74ha8Xc9OAI3asdcjcJhUSactoA/uKhjHr/2mElhbxWwwCWNoR6P4a3deAbn328ITnTYFl5gBPTDr7tR/7ZUahWmXQFZz/EC3+j0xGMTNVQq1oaXgPk4cXIIxQTULK8hhehk6VIALH0+gow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AupasI5AY6VppSakVLIMBckMbjaNSQYjbtlM32jDS7A=;
 b=OLAMFEISnbi+lZwroaqlCywwkUwI+ogbsss3LDpAqAn59cfgi4jbt7xaZ7ua5Gv8TDGydJ2gmm+SJo3z/SQOU2DyhDiZlufu1/64lPOaMD+BhYylz30XoN3lzYtuvbm5vjk9eDDD8KOjz1bq9w6zCTWMmq95jTX4XZd6H7l4NRfJheV8Vm2VKgdKTcYnaRTrDr4oN5PIa4bNKl76dZKMQIw+wI7FIYBMc4l60EoefGNmATALBu/L9gOg7bfgliZpFaq2zvVXTqzTxI6RhaPnmFFop9JYuhT2vpSLNGgcxp+I+24JpQW106Y6iaizD3QGNUGhuL/zw4nT5lBQb9XvXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AupasI5AY6VppSakVLIMBckMbjaNSQYjbtlM32jDS7A=;
 b=GakX9oho9jzcqkoFM5eDyzLyvIe9Nhk7WiOwRv2kFY28PfdLdlVvKJKQE738Rdev1DmbX1Md9lJh85Dw6x66SqKx53WnLesdTM1uLzQHE1NLX3VtCAfY4CZMzcW0QbAeC0zxvG7BG8yhUP4Y/4/c+FB23JJAcXfIZ9inKq374goIXD441ck2xanauWCuqHFRvVYCMzOsG/pCoFYp/swG77i6Oo4/JwwYdYyiLmOKKHVV1k+cXTUbXpO65cZhczmL9A/X0GOGbBNEmMLcUjT/Je+vH42wzMNti5ixRs+GvpqyMx8QwrgIii2bWWhJtWIaY38+KQJPGj9902FpJzNKzw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:18:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:18:08 +0000
Date:   Fri, 15 Oct 2021 08:18:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20211015111807.GD2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB56583356619B3ECC23AB1BA8C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:208:239::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR08CA0021.namprd08.prod.outlook.com (2603:10b6:208:239::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Fri, 15 Oct 2021 11:18:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLDz-00FHz1-8R; Fri, 15 Oct 2021 08:18:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5720bac3-cac7-4cf8-e547-08d98fcd7742
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53494A4664A55CDC4FA0BAE1C2B99@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+3Szu0I3dvI/++CGCsUdb3VtvOBBZuomE4Xk+6UGZHJuIJGS6lB7bWIpNKw7tSF9zzxkug3akHQKDE2EEk8WVibbrbqwxQX+vwHdxZVVfpCdhqQiHhnefVJJVhs2l8zGAyiR7op4dCW0qp+UW7mNjV9yJ7EUV2mAQ6GMyR/byF7TiGJdwO7evRlEK4uVf83oDkLLLyUSd/W5yiIuvcdRtLq1EI+odxeURk9nw2XKbDQBo1sTJ/TK5MVDXNbPRAzodRKMgVPr2y9htcisXD3lzHNUHPoBQyayHboljUKwpyimLDpqdj71Zii3mJJAVdOIIESKM80374JZwNVFEVXmhiGGH5Rgnp5XOQRGflAPzoiT+4k7dyp6jQRBjCTHy+/WbfBai8t8hD6bZtSflK4R5vNCikQfI0qz1Nk/N28JZP6WZwjsmKuUnG3iqDr+drgXZFkLJya+qSqYoQVulJYqill9qhbWM3KH2YABL5iZIw89hvFuZB5RH9MeltCqC3z56zQaHw/MifDRMWZo8NAmjzsIqi9HixbA8OY/r8vKa+ZQ4GJ0Fiw/bJJCGHMjSHAFp7QZtL6YYVtQFj36WK/g5jX9vUSEwhx5CaXkOgNm/lzo888jF/f3HfvChMfwvpy9749EVGzntErrbDIBERAYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(4744005)(508600001)(86362001)(186003)(426003)(9786002)(2616005)(8936002)(38100700002)(9746002)(33656002)(107886003)(36756003)(2906002)(66476007)(66556008)(316002)(54906003)(26005)(66946007)(7416002)(1076003)(8676002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T0DI09TfZwZvzBrEpCl6r9+Nk5G7Z5FYgcsepfeIeL+czHPm3d54aLTrm5px?=
 =?us-ascii?Q?QKQ1OaDiRGBiZZxOZ8irXrGcVxzx2tYpV02m9+FXKWKCMeeq6lABWIUlXR2e?=
 =?us-ascii?Q?dS3EV2LBimefbkpuyPMrQd0fHE5KucL0rIlNvY5cOVNG33rJw+trFFgJhHjk?=
 =?us-ascii?Q?3RG3YPJs/DqLwfriDII5KfsYCfeF9XNfoTGkIkk9j14Emc0H+M2Wi6ihKwrB?=
 =?us-ascii?Q?5suSzjpAib4os6RHB9+BBSL6YCxuHq8Qc0G2lEzBt3xozR1ayrEgZDCXHrIV?=
 =?us-ascii?Q?LQ1cTbhrWq/SYgfUzOnIC7drd4CB04PJyxkSjKoQfj5mL/DZ5A+9C2AH3iHr?=
 =?us-ascii?Q?i/7nwuO+uqjq+5P2xofgKaVaIV/cxBoX4Mjf3qtRnxaipf96hSSBF3AasNgc?=
 =?us-ascii?Q?5szp60/3nO64zwLSCGR5/H/o8zbsWLmtV4bDzYICbJYeYlSnt2JNbuch50ip?=
 =?us-ascii?Q?qYF/RP+j+FzunX+BIUZdzT5MtKixGGar4vhcrhjUaf9iZR41motm3l368SL7?=
 =?us-ascii?Q?ljO/c7W4vaF1lcZXnDED9ZVHDBRnxttp7igYky765W8FMS9iiF0FinRKtdnK?=
 =?us-ascii?Q?KhnvE8HLHxRNpklQ+Fs6Cw5KwtG04aKGjbuYxeqT6IZ7dtIR4ybik+nznPf8?=
 =?us-ascii?Q?vHgE2TddeWCZwjQudyFxiSzJd5J7nHP6emc5YWARSSwRCXp+TBq86KlpUoe+?=
 =?us-ascii?Q?RHdHXy9THeXSaq9AjCN50I9VlHXzLkkCMHDPg5nag3BfXXfBG/o5y9spZWDd?=
 =?us-ascii?Q?cFQerSG6rC0GS4L8wX82LQDzJ/lIyuRtyBIf5ABtMpkMMAoXGJfzj2RYT7Q3?=
 =?us-ascii?Q?R3rpyxzBsDSsXDm0n9cOCpjdSVLq7ApLBVy2RKfRhZRIJWtV8Dhifph/WFkL?=
 =?us-ascii?Q?1YUWukck2cBYDSbtyJplzYLAqBgUW8VTyPGZXNPgZlQuF8UtrGf4G7v67uac?=
 =?us-ascii?Q?CxHQ4R9vtKWHwihuv10k/fdjLt1ZGzbcubiPrORfDvbWKWyhLo3WskMG1k8c?=
 =?us-ascii?Q?qskDPq2+UHF+mvFVN+juAs5q+sR7Ar6dABTlcyJtRfVlV/CLDCBdVtkse0J3?=
 =?us-ascii?Q?M8N/KqhfDwz8F+tdXLCXqdibFDtwmetMo5ob2PByML5OYqGDge2JJacGPRM+?=
 =?us-ascii?Q?mNzkP92wzuIM9n+iAVfwMcwqnO7+2RXcGlNnjOP2S3AYbwvFm7NrXIHRgkTk?=
 =?us-ascii?Q?wqDABVkxGUHUyetZN6g+asedNORyq30ce42zd9gfFBnOFAjZIMgugYQL18yR?=
 =?us-ascii?Q?D1mLQZY+CWNZFCVj7ZdeOfHPx0GmwfnrcX5HY3mZMvNfC6NzcaZuIz0O0bOG?=
 =?us-ascii?Q?uh+fD9v5bHnJwE4GRkkSrAcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5720bac3-cac7-4cf8-e547-08d98fcd7742
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:18:08.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtmhgUWmJcFuWeTlAMqnWaOnF7tfs5o6PZVKhc+kf9xRfZZ8QYk1EIiuG/s73h0W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 09:18:06AM +0000, Liu, Yi L wrote:

> >   Acquire from the xarray is
> >    rcu_lock()
> >    ioas = xa_load()
> >    if (ioas)
> >       if (down_read_trylock(&ioas->destroying_lock))
> 
> all good suggestions, will refine accordingly. Here destroying_lock is a
> rw_semaphore. right? Since down_read_trylock() accepts a rwsem.

Yes, you probably need a sleeping lock

Jason
