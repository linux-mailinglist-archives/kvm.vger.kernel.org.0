Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D47070815E
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 14:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjERMdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 08:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjERMdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 08:33:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3783AA;
        Thu, 18 May 2023 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684413221; x=1715949221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rXTBa93Nag2soS/mcOwYQqvKOuZyY9OiL6YiwkPbAbM=;
  b=lOPqYuFyoZR4S5lnZAwYmvTX8SRRAYnHEgMAxS7telFOpFtW9qK0ZyXK
   o5KLM7U26PRJKg1II1hCtKTWy8CdFMx54KZLKfX5GZUgMIAhe8wyNJOLi
   XIKIvq7JzT98dNxY+9Wi9fdOFJAcM8bmy5l6TntqOqYY+bUT8ULNCbeZs
   tWtvvNFGEAj4YqJmuLyeF0KHBUSm/JxQuxwzL9td3gRUFhzZVNgIUOIjQ
   GCgPTzpE/gQ1JN1SW+kOjhnjEj5x3AFqMT8RZjUGHyz1hzM9/oob3IH12
   O6uLkq7bUVKnQ5h9NDPquz5DIyKPGn42JxYGr1cmF/e2bW+b/NLDGy9Q7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="336619481"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="336619481"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 05:33:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="679663938"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="679663938"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2023 05:33:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 05:33:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 05:33:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 05:33:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 05:33:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4PMg2f5XnpsAwrRdNFPXH73sK90THhx+rqjK71RHekztCnUzdhgCK70OL8E1xiB7TiHK/FYk+rQe6BBOrr1Z0+HrlDmOQVBuDt+VmrXGwU+9Uhp7aULEpzJ5p32n8JCJDSCHxMXODtP72yinZttDbXdFaszj4Si93OfYcUWNRHIzYKofYZtGHlMSZECppG3/yx7hQHUeXQoUWVFgChmNqhG7gCwGRLvUitQ6IH6bVsQAF+f9nWi9qJECS6uFQ1dr/HFNSguz2X8n+sQeH+QSuTmu/kEYQk2SMAZPZGfo7oTPJdPYXQr3UlFCE8eKCHGFJGq29AhqQahKxDWX9t/pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSsT+Q7a7KLilHsoqDVIRHJ9co/3iDocf3Vvkar99JQ=;
 b=ecZ1eDt5o6fn5CeS2H9y2Km5ObpsEAot6wo06Q0vMMdwcZqJTQUKq93GRHs3na1x6GWhwFoYhzbDG8H08lt77nHriX4awFNgcrPlPuEDkoAQP3+gLOYyMWI5ZQr+dkSc/kCK6sgMyiQl/3gq0mcVDzfQEZVuvM8tzLotoRvLFptS+lAwjLxcQ/fZfpNwClG+nDH9S/JY5yz4tgAZZcZSGdQ7vJxMOS7D3uF5fKObjuJTz8IujLYzhv+tQYT768Lwfg8fPHfO7ftndGaKukIoBXSf3e+N+MVIe9/8LpFxn5nP6NgC1xqVnSsdP3rZkCf+IHVpCSSMIypcwAmZjNYNDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6925.namprd11.prod.outlook.com (2603:10b6:510:227::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 12:33:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 12:33:31 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v5 08/10] iommufd: Add iommufd_ctx_has_group()
Thread-Topic: [PATCH v5 08/10] iommufd: Add iommufd_ctx_has_group()
Thread-Index: AQHZhZ3j8IDG89UncEChA46mX3BEV69e46KAgAEaefA=
Date:   Thu, 18 May 2023 12:33:30 +0000
Message-ID: <DS0PR11MB7529A718A02493CAF28DC021C37F9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-9-yi.l.liu@intel.com>
 <20230517134029.7e3da6c6.alex.williamson@redhat.com>
In-Reply-To: <20230517134029.7e3da6c6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6925:EE_
x-ms-office365-filtering-correlation-id: 1c5950a3-3b77-4967-a602-08db579c16a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zZJRXxr9P8FCo9TqeX4Jx7zv7ZoOMATNhgOPv38bsOV4HOMfm/itjG3l19K7E5lu3rGTkp28ohVv+wyJcIgOrTVGdAbUpIKzQsaQpZIhfxe8TJK0nifsWfZqdPrh0438PDwrlDfmMtP7j58+hXMCrqP7feZdNeRG9r9Z7pqK0N5S3bg9MIBqgbUucZqUMK6Q7pBdifc1MsyKWejEa8xk3Rc81Fr8kocMCDxHzFDQ+UcjlatiA1dHhwK0alLKWZCUUb2ZGlwsJFEwTLOyqfPTnENKmtsfAoHPF6AYstjCLgzdoMA+LqfBu9Q17JwLEq1SBD2CkGAWzew97trNvMhX+urDbJbead0R6JQgSrehUPT6aJU/54yLfQWNZNBTm7NyWDlIKhOd7yPah3TDPe/MjciVWCuQBW+5X6w8OCEwkzv52XsVY11GbhMvpJA1ikc/+mbA01ZbUA6q/1k04w0hjLGWeY/3HSyf6zH7ILrCEEVd6mmrBvWk8I6miwXdhhEehKdTwC8KuW7OeYmXeWRP8AIpOevdngCgDQKsgkc963zwenFjO6YzcLh/1NnO8VkrL3Pb2YmBc7uY3+D+lUi60BlWxMTkh5W3zPTUdgtjHKrNqeBVaFgz0Lo64WJGYdqz/17KZ8ZdQ05dJS3sWatO6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199021)(86362001)(7696005)(66556008)(33656002)(38070700005)(76116006)(54906003)(66476007)(66446008)(6916009)(64756008)(316002)(4326008)(478600001)(55016003)(8936002)(2906002)(5660300002)(8676002)(52536014)(71200400001)(7416002)(38100700002)(122000001)(82960400001)(41300700001)(186003)(26005)(6506007)(9686003)(66946007)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NhpYdswf/bFOwzqAnq4g5Q+w/DbQ957PDFCzGuGo3uWEwde9T271mvXhqCFp?=
 =?us-ascii?Q?km+34RTgBp0eiTMDk/2p8xSus+7pDQ7cMvfHI3RmMLXFZ1IkEMTInwamSxDy?=
 =?us-ascii?Q?UI0NmdsHU+bHiiAXTVe0TwgtLD6mnE41XvpPgwHU2jJNHMGkhToi6e1LEUY0?=
 =?us-ascii?Q?Q9szQ/PjRQzpkAeTKnCVEv1o+PyBf8Se8fuilmhAsGieCN7tMCnKKcbUvLS/?=
 =?us-ascii?Q?/dlGQXF9dDAfon/xlC29c69QGtRbSgf44kPcW0S3Y4Zovo55BaEB+jWi/tdq?=
 =?us-ascii?Q?rkRhM8rzsWGmovKOUIhsn2ZyKEhpzSn6FIkH7/vD5zILmtG15QXtuB5kpv38?=
 =?us-ascii?Q?TBs/wqjhOysfHKstrtlRJfZWTiysex81CZCw0TLQXzPQcWlRef3PUeMp5aI4?=
 =?us-ascii?Q?CJAtUsNQEZOFEex87vfrr/uUiyRcV8E11IIo3YYbU5me9uLXA7sQCA+MMzz5?=
 =?us-ascii?Q?Fhd+QUNQgy5dg/pYNvuHbxB8jkigQDf0rEUUMcwuHwPHgpUMqSuphNMbA2w3?=
 =?us-ascii?Q?9RSMKJXW8VqY0YnvHdbxWZuDlDntcD6WRuqHsaHq4OjGhaN9M3hO4OdjdS/I?=
 =?us-ascii?Q?BLVRLM0nUlLdKvmExZXuSlI2A0UeqxH8pmyphAeYhcUYVLtS9eEK/7OmbJWY?=
 =?us-ascii?Q?oTtj90hsez+nI0RP3j5rIzv4aH+mz3+MfbA05I7sgbKrz3C8MAxaZL8a4Pqy?=
 =?us-ascii?Q?xNtSC04e/+2lecAHLl5xfabc9t26FhNS0EiJa7wk4qOEin3DZFuGJFNwX6Xm?=
 =?us-ascii?Q?1s7JyRB5stS+UY/s3O3FbBd7Kfee+jbQHNUIC55j5lAMzXCDDo4CRWh06+q+?=
 =?us-ascii?Q?YuAxXQti+x463mHOK74HoPWx5juvoUjSCal4siRH+W8x8Tkh2LPo6NaUihQg?=
 =?us-ascii?Q?U8Fghv4or1s8SaU4ioUJvIawkkU6mptp3ONgyuloKv7bBY224RmlcbeB4iqG?=
 =?us-ascii?Q?rDzPyQltT9oDRePTYqg70HcSfE6kbT7Zln6Tb2FVtgQpLpHaq9IuIJNHmaP6?=
 =?us-ascii?Q?CeOKQSQs/izAGfxI1e4aES6Z9+CrHJTylncnJfjGadwiKn8BDzSY4fewvjiA?=
 =?us-ascii?Q?ozjPlgq3TnMz0vgXO1MKEUWiePpsoySPsVamif5D0rOrUeLHwbTrxZgrPZin?=
 =?us-ascii?Q?j+BJaEE76N0R4d9N2AOdi03XZSLtM1Zuz8gquu3wfGg1gGUQq2tggoDldJlH?=
 =?us-ascii?Q?YXAg6ZqNnthFH5H/ExMR3Z1EoiZ2bcl+ALnfR0ihnzPoSDAgYH4ZE0SDg8mf?=
 =?us-ascii?Q?THpVyyo+fW0ECs/LVRJFOWtIMybLd9+uF6ka+e7tZWRXVTkLuh99KTYfJjij?=
 =?us-ascii?Q?+oGIRaQwmnhWHrYu6rYevgYkIIgsvATNd61rEn0d7RP4+BbZPsmUw2ZfG+vG?=
 =?us-ascii?Q?KEhoj4i3UX88l08eTFePtSSzWE9q5P5t2TFPdaVwbMhWXuAwl8n8d8D9uGbq?=
 =?us-ascii?Q?v3oLZNM2kwPj+sKXOQ3ePzT4HwQUvLm13pXwtEC/vZ28Et9bKYAy8XRjW5Qk?=
 =?us-ascii?Q?gj+iV3uW5XagL3yeT4wIcJqJM9eHsQk/zJGRc49r942ye357gxN0MEFcJcaV?=
 =?us-ascii?Q?YsNKQRzcWikcRlYOvYZAXy6dDOYxrxK1jvENmome?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5950a3-3b77-4967-a602-08db579c16a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 12:33:30.8916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7MJR0EiupkZ/ckq8g/S2aqHWLoXbUKoZqREMgU0q8/zEtjVZN2YjpCeCUCyEMp+GiI+q4FmWeSEF7XGWgrBPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6925
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 18, 2023 3:40 AM
>=20
> On Sat, 13 May 2023 06:21:34 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > to check if any device within the given iommu_group has been bound with
>=20
> Nit, I find these commit logs where the subject line is intended to
> flow into the commit log to form a complete sentence difficult to read.
> I expect complete thoughts within the commit log itself and the subject
> should be a separate summary of the log.  Repeating the subject within
> the commit log is ok.

Sure. I'll go through the commit messages.

>=20
> > the iommufd_ctx. This helpful for the checking on device ownership for
>=20
> s/This/This is/
>=20
> > the devices which have been bound but cannot be bound to any other iomm=
ufd
>=20
> s/have been/have not been/?
>=20
> > as the iommu_group has been bound.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c | 29 +++++++++++++++++++++++++++++
> >  include/linux/iommufd.h        |  8 ++++++++
> >  2 files changed, 37 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/dev=
ice.c
> > index 81466b97023f..5e5f7912807b 100644
> > --- a/drivers/iommu/iommufd/device.c
> > +++ b/drivers/iommu/iommufd/device.c
> > @@ -98,6 +98,35 @@ struct iommufd_device *iommufd_device_bind(struct
> iommufd_ctx *ictx,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
> >
> > +/**
> > + * iommufd_ctx_has_group - True if the struct device is bound to this =
ictx
>=20
> What struct device?  Isn't this "True if any device within the group is
> bound to the ictx"?

Yes, yes. a poor copy from a prior version..

>=20
> > + * @ictx: iommufd file descriptor
> > + * @group: Pointer to a physical iommu_group struct
> > + *
> > + * True if a iommufd_device_bind() is present for any device within th=
e
> > + * group.
>=20
> How can a function be present for a device?  Maybe "True if any device
> within the group has been bound to this ictx, ex. via
> iommufd_device_bind(), therefore implying ictx ownership of the group."  =
Thanks,

Yes, this is the meaning of it. will fix it.

Regards,
Yi Liu

>=20
> > + */
> > +bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_grou=
p *group)
> > +{
> > +	struct iommufd_object *obj;
> > +	unsigned long index;
> > +
> > +	if (!ictx || !group)
> > +		return false;
> > +
> > +	xa_lock(&ictx->objects);
> > +	xa_for_each(&ictx->objects, index, obj) {
> > +		if (obj->type =3D=3D IOMMUFD_OBJ_DEVICE &&
> > +		    container_of(obj, struct iommufd_device, obj)->group =3D=3D grou=
p) {
> > +			xa_unlock(&ictx->objects);
> > +			return true;
> > +		}
> > +	}
> > +	xa_unlock(&ictx->objects);
> > +	return false;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_group, IOMMUFD);
> > +
> >  /**
> >   * iommufd_device_unbind - Undo iommufd_device_bind()
> >   * @idev: Device returned by iommufd_device_bind()
> > diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> > index 68cd65274e28..e49c16cd6831 100644
> > --- a/include/linux/iommufd.h
> > +++ b/include/linux/iommufd.h
> > @@ -16,6 +16,7 @@ struct page;
> >  struct iommufd_ctx;
> >  struct iommufd_access;
> >  struct file;
> > +struct iommu_group;
> >
> >  struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
> >  					   struct device *dev, u32 *id);
> > @@ -56,6 +57,7 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> >  struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
> >  void iommufd_ctx_put(struct iommufd_ctx *ictx);
> > +bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_grou=
p *group);
> >
> >  int iommufd_access_pin_pages(struct iommufd_access *access, unsigned l=
ong iova,
> >  			     unsigned long length, struct page **out_pages,
> > @@ -77,6 +79,12 @@ static inline void iommufd_ctx_put(struct iommufd_ct=
x *ictx)
> >  {
> >  }
> >
> > +static inline bool iommufd_ctx_has_group(struct iommufd_ctx *ictx,
> > +					 struct iommu_group *group)
> > +{
> > +	return false;
> > +}
> > +
> >  static inline int iommufd_access_pin_pages(struct iommufd_access *acce=
ss,
> >  					   unsigned long iova,
> >  					   unsigned long length,

