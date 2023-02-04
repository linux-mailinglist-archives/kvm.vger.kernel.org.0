Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3506968A893
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 07:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjBDGYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 01:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDGX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 01:23:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6BE885DA;
        Fri,  3 Feb 2023 22:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675491838; x=1707027838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a4RIp32ZP48FWHUjJO4WhA9g7Ha02faAdYWXCZDUA4s=;
  b=VZLmXlgY4HbbdFTpENSVxmwVgStvfvUff0KOmMxIoTERZSoc3BcfJc5s
   W7liBZc/3x8TroA2YDTme7zKlJdE2aKqH0hPlo//yUDvxB4A7np/denho
   UrBInrAA4ZRP0FwqKJvxWc3m/CFYLNwoogkSqqqVWAc01YAP2DF+Zx6Lw
   Xd/teIovJnfGqKUy8w1ycdQP26ewYfDSwid8fpsbrBwhWoFW3sYmfL4x6
   UBnYwETfReY96UoLKH6essXz3pLnOPfXglUV14uTzZWd+YWLG6xoZ5AnR
   eMJhyMs/Rvmxmon4JkRSbRNHMQd7fpUIYiNLWDMc737pqPuDcHIXbJ8Vm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="312578730"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="312578730"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 22:23:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="615933427"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="615933427"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2023 22:23:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 22:23:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 22:23:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 22:23:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 22:23:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+4/TXkNWbIJKfT5bO73IrwvsAo1jLlEzCI37bYX1AjTKZnWP3cZKFbvHg2TeMpBA0NGQ7AdBu7WazgIYE8EOGfBN0Rnst/gyGxdFhfyBxoclBd42gJSULfAfEaK4Co8a9v6lGSYVyyy0ZvKcxjjOzYpnxi0v5DDzXceBChTwlRBwRtT0cVQaNnReYFU30G44aHAbm5yKNNPGR7Ix8XUomaQ29vbKyoy6OqxUTBb47JyRgfdj8i5nopoH5eWi8CQiPLQygi5fl26c9uY8zQ+6LyPgiSfeH8eZ5OlkpUsRLmbKNla6l+4DG21V0pwIYEozm4aMVNqDMJek04Uv6WhUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AE6eQ3fhpZ96KQnB6v5UGtCicgSGGhHZiMEXHWbhL8s=;
 b=hto5m/oXoS5vmE9rhvejH9qAt9yXcMCqmtt+xfCPmPBcwf7S7wQB1SgjWNt7tz3tiKJastvqDOleJj2/Y7CQYwOPd1hamVtmzP0txQZOW62KhqGg6kKMRtmh/1Q86yJOs7K0yCUwBWTD8aeXtxcBhq0/ad0VujswpYOoBOjVyWk70EAo9TjM/WkEBxlSVVIwYpd1HEEPwqW8OHaNSR0ej4KD4279HCxaR7AF93k9zH1RTNuqw2BEivCpcGNLPkHHnXpVw7dcMjZi9VnUST9y/5DZqv2XTFqj6AObgr449bvfCzx0ny6XgPc6ZvQ9hizeSU/jd9TJVCIUKYTDt9tSXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6315.namprd11.prod.outlook.com (2603:10b6:208:3b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 06:23:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Sat, 4 Feb 2023
 06:23:52 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/2] vfio: no need to pass kvm pointer during device
 open
Thread-Topic: [PATCH v4 2/2] vfio: no need to pass kvm pointer during device
 open
Thread-Index: AQHZOBmTn221w5MAG0K+5msUC0tdgK6+Uf8g
Date:   Sat, 4 Feb 2023 06:23:51 +0000
Message-ID: <DS0PR11MB7529C0AF0C079748413999C3C3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
 <20230203215027.151988-3-mjrosato@linux.ibm.com>
In-Reply-To: <20230203215027.151988-3-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL3PR11MB6315:EE_
x-ms-office365-filtering-correlation-id: cd61d9ea-c9b6-4752-e366-08db0678625c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8vuAk5B/UO7guHBAaLhMwyWpgz8gUl51ogzivEdAe7MzsitttAegzl4OuG2C4hiO8y+uPVgX0rdZ9ujyuB3DsVzldssZ6DixtqoLkDVo0Kq6uc5/Wzg+HGTO4Ck52/77TEovosGPsNiTupmorXommGbV0Lj1pZqhZDvbqdDk7tLYNHyikWFWiCkwW5k0LGZObd624U6mzesxD9h7Oz0wZQlBuc9JALxPv7HLev8fYOk5m4INJ6Mn6BMaC4T+Yh3jEBesFRbMSS/X4EkPKIZOJruD+4jn3MlU0WFmW+/M9UReZ5rE6StgPlcBA7j3PBnbW2MDMs+WQSZ3xoH3LiFGZsHhK9yVv0EE+dWqK0xm0F/SH2liJj1XuzWqnC/5XXE+tR4ICO6uN9n75/rYBzYjxpvCheG4J68DVfMCdQ4lGqsHqjMV/o8WcHGKrNv78rM6Gd/17dQxAxj2YyUYQrJ3UFzaAl4fsySf0GTF1QgO6OK0wtStOvZzKKXgKSSD1beyFiwYswFNa7q5b1lmvb/DBBe9EPH3ef25K7zh5lWBrTmXF6lDyw/zvQUxQ0cp4uT9nve7VDBoMozlhRk/aBY+AVTwN6cB6zEBsNpAjKg21LmPX8H4xE6y7RV2wnkrQ/opKNa31800juDVghpRdKj/KnfawBqwcv6YQW7Z6It+iTK0XZYVhDi+d1qA8KKId1wzLLLF9BJzUN0z7awFggkafNADpbVwJo9L9Vc+hvpQZws=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199018)(41300700001)(478600001)(33656002)(82960400001)(66556008)(38100700002)(122000001)(4326008)(66476007)(8676002)(83380400001)(54906003)(64756008)(316002)(66446008)(110136005)(5660300002)(186003)(71200400001)(26005)(7416002)(76116006)(9686003)(6506007)(86362001)(38070700005)(52536014)(7696005)(55016003)(8936002)(66946007)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fR0yqHQWolRJ8LLZWjuWE7Gik6BxsVh4zRLXEg6zDrrBkANfXOLYspNARB2r?=
 =?us-ascii?Q?Q94KZ5JSOYYyocj3ZeaLyvX4J8HvZJJ9t4xH2EVAk3k80uX7P3WUI9GIAQjl?=
 =?us-ascii?Q?Mz321hmbnLrlApugeqHVyTVUCMSktTEinQLKlqHkAeRBDjW0h7odHKDW7v/v?=
 =?us-ascii?Q?X4V0wB6+sK/Oy7QACbDCKquiRCOw602v9vpysFToRewJN7WclnZNZpNR7kyH?=
 =?us-ascii?Q?7oSxQtKjkOJCL6c/zrX3J9XXpzRsURUQtp5RGOQvUiycbe5MPq3BTp/P/pQQ?=
 =?us-ascii?Q?rrhGCWMqhQIddE7Ow/hLo8IGeKDOF9vnE/aBkzHlOYRk6HQGoyHjbjAcvXHq?=
 =?us-ascii?Q?gQ7HqFLtdYf4ew2XYCH46i/qYirWuH35uTZNsQGKdxQVCIQPBWu1Jrg/NOfH?=
 =?us-ascii?Q?+Lhd9GzelWf6z+9QucGM4PowOwGcF7UlZfkFfcV5h0GI4X5leWSKtN9P6ipY?=
 =?us-ascii?Q?cKyDXwqf0Z5mUXY/qVJNFH7HMT5npX+TUCuk43yiGgkf/kC+NWUB0JL1ZaRK?=
 =?us-ascii?Q?2yf3bSu3xUllIvzjUbMcBICZFIs1YhFxqFkeV4mbrbzZrPBft5olweb5+MD5?=
 =?us-ascii?Q?c3aChKCnFXtMyEghHmQPCIB+i7GSJ/x+s+Mq9J4aDnmEjit5UHamB8oTt0B7?=
 =?us-ascii?Q?9+ywU8tqyG+o3GJ7Rm6o2D3bLT7qZTMa32onMed23v624HaD9d/6YWWY3F06?=
 =?us-ascii?Q?+OkUHRZEPeIlIWbCOrGr4XHoWTW2HEufJb6cGKrXoy0rTiZVdJfhJ9oV8YU0?=
 =?us-ascii?Q?XHgxnyMK7a0SizD2io6c95kR/kDsnOpJCAr54sBDDXzq6zzUoANfGZwCg/+X?=
 =?us-ascii?Q?fNx/BYk90ryEY2sHXsGZP7FKCxaqO6NKD4EM92PDfgIZirq/Aih2xvFnEdi6?=
 =?us-ascii?Q?+at3q8Z8NXNOwFUJMt7P3rhTB2isreSjATrbL/xgn5kuyV3qwMpFtwW+/ms3?=
 =?us-ascii?Q?8kkYBRT2Tf0tIJ0Gxazw2cUMDqsza1jWz2HfRZ9fiSaIQdX+y4ad+ZxTyRWD?=
 =?us-ascii?Q?s5PFWsiaKyCbey7csHfuCrhZrhkTPun/4hClDYMCdUrdqbYyqrv53mcz5B/D?=
 =?us-ascii?Q?OykUdvKiQl2M6eo8Fp/NUp6JxTe58P+JZuaxUAbm1bJrk93IrVI3h1xT8GrM?=
 =?us-ascii?Q?xxDjcFbc8hymtgP5daVnmUniPK9ytKnraG90s5XbjP1gyFjuBfGS52jUbY1d?=
 =?us-ascii?Q?0ZV7mtjz1NR3kQ6e9dwmM8TzNEjtPJuoliRPcQtmmS+eOlI1r9RJIUBe3SSH?=
 =?us-ascii?Q?UL4rATggLOGc31L532ye324toRBa2wEUxx/XA+lJ2yFEBiveTnpEZ0N5nCdv?=
 =?us-ascii?Q?JkB7chkRQRAxwrLj+BIQ0MVBxwsMq3Qkbk8ABnsIzcc2xqwcQ7gyQ0HBkBtS?=
 =?us-ascii?Q?hbvUmNKKh3+G1uCFPgsh8IAnXRGp7gHg4vCdf5hxyRTQUnAAH0/LYERqpS4B?=
 =?us-ascii?Q?FouVMrgil1gFcOn2F+3Bg4b3uZyoFjYBIYM1pnRjs4cxrt4jdOnZXRY0ZIv2?=
 =?us-ascii?Q?XooQ4H3B4OAuP5txu5nBJ1XwcnZuaI8yOc4XQwOyd2Obs8VxCa4m7F5Az8Cu?=
 =?us-ascii?Q?ItnDFM9HCueYNepR23EFl3ku1PTOGtKPhE+4FhYF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd61d9ea-c9b6-4752-e366-08db0678625c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2023 06:23:51.8685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OucVwq0R8zIwRIR2dGt8Z+j4VSVu0gExEZcoiZHyLvusgKYIZ306eKOy2DHvkNzwd1rpD07mIKlEupg6Ef3zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6315
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Saturday, February 4, 2023 5:50 AM
>=20
> Nothing uses this value during vfio_device_open anymore so it's safe
> to remove it.
>=20
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/group.c     | 2 +-
>  drivers/vfio/vfio.h      | 3 +--
>  drivers/vfio/vfio_main.c | 7 +++----
>  3 files changed, 5 insertions(+), 7 deletions(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

Regards,
Yi Liu

> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 98621ac082f0..0e9036e2b9c4 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -187,7 +187,7 @@ static int vfio_device_group_open(struct vfio_device
> *device)
>  	if (device->open_count =3D=3D 0)
>  		vfio_device_group_get_kvm_safe(device);
>=20
> -	ret =3D vfio_device_open(device, device->group->iommufd, device-
> >kvm);
> +	ret =3D vfio_device_open(device, device->group->iommufd);
>=20
>  	if (device->open_count =3D=3D 0)
>  		vfio_device_put_kvm(device);
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 24d6cd285945..4f39ab549a80 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,8 +18,7 @@ struct vfio_container;
>=20
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm);
> +int vfio_device_open(struct vfio_device *device, struct iommufd_ctx
> *iommufd);
>  void vfio_device_close(struct vfio_device *device,
>  		       struct iommufd_ctx *iommufd);
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 28c47cd6a6b5..3a597e799918 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -397,7 +397,7 @@ static bool vfio_assert_device_open(struct
> vfio_device *device)
>  }
>=20
>  static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd, struct kvm
> *kvm)
> +				  struct iommufd_ctx *iommufd)
>  {
>  	int ret;
>=20
> @@ -444,8 +444,7 @@ static void vfio_device_last_close(struct vfio_device
> *device,
>  	module_put(device->dev->driver->owner);
>  }
>=20
> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
> +int vfio_device_open(struct vfio_device *device, struct iommufd_ctx
> *iommufd)
>  {
>  	int ret =3D 0;
>=20
> @@ -453,7 +452,7 @@ int vfio_device_open(struct vfio_device *device,
>=20
>  	device->open_count++;
>  	if (device->open_count =3D=3D 1) {
> -		ret =3D vfio_device_first_open(device, iommufd, kvm);
> +		ret =3D vfio_device_first_open(device, iommufd);
>  		if (ret)
>  			device->open_count--;
>  	}
> --
> 2.39.1

