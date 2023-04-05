Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C46D7F79
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbjDEO3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238622AbjDEO3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:29:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BA66A4F;
        Wed,  5 Apr 2023 07:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIYi3oTtK4YLI25uH7kXWjufNemQJuLNXL0qaHFnYWPInVEqQGvXghFKDlhoguidEBKsI6CAfHesih2gGIs4aef/b+jkXnFoi8maPQcul6OwxHKBH9t1nIBravdXrU+p1vZ0UgnbCP9u7Exd6YP/AQKPwg6lfg8UIQt/T/QPvgV8z06PEJ6DJQQqItrQ9Ov4zNI2nMXVyz3qIKprXgjAZOk9YGN1WnrPvj9O+s+RCRbQJfhXIOLqXZFtAIBP46N2LwOO6/FjpTSq/haGm/83/AzRQXTh+d2Rdzx22Abe+q1l68YSak6DZbJQynVnJyvce+eY7Yiba8/r4ndNGUQ3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdBzJJOOsm0vozrFvgtLnPMwzDfIVb+x300hbLTPPWI=;
 b=DFVNwO6cYX1o8sRg4RTf8VSVqAsi5KF0ahYKPEsvEGvH6bYee5MAqYVAjmYG6Txpa2JPoj1Flvo5qNFCZ7Pu6rzcascPs8/tgna23nxhZ+oZGmrjxfH6NKNhK5bznhBoJSWNRSP6k/t1W9NjMfo7TsWgDTLLBma+ZUWCcxGRs82ArJ6b5TH5KqsqJGvm3g5VK634vl7wmn1l6IyY6FiSP4LfgubE2PngpVpl7o5Ctjg6uw6hQdjnJUESmBTRaxyPBuTU00nJ5chrQXLzoLobRfa5i6s0B+RYP8ZPLdnAxKCDkrfswOinBoo2kzA+AwJVp2S7zyZ90fyZbaamAWWFwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdBzJJOOsm0vozrFvgtLnPMwzDfIVb+x300hbLTPPWI=;
 b=SZglbNS0cA09Zp6VJPL088XWwl7pO0/pFIP5ZVv8H+w9I2/8uEU+eDZf+Ws7Z4MCkmN77tWq+1vykYqGRL+rtfgoQM3meb7ISa0Gd1/CyMRq0I0RZKdYZpKHTmhqefG7SBV7sL9vsh3Sv50jkIS+nF3OKRgR+FiwrZ3QA6cK3Mogb1HHoUrc8vAnd4YQMKLkKG2cbnavAySDqe/2AgFcUdR+mzEkV0trLKO/pWxmd+RaEfhcQykCefYrj4IVIxDbAtnXNShQpAN8zRALPioS1sQ1EHU7BrKxU+fvl10WeS2DdgHJlj9zuozpAyRpm7IivDZ+CUREcaDrXdeqAXpHhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6724.namprd12.prod.outlook.com (2603:10b6:510:1cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 14:28:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:28:46 +0000
Date:   Wed, 5 Apr 2023 11:28:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Message-ID: <ZC2FnFmBldTnKeaB@nvidia.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-17-yi.l.liu@intel.com>
 <20230404164512.37bca62e.alex.williamson@redhat.com>
 <ZC1h7PyuhEg3ZMcj@nvidia.com>
 <DS0PR11MB7529B223F9091E509DBF351DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B223F9091E509DBF351DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:208:15e::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 433928b8-e225-468b-ad64-08db35e21066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /cFF4UPxdlOlJcgVMsTXTHARvgPUJnNd5Bx4keQno9iQPv29lZ9BaCYBOUmw9swR+GkOIk4q3/yTO/GjaaWni7Y3zVtgwxDCHwhhmIfyTlY/o7LmLvV7gyvk8mvmj+qpO0WNCbN98ETDzicO8mJ7l5hZkMdqtWCmP089xvv1nGjv5J1JSONRkq/UKzi9wzY7tptFmb8mOpGWF4JsoF2zJM/sh8jddUuIq6GZINndc6Q+eqpcN4dx/vBNN2KyTK0N+TmIgZ/FNFSpJ80dMY4J84rpg7XUmH5M9ZhJJByCCLrA3D98n4w25pM+HjrepfiT/r+Udqj3dN2sXH0+OtXygmYM8q5pYpnE9eAwh+8xRDwEeogdafbxLLyqgTU5NZveNmF18sFYSE6MNlb2sKdJHduoLJPRQQZS94TsCWX9HRwZSWIN0mh/nvvZB+SKpFk6UXM/WqGT5dQ1IZrpNmkIr50sSrls/Y6IczWbtjFQ9xg4pHjwJvR/pwEoTBz0jp13Qfzo/lefCqW3wSv0Xipm3LyEZdKXPCTqH8vAJz8GHcxgDOjc8zmP4U0Q+PJ8ze1WgvIJlAGqR46KnwSjqMwpxM843tEpjt0vjbUBCDrEXLc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(4326008)(478600001)(66556008)(8676002)(66476007)(66946007)(5660300002)(7416002)(54906003)(6916009)(316002)(8936002)(38100700002)(41300700001)(83380400001)(2616005)(966005)(6486002)(186003)(6506007)(26005)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LAEtUXxN5TROOGs+idHy9uvyDwYNK252Zyo/ykUGG/djTboU+VRLpQwpfoLG?=
 =?us-ascii?Q?8IiS2YGKP4HIf4ylP9lyL9tkaeRk2UVssmUZjjlmUoHG21jLCm0Xsp7UiWdo?=
 =?us-ascii?Q?nHAM2BTyNbD6wDrr236wcN5YGLymIMC1YJ327swvhQ5QHaNHQ50b6Q+kkj0j?=
 =?us-ascii?Q?qskkZwuzpAldvcBHngHeXs66IsOPzAvHbIFmnkS7UwU24Xp/k1YyhcAujw1q?=
 =?us-ascii?Q?us4K9oMSGBioaZ0P/UrNp2OJIY5EjD9tnbeHnBNWPooxdAnj2RemhCzA3AE/?=
 =?us-ascii?Q?l2V85/dm0o93GR+p1YrauJfjEbaFd2+xfq0p5b32bYXsdHVlrUXBTjYNf6nb?=
 =?us-ascii?Q?AMdfMwGPqpMtoGetYZAbFLShojOgS2BQNUBm0KGya/9OSmdlrdwm0qH7Dx4z?=
 =?us-ascii?Q?KEz+Nw0ldU5bY7TJ26oxErN+4dO3Q5HGVd0m7nxZj3A39yqEtKGDbFTF9uZ2?=
 =?us-ascii?Q?MjvYsYe/jtE37YVKA88JGRoKPSIqYAXrB2Q3jWnMYSDfyXuOEMSnC06QNLK3?=
 =?us-ascii?Q?/ZANNkdwXRk4UwNu45L6GRLLh707LbKDGYggHsQ+YGuGQG04k0JdaJuCce2g?=
 =?us-ascii?Q?YgOessWWwcn2KAtrN+jD7sFXX7AbKeLo3yrw0p5y0fkNVmtzQh1b/7pzdVAE?=
 =?us-ascii?Q?086cfabOXdzDP8/2dHMw/uyNFfeP6jigbs3OaoPXQOYMhPBTpN03UvLQf8rp?=
 =?us-ascii?Q?HQoQiL9SCKJkbCBH9BxEFDCYIfma+zAIZYfxFuKZT6S83kz33rKicJi8DmJh?=
 =?us-ascii?Q?EhMUmSSr1rqdXqmo+fqsH1YF86+koCYIRmkFmSO4oB58cp5Rew59SFCaR9qf?=
 =?us-ascii?Q?CDaJ6QDKaODTFm8tmHxuDp2/PNJOASGhautLxYqZvq/Kykqe0lP5WmCkVlEK?=
 =?us-ascii?Q?boW3mlFuJfbhNFg9rFqpsoWSr0fPyamE0xnnG6HC25HVkigAyPyhxxBz8Fvb?=
 =?us-ascii?Q?H7ogU+2U+hUkuf7pVa1ECTYlkhpbghbSgG0pU+wZx5SLbg7oj9g03N55gLmF?=
 =?us-ascii?Q?sfpOHs1UwLDOoi7DpSAedzCnLVpxm64t4QcTDUHyn0Q+a1H4D1NE+gJRL6NT?=
 =?us-ascii?Q?4A68IzBS3fD7wL25lkd0/D7LUn1NqG/beZEmGgUXmh4am7Ift3Ap6rZqN/L7?=
 =?us-ascii?Q?i5xFrupOLW/HAPy2fnAEPzUV2uP7OiMo4pRkIrVQ0kwUTDgaPdx8Mj9s9dAg?=
 =?us-ascii?Q?JNFeNPgFRqgD1gr2WB8RsANoDMguKAr6i8jPS4rjS9DopuTkz6kWiN/qjiAL?=
 =?us-ascii?Q?kkPYfapGMlU5IRqbR9ifeTDCnkfJ3f/THKZH6Ly8wRbeUsvm6RjNUGAYU7N4?=
 =?us-ascii?Q?+/tzzwZiDjlFnIr12rbKfBiAqI0UodtLzRhAAEfLsI4gklUW8S1I/CaiGQ3T?=
 =?us-ascii?Q?gX0lKgdHuz1/jlLZI9Eg4/bg8JQzx4W54xR+bftDvn7Yyt1FahraMUz3eOpN?=
 =?us-ascii?Q?n3Ch2z9cUBCJlkn6w7apx/bfH3/1CrxrgJm/v8Ne1C+mE6uHJvcnvj4I0mG0?=
 =?us-ascii?Q?3PdSdXfz80tUm/rcQ5YI8QvOXjkCukWusMhSIp2W6jEtkxpGuQvUFi5mxiNk?=
 =?us-ascii?Q?5T4AdMEoGWX8DqQ8I3JYki6Bzha8IxG5L30PG1Z/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433928b8-e225-468b-ad64-08db35e21066
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 14:28:45.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huC4n3olZFoWvk2ArTgI4LKJv5uBybS9JQk/XkA52oOXHHt/RQQ+adfdNGzn2Sfs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6724
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 02:10:19PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 5, 2023 7:56 PM
> > 
> > On Tue, Apr 04, 2023 at 04:45:12PM -0600, Alex Williamson wrote:
> > > On Sat,  1 Apr 2023 08:18:24 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > >
> > > > Previously, the detach routine is only done by the destroy(). And it was
> > > > called by vfio_iommufd_emulated_unbind() when the device runs close(), so
> > > > all the mappings in iopt were cleaned in that setup, when the call trace
> > > > reaches this detach() routine.
> > > >
> > > > Now, there's a need of a detach uAPI, meaning that it does not only need
> > > > a new iommufd_access_detach() API, but also requires access->ops->unmap()
> > > > call as a cleanup. So add one.
> > > >
> > > > However, leaving that unprotected can introduce some potential of a race
> > > > condition during the pin_/unpin_pages() call, where access->ioas->iopt is
> > > > getting referenced. So, add an ioas_lock to protect the context of iopt
> > > > referencings.
> > > >
> > > > Also, to allow the iommufd_access_unpin_pages() callback to happen via
> > > > this unmap() call, add an ioas_unpin pointer, so the unpin routine won't
> > > > be affected by the "access->ioas = NULL" trick.
> > > >
> > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/iommu/iommufd/device.c          | 76 +++++++++++++++++++++++--
> > > >  drivers/iommu/iommufd/iommufd_private.h |  2 +
> > > >  include/linux/iommufd.h                 |  1 +
> > > >  3 files changed, 74 insertions(+), 5 deletions(-)
> > >
> > > Does this need to go in via iommufd first?  There seems to be quite a
> > > bit of churn in iommufd/device.c vs the vfio_mdev_ops branch (ie. it
> > > doesn't apply). Thanks,
> > 
> > I think it is best to stay with this series, Yi has to rebase it
> 
> The rebased version is here. Shall I resend a version which is rebased on
> top of vfio_mdev_ops?
> 
> https://github.com/yiliu1765/iommufd/commit/d3d8f65c82fe2ca2a7b1a635f4b40b2a0971daa9

When you post the v10 it should be based on top of the vfio_mdev_ops
and the hot reset series.

Jason
