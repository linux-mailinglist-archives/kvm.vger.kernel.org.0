Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13D6728BF3
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbjFHXoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFHXod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:44:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3318D270D;
        Thu,  8 Jun 2023 16:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686267872; x=1717803872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j7Vz8Wi549HH6zMn5AL8cTna/uo2WysUZXW/pJEh9BU=;
  b=bIhAmFZ+fUMACHHpKvjrdDkFMrj6TWWF1EOWcfQelwJykvvv1gaF2Xh5
   EQr7cpmprH1ElXQjW+pVJJ9AiJXvF3ipn1mkGAngQeNEDODA1Pq55SjE+
   QLKmwHyvWQ4rvjYhQW++TswVKsd+ikVoETWLD8vTX438P20WARC54G5Wz
   ribndW0jCg8edGQfPPFP515T5IkszzVM9Lf7GLdtMTPXQU4nTFMIrmpcm
   w+GNbZqDL6TmwWtVIAgx9C3OHuKRopXweFgPyNRO3sve+ylLOPb4wJQZI
   lhvgigcpxJqQMEXP1sQdav/dL71qG2sjIvA5ly1s35KwiT+pgQI8yrhtI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="360820476"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="360820476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:44:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="660565469"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="660565469"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 08 Jun 2023 16:44:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:44:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:44:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:44:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPYGDue74VFjr+x4RwSk7ZYZ+uJO73QEaWPM0sJhQx77JVJhgT6SiWZPJPCylNl89kvb9M61v8a6C5J7Y26hDCOu+97jstfu6RzUvEHeCpEmzy5stcgbKp6bhnY/fjICkRkt1Iq8rcTB/vjavfUSxVqeqpJ7QS1bUh6aT5zbmgdfFtTm2+DxDpCAk51F4SlE+GrJURdoVgk+5jblzlauU2H8UxYzs1EveDXeGlIK3CFsex2dLEFxrJonOpdrTsiI6taPFdcQdEGlMOHvdd8uGRVyX65EQzW6gDkeXCgP/Ov00RW9RKLeIr+kVb8HTWNLLYQhWIXj90/zqY1N/KJqYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysg9fltjcCDIhEuHpo/xY+0ACDBozZut84y8RpCgQIE=;
 b=BjUb6aE1mbSOWNa1BEaeRyZaYg5/BSQVALdovveApKfE1zn/ec4aKGIqcxZCtukN7xfu8yTWLDhX4Dd6SiT9vlj3vkbssoH03VDk6UVafznRRTp07eHfD2hy+Jc+QenZU+fkyHDuN/ZzlMM5s1szVOMnkqrNozj950cLjumucF/lZp0NQPtcZNCrV/NBrkQLdPPHSolE4ipSeTYLAEVYfd02xVrrCK5bvCan2yzypnYdt+9c9oH1MYYJYeTb9StYSX6eZO0fBWUwcL27F0OwDSXjj7GrpF7Sj+gMnax0CL/Vlj9aBvWt4J6aY5V9vgc2zrE7nSDyGwDWWg2hCA0kwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 23:44:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:44:21 +0000
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
Subject: RE: [PATCH v7 4/9] iommufd: Add iommufd_ctx_has_group()
Thread-Topic: [PATCH v7 4/9] iommufd: Add iommufd_ctx_has_group()
Thread-Index: AQHZlUvwCII0iJLcikiFFSBTzeci9K+BeTKAgAAiXAA=
Date:   Thu, 8 Jun 2023 23:44:21 +0000
Message-ID: <DS0PR11MB75290C8B93CAC8CB87191284C350A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
        <20230602121515.79374-5-yi.l.liu@intel.com>
 <20230608154051.0f0e4449.alex.williamson@redhat.com>
In-Reply-To: <20230608154051.0f0e4449.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: 89f54ad2-02d5-48c4-f721-08db687a4856
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qu/KDN2b7c4w2btvN/55dG9g+XGn4gN5hz1JQk15ZlAw+gYseVxHT2BrIPOnNNAhtvfcfvTvsWPalGyDo3bBEGLX/iP40YRf7PfRLqnSsbdovrhQNYxHXFqsnej3TTjD8RnVjhxEkkAcrNXyPzeyRWG61Nv7vTxpvBIjvF27Xcu8kk5Z50D2MsEy5kiPqG+oRik67bQDnRtk+9L97/k5t4G4glEzOh7fL0s7QSrHtZphwZhqkMep7z6x6Xxr2yZWbqCrM6NdE3SoBtDsRAYghGvTu1T/xYRmw5/zVwOHQIlae8BBcE6II2rTZycL+fusQqQswr374YRrMofj8+w1dMrsKGl/vJDf+ukqZNaVe6J5Zj0yEfh5j8Cf5fzmKzTqnW7rAaXItDx35rLdsKLBakRbJYj3XK4dXwHK2k4AFa5cW6H8c1SXHhDWnumoZWr/gDOxs0ylqX9tVqdTJgRXja9yfza49e8MYrSSfbAT37Fa7MQeBS85kM1Ig878AJpOTNGWsL+IYfo81+mgatxp3UHmL0zLqccS3D4b0eB0aSwGvGTIZXJe9vaNvUjtL9Q5rgvhBI2b75ttDB6H/hVtRB0vk6/gsOkAQjIQ5juuZU0NqUJ1DglEfSP7i83JM7TnH0w9/u3Yj3/riu5UhIj4qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199021)(9686003)(26005)(6506007)(83380400001)(33656002)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(186003)(55016003)(52536014)(7416002)(54906003)(478600001)(316002)(5660300002)(2906002)(41300700001)(64756008)(66446008)(6916009)(76116006)(66946007)(66556008)(8676002)(66476007)(4326008)(8936002)(7696005)(71200400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+KbkO0OxHxRa3rBF8CzwR4x0WJFzR8z4OnvsX9kFFTQBmVSGcR/zjr37vCeE?=
 =?us-ascii?Q?/e28e55UHYgXtM/ehF8viT3sK1dhEgJbIexauNrZ28QQEy+4qJ05CPtCBWN4?=
 =?us-ascii?Q?fpYqwEPFEKAHyIZR51V0OoQvj0d+uqNydVY8GhpNj03FUHFLhz4EQZa3ZloY?=
 =?us-ascii?Q?oJTxY2t+vNBvvFIvGCkG4EUYRJl9EvWeJjoqcanYZhhXCUqlXTDzPg95eYfl?=
 =?us-ascii?Q?GG+pJyFYj5Ffk3jQtBUHb9XGqvFJkXovQDDFwntpaCU8199ED+zMtRyRiXY2?=
 =?us-ascii?Q?VLipJB4AIfZPkUX74iHNOqgXokFy8OyXogFhL9rQCskGrQE52Z0s3TSkSulW?=
 =?us-ascii?Q?szP3DNWxNPTiZbk0ipqvuza2TcGXfrKlOWnJt/OPGq2L8eKixDeSCYzu0Rep?=
 =?us-ascii?Q?mDsGxS+9OGcAi9MPSipKnzi/3y3z59LV/NCATzA53xngTeJ+86h4dwGHrVyu?=
 =?us-ascii?Q?vs0GsFbuz1De6FwCvz411AWeqr0Y21r/w7ocM6Q9Zgb+XWDUAuJfQsuKKLyg?=
 =?us-ascii?Q?nK/D8vs15tpHJKQRDYydeAWl0pfDJtUnI/tfUlpdv5twGE8H2u7Gyp26dAZW?=
 =?us-ascii?Q?XQGcXInj5EB/CyiM0CrJq4UmWYSh+ioxDq+/DJ4vnbBVCjwuKHChEUM2XGwg?=
 =?us-ascii?Q?gJ7LMS187rkdNPgLJfdRN+um+tb/o9yEM0ZYnHC8VXUecIJf/Tr5EBz2+0qa?=
 =?us-ascii?Q?HebL5XQBtoK1IbwK9aC9BhuUN1ry9rR5QtZ+VRKElgp4PhsLC3+Nuq9jORWB?=
 =?us-ascii?Q?T5ATXl1Gx4b7qsUxwFn0FI7u5suvIqYu6XB5yqZcQYpyWFGdc0J/y4uhlKB1?=
 =?us-ascii?Q?H9VibCgms/bqsJkbSnnzl1lUaAPCwIT4/gl9EA2gLYoCFE35HaZtSlzaHmWd?=
 =?us-ascii?Q?5eYaIAyDu7l++BKRe8pj6NMBuO3muQ16NvuqdwWKJmKQalTsxBq+PzAowW6k?=
 =?us-ascii?Q?9UrC0Ad+9acegiKdpIJtGk3fLoZ/6exbcKZQRFy4xg9n8h7rJeHGyj6YMWCP?=
 =?us-ascii?Q?YNafgsAHXapan76N8obiNBJaTIj+dZlPENInGtsftYqtQXMfOuMTovcs6G2P?=
 =?us-ascii?Q?7olXvw9Q0awRr2UDamnG02DBwuDgnFhSAXrjf6sTV8V2m/q/CvZAEr5QnPQB?=
 =?us-ascii?Q?jJVpVbqDu46aZa2xcWVfUKB+wejBtf8J9gJd3zrFuWIOCdZ2XIRmsajbMQDh?=
 =?us-ascii?Q?rG5pnbzgFlJ6OlEOzJ9gEPff8gdXQ4BOFd+nYmydNkFGXMq28LIR068fnIGq?=
 =?us-ascii?Q?uyyAP4enDYjWD4tWrV3x/z4inxCwkDjgw7c2vDXyWVWmAlOM72ETTj4qK9j1?=
 =?us-ascii?Q?gM0r1PTcW+Y6Hak1zmGk4PlrEFZaMwh/Rrkis/P9FuXH3LP3LtmX0i7EMdqx?=
 =?us-ascii?Q?8kDzG0KZ7ofFiIpWjugWHfNZ6ao/1/sgwf7C/XHmn/y//M3S/9iAvWE31CXY?=
 =?us-ascii?Q?JAktmVtz03TbnqTVnxEDYCXsBki2cjslzRJxzxVHA7pIqRxepKBIcprMMj99?=
 =?us-ascii?Q?IuCZ+7B/C6PkoZajeTIIZd8Dw6Zpve/DxTTocZjq86n92PwdvxkquoJmMiUu?=
 =?us-ascii?Q?nvIQ3cp5vgO5Sh5Er0jhArY9ZqWuUPfcE4p/T58f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f54ad2-02d5-48c4-f721-08db687a4856
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 23:44:21.1439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzsdi1mBd8dPI5H+3bMdF/+N/KZy2XQOSn6lm/9snESg7Pooh0W5CozenSX0/8Ta/xe/AGqBCIoQysSrmnpvNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 9, 2023 5:41 AM
>=20
> On Fri,  2 Jun 2023 05:15:10 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This adds the helper to check if any device within the given iommu_grou=
p
> > has been bound with the iommufd_ctx. This is helpful for the checking o=
n
> > device ownership for the devices which have not been bound but cannot b=
e
> > bound to any other iommufd_ctx as the iommu_group has been bound.
> >
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/device.c | 30 ++++++++++++++++++++++++++++++
> >  include/linux/iommufd.h        |  8 ++++++++
> >  2 files changed, 38 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/dev=
ice.c
> > index 4f9b2142274c..4571344c8508 100644
> > --- a/drivers/iommu/iommufd/device.c
> > +++ b/drivers/iommu/iommufd/device.c
> > @@ -98,6 +98,36 @@ struct iommufd_device *iommufd_device_bind(struct
> iommufd_ctx *ictx,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
> >
> > +/**
> > + * iommufd_ctx_has_group - True if any device within the group is boun=
d
> > + *                         to the ictx
> > + * @ictx: iommufd file descriptor
> > + * @group: Pointer to a physical iommu_group struct
> > + *
> > + * True if any device within the group has been bound to this ictx, ex=
. via
> > + * iommufd_device_bind(), therefore implying ictx ownership of the gro=
up.
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
> > index 1129a36a74c4..33fe57e95e42 100644
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
> > @@ -50,6 +51,7 @@ void iommufd_ctx_get(struct iommufd_ctx *ictx);
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> >  struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
> >  void iommufd_ctx_put(struct iommufd_ctx *ictx);
> > +bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_grou=
p *group);
> >
> >  int iommufd_access_pin_pages(struct iommufd_access *access, unsigned l=
ong iova,
> >  			     unsigned long length, struct page **out_pages,
> > @@ -71,6 +73,12 @@ static inline void iommufd_ctx_put(struct iommufd_ct=
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
>=20
> It looks like the v12 cdev series no longer requires this stub?  We
> haven't used this function except from iommufd specific code since v5.

You are right. It should be dropped.

Regards,
Yi Liu
