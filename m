Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5921341E39E
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345026AbhI3WGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:06:34 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:44289
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229644AbhI3WGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biBb4MV31vitCLQOM/6OY/5t5G4v6DLqzTmDowgQSXZWRX1RCpabY6C7pAioygXvdJy/uFeQJENylkuCykkdKlB+Lc+33FadFmWIqxKyy4DHC2rFJRNIUDuD/sARCiJJxqJDZGMir/lcEcesAUpCzinKA33G/MT0RQApvXg0sOHGV7K4030QLFoCr2snMjJRjtZ/GrSgT9BhUxVbsnqABZUqU6UF+wfFmsnhEA9sqnvTw6EeEt+NU58NtFs7Fv+59BhQbX6eu0jx1S6iq5eSqKjFyoVdGOWtB8znI66xadwlRv5b8Wthh9JbG+ltd4KCmd/QSehuNFq8KLKnNV1m1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfcxxNlGYqEXiUxdKX4+Uyx+9GZhHvQDWLhBVFEIiMA=;
 b=WhXRihRkkupa8ZQjQ9tNV8/Ev+cOl0X81mcDwZOhzW8MfmvtJFpWVsmrxLbtzr/W+BdyU9wd8D/AvZpxP3JvXa6KsHqxTjdtO8PxDDvxW1kqi6nj8kmCxn89zuZsgP0yaAQ3lKTORp7e5TfyDAYTXzCKFtiSVkACrviGJfOdJaXNzqS7u3I97NO2NHM98THrcfakTq1BfSL2Z+BaHRZIOVxPNnAQPWmxhwiSMDQMiKnVXqxi9Yjd+jMHvmXxGdC/3mdDJ/72squ6jDZoP5ZYnjcRW70o4rvRl6pk6JrcN9lMovFUBpV9GJ2I81ETNBIfI31+ORohTEJh4kNT5OKsoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfcxxNlGYqEXiUxdKX4+Uyx+9GZhHvQDWLhBVFEIiMA=;
 b=q8fJOCeGB5fBAvb03qyZ/TugM48Zg471hwNFvfBSkBnHiYtHZwrG/7aa2LT5qbUw5sv+vudQQ/mblJa3aSyA4oWkfgDfDW6AGaGcJrVVrk7a0+mfHLugrKpPeve57Bw4ULGotwwLiQ44TQ6hbyFAbRfW1FBl3I//q6WHxEhv6JcYFT9ecdu0fsjf0p3Re/aneNU6S1DH7DnL/QIosDu6NZPWGnEacdSLB/ZE8rcnVXVeLxKu4AIvA2DqZjDutoA5p5QLXlUzxldMmICcHiXUPBwDkFFh1KN3jIiiw4Bhgoc11bwrabB1u7TStYpLWdDjvVJ8LXrWRiVLbwAkuviOhQ==
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 22:04:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 22:04:48 +0000
Date:   Thu, 30 Sep 2021 19:04:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>, "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210930220446.GF964074@nvidia.com>
References: <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica>
 <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
 <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVWSaU4CHFHnwEA5@myrica>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVWSaU4CHFHnwEA5@myrica>
X-ClientProxiedBy: MN2PR16CA0033.namprd16.prod.outlook.com
 (2603:10b6:208:134::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0033.namprd16.prod.outlook.com (2603:10b6:208:134::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 22:04:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mW4AY-008DFG-QX; Thu, 30 Sep 2021 19:04:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61e97d8c-1f70-4266-bccb-08d9845e5162
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52067556F773897A0697AF6FC2AA9@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpVXYNji1HYsUj4x4+zbSWsqoD9i4OKrka17+wbqjLZTfk7uM8bvBjtBgQceeuEfesBPxc2KCy9vZo0ukeDXrs3seFCmqlbgOh9joyneIL7bVc1CjGEQ4hB+jqcJC9HYPncB7StbwQVmXUrzpzdNgQJbcZ/+8/C18TEHcCuQkmjBFmiuaqQokq4rqf6TX/FoH55w0Q8xU1j6GHb8dClm+A2kan2V8RgczX9zjl64ikFDbrPSArD1kHbEq51cv2BScFD/VofUsHnWXr1tMaz6mcQurGs13+H5KOSCEPgS2IQuyBHgiiNsmlRwJ3b53iJyw3f+/Ta15cU/Sft6p8pto+vjuHpeZ19r/zzj50NUwbjAThLMh0nYCjj0+veJG2/3VXNyG9MBUxPvk5vpy9140U2da2GJzVIsWJvD7W/i9MqbWdh2BI56IzOPX5Aia2qTLYKbyUfDtDOStOqtFM0dUdeBMQrSKXiyI7818HjHDWHQ1lu2X7mpyWANxRtqLftZZ4eE0A/zrNowjeswsDXEd2Fbr8FQhC1mEpbqh0zyGrAqutfa8DQHNZnY1F3N1xAIDZ0dHJSBC8nLspEdpQL2nBA3mtV4SHXpRowe6aMAhW1LkI0D7GBxFPh5p1EF9k9KXKSMnpNMDpqsiWk7YeAMXf9xD29CEe1+9B2F+pFt79luGPpiFPJ/cptjgiAg7MaI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(1076003)(426003)(316002)(6916009)(7416002)(5660300002)(2616005)(508600001)(83380400001)(86362001)(9746002)(9786002)(66556008)(66476007)(8936002)(38100700002)(36756003)(54906003)(33656002)(26005)(4326008)(66946007)(2906002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUvmr6mITBcCID8KCzovi1G1FApXao0FkVxMps/3ff/zPSKP7gjqYZ9patIz?=
 =?us-ascii?Q?26qUTttlTQ4HRvhuqhu4pR9q9Zc9gIBaGeZ4BgLIhBNPu6bb/hbVUEkV7C61?=
 =?us-ascii?Q?lvH/R0RoTgLfjz4vmCyMb45jb+6Uxxkm8W2YfTim8/G1uUyS6Ss8Rc2uvTf7?=
 =?us-ascii?Q?ZjvsbG01ZGGBH1y8ytnhEYT1P/jSvubwBwZ9xaUICKU2McbGgaJykQKzIqGQ?=
 =?us-ascii?Q?SIbCCoTDQtrV6d5eJw3I5CSmNEEy6BtR/qCRz+eisb6KiDwJU+ObBeEpAEcC?=
 =?us-ascii?Q?tJQSYbt+OZgNdV1YNo2FypaoyeLoHrlsP3YX7bsDLszqU23isGADmJsmw4U7?=
 =?us-ascii?Q?C/8E+55CUcIX09nZY/WtdZyS+5Ms7fdRXZKi4/+I/ijFrTEL1vLz/hCfBAva?=
 =?us-ascii?Q?Fri9Wda9M5tQn+NfelIGFpeKuniUZQfgS1vM9SLJUPdAGXj5X5459c9LelQl?=
 =?us-ascii?Q?vfIiifrz8YzZWMZ5CEyUrWr5KvMABntgEnSJdYOvQ2KPuHT8uWnvMMGLTJby?=
 =?us-ascii?Q?roIGLGKXjNFUZMT1eJnkDjh7c3RugJi6qpopR4k6RRuRA/bXUymWoUF2gXQJ?=
 =?us-ascii?Q?95ufCH0c7UgPD68Lhw5oHtJmk9wYK17SLjnxY84FOHWSaGqB87c/7yyIAlCI?=
 =?us-ascii?Q?wX0ZUj5zwE3hHVWZSqmif8NEjEKqG3Xzhxxr1moJrOvhCe7A4N1h+je4cbts?=
 =?us-ascii?Q?ckpggSqTwBZ6I9IkO+sEpTvze1++UKg0KNlcczEwE8NOw4BZq5/sKxPSn5ln?=
 =?us-ascii?Q?qEFFTW7Y5oU4IOQjq6jtRkl4xCmyJZiTLqLbWUZ5Qm2Bf/PrQoMvw39SNQkc?=
 =?us-ascii?Q?l8ta8sgURoXL2tULbElI7hV+pWIscwCd1KryJCPxGci1K7XyUbbvAwe2iInm?=
 =?us-ascii?Q?v4i1HNYYgOh63XiGBGXjrhVbFFk5+zd3dtrAOnAgk6haLYI9Qqpc+sZ+gB1T?=
 =?us-ascii?Q?fsoBa6eUUrO+koNiQncMqYyS5U/rdaDguoFN8rz3cpT1YPMb+jsfL/eLLE0S?=
 =?us-ascii?Q?F60qquXKHieKBD1i9Ij7/a8ndkPRuksUr5eQiFe5Mc2Y06gRTYCWMIj7hwWr?=
 =?us-ascii?Q?Ws0tnkECfH0kqgRHru42UcO86ZnC5LzRAtsaPTD8TKavgxB8K7x8S70YXS1G?=
 =?us-ascii?Q?QCqNJwSEJO8S89LVSA5tR1eySZs/goVxy4PTWDmtUHJOhauMbPyJ1/nG8N3x?=
 =?us-ascii?Q?n1ZLK6VrKTFiUS+eMfGNCns5V8gg/P2eCKqqSyxwagNCDQeNlAlGDeVt0AXx?=
 =?us-ascii?Q?1ydiqVJkqaWC2Sm1Lx4lPAbmPRhfDduXJ3pC+jl958LRkwxOMtoMerO0yD5d?=
 =?us-ascii?Q?I1WUSIFiWt6LztuKYEPKKckI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e97d8c-1f70-4266-bccb-08d9845e5162
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 22:04:48.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSkygK45tOONcnIeYWgKNt9ZE4UNQbDkxs+Gc7qSCWwqSzIFF/Xjk2WQyMG8Bohj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021 at 11:33:13AM +0100, Jean-Philippe Brucker wrote:
> On Thu, Sep 30, 2021 at 08:30:42AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Wednesday, September 29, 2021 8:37 PM
> > > 
> > > On Wed, Sep 29, 2021 at 08:48:28AM +0000, Tian, Kevin wrote:
> > > 
> > > > ARM:
> > > >     - set to snoop format if IOMMU_CACHE
> > > >     - set to nonsnoop format if !IOMMU_CACHE
> > > > (in both cases TLP snoop bit is ignored?)
> > > 
> > > Where do you see this? I couldn't even find this functionality in the
> > > ARM HW manual??
> > 
> > Honestly speaking I'm getting confused by the complex attribute
> > transformation control (default, replace, combine, input, output, etc.)
> > in SMMU manual. Above was my impression after last check, but now
> > I cannot find necessary info to build the same picture (except below 
> > code). :/
> > 
> > > 
> > > What I saw is ARM linking the IOMMU_CACHE to a IO PTE bit that causes
> > > the cache coherence to be disabled, which is not ignoring no snoop.
> > 
> > My impression was that snoop is one way of implementing cache
> > coherency and now since the PTE can explicitly specify cache coherency 
> > like below:
> > 
> >                 else if (prot & IOMMU_CACHE)
> >                         pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
> >                 else
> >                         pte |= ARM_LPAE_PTE_MEMATTR_NC;
> > 
> > This setting in concept overrides the snoop attribute from the device thus
> > make it sort of ignored?
> 
> To make sure we're talking about the same thing: "the snoop attribute from
> the device" is the "No snoop" attribute in the PCI TLP, right?
> 
> The PTE flags define whether the memory access is cache-coherent or not.
> * WB is cacheable (short for write-back cacheable. Doesn't matter here
>   what OI or RWA mean.)
> * NC is non-cacheable.
> 
>          | Normal PCI access | No_snoop PCI access
>   PTE WB | Cacheable         | Non-cacheable
>   PTE NC | Non-cacheable     | Non-cacheable
> 
> Cacheable memory access participate in cache coherency. Non-cacheable
> accesses go directly to memory, do not cause cache allocation.

This table is what I was thinking after reading through the ARM docs.

> On Arm cache coherency is configured through PTE attributes. I don't think
> PCI No_snoop should be used because it's not necessarily supported
> throughout the system and, as far as I understand, software can't discover
> whether it is.

The usage of no-snoop is a behavior of a device. A generic PCI driver
should be able to program the device to generate no-snoop TLPs and
ideally rely on an arch specific API in the OS to trigger the required
cache maintenance.

It doesn't make much sense for a portable driver to rely on a
non-portable IO PTE flag to control coherency, since that is not a
standards based approach.

That said, Linux doesn't have a generic DMA API to support
no-snoop. The few GPUs drivers that use this stuff just hardwired
wbsync on Intel..

What I don't really understand is why ARM, with an IOMMU that supports
PTE WB, has devices where dev_is_dma_coherent() == false ? 

Is it the case that DMA from those devices ignores the IO PTE's
cachable mode?

Jason
