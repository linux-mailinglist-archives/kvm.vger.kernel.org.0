Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794E4396B7
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhJYMzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:55:37 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:8833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233071AbhJYMzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 08:55:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzUOVa8lc/62YJPWpHDdSATaJsrXHwglW+2IbUQgG3VI7yKyPEpgiIAW3IGG7BDTrhdoPzKTCjY+oE2P+N+rUKmcYhgKADrGdJ5CGu7B3+PoqeRy2SCrai4KjyWIbbERIY7v4Of2A5tTTIioGzgulVau5UfGIJ/ULh3LSB71oiSR852M/Kr24qE3JusEmuYXQQhQnWb2wTmGJphw2BZiBTvtEn73jprxauGzcYCZZJ3cGQsddfUOP4jzDbpfNRZ6vEK8G/kKceI0OCaGCX9Z2EpBaKrVxqMQm1IvyDa+OFGP9zZt8IKG1CU/APV2LLKK1qnwkFupjRdtLxWdnfiScg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2YfBqsSPy+ZMmgJjl90lyXjG569Eqib/opJj0DiXXY=;
 b=Zwyvr6LUkeVjdqd4mSQb1CiPfsl6jh1HYsJJz9FJdBBeQyWl75ckCB6neA7yh7S3qJcECE+sdeyvTo0rg1aSA81clIm0P9DnkMaJxNPbrP/VP3/cf0NJudJviciMPYXvcaFtMw+w7KKTN944X3HZty628Q97mzxmflJstNQQi3/jX7hkobmP2RSNkru6xqmDu2e2JvyuFfFQOzsREVw6hDaUHjso7VbKLjIzF2Weq4ayNJeyGQzXx7Y7+g7DH5L/hu1adeuw9tIDOWYXlctYtAqSCaZ9EK9uL0P9e3AOg+ACMrlOhvGlEIZyixXZs/YpRdwipjRoQpK8j8e8TRZZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2YfBqsSPy+ZMmgJjl90lyXjG569Eqib/opJj0DiXXY=;
 b=cNrBkH5Ou/w8/xLkXPc4FuMaTDbZvsuJi4vAnedy/T3SZb/uU9RupMleXuWaFhtLLltoTtPqap/6yZQ8aAsmvaDmWBxGQA0U67ezltcnayGooT6xQQ96+KUo0Mg3zVtBuIqqlaXKcJRqaAdoC03NFj375cQ3y9W1w5/we1V5CztNaxVhWrXOwI+nxwo7hvbFW0ezEsZkZldJC/rBPU9CxeYQGPkFU0+urZKGpQa9GCCKRkGAO4NfOfz1n2b59TmdYfj7AxmeKgBlWJYWgB3CwbyoPszoph5Hgh5JurnhNe8TmICJAFtjI4ujHdfTZJciJwk7p+dmbMPu5BudrAwp2Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Mon, 25 Oct
 2021 12:53:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 12:53:12 +0000
Date:   Mon, 25 Oct 2021 09:53:09 -0300
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
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20211025125309.GT2744544@nvidia.com>
References: <PH0PR11MB56583D477B3977D92C2C1ADDC3839@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB56583D477B3977D92C2C1ADDC3839@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR18CA0038.namprd18.prod.outlook.com
 (2603:10b6:610:55::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR18CA0038.namprd18.prod.outlook.com (2603:10b6:610:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Mon, 25 Oct 2021 12:53:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mezTR-001S8B-Vu; Mon, 25 Oct 2021 09:53:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8743aee-27af-490f-1f4c-08d997b6670f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-Microsoft-Antispam-PRVS: <BL1PR12MB512736298B786B52315FE48EC2839@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLAxppNUkU33m0VGO5cJ2t4EB7RIxsZrL48JG+7eoiTBNEE7IV8G1FMSDK8YZuipc2MF/EIEULxUQxCNyw/OZSr4Gw5U6Y5lbVMujgOif/Dyz19r/GQK/jWBotRhxVIywavIXiQqHI3amQd/Wv+0LbYHPF2AS78KgoSlNDipsz8Mer3l9+nQa3v5/qeD0Uw6hPZ4flh14z2Xz2c0NWBKSjHwf+7GICf7SGjRd4UhKyQbqx53OAsYU6NUes2BbZKX/Qy3ebYWiVJpFYECbFH6kAlxhlXXjNivGqJILI9MzSaHLVjpkx7hKbgFkPXw2B7zygtufogHlRyOmWbce9CO5DMv0KIcNCFyr/6t1YeXA0XyNSa1/xk0MHEiv46o2ieULyce+JgyDLwuqAHH7Bh77m0OF2eFBuW1f+d1oKcLvL6N/FGg+yGLDfPdTxjqMYLD7u9gm2vnmLH9dF7iIQkI7v/+7hgqLOe2sElNWl1zl6c9y4GgnmhDuyiB5HQRR3sKbVvBJgQPGLqOlVyjdEtvFylLh0ZA5W7R9kyBaaXvbFmLHJjVhbS3LQWBCbiycFwkG51ZfypmnFwwR0WZI6XTTgi43WNtydrINu11zkFQGmbnEDRZ64ZSaGnsCym7coGe+DOs7dz2uY1BlB8pJUgChw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(426003)(33656002)(4326008)(26005)(6916009)(5660300002)(2906002)(66946007)(2616005)(9746002)(107886003)(9786002)(36756003)(66556008)(54906003)(8676002)(8936002)(86362001)(38100700002)(316002)(7416002)(508600001)(1076003)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wq3VJHJo79XhpsZxOGRP7tL5FLvLPzacmM/QTLmQU1SDTc0S1RLipwxJP1p7?=
 =?us-ascii?Q?h9xawknUbBHvevaYQgMBQeohUzOSGnKHGhyC8Av2dByjJ0RuSvXeXpOxb0eH?=
 =?us-ascii?Q?TrhPB+rn2lt/c99D++Fp8PtnW4a5+lpnErjAXPKosJTNFRwsnsgXR9gP0ao6?=
 =?us-ascii?Q?Tw4kC1mPjQwJV3SDTgWRRkjjqh4+SiI0uxHzWSwSeqSmEgtYCPqxanWdJgLx?=
 =?us-ascii?Q?MvMUwI9EyUZab/eG2jjgi/aOaGt/3fGMXYDoTNAFDYfTxE4JYexVlaZQWiZw?=
 =?us-ascii?Q?ro/68xy3O+ShD4BDOGZZd5iKK1Xuh3ojTp0uX98vPQv+rj0XmOzPwvfsZBNp?=
 =?us-ascii?Q?DMx0UkvoP8hVz2vVzCSva3UG9W1QUiW+33P1hoJzSjN5at3nnCC4hx+AYHiJ?=
 =?us-ascii?Q?Wkyth4yApJtM1LlzCnj4aFLO9V34it3FYS1BUrFSR9iIxO6Y1lBxlVNl7Y0s?=
 =?us-ascii?Q?IWXZcpjHoakRJK0ZLNc7CSgU89nbojK+Sb/k0ez9vjYFuS69lzzzOAPEj+o2?=
 =?us-ascii?Q?sHBWbuNpGIjDnBv3vIoNrduluzelk2U+T4yVwd7h0/OukGUnFX+qHql1OMop?=
 =?us-ascii?Q?7VfWIIcHNhPEG3t6E9jXV6ocMRRFPFLvlD55XSwXcO4G8djn1tURumybGg14?=
 =?us-ascii?Q?bmw87AqM1SXUW9U67d6C7MUgCOyzFOuen08KDxyqW5Eq0H02ynWg9wtkWPEJ?=
 =?us-ascii?Q?FxAK1pbBircZIr5TGV7syXWGva4aD97C3oCZprleTkkLMj+YhfViOFQyPeHh?=
 =?us-ascii?Q?gQ9/iPnPa2QkCdKNz+CyFiGlCiE/32W9HCUQxtN/y0a21yjVCSxdu+keP3Dg?=
 =?us-ascii?Q?Ac72lf9uYLrQfEb/t4mrS4zf8p3bBgXLMZ2QrdW64hI7SZlB29N7iEyu6CVb?=
 =?us-ascii?Q?hDhN6Ff43nGE4UtiIuT3VpdpPwU4M9vKOdlXqqKO2SsuJzQEYCHeJP/KYyNd?=
 =?us-ascii?Q?WGiSOkwe66Nv6gz4uQYyedxC7rIqaOkzMqlDfcLfecau9mG/cCsoKeKYDERU?=
 =?us-ascii?Q?onr/9FqiGOm2ixOK7ytWdfUK2Rg4F9bPHQH7QbGWF5xixPWYb9bKGhwVTi64?=
 =?us-ascii?Q?jriTYI5DAjI2ECHMNHKGivfcclcf5o+wKbyJurlCnVJUl9AMMODDzi9dF55W?=
 =?us-ascii?Q?EUSEjukWP6GWwYDyfoulJMCzd+DosBsRYc9I/KeL8j4t789TYAJxZH34vA09?=
 =?us-ascii?Q?n5fN+AeEJ0VtAqXgSeajZjTww3dv6QjK2Mg6uWytWOBVdJrJjt7UWsTuEopf?=
 =?us-ascii?Q?G3fELlEYBtGwqvFOCikB+towV75CVo6RNLRxACYZOW10mCmC6LfTXpf4X1/Z?=
 =?us-ascii?Q?R6PiPfsUzNPdygNbjDnOhM3SVoGs0s1xA4qPK8uMJGa04vPFO1K56HTv605N?=
 =?us-ascii?Q?tv9ieoW68pmvCBVuHFIhrZ98Hmi9BCEl0HLG5h2bZrSCM3YG52x+FANJj1Pe?=
 =?us-ascii?Q?mQmwekj6+gVNbokrUwGavuI4RsIASIRiYZJaqr6k9Ig3OnGMpQY1l/chJbVY?=
 =?us-ascii?Q?K5L2IH4TV4dua3nuW509/CW9ZaBFhMlX3HHizZ+DHZmIAEleB7INGsP+TiZw?=
 =?us-ascii?Q?cenwxa76GnlzwPddOmM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8743aee-27af-490f-1f4c-08d997b6670f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 12:53:12.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emfy7xzXij35Su5kiAOInpq07Kb//1IITdpXNzM3gzK/dCZJLHBhyTR443elZ6EO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 06:28:09AM +0000, Liu, Yi L wrote:
>    thanks for the guiding. will also refer to your vfio_group_cdev series.
> 
>    Need to double confirm here. Not quite following on the kfree. Is
>    this kfree to free the vfio_device structure? But now the
>    vfio_device pointer is provided by callers (e.g. vfio-pci). Do
>    you want to let vfio core allocate the vfio_device struct and
>    return the pointer to callers?

There are several common patterns for this problem, two that would be
suitable:

- Require each driver to provide a release op inside vfio_device_ops
  that does the kfree. Have the core provide a struct device release
  op that calls this one. Keep the kalloc/kfree in the drivers

- Move the kalloc into the core and have the core provide the kfree
  with an optional release callback for anydriver specific cleanup

  This requires some macro to make the memory layout work. RDMA has
  a version of this:

struct ib_device *_ib_alloc_device(size_t size);
#define ib_alloc_device(drv_struct, member)                                    \
        container_of(_ib_alloc_device(sizeof(struct drv_struct) +              \
                                      BUILD_BUG_ON_ZERO(offsetof(              \
                                              struct drv_struct, member))),    \
                     struct drv_struct, member)


In part the choice is how many drivers require a release callback
anyhow, if they all do then the first is easier to understand. If only
few or none do then the latter is less code in drivers, and never
exposes the driver to the tricky transition from alloc to refcount
cleanup.

Jason
