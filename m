Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95556F00F7
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243048AbjD0GmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjD0GmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:42:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27952ED;
        Wed, 26 Apr 2023 23:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682577720; x=1714113720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TDtypYs9Dq0ElcleIego6sroWny0h6GBcY2UPNvtRFs=;
  b=A4tW3fmvqZUVjHbTsEOBj5Rr+Tj7s7iVUG2i02GmRCNpCe+zhrLTKWa1
   ZUDjYQ9HjLi2TnPYZF9WgvswTVAYteM2moHiPsOfN1wG1ZMYwHIcVg5GA
   B9kjpwnlQATjux4p/nchekFhBr76e5tD5/Fj5MnQAmlEGko4nGHJ8Zr/0
   rqiZb4dSqzjESqGXp0Jgtqst/nBWWp1YyPI7U2PqjUXefd8azt6i5Wssr
   NtvSiW1xRMuuZDzPkhNI7CdFwhcu6eiHnYKs0uQz5MTpt6Nd3OzwLZV+2
   ctZekzGrSwR+I2vRtrUj1KclkvyXNUtKwB0ZUd8/B634ydyTm9NaqwCo9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="412676825"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="412676825"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 23:41:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="818407178"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="818407178"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2023 23:41:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:41:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 23:41:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 23:41:58 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 23:41:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9l64ZItj0h3+D7ie1whLkZHE2yMQKINqVafvTcWmEb2scXZAnUvwUJCrJvI/KuCTsMJtQG2CxY//fPkPs5bmc0YhGV5MeGSNrQ891X4E6x5LWZup1zGWxAmnjwlcfJnme+xmiUcjcu1DQm2HTWDkvy0EZla+sptiW98+rJvlbed5qXBK28cD714+cgTkMbVQUxIGo3kjw8nrhTNqIkadUm36ZRfSuSb/e5DPOrZpJ0Ex+YeNDVyOWFf/mFB1lVtJCGJd1Sy8ludoiYbFxx/pSdyU8cYNbiwwqRvH/Tx9omIjyO81LDufERQlAjAdjDpavyUZgU400ph3eZWvYkzcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCx96+T3tZHpsDfBUT3MELml4/fOFWqGUVlWePPM+Cw=;
 b=G2Z77ZWpFNNwXu46/W2b7dBX315Z4aGWl/MZ8nB433LVudnh67DeIS0D9DIJawK94BNMksGPxhUnugcdG06Hn93cG9cU+A7rk+DwvTCRgcJdRZFpMNiSfgrSkZwLflmpdv+RfKAN8mXJ/iZSfCtgpP/StZkd1eMuysX8Bi5UtCW/ftu8sz3CdBl8dztK9S1VY2ceIWncq67dLh7nX3rayUVcmA7TeE2BECr6OKoiwGky6Jbq1yHipGTcYSdjaR1t/E/K5SXRC7E1WURZjubisCeyLCDt2eOXVR8AHpyrNOtiYIEggRaVDS4/uJ1jooMfXg8L6ev4dgbU+dV6X6WZrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7358.namprd11.prod.outlook.com (2603:10b6:8:135::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 06:41:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 06:41:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 6/9] iommufd: Reserved -1 in the iommufd xarray
Thread-Topic: [PATCH v4 6/9] iommufd: Reserved -1 in the iommufd xarray
Thread-Index: AQHZeE8KwtIG7msH6kmeho1lE0GUqq8+tahQ
Date:   Thu, 27 Apr 2023 06:41:54 +0000
Message-ID: <BN9PR11MB527637C7DBBC4295F5A3BA358C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-7-yi.l.liu@intel.com>
In-Reply-To: <20230426145419.450922-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7358:EE_
x-ms-office365-filtering-correlation-id: b5deb968-953f-4dcd-3fc3-08db46ea7d9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /KaSu7aVyTiDik03NxPnve6ULfArDdIBSJ0nxfXR/j3a5TdH5bomFp4orqwlS8sa/URuUCPfvmK7fZ/+tuzg87mzKBs59GlZMYZr9pbXNI5JDnnvI+zC9DW7WTE+JffmsT/r/gTz/ON6QZMk0vqm0liVh/qOZsi3IrcW9b2jerCwgZXCaHif61TN5wJYKU4Ak+/JrWKrF9JoadlJ75zBehFJ83po6lQVNejXkN0Kj858nb4552P5IwBnE/ImuUYE0U7Rb56pR57vRfm7BUaiPsNspn7olaHiehTJnPtVLuj7d1JgHW6cTwsB4TTbX6V3IDXF5BI6oTVUkPE7XDT//moNXjB0uZv4Y05NDI38IT0UgmelfFXG+VFoKH4wLm1h8gkYMbKwhC2R3CuEl5B7kj2FNF5IU2dl9AEIlSZAROwT5fay8xIolsfNj/zZPIzSQ9/bJxVGLlUFYrfVoajNHwjXsqsM0OyXY57rYAFOZUgVVkh2PLRBHAXJ6bzCzXU++tMWjdQkoJgEh3gQKfwji8wBrgLWOTHNoLTUXgAkUkvWDpnYkFgpbyJ2bYzk1tJNAmplbpjixsLJvafOT9M4aDCqTZNZOP+OXvFyRZQfWWBAbQL+VWEPQbAWhJEHd4lw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(54906003)(110136005)(4326008)(316002)(66446008)(76116006)(66946007)(66556008)(66476007)(64756008)(478600001)(41300700001)(86362001)(71200400001)(7696005)(8676002)(55016003)(5660300002)(8936002)(52536014)(2906002)(7416002)(82960400001)(38070700005)(33656002)(38100700002)(122000001)(9686003)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bNS0OW8QJ9TtBXJMARkQ4baQQ1aQkvQvrx6VIfMtHMKxuKaGrxk6QcdeTYip?=
 =?us-ascii?Q?zwNaKZC295Fn6bx89ZHj3jiMVtEwNxTU998TuxwsZZ3OmiERVtcmeKme4PkC?=
 =?us-ascii?Q?8EFrZ+h1n/4H4CDbWsHutMskT93zDlVtLSE/8cB2g1zi5mamYWFHOLN9+wJH?=
 =?us-ascii?Q?D1Rc87XeK0UvUHgwT4HkNMwEPpQ9nlZl/w9B15tz1Y6/2x/p2T3Hn3hr3ZyL?=
 =?us-ascii?Q?ybd30vWKq37wGDMbrsEWnW/BZgZ2XUfO83w2Ic0xW0tJrOKxy83JR6jTlwDz?=
 =?us-ascii?Q?ZlcR4BRipeKxCHumx80voHxJRuHX/eRZbwoLBgzgw1dyOes2B+6/Mk1e4ALG?=
 =?us-ascii?Q?ruAqYG/rx/SiAd1IIyz10zvoQ1qBLYaX5IuOH0YkNZs50pQXc1BX34+oFy27?=
 =?us-ascii?Q?cbG8pqfinXEGVvPe/837A4ArCa/sQ7ef9xWmb/o5cfBQBba+F30ikGUSXs1m?=
 =?us-ascii?Q?K9o4ij/5xE6Gk2dQFcZj/Hmx0TEUZjlnpuEV17ipLX3G4/kfIUGWAp44Vjmd?=
 =?us-ascii?Q?MS+Zk1Z/7AybYryWNWpVfr57Rtzmo5X9mFrjVsdc+DrXSwtTMEdWVXhmKzvJ?=
 =?us-ascii?Q?kEMTdSzLKu8p42oZUI7W5JvbqAsHQ4HGci1leya2t55vwMW9+3QQLkAGeCGH?=
 =?us-ascii?Q?yjXFJCysAo8LLFcK1DAMV5xxWJjhi5tmbUR22svWxegic3rPdRpdQ2+k+j+z?=
 =?us-ascii?Q?vhqQiOTY8ymfPROFOsxVS0QXB/ZwEc50Z+2lC9Hz1pl2vetYazsKvXnucPKa?=
 =?us-ascii?Q?JKWnjNxdBY90WtPhIlSnr8XlzyI3WPnc7fjj2zln7CZ80c/fWP87xeDszlMn?=
 =?us-ascii?Q?B5ntGzlwMTfh5WWV6/XvlwRVcp06+ZkJPxFyZeTG4+YeUUz9yu62PKHpJlJ4?=
 =?us-ascii?Q?aK0zFhBE5XehXr3f/MAlrniNo3wz9L6psYTNrcB0yFYxNtrp3cNrtBjeDCzT?=
 =?us-ascii?Q?A5SQYEMboBUYVa7fpz/sg89VQEL1w/bHQtS6CxGXmkReoxD3KKB3KWka4WbJ?=
 =?us-ascii?Q?ZgU0u9UekryV53gYrDRgR616JMUn0yYZFB31zuCpw0Ky//UQ1+9h3TVTtWTF?=
 =?us-ascii?Q?Z/XfjeU3m8tIbLRxthP4xqme+2mLUIQDrjl74B12RAdmfewFXmLrSuslfbpJ?=
 =?us-ascii?Q?+ld7A0vRxkmN6DjTOTRbznx/Osxtmmc6KCH0uN8krGF3SoQyoGnqDIPXg1xC?=
 =?us-ascii?Q?HeK2DW/vK3xSwj1fXQ1IoBtEO2QMdn7Qy4gUh4EjcljccRKLEPVBJkYka2xe?=
 =?us-ascii?Q?vZfWwjT3Y/gXSlsxBYX1MRedtj33Xc5YWtjvJQxxvt822Aylqvw+dK13oVL4?=
 =?us-ascii?Q?s3VsGMzV48SaigBOHMUpkffrog9POBilRsjyv+aNKKAXGWnBePxLcytQxeqF?=
 =?us-ascii?Q?B/VBdMrNYet4eH7Y4rsUgYnply4MpFnqcMvIJ1PKZbnT4B4wnoqZQWIofZ4n?=
 =?us-ascii?Q?DjXs+aEpZpUnGuH+F4sKNzQcS8muQY8p6MvimB0dOfbPntzsSkj/F/Ukih2R?=
 =?us-ascii?Q?0SrzeSgbOnDqldDn4zwiXU3jbRCEM22fkTnOKUkDoa/YNSVaxH0S0i2GRoSu?=
 =?us-ascii?Q?mjXLKS48IEEPFunW+jgnGw6riM6KW6PtD6stJxc8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5deb968-953f-4dcd-3fc3-08db46ea7d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 06:41:54.6810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddNZtzezaE1oBaf60+UMY8kFkEw4QouoCqlZ7YpLS2pzOfuTm1jIb7t6159MGewxkay75lIVTzeSnNfTPvCdIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, April 26, 2023 10:54 PM
>=20
> VFIO needs two reserved values. 0 is already reserved by initializing
> xarray with XA_FLAGS_ALLOC1. This reserves -1 by limiting the xa alloc
> range.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/iommu/iommufd/main.c
> b/drivers/iommu/iommufd/main.c
> index 3fbe636c3d8a..51b27c96c52f 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -28,6 +28,9 @@ struct iommufd_object_ops {
>  static const struct iommufd_object_ops iommufd_object_ops[];
>  static struct miscdevice vfio_misc_dev;
>=20
> +/* -1 is reserved */
> +#define iommufd_xa_limit_32b XA_LIMIT(0, (-2U))
> +
>  struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>  					     size_t size,
>  					     enum iommufd_object_type type)
> @@ -50,7 +53,7 @@ struct iommufd_object *_iommufd_object_alloc(struct
> iommufd_ctx *ictx,
>  	 * before calling iommufd_object_finalize().
>  	 */
>  	rc =3D xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY,
> -		      xa_limit_32b, GFP_KERNEL_ACCOUNT);
> +		      iommufd_xa_limit_32b, GFP_KERNEL_ACCOUNT);

Just direct use XA_LIMIT() here.

btw do we need a contract so vfio can learn 0 and -1 are reserved or
fine to have a fixed assumption in later patches?
