Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8B6D7ED9
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbjDEOMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbjDEOMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:12:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C054F3;
        Wed,  5 Apr 2023 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680703906; x=1712239906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Euyh7UAqb9I4F7WqFjp3Vto1ELLU9hZniANOyzw4oVs=;
  b=YlOvMB0w4hcGUSm50mgSQ8APE0C095E27v9cNYcco6adcW23f84iD/ez
   VeW5RdzCVuXxODu5q09D0vBoIf4Qc8G/0uWupLLJTJAsoO4NuqLhcmB/c
   ep5V1iIhbh9MyPCJQZuhtg84JqSdeN4GZyDa0SoWM0fINXVWbWlPmDe9k
   shS0uzz1b7ONEGXTKAYrzxz9TkU8XsyPod/X+/9QCnSXBHjqoKN4yl3Zc
   6SsWldNhuY/h/53Q/7hihFijRMVf6ajEoYKpyDZWns62KVeOlp7fB7LQ+
   1YG02Lv0EpAopS39d/aGbV0utfJsNIl0uqsNnlK4aQV6DcLZCIdeImbTe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="407543799"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="407543799"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 07:10:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719337836"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="719337836"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 Apr 2023 07:10:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:10:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:10:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 07:10:22 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 07:10:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGTeFE72TRPf19Xo1ulzN0E/Zyk0ch6pOnJow9kSjpQfnUedg+5GDN+ZXXIWdQgYEXcmXw26Ck1u9wO511oTzuwTkni3fgUEehyBkYXuLsDXNwyGYVvEOd3PqghxDIPxT2fvQks2tD5KtHJ+FCIsQBVXPJWbalpUIKh8+ihgAtQt1Swjq5WUlTfEGEc8IdaUzWYFZTRhhtT7LqslsnLGaTm8ni68IUZ0CUQXMem47mQCa0MBX1N5hdkNwyJKmxVLBwMFIMnGSu6IIty+gRQC/2e+IvdkZGaKDXR2KtbchtMc+Qf+h3URo0huWk4vmt1nNLuIVBeuROkXs6DGfPVDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Noc/jS1dQlOYnzDITrC8Sgf9280qZ5ikML5wMzn8zbo=;
 b=S/JJ9pomkdKNdWRcEhM+ni7kB/vlYK7M39SrllAEimWzTWHHRKHxa3XZNNbSqSt7Z96P5CMTHY50RjgnzvXS92x5W5sdkISPhrf2tQj1pL/UWM4JH2nE3q2UmuPRZQT3Oy2ZPk4M77Z16NMsj6NQBh47kCm5aKY41oO96v9lJ+imUmOBXccI2J+6mkmtcxhKnjyoSsznU9lgfBP2GfNnOVpMZtDXkzmwWz46ggbmXMW+iDeQ7D51Nw42+hRFq/+ya6BbjPAcewB8RM9vL1ywv6+gjUoeq1E5ViUOdRAJxmZf/lNQZ9N5CpKBZxDNqUDgM5bkuA5DLIXGn6iqfv9ToA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4583.namprd11.prod.outlook.com (2603:10b6:208:26a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 14:10:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:10:19 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Thread-Topic: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach() API
Thread-Index: AQHZZK1DZFmNremnwkKG+VLVqq49ia8bxOAAgADdFACAACQI0A==
Date:   Wed, 5 Apr 2023 14:10:19 +0000
Message-ID: <DS0PR11MB7529B223F9091E509DBF351DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-17-yi.l.liu@intel.com>
 <20230404164512.37bca62e.alex.williamson@redhat.com>
 <ZC1h7PyuhEg3ZMcj@nvidia.com>
In-Reply-To: <ZC1h7PyuhEg3ZMcj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN2PR11MB4583:EE_
x-ms-office365-filtering-correlation-id: 922cdfcf-ad66-4d73-10f1-08db35df7d42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wUIGlE61qyiayhvqfBM2QdyKI1YE8NIO+lllJiKoGPcOaOOfdYhuXHTEBZ+O4EdRA5weETPxrAvPIw6Kl2wq5JqkMkHCUPPOU9xvhDWE7Mg24CuVw0Yj5v6feWuWNk4hnv3q7VZg1+sNPxeqMMyE3ycC50YFPvYms4mpJDgaBkLjdYXfaT6ZhvkaoepK6BGAAr1OggD9d8noxDrSf6gWRuCOd8sEGdPUMRRyLCbySVHbewvUBnYfxeOigvcLHVwygob4kIGlKEskkWKvZNM8tg3tqfkRU7fbI70EtlFJDMFVQIUpRXI03RbgkJi6EVcpAjeVESIk7MQ2abDPbXu3YNyNBzQTdMEuJkCANayWDK42Gp9LrdsAee80ggWvy54W9Gn5itdOYJ9bCLPEjcNMPM/ceE9wpEJmzSNA38WwaRk7kBIsHx5r5YXKwvjGH3z4IwD5oTuB+YX6XoizY2py6VvtD09blc6X9ojlABqTETS4mZe0po2A/2Mrol97QQPfcuEP3tjphyuMUjbjE0XpDCI5O3DDYg4ejgLfxUlrq3UNJpOdU1j5I15glHSkL0xK4PJvfSrFJSgzSzp3EZwoF+NGSR1kdgW6xgehTnrpeQWIyGZs0FhiVVo5EAtmvyai
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(26005)(6506007)(9686003)(186003)(86362001)(478600001)(33656002)(7696005)(54906003)(71200400001)(110136005)(316002)(966005)(5660300002)(8936002)(7416002)(66476007)(38070700005)(41300700001)(82960400001)(38100700002)(52536014)(66946007)(2906002)(66446008)(64756008)(76116006)(8676002)(122000001)(55016003)(4326008)(66556008)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a0TBgWXM7po4bBuxYIVAe9qgX411luvJ3p4fTyHqZRtxpWGZyOmjPH8BF6D1?=
 =?us-ascii?Q?m6Q80QyVJijYcjMClnfVvyipt2v0UT57Wmalcq3WwxIFQYKgt/z7cAlD/Y6a?=
 =?us-ascii?Q?/+U0+RnrWNmwdrgJTiolhh6KT+8ZU24FcbRJrqFGiLkhvu5TxB9CF6QVSXXD?=
 =?us-ascii?Q?pnJhVSA65+RP75bncrALbU8EkLa4oRQppnAiopFjQdNIn9zv+j+2gK7Iu08o?=
 =?us-ascii?Q?mSYRN6d9lzlWOkT4c9PJ6rxjb7wU764h08ENJcxj6UkifDdeWjI9BX76ilxt?=
 =?us-ascii?Q?olgx2A8qtcV/nc5BZd3rlq984DyCOa0BA0l6t92jycjLYGuV2h+9eatKVYuy?=
 =?us-ascii?Q?Ca5oXocfpn1LNNjDGdhPJdw3zZxmKOdPTfQHNmVeBwIRWfrVAIC6frnWlF/T?=
 =?us-ascii?Q?s7DV2qMRqgy1fLrxipsmoZrCOjn/T9WKCtj2y8jl7FKra24Vb7uxdqDfcvA8?=
 =?us-ascii?Q?ztk4fEidkWOLzEyBiGqk40PHTjakp0EWWN/nthSPWhbDYQESgvB4XHMjfkXZ?=
 =?us-ascii?Q?Qrk928i7Yq/6yi7l9SkuEiYdqY1tg+Frf8x146rxLeyjGordi1TXulbkTf2M?=
 =?us-ascii?Q?LqONgH7aUI7OjyK/pqSNrFHpj0ChFov+f18N1zpk0V6VceUQZGe8z+fesULL?=
 =?us-ascii?Q?lUiO3uPrjNfIJMoxOeIGi6aFBXLnQGm4mQA6QMGh6nNJyl0zZAUhEPWkVZmd?=
 =?us-ascii?Q?8TnQBtK6yUx+U3Pfa6E6SMyoTIK0DZ7/yOrWtTDloI2/NZjKC4veYqeo9M+q?=
 =?us-ascii?Q?Lw37SIMDs30f4XyNghoKSHbz6vlC4nPoZH32KLCCqjCjOh69XTFS/IswHQYV?=
 =?us-ascii?Q?RV+AX+M7tzh6wP1VLe6H6XvmJYR3RGP294mXW69TRFU6g7PInov8KqeMGSG/?=
 =?us-ascii?Q?WLycfhkByFhnx+Rvt7/SLEdwJdtlmUhd6wd7XYnIc0o4s1z25Aoo5MzkqXxN?=
 =?us-ascii?Q?M/HGyE7J/cr+Qta40t42sm2Q8Lo9FxvGAGvFyn+EBcSjkj4MzKZCL3BXp51F?=
 =?us-ascii?Q?qrhfHD9nb5MnvVmB3Pm+JP7UU7e0sSWm6hdU08hmuJ9JytETtEWDfwrPOLBZ?=
 =?us-ascii?Q?66OXMKP+nnqz387q+IC0+goULwS3v5vrSbwK+z6eJmVVj9zGh8IUcNF/3tsC?=
 =?us-ascii?Q?vBST6PhBHMhIompud4t+3+brZ+dke/QlkT02LgsQTpxlwJCEA79UovkEX+GF?=
 =?us-ascii?Q?nsl8RGwJMRkPqxa2hNegGCMLrm4kFLHqlPzJBRWrRcrGGw4LCEvkNdYifP3H?=
 =?us-ascii?Q?BcUnEow11np/aeawVPuP7t+PKgZ6fgJxY7qpnXZcVRPZ3YWszG4tz4Otao6W?=
 =?us-ascii?Q?d0+nemcfNNqZfI6lX20XOZwwjmS89zWjQMV/gF7kRS9vQPcuoLwgDJdsRcbq?=
 =?us-ascii?Q?j0TtjG8uJ4rzwEpDacMkcQla0NWzaLWApmhbCaTLesc2kOr9cHkIOFIZTlEL?=
 =?us-ascii?Q?wxLZTfR9KM6KxaJHO7KFTm6j1dmLMVK45i0DqEmX2/U+NCSnJp8OYq7OSMB4?=
 =?us-ascii?Q?BksODKaMBSScw3aMXC6qVpKPaSTw2l3aEjeZr0D/7eQy8OpCOfLLgfsY2l6h?=
 =?us-ascii?Q?suk2BzYKE9CmME/fdJxvid1I6uCYr/MKca08WuaU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922cdfcf-ad66-4d73-10f1-08db35df7d42
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:10:19.8338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtcunBhSPnfhZyqxyQ36agGjUhhGPwyc9/jXGhvVnMZDgdrxGB5YcBfQ0mj2lxJzeu8VlI0dLhBHfxoYflAdUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4583
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 5, 2023 7:56 PM
>=20
> On Tue, Apr 04, 2023 at 04:45:12PM -0600, Alex Williamson wrote:
> > On Sat,  1 Apr 2023 08:18:24 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > >
> > > Previously, the detach routine is only done by the destroy(). And it =
was
> > > called by vfio_iommufd_emulated_unbind() when the device runs close()=
, so
> > > all the mappings in iopt were cleaned in that setup, when the call tr=
ace
> > > reaches this detach() routine.
> > >
> > > Now, there's a need of a detach uAPI, meaning that it does not only n=
eed
> > > a new iommufd_access_detach() API, but also requires access->ops->unm=
ap()
> > > call as a cleanup. So add one.
> > >
> > > However, leaving that unprotected can introduce some potential of a r=
ace
> > > condition during the pin_/unpin_pages() call, where access->ioas->iop=
t is
> > > getting referenced. So, add an ioas_lock to protect the context of io=
pt
> > > referencings.
> > >
> > > Also, to allow the iommufd_access_unpin_pages() callback to happen vi=
a
> > > this unmap() call, add an ioas_unpin pointer, so the unpin routine wo=
n't
> > > be affected by the "access->ioas =3D NULL" trick.
> > >
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/iommu/iommufd/device.c          | 76 +++++++++++++++++++++++=
--
> > >  drivers/iommu/iommufd/iommufd_private.h |  2 +
> > >  include/linux/iommufd.h                 |  1 +
> > >  3 files changed, 74 insertions(+), 5 deletions(-)
> >
> > Does this need to go in via iommufd first?  There seems to be quite a
> > bit of churn in iommufd/device.c vs the vfio_mdev_ops branch (ie. it
> > doesn't apply). Thanks,
>=20
> I think it is best to stay with this series, Yi has to rebase it

The rebased version is here. Shall I resend a version which is rebased on
top of vfio_mdev_ops?

https://github.com/yiliu1765/iommufd/commit/d3d8f65c82fe2ca2a7b1a635f4b40b2=
a0971daa9

Regards,
Yi Liu
