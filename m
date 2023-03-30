Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08D6D05EB
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 15:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjC3NIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 09:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjC3NIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 09:08:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B05183E8;
        Thu, 30 Mar 2023 06:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680181695; x=1711717695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jeTnGfq8TjNydKMaXoJG2MbhIe8Y03bJDwHymhDnlBY=;
  b=E2Nj62Dx4mMLKA8TkfsOCsTL3L6/gpAVF7A81QdJPrhf/uDDI1Jx/egt
   Cz0bohUgD2rnVfOk8UCF+dQnVpJ2pIIsKSVKjvG83uSbKnm44A7VPInaK
   62OICyOJZL87wP7pAPOYBtuEudrfNfMjmkp5guMUKotFnPvasmH+bcTF0
   8I6jhgcyyPBtSBm6lVObQHfW4jovPuskBHwIAD6pNbzOU5AOjesHVzKW/
   Jo8e6FzOQF5HLNG2YQqjvSe0rbi0DTV7Dhw5cWwBjJuLLueu/Q4wGDRhN
   9Roavu39xr8NBkYRu26JS9o84pjIphpKTEJw7YjAOLTD85stlrtBetIcQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="406127853"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="406127853"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 06:06:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="858908674"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="858908674"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 06:06:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 06:06:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 06:06:41 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 06:06:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 06:06:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/DzXKVm5Kdck1uqhqN8wVIw7LjgSOGLrFHau41nYkxheiLzXeInJbY+ki5r9GPOp9SchbSboaf9LWCyXEsODeff+sBgYPBwaZINZuMxZOxv0ctjlrLwT/txFBJs2ZdS9cH0I4WaulqrOKkkQS6KtIofNREIUAfKHQ2vH7y2hjoHvoiFnWjg3ypbZjJ9rlna61Cp70ykWs6Rf5lMDu0b8E7cwqUd91MKL369oi7CleWufz9QKq7iKK45xtZP+EUqmp4AuhZixzJyZUyYJoX6S9NLvKa/IbQDsn3dAsC+NP1Up34Sc+siqNALLZxbK45p6dIacVEhsMj5cF+P4aqeqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEyGT1tkzlXhRCHUJYgaPSqEhhsgaVJ40zKzoBNg7x0=;
 b=jAFntoiFEjq3xsghnrfJpPNb1kXKeWBv6mGXEFx14r5wu/SixmAh8IFrp2CjXvQGhQI1fo6WAvKOTahOCM6so8et2MnfUgAVDU843aniPHaXCbuasp2FmnfdcSCGDvsYPkSCYLzeMhx01dCnnINBlhq8nNOXQcmgtwMHTPbBNV4OwJ4Ud/hYFkiiWPgcniPnfKTxoHqUu8zk75RSZp9g5Ienx/8NWjnIY/cQ6P64mJJFHh05ndFPSi9c9JGzXr/asB5RhEmX8dIzsd2vDpSetZHBBMDpOCPa6f7TTKmij5+MIY0Ml7O2NF/vrosckELj5iANNBU2rDIQdb+fEzpncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB7885.namprd11.prod.outlook.com (2603:10b6:8:d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 13:06:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 13:06:37 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v8 23/24] vfio: Compile group optionally
Thread-Topic: [PATCH v8 23/24] vfio: Compile group optionally
Thread-Index: AQHZYJBHU4+lrve150iUTfuSQS/ZBq8SUA4AgAD+nTA=
Date:   Thu, 30 Mar 2023 13:06:37 +0000
Message-ID: <DS0PR11MB75294C1C51B2B91D6D89958AC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
        <20230327094047.47215-24-yi.l.liu@intel.com>
 <20230329155118.1a76d937.alex.williamson@redhat.com>
In-Reply-To: <20230329155118.1a76d937.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB7885:EE_
x-ms-office365-filtering-correlation-id: 75c5cf4a-4fa6-4f5a-d28a-08db311f989a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b5eaGnohzSP28oKwftL9BBHOA/Q1DsOElnOwOtOwiP1oOFm7JesgGaRGFgO7kJ2YocxcZ9IW/yXxLxAbZQXQOvno6PHrsVKu/EorrgLjh7HJ7b+boR6rjtVsQ+nhnvD8XJLQjehq0Y1j+VWER7BVtLn3SBfp7IscWa6weP8CNKfrtfdyBMiQXs+nHubkaRXmosLBCW6A/WnFS1n0RSCYcNwZ/nDncOIy/SA2iuAnaPdtMXOfoxirfuaNzPZ1/BRUdTv6LrIIHUaaLelZ/s6Z8CDijFx+5MhijLX4dv5eG88+nsnw6hhefpLFn4OoQDN6PSeU7GCi3mR0Y6PljnmqDNyDbrgip7g/H8lemWdN4d/Ly0uZLSzL6dj8bsD1gxjeBYfoi359CrIeRDkZ+xoGUuKF/rZaorYkpu+Lff4lPoMZr9fWW6e7budCarCjrPuA43T5P/ywOYEqOAI7aZfLvt5h6xGE5b4edQeWSS883Nnr2/8vHaV37bxCpHKaLKvifXiZdRx1KOgT63pxJJxVoz32H+P4KJrkhTOHcsNGPP8xC/a7J9ukLrLB+VWMr5orBOQ8FSMD0XALQy+yMeMJX1n1U41EhP5nfksuQaAlBCbEG+ebPon3jFMq2qGDc+hSCtrcSVN9YnMh4pMfFje/aS/cXqiumQnVuNKx3hlLS5hkxXVtRZfCBjDhAwR1+YxD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199021)(478600001)(316002)(9686003)(6506007)(26005)(186003)(83380400001)(54906003)(66476007)(7696005)(71200400001)(38100700002)(122000001)(86362001)(8936002)(5660300002)(33656002)(38070700005)(55016003)(7416002)(52536014)(6916009)(66556008)(76116006)(66446008)(66946007)(4326008)(64756008)(8676002)(2906002)(82960400001)(41300700001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XIXWThBFnAm8oVSH9oQTbXKIrP1q8hQRmpxaZV18U/jC8J8bn4V3ufDsVO2Z?=
 =?us-ascii?Q?6eyf+bjbzAUywolexLlmPyer9Yd9fC07LGowViOR9M85N34nBFvIFTA2nEAG?=
 =?us-ascii?Q?0z7WPTgdJjHMfgMPACSykzqvCkiYh9oEXnpFt/ehCh1MQtVRomC2vYaoyjjG?=
 =?us-ascii?Q?NHfytXDut93H5sZ1iENM53+ZtlcXhlWR+4j4TkF099vy1hLbJkj6/Y4Kq07z?=
 =?us-ascii?Q?BAh1bIbp2mZMW9iXAx4RQIVZBP49kkHMh0zVZ9MW/pV5GNVeZ8ss4I0+S9fI?=
 =?us-ascii?Q?OUUZp2zajNtG2MEF7A/Mv7VPcIm5iK4YSQMP/NmjO00SLXaNzBdjnG80Kd8N?=
 =?us-ascii?Q?AZY+5UhbmOu1VBloEv1ka1ZS67GjEA6qUzubWj0RCQAtzI1jVM67/5LDgutj?=
 =?us-ascii?Q?68YjUnl0ixaOCWJOZv/k5yh1yXTg5rrREEDpNVi+7oRSeR8NaZbKoG1f80GU?=
 =?us-ascii?Q?E3H5HWjoF8aTj5gEuwX3wRvMWuwrkn9eloj+6FWJGZaCcvj6DItuNc4iKHaX?=
 =?us-ascii?Q?wPXRgjPHm3UBEgANzgrcoLjRrXD9YALMWfIbc8DPknhZmCwin22v1oMBYkd8?=
 =?us-ascii?Q?dcTsASe74OTHsMkkQuexVpgylgxW4Rc0Ai5nFpqvuHkGyYX36MEZ2HO0CdKk?=
 =?us-ascii?Q?cPTsMBtGNsLBYlyNPc8/LevM6ZGhzvOQ5LmBAin6TAHt7QpNBGdyOGJNPesI?=
 =?us-ascii?Q?iwD1rPySdI9C3nebNxpHDxmYNP6mAdZFMIWnRpA/wQUyi10vl6fknqMBZcUf?=
 =?us-ascii?Q?lz0qxUtWF1crQRtZhGI43I/HrnKuHtohtp+R4tmmJ3qFYdE6cNknXWVk6PXl?=
 =?us-ascii?Q?+3pn848r0pMnSyHRSJsRRtWFVFajOy3+xWr/rjturX3cf+bt/iL3E5cxusuu?=
 =?us-ascii?Q?zi3/E4kcuoKZVLSc4qsssO6pjz4g9KJ85gp0SvrF1sLp+s1a8xiA7HGA/NrA?=
 =?us-ascii?Q?v0yJPe714AK6I190q5FEzvac6CuveFqeSTNHuGbk3ZyWtUb0poW/Gu9M3bQE?=
 =?us-ascii?Q?AHZZq1+GG5BMSGhBLJeK5nn5yoFFwMBVGeEk7fp2Kw3wsk2LITJtIi0Ob4oK?=
 =?us-ascii?Q?Eeb9pht60DWvxIs7YENpPSPPiHDGaE4U6OdFj9O1gbr5LLaU5XPk8jugVFjC?=
 =?us-ascii?Q?qJSmmWbxFKg5UTY2SXTsbjUTIntSu2bjHmoCOX+tBKWsvibzrK+OtqxMM8eE?=
 =?us-ascii?Q?YHn/2AExGJrp06fkrPx6Bb8OxYs83iyGRiy59eBQpFjoVH1E+rBQC2lz11j3?=
 =?us-ascii?Q?Jl04wtZbxC9sPcIv6DUhkQD9FrB5iMMqXov6+43OOGF3yZF41PtQuycRamYJ?=
 =?us-ascii?Q?FPFXlWV9uVv6YLj9my+6X10UeuaJAjccQYnG0+XHxVrYqvt5wAQSuao5LG5s?=
 =?us-ascii?Q?3DljKEjLkmKPj3AbRupKeTYozH1tMdP2XCMzHBqAszcGBvXZxtqJlh2uFWBy?=
 =?us-ascii?Q?UBYFwgrA5DDtKVEv3W4+W9xtwnch6nU+jnfnopinHnEvXa1SM+neAEyTkdBN?=
 =?us-ascii?Q?uIDw1XsYEPSQspmL62i0ziQWmPJ8HqYpgrhVrppA5f2NrK7UWR+fZtEGU01p?=
 =?us-ascii?Q?fjdQWYj8rmRk74zGbPVLGio0GFmawkeXUSvfshJA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c5cf4a-4fa6-4f5a-d28a-08db311f989a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 13:06:37.6853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qstMkuMYTEvR8DjIutDPhTJWjuG38TUK/T0jVLTlib5nEYcBq9Bi9hmF+URLjgMUuLN4QFM88N1k2aMUvp5iiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7885
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 30, 2023 5:51 AM
>=20
> On Mon, 27 Mar 2023 02:40:46 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > group code is not needed for vfio device cdev, so with vfio device cdev
> > introduced, the group infrastructures can be compiled out if only cdev
> > is needed.
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/Kconfig |   4 +-
> >  drivers/vfio/Kconfig          |  16 ++++-
> >  drivers/vfio/Makefile         |   2 +-
> >  drivers/vfio/vfio.h           | 111 ++++++++++++++++++++++++++++++++--
> >  include/linux/vfio.h          |  13 +++-
> >  5 files changed, 134 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kcon=
fig
> > index ada693ea51a7..1946eed1826a 100644
> > --- a/drivers/iommu/iommufd/Kconfig
> > +++ b/drivers/iommu/iommufd/Kconfig
> > @@ -14,8 +14,8 @@ config IOMMUFD
> >  if IOMMUFD
> >  config IOMMUFD_VFIO_CONTAINER
> >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > -	depends on VFIO && !VFIO_CONTAINER
> > -	default VFIO && !VFIO_CONTAINER
> > +	depends on VFIO && VFIO_GROUP && !VFIO_CONTAINER
> > +	default VFIO && VFIO_GROUP && !VFIO_CONTAINER
>=20
> Shouldn't these simply replace VFIO with VFIO_GROUP since VFIO_GROUP
> necessarily depends on VFIO?

looks so.

>=20
> >  	help
> >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies on
> >  	  IOMMUFD providing compatibility emulation to give the same ioctls.
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index e2105b4dac2d..0942a19601a2 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -4,7 +4,9 @@ menuconfig VFIO
> >  	select IOMMU_API
> >  	depends on IOMMUFD || !IOMMUFD
> >  	select INTERVAL_TREE
> > -	select VFIO_CONTAINER if IOMMUFD=3Dn
> > +	select VFIO_GROUP if SPAPR_TCE_IOMMU || !IOMMUFD
>=20
> This needs to be IOMMUFD=3Dn or else VFIO_GROUP cannot be unset when
> IOMMUFD=3Dm

yes. btw. does it mean the "depends on IOMMUFD || !IOMMUFD"
also use IOMMUFD=3Dn?

>=20
> > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> > +	select VFIO_CONTAINER if IOMMUFD=3Dn && VFIO_GROUP
>=20
> The fact that CONTAINER depends on GROUP seems to be sufficient that we
> don't need GROUP here.  Thanks,

right. I added VFIO_GROUP as I saw a time that container code was comipled
when IOMMUFD=3Dn and VFIO_GROUP=3Dn. This encounters compiling issue since
container code refers device->group->xxx. But this should have been fixed b=
y
selecting VFIO_GROUP when IOMMUFD=3Dn.

Thanks,
Yi Liu

>=20
> Alex
>=20
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/driver-api/vfio.rst for more details.
> > @@ -15,6 +17,7 @@ if VFIO
> >  config VFIO_DEVICE_CDEV
> >  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> >  	depends on IOMMUFD
> > +	default !VFIO_GROUP
> >  	help
> >  	  The VFIO device cdev is another way for userspace to get device
> >  	  access. Userspace gets device fd by opening device cdev under
> > @@ -23,9 +26,20 @@ config VFIO_DEVICE_CDEV
> >
> >  	  If you don't know what to do here, say N.
> >
> > +config VFIO_GROUP
> > +	bool "Support for the VFIO group /dev/vfio/$group_id"
> > +	default y
> > +	help
> > +	   VFIO group support provides the traditional model for accessing
> > +	   devices through VFIO and is used by the majority of userspace
> > +	   applications and drivers making use of VFIO.
> > +
> > +	   If you don't know what to do here, say Y.
> > +
> >  config VFIO_CONTAINER
> >  	bool "Support for the VFIO container /dev/vfio/vfio"
> >  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > +	depends on VFIO_GROUP
> >  	default y
> >  	help
> >  	  The VFIO container is the classic interface to VFIO for establishin=
g
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 245394aeb94b..57c3515af606 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -2,9 +2,9 @@
> >  obj-$(CONFIG_VFIO) +=3D vfio.o
> >
> >  vfio-y +=3D vfio_main.o \
> > -	  group.o \
> >  	  iova_bitmap.o
> >  vfio-$(CONFIG_VFIO_DEVICE_CDEV) +=3D device_cdev.o
> > +vfio-$(CONFIG_VFIO_GROUP) +=3D group.o
> >  vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
> >  vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
> >  vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index c199e410db18..9c7a238ec8dd 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *device=
);
> >
> >  extern const struct file_operations vfio_device_fops;
> >
> > +#ifdef CONFIG_VFIO_NOIOMMU
> > +extern bool vfio_noiommu __read_mostly;
> > +#else
> > +enum { vfio_noiommu =3D false };
> > +#endif
> > +
> >  enum vfio_group_type {
> >  	/*
> >  	 * Physical device with IOMMU backing.
> > @@ -60,6 +66,7 @@ enum vfio_group_type {
> >  	VFIO_NO_IOMMU,
> >  };
> >
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct vfio_group {
> >  	struct device 			dev;
> >  	struct cdev			cdev;
> > @@ -113,6 +120,104 @@ static inline void vfio_device_set_noiommu(struct
> vfio_device *device)
> >  	device->noiommu =3D IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> >  			  device->group->type =3D=3D VFIO_NO_IOMMU;
> >  }
> > +#else
> > +struct vfio_group;
> > +
> > +static inline int vfio_device_block_group(struct vfio_device *device)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_device_unblock_group(struct vfio_device *devic=
e)
> > +{
> > +}
> > +
> > +static inline int vfio_device_set_group(struct vfio_device *device,
> > +					enum vfio_group_type type)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_device_remove_group(struct vfio_device *device=
)
> > +{
> > +}
> > +
> > +static inline void vfio_device_group_register(struct vfio_device *devi=
ce)
> > +{
> > +}
> > +
> > +static inline void vfio_device_group_unregister(struct vfio_device *de=
vice)
> > +{
> > +}
> > +
> > +static inline bool vfio_device_group_uses_container(struct vfio_device=
_file *df)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline int vfio_device_group_use_iommu(struct vfio_device *devi=
ce)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> > +static inline void vfio_device_group_unuse_iommu(struct vfio_device *d=
evice)
> > +{
> > +}
> > +
> > +static inline void vfio_device_group_close(struct vfio_device_file *df=
)
> > +{
> > +}
> > +
> > +static inline struct vfio_group *vfio_group_from_file(struct file *fil=
e)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline bool vfio_group_has_dev(struct vfio_group *group,
> > +				      struct vfio_device *device)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline bool vfio_group_enforced_coherent(struct vfio_group *gro=
up)
> > +{
> > +	return true;
> > +}
> > +
> > +static inline void vfio_group_set_kvm(struct vfio_group *group, struct=
 kvm *kvm)
> > +{
> > +}
> > +
> > +static inline bool vfio_device_has_container(struct vfio_device *devic=
e)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline int __init vfio_group_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void vfio_group_cleanup(void)
> > +{
> > +}
> > +
> > +static inline void vfio_device_set_noiommu(struct vfio_device *device)
> > +{
> > +	struct iommu_group *iommu_group;
> > +
> > +	device->noiommu =3D false;
> > +
> > +	if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > +		return;
> > +
> > +	iommu_group =3D iommu_group_get(device->dev);
> > +	if (iommu_group)
> > +		iommu_group_put(iommu_group);
> > +	else
> > +		device->noiommu =3D true;
> > +}
> > +#endif /* CONFIG_VFIO_GROUP */
> >
> >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> >  /**
> > @@ -356,12 +461,6 @@ static inline void vfio_virqfd_exit(void)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_VFIO_NOIOMMU
> > -extern bool vfio_noiommu __read_mostly;
> > -#else
> > -enum { vfio_noiommu =3D false };
> > -#endif
> > -
> >  #ifdef CONFIG_HAVE_KVM
> >  void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm =
*kvm);
> >  void vfio_device_put_kvm(struct vfio_device *device);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 8719ec2adbbb..1367605d617c 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -43,7 +43,11 @@ struct vfio_device {
> >  	 */
> >  	const struct vfio_migration_ops *mig_ops;
> >  	const struct vfio_log_ops *log_ops;
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  	struct vfio_group *group;
> > +	struct list_head group_next;
> > +	struct list_head iommu_entry;
> > +#endif
> >  	struct vfio_device_set *dev_set;
> >  	struct list_head dev_set_list;
> >  	unsigned int migration_flags;
> > @@ -58,8 +62,6 @@ struct vfio_device {
> >  	refcount_t refcount;	/* user count on registered device*/
> >  	unsigned int open_count;
> >  	struct completion comp;
> > -	struct list_head group_next;
> > -	struct list_head iommu_entry;
> >  	struct iommufd_access *iommufd_access;
> >  	void (*put_kvm)(struct kvm *kvm);
> >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > @@ -270,7 +272,14 @@ int vfio_mig_get_next_state(struct vfio_device *de=
vice,
> >  /*
> >   * External user API
> >   */
> > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > +#else
> > +static inline struct iommu_group *vfio_file_iommu_group(struct file *f=
ile)
> > +{
> > +	return NULL;
> > +}
> > +#endif
> >  bool vfio_file_is_valid(struct file *file);
> >  bool vfio_file_enforced_coherent(struct file *file);
> >  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);

