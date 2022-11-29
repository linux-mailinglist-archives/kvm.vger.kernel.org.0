Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934C663C0FE
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 14:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiK2N1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 08:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiK2N1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 08:27:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50521AB
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 05:27:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUYAxNtzEZe7GXXEmfs0dFULVPXOiw1JWk10P3ErC+ca5qs08CqTakl+LNXkcbKxmIae9NQVI1zlPUEICRi4kZlWuGVzRsyRIM4wG49skXp0btu5i0KSgatChD4j//SKQd9pchKIuBCunZItZCj/wOxNa21qBuSC4N/vg4NaWtCuJEoPzp3l04P8IGvCiY2bmbd8GoAfPpcxuYUkkM/5yeWA4WSKgcU8VkiYy01vhNbQrvBxSzPhtoQL0FhMIfltBxjz8RrBSDwnLro29blcJ9tBm3Cpwm+haORXg4sH47N+YyMKedqDE7BbsFyPCkGpaqXOw1l8fb1jL9QzIrB2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEmf9w50xb/e6G0lDHi7B/DG2rPSKgrSVx1qpQQQDTg=;
 b=DFXcDGJLGcQxMrmshsflPBJuk+ViFQyvlK/MM8bX2xqA9DHu0k5aNWaDwOWdh9slcpmxwbIpS6ezwyGt8tA0rq70MIV7jsH0dER7mEz76W1g9L0ZeiTAr4tco9Ta/nsq+7MzAB4l9L1+w8QzKyQNxB7p9408xdA6TVR8MpKDZMyLQKa52IrmYh7EdDsmEt8VeO97r5Pz6lYmIoSGvHc3KTD5c/vafhhAgQ0OrBTLw920C4srGfAHNQK/B5b5vM3jZMobxDsBShD4VPH1+P1wdh+KOU7jdwYl1b/6fpanjA3YNURZR/spf/FjVHM4PzUoqtj7gdP5rjLkreRcS3Z7Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEmf9w50xb/e6G0lDHi7B/DG2rPSKgrSVx1qpQQQDTg=;
 b=fmWHZQb6Y1yobPDiGncDu3VGpvuIS0spXsoNL6cf39jYpAuAW4R7Zo5C8D6yKX3S5pe4G0VNx9BIYt0Hq0+r5n9cztrYkjWz8KRIQ9794r2DZqMyaO5IDoEaHx+I4pD/UTJR9/VznigipxFFzHS0Iml41Ym1t2bain0oo95f0iwQ9ztnvQI/UOdtjwYrW5Sp/XpIyTR/Nk4b4NeSP4+0KvlJDPamhhz7nIn39ZjbGANmXIazgIQaTCxKPEj40WjhTQbHpz4bue9wrjbYe4Oe6h18rVuNP8gPSatiLr1yPDwbLvF08o6scGM1VcI3926NiJ4yi6FJUgK6iqafwMxmoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6455.namprd12.prod.outlook.com (2603:10b6:930:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 13:27:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 13:27:29 +0000
Date:   Tue, 29 Nov 2022 09:27:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC v2 03/11] vfio: Set device->group in helper function
Message-ID: <Y4YIwH5TT88D3vIQ@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
 <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4e180f29-206d-8f7c-cc20-e3572d949811@intel.com>
 <BL1PR11MB5271B4790C8C90FDFF813DF08C129@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5271B4790C8C90FDFF813DF08C129@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb10e0f-cbc9-4c0d-c55f-08dad20d7695
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOCWH5EWLw2e8iyLAMddAbZheSP02Xve9poVxIFWNH4SwP0A/OaD+moWxixdISaTYgRUwJcPllyVyVgxrQNkGdEbOCNph3GmioMqqxKJEc+uNuOW1GJ9FTn/rbZOopcsIpI4SjvKsQVL85Vul79dvCDPvKHx7hoIiCTtv4puqIdyU9wekTye/MNG9igMCX4ENMDVYmK+J1l29vctoLp/+7gQe+s4xD+krJo2rFbJLaliPbPPrmV+Q4OUdaWlRjuUYvXeUYJyOJOlNwccd3eW0/KpIKc67zQRjRJL+zaQfCHSs6wOeFCWDk93azAGVSKpNqQ92922oaQSohbwA5aZdMejV1h6jumykXHphH6kn9QodisPznv1Uc1B9MuWrzLnItfCndNx44BZyW+EmR0PkH3rSGZUaxlibJV3YU0ruzW7xtLGt7qFFLCCWg4JBEAaVGp05FNIUUR55oNgLBa6rF4eChU9eBkni4XYLUGfF0vdg0IZ41DVirMnqfhgMDuTsIrixAqf0hOE6y8953Hrew8213POqlhV/kRPniZt5fraNrN4SgR+jWquvjtPA+FWY94PTIm8NUicsMDOgL+etXXcLWKN1X4bZi+LK9TQBur5YfkwgAr7jvwUmOuaZLkt37yBdiTqiBFzdhJpU9V3cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199015)(186003)(2616005)(86362001)(6916009)(54906003)(316002)(6486002)(36756003)(38100700002)(6506007)(6512007)(26005)(8936002)(2906002)(478600001)(4326008)(41300700001)(5660300002)(66476007)(66556008)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hzQjmC0+kJzXTZ/nEc/eVLgpkuSh7brQcuzTcPi9JJzUII5T9X6HozDWIWET?=
 =?us-ascii?Q?i66h60Wl6lmYcfyDQkgpPXmAvvBV3JJqQV7MJWgoh6OyXfvr80hhwq8XZ5Lb?=
 =?us-ascii?Q?qsl1Cclj7m+HxKRZC6ozOc9ayn57H3mLuS5qYU4o/zcr5eKk1oZhuXRzWOSm?=
 =?us-ascii?Q?B54K9izRuMrwCR6wHAp5EPNlVsl81xEFWOcsN3HHKIWGbctlLddQ5bxAtHRH?=
 =?us-ascii?Q?kln9G3tsgpN5Fzp9DbIf7xiHEBdwBGqXA/ol1v5BOiHyDcQxaMjUzgZUS+vw?=
 =?us-ascii?Q?sLJr0TzMusiii6YmDZmXe6lUasFyXo6Fpee/EyqRXyMgCox9Ps3tT7d4Ir3i?=
 =?us-ascii?Q?qJuBcaLVmtGshE7Bgc1mLbF60VKlkAcJpVrBpEnsdjmWsLIe9XC5DWCyroRG?=
 =?us-ascii?Q?c7UEsdfqaRxRyo1K6XMBfYPAgWTo5Zt+6P0dKFcaCVtum90GN8FVaD2UXp1E?=
 =?us-ascii?Q?QKAwhqAXzY92IyK0NXuWQhpJR2+XF+/MPcpmqYgQa5N3TDrVfv48Ht1Uq143?=
 =?us-ascii?Q?751Aq4p9DbmquWwu09PhIBD713L0fNgdOYWbtTt3jzjXeK6yUJIEhtbYb2OZ?=
 =?us-ascii?Q?SKH34v098/GMEcpvrFnNiput6d8JM5WjDd4DiIFmAbFUgKWa6Svg5aG+kmff?=
 =?us-ascii?Q?KU3VBmYgcGxN+KNN5vmmqdB3mIi4MlufvF8HVPqBK3ysaS3SpzRvw3FmW07q?=
 =?us-ascii?Q?tTG9/uaql+VWnZu/zZob9ooYGes5ThnZL9SlnH8xu/tOUvmh5bdHMzcDirFv?=
 =?us-ascii?Q?Ca8zBzghvVdyXbXoq399vHU3it0FQd2GwWsNccIRng8UfnbhJ+rjHEaGkKrk?=
 =?us-ascii?Q?gbAsOhPjYHK7PYd3gQgvtNjh5Ehqck0iF2DkszjD0nx+KarjzKzv5sVT/EhF?=
 =?us-ascii?Q?6G7+BG9aFEakVkCren8TfQhBHncTDatR9emuoW5LNypH4jdrv9kdqgXovbvX?=
 =?us-ascii?Q?l5O5460IAsx5RgIPznUfzbQG4yfu7LsJ4jh06fzhrxgCa4h5FOU5b1orH2qJ?=
 =?us-ascii?Q?EB5yhrvoW4DfXKJGmozNteYbGkh+FMlPB0vWD1iIEmdR6UZVLlq2J05FN1Kd?=
 =?us-ascii?Q?ikWr+/O/tO7oOo6rGDEQJX5cdfPCpak90dckhpZYcMXX+wzNkWAfHcGsSKnL?=
 =?us-ascii?Q?ERzHbbGsw/1o9z/5vm42f3IHnIOUJa03D7onRUDuAUWxN8/aIdxl2LFcwNjc?=
 =?us-ascii?Q?wLD2uIl5SD7SMAyqMEMcZdn4JGttCUHXCDRDBxEZt+Q0mtbzd5Yxwqlt0cmq?=
 =?us-ascii?Q?9ClHBFxeJ6fvkVoMOesZQC3q+o/DXFqOnRgwtzQSDCSKbepAaR39uGtOdiQR?=
 =?us-ascii?Q?zGIgz4/ponszSl50n+RaCPZ1RPFqbGk2NDZCf7tO16NOuiPaTnsuoUWyNUlU?=
 =?us-ascii?Q?FjjkQXznxQ32GIAnwwWb5ewvkrnv/8CwSEvAhSAANL8DfwFIPJBDggxwOayt?=
 =?us-ascii?Q?uJdwZg6HVW36uwXeWNyoscGtaiGz7a0VnRs89+7A4J6DUp5QZBBux0ui2x8u?=
 =?us-ascii?Q?WMNcXhAlX4uWAsOeVLYsT4M2KTNxs8F8UVI9+tdpzHh39Mf9UoWH+CXHoUte?=
 =?us-ascii?Q?6Vk/u718E0yS2uJER4Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb10e0f-cbc9-4c0d-c55f-08dad20d7695
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 13:27:29.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMcannPRzMb1k92KitqL1IyAWxTKcppPdevp0/+8oEdsJMOz4dUHZy3G2j0kQzmX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6455
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022 at 02:04:01AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, November 28, 2022 5:17 PM
> > 
> > 
> > >> +static int vfio_device_set_group(struct vfio_device *device,
> > >> +				 enum vfio_group_type type)
> > >>   {
> > >> -	int ret;
> > >> +	struct vfio_group *group;
> > >> +
> > >> +	if (type == VFIO_IOMMU)
> > >> +		group = vfio_group_find_or_alloc(device->dev);
> > >> +	else
> > >> +		group = vfio_noiommu_group_alloc(device->dev, type);
> > >
> > > Do we need a WARN_ON(type == VFIO_NO_IOMMU)?
> > 
> > do you mean a heads-up to user? if so, there is already a warn in
> > vfio_group_find_or_alloc() and vfio_group_ioctl_get_device_fd()
> > 
> 
> I meant that VFIO_NO_IOMMU is not expected as a passed in type.
> It's implicitly handled by vfio_group_find_or_alloc() which calls
> vfio_noiommu_group_alloc() plus kernel taint.

The code is simple enough to check the two callers, I don't know if we
need a WARN_ON - and it isn't actually wrong to call
vfio_noiommu_group_alloc() for a VFIO_NO_IOMMU..

Jason
