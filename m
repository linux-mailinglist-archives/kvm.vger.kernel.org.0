Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC37189B5
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 21:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjEaTAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 15:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjEaTAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 15:00:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA61101;
        Wed, 31 May 2023 12:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3/mcF+HaVodYXNXJ0VfRE5i9R7wVaafcjQZGFl/0ECfgCWazrhq9IbUhLe6OSu4VeEAS9xibMpVkJ9pS3K6prf7m0i72Yvoa+RId02l012lWz6SEam4CbiNmMWdp9Asp0LUWewq4tYMj72TfCNGZaUIFoAUlL21Xc4q3CG1ERtTMN2M9K5HfyK0+mGQeJIUMCpWzJKQKFctAiGbGsZy7fAy/+mKBBv3cLSVWRYlM/WoIdgKrmlYd2AiYW4FH1Xx+I/opJA72hh0piMUa9/1hcD4qBqCVJqOJ27Me0GNed9psLHlZOY4tHB1ik724mYa3KSXr3aiJt5fGm2ULPmExw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Usj40FjyPgAWltEGOhU7vErOMDtGbOW1Jde7uR1g0Do=;
 b=oFXoIz5jmcxio4NeeVpBRNO2ccjBNc0oq4nNFsfyvwPGnk693KRkXlWDYzGGEOvTrSwxfYOi3bxMuarET3/NthCwNK5hpCqcgkCshAbBttG8UkXsd8B1IXdww9rWEOGxUtDYZDB03hjDIbMT2dWt9ul+GGkDb/OicYxSxqqpMIhnb3UnkXXjuBFITn/IoHsVawwyGqKh8LAPSFFeEQQS0cGBrQKQOPg9PFLmKnml260cnntO72IEWc4vST1mRQ1GcwfGTz2U0HFA/5aiQxTo6eM3Vlm76zge/LnN54YeYi3Z3LcvVVrsKiN29G7g67z2hdvAS5+gPx/R0bHudyxlig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Usj40FjyPgAWltEGOhU7vErOMDtGbOW1Jde7uR1g0Do=;
 b=Jn0CT64Le4ua8RbVW7szGZLQ/FK2Kwr4CF1vFnnG834Zh7Ik8eNgZ775xngy3/eAsvL8OIZNQLrRB9U2foFNKqybtRtgyWuJWI7DgoBex0dr82AvRIkplL7dfq6B04EaXjh0Z6ACcAwbpoRHO+NhDFT9Zy2jRROk+x9hUwYafxk0M0eeOHM3/Tkd7ouUFWCfEUhurd4oS+2tkQ3xKCtDRY/1JmbitAPUU0C+pX0kROsusPNt4IgCjskBjhehpvN0tjPBTSIZllRkBEw+LYfdFYDtiwCCTnOSi0aWAfb5Xu+a/shwcrLPjt2YCHkcCRFu0220a0gn5LX422DTSHMORg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB5640.namprd12.prod.outlook.com (2603:10b6:806:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 19:00:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 19:00:14 +0000
Date:   Wed, 31 May 2023 16:00:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v6 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZHeZPPo/MWXV1L9Q@nvidia.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
 <20230522115751.326947-10-yi.l.liu@intel.com>
 <20230524135603.33ee3d91.alex.williamson@redhat.com>
 <DS0PR11MB752935203F87D69D4468B890C3469@DS0PR11MB7529.namprd11.prod.outlook.com>
 <355a9f1e-64e6-d785-5a22-027b708b4935@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <355a9f1e-64e6-d785-5a22-027b708b4935@linux.intel.com>
X-ClientProxiedBy: CH0PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:610:b0::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB5640:EE_
X-MS-Office365-Filtering-Correlation-Id: 57c2d8e9-379c-420c-d9a4-08db62094437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0s7MclbGIh+Hb9sJSdDxTFozH5gJPe27ck29FZRMrnWvF43YpAQOp+gXlgLI0HbG2WtD8kL4Z+IEEaDpL7985cxLt76gLSUtlQzbdGQUPXdAphfgAW5HgK3dAa7fvvIvxhVrm9mwaky1irkNcMSSRWOCLaNyKFbcTsX79tzRAJMbJc6u5ALobQ0lsYRoOUrYdA9c9xl2LjbYCniNHan5cuXLazaREiSA0OWY0D4LAl5nGed086foOItarLvJWUlg6UJ00drQQ9N4Sx+YFZX7F2DjA14ObMRNLmnPfyNQzZ0qEyGD7nBzdvTxbZTqFbAYQnXOjrkdHlQkb1JV0hF/FOD4wI4yMeMyayT57Hl/wnPemLVL/syIu91YmIj4QMW2wQLJ15q9luZd6HEIL6h9CPBb1Sn8jjpyjdfD2jCHc7GHmlBKTfn1OL1ri/RmaTGpUgUZSZcn0TLMP/i3mWRIHfKW+YId4V+x14DPpSqmPDPLCgEqUhA26P+Sn0/srhImroLTA1mTN6ujjA04cPiDZnNOYMaCuI16V3hR693pLf/aK4FnbPE0odripXEoUJS1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199021)(316002)(6486002)(41300700001)(83380400001)(6512007)(86362001)(2616005)(186003)(53546011)(6506007)(26005)(2906002)(38100700002)(8936002)(36756003)(7416002)(5660300002)(4326008)(6916009)(66476007)(66556008)(478600001)(54906003)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XWzN3CQ69IGJH3evyrMcbXsfKEJmnhIYPYJf7tYo9Ek9z1lm9fxIGhcr7wUz?=
 =?us-ascii?Q?vnU/1TASSMSzPAMIaRorZilcMMGfFMkteAPFt/tN4yKA2aO0rkOYqblb+Daf?=
 =?us-ascii?Q?BzKuH5euKPc9hi4Xwr63L2V1bunT8YQun7pI/6nfz8eTKCtKOj6KR8yM0X1F?=
 =?us-ascii?Q?brF0nZnY3EA/G50LSQhaj3+oUKITPp+Ng4cuap6ge6pCZ/LnszmFEjhh/4gR?=
 =?us-ascii?Q?JIQSJjPJHqRGEGXgpgNneGhHkBnA3R4SdYk/BsTr8eQtthLEzQ7GBTCIHojr?=
 =?us-ascii?Q?tG9epbOZnxHENvst605FAH1LO2TlDuFnuZm1+w1mpWteqXynYNTdkD5p+L3I?=
 =?us-ascii?Q?pRLMKDEy77PG43DhSyIy33eVi2wiaZMRL8bhoPpzzA3YAa/wuEzwSgbCWNr9?=
 =?us-ascii?Q?1i8hd7Vn3mfuFleK0C/YFMIEbHXOO3Egelng9312y4pqrn3nGhjeNR8hpx+V?=
 =?us-ascii?Q?BuIaFgcX7ybQdVO/RSiviXDAChCOsfU0jtIjE2kf64mJFq1GHTYMJQBrXhUQ?=
 =?us-ascii?Q?G05Ou8lFxRIOdKuNc5GnsBD8+gAf6pjKhaQz5pDRafvpZy3DbHGohT/xNx5x?=
 =?us-ascii?Q?1g7lBUZ7lib2VE1RhhvmiWFZtSVUgR97l/nVDdr3qJqCPWKQLaZzXhWm8uAe?=
 =?us-ascii?Q?sdBQ8m9+2NmY67LILjKVPi7qkXZU5pQzmweI6J/ovSM65vn/E3dWfxN6aq91?=
 =?us-ascii?Q?7RY6RrIU2WScczOHZbh2jLskE+ct6UjUd/8gm++W/buOwScz3dzK9O7H9qBe?=
 =?us-ascii?Q?nV0iGqGYRkOLdV34jk31uup/c95qJXEJJwaDNyEpnqi0XSF0+qS6iDyuFyho?=
 =?us-ascii?Q?ucIXpKjaINKK+nL9VS0FQo1MwIfHt3zqH3HLZ4ttZz4/XXhMHN97ESvTVpkw?=
 =?us-ascii?Q?rM6o8VUv8aHZ29xYuHjtbPOyvFR4b9DZyoR4tO/KmeyuqNogKhY5ZmLi+VZp?=
 =?us-ascii?Q?a3CB7JtjZw42kV45wsyqIG609xPb76KrO0WvulaNmdH54DS+t6ngaBi3x9xS?=
 =?us-ascii?Q?BWUuCgOISkn1gLWlb5ShVgNVZK7gwlbn6LiYerDy3rGL75WtlQAaKTBUVJgu?=
 =?us-ascii?Q?UF5EfZR6UndunvBBsHWKlpJkxfVncDnRL5jBZiMVuKUoC2fm0ezu24Zfu1FZ?=
 =?us-ascii?Q?9qgErPZckF3EWgPHy5Wi1YQD86SSaBsTvhqp+Lq1qKMhDklK/ApHI3RHT4Ne?=
 =?us-ascii?Q?VPjaIUtcWs10s7gHXX1oyp43UqqJZMQMCXe+7xRS5MJ7dypYTuWqxprTMYGr?=
 =?us-ascii?Q?w7q3nbQ6NPDONsJECiMzyOk8bLayIL8JK5EQC62G+bV+oNXGk5STMgZ7zv2h?=
 =?us-ascii?Q?8F6c2+tyhYjpGIpzqB4l4yvraOj3ZS7urrG1qkdYngl58X7YWZ0wytuLA0Q4?=
 =?us-ascii?Q?wUAlYiXs+fpzXZQDlnKsxclQjC4TvqWt0sTOpYUD0Ah4NuWCSe7ueT4oW2FH?=
 =?us-ascii?Q?z0BrR32lEt5SXKJB2AtTAe23IroljUPx09wMO23ocWJ5pMkEv2nMXuQNF8j5?=
 =?us-ascii?Q?cVj7T/9rX7JJtqCvQEIqJf5CVWKJwEpu5Prh1X3uHn87ay6FfYYvv6ymCdBJ?=
 =?us-ascii?Q?GiSwEAa4E5geC+l2maEi5iZUKt3p63l2dhHGuMVZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c2d8e9-379c-420c-d9a4-08db62094437
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 19:00:14.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgwDUdvIKPy3iRdRga1rYffQznPFWdwZd2dt1DVE1E/RX2+IiOYayJKvBa/4EqxL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5640
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023 at 10:04:27AM +0800, Baolu Lu wrote:
> On 5/25/23 9:02 PM, Liu, Yi L wrote:
> > >   It's possible that requirement
> > > might be relaxed in the new DMA ownership model, but as it is right
> > > now, the code enforces that requirement and any new discussion about
> > > what makes hot-reset available should note both the ownership and
> > > dev_set requirement.  Thanks,
> > I think your point is that if an iommufd_ctx has acquired DMA ownerhisp
> > of an iommu_group, it means the device is owned. And it should not
> > matter whether all the devices in the iommu_group is present in the
> > dev_set. It is allowed that some devices are bound to pci-stub or
> > pcieport driver. Is it?
> > 
> > Actually I have a doubt on it. IIUC, the above requirement on dev_set
> > is to ensure the reset to the devices are protected by the dev_set->lock.
> > So that either the reset issued by driver itself or a hot reset request
> > from user, there is no race. But if a device is not in the dev_set, then
> > hot reset request from user might race with the bound driver. DMA ownership
> > only guarantees the drivers won't handle DMA via DMA API which would have
> > conflict with DMA mappings from user. I'm not sure if it is able to
> > guarantee reset is exclusive as well. I see pci-stub and pcieport driver
> > are the only two drivers that set the driver_managed_dma flag besides the
> > vfio drivers. pci-stub may be fine. not sure about pcieport driver.
> 
> commit c7d469849747 ("PCI: portdrv: Set driver_managed_dma") described
> the criteria of adding driver_managed_dma to the pcieport driver.
> 
> "
> We achieve this by setting ".driver_managed_dma = true" in pci_driver
> structure. It is safe because the portdrv driver meets below criteria:
> 
> - This driver doesn't use DMA, as you can't find any related calls like
>   pci_set_master() or any kernel DMA API (dma_map_*() and etc.).
> - It doesn't use MMIO as you can't find ioremap() or similar calls. It's
>   tolerant to userspace possibly also touching the same MMIO registers
>   via P2P DMA access.
> "
> 
> pci_rest_device() definitely shouldn't be done by the kernel drivers
> that have driver_managed_dma set.

Right

The only time it is safe to reset is if you know there is no attached
driver or you know VFIO is the attached driver and the caller owns the
VFIO too.

We haven't done a no attached driver test due to races.

Jason
