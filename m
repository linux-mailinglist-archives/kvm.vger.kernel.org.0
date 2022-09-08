Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C55B1182
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 02:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiIHAni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 20:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIHAnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 20:43:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C52B2777;
        Wed,  7 Sep 2022 17:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5o3TZxYnm40o3i4bFh7m2h9FKcbEaPahMkA4G3XjtuFq/dJldww7xDgLm3iMuSx0QeOWMdkXi0HItPMBb0tcrLm6kiDf/uyO8PG2tfCwVRM5kT3MvLHAqewSa5TuxyB1SNR62jIszTqnTPLxWw/H+qsPuF4/DOOiDfPcCMCDuK7aCB3PDccTqzyX/QP8ORIsmeSSoug3zvb+1oXXBYBld5QGxQZesjpVAghn28DDNX5YKbnm08nIbz5FCTxyRnedtuvV1oVQuQpNPS9aPDmNtOdWkr85mAkltoajQW8Kl13o6ikiTavNr9b/Z6rwR94XfHtH7GHYNvUU0wymd4Jfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfOcDBEgVXO7M7Msk8gAo6LefoAGPdujDTjf4tJltk4=;
 b=ig/BO1z1f5lNABM9/xw1qcrzt2XJfc56MhJrK3H+MBYZ039OytmbZDzsPynJ52+yQ/D00kXT4j3eyWqNiKe5Eme4AJYfJAxzmVYVmUK+eEFxr+5LO7WEoTNyxcHF5dDMBexHd+9AJ0A+1snt11P3YQccyxyX+q8B0wR+SS1VTbQeuKIdwyVUDEooHjr3Do89Xsj1nkrigI1aAr7nhUsevUu7spMoPtmYor26xrd2j6yS6FaX9aByEBgI1HnvLkaS5URRiyde68TOFXDdNTLJ6e4DhyY+dX/RUz8+pBPZTRZ7qNaovJE4G/bS+lskOZFuyV2KXqDQUbqxkTpZAqMg6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfOcDBEgVXO7M7Msk8gAo6LefoAGPdujDTjf4tJltk4=;
 b=nK9esuXDTHF86bApkiRgPNu0pus9/seJ8Qjd1935mZtMyhMayF3f3snT20FO04xSBJ/XhIVsOM9oJAPnpbL7UoL6fu3LLS3JHsMCiiYfC00Z227OQor5eh0y76SBTDhRUA/aJ/T4TpNKny7b2tbb1CkHHJ27lZS3rPJLJ0agAMFPwfkFMTvrOxU1HXrnxrFpAv8W3Yozmpyjnt2PbTlLSNdLAF3PTpTQJPjP+PRpERYPfiGDa4NvsF1vu4fx0/FfqWoqGDJ+UJ5Ox+9E2vpXJVsqS9C2hBQkomVYz2mlElLxUeXOZN1bEocRrOjUiauGvs3yks4/j8eKyeDVcjEr0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6786.namprd12.prod.outlook.com (2603:10b6:510:1ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 8 Sep
 2022 00:43:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.018; Thu, 8 Sep 2022
 00:43:30 +0000
Date:   Wed, 7 Sep 2022 21:43:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        alex.williamson@redhat.com, suravee.suthikulpanit@amd.com,
        marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io,
        robdclark@gmail.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <Yxk6sR4JiAAn3Jf5@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com>
 <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
X-ClientProxiedBy: BLAP220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcaf40b5-a886-4748-bbb4-08da913326a4
X-MS-TrafficTypeDiagnostic: PH7PR12MB6786:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2e7yqB3vrvU9ruu4a/VRCXep31ycUJNwiCKVB7GmD5m+ARbCa5NAfOVO2y0LT6wcMnK3eCFSQnqRowPqZiVzyYUe9kuv8pt6kFmgc+sILmHCpKmCMeBle1rn5RTWv/ncjtNUIOp1PQcfxeOCC+VZI6ceYOLmZiwsJAj5RSPfLo/fxtI108qL6BgQxH0h1+SK+FR4wQkVgWDNCsDjX6q3LexmtAOy9PcGZzJ92lRXilhUwDq/YNNpul2aSM1N9nMuP7VaPCP7d+shRxpYFtNrAEeaFJzp28w/QPCeHdMiKvKERGM3ZMOQHzSCCvR8lOJ6Mf8N+H3Oq3dBP0iZ34e9Bigq6A/SQh6AT0A8PVXDpd8aOmtKcttXfbwm48rZKtuDorq+isDlQn04OS5I++DTz7UvIG8UlFGtGNu+7efS8V2nmk0x1uwSoCnpp+DGlx0gL5oKLkEGWamIQ5qhK2yLx64u2WhLihJr9vMJeKcYd0fM2JkDw6QzJ7ZKjY8aIGV9dTWD5oWCbDv9pX8lSnMBJ5OhAYOJgIkf3vUBdtKF21MhjS53INr50bwx3nKJupeayIwH9pJSeasPqfLpc/fHcq1/29Z8lNJo11CVqDLLyE6/3OF9t73NA2XHd1wgJKWTGifS0Z2IVsS1kMMG4DcFCwn+N+MOdwxTJvJ3PiSqu9bxHWdOFb3UilnCXa4S1oBcny8PAR9XHfDhak0/xL3WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(6506007)(2906002)(66946007)(6512007)(2616005)(8936002)(4326008)(8676002)(86362001)(26005)(66476007)(66556008)(186003)(6486002)(7406005)(7416002)(41300700001)(478600001)(5660300002)(110136005)(316002)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PFGu8UtqXI4CTRN5ajnfKpn1Vjy1pzzQgVwHDc8FcrTsP7tHO4aGDTdXr0Cr?=
 =?us-ascii?Q?OpEbtPL/AkKZ//1h3u8V48nxpN+DkORFk0DrmKIKqpXE5/9DoyDksAgwXH5w?=
 =?us-ascii?Q?Yb9aKoK8BQV0aZHxZf4reJPUx+UmK9hc4HoDjaVDZMar6h6h93UX4uOGvsXQ?=
 =?us-ascii?Q?qVh5FeoSMBKiveKJs8ivvb4syTH5oz6ZjoeJ8NVt1nk4iG4i6vXiFksHi8+a?=
 =?us-ascii?Q?Fy53OgWBLhLY9HXL/F1dESRTtIsWw7ERpoI2XeBgbQrxnjL2XJxPxIz1Cn99?=
 =?us-ascii?Q?uJ11k4bpPiBbAAd9xjfRb8YIRdWDbzBn281xC7o2XPLu0CeA+xeC4d32LWNx?=
 =?us-ascii?Q?UlCssla2VH/Ina6gxXeCCcBxYYMF7ZoTu3V8S5OYsnZRq6dA5Js/3HZkv15l?=
 =?us-ascii?Q?vLFDfqMI5Lxw4WFuA0YnuZWKutvU2fTfk+imbuv9V1esY6dnZH2gAWCeO9To?=
 =?us-ascii?Q?lIf/mVdqLxPGIk+VUL16Fp4ZpBgVpL2ahknWUGyMaOM0mb8fLqaMdERSStHe?=
 =?us-ascii?Q?/GM4D4SPiWd3UmvzkGiE411bua2nZJcNRYwtdTUamBfamU6NLy/vwlFYJsBB?=
 =?us-ascii?Q?40SzHnnPYj7J3yA2xS18+bXXJot8V0H4u+DrNFEom4uVe1zAz5TTVjpOF01h?=
 =?us-ascii?Q?fQ/bM961O3W2UvjrZUENO2uMQcC0Hbbfe9HThnOdPJpwzCZ3Jk+k44oDsNSH?=
 =?us-ascii?Q?l0+DkTWyjyPaEy/l70DQxYq7Bdy3PYllZ5EBEiGc8mMb3PdWrFIHPcyvygHk?=
 =?us-ascii?Q?NBUJzTbA3LSoFBsoKB5E19kTU2LFgQGsZ8CKenSXoHSTOAn/GzqXZ4ggdwo7?=
 =?us-ascii?Q?YYcv7tt8Ikg7IfvTKW45hX6jTR6Id72PVQmP18gNzvJx7FeJnzM1sd8fiF8L?=
 =?us-ascii?Q?1JaeDL1FxA2CsHm2uA2UdILZ7IBPLOTKI1f0fpHhRZeYduN5s6HJtcIyvE8p?=
 =?us-ascii?Q?zTOQEGc4rqM2kbc6U89wrj+07Ok8HOJGYolNamX5oTPBQBUHGU2LIMLb+4eK?=
 =?us-ascii?Q?NlqKanjHL88OVFI3OHHkw6+RWcyxdbG7PYDoSfBPpO76O8PwfqwJLgl5UZ5n?=
 =?us-ascii?Q?vpb3mG0ZE/EMDftiHfiqe26++7hZN98ssmvLfEyqLslP5iRlix1ltNlVwynA?=
 =?us-ascii?Q?1xxiJKDmUlib5cTS8NCqnXw5gQjFYa19EpKPkJVJzDYV6hPnU1ytPU4hyhJI?=
 =?us-ascii?Q?+T2vfo717F811kRebId/pdt8yqHneeLE4sDaxDlQD+gTLVXhxkCU0yDlNxyu?=
 =?us-ascii?Q?gWzQnr1X1WYiAE+gCEbn8G0xVA0W8CHBojz4Ugzqz+NfgcoL83HQELO4kfy9?=
 =?us-ascii?Q?GN41sGO4nOlMxJeMhzWbN2ndPvpMjKkTO2kRpW6QowBKwdTjC/arWl85Ju6c?=
 =?us-ascii?Q?5/5Xj1M0cG6C4MYFkbePisFioC4JaFv3bZrZQ52DF/t1XKsg6Y2ilcb7zU8/?=
 =?us-ascii?Q?qXD0ZkZ8BBFTbzcDTluV2xDyDCNBFO5UUv72z4dxxvPaGH8fwEX+192fSphD?=
 =?us-ascii?Q?YRbJ626YyuKUcsjH68tUbZd5Y+0OOPCNV31dZMv857WLvCC8KZKPc46lyQ2c?=
 =?us-ascii?Q?OdJYLd12m/zDJ4zXT7oVV55TIyuptxrJHqcZ2ayk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcaf40b5-a886-4748-bbb4-08da913326a4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 00:43:30.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7f3il3fx2U/DyBc4XD+wKamRNl7Vp4SRqWpgvaNuk7fhKufGl1Ch0WCNR725EHq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6786
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 08:41:13PM +0100, Robin Murphy wrote:

> > > FWIW, we're now very close to being able to validate dev->iommu against
> > > where the domain came from in core code, and so short-circuit ->attach_dev
> > > entirely if they don't match.
> > 
> > I don't think this is a long term direction. We have systems now with
> > a number of SMMU blocks and we really are going to see a need that
> > they share the iommu_domains so we don't have unncessary overheads
> > from duplicated io page table memory.
> > 
> > So ultimately I'd expect to pass the iommu_domain to the driver and
> > the driver will decide if the page table memory it represents is
> > compatible or not. Restricting to only the same iommu instance isn't
> > good..
> 
> Who said IOMMU instance?

Ah, I completely misunderstood what 'dev->iommu' was referring too, OK
I see.

> Again, not what I was suggesting. In fact the nature of iommu_attach_group()
> already rules out bogus devices getting this far, so all a driver currently
> has to worry about is compatibility of a device that it definitely probed
> with a domain that it definitely allocated. Therefore, from a caller's point
> of view, if attaching to an existing domain returns -EINVAL, try another
> domain; multiple different existing domains can be tried, and may also
> return -EINVAL for the same or different reasons; the final attempt is to
> allocate a fresh domain and attach to that, which should always be nominally
> valid and *never* return -EINVAL. If any attempt returns any other error,
> bail out down the usual "this should have worked but something went wrong"
> path. Even if any driver did have a nonsensical "nothing went wrong, I just
> can't attach my device to any of my domains" case, I don't think it would
> really need distinguishing from any other general error anyway.

The algorithm you described is exactly what this series does, it just
used EMEDIUMTYPE instead of EINVAL. Changing it to EINVAL is not a
fundamental problem, just a bit more work.

Looking at Nicolin's series there is a bunch of existing errnos that
would still need converting, ie EXDEV, EBUSY, EOPNOTSUPP, EFAULT, and
ENXIO are all returned as codes for 'domain incompatible with device'
in various drivers. So the patch would still look much the same, just
changing them to EINVAL instead of EMEDIUMTYPE.

That leaves the question of the remaining EINVAL's that Nicolin did
not convert to EMEDIUMTYPE.

eg in the AMD driver:

	if (!check_device(dev))
		return -EINVAL;

	iommu = rlookup_amd_iommu(dev);
	if (!iommu)
		return -EINVAL;

These are all cases of 'something is really wrong with the device or
iommu, everything will fail'. Other drivers are using ENODEV for this
already, so we'd probably have an additional patch changing various
places like that to ENODEV.

This mixture of error codes is the basic reason why a new code was
used, because none of the existing codes are used with any
consistency.

But OK, I'm on board, lets use more common errnos with specific
meaning, that can be documented in a comment someplace:
 ENOMEM - out of memory
 ENODEV - no domain can attach, device or iommu is messed up
 EINVAL - the domain is incompatible with the device
 <others> - Same behavior as ENODEV, use is discouraged.

I think achieving consistency of error codes is a generally desirable
goal, it makes the error code actually useful.

Joerg this is a good bit of work, will you be OK with it?

> Thus as long as we can maintain that basic guarantee that attaching
> a group to a newly allocated domain can only ever fail for resource
> allocation reasons and not some spurious "incompatibility", then we
> don't need any obscure trickery, and a single, clear, error code is
> in fact enough to say all that needs to be said.

As above, this is not the case, drivers do seem to have error paths
that are unconditional on the domain. Perhaps they are just protective
assertions and never happen.

Regardless, it doesn't matter. If they return ENODEV or EINVAL the
VFIO side algorithm will continue to work fine, it just does alot more
work if EINVAL is permanently returned.

Thanks,
Jason
