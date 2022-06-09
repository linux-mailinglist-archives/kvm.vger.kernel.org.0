Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1681D544459
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiFIG5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiFIG5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:57:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4733B4040;
        Wed,  8 Jun 2022 23:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757830; x=1686293830;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v4qxUI3VdzfHEURH/NOqVB9DvhMjhud9tgaFcO9eN/A=;
  b=ZUmMve1LttSxSIp/wv7R4DmhqCAeo3+aznfpaMf01kuEopFE11RdsXix
   N8UJsNPjrzbapRlA3y/pj693LweEKs/ZbvlTH/L4jvI0NuxKlZ2VEc571
   TjkoMxbyPtMOpHWaZ4JjvwQWTjITQIgJ2DhJWBhanFto7CJSa9hS3geJb
   Y+KQdWzf5FRMo4PwhAX6AxOGuf9eJU2bK7fj8wPUQlKyVZ49E+KoXsHI8
   q8sDEKCFk8xFOJfJiWMa1nWgC9tfcRfHfcWIiqkG258XD7ClFeCMzrdHC
   xCd1kYBkOv18APLDg9iRyRPNEWCKOLk2P8kO3WqAQD0YyXo+Ijyl4Exbo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="341258629"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="341258629"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:57:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="908120058"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2022 23:57:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:57:09 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:57:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:57:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:57:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrAMdjXp+Z2CZhw+k2HdyOQ+ynzrx7cdNhdnYoPvYrq/Ixw5TNpuNW3YAN5BYEd+LQRrNDFRBj8fxAdKqH3Mij9wyNu7vVaWd+G69y7uPVphcdi48CJsid3z0qy919PNCXQ64kmYqxZXcHuoDkVBypLeiaR7NamrGVu6NBpC/+BmnSUA+5srQxvilhj3EWrAoOg5/ZSyMjztZzyFZNCipnYwe8w15ZSt/qIcjzWQR1MwP2NA6IUGwx8YsY6+tRkIA/aVYc/MCrjYsN58hf2nixWqV+MGnJLvEfMUL1FlX/ids5oEZda/3LMJ3AdPIUPk6sEHWOB0wF+XxDFMK8Y1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h06iZJEcpR0670a0VwmmtlZWtJblBWKRa3AZ4nDq3zc=;
 b=RZ+7csxhxDDGIAnZ13t0iXw+2DCCBE8WqLKxgMN5Yr6IApV/nEVwmIyyuiPYp2j+FgF8YG0DgYj3j0g297ccK0BKV4r5AYB3FR2iNQvoBVEDkHPqZDA+IPuQDiYjqDZ7sEo4UAJMUcU8wL0ME6wF/tBdaZ1w1OPruEeZZTzGwy7cHJ4fNeUWiNTnrkFNQNbfvPAWo/KMKmLzfbvTiamA1sJBcu4vGqifyPcV/o3NOLdxqhRkdg0wcZymyXYD85GTlIoh27qALCipzLjt0Pt+F2W5C6Bvj/BSLPexPjhamz90imZuM4mOT8TamQo0YICwhvoEpOVT5GNPSj80xXH+Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 06:57:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:57:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 6/8] vfio/mdev: unexport mdev_bus_type
Thread-Topic: [PATCH 6/8] vfio/mdev: unexport mdev_bus_type
Thread-Index: AQHYdxPp0ktytnaukUOmcQ8QyyiuW61Grf9g
Date:   Thu, 9 Jun 2022 06:57:07 +0000
Message-ID: <BN9PR11MB52763B9793DF061BFC2727DD8CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-7-hch@lst.de>
In-Reply-To: <20220603063328.3715-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2fff55c-ff49-4e37-eb2c-08da49e54495
x-ms-traffictypediagnostic: SJ0PR11MB4976:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB49769D54B66E03733D1705FF8CA79@SJ0PR11MB4976.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BtpSb1/0tqQGPAUHtGtK4QKZkyMnY1kWxhZzYJUxwD0MNsTfvTM4fEWmeMMq+20t7qLHTF7K3cQHfNYzVDkj+CSbIMklpUFXKeZBfQbgQV2ssjPB2Ln0K//5ABD9BSfl/dKZ1+jPoWdKkaU/GL8U+Zh28ZxepTkUf3fk91sqcVIdZatoqisILL0gc/h8QDeCIt9VnjU1TQi+l+Yr1i3EscefSjov8wLQfQjljUFKVD9HqbRxshVayldhmWNIwgZmNEJM9QspkGE59JWsdE5z4T+MROJWa1Cu2qiqE3aJv3erud0GILbzN1kWcz5Ge/4g0SQQ/cOsQ6LUnOGVKRuKQ+pLy1oCA6yVFDiWy9mPPzvTvjj1Ft2Z6LFZVB/tvzJhjUP4yuZx26VcBYiSdRYd5dAXZm3y3PxKAXQUwL6JLEbPHpSG5k+Fabp0cxVFlv+2leFWCN36p7z/JLW06T0pOMLlNEv12IN5qx5x7tGBdvyzoLp1IJM5CKWgdsw4LtcYVGQ8TedRk3r2WgxjxbyLNZV/hh/4JLp1DpSBASXTu6inIhksozaPe3Gm3BRBn5BFarKX0mp4o2MweFtWps1ZJ5iYksUtT4YeRfN6G9kyrgPr1jJSh48KTkvZ518etUMbSdnHTqPjayBweYczRHaIBEbb7h4tNODuI9lyxsUTRRRrdFi8pt09MBj4q3uEHNyrERIk+3qrC30zpDckCej0I0HzqiMoVJTXlPV7+HR3dWo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(2906002)(6506007)(83380400001)(8936002)(7416002)(5660300002)(26005)(9686003)(55016003)(508600001)(52536014)(316002)(122000001)(110136005)(921005)(38100700002)(8676002)(4326008)(38070700005)(33656002)(82960400001)(71200400001)(186003)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MADQfCZHpHs0LFITCf6C2CfIUa8rXhh+kYPYgHHtTFvM21ZvxgfZxeULrEyV?=
 =?us-ascii?Q?ziosavx60Yo5zGY8mvQiig7n0olyYgRG++z9PUE9X95Y4EBfApoxJnfHVWKq?=
 =?us-ascii?Q?F2/8nn/1V5d/yjf2WxOi9ZSCo0vPu1VtUcVNjJQKXl4rSA8nV2Pi7hDR/dJi?=
 =?us-ascii?Q?txyjxc8ROsrZD0zZopwesjbp+eYtvJwsBIp+b7iUCayl1j0/l4BIvEgme7Ff?=
 =?us-ascii?Q?q/XKzAzNRFE/mZt5ENkyLQ3qQ8qN82uiD/vj25LY8p6mgkwqDFDmg55wMir3?=
 =?us-ascii?Q?uQ9A3LgRCyNkjlcx9bN1ao1a1zC0k2vPbc0adzZrECjVdBXHsq/LQBCgwno2?=
 =?us-ascii?Q?kqj8GGTICpXRPj7p3wHJKylVE+CtRx1Ib2wI0yZ/Iv520MKeZhJ5RExPZvmF?=
 =?us-ascii?Q?hrbhi5FNB4bdSCiX9H/L0x/GHUGAgKP6wF33jyRSMjfDyOsAfgBAkC2nmyFa?=
 =?us-ascii?Q?RrVDM3h+5wAPltVNpfRm/kmXkVrUMvow5jlH4qOv8JUqhb6LG/sGvaYP7dSV?=
 =?us-ascii?Q?nOZ3pwMv2nfE4b2KjdSfi29O5TjBXb1VWLnzJKAb+2pw/zLCk/sRRv+WTiNK?=
 =?us-ascii?Q?FnmxJqzYqckI/d8orSvLon/meLhYr2YKXz7i77jF9S+ePJnY74Wj/e05ulTG?=
 =?us-ascii?Q?08LHDQfqZTcQrGdsFKcXHFxpYSrnqqH2iYW5VxT+JFZI+G/laA466MttpQ6k?=
 =?us-ascii?Q?GTa8AnhBSMduGWupY6qgF9tGETVzkwY2HBNpJqEO5+YSCNvFKIiBgCVQ4qlo?=
 =?us-ascii?Q?4eLg0IZDzUn1xooZ3+3hbkh+7bqy4si/eRLkVCrgtHd7pgYh09uhEB9UaAWQ?=
 =?us-ascii?Q?nCdS7nIBXMtReZcfEB20TWJAgErCgGG2cF7h/ji0NTxV0Md7tZ3UusOdx8sV?=
 =?us-ascii?Q?agMdrkWrRTtRMfSXxcKwhzD5wrrRjs6XAS7MwV9OREgYI5BPecykox8/KjSl?=
 =?us-ascii?Q?1/LYpUQgAB4zcmLnsMH66qmq/9Zr5Sn+aQSNXP1+R8CuV757MXljI2J0wZAf?=
 =?us-ascii?Q?2Q7eZjYPZ9HOQS4kGoaA4fBGXpVYm1V7lQh4fzKTzBvWvtFviUmPNijngJWs?=
 =?us-ascii?Q?C+ZDH86wbATYx8OIBU/L0r2oWPdPrkAZduAOzSqMkbe2Z8qYIw8Sys1gn2Zv?=
 =?us-ascii?Q?fDBOwRB01t/c3JIpqGKT5g3GGq+Cmv/ZznYBaSDbRQDo3Y3Nw50uTEge/Zu9?=
 =?us-ascii?Q?tqFmeasamVGffVBI/x9uip/2uXUdK2qhTsaya4LN0gW2wAepX1gSbomxsE1R?=
 =?us-ascii?Q?GrI8VY6sLruO5lxrd26u3wzg7Wb+DoZsr0piF+kY0tKnInCivveNgX+aUQPL?=
 =?us-ascii?Q?LZC7o717fD7Ehs5lEUQlAyV9gdrMLl9YGXLZTYOQDP3SB9e0LbQ4YoMVpsbW?=
 =?us-ascii?Q?RYktguy5ClcpyyFEP6JaZHBAmmMZ0VQqXoWwAZQg55weS7XS5vWNvolCGRFs?=
 =?us-ascii?Q?LKfokL+sHnnARZ3N8Jvd+xj6Y7nBhPmCB95cIdmNjpcneyUS8ymJhDns+g+e?=
 =?us-ascii?Q?miRkgbyaunvuLhNLB0uBXwiTtHkk9/jxyVtetK5p5YckUyoOHauZcF7T2iNw?=
 =?us-ascii?Q?k5LgZ83FnC6yIXTn8uIRKyaKxffn+44saqxq38ealgbCht1FaKVV+PEXot4c?=
 =?us-ascii?Q?/aX/rjhVGF7t+Q2gyKCj6QESEms9x9YGqT91ByT2c7egler0ghwsoixINLu+?=
 =?us-ascii?Q?/3t4o7l6sVPGyS7zVOB/ea5tCwazLTrnHoYCgPpLkjEDIpLjzR0HjTkAR14y?=
 =?us-ascii?Q?lcygr7xTTw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fff55c-ff49-4e37-eb2c-08da49e54495
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:57:07.2892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDXiihvrrLWGCw+OJ3rHMaZWiDdoZPib04s4rbkgDPyQl3fqOy7Vq7LH6lAPSPQSaO5iUXZXkE4WOL9nN3FYtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Friday, June 3, 2022 2:33 PM
>=20
> mdev_bus_type is only used in mdev.ko now, so unexport it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_driver.c  | 1 -
>  drivers/vfio/mdev/mdev_private.h | 1 +
>  include/linux/mdev.h             | 2 --
>  3 files changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index 9c2af59809e2e..dde6adf23b1db 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -47,7 +47,6 @@ struct bus_type mdev_bus_type =3D {
>  	.remove		=3D mdev_remove,
>  	.match		=3D mdev_match,
>  };
> -EXPORT_SYMBOL_GPL(mdev_bus_type);
>=20
>  /**
>   * mdev_register_driver - register a new MDEV driver
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index 277819f1ebed8..3ecd6ae1dfa7c 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,6 +13,7 @@
>  int  mdev_bus_register(void);
>  void mdev_bus_unregister(void);
>=20
> +extern struct bus_type mdev_bus_type;
>  extern const struct attribute_group *mdev_device_groups[];
>=20
>  #define to_mdev_type_attr(_attr)	\
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 5811b5a52a511..f92b4d8edf0e8 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -88,8 +88,6 @@ static inline const guid_t *mdev_uuid(struct
> mdev_device *mdev)
>  	return &mdev->uuid;
>  }
>=20
> -extern struct bus_type mdev_bus_type;
> -
>  int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>  		struct mdev_driver *mdev_driver);
>  void mdev_unregister_parent(struct mdev_parent *parent);
> --
> 2.30.2

