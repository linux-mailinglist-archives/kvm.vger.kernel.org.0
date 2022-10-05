Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D355A5F589A
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 18:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJEQxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJEQxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 12:53:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::61a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31111356D0
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 09:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7u9UYQ+fHdVvrwLw5WDIF+J+/nCghQa0RnCV+5cq1CPzzZvx71IacZ0V/FLJy8l1bnnhfbydYi/esYyl4SGy828iymyVIEjn6cSYrBjIWfWciY2DifNVSrmry7dWBQXEr1FzmlOi0Mnsh3UCwt/yBbZIcEgHIaA5jVLLge3FQQLEekgXTHgFuhWJWOMOtDgdkfmDvfICjyrxdfGxs13Ro6rqYnJK/Th5tdrfbrIS+1hpMfdN36R4drpmK6kc0yeaGbucYtBn/0r0Jof9RU1+p6wvcMZJ1DU3uL52JeZjJypqavEz1HaG5SF2HjqGTfuMFsMb+u1diD7NjkIlhWgCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNZbbsFkF2TXZih283SL1cp/GFVSrDHITcCaglAK6U4=;
 b=lLteu3gHX9dlVmzKM7Ec0euv8mQXOKNdQwXSsFYbDaiX5tytbGRNgkNJTuJO7baE1kQYWD9bgf/IJnvkfbGGtAqqxUM2PRcSYDBlvCIlBbXS3VpjKUu3j9PKFes2R7KRiZJljGqU9QYaiPDRc2yqmMmXP+m88F8c9zbcsqawPJAp1yln34AAjB+Jcv4hDMavoI20TYZPxi3RhXKradUdUxD53vBFe2ZLExjozkOPUuY+tt2nHqZfamr0G47h0BEzI5q7eSOkOtoa1b2+d+8nmBcZtEGo9wlsnHLuISCTDupGHwrRLuFe7GMsT5IDONNBG7YGQ/W3ihAGLagwMBbVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNZbbsFkF2TXZih283SL1cp/GFVSrDHITcCaglAK6U4=;
 b=dVneQCpJ/0BxkXnrfi6dl+cuu6cIp2PZIiDmV/jrkzHoHPmCTivgmrYTQDxvSJ/vMP1HkADDspOGGVgbkmzwF1QJfIi1WS3jpPqN+ebHvgsAevAZgI2cGk4qX2wsMc/xXPIutVFHCTO38H5r9seMO9fBMoWLX5POiis10C1oam9wjy9QzvjyZ/01wzzGaChHB5iGbSVc9bkwus9s/S4tFyLuuSPFx3OeiibmtzEUmZZjspVafOOlX5tcFy4RcpciquvsaAoXK4puM9u3oROXTpITd8vJhaP32S/4q1aflTAt52ew7w1hJhlrv4f80RmP+nzbVHA9RqCj8pOSEGVVEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Wed, 5 Oct
 2022 16:53:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 16:53:01 +0000
Date:   Wed, 5 Oct 2022 13:53:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <Yz22bCDQr3GQ45C3@nvidia.com>
References: <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <87lepuqlad.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lepuqlad.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0224.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 459743c1-c124-4560-2e49-08daa6f2102d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPbAq5ic9eAB24USnDVeDzs51IW6xn2bNBM/pZVc9jASfhM1XwdXBFmy4cshYk6HNbLcHYzzpkt6nI8sOH6vgIpLKqn5Vey9OBMCRAwx3YxBVjO89Y6k5Ko8Ri6omQUQ1NYd2UlcefTXsI09F4ttP7WhgCvY5O1gJuOWQlwNEBsu/u4gmHPrzo144kk7OtBJfLfVgWlZoSfEWAyc4T81KW28go4PS2KzHwEsLjMspb/P4eK3h+8Wz2sGJNn1/ZYGh4bbp5K/3NX6d0mvznPUDBCBqAn2+XQ/dIWfzvtt8b/pGAPyFdqO8UdjCZdH0uHANJLrimY8as7LFa3FDJNCzknpme7tulP8J08vDx0gH0xV1QV4K3fHi0cxTgt65mUpD6z/ecvJ3WPiBrVnbJXUhHMnGc5Mi7xaitWthIrFQiLXPPN8Nbg/rt38ZcBePmFtAlQ0LveD3zuL392fb7edbTSQ1usZG5JiZNkG8iYeVD3VX1iLyYNsZ7rOXTXVGi0qagRQurM5WAn0/sTmJcSOLYKzmdh5TkH5GuZyvcGXofgcL9lfPbz2baAR3B9CPYyEHypRLl6K2vCdHXMXLkPNU5pBOK9jnNfdS5CRrcrSdx+cgjGtkqHzDBH3ktDXgptleriFxzaOrHSklhsbwKRr+9yPoeh8oAP6Gau/BofHbkm5/ekEK4Nwg3vJNP77xfLp3pgL8lHkTzn99MVZ7cRDAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(451199015)(2906002)(66556008)(66946007)(66476007)(8676002)(4326008)(38100700002)(41300700001)(8936002)(5660300002)(36756003)(2616005)(6506007)(6512007)(6486002)(86362001)(83380400001)(478600001)(316002)(26005)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vswsaFBWuCKs8SA2L3+sLYaYe34h2VqqKu1e68oOyASiPjY95aZ6XI9TNumr?=
 =?us-ascii?Q?j3eOn5wxBnqHNluhOX4BOntE1ispIdNJVRDzYaiI8eu0buJVyR6en5A0iu2t?=
 =?us-ascii?Q?ucuDcQm7Lc7zZzSyjOkRu5pO+MduLam/Jm0ca5q8JntHb2g7I/IoBnjSNcVB?=
 =?us-ascii?Q?vGMTuMrnv6jO6sPplscEF+reitxfEn1ILTkfjvqnxp6+eJwZi4nGvD9qzUma?=
 =?us-ascii?Q?jUU1pV2k26TS1kMnLboN1fRELWU/2ItlI5SIDQNn/LK7Xlhkv0ZGwdnVlYep?=
 =?us-ascii?Q?9JBlEV21HTxYcEcI4svQ2nedTk66yu7TLfbUJXnhqAkg9aZdS+QdHSHywOId?=
 =?us-ascii?Q?SuJNSdJeluCPTWU7mMOvXTXpRbNnbwoFQiq85SHC7ni6spBiaJ0nQfrbiK7W?=
 =?us-ascii?Q?aBCu8ck+WBgosScVudYqWO6qVV+Yzatr8/OXhMWdG1WkJyI2Zl+AqmN9elWd?=
 =?us-ascii?Q?x55OacI80ZLDBB8wB9YdxcwMQ83Sd27zWAtt0EuWRSwAvsBV1QwA1JOUJdJp?=
 =?us-ascii?Q?2iXKz4PCMsOwQ+leaBlMEtCrEuQ2xoVp15VnkQK+hfiAb2/LH+wjH+kLMen1?=
 =?us-ascii?Q?Jl7jBz8CFoI777cmojPCFJg6Bk/ms3u0owxYkMh5tSMNEQLCjJ5mQIGMyn+J?=
 =?us-ascii?Q?uagIMMN6yRCGg2/hi5D/SdiION3pwP/3+WcoIt2jIM1djx2dT84ccjBnIewd?=
 =?us-ascii?Q?zHJjsyzXi5Zbud/h0ed5D/W/P42MwBwSzgpNER8zvqrwYAGtecg+EKiLtfAX?=
 =?us-ascii?Q?3go2k0fuBHntfYQ7J+hQDSJmUc+g5yyo/OA7yLOaLAcSJKabCd6Shmieh7LN?=
 =?us-ascii?Q?WfqIOn+QSw3QuXbPszP9vCYzvQ4/cZTOr6uTup2a9/nifL6+8xiuKSbzjmVp?=
 =?us-ascii?Q?ptpuHX/QCxlHaev2TKPDW91q026pwhMZzzRi1B/K4oXSdTweHTjyfnVE69td?=
 =?us-ascii?Q?PSh70n4rOrIO0hug5XRqZCHr/t5dfFJhwrk1uIDy6rB6ZyhxPI51vs4DIa2m?=
 =?us-ascii?Q?I4uRO+TtkdPsNYKLCZnEz7FGxpcnN4A0Kx+w0kFmQUvT/JXRJhzwLxqo9YlK?=
 =?us-ascii?Q?OrwIhBu6nzlu3S5/yEKy4l0SVlW0GTy4tIdFsYIYXpoRL6uWEqQOu2qf2+gY?=
 =?us-ascii?Q?dkc5OmKCMrAU8xv0FaKSBAHvsuWKwv6SRJiTOob/UYgdanlYzpnjb8YqkJ+T?=
 =?us-ascii?Q?jErH9fvCLINNjlRhUsxvJpqW8qVuBIrd1RTzH4LyY7AZ2GKudNVUnKslMAGY?=
 =?us-ascii?Q?abgSbC0gjb+iZJjpu13M30nBNkyfQ63eWMGQE4K61QjbkhtWxn1k2zeeIZGT?=
 =?us-ascii?Q?7WsffL/BHwRsfrmMB2+7slX4EBeqIOKDVR7NHXSBK+oMRtWbVf82jJGdBN4a?=
 =?us-ascii?Q?YrT2fCK9u5f6F19WkkLv0CyxXM3D94T8Sly+244INZzkoaL37fGVnS6//e6p?=
 =?us-ascii?Q?wzwNyOKZ8to0f09DfRFGJS402cx4/1IabgzgRI9WrMxv+GFKDeIwXcwXWblJ?=
 =?us-ascii?Q?8jwYyKt26nPwJxpIrfvvekmR2ZSUr5p2Su+uCVnMv2Z4I/3mmjHgYS8XwM+S?=
 =?us-ascii?Q?k//5NHDdmobbPQKhb2g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459743c1-c124-4560-2e49-08daa6f2102d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 16:53:01.1604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgT284C5zCFFysrqPSFsYW9BdC4RXOndx3sIsahR6JngimFZsPp9OEAbTPMbORfG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 05, 2022 at 06:37:14PM +0200, Cornelia Huck wrote:
> On Mon, Oct 03 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This is only 1.8k, putting it in its own module is going to waste more
> > space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> > vfio.ko module now that kbuild can support multiple .c files.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/Makefile    |  4 +---
> >  drivers/vfio/vfio.h      | 13 +++++++++++++
> >  drivers/vfio/vfio_main.c |  7 +++++++
> >  drivers/vfio/virqfd.c    | 16 ++--------------
> >  4 files changed, 23 insertions(+), 17 deletions(-)
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
> 
> I think you need to make VFIO_VIRQFD bool instead of tristate now?
> 
> >  
> > -obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_PCI) += pci/
> 
> (...)
> 
> > diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
> > index 414e98d82b02e5..0ff3c1519df0bd 100644
> > --- a/drivers/vfio/virqfd.c
> > +++ b/drivers/vfio/virqfd.c
> > @@ -13,14 +13,10 @@
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> 
> And this needs an #include "vfio.h", I think?

Yes, thanks, I picked those up from zero day and will resend on rc1

Jason
