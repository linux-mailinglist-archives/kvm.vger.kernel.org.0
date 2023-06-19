Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BF3735B22
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 17:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjFSPab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 11:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFSPa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 11:30:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2051.outbound.protection.outlook.com [40.107.96.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3C8B8;
        Mon, 19 Jun 2023 08:30:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvwkYyiOuzqB+c1W/oG3BI3nVqtmwPE9CMh3aLH1FTfIBxAbrtMKdWQpdBMMMk/6NW3AW4yJJhmVrfTLzQN7t2lg26Psdw/93phSGFU5qKKQYH/S3M5pSbW3182uzBsW/sE1Q87sbjUYMroBh92SkCFmj3QJqZI2FxgS5WV2u8jmZK8c+vzfuf3OYg4FfRV4ZTdxTf79+vCcK1e0P+kk9Y/SUQdYlCruSzGmozl1s/GtiWa8MIjuVNhdfDMGKuu5ldEMUfpxYLu6Yj6r5PSossKh8H4f+YsLhLyLsKEJjc/sZ4vXfU8j34uwLu2vIyJBeMoZqCvHdaA/lf1k9qPPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElkEMehmHQ16BFioE94BrMNQRr9GhjTdPz5MkzRc7lU=;
 b=IgkL12+PSK/lqaT6Zl+zsoGhZSLI4x9NIn7NvVQtGpQHkaeBPgaPGoP3JeFZZ4lY4jgEgyFfqMb4r+FjXWRtkhAYxwNU9/yrFFwCPqEuQxBAoX46wJou83I4KA3G4YRmmeIcKTU0mMhw+J6hkh+NcbXIXvX3p7WZRt9zoBmi8ANn7XUwgxnENbRR5fXPBcMkQw56e4Ap/MVjTFJmnUls6cmjDn6Zp44gAP8zmvOEFhmUl/rvDyF8mgquC27Ko7vv6FkfLZviytUbSXZB9s1IGW9gm9FHW7BiyMbdgX2iky2PIqFK5dN6Xj+4YKrOTLg0G1vel6Zfdv5BzZcyqSAGZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElkEMehmHQ16BFioE94BrMNQRr9GhjTdPz5MkzRc7lU=;
 b=q3OhNRlbcjAEzRhQFHQucpie2+ml6oHoDOWXCDO3N7y0g7OpRbjsCYRCLcBOu6beov+joz63U+XRGs34OSFBc9EVt3I6UdyfbzqoQQnJdvcy+txbro4G2tNycmfZKCQ2YSOMMNcumdMjoup0LjBoF3xk8WysDr7OI7nSfMU3LSh02wRoGxzdDbTmzG0k40d4HbuVogUZOMRrEEEcDmAMnYIEOP2b8zJpZNyuduiUYbidT9FCp6WdkGeeMnaytKW6krjEHvW5+IdwXIVsAm7xz+y/LwosYk1NxMSlMSu8QE9LVkNJSOXURvW9Os0sEPjGvCaWNOlc//CwmxCaJm3HKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 15:30:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 15:30:25 +0000
Date:   Mon, 19 Jun 2023 12:30:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Message-ID: <ZJB0jyMQpZXWVANP@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-2-baolu.lu@linux.intel.com>
 <5d0d6665-93e4-f61f-d700-008c0fcb4a2f@arm.com>
 <ZJBbJHevOa8mAdll@nvidia.com>
 <0c1aec7a-8724-0f49-bccb-6025f5863bb7@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c1aec7a-8724-0f49-bccb-6025f5863bb7@arm.com>
X-ClientProxiedBy: CH0PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:610:32::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 022926f2-32c3-47d8-77fd-08db70da1a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usYU88jerYII0JZLWR6Qk8Q7x2kTJugFkLnfZ21pg2juc23+Zl/0RcbqN464MlxLqpBITjS2AvTsRBLCzczqtBDODCSzX+oNpF9ETBkf1ZXiPC0jLNMk5jajye9GSn9mSvxR6/LJQfDaopJCFiASmdXOwkl8jyeb2dkasVs7DtjTWhIW1DEf27MFCWzIrfkb04P7eczCoY17FVEB/u07+mSA412F5W2yno2SgY4gekYzEsShdvw0/Z4YWLS6a13vve6K3MAXBJSgP5K19oBgZO/OMTmQeb9oam2+WfTHMhSu2bYs6D7ZItukAIuZlXqzT95QmfkSC5DeT9y0fBqiqq8HghxuhHhL0wcgz72V0znuY9oaSa1ZO5GtDymxr0kT7b9S+Aptt0yB2IU8p0540vBHFiCvyvESdTPK5yz3ciqxYoEDul14V9GVPoQbghZTegowR11cV4++2B1dedgdCkVB1j30QBFxMxZSPKF0yOu7pCcqz5+MQyZg4PncCMcWHR7Nis15A1EWlI9vJ/ma9UN/TYgECEXrcf0fiAoSFYk9aY6qNtLYr77l5YC3uAgd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199021)(186003)(8936002)(8676002)(66946007)(66556008)(66476007)(66899021)(5660300002)(54906003)(4326008)(6486002)(316002)(38100700002)(478600001)(36756003)(41300700001)(26005)(53546011)(6512007)(6506007)(6916009)(86362001)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cl5FLVGFI9mehQE0xvWxXHQ6JHr53OeE2vffWv0DRlrLnH+TkQ2H3MGfON9E?=
 =?us-ascii?Q?T8x9UGhxg7O662jA8CeD4xjZVF4qwJ+K1apO7KJh3sBeDTQfZopWSWUy7/wm?=
 =?us-ascii?Q?KYOcHlF3iT/+Z9qEWFtaA0FuH2BCGURYH6KO3imnCqYbEQaNI+Rae8ZQ4dDI?=
 =?us-ascii?Q?K+XMGOAEzF0+xbpR+y2I5WNXNwLPB8FHcCJ9OD9uuAfwUtA5q3KxfRxIDPvJ?=
 =?us-ascii?Q?huxlHiR8ay/Fz3TRqFq6ZmiVt4P4wcxfpDlUcTIIjBf0Tg0k1vRvj9Koh5f6?=
 =?us-ascii?Q?Th3cPAIRY+NHyYDK7qvigCem+nFAdzwvdgkhJETUd3kv3zyiSTFAhN/hVnk2?=
 =?us-ascii?Q?RCQdmj9KUvV0T2fwbO+r3PNUJfg3lA+pnhmaMCoM4zMcvrt4jWet5KLjx3hV?=
 =?us-ascii?Q?XQHCRF4Ppp5Ai8P75YwdimNO18OEA7bB5ZkvaimPlbKNaClZ0NIhhv0DldLF?=
 =?us-ascii?Q?0Vlwo91ArWL+RNGW1VACbkM/WqDPb/JtttkbpcdlJNnmqrriLFtVZrS9F8Nb?=
 =?us-ascii?Q?J9ddpXNUJ7MnBds7Y0dyUCgL3GpMpzIDsAIG94VHxMakg+ZewduSD99skp2I?=
 =?us-ascii?Q?zj0x3uB6Pvz6r/5wekmzqZi48NQwNxLByHydxhrKoSpdFJBqdfqAjsdfugIh?=
 =?us-ascii?Q?np2RPyKyegqs52UBzjuKT+P8VGolDg9F+31b8bOkFsYI5cDb7xLJath2wfyq?=
 =?us-ascii?Q?HdUjAoP2jm1T2LczO34DMWoQpUcatHY5vpYTxYfWjrh/iL6wxEPBFqiPawoT?=
 =?us-ascii?Q?eW9G55oaVblR+JrZ068pacBe9QeafeMpN/HmcHc2rG9+VrrdevnWr5Gw4c+j?=
 =?us-ascii?Q?VaET68LT2d32kGf/iQyJapazmlhDi97QQTeGlLCiTO9Uq8cPW4mk1WoOUuhP?=
 =?us-ascii?Q?pEuEkQUCtNjVQku568s6nTTnAFSTL2Meyzg66dT1ebiKrj66L3jXTlOP1dNE?=
 =?us-ascii?Q?Kkg0Utwws/hQuFtvSrlznmE+nXQiJQPyYZNX1R4J5sHey2k4Y6xAZnMGHPt3?=
 =?us-ascii?Q?YPYusR87cvoYvkaU8q7ZNL0D0w4p+zEhE1I+ZECLJvM6MI0f9cJhTcOpZ1uM?=
 =?us-ascii?Q?bjOK1oL6SX3YIQRHicaYx08G9WdLoNlrob3enLMW7l8PWlKcv4qkO/D0WnZ9?=
 =?us-ascii?Q?R4YrgBo7lxgRfL/+9nbJheworI0PqGJV5kKFQPEXTRL6VrZuuBqHYW4+N15m?=
 =?us-ascii?Q?jBj4+UfMHqlMTU4MbYDbrronpBvAuCZS4qv0Ibh6tt58XkFiPZ1CnqZbCGIY?=
 =?us-ascii?Q?EW+aT3d4c1QpQvq0g+l5PHmM9O060XuEeh78V0UG8j11f9pYQ5CmJQPIkmkw?=
 =?us-ascii?Q?Mp1prEFdSliGbqMPR0gFvafDyaHxqOBDk92voH3Mf20s0HvXzyBl3biwE/Oz?=
 =?us-ascii?Q?xNFnVu1PXXxZ3j6vzNhFuQaZbCR3dqBxyue4g2ruFwVTJiA47NUXYNl/rBLk?=
 =?us-ascii?Q?Nv6xgOxgnAe1lr3sH/3LAb3k1AXZ5fxMYEp00BTAb05+4KXTNNG2Uk8LWMpw?=
 =?us-ascii?Q?ZRX49aDSdXGLhFmrJhXlD8yj6jqHOszuFGDUMDrEgC4qZgXuAZ5t7Apcwb6M?=
 =?us-ascii?Q?sk9mlOyQX05PdEbEJrL1IQjRgqAXn6iYpuKzIQs3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022926f2-32c3-47d8-77fd-08db70da1a7e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 15:30:25.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRex/TUHQp06pBAtM9X4XJLY4oSBmHX9fPHQ501znX8GZeIXr0Ri2jB+Bm8Zz6K0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 19, 2023 at 03:20:30PM +0100, Robin Murphy wrote:
> On 19/06/2023 2:41 pm, Jason Gunthorpe wrote:
> > On Mon, Jun 19, 2023 at 02:33:18PM +0100, Robin Murphy wrote:
> > > > @@ -2121,6 +2125,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
> > > >    {
> > > >    	int ret;
> > > > +	/*
> > > > +	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
> > > > +	 * the blocking domain to be attached as it does not contain the
> > > > +	 * required 1:1 mapping. This test effectively exclusive the device from
> > > > +	 * being used with iommu_group_claim_dma_owner() which will block vfio
> > > > +	 * and iommufd as well.
> > > > +	 */
> > > > +	if (dev->iommu->requires_direct &&
> > > > +	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
> > > 
> > > Given the notion elsewhere that we want to use the blocking domain as a last
> > > resort to handle an attach failure,
> > 
> > We shouldn't do that for cases where requires_direct is true, the last
> > resort will have to be the static identity domain.
> > 
> > > at face value it looks suspect that failing to attach to a blocking
> > > domain could also be a thing. I guess technically this is failing at
> > > a slightly different level so maybe it does work out OK, but it's
> > > still smelly.
> > 
> > It basically says that this driver doesn't support blocking domains on
> > this device. What we don't want is for the driver to fail blocking or
> > identity attaches.
> 
> Is that really the relevant semantic though?

It is the semantic I have had in mind. The end goal:

1) Driver never fails identity or blocking attachments
2) Identity and blocking domains are global static so always available
3) Core code puts restrictions on when identity and blocking domains
   can be used (eg trusted, reserved regions)
4) Catastrophic error recovery ends up moving to either blocking
   (preferred) or identity.

> I thought the point was to prevent userspace (or anyone else for
> that matter) taking ownership of a device with reserved regions
> which we can't trust them to honour.

Yes, this is the practical side effect of enforcing the rules.

The other side effect is that it removes another special case where a
driver has special behavior tied to IOMMU_DOMAIN_DMA.

> assignment", not anything about attaching to blocking domains. Plus the
> existing intel-iommu behaviour being generalised is specific to
> IOMMU_DOMAIN_UNMANAGED.

Being specific to UNMANAGED is a driver mistake, IMHO. It is a hack to
make it only work with VFIO and avoid dma-iommu.

> On reflection, I don't think that aspect actually matters anyway - nobody
> can explicitly request attachment to a blocking domain

They are used as part of the ownership mechanism, blocking domains are
effectively explicitly requested by detaching domains from owned
groups.

Yes, take_ownership is very carefully a sufficient place to put the
check with today's design, but it feels wrong because the blocking
domain compatability has conceptually nothing to do with ownership. If
we use blocking domains in the future then the check will be in the
wrong place.

> so if the only time they're used is when the IOMMU driver has
> already had a catastrophic internal failure such that we decide to
> declare the device toasted and deliberately put it into an unusable
> state, blocking its reserved regions doesn't seem like a big deal.

I think we should discuss then when we get to actually implementing
the error recovery flow we want. I do like blocking in general for the
reasons you give, and that was my first plan.. But if the BIOS will
crash or something if we don't do the reserved region maps that isn't
so good either. IDK would like to hear from the people using this BIOS
feature.

Thanks,
Jason
