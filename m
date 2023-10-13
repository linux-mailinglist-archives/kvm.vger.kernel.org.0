Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58077C8C28
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjJMRQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJMRQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:16:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB9C95
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7vrM7vKewquPNWp94yCMlvto5ngnRN3eElrVh9VwCzrUf9yLk8J7hLqYKf0/ybAuDWDIGfJDCFKgfGVObDzymKSN5m4xmCkn/BvWXuaofii26w58x9v27h1m1//JOV9SpI/l8xxEhqvTOwK413PU8VFw3U7xJ0mHlXZznUp9cZ2lR8B5QUtbJwyO6ltSZLXmMR1qf8t2Ly5m+RuEOgydkr/0wDdT25T163x4ap3QnleZZpudxT7oy1Er/JfKg0neqE+3MS8MfLfyJAizmfzrUHNturOZjJ8JpdQsQnDH3h7GzzkQmKlHSRLqm6rjSvAyT+DDbe0i35YckFXIFLVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hqxEMXXYKuSPYKM4p38c6F21+LJEPobPlcmwn18+SQ=;
 b=ZcjwDO4UhgyiTYR07Hxc3Dn4GINQc2A5hfVgN14CtQHPqzxLSEWeEdPPGGC5+AqfP5Ns5sjFO5GB8h5OpA6Ogs/MHnF3eFZ1q7ajT3G9Uptcw0zmUkcj1xQxh8D6gSlTut6X6dSMSHQiEucn/yZ4u0n2zCoK9WLbemoRtUvCFHos+N7SCRVQ36Zf/LZrrnsMOll56CLXkLCgAMK3m9XaloQCl/qko0uEs+OwKK46XFnUwSInvkvTB2PvZOZ0O49JsyDtg14/ShV7/zU81akI/AGZZcqAwBwxZRyTCajl0rP/ruAPD7SvtjRoym1r7u9wOnCIIhLZ+NNgwtvfkuR6cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hqxEMXXYKuSPYKM4p38c6F21+LJEPobPlcmwn18+SQ=;
 b=NEUJGPdmHGgPRqYw/6uqsGizMjJItOXgj7pDtBjFh9ay308ydxd/5x9rOyFkuXDCr3morfpXpa3O+yoJLrM4uRH3adMIJyvQMOkXYrfD7PA1BCJAjhF34+haI0myBnzbENSWWBJiGWRzpDNDjuxERtl7T+izOOyD6TYeB6k57Gamy/homxLuaAo6y0WpyG8/7UYstvaHm67f0pqeTDj/tQWqCEESdYZ8oyQg9K5xTBOCMQWcRn1/AIQTF4MXC4Uyh3CTJz9k6tSkILu1U2WEhvuYK4JfSzUhj9YNgIWInEA8lu8MbAJ3F/YmXvJPQAZyp7V2PH9QXSRK7m/dOmzWPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW6PR12MB8708.namprd12.prod.outlook.com (2603:10b6:303:242::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:16:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:16:29 +0000
Date:   Fri, 13 Oct 2023 14:16:28 -0300
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231013171628.GI3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
X-ClientProxiedBy: BLAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:208:335::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW6PR12MB8708:EE_
X-MS-Office365-Filtering-Correlation-Id: b69d847e-86d8-4187-c699-08dbcc1023e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3clwo5xRfMxqU9pvotlYcq9W372gxAb9A6lF3Jpv8FqHgnnAhbqx8NzoBjGmUeL3r1EeDXb5Rcd4Zax66tHPLwzcWfF/k9luE6eCm4hTK+RjMP3DFcvAyth8cKaQWorRihqtTgq5rUpPii9qErivBN0aBkO1IxfI9vAQE1sVuwac2PmmZTBqJWQIn1GmlKCNCMP8QtiMccU4i1gq4gWdre+EEuZhN6D/T71OjC0yhbP8caXtz2vHU5ILkz+e081YWT3mhDTySpPhFXuW/fgCr0VIHPEfB7V3AeV8CturZY9U4b5kWoAxCXw1/PBn8i6BmVzIc1p25e3ImdLgd7EG4S+xfn22i1jjJwEIZrAA9fASCzQsvbjIRiXON999KJI406ypM+3i6ztYwx8Sq23LJw/fL5b1k+KjpWK2V7a1c7c3/Olb5G6E0fuJwuL9dy+WkAPqoY8G4EmLaxl5OL3wxk5fsPI1oKuQT31O6m/TF4cSK64r3cfNFqShelcG46lv1tjGKUqPyn2Oa5MJZC1SHY2I0DleRD53iNze/KrwGhUdOCc+M68AtxtWy6zt254K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(366004)(396003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(478600001)(316002)(6916009)(6486002)(6512007)(6506007)(53546011)(54906003)(66556008)(66946007)(66476007)(4326008)(41300700001)(8676002)(8936002)(33656002)(1076003)(26005)(2616005)(38100700002)(7416002)(2906002)(5660300002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vhq5++7fZXHfcoM+dsR7Zg3L8t6l1NXrg1AZKwlBx4hvYDYlKtRvRDQ26/MU?=
 =?us-ascii?Q?CO75/ha0nXQ10LqaeqPz7E5qkPSJvLVp0AiNoyKWcBLSrPssnxfkBMaNkQXf?=
 =?us-ascii?Q?Nnidee3EddedtDq4EuuPadcThN87TDf5jjIf8efQVXZEYIRC/nOjllaFCPB5?=
 =?us-ascii?Q?GMM8/bszb6/+jbtbW882wnRZr6up//xk8MnWJF1I4UZER5/AtmvctM1+Y4vi?=
 =?us-ascii?Q?19RgQBABrcsdJmqofr+m6w+rhk2N9v16d3ejTatcJlq3ODtuxMwzYywmyb8I?=
 =?us-ascii?Q?OEiraVV5RKAyL8dp9g4dXgE/bGOl5KgeCbvQ4oREiP5Ff/JvpOaN5srRhExm?=
 =?us-ascii?Q?5HOGjHI880Jg/uJVoK1jJRg7kFY6nFS8AzYSOuPvwfxWIChoNltzWCRLaJ+w?=
 =?us-ascii?Q?o4YW5Gm57OQxmC0mn5w27w/f3SD+axAg1/TbNWZovpiCIahIV64MoOVoNInN?=
 =?us-ascii?Q?pW9aRwvxSEFx3dUgHUcYIJ17wyi5ooWaffU7p4Pc5BeE6XdngDAy3M9DjSCs?=
 =?us-ascii?Q?wzrKzRsEkAUIBkuOTHrV91Cc/RQFXbgIoHma76gV7Q1CovCaV6W9lICDG88O?=
 =?us-ascii?Q?K9w0FCvW6j35gzg/De9abwizpJnRIUtTJdeUWZ/pWMfsX2gINPhTk716hcAq?=
 =?us-ascii?Q?dU3KhaFw2ShGrKQbaaq/O6Qf0YlP6mgPE/1PHaotNs3FAY4EaJainWjki6OE?=
 =?us-ascii?Q?HfI7HjbMGcjEnDmNECHIK/XTE4JI+KpsD+9RLIXPvrpKBWseTLsxHKKUC4bG?=
 =?us-ascii?Q?/lQQYzQk8wV7b+yamMlBdH6m6MS1v4UUNRftGdoXIimiF0IKm7FTvnYBrY3E?=
 =?us-ascii?Q?a3V0FZwx2yWx52LxNKPZ2lT1eVhrlW6WnCRWIzFe729bVuUWFAHzakVV1B6H?=
 =?us-ascii?Q?d+O8pR8mHVCsw+7fyMv47jtr3sxGcTmdo7FQ7XrXyopN+Fgx6PDbxdGL0M2u?=
 =?us-ascii?Q?7odfQckJ0XI75HJAxgVtj/SpctsAytwr3DG5LWj/EjLcXuhRLVfVFXsCr0hX?=
 =?us-ascii?Q?ttN7oL+IDnUcZLKXuGYumYqVKeeOpV3Z7MQs+ywkCgw7AixiuHWs6/d3n8WK?=
 =?us-ascii?Q?EDEQhCuq2TXsw31lnGEH+7VGuBwStpJHQR5NDRCUM/y0D7TvYBEuNgcJ3cfA?=
 =?us-ascii?Q?I3ggAvzG+lnR9E6lWIFWwb0e1gf9FTNoSJo8XLzQeuizOSPaRbM2Gpx0n/9Q?=
 =?us-ascii?Q?osJroeuPRI8b0r9oGKV0kCfHdbf8+7bHqZLHtpgqTFOSi64gwAP7R/mIfuDI?=
 =?us-ascii?Q?g3mUgMAYjLSMyKE22tz5A1wngb59kehC13H6PdGwhdlbW2qg+XCrQ06iPI3g?=
 =?us-ascii?Q?28rbNuqiVLTE6cCBRIugyno7sAc9AMu4ostXQyG92P5GloMBGR4pRs3PAFnB?=
 =?us-ascii?Q?Q4P2SjbX2n1/uvPof4OGapJIIRk8CrEc4Db3gCMf+H5GU98xdAKmqfvIw6ON?=
 =?us-ascii?Q?r3RYanGUje5tCpGXLn5/pFVO6J3vp4E6aJINUwmUtrfnMwfDWn+OAeTFgWTX?=
 =?us-ascii?Q?fqNyPKvKblnwxUTUjLyCKeYEj8FLl2Qz9Qg2kGJXX/qqBw06DlJ81echruRb?=
 =?us-ascii?Q?iXPHpZ+Xb9xvkzSVhGm6o7nc3uxC/NGsQ52NN6hh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69d847e-86d8-4187-c699-08dbcc1023e3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:16:29.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTWX3o0nWy28mnocjqQedM5nepCp1VmsqZPIEkOoWlE4xTCFrjaF5Jul2cxXHuGd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8708
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:
> On 13/10/2023 17:00, Joao Martins wrote:
> > On 13/10/2023 16:48, Jason Gunthorpe wrote:
> >> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
> >>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> >>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
> >>> can't exactly host it given that VFIO dirty tracking can be used without
> >>> IOMMUFD.
> >>
> >> Hum, this seems strange. Why not just make those VFIO drivers depends
> >> on iommufd? That seems harmless to me.
> >>
> > 
> > IF you and Alex are OK with it then I can move to IOMMUFD.
> > 
> >> However, I think the real issue is that iommu drivers need to use this
> >> API too for their part?
> >>
> > 
> > Exactly.
> > 
> 
> My other concern into moving to IOMMUFD instead of core was VFIO_IOMMU_TYPE1,
> and if we always make it depend on IOMMUFD then we can't have what is today
> something supported because of VFIO_IOMMU_TYPE1 stuff with migration drivers
> (i.e. vfio-iommu-type1 with the live migration stuff).

I plan to remove the live migration stuff from vfio-iommu-type1, it is
all dead code now.

> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
> essentially talking about:

Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:

vfio_main.c:#include <linux/iova_bitmap.h>
vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
vfio_main.c:    struct iova_bitmap *iter;
vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
vfio_main.c:    iova_bitmap_free(iter);

And in various vfio device drivers.

So the various drivers can select IOMMUFD_DRIVER

And the core code should just gain a 

if (!IS_SUPPORTED(CONFIG_IOMMUFD_DRIVER))
   return -EOPNOTSUPP

On the two functions grep found above so the compiler eliminates all
the symbols. No kconfig needed.

Jason
