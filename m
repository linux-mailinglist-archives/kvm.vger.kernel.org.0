Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C01674E15
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 08:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjATH1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 02:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjATH1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 02:27:01 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE1B79EA7
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 23:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674199620; x=1705735620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=13WubAAuRMMiGDMD6gRphCsVGXyglUkxn2pBHbCY0/8=;
  b=Ii9+Gf++vjB8QD8TYQlA51ePYZrodduo/7uZediaXReQjDIUFbz8jkiy
   tOsOqSRsolQMMVVvpp9DmEGr4P1beEl/aesLQcLYdXRUQ85lA92xZiD6J
   5Pz9v/Gayhw8py2xV+IbCCt/LrVo/tQ0/EYrc7beA/UdOKxUmUVaswx5A
   f0UQXJDJ4LD21i/v0awEEfx+Xsb9yHnrbDXxloZ3QVOpZSB1Z9rNVi57u
   QoRvvEYNOHJpDdzz2MMuKp3quVkGxlVsMnnMEF0+pLrXsTUtkhQhlWJPP
   d52M44aOjOFBLDiCV1B79vMsQ1v87vIMAUUgYElVIb38HRhcwK44rru4R
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="309100124"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="309100124"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:26:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="802982156"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="802982156"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jan 2023 23:26:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 23:26:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 23:26:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 23:26:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 23:26:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0tBuKnqZlWGrycqzOuT8dEBALRGmEUK0GvArlnB+weNnefoe608dja+84au9pLmkoupIfSWQIoj3CcP5rZ8kKiuBLFmWyh7AgpmTDkYifhUf6uolhyIwSt0o9CiCiI5ojlAYkYl10QCxedIlCPjFFsqs+MbyQuLfopZ4wzYyHpE3okRCTosB2MLAtTk0hVXwXGHfiddn7b1BbPaqD7tV/CNCV7d4vR6pW2LURFypSof6CGqvoflMmWFZoBmJD/HAMN5q5QzyrwUMEaxvljtMW4ezWBQraVw82WgX1Dx5o26PqFYSJvD+fRHMlqmAcQTLVxtJ8GUEWVgApXOilDgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJkdBRN37U3BSblJ1xdLJS/OOFaiFLD7ZbYtlqKZntM=;
 b=F3jfETh3X7eJs92NnAgmFf65J2osveFlT0CQFpx4PiWYuugD/iN6FBWSIZ2I1N9U6Pe/kEF07OD9LQX9sonPNv7oSDKvt0nLHBGQKEB7CFjFIOi2iYFYpUh+zLxIbXMqAytORPTEj8sLw3QC+C/5sZOjztyt5n8VqdUjjLONPiO9Zt7w3xYzCCAluxxvwXRjmGRQNRHKOZ9cfhSFl6zNK5Z2yx5SDcf4EKAEQQwlyqpgvVQ8cVr8iR0VjJ6TBGTT3xNbEFTyAjnmHbKxSrqH/RC8o9JoP5hh2TKF78uiTqVcRUZLLMiuSFpqF8zQ8I8XcyhL5GOtuTDfK5HYblg1/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7993.namprd11.prod.outlook.com (2603:10b6:806:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 07:26:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 07:26:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH 11/13] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH 11/13] vfio: Add cdev for vfio_device
Thread-Index: AQHZKnqa3mqWSji0hkmOFPzpVcOlY66m6DaQ
Date:   Fri, 20 Jan 2023 07:26:55 +0000
Message-ID: <BN9PR11MB52760F47BA7B584015225EF68CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-12-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7993:EE_
x-ms-office365-filtering-correlation-id: e65de0b7-b928-43f6-8586-08dafab7b516
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2PfJ7vtTRZVDsAKED2tOKpznTklRqJkIPLvZsIH13y1drAwoeaOckUxNUCh4nPRF6lglVI7c6CwEI5E1/p0Op/qX2Uy1kKUogbR/uJW8aF+ARyFh1KvyOj/mSV8X2x9O3ygu7v7+eSn3EdT4NoplQ2VC8WWI6o77TQlExpE7Kb+hSNVAPcZTEHkRq4Yx8n1QTtRm5qMZkHw/9s2O2UWq4uX1dyn8urz9fGieAvym/d+CauDfzUavzmv0dl0uamEuusxU6BBoENZHJJx3pcV/Z/FEgdoXqdNkWYDO/vygKaKhgNnK3TqPl7SOwI25r4SX3yWvm83QwKioIuUNyE1rIrrL4z1uOWvhRamfgjQ/sRPmEHxYf53HQSLEc8yide5rBRbRpWCBWbrcwqdQiNabiOY1X+yZlUbAoucDJDBq1PCdlp5/vCdnf8bln6u7d4grLcchXWT86C9wzZqpnkVbbFy14mQpSOKuCCEIELh7GWtnXh1I3hRA6PtWgbYFkAJZ2FjVXrD9cFmbN9HVv2ZKFR9tltqaiNrrvDsI0im3Xmdk4ChAfBFq9j1lJEqBDn8OHj4ehzdrKFUKkQEOOfEwPk5uHG3HE/+KJn2AopmrKuulhAjY/virqeMuX7t8iPZNQgwyHfaDTWkle5tsLtSRd19BdNTkHwZKIlCcA19uAIIJ6s0397wQJ/50NlItR+eXuvAB/avG6zHQd2SzPEa0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199015)(2906002)(26005)(186003)(9686003)(54906003)(110136005)(6506007)(316002)(478600001)(7696005)(71200400001)(122000001)(38100700002)(86362001)(55016003)(38070700005)(82960400001)(33656002)(83380400001)(41300700001)(4326008)(7416002)(5660300002)(8936002)(52536014)(76116006)(66946007)(66476007)(66556008)(66446008)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XzEOfP65iEA20Ztrt0zCH/WSLb1Yxpl4kLu51B7ABrwHfKIzz0hP5pG5bFLd?=
 =?us-ascii?Q?Kms3dHrdLymK3UDGhZRPRf7DU4tIQIbqjVLADu4wVeQ8wHtF4hBJWc4gnXJh?=
 =?us-ascii?Q?+OrPgKtZCT3RJa5xsOu92/0kY2A5VEiBtEcBGlUtqveedYnWsgEy6np5wFX3?=
 =?us-ascii?Q?VkwVuaeHgJhhdaZWxpiP454Z0DaPhPanBdYh5LNqzLAf5vWmaibNKk5J1t8n?=
 =?us-ascii?Q?AyDzx1Pv+V+T0CM00XcCBWBWj1ET6e8p5kBPArk82Jk3IAb9fl94t7QnAIAj?=
 =?us-ascii?Q?yasBykxf6CmwHRrgdd4mFf6nDS91qQI/JutRMmvj9hOymgQfiqdYKrkoW1CA?=
 =?us-ascii?Q?czmnTw+5S4sfbvSfi66kApb4BGPKvc+QObON2SvSn6KRm1cfe9bl7wXtwUsj?=
 =?us-ascii?Q?u9tXoPRwfnndUB5MfzB4DNGQ2jgi9IiyMYQ/N7A5mB8HOKWoNDr3DRSLHpdQ?=
 =?us-ascii?Q?zPbgqWr/55SzWI14WFDikBTEqwjEm/BzUTpLt83dhiIXMAxSxyZllxuSTqe9?=
 =?us-ascii?Q?1UZGC9snUOrgx7VTWinEqfyuqmktlO90qjZR+wxj5WIdGRjgroZDBjszR9AB?=
 =?us-ascii?Q?iDpBoaEEP2M9WC//aMMp5rUdyMn2jkqlXjQotwCxGoyMGKHB4Yq0nhZ5VveS?=
 =?us-ascii?Q?8nhFKOf9LBwA7krEn87C4gF9jXhf4GY4x/AFme5KiYCNjDHP3I4iX7O3p1RI?=
 =?us-ascii?Q?MnLR+4/CXFuGgP/FY8CxummlYgYtP+S6CWlxEChTru++r9X3TqkqLJol3Sfi?=
 =?us-ascii?Q?U9Gufg3rw22EJFcsYY6qbtVRkaHLufEBTBpPX37IRN0NQxtZwMoxwZkES18v?=
 =?us-ascii?Q?CeRQ+A1SkZ/Q2zyeTX47X6xRDg4OF9Q0X77uHexXR5AcNPJznakOh7F+gkO9?=
 =?us-ascii?Q?Wc7ZgnxS9konXWOYWMRb1ebYwsM38aoNCTz+BaSBTPCExl2O9Kz2GUuS1NOW?=
 =?us-ascii?Q?fK3zEDR0WN6di2iaW6cZLugnDH274/ra94G5i+2U7qGfFh2VScR1xsaDfiWa?=
 =?us-ascii?Q?OSS+Tw3JeewP3i5aBUYfA6bMqyY2uVBjrKrpsdR9UDeCJusMwr+jnqzUBM9M?=
 =?us-ascii?Q?9Ao2etjYGwX6mmBvCFh52ay/6Zq4izdDaQ7J2QrflKZLjMDxxcPyNOLFLYPB?=
 =?us-ascii?Q?NCRimUR+6H4qO5+d6HvdwjJs050f+BW1raNpZm4qEorV164eby7rs42eLk9t?=
 =?us-ascii?Q?5/CSpwWdyG8atjbN1Zoxl0yEQ8wdtVNoV0meDtHazKExb8LBBW2oCPehMpCt?=
 =?us-ascii?Q?tZvUGso3y/akcUZjLxSXIr1wIBTdOIWY37vHA+ngstSb/X5wzHbEUhDFgmFq?=
 =?us-ascii?Q?t1dMui6EmHnS8qRFeuuppQjY5uZaBFs8QRah1D6IkvfJsX/i2tX90ja6+uSQ?=
 =?us-ascii?Q?v+JIIqnrqFEgWgpFwzSIx45a6L7iYPikKT1n7hzSJ7+kENmv1qftvoq+KpE/?=
 =?us-ascii?Q?sx/gdqP5N9eeVGXtud78s9sSIfoOII/3UwU/1pJHWfCTqzcU8g/xTOqk26tQ?=
 =?us-ascii?Q?l5OrZQCxnI31E88PkwJqQQMOVGQh1wu3P9Cdjzf46RAaAuCpSmZOBunYPa76?=
 =?us-ascii?Q?nMXS0y5ZEmGRlF8Fqq7Ws3wJAFfvozxkNZcYobZf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e65de0b7-b928-43f6-8586-08dafab7b516
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 07:26:55.0301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZOAE4dr5lEeAIRmqX5QB3jKvmg1zFeY9w5UweJzkojc+nnR46vhQUR/LeFTO1adDx125VZW5U88VcnF7TZZBDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> @@ -156,7 +159,11 @@ static void vfio_device_release(struct device *dev)
>  			container_of(dev, struct vfio_device, device);
>=20
>  	vfio_release_device_set(device);
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	ida_free(&vfio.device_ida, MINOR(device->device.devt));
> +#else
>  	ida_free(&vfio.device_ida, device->index);
> +#endif

There are many #if in this patch, leading to bad readability.

for this what about letting device->index always storing the minor
value? then here it could just be:

	ida_free(&vfio.device_ida, device->index);

> @@ -232,17 +240,25 @@ static int vfio_init_device(struct vfio_device
> *device, struct device *dev,
>  	device->device.release =3D vfio_device_release;
>  	device->device.class =3D vfio.device_class;
>  	device->device.parent =3D device->dev;
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	device->device.devt =3D MKDEV(MAJOR(vfio.device_devt), minor);
> +	cdev_init(&device->cdev, &vfio_device_fops);
> +	device->cdev.owner =3D THIS_MODULE;
> +#else
> +	device->index =3D minor;
> +#endif

Probably we can have a vfio_init_device_cdev() in iommufd.c and let
it be empty if !CONFIG_IOMMUFD. Then here could be:

	device->index =3D minor;
	vfio_init_device_cdev(device, vfio.device_devt, minor);

> @@ -257,7 +273,12 @@ static int __vfio_register_dev(struct vfio_device
> *device,
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>=20
> -	ret =3D dev_set_name(&device->device, "vfio%d", device->index);
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	minor =3D MINOR(device->device.devt);
> +#else
> +	minor =3D device->index;
> +#endif

then just "minor =3D device->index"

>=20
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	ret =3D cdev_device_add(&device->cdev, &device->device);
> +#else
>  	ret =3D device_add(&device->device);
> +#endif

also add a wrapper vfio_register_device_cdev() which does
cdev_device_add() if CONFIG_IOMMUFD and device_add() otherwise.


> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	/*
> +	 * Balances device_add in register path. Putting it as the first
> +	 * operation in unregister to prevent registration refcount from
> +	 * incrementing per cdev open.
> +	 */
> +	cdev_device_del(&device->cdev, &device->device);
> +#else
> +	device_del(&device->device);
> +#endif

ditto

> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +static int vfio_device_fops_open(struct inode *inode, struct file *filep=
)
> +{
> +	struct vfio_device *device =3D container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +	struct vfio_device_file *df;
> +	int ret;
> +
> +	if (!vfio_device_try_get_registration(device))
> +		return -ENODEV;
> +
> +	/*
> +	 * device access is blocked until .open_device() is called
> +	 * in BIND_IOMMUFD.
> +	 */
> +	df =3D vfio_allocate_device_file(device, true);
> +	if (IS_ERR(df)) {
> +		ret =3D PTR_ERR(df);
> +		goto err_put_registration;
> +	}
> +
> +	filep->private_data =3D df;
> +
> +	return 0;
> +
> +err_put_registration:
> +	vfio_device_put_registration(device);
> +	return ret;
> +}
> +#endif

move to iommufd.c

> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +static char *vfio_device_devnode(const struct device *dev, umode_t *mode=
)
> +{
> +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> +}
> +#endif

ditto

> @@ -1543,9 +1617,21 @@ static int __init vfio_init(void)
>  		goto err_dev_class;
>  	}
>=20
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	vfio.device_class->devnode =3D vfio_device_devnode;
> +	ret =3D alloc_chrdev_region(&vfio.device_devt, 0,
> +				  MINORMASK + 1, "vfio-dev");
> +	if (ret)
> +		goto err_alloc_dev_chrdev;
> +#endif

vfio_cdev_init()

>  static void __exit vfio_cleanup(void)
>  {
>  	ida_destroy(&vfio.device_ida);
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	unregister_chrdev_region(vfio.device_devt, MINORMASK + 1);
> +#endif

vfio_cdev_cleanup()

