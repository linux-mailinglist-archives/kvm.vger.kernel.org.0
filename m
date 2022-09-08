Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CEA5B1C4A
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 14:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiIHMIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 08:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiIHMIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 08:08:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF40F5C7D;
        Thu,  8 Sep 2022 05:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOYiLzMfsd4sz2dvZXj1Coni6RjpFYlmZg0vHg4qOO6tpFnvOWx5pKljKCyJnBFZkIqZq98zrgC/EXdOcFwostxMhORoWdyS4nvdz5vSm5pQEaH4FETV+K7vSABSqFqe/YOJoyHIka1kp3HSv++KIp6GpUf+bp3/xf4DQZ9Azhk5bBapv4wDNfKo8qZPz0YtZp+IsqkMckZ/sLVKhTseFHrvHtwt93+m+FVjXe7LRaycuA8r+e1biNlSe+nORlv6NW1YTwjs2UXgXOy1ISnLmB+91OItndOUtM5+vZYDGZszPuJlIgM6mnGlH92K65/2pOcZdNi8/QOQBV/rb9zcFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeGLGnQg/UZOs09gFr2w3B0CznyeJ/fqxMfX+Xz+1UU=;
 b=icO8aTFsET+G5h2fRhCgFq5XPiiwqOmbDTfCB5HUQMkDAS1V0nGkFUCSUFWFH1Fdr0YBGI7QvYoT754foDJ/5/Wl7wSxHE/kTtM+hynxBIvCuHRNgOx3yD/mHVeFaqY2f1GXbOQhkN0QcDKy/2/fOZ9TJxEtR4lqXWFKzPE5ZHQPtxqCpSH8kWDtLw02YRkBVbJAbxGjqmM0syGXO0gx+EjmSTKf+BLygaZgmnZ6dzEmfH8cqAMmUcffIhwLZ++ZX4+pXoeEuaFhiGDCS9BtbvO9s9qEuLVEW/th734fEkRBZTtL0bcNERZBXkN9H9AQrAkm4wSHvQUxPt6SwvyVbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeGLGnQg/UZOs09gFr2w3B0CznyeJ/fqxMfX+Xz+1UU=;
 b=rd/dreQqpFmn6I+Sq1x3azZN49bVTiw8KnkQ63ZbeB/MSoFqZZUChrn+nqcxbfUiPSQGu0NwY5br5PU5AkCMrweFPcM6FTu4FVNuFxlzQDOEcmXbcihnJZV7qrnI6Kl5YW5vyFq8z9VHkdFnvkCtcI+Ae4yPRysEuGtjr+ymERH8uKfhOQ3YWr/Oy/TRi2w3xe8/0XY8yQyy93tE66Swr4jy3Yss0U0TUmZgvY6KKGpJqj9P58U7n8xSyZF82OFRG1zmXf2knUf0SpZB5R3y+slS3kS24Cblk44kIR8+H36AcGMw5NQnUlNFsk0VUrRNa+VXqqlTOJWLoyIdjFbSsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5982.namprd12.prod.outlook.com (2603:10b6:8:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 12:08:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 12:08:40 +0000
Date:   Thu, 8 Sep 2022 09:08:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxnbRq5vaP/OL0ra@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com>
 <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com>
 <BN9PR11MB52763FAD3E7545CC26C0DE908C409@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763FAD3E7545CC26C0DE908C409@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:208:239::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS7PR12MB5982:EE_
X-MS-Office365-Filtering-Correlation-Id: 3244c35b-ec15-478a-ddbf-08da9192dda6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4+2d2iNiPq2gKqPIIMLiJKWU84io64lVnGpFadnBr78zMCeS3F01ysuye9dWuU6lgAayElZZhfFPBG4Rdtt5K9zHkHw6hVCpdMKwnPRAKiotcRhS/tOPnbOEC5S3X3kbv6k1QqTG8wC2j3pB3k8pxCq29fnQFNZMaq/CEswX114amnp7Zvg72asikd8JMnASqmSiXSMSdIizc5WcDnqdbMEFdCPRhxXP+8eRZXYXmeyvI+a9qnAqXarIXjIa9F1LcA3xqKYNzbCZXhvs2J+Q5j176nq8VNXspbkkq+sk3MEmIHi+YZ7oDS8j5cPWDRM53Myc4wwdk2xYSksg5QzLk74mP6sxFewoZqTiQXMXzWHnyVe5p8XqZ1uOhLoPYk6WieI3R3IqNcBSToAtCn9Wzy9DwaVGREGpmaY9sgZFWiKpJmbFMbmQRrsYqaqVZjzeCdSPhL6gcbjLDIfibRUaCJu23fE9C5mqx9Cy8FG8Bzn1//bTR8jfHvhEBgmVYLqZFRURkVVFqnGArnEPKF9EOsSvT/AAWGVByVgVc9oIBDXVAWA5n98OU99Eu5EKFxfO/fGw0XWO8GAwJxqJUYkDiGAWPI2AFBo+rVCis0UQqXlgpnfFC7VmYDFr/2ItRAV9nIU0e1FPCz/QvTb3kfYT4tK8bBXwmrdKT42FZ1zL1D0RM+hnxKbqHm3OSNHE1Z+CMNGQWXqb/S5CTRPXZjiew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(54906003)(316002)(6916009)(6486002)(86362001)(26005)(6512007)(478600001)(41300700001)(186003)(6506007)(2616005)(2906002)(7416002)(5660300002)(8936002)(7406005)(66476007)(4326008)(8676002)(36756003)(66556008)(66946007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YC7ZpSaWO3c6nwIXl1I1baJNiCGDp9UeVFhiHmN4pffm1XvGbAMq9eu2remb?=
 =?us-ascii?Q?QCmBpmNYiE0QHW64d90+q1bEXSbztkgAcXn1nky6MmrrROUhTA/SzVfCxZad?=
 =?us-ascii?Q?SQ0wJGNH+xBWDD4RVN5BhYXzk9G+FnXhx+ULoeZDKAkYof1ILmmdhvca4pqu?=
 =?us-ascii?Q?t5F19JA4jM1Sxna+5wyA2IFCETjxy10k7P6bQHjayTm2DGve5Ib8YtdLn46/?=
 =?us-ascii?Q?bYufWsXV7KpeoyqMjfErnM55mMTJYY9eXBIdVDh4Y9LZ8DXNE9iTYtg0dAnU?=
 =?us-ascii?Q?kSm011HNwk2CGU8BBVrOyJAo+QzvFQ0pl1ROZ7g5m7lY4UeHkVIKjgub5xg9?=
 =?us-ascii?Q?jL3/H8Smpx4diwMHBcSIH6tTAqx5fgb9K8APbq8DzsCDDMhenJAymAYXlXQI?=
 =?us-ascii?Q?XS9qb9LTairjYMV7wAsf5oIARp18fEl+z20fHl80gRcRHGfWeKC9thpsoVi/?=
 =?us-ascii?Q?uZeWbMXf3XvrFCvu1TPNlfBWtv1zlBrcBLyhQ4yfZpjoan4pd+EOzTAxXSYI?=
 =?us-ascii?Q?XTTgb/ahDlx+53WAWFNQlTLPA4759e7Gy90dqE56DpZVtnyqQO0ED/8v3QY/?=
 =?us-ascii?Q?LUqNVEmmJKsQzet1EPYnKeB2t1tbav2i4+Q6a7vA2nheZxy0yMkVbdXJz3rE?=
 =?us-ascii?Q?Umhp68l3EDDhupBHJIHgoTRhURNvWgXljlFbgZToTSb0s1hroQaPqwQz+xnm?=
 =?us-ascii?Q?6Gv+xc5nADe2V3H0/pjwOtcjIuOR8b5eQ2ujiAGRswAECI9YhmNRcS1qaif4?=
 =?us-ascii?Q?7Guoxg8Xi8ktFee2qGMxeOKm0Xp5srsxw7Lta4K3NXwlC9SBzz0bYahmzTRe?=
 =?us-ascii?Q?rMoMXkPXhXZOCBMJWc1b8FpfJ1518vjxRVBa3xQuzLiwn9Mvk8mebISj7OII?=
 =?us-ascii?Q?VqKvOXA0jhKmrLW8NY/8xYfAD1DF5jVmhzfwlbCCrTa0wswi5fOgwyxwg19d?=
 =?us-ascii?Q?PbacvtBy2pm+UrLVbaIj/S7mnWq+YY7oIYZZCOgiBEsjkEKhUAFoRfMtvu8a?=
 =?us-ascii?Q?hL/5d4LP9N0SBvrY08VVHfbG246ZuaHB/s21dCpdf/V6/ZXUWTi0A/SLB6Zd?=
 =?us-ascii?Q?ppYT+NxtBJnKOhRdfaeVFEO5tcOcFUI2rFRwkoOqepf7rHBNlw8GmMosXm5B?=
 =?us-ascii?Q?hrRy//xwT7XGXtfIPOHF6eCOHDEvIzv+RNffcYU2UsWMSvDsnwqKADeGH1uc?=
 =?us-ascii?Q?ZGKKPq1r64P0QhdWvo6C76Q1rKvz+/Fx8Mc2+1GwxhsLeB4m4BLRhCR+uwnx?=
 =?us-ascii?Q?OK5rPpsViQqyrl9k3EgqS78d6YX9HgkFFY77uaI6Il+16NIniqmo9EjjPWKM?=
 =?us-ascii?Q?9w4Xm6p0GcYpcH7exul/jH6IUf8ztmAbUlM0kRGND8k27u3PpilCDEFyysvp?=
 =?us-ascii?Q?3aG+Km2bBwENSN0w5iKEsUtb36Vz6MYeYRY8WEtvsM1+OZG0+xJPYqvyRGSQ?=
 =?us-ascii?Q?+LZ17IviGu8rL5pmyjmpgKtzexyUs9jwnzixV1fcvSsEfVZ54KWHuN/0meca?=
 =?us-ascii?Q?j/C1YrG7KXcVWEnVkk9+uDnu5HcoebbIuncavvTLUajMfzJZWPZXaW3dVABz?=
 =?us-ascii?Q?770ox9S8tSBKtR92m5WJpAtW/IQOdFGpuMr5lSta?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3244c35b-ec15-478a-ddbf-08da9192dda6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 12:08:39.9112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tUARSHUMPfq9ikfUIzkS8+m9cKF5BR5O18RpHndTLj2Iu8lGTF+aGugMXsj1tm/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5982
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 09:30:57AM +0000, Tian, Kevin wrote:
> > But OK, I'm on board, lets use more common errnos with specific
> > meaning, that can be documented in a comment someplace:
> >  ENOMEM - out of memory
> >  ENODEV - no domain can attach, device or iommu is messed up
> >  EINVAL - the domain is incompatible with the device
> >  <others> - Same behavior as ENODEV, use is discouraged.
> 
> There are also cases where common kAPIs are called in the attach
> path which may return -EINVAL and random errno, e.g.:
> 
> omap_iommu_attach_dev()
>   omap_iommu_attach()
>     iommu_enable()
>       pm_runtime_get_sync()
>         __pm_runtime_resume()
>           rpm_resume()
> 	if (dev->power.runtime_error) {
> 		retval = -EINVAL;
>             
> viommu_attach_dev()
>   viommu_domain_finalise()
>     ida_alloc_range()
> 	if ((int)min < 0)
> 		return -ENOSPC;

Yes, this is was also on my mind with choosing an unpopular return
code, it has a higher chance of not coming out of some other kernel
API

> If we think attach_dev is a slow path and having unnecessary retries
> doesn't hurt then -EINVAL sounds a simpler option. We probably can
> just go using -EINVAL as retry indicator in vfio even w/o changing
> iommu drivers at this point. Then improve them to use consistent
> errno gradually and in a separate effort.

Given Joerg's objection I think we will do EINVAL and just live with
the imperfection.

It is not just slow path, but being inaccurate can mean extra domains
are created when they were not needed. But I think we are getting into
sufficiently unlikely territory that issue can be ignored to make
progress.

Jason
