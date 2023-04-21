Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD256EABBD
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 15:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjDUNeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 09:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjDUNeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 09:34:02 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467D45FEB
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 06:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+z72utoT802n8mA9cEBm3zvAD1HR00kQHCimvGzJf0/Yp03R9squwA8InvzSICEYuPvFQ1LMAi/fNTYk7DehxIQlEiBiWKLOHtzdOTAKsKT2DopYaCOgM5eJPWVl4nbLUA2KZTn0goDOreXhtWM1Hq2YdArPFHedpbFlE3/c4Inflo5po7W6fMTacxFcgkxu7TBSQQvSMuzINu40ZM2bVtYgqQk38OP6XDEvLb5zj7lrQDxMvWr3I6mC1GQXGthF77NEIli/k/ytIlmiPEHx0UwQtyP6EsT87ygMxEE/oN0W+6MAWx+PxdUPOxPb9jAKYng0AapomiePzr+V8gBEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iJQyMNvuSH8Mf3hVtUDKk5vqRT/iLfEa0GBM5g5CzY=;
 b=cDGol+XBHnI9w5LemUYioCI3Q/A1S8XOrukj6YwtZlMSYnFfggu6tzPkxDkWXZ/Ihh775BRKlyMclZoBpVSK6Ll15qyoHCMC9KyYKAskeNvZ41NNJFhd/ENq3yfaZWNbR07cO+Op48SnW0tFJ3G30FJpgI0OUMBBtcl6gMsGD78tdW+SvSdYfFtdBIjFUAes/+EaBhqjronjbPg1FRa0Zf4e+PAkXVOulqllAtf2zWOS1I8IIwP0Pz5a3akJGY1adNq3KDqbkpbPbGhqahoRYvg8bDliS88fb9sSjjOylw04Xz3FQgRVY5OoIyQKd/li+fncN+43YJZLxS4EAguD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iJQyMNvuSH8Mf3hVtUDKk5vqRT/iLfEa0GBM5g5CzY=;
 b=b6SNQUMvS1aBwBgK4+imHRKnW+qfIpiKWlnqxUYqViTm/wE96oIykqp+Qrvhh+3rw70wA7M0RBJVpyE8eZHpIYJeyPlGoXOYiDB4qJ2zeX+7pQdEaXZrew1ctPXjbcl656tEXMnvLjfZf+TLzb+Hu2wmzoPP+Sm1b4T1P16lYARkrUjO9qWdW8QrywzVMKsU4IvSZK4ZYmdkowUkHMWY1a7wqve4TtV5W6xZoKkZVep9eSoDM5Azps+sTixsxwkJKKQnCDhF9oVFsisFvDqCcl2nSP+o74ucc2cqvhyTmLhATkRM/zPWWkm1z8fdJmfLrGeDpC08dy5z8YQ1B5Yx3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:33:54 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 13:33:54 +0000
Date:   Fri, 21 Apr 2023 10:33:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEKQwVjJrMTUlPUR@nvidia.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <f0c46e67-c029-a759-5523-d598adb7fd07@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c46e67-c029-a759-5523-d598adb7fd07@linux.intel.com>
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fee1920-26a2-431d-645f-08db426d0d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OikNSCYtdJBq23GH+dd85knwdTJbWUuqWs0dbluz41fbDuwtpZRdZfLV5ZjXcjf5001NJ0dtUT1mu4SrC/D/GiW/IegJfYXQhPcsvAwWeBds42CYNeGx+Uyfw13mkKNJt7qLvmNRWQmAkOfv7wV8RGV9NH+dHBZdO56zv/+3zPZ6Rhb5wQBc5ZC+Gg8o7/vZgcb2cigG/65ewTMbiLhcUqQWn6Gs3gN3W82APwPf/gluLT8fY4vjUIg8SX2DQGVUrAoFS/BnyydfDuf5CA/ZORASCb96KLIoFO01BV2H/XsIvFb9CBCIflQdAiSGxEWpOeAld8Cuo1dss5VDq5aMltUZYJmjVSUl/zbC4IMpBmImnkIXK3sZXsgSiBJ99UEOt8VyTibxd+25+4raqD6hsEmxEKqNnLxxCm8Ht9h3CK/vwO+ORP38EA5gb9XOzaxsfP23sQxg/IYrwSmxsLm6VszZsj5nwN0DW7XYCYNJJwGoV6CNg8FYnDV70XYn12ZXkza/gfogOBIsoDTtdsb2qR9CKvae7m8zBQ55pLRONEkbZB+zlo1Gcc+DU7Z9moD4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199021)(38100700002)(8936002)(8676002)(6916009)(66946007)(4326008)(66476007)(41300700001)(316002)(66556008)(2906002)(5660300002)(186003)(86362001)(26005)(6506007)(53546011)(6512007)(36756003)(83380400001)(2616005)(54906003)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rku0SHCjOLnz+QjqMIDEBVcCKkg32binffUHLybrPz/mrlYLM/2e1vw4O1Q5?=
 =?us-ascii?Q?b3qEGZLL//dPhqPhsg7YmCUqcDCj4TnbRtzHsNTe9eqlyBZwnK2HQv7yGGcV?=
 =?us-ascii?Q?Hvv74rglDzuKPTC1LqN/HbvxErKWPnj3rT2Dz3HSPZ+MtZ2Lt1EJ3tKHIxUh?=
 =?us-ascii?Q?4AG1KMjNjmMW+dg06hoFZJaGJEpQjZtnsm8IlHNSQv0GbTxm6PBgwiX3eyv/?=
 =?us-ascii?Q?TMK6APwA3o+wMymePVjsO0kqw976yd2YDUOycRKQolIq1k/CmXxfx0nOV/3P?=
 =?us-ascii?Q?bKUSZwsSyz18dxmbKtsZGtg0V+Vrlg0A5Mhs80q2x1M4LRnrIsHs7Rouho6B?=
 =?us-ascii?Q?CLfDJ5Z37K03pfOWd7DV6cFjEDehBox4Ge3NKbFB7GEIbjnvL4a5eOSnEaqr?=
 =?us-ascii?Q?BMpAp8THw1pm1cr/Ogjllu1OB2RFK7Y1Hcr8wpBzrUYpqtJ4TB8Rp5PEONrP?=
 =?us-ascii?Q?NaDcLE42hTHefKSshMZAMD2O9okd4rFXF3IYZaKfqN+d0SroKJgPCS46tyhD?=
 =?us-ascii?Q?sV0XXqqtZtTKTCKQHjPgDFhu2rylizK2ROhJQiuz/SCg50yUznkKOqwNXM+C?=
 =?us-ascii?Q?lQhzHcEtGZnrmetMeU3I3WWUF5/tiGvclC2WZ1YnBvYY1JLMbaAcJsDyGt/Q?=
 =?us-ascii?Q?Ew1FkENHLQyksC0+YwUq0feZuE/y4Y0Y4Ub+SGMwgL+AWrP3AkV0eax39cm2?=
 =?us-ascii?Q?Y4duOXOKLT4Uu7aBA01hzXuSHeVIVK/shvWgl/x9OlNp01rsi/2kIa2/1D+6?=
 =?us-ascii?Q?sFY62fi6IzCkv/ns4uLMz68LP8M+NrSRXgpVMxxhjCT6GP6prxH1alSrm8Eh?=
 =?us-ascii?Q?I+sWR7wSJu9ZzTYWx15sddXpmRoCcuqz8qBrMeUQfBfkDEoQ1ZiefRugHyt5?=
 =?us-ascii?Q?5Asm8ElxzLoWxCz8Ke2fM60qziBPqcxnMYGKtIwledLILQyJ7T8wz5/FGC72?=
 =?us-ascii?Q?7Og1VtkdGul1Q5RSq69lpeYnao2FMdoUqlSpBZP9LQ2aVr5mirX5JrXROrq0?=
 =?us-ascii?Q?+QvvV16IYfxAOLFerdg/OdFLFSFtUM7XXm6MUuXK0Bp3eOdGtpR3SFar78vG?=
 =?us-ascii?Q?K0a7x8yCxMW1UGqjarIGHI7a5wpRenWSLwggq8a/w/W29gwYAofUADrg6+pP?=
 =?us-ascii?Q?phVc/0hBWrQ+UR3AFoIvK3Jv9YTxrl0jSTwBuEIAD916FdEx+Fq/kcerKX8p?=
 =?us-ascii?Q?5r8xcBV1BF1wvE2seTUN59BC1TJPmyE8vBtnsl5h7cDiefK6eZqHUoBkwFHP?=
 =?us-ascii?Q?y71xFPbl0uR15U8/HqUValXVFIRgu9SJNXWps+Pvcd05oLre7x7Z4bFuPfhb?=
 =?us-ascii?Q?O4V1j4qQTNncU8FATOn3pEZvYBtKR0g7bp/+RsNLdJTZgW2RlFbFKdM0XXfj?=
 =?us-ascii?Q?HYIG8YKGBTzNfPJWSfsFJ7XYHbxREjVBS8gY7EUkqk67ECQD6Aeh5EHWyRoc?=
 =?us-ascii?Q?i6WYSj0ZAoBpDh7Voz0erXYhFg+Tc2chYi2nuVjwcGliO+h1O0G/O5rrziOf?=
 =?us-ascii?Q?nsExwTwvKNfceD0gihVIkocZpTE5EkisDP/bzG0UdS8uUs8sI5aSD0QFPsQF?=
 =?us-ascii?Q?nsRLphU2EPdDPUWEy5PKLlvmA/sRuIewmypEmCkO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fee1920-26a2-431d-645f-08db426d0d3b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 13:33:54.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjbLj0TunE4hC2t84A84kSJr7sv8D7dLG9evWnvMUT161QwHUzQe94Qr7+NbGxUK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 09:21:12PM +0800, Baolu Lu wrote:
> On 2023/4/21 20:04, Jason Gunthorpe wrote:
> > @@ -2210,6 +2213,22 @@ static int __iommu_device_set_domain(struct iommu_group *group,
> >   {
> >   	int ret;
> > +	/*
> > +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
> > +	 * the blocking domain to be attached as it does not contain the
> > +	 * required 1:1 mapping. This test effectively exclusive the device from
> > +	 * being used with iommu_group_claim_dma_owner() which will block vfio
> > +	 * and iommufd as well.
> > +	 */
> > +	if (dev->iommu->requires_direct &&
> > +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
> > +	     new_domain == group->blocking_domain)) {
> > +		dev_warn(
> > +			dev,
> > +			"Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.");
> > +		return -EINVAL;
> > +	}
> > +
> >   	if (dev->iommu->attach_deferred) {
> >   		if (new_domain == group->default_domain)
> >   			return 0;
> 
> How about enforcing this in iommu_group_claim_dma_owner() 

It is more general here, since this applies to any attempt to attach a
blocking domain, eg if we future miscode something else it will still
be protected. It is subtle enough, and we all missed this for a long
time already I prefer we be robust.

> and change the iommu drivers to use "atomic replacement" instead of
> blocking translation transition when switching to a new domain?

That seems unlikely to happen on a broad scale..

> Assuming that the kernel drivers should always use the default
> domain, or handle the IOMMU_RESV_DIRECT by themselves if they decide
> to use its own unmanaged domain for kernel DMA.

Long term we want to get to the point where all kernel drivers call
a claim_dma_owner before they mess with the domains. This is our
locking protocol to say that it is actually safe to do it.

If we reach a point where a kernel driver wants to make its own domain
and needs to work with FW that pushes IOMMU_RESV_DIRECT for its device
then we should add a claim_dma_owner variant for trusted users that
avoids using the blocking domain.

Jason
