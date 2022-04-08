Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6624F9597
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 14:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiDHMZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 08:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiDHMZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 08:25:02 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93C73AA78
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 05:22:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2V++2P/dWT2C1KpmIKmfTLkvNEMhAHCzKn9n5zhF+RgvhsVXXucfejwDDqurXL1t/5ISTBIUGvIuMlOgcVGWSMAfgtrSnhlbwR9yksFjeJuXM+lpYVg1REWlrshsSzn34iJCKwUZemoVy9qdPGeOD4uako79wnTr92chUe3OuJ3L3IRZxn3hzirOjiTP7/DHaJg1i0TukZBm/VVipsGDXBz4L/ECnOQ3nf49ZrTiVyT0Mzbaks7UNOHMpI0IzHvaA6hYIpts0csVSiIurN9DdHxH7uyQBMMXN78D8pn+z27JNqS/x7yWdfQ2rTSSA5FfiFbvhd8PBA5IGA2GPEgCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmnWGB/O9fqCT9FOA2V3rII6DQCvCsKVrk7SKvKGLwA=;
 b=BkG9wvFktqnsbrYhwNFGrySif6tZZqHbyk4GuK6QxptyITJtsoxEnFCrq+W8sYgtubCT0wxXgWYnZ+yHbKPzcKKVTWSSTwSlpsWmLgOpjwvzMiKIEoL0l5w+M5XKKEC/TjUKUuqXZyogOONjZdTmm6hLaC6IktBG9XsTjhQPpVWf46vavLHE7FNGCk+DLkoiTcDanXJ9HrJbjQgKhe/m/nAp6fuzz93BTzeDTPe+/ZFAsTql980gRGrlyYRNKOia/H7rdIMNVVoy3KSu/olvHiVOD2QWLVO+CcX3nmRj1VTCjD8wrM/F4NgX/uu6oDdRYF/nbaGJKUFnooi96XHhzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmnWGB/O9fqCT9FOA2V3rII6DQCvCsKVrk7SKvKGLwA=;
 b=DiesNPWPtyISmstxHYL4bcRA3U1ncp0FgoxLyirEUQ09168e0FJCE1JEL6KgbOWXxDcu2IChaUM70tWEA4kv0P7mDIEKgOOVSXoiJDn/Nm/pl/ApaXWJcHgKZGKVFS6fps2pCpLgfq53x/zWvMku1EyAz4BcWE61ZpeY4JaqqTj1ynrKjn/ldhh+lOU2SP4nmvvKXO0ZJltKlKj8+u9xfR6fkJ0rDufDTcgtszp+EbNI/4yO4ZxDbrqXnx8nH6H0DS1M4jAc3QhcElZFoUUFkEGQsbXuhOjgx1xU8p6QMa3cA82/U7J4m5ZEBxvBRmbUWrQxD6ptSjw/UuchuNnemA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3022.namprd12.prod.outlook.com (2603:10b6:208:ce::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 12:22:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:22:57 +0000
Date:   Fri, 8 Apr 2022 09:22:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 4/4] vfio: Require that devices support DMA cache
 coherence
Message-ID: <20220408122256.GV2120790@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <4-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB52764BF8AC747D4B2E2B8BAA8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764BF8AC747D4B2E2B8BAA8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR16CA0036.namprd16.prod.outlook.com
 (2603:10b6:208:134::49) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed7ae2e7-4713-4b8a-34a9-08da195a8388
X-MS-TrafficTypeDiagnostic: MN2PR12MB3022:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3022F03B051170EE933E7981C2E99@MN2PR12MB3022.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVFd3DQuxNtzN4v97N54lqncHm2vUsGs+/JG7+jlpI+pFwHL63uYuuULnyj6eBd73dFAI0NsFdd8CPtDdhQYXOY1HgkJV5CbmNNLDYMAzIAD+xC5ZiR4oDROovZ0AS178DX6MZ+HFCRBfZEwP/Sczx4UFN0CpkOY1nZQoQ2/41t4uqR9KMUPeYnUouv4LzHSYLs2XCjdQOBO9pifScTh3lhwKslK4oT7re6Cd0TN9US+TJTnTN888GY9QoYer4L0iWGeYXKAG7wiF+UyHbEXI7A8XNUfomRQ94SPWu8XLvQH2bVAcY+iyxfma/ybVn4/SUGUycGuc3P1lwMQBiZgCsQDzmOFzPxlWR89iK8uNPIZnyuEthRWShNfFP8ckIV8QRt/fj/2cpJaduP5WskqJI/bBQK4mbNR8Dg8BU0CRczk+WZhcY2ZroyLpHmXdUf/ZWDZ2HOM6KtEwDvpWahbn2jGT27QcBRWA3xaH6EeJMnpCB/rh2ki75YSEJrYTcBE6sW8ZxaVdu26Xh/BYrpskcr3a/uS6R1aRBKTkPWvuaWuDQCNTz33k8mV4BxGh2GX2kZQs/0BszMV2EZUWGYQgTfrWicHxBcq8BBrP+JbgetjQ6Sx6bARpu/8YeswCsazsSOAnYxqAdcMUHLaD0pnVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(8676002)(33656002)(66476007)(6506007)(6512007)(83380400001)(4326008)(2616005)(66556008)(2906002)(186003)(26005)(1076003)(508600001)(6486002)(86362001)(54906003)(5660300002)(7416002)(38100700002)(36756003)(316002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RJ9YInn3y7WX8KzDDtHFjXl6PSOUfFD4GQrbxWCZrihaXnCNhFvGLgzmREr/?=
 =?us-ascii?Q?jro0+zzfs2cgX8ePOVZZreIXZYdQFAmP/tx6tcJ6/yAv4i0xBBomeG2AozkS?=
 =?us-ascii?Q?Fm2WcRtZm30dlBPoSghEnE0K4jgIIVZmvanJktia3QQP+nIWrqmGk+yRXTPV?=
 =?us-ascii?Q?t1wSwBDmZXnABYqNUcAGnBjBJ+gZSJP4SQA5OzVW8v+hNZ8bkDZlOdfa7udB?=
 =?us-ascii?Q?PqCLBHcQIO24AHfwK3y+06N8UzUnUwhxXEe9xhgn/VnRno4YgX3HUVxinRUv?=
 =?us-ascii?Q?5ZaGaJkIcljXbH7LQPzgo3lhB7zuYtR1+KyvQtdfJG+GmpX/RMmG//DJ41Us?=
 =?us-ascii?Q?drFKZm5nqwlB7fdYGCiPbF1GzqvXjWeP8KRT51j/y+fDFLecbhtTcDiYD5ql?=
 =?us-ascii?Q?t3HZUvjJIl3/zI8Y2aJg/ZHagkY5FgfSwS+a/Iuk7DO1HA84nNaA9J3gQMGP?=
 =?us-ascii?Q?xWR28qYI0zvLOofzNLeO+pHUTPRirh5c4DeyBwmArdoJqG0dYEs8D9iSaPRg?=
 =?us-ascii?Q?bnrHQO6WG5w9m5hgAvdFqBWZ0ZsqOlFNRwCNGh/u2vhM66jW1nFoydwyY8ha?=
 =?us-ascii?Q?FPqc2HoirC6QC7Shh0VVCXEYy2qB9m1ExN/dkhy8bvyvv1862so/+eal0gPg?=
 =?us-ascii?Q?nDFY7AcrOwaezTnR+TjAAVuMQcWdJjRT9r1rpqQIWuXfYb55fej95E68zY7w?=
 =?us-ascii?Q?Z2kmD0hmkzC2+eaq2IvemOmRpzM4KJqUm4jo1CtwFH3a1rYIizqZh8ofdULo?=
 =?us-ascii?Q?pbwhaE9YT0BWPZfGCE0cYKFbW5zhKYoFqk7oNCHGsg0zHXcoDSvYvkXM7t07?=
 =?us-ascii?Q?TS8z4TNHpJwkdk7Hbk4fPsCfGDYX8wjcctZSguFF/3Ooyb4BPUWZ01XAfzDy?=
 =?us-ascii?Q?kGS0E7NadQG4z7fu4tTmQ3PFq0ohxWddUdLreNmintA0PWUNa6Js+O414tyc?=
 =?us-ascii?Q?Mc8E0E4hqTfGcngQOhtHtu0z+siIaUV1uvm/x1YmeZpSHbSDMZOfhkg8ruLe?=
 =?us-ascii?Q?o0EaP1lgxwPFQfBuI6lmEPcjMfkmpy6mH5hGa0nY6pfhB8eOThu4VszWGqLm?=
 =?us-ascii?Q?uyEpt3mFD5anxaGRcAJaoS1JXDqtxZZ53k5Z365GrA/XjIx8aZ1wrV4MC23J?=
 =?us-ascii?Q?1PHpGMOb5xwMj7TMVWbOXmoQGIPQShEd/ldThC+U78Yt9Icz3g/T8zUa4o9v?=
 =?us-ascii?Q?RpOKslvxjdKo9TQNYqLNVEAGeCjj68mbODHwaLjpGfJwqD1UxQZb2Yn8Fflj?=
 =?us-ascii?Q?zTsyGfoWrXwc5RD5mU6P90Gv1D6qmyzB2j0ATfSsSAXl108RuIO5Jm3uKHp4?=
 =?us-ascii?Q?birfM94IDL9wEi1hGosd2aVkg+SOrFQDtux7w+QXJZ+Ws+ExNtUke5a4x03D?=
 =?us-ascii?Q?47DgdcdDqMsPxQXOi/HHA9nLyMD0+C2J0YLaMpzPjbrfoBBldrRU0xOzMphd?=
 =?us-ascii?Q?XHWQxf6zSbO6LaBvxgx4MqFj4jKFbnCs2L3AWHyla3YQe7cmMeXv0DGJaWZG?=
 =?us-ascii?Q?hsUgVn5DEBXwcVU8pCeqSvt+e5pl/RxR3mFxER90R9zp57C9DZ7wgRhRbKQ9?=
 =?us-ascii?Q?HJQSetudzH4yERLeWFsjL2ZZ5OxYWmm4xHbDt1IkYaJM57AIVW1Pr/Rug+H7?=
 =?us-ascii?Q?7Mx7xtM3im1R1jY9sp37BW8BR6TTb1zremXigtwqVRQHXOqJmgg0kc1DFjos?=
 =?us-ascii?Q?zdoBWkW6Ge5TLGWUfZF3ZxN0UrHjlPkYuK6rEs5OkwRkbc4qtHx/3u6Dl3H7?=
 =?us-ascii?Q?LMILA4f0zQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7ae2e7-4713-4b8a-34a9-08da195a8388
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:22:57.2401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqW4u2vr1sSYkSlwOHhIxfOsqKi+lOZDoqAKCJvQU76WCWkahMlWOGO3RDQEKciJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3022
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022 at 08:26:10AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 7, 2022 11:24 PM
> > 
> > IOMMU_CACHE means that normal DMAs do not require any additional
> > coherency
> > mechanism and is the basic uAPI that VFIO exposes to userspace. For
> > instance VFIO applications like DPDK will not work if additional coherency
> > operations are required.
> > 
> > Therefore check IOMMU_CAP_CACHE_COHERENCY like vdpa & usnic do
> > before
> > allowing an IOMMU backed VFIO device to be created.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index a4555014bd1e72..9edad767cfdad3 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -815,6 +815,13 @@ static int __vfio_register_dev(struct vfio_device
> > *device,
> > 
> >  int vfio_register_group_dev(struct vfio_device *device)
> >  {
> > +	/*
> > +	 * VFIO always sets IOMMU_CACHE because we offer no way for
> > userspace to
> > +	 * restore cache coherency.
> > +	 */
> > +	if (!iommu_capable(device->dev->bus,
> > IOMMU_CAP_CACHE_COHERENCY))
> > +		return -EINVAL;
> > +
> 
> One nit. Is it logistically more reasonable to put this patch before
> changing VFIO to always set IOMMU_CACHE?

For bisectability it has to be after

    iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for IOMMU_CACHE

Otherwise Intel iommu will stop working with VFIO

The ordering is OK as is because no IOMMU that works with VFIO cares
about IOMMU_CACHE.

Jason
