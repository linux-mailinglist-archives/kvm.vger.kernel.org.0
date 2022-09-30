Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5195F1308
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 21:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiI3TzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 15:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiI3TzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 15:55:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE50C5BD2
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:55:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS91vp1bOKH+wGCLimgEJHGwYNWAT0T1sUAsvmUIPid69Z9Gsrv4ARQelZErHg93Tna2k19VcgVqNdM7QdK3592u2TxyDig9P3vjoMuAjv7Z53x3mc+PTAvEjerPHsElCox02YxSQo4DfsjYiGjWrnjEXZ0wPH6pBRLh7Zyq7DbEcoHwgcib48JmBFqoVkHK/x4VmtG6OSBAo6LvMTKqLnBPPapl8Jl7QXhBbutbgdwR8sAfgTFDvZaxvoKjlf92Mk+FVv5t5PL+YjWoNHSoIM7ZOsZJr88e0gBDOpOIbmcvio1s4j33s2eQqMlOAcvmRypVcAtURyfIjQ8kOiYBsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brCEzpmyi86GiSmdk+hBiEAhtynS5pyk31p2covQltY=;
 b=O2/K0MBcWDLvJOSTr8YgN5qERLCnh0Cno7UZZsUb2ADLMI6VhNZn4mmOo10mWwJEpzYiCs7O+iLs1LDO7QTOv2gti1FdjDYEvU7b1fk9anUIOuCH4mz2LWu0SC7TdaXaF55EH0YFb9JC5KDTaHp364t6ZcjqVBVbFvdCU0N4Ks0PiSXpOiI2/UhS23lVfYnTHi9uIf4D5SQ0oewPlAK5JMVn+SWZncF18cUfk3nB465ISLUyVxcgsT2qONDKotjR0BmtqwgMRss36h0E+MXCex3j11U+/QAmyC+lmed222nUkYPYPwpOXikPOWO5oaijxBdc7+VLPFFd4PMoBIx5gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brCEzpmyi86GiSmdk+hBiEAhtynS5pyk31p2covQltY=;
 b=ZaYwRM21hsdu5BleI4W23vU8XLkNyQMDXhAbZihUy0146s+OY4w0bj6boyj1bnPUk6Oiv58CfrVQBxWUMTrmqo/1mQ0JOF5x7xgMyJXaH4dIfBVl59QKiz1wICzL+CzyhSgYNSl2jtX46OEtUXE4BaeWk1YV2aF2YAY2UCWbLx/RzB9YaBUThftnMdHkSZQUuQ8A0NaM779x71la6f4kb6L5usvpOA29evo/o4LgG1x5rPIYRwf1BcypTNYtE+Zv7kA8BIRPk0sUIzAy4cy/jOYmvMnyZQ4G6Xj87o+BWdCL5S6swBOcLIC2bEK6KNOC0IafWEJ/33YHkeB0s36Skg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 19:55:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 19:55:10 +0000
Date:   Fri, 30 Sep 2022 16:55:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <YzdJnbNoVgfOX1A1@nvidia.com>
References: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
 <4-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
 <20220930135409.0cdad9b9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930135409.0cdad9b9.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:208:237::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM6PR12MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: 5125b85b-c78f-4b95-131d-08daa31dae70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OEDLGMzVuVpKP/LPLmBvfdyjXBQBx5mtEVigKa2KVEpzYoi6Bcx5XcJXpC0D3b6lKGGI/z7VxqK/SbY9XuMYojfOz2SCoCIB97z2k6SrEYRJYGXereeEvAJGzJPZLvgk8nuxVp62YCshhTzgYPHRQjRlEDVcvL18TfKeMLERcsvU+IjQjOqQ1Alotd8RTqj30mZgu2hK8l4k5/rRvRyvcT6W6/KdaRYC/ceVfj/u+lghcSOHcqw8idug12Id9F/sIciBy4VK8awOiuluM18wnLvSKSUt9qbcI4tEgCR1qalWwy2hXTX4yit0Yen4dkvae6XFgTL0fjgamRiAZZ9uvNY2SxCiYFId0Y1MqetVYyfH26tDkWBDeEpGqphIM+Zce2ino7LlgkkYNVcDRaP5Cpyd6ZgraurQUUZwT5lgMxvIxHGXc/Z7MM3zsb0klTBIEr34Z4BTmqSh3SxuAnT0/kyXpL4+cs6XZUysF8faLIIqiAsAFq2Ae76gsAn3an0dsAGk/vKL+EXkvcULa56XcF9c7SLl/0CMm2NTxglEomUnfoPWKpH2JP2zXCOHake7F+q/IJw4AtPWtcc2YjhnHh2hW51GPSNNujF6DMopLykpd93E6UqY5vX7mmoNBG4xOM0fwV8qeNanuVQrb3qq6nKgoXVYuxGfKmghsRJMp41fyueOb9VFjL0REbRLd5FaVRplJZCQKoGRpqDDKVIwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(38100700002)(2906002)(8936002)(41300700001)(86362001)(4326008)(8676002)(66946007)(66476007)(66556008)(5660300002)(316002)(6916009)(83380400001)(26005)(6506007)(186003)(6486002)(478600001)(2616005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/FCadADhvU/EJgmPXfH2/PRyEnASggVtJZZ4TRT86ATeW1vpeiAUUxJt5ZAc?=
 =?us-ascii?Q?JAUMG+PtO/vOkC4aETRcPllXEFeeKoQp9DWAS8Bn1zV5t4F4H/g25MBlndsu?=
 =?us-ascii?Q?rpZqOHX5oYP/XnhJV7b97VmO0ITjrZ8iU3lgp7fg8ObhDg0heKXs4BTC3cZs?=
 =?us-ascii?Q?2Rxp9Uovu3CNYRmnpFszX4JDYWuCb/G4ZJEWrFkm9G5VPgAWmSfoHZZJrgCx?=
 =?us-ascii?Q?xQ164Lb+iSnXwxAu2Bv9vKTnZnePI5+cD/13xA1aMzvTa0MD8yHUJI0fTbv7?=
 =?us-ascii?Q?XNzlo3o1jNIPfkOocNBF2SfgPXDKucLaI475ueLzHA6IQi8ybRqJLJdKtxDe?=
 =?us-ascii?Q?xtZPXd8eP775Bt4lusmv+79Sm+AhWqq7bGzlaVTXpdIQ5rrMtsmbyiYhwlxw?=
 =?us-ascii?Q?gZupvXGH8lWuCPQs10HJynae7umEZNq9jCirVsceY5yZX9bwb5hSz1fjV6eR?=
 =?us-ascii?Q?RnM16XMzpY08B1IbdbGDyJXOWVqweAy28X877NcJ02bLGdQtP0sKgFvAVnwW?=
 =?us-ascii?Q?Qtr2/BWMYGl+TjyPpz8c0hc7LMDgN0OZAo4l5WFgK2n/UmygNzp3nmYHaqdv?=
 =?us-ascii?Q?0fiA3dSWjRJhPmOs6ZsGV5/XoAfhg1Kni43S9rDqcrdrYJm/ldNKNPYGSzUo?=
 =?us-ascii?Q?t7A7W86scCA6nrly9rOeduyyx/3lhoymFSdCY5L1C6vVHtsV3PV8n7VTAUBA?=
 =?us-ascii?Q?qLRrd4XP2EgDQlKZEAz3e4stNAVan7B5PZv+u1CVHSXi5yTU2789CgRojjic?=
 =?us-ascii?Q?VhIluOXR0zdeBVrvN6sOTdHKT3P/kukzpj3qDozBjg0ZhfcEAcxh5wU0gxg8?=
 =?us-ascii?Q?gZg9hsV4ylD/CLDQGW0N2Z/Fw5iW3Lc7FHoZanUkzfV2gBMN0UzYSBP7frYA?=
 =?us-ascii?Q?odn0X3IDtL27ll+Ueud+/OkBmTmBsyUSSbblPpwbgSIMZKjwmIjMvKQwK82v?=
 =?us-ascii?Q?DsqDQ4m9YhFkHGaBbopQWZTMaWkMnuxQhIPHcQ4mgGt1B63Qmhg/MGtdRFgf?=
 =?us-ascii?Q?RF9Y8zJkPqTNQetkyLzXXiAkoq7+qvR9A1iI2Joks6tqU4abpqO7gkmnz3sb?=
 =?us-ascii?Q?UvuCuGWz5Gqie1BuQoIxwXfmZxwj3RTYfKRGjIQR4qnONLBHaW8obJSRLona?=
 =?us-ascii?Q?wlEluBH6g+KpE7lP94Z2X7z3UqYQUxJ2xvYOWBXzR14eA/KVxhP6K9QN5bYU?=
 =?us-ascii?Q?Ud5Ix0//Yokcy8q1EudvEGYU0ThiBVxAmtychfBaOql7rv0XqXeg/7978OWy?=
 =?us-ascii?Q?lKHNRSGzwzV5ddHbn6u60g691Y28JAmQuEQW8h/wJ4Bbc+GaF18Ow9Ux3lgY?=
 =?us-ascii?Q?7DCTudmCtfuS1FLUVZ5DvaZ27izqzqcI3FFJtJCqM6qhJSBZiVnNGNGxSnxY?=
 =?us-ascii?Q?nq5QJALeRWUWF0v8xlpTS9Qe9Oo10dlnjxa/OQma4Oe0ookyZO7FVvnlSm1s?=
 =?us-ascii?Q?JwD7txope9aTAp9RRICpaBHeTkV13EwU495tC4xYuyjiBEriAuVxdO135ZqY?=
 =?us-ascii?Q?kCB55P5P8aYZBJtevKsEgkWW9ap4paq+VPHe9bJ7NcJZgHoj/76uNkQ/Ag2G?=
 =?us-ascii?Q?DYh1xzrrbemsqvxL9cw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5125b85b-c78f-4b95-131d-08daa31dae70
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 19:55:10.3712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUEdSCAUPnNiTu6KHRLPMpS87hnPXVCzVSuI0TL2V4uxQPTZ+fhi7dxigpdKSYnb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 30, 2022 at 01:54:09PM -0600, Alex Williamson wrote:
> On Thu, 29 Sep 2022 12:04:58 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This is only 1.8k, putting it in its own module is going to waste more
> > space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> > vfio.ko module now that kbuild can support multiple .c files.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/Makefile    |  4 +---
> >  drivers/vfio/vfio.h      |  3 +++
> >  drivers/vfio/vfio_main.c |  7 +++++++
> >  drivers/vfio/virqfd.c    | 16 ++--------------
> >  4 files changed, 13 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 50b8e8e3fb10dd..0721ed4831c92f 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -1,13 +1,11 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > -vfio_virqfd-y := virqfd.o
> > -
> >  obj-$(CONFIG_VFIO) += vfio.o
> >  
> >  vfio-y += vfio_main.o \
> >  	  iova_bitmap.o \
> >  	  container.o
> > +vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> >  
> > -obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_PCI) += pci/
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 4a1bac1359a952..038b5f5c8f163d 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -125,6 +125,9 @@ long vfio_container_ioctl_check_extension(struct vfio_container *container,
> >  int __init vfio_container_init(void);
> >  void vfio_container_cleanup(void);
> >  
> > +int __init vfio_virqfd_init(void);
> > +void vfio_virqfd_exit(void);
> 
> It's the specific bus drivers (pci & platform) that create the
> dependency on virqfd, we need some stubs in the !IS_ENABLED case.

Yes... I missed that, OK

Thanks
Jason
