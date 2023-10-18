Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442CA7CEB09
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbjJRWPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjJRWPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:15:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0EAB6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:15:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRrtEBN62MkEp9AXgzJtnp1ovGoclYJZWimYuE7rD6A/T/A0te4j1YL+U6Kdscoc4/OaU258/b+l12d+vk8rMQ8eJvWUjZHSgd+ZKg5V+byJjP2umTEiriZZBCtzbcd9jXK9qlUfEkbniAJzoXmQZASpDCgHk+1eN/MrbB9V64rWCHDkq6zLs0bxINcAQal2CBrJu0/2rxLwH+2C3XT5MX1WUzLGdDmg5IBv2bnliAS/+AoHOr4KJsV759JlO4YZt0fuBCiZzOMj1DK3VYidynYSRpV1KOGnX2OU6zG3GzaymbN+kbd40SAY6lbDr4rbveIh7Retx1XCAvl6DTHA6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biae7hqnoefgDQm4z2XSEiyDW7ceS2yzDjAZZILwh1k=;
 b=VF0yVWpoHmYj3QLFc+8ZY6aCaTWioiS09CPMQKYltTlT+ApM9EHQ+NNSXJuR7PC+e+g8qPrEq1OjRYL2UpDaYFr+1YEvfscVMNIlrxEq7d0EvGCCVl493wWPs238l6b+3pr8ghvMhYiMf5UN68x7cMg/Ajha4iBv06196IdAhz/UKqO2gzTLdOxRRNNI/JUh3R0D5LJrMcECUJcKMM6IzkRaXD8mkvO2rlVw2jPSiezUAmEA4snYUJJAUAy3k7RANp5N5kOZG43Pl3/LjGzCYqKers76jNqwNI5stmvbPPx41e4oVrdm1klKOCzth4d9njn1t1zj7PHSL1Pyu7yk9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biae7hqnoefgDQm4z2XSEiyDW7ceS2yzDjAZZILwh1k=;
 b=fePaQgKqX3v4sfey8ruTzWWLb/XRwYgvhxuX7DcnHH5tN7ZHLYXNfWO1OUFij3V1RfJTNndeL5Vf5HJxey4iq4MTnri+EfH+2mABb/VbhQR5RwMzw2qe+dqoNDE+ugLZmTzwhF7fZSoQJyhgNbjv/bFV341RRxph391L4tamV+/mn+4L9MSfKKqXJrDmGQTxToIcok6wjuqA5JmPibcUrOv6cmoqh+E26IQYBGGuoUr1zqbVecrQpjzIUTzLBnFFh+54E65eqIgx7B0nogNYSv+xkQH/6uQOSKLZxTO4e3ajtuprWMnKcK7mP2DGSsEoy3Gh9ZO06ZOZI65PowarNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 22:14:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:14:58 +0000
Date:   Wed, 18 Oct 2023 19:14:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH v4 02/18] vfio: Move iova_bitmap into iommufd
Message-ID: <20231018221454.GG3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-3-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-3-joao.m.martins@oracle.com>
X-ClientProxiedBy: BYAPR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: b7ff6f19-57b1-4010-c8fd-08dbd027aa19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccleC9ZE0MHXIXyE7uGkzknHYQe+xcdCynX0Ly6WRnI6viaMp79nN3yijz25raje6i6AfmIopygqQi+Trxu1fR703cJOtGnt/M70wvIuJKTx44uLiqtrRPxOSmloVGsK1S6zwYCZAiAZPYxEPU0fSIbDp3i81nNO4/O9zYqTsohqWiv5BnmL1F1VNOXR17xF3S7KE/1WqkRV9F+62AsJ7Lseh3qHLjpiltyFfgrucQtDLRnmmdOGa8+P6xaeUO8eR+R/aBWCMIlRlyhlYt8GbXdMJuaYFq8c/x7apyWpCoBXqDXpZSruafFs7XJHnuYNX34TpdoIPJOtYjRFvjnrTEHWIVPxrsytflv07ZWE6HV325PLxtaN5n1cR78itZxUG3UUeWdmgFFSVmNmZlC//evM3i3fyml2ZdnNh2wMZk78bAnXt/iDv03UHeCx+la6mCIm+Jxwk4VLT0w//z/xnAAYfUZbCROGuxC7L6LGuxs3nzAq17QO9Tdkdkyw8LbpgcCHLzZq11esvhksjJcb8TJIbECl7BtGqRVlo4Vuymudf1uLBRIaEyT19aYK7msq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(396003)(366004)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(36756003)(6486002)(478600001)(66556008)(6916009)(41300700001)(7416002)(66476007)(316002)(4326008)(8676002)(8936002)(66946007)(54906003)(5660300002)(6506007)(86362001)(38100700002)(6512007)(1076003)(26005)(2906002)(6666004)(83380400001)(107886003)(33656002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LYvTcyMBZwJcmJx1qjM7EKvWvSQHr0jXT4/X0ekEGseuGHnvTLyGuf0CdbZY?=
 =?us-ascii?Q?IwSeb7Pfz9lQ4r8KqLUEvLygxAHXMuU3UHZOoQyBZgMWcIDSBo8GGSFZvP1o?=
 =?us-ascii?Q?2GVbTYEviXvI97XEJmGuz2Z/8wUkWGycTzL0k1x/bVoqTwP3uAVVSncnKl1a?=
 =?us-ascii?Q?wf44XhYnlT0M6AOsXireZkj9xw1njz9cesQGUUbxtxQ+3GvYOvUpqF8ZYiZr?=
 =?us-ascii?Q?jVSu0RKi2Q7Gp0FXUEUKf+HAQfBsoTln3aFiAOeXv3zksk55ZKwmXN+mm3xT?=
 =?us-ascii?Q?Vyx5Rc6SMoodbd5p438QYlv6Lrs7q4BKsZfxtL8ee2fZ4Z+QpRdG4vVDg3r8?=
 =?us-ascii?Q?mkBwd7+5mXj9CJ/QNDYPmAb57KzpOrp/z87+n7C1jo9/v1qSDfpdHKCSkK7F?=
 =?us-ascii?Q?hB+LeYUUXtLHSwr6v3T3yecpJAPxa5o2eE7zNj4UzhVd2PdtAxFfFwb7Sf+e?=
 =?us-ascii?Q?YsF+BjDtI+rQF1GNHCu+XMd/WsWP1b5xGAAMOeNjK1/yvbcBqJ3q/cyFakJR?=
 =?us-ascii?Q?LS3CFnN36PY8MR2xWquxkax9nFwXukqYQZ6hTqXG81RQ/VZSC+2kUc8U3Y+u?=
 =?us-ascii?Q?lbH9aMefYBhYtqElbcqBIjL8m1bCm9AZqMA2lfkP7Grbl6Q/aVzi5uwhzwiF?=
 =?us-ascii?Q?oK17pSI0sYlEQ5ZPr/3/RHxsakqTbvTCAxWGrCA4S43U9xc44r2QPybZkg1X?=
 =?us-ascii?Q?pyTI+GQGLdN+F0iFvOSCobcBat0gEL4sQu2DdURGJ8YbfOyKeIR1aNBbpnYG?=
 =?us-ascii?Q?vHndLqcKM6x+SyDcmh9STgBoBQey0TsC1eX2o5AQU7oD+6Q8Yk7c+Y1oAwVT?=
 =?us-ascii?Q?L2WpruUX16ps0RZEI1KlcYpYJaWUUrPqozRaYO9g+z4ps1/JGQSJh3D+EagL?=
 =?us-ascii?Q?BrxxXAChAO3RuIoqgZryGmjZHPsqkeE7NLnjkuA48oUJpAoM4eGktPsPsney?=
 =?us-ascii?Q?8vwvg6Lj/epmJgXSNgZZCaLmyJO+QBpiI2CaU/XZw2X4NPlmRqQ07criRbg7?=
 =?us-ascii?Q?ua7hBprgxvfDTPs3K/w9wvmi/MsCnU0hkIvFaf5w7kTZ1qiCLLskLDcnhSWC?=
 =?us-ascii?Q?2VcX/quI5mQsgSiHmV/DCq72eN3fy7ZPZ003mgtAXdZgdL/+doFKZ1EKxAiM?=
 =?us-ascii?Q?oj7o3wJT8w7tTCQhZ2AC/IRzWZHjMsLq0R7sqjo9Vyhmm2IH6p80PtPVxRxM?=
 =?us-ascii?Q?GHuyzxmHc3wai/y4DZ1wLkzJiBMK32IcXxhNuPcSzH5xs2XfvAIPQx9NXAmR?=
 =?us-ascii?Q?vHbvsZ0ZRU3U/H7q+Qgknod9f/jV5IruMHOnRhn/3wABu3V3jWVLjX6gw9Cr?=
 =?us-ascii?Q?raC+CcdTyEjFHN+gFlaYFbr9jqTX8xygB+hM6fdARbqJYUOo45NwWhZoyyya?=
 =?us-ascii?Q?4fPLjo5MBy4MyMfWMq8JYVP2p6KIAnyPxGJRIvTFulSiIZ5dWfW/SgQCoZj1?=
 =?us-ascii?Q?o1vFohmqUHmPQtpkWjzmo2PgMmhE/3Vhl0bxNcMyH8GFHDMDHmGwfLZnd8H3?=
 =?us-ascii?Q?LzM8yXNd6Mi9EEyUIgtPmkhFI9XVxO/bpYbzL/tSHXVoXZfeCtQKBqXL0ek9?=
 =?us-ascii?Q?zKnKIkr1XGSJOtOX4Bse0r55gEjswpfew7e1jT60?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ff6f19-57b1-4010-c8fd-08dbd027aa19
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:14:58.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bpnWqNSdSdgGt1laPY9iXUp3wcX3U8/ftE6EhBTB0KmhvMPaS7rkPyFnTlK2CMOZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:26:59PM +0100, Joao Martins wrote:
> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> the user bitmaps, so move to the common dependency into IOMMUFD.  In doing
> so, create the symbol IOMMUFD_DRIVER which designates the builtin code that
> will be used by drivers when selected. Today this means MLX5_VFIO_PCI and
> PDS_VFIO_PCI. IOMMU drivers will do the same (in future patches) when
> supporting dirty tracking and select IOMMUFD_DRIVER accordingly.
> 
> Given that the symbol maybe be disabled, add header definitions in
> iova_bitmap.h for when IOMMUFD_DRIVER=n
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/Kconfig                 |  4 +++
>  drivers/iommu/iommufd/Makefile                |  1 +
>  drivers/{vfio => iommu/iommufd}/iova_bitmap.c |  0
>  drivers/vfio/Makefile                         |  3 +--
>  drivers/vfio/pci/mlx5/Kconfig                 |  1 +
>  drivers/vfio/pci/pds/Kconfig                  |  1 +
>  include/linux/iova_bitmap.h                   | 26 +++++++++++++++++++
>  7 files changed, 34 insertions(+), 2 deletions(-)
>  rename drivers/{vfio => iommu/iommufd}/iova_bitmap.c (100%)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
