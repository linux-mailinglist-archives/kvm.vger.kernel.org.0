Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1F341C4C8
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343789AbhI2MdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:33:02 -0400
Received: from mail-dm6nam08on2058.outbound.protection.outlook.com ([40.107.102.58]:39681
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343628AbhI2MdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:33:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgWpw2tFxOEqvcJiRoQOl7Svoult/1dvR62/DMr/4u/ZSMyJHyZ6oKsQfU5b4A62gxdcnyySKhLElRP/k8ZZRBfcKgiYM/Q6+buOIOc5t5RTQqQmaDZBkoX5hExyqh8f2KBS75tQRJecJBw+TfsEQZ0EQ6y0eRNt/KMkhm/3psAsVjefR00f4rvxqYyG4XiyIFWBmuoi4/gSmJI9o5551Em2Wr6KSm4xS7uLerZzJHQ1atWFqBY9+Hp1udsHyEwWU9TkFcFkVkWy7y+iayQMvMHOkGbJageg7S6MvS1e/UysYV/I3VLMbqxi+/3uWPraO91Xnlfm7uLmFr83wUQTQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yJdC3kvDR4LVeVqs8inz+w4UUzH8FxZdZ9+fCMTaCaQ=;
 b=jJfuHa9CQ9kqcPXPgVuVTq+pnU4cHiwKthkVq559fzu3BFQUT1LCmL6iv6tqBaM5WvLWdIHQwbKza5HCJtfAHkpnV2KeskV6nbPLMaQOiR1KfsE73/k+rMveak7Efsu6mk9VktrQyEg7Hcc/LFPd1DwD6DkQHhXLO96iY6uPO9s7KjjlTHIyvUFFdukWJF+YCcFWlg3KMn87WXq5Y9pwuvbTDEb9oHndJiUq8qJnoSG6AT8SA0oTp4ufPxawDjBkUlI7JWvbBQnctrolW6Kd1tIy11ovWlcomKhDmp9ZFz0n+8n8HyIBf4KwyEmfekSMrPNk0mDWAUgZI27tH1OWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJdC3kvDR4LVeVqs8inz+w4UUzH8FxZdZ9+fCMTaCaQ=;
 b=dqNA7Z36qnUelY/lBi8U/F/+6CZ/eF15RkjjvmUhJTAVLATIuK3B7LkV1ipjGBnMkeon3Ysy5Qy8ldNZphCDJDo5dIlPDkRIpF3EzIg9oJfRpnZprWOwTVQX8DMYgtXJ8Tl42J+ALNyiNJF3x6Zv74RT5mIfqn4ZoQshoByCyBaLTtp2N7iYXwzWGO0d1+j1b4SCqvSVSEsySFTWWQovsGTIRZfRwb4B4+HBH3HUvwspngQxfKEaBiHpOeXxod9P+0amziWl8drjdGB0h8/fLX80EbGm9nf9pC/gIQUyd0R9WaMbRU/5Lw7yAKvY8IFXTAGVmH5Otv+g2K0VQHQhLw==
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 12:31:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 12:31:19 +0000
Date:   Wed, 29 Sep 2021 09:31:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: Re: [RFC 17/20] iommu/iommufd: Report iova range to userspace
Message-ID: <20210929123118.GR964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-18-yi.l.liu@intel.com>
 <YUtCYZI3oQcwKrUh@myrica>
 <PH0PR11MB56580CB47CA2CF17C86CD0D0C3A99@PH0PR11MB5658.namprd11.prod.outlook.com>
 <YVRXHDwROV2ASnVJ@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVRXHDwROV2ASnVJ@myrica>
X-ClientProxiedBy: BL0PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:208:2d::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0031.namprd03.prod.outlook.com (2603:10b6:208:2d::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 12:31:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVYk2-007Ykt-FM; Wed, 29 Sep 2021 09:31:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 253fd489-8e72-410c-cbac-08d983450a03
X-MS-TrafficTypeDiagnostic: BL1PR12MB5377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53771574423B51F9F0B116BDC2A99@BL1PR12MB5377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42eloFLqDSJBidcWd3U7NjgQNsj+E0ZAaM9MhcTNvLa4k6tauVh4Wyp4sViZwBG6rFR3jY8WZhwVtZkznT7qvVx9RtQoD8kVz8oLtwC2Z5iK7q/xizgJPNv0RgNYsQPzUnt2NNbCgBkVTShly/kD1h1x3+U7sULlIZNYdxrrh4VnKSyUA2hfptpatMim85/Nnvlj6TUl8RAMVsVXHT7cia14YI8Dj4vsYAvOgz5phwnDEviUSuhNP1pQArazU2zaw5GiE9MtMLzbJHU5buxQMj1dicm++uRCT7p2C2s+3AVSOjCrhc62dxPGPob7Bbg3rfoJylMA2x66uKYYGICOSXaJFAzeOGqEYftdXWkKhfTYM8IQuBMv11UstwMntAkox2R2+8nS0ymibpkS6xcNGU6mppV8yR4vzpws4VwYG/sRrxqZj/ZyVarf5VOI7+v191/3ncucejZjLQ81RHn3Qowx8zUiGQZZYW57FX2Pwc0YoeI+urB+MVnyeWOFP6N622VLC5DXFd4oq5X+wXfGtaiKidxNOLzwR43xmjf4ZCbyh1rCZl6+O86pMXeWZoQvXYhw9qqA7mbQrY0t0sguKt9nS1RhuDH8znF6/bpBkz11yLPA1TsungwB0/A141ab6DQ6fRhoeXOnpunbriJ7BeN1+kK9XtABniiAcN9Kqmlta2R76WVR38HIGqL0xWz9w+97OYmo5sBagqlny7W+8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(38100700002)(54906003)(1076003)(6916009)(8936002)(508600001)(66556008)(426003)(36756003)(5660300002)(4326008)(2906002)(4744005)(8676002)(107886003)(66946007)(33656002)(66476007)(9746002)(86362001)(186003)(2616005)(26005)(316002)(9786002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?duv435sLnUY6rosf3QqF3X3GsMj7f5i1ybrpPWyEpsnPhbmwaG8PJGt3mNJq?=
 =?us-ascii?Q?kjiGV60jRjk1W+eo1qMPhSdfukwTWs29AV17Q6lG5y8E3vXiGfzE0dmPi+eL?=
 =?us-ascii?Q?HRdh2j7UmDeR1WjqMdlsv5cfLV5a6nntOMr3n7Lkxk/btDt8XSuZc7DGEqbq?=
 =?us-ascii?Q?XjyCStRCLrvzXVIox82PdQP3BK4MEgVUxxeoSzza0sc952KSQRU0tqoESlSz?=
 =?us-ascii?Q?OTj+jb+BzENna+rCD1JCcsf2tLuGhmyA3q4qUXgcPPe9FlBCV0IwK3dGL3UJ?=
 =?us-ascii?Q?V2pMQdZK8ubAJjVxW8uK8t7bvkx3349f5LQUUQ1E67AVbWKAU5hgH6JLbPUI?=
 =?us-ascii?Q?kbhyBGd/Y1WmPscasidDNGYVijYHMu97nkswDwUNZ6PxG/4oVUDTzhsiJsdg?=
 =?us-ascii?Q?gj6+9Jsd8F1Lxhxe1fhliB9jkDDntV7GV3oxLGvr/Pxlk6c6NQ6Do/OdmyX0?=
 =?us-ascii?Q?J2HFtL82Ur/3lLB1ErDdSJ30OBnKA8JqcKedRKzboud9IFv0En+g0r0FCo6W?=
 =?us-ascii?Q?TRDRCiYbzjJJFEfzYl1ELb6QKuteb8n1vV7tPaKOfltDt7/sKcAlnEfBYHLr?=
 =?us-ascii?Q?w2e0QaLlXOevMZBEH1ELHi4jewC2h6RQJMaM2oDfAI8xu+AzbqgALNqh2K3/?=
 =?us-ascii?Q?4VxTtLIMrVQJYXGmQnEiNtfw/EPaqbpSFZUstsD/h6syWD+8XE4YwTvDRpRM?=
 =?us-ascii?Q?qlLIUVNjQDaqrXM1iHXPDXPiS6EnMagDKYm2sibVH38BiwFxj0khwUgiTHTD?=
 =?us-ascii?Q?oTytaHpYICdjXfNpEOAAlqODZDZqpNPCc+2LT/EaGy8XKfjJLpD3pbn61K+/?=
 =?us-ascii?Q?QBXd2yF2ewL2xZj/yOjGLm1VEQNuR83fDEurinUgj3ASNJDFaGuwJcM8rN6g?=
 =?us-ascii?Q?bdBRqT5MTidTgXmx1ql6bXKbvov6S+5P1pRV5IQfK+rc9HJGXxPrywKeQ/PZ?=
 =?us-ascii?Q?wqeXl3tkfEJJuqqnRYAwB1T5sXLPXyA5yivTyQkep32bSZKFvWip+fONx6rB?=
 =?us-ascii?Q?bdHeHl2/lxHdp+twH0wEiROvwQEbreovaLOGLfLeC/0ruJemvEONqS/ssG49?=
 =?us-ascii?Q?jHluoLF0nYgETRzOjiopKTafA1qmDNvzl13XhDv4TCFmTP8YAbQ39Yco9+44?=
 =?us-ascii?Q?bBtAI3dC5jGJ5sQUsfamEuIGOFJNbQkZah6jjXhHR6VTJAFJ2TwNLRYDdAQP?=
 =?us-ascii?Q?tvOwZAiXHx0qaDcCIJj89qs5MeYx7NInuCmFdvHAjAddJ0FOXmjy75GEJV/z?=
 =?us-ascii?Q?lUXIdYHitCLiXTytAQTuGqxyKTfGNU9fB1Pkppie3TH8ow/taeWeJr+McYvM?=
 =?us-ascii?Q?vq6sdI9z5t4Y/0Qm2v+XT7WK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253fd489-8e72-410c-cbac-08d983450a03
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 12:31:19.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhQOR/jKrdkFpp8HyCi2zGnF5B/KZXfuzyZBoFNZLseiSo4sODpDZ8VKgcmlu8O1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 01:07:56PM +0100, Jean-Philippe Brucker wrote:

> Yes, so the guest knows the size of GPA it can write into the page table.
> For Arm SMMU the GPA size is determined by both the SMMU implementation
> and the host kernel configuration. But maybe that could also be
> vendor-specific, if other architectures don't need to communicate it. 

I think there should be a dedicated query to return HW specific
parmaters for a user page table format. Somehow I think there will be
a lot of these.

So 'user page table format arm smmu v1' can be queried to return its
own unique struct that has everything needed to operate that format of
page table.

Userspace already needs to know how to form that specific HW PTEs,
so processing a HW specific query is not a problem.

Jason
