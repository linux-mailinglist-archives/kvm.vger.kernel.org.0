Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3697C8C50
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 19:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjJMR25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 13:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjJMR24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 13:28:56 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45760A9
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 10:28:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLohNgVh8pgAg57AyKluZlTqD1fq5L0R9eXxFmsklfVY5hcULGjII9IAPdU4a2RW6flc2W7DVRnqXIaIMI3vZazOL7iKFmsJLiBifGgEYNZR9+YfnUPzXoAWgwo5SQJuQr7fnwO84MQxJPe2e22z/wI/3wARQX4U04+AdCtGUR4VQzdcTiXnJyolplRUdBzJvFD2w3+BnT9LulLGzEDx6bmWWJBssfA0k62pAm5SM3Ab13Vi/lKyiy/4Y+fTSQyFs7rVtMGebOPv33e0ZH5PJNDOOZs0aLTERRMj4HGfOHB9JUDAbTSre2LSE6PAi3/Wf+14GHbIonyXHUT5Z4TJLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj16gzOAXOs/UcVWTlKdBfyGvkTTqxl6XsWf9yjRXYE=;
 b=R0PSD65Av+mGrMfWFRaBuJTBIDsJj+AfC70+JVXPNufv57GfWg1O5TKm6n/Pb6Yolii4uJToHzaQK/2xgFkV0J+PSCj+yUfjQqqrinwgRFY5s4XNv2C7Cld58Drku11iO9xHicJ5eaDQIc0ab6AJ+MSpVSxjQS2Mbwzlb+BPB1/jsLdAJg8F5aFSbIeUSyfF15jsn5Ck7B4TTVYKNyaIzcCRIHqWWFmNXIwtyPWJVldgguswOsDMInYux0aeRFWJzVF6Q5GJT+AQmBzF2hfYzRX6QTCk2VEWDZm4toyQnZ/plw+aYUoPKHn4QIuCE0mNoVPiq/A2cS1nW6raJip6rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj16gzOAXOs/UcVWTlKdBfyGvkTTqxl6XsWf9yjRXYE=;
 b=mTqTvlLuJL2nYZa84ENSncIyUAGBTD/KpXz4R29LhtWTU8eE8KuLWamdCueoADG6Tlp004zA1dB/5jFt0WDVetBf+FBJm4AAzhO4otb/uHO1GhxsOghsYHhfMqfQUC+mHD5Awm75a4gE/SOAxryXhor9dxzFU7wKQlIrcmIEH03Rk8oM6RpI+0I64/WZscJVLiljMOPrgMSFxh5yDcsFsACOc/uL9Y0R7jemWJdw1js09BN5FcQqDsawjSZTQhotLDCehXV6xgp+M1jsqKQxuURHm+eqIeVnBP6kiS3X0nDuvnUBbeczw8QhfoPEJeKaiMMkE5XIzZSmxfQ7NZqBvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Fri, 13 Oct
 2023 17:28:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:28:50 +0000
Date:   Fri, 13 Oct 2023 14:28:49 -0300
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
Message-ID: <20231013172849.GJ3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7e8414-7d42-4981-b4e0-08dbcc11dd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HO0jeJ6QJDiKB1oBHe58z4eIFrZkUKOzWwN/0BvCg+cPWNh/U78WOKegeRjjccGdWdNfuCuGa1eegIx5DaCGxkQbWgkoYQM/ed6def+PsJn6+nLo0NakUeN07ndsc97y+dkUzToofV86j4K98Yztsha+EMxCz/4J8BkGIdZ9ojQztbX57FuZCFKa6A85IfZuFO2B0TszcimcZhmPWQHpT5+/w/hhno8IZMnK6T9RV4DCKom1jFmVusHHKjJz52g/s8imCt65qzbyg4dgAY2WxZVAdZnuSbGVyiyGCe3vO72Cglv7Le0Mo7xn64gxDoBkQIXbLCvfvmjL2+8L4nejwr2mIoRW2fqWhuRN7aXPBPP4SzRBf8ZIM9/4B7inxzGH/ZAUzZK1L+l8UG4FCN96Hs0s+LAKIJql6Gm6oPipxyyHV4QkhbF3ArnuYrRoRDU7sBW0Ppic3aMIT8cFApCJluvtoyX2I2LYszpWpAKvDVoTBinpqQbvjcyCOJRHMI0esYj44sa6Rw+80A2AJmWkqX/7slqrw5oVozNF/XgM5TyFtMj1Jbf92CT56GxciRoc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(346002)(39860400002)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(6512007)(26005)(6506007)(53546011)(1076003)(2616005)(38100700002)(8936002)(6486002)(478600001)(36756003)(8676002)(41300700001)(4326008)(5660300002)(86362001)(2906002)(33656002)(66476007)(54906003)(66556008)(66946007)(6916009)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dW2VqvPM7POn/15fC4cKM0Vy6YlCSgmOYVgz2aSZPJ4lKUydU6cw1UMUKjZ1?=
 =?us-ascii?Q?66sB9Qv+PnQmgCGpUIWtbPScFioAeNszWwnNgT7H058PDgrpPaX+F7XouUXF?=
 =?us-ascii?Q?SSPe3SnAXVVogxd2QeRw3rBzptayZpMUKAaJYkzaLSSsoUW26hY8mGc6O7Pn?=
 =?us-ascii?Q?XnbiZeQL4kovrYuU47/ksql8vGvdEAdZTIxLUT8CYPFNdCSyxQbx6E2SwRVP?=
 =?us-ascii?Q?ZnkcCME/jjxLnCWMvYaxz0zB01Kl8Cqk5At3L8Cc/Yr0W3i8b6yZPq23GdCv?=
 =?us-ascii?Q?XVKPwq7aLD4vFJlEQCA8UxQXpRahUT0q+wVR8PnIjdTUvOkhbraoiaYCmmOj?=
 =?us-ascii?Q?skLfq2WQXsLcfpwHfuGiMlS7rcuxHsUOlXhIWHdonRRZRqT74bcB/kuQpphh?=
 =?us-ascii?Q?UGXOLk456w2mtdWY/53T5NaLf1lzctkOoO8+GQZE57acBhHSqPbhJ/XrzEgL?=
 =?us-ascii?Q?phRVvrC+sOgQYByUivvf9nVqFbGrTlZnA9a29GwjyFvFJ/Rwb0uEqw0Rkcy7?=
 =?us-ascii?Q?pO/6+2ym9oMqzXePCTXVx5E+eqrMVWSPEO/Ag0eXNnK0hTcDkfqgmn2Ad4M+?=
 =?us-ascii?Q?9HDiVvsRIlyMVKwXALNS/4FKKzdOMtVCDppBVkK54aZUBkENR9RlAJtzwgm9?=
 =?us-ascii?Q?O5gE8A5AV9txvQqbG0pqiemgaIFWly1jg0Eox/093GylB3OecBH6wqcxT47P?=
 =?us-ascii?Q?etaBlV5z48M89qitqre0M15+um1vvf7p03cc5vH0KhQq+XnnJANG2eFw3Jtm?=
 =?us-ascii?Q?vN5CNkJlkV4tl4mCdfmbdtAPUle7WLnleQcXCPQXvoLGaqaCV9ErTEz6nQS3?=
 =?us-ascii?Q?yCernWoujCCAhs1qHN535UbpgJj1h6+dIpbOc4fB4EkDM/cg5Wd8SYEhOc/7?=
 =?us-ascii?Q?vJx1tC1p1HBDNAWHHcx30q0s6Lr1Qih9x1Jh0nGGH/bfKOf/VAmf9lOte0t3?=
 =?us-ascii?Q?aSufILPRdAUae4tCdY5LxItRAffjVdpKiN8m1aoYKlk9vuBFEqM5MZuflTvT?=
 =?us-ascii?Q?PN9XcKrhz00UBuDzLyPEDylS8n9fYjMkA34FHmVtbfZU8VXdUvPDb32Lw9dj?=
 =?us-ascii?Q?YrQ50x+etRyLhRN9wzFit2SXO1m0xAPw59Afa5fmHKAZ8l7kaTtU44+hFiFQ?=
 =?us-ascii?Q?ifMG9IGnQbFVcEW4TJEKpe23dkfBwg10lzFgE8/Ccr8jTTMPw24OaQpzqlC0?=
 =?us-ascii?Q?ArFkhYsRXTuLIY9WSReRBTZnqndsVvMVoGJT5tq8gZhrxPBRkN2mvo6iLhOr?=
 =?us-ascii?Q?bPUWAwY9xryNzJwlqDcWiQ52ylX4TFoZR4Wa/zeN6F3UJZEbRtcJ77RHWwWZ?=
 =?us-ascii?Q?C0pHjGJ2cXKTxXzLtH9T6MH3VPcwt1BIUGUSWAtPASBr/yhOvCSVWELozWBW?=
 =?us-ascii?Q?sny/OCkJxNVn6oXXefI4Uy9yLdvnBUY9mxuYKQIYsoX1/sZ0g3h5Tm18oa6U?=
 =?us-ascii?Q?Fdve9fqrRC1l6e+YkreAXDzR5/G0zlayU98Jm7ywkiBWCSy2VntO26M4BDJr?=
 =?us-ascii?Q?dlzm8RMtSGvx7ImKqSaS/X+j34RaqRTNWaCUbF/NWOErvlbEs6AXeeCa9MIC?=
 =?us-ascii?Q?WsIZTqE9m/jToiW3a7bWSdrOn00te8I08V75JOMF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7e8414-7d42-4981-b4e0-08dbcc11dd16
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:28:49.9889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysFUYkNamvdLefxOD0bjsCsXD2o/Jt3GRMsyhflKRh3ZWHYdrhRkgJaAee1OgCBR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 06:23:09PM +0100, Joao Martins wrote:
> 
> 
> On 13/10/2023 18:16, Jason Gunthorpe wrote:
> > On Fri, Oct 13, 2023 at 06:10:04PM +0100, Joao Martins wrote:
> >> On 13/10/2023 17:00, Joao Martins wrote:
> >>> On 13/10/2023 16:48, Jason Gunthorpe wrote:
> >>>> On Sat, Sep 23, 2023 at 02:24:54AM +0100, Joao Martins wrote:
> >>>>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
> >>>>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
> >>>>> can't exactly host it given that VFIO dirty tracking can be used without
> >>>>> IOMMUFD.
> >>>>
> >>>> Hum, this seems strange. Why not just make those VFIO drivers depends
> >>>> on iommufd? That seems harmless to me.
> >>>>
> >>>
> >>> IF you and Alex are OK with it then I can move to IOMMUFD.
> >>>
> >>>> However, I think the real issue is that iommu drivers need to use this
> >>>> API too for their part?
> >>>>
> >>>
> >>> Exactly.
> >>>
> >>
> >> My other concern into moving to IOMMUFD instead of core was VFIO_IOMMU_TYPE1,
> >> and if we always make it depend on IOMMUFD then we can't have what is today
> >> something supported because of VFIO_IOMMU_TYPE1 stuff with migration drivers
> >> (i.e. vfio-iommu-type1 with the live migration stuff).
> > 
> > I plan to remove the live migration stuff from vfio-iommu-type1, it is
> > all dead code now.
> > 
> 
> I wasn't referring to the type1 dirty tracking stuff -- I was referring the
> stuff related to vfio devices, used *together* with type1 (for DMA
> map/unmap).

Ah, well, I guess that is true

> >> But if it's exists an IOMMUFD_DRIVER kconfig, then VFIO_CONTAINER can instead
> >> select the IOMMUFD_DRIVER alone so long as CONFIG_IOMMUFD isn't required? I am
> >> essentially talking about:
> > 
> > Not VFIO_CONTAINER, the dirty tracking code is in vfio_main:
> > 
> > vfio_main.c:#include <linux/iova_bitmap.h>
> > vfio_main.c:static int vfio_device_log_read_and_clear(struct iova_bitmap *iter,
> > vfio_main.c:    struct iova_bitmap *iter;
> > vfio_main.c:    iter = iova_bitmap_alloc(report.iova, report.length,
> > vfio_main.c:    ret = iova_bitmap_for_each(iter, device,
> > vfio_main.c:    iova_bitmap_free(iter);
> > 
> > And in various vfio device drivers.
> > 
> > So the various drivers can select IOMMUFD_DRIVER
> > 
> 
> It isn't so much that type1 requires IOMMUFD, but more that it is used together
> with the core code that allows the vfio drivers to do migration. So the concern
> is if we make VFIO core depend on IOMMU that we prevent
> VFIO_CONTAINER/VFIO_GROUP to not be selected. My kconfig read was that we either
> select VFIO_GROUP or VFIO_DEVICE_CDEV but not both

Doing it as I said is still the right thing.

If someone has turned on one of the drivers that actually implements
dirty tracking it will turn on IOMMUFD_DRIVER and that will cause the
supporting core code to compile in the support functions.

Jason
