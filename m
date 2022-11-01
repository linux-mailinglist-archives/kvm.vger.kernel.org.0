Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D598D6145DF
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 09:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKAImR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 04:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAImO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 04:42:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44AE14D2C;
        Tue,  1 Nov 2022 01:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667292132; x=1698828132;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9C4YM79Plx/AIskPC27QA8W7fWgb2dV0+hiWBAKg1/s=;
  b=WC1UXbUI9NDwzkGE3kca4KlSzsRsoRJya+SvoItLmhm1pU5KSNBz8NlB
   DdsWSpiBqri/bm1jiyINNAFOM94XTJ9C/VDQLzfymGMjpXMSp/e0k4pjk
   L89fgM0QVxaxhjPzi+5K7/pg6M11RQia0vw3j1XqCa9n8MGSAWFiIREGo
   1J5lVmWUh6ESj5F/pQwDohgQfK7O5vHr6lsIa3QGpQnFdeGZ9CLGVmbS9
   IYIhZMfXx7PTbrI/XB5ZXhw/ge2pSgb65TKmc5CrL/dkuF67vQSxnje9o
   L3A/sPm72pqI3Zkh6JfGR9yzju5nFASbIf/ZwkgRzd3/x50wivEOjmbx2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="335758541"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="335758541"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 01:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="702814010"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="702814010"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 01 Nov 2022 01:41:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 01:41:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 01:41:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 1 Nov 2022 01:41:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 1 Nov 2022 01:41:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bj8ka+w4MKP+r2xCPcKbcVhoQgF0MzUqrjGAwc/yLrk+43YXc/VNrg3+h+zLnBGNhE9R28ficVAkrsBzHn/BU5ivWaUtpPl7yFslmFBdvME4/Yw/LwCsvNXvQxiAj+JLkZJ5/KiMdVEno7rCoN10hxkpspKFlxVJ9SgxA/x8uDD8zB8uhjR61QuF46tkxXmSG2qsV/lrOok4RbSE/ZWgTbvYcpgvZRbHm72YbbBbw9YhXv/oJAURUrgpt+slmoLfT3rgINV+KZZFzrmZxrBDJF31mqiGMxKIy13sUqICnaLHd/iraVmnn9HctYyn8+LamK7otT5e5FC/oAZ3u50ZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPy8Oxv20Q0SuziOvgJsrhjfWZIuu3dc1ELz8CASrVk=;
 b=QvrcmPEXgr5zaSj3blo6u9HHiUuHB/TMW1kq8My/juL9D92Dy0tx8tG7NKongLglH0LzUA6aINYDCg7ZAFDGdIXv9dUlZGo1ELc2QwkQ4cK/XKizkzTpbucmy+pmfeCr77xtaA8dgZMCC/SyYsh8bO+vpkbFNdPxABQ4YeDqIWuCXXCrQj+X7vbbMGbuwNu1rTxvyCFBj+gLAy0rxGCfuCYt3d8M/shyXuywD4xDZtXCZV1c8oakU1/F1YtXNIhIywcxJrt3xBPQPOL79nR1NFLTe8ILJoVoBO+QjG1OEQyLCHEEVyPy2eYVyBucY/0sPl8NV6fo1wvFi/uzmUoqgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6053.namprd11.prod.outlook.com (2603:10b6:510:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 08:41:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%5]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 08:41:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        "Matthew Rosato" <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "Shameer Kolothum" <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 09/10] vfio: Make vfio_container optionally compiled
Thread-Topic: [PATCH 09/10] vfio: Make vfio_container optionally compiled
Thread-Index: AQHY6KK4LvhSXMpcfkij2hh136pjaa4pyTgg
Date:   Tue, 1 Nov 2022 08:41:56 +0000
Message-ID: <BN9PR11MB527657F83EA743B2DA888A9D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <9-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <9-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6053:EE_
x-ms-office365-filtering-correlation-id: b410db2e-f6a3-496e-e11e-08dabbe4eeeb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4e+/eZbcWo5xj1tq6eZAnoqpz9a6zLxogB/7cdC2DZBpznTG8Ky3MKXZsB4HRRw+KjUW+ryxkN7IzGV6yItvt/x9+O5WPn60TVQuzSlxGteyGkvnijCYs5F9SIRAHtAqlDiqovSJwLt1DAc8A0bMKTrYNhowToWrVlujD1EVjmsiG1B51WYh9cp+t2+hKu2m1nC/3Cgwst3VKpZeFlcwa/SROWv0X3mRwZ4qj+Wqg/GNP/Qrt9faSz2f36Co1Xlwm9txXTpcQQJL81e3ogNF2gAhlC7QGxsL68TebxpY1EVvrVWNJhI97MyJ6JKf4VtiFaEi0SS2Q7UkPNlWkh5p1HnmZQIzCOARH5GDweUL15EVnCHY1uSQ6P4nGel4YQqBCpuNuBhLAYwt7pYBDql8NLo6FxoMtKaWw6C66ysp6Jl7DWYaCsfhH3smnYm6D2DSShRT2dc/Cfjh9l/hDN0JS2tr2cbORbku+njNApTGoPzacDO2t5Xxeso3lB+a2/jZ4B0U0irNC7AcHTeeExRKHHH8MM+spjDTVS6fpYlLnlLZEbyasnnb+8sqgzyE82JQU1eaN9wPIcQ60yBUfC+N0wiVAwmGl6wBfv9QDsn1/s0Ta7Me7GDJvA5byDcWctuR4lsEARHoVckEE52w1tsmkd7VSAiNnmfFPyUlzj3kdIP7E5miHEr+dtPYvyi5Ygj0NhPgWfr5z0e9zSkfqXjgNGTPtDrrLgU+9dZwUkuJEMXaGWaI42+OWvhVL+/8s2Yp4e+tlNrYGq6LtNWDcjUmVodBAn85dIgoSjlyGeOfYgM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(6506007)(7696005)(9686003)(478600001)(26005)(54906003)(186003)(4744005)(2906002)(55016003)(66556008)(316002)(66476007)(66946007)(110136005)(6636002)(7406005)(52536014)(7416002)(71200400001)(76116006)(8676002)(4326008)(64756008)(8936002)(5660300002)(41300700001)(86362001)(66446008)(33656002)(38100700002)(921005)(122000001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pamdyaz3etY7bgQSX7R58NIEJjP5z+rrYzuW8MZYPa2lKQ0a3cao2YIkDH/Y?=
 =?us-ascii?Q?F4NhrSjOTmXdZJMMJcIjj2PoxAs3+7N4RL+o7PH7nwKKITLIg3MD/gmK90L5?=
 =?us-ascii?Q?NI9i8LbhvYcTXQrHYxMPRkOg1oRpD39sqtOzIogPrs/GY8OGmUkeVo4pXUEc?=
 =?us-ascii?Q?RkXFL+jxJOfWeSk2Iux7C0BzgIMJ0pHHSK+5JQgKdtkc4IF4pFTA6LZ9Y0Nd?=
 =?us-ascii?Q?GGnDHZ3uGNpItYdQtkO6ICSBdVSAMbWPtoqL6Ofd+z1Wsra+KUOFUSuE2Gju?=
 =?us-ascii?Q?DGkf8UprlhT5d0H6/mhyX/YduBqdLEUxvktWIVm8qhmz3Jv84cmJ12xb4OvB?=
 =?us-ascii?Q?dD9IU8EmdesQ0YkUu77uTCvcLyZ+/CIOg3fQbf6IJMeDj2H7jLBeACMo1xIY?=
 =?us-ascii?Q?3QyVnKLC9NyjbyXtK+OwD2sLmFIh8BQclBimOz9qZd5YZdso28e140i8As1B?=
 =?us-ascii?Q?80EI2xWi5IBl41zPcWuEAn7xtMIuBFz/A44ltQ7BOsGBivAS7dkztMiACNw6?=
 =?us-ascii?Q?3bXN21TYFbv8MwwHjYreiBn5AYqXpZcipCLMUjtxYI/o5C2nA3XaG5Vb/GBx?=
 =?us-ascii?Q?CW/1xN6k0zdd463xF3XG99BDF7uHNmAsse2SC5SsiiENbibTQGRxc9YT3Dbc?=
 =?us-ascii?Q?4pJ9mpUvJdJsKd7AutnS4lqmHX9WqXEM0YIslYB61AWEtuUDAVWfQo16JxeL?=
 =?us-ascii?Q?ubQd35Yb/t26I56KNtpvfanP0nfAHtDDKdMNEOzxOMFJ/4NKCouWSm0IZF3Y?=
 =?us-ascii?Q?m64Xc15jqvrr6CoEV6ipYHOJCmnCfEJUyAo0JW0nyrkv38lVhLpebotlCEzW?=
 =?us-ascii?Q?SztvzeB8yfNWZMqKSHQiv5VyXcoAQsv8BY0hcA8yzjSwTRwdvKRxzH7Vnhhs?=
 =?us-ascii?Q?9ZFAJyXDAbWCcHJvxWpfl41iUoU7eXhafFZrdGS9bJk1G205AQCzZdoz3B2c?=
 =?us-ascii?Q?I6NA6aGYXpQPtyi3ygLho+0vQwj32bJkauePA8FFMzzo+0piHWWxwgpQU4DY?=
 =?us-ascii?Q?eDs3o2unVrmmjWDv1bKCM3VfKxrfN1AfE9XW1NyZY5fKdaNpDkk6Jljb9dvg?=
 =?us-ascii?Q?PgzNisRJX67E69+QN6MWlhhpo1gCAPoyvjVthhJeKPvP+QcAOFgFi56I5W5d?=
 =?us-ascii?Q?wFlqJBfjbmBVbK/r3sZej542yj63ns5TaR7MDszk4AZdYDEVCA1vNW5Xvvof?=
 =?us-ascii?Q?ZaW8YOpJD3HW9AjDJMWjYc58sezL47WnI8duV5SdcPjNHJUqgtVAx+R6MBg8?=
 =?us-ascii?Q?Nalf8L8aytPSDJQmFS7AXW8udNtnhdVuRGifsOEMX97B7Vi2uryp4U8QrBAG?=
 =?us-ascii?Q?listZl01OUBggWdQ6DOQiss+zeIpbkotVjd2NKcJaBKb8PttU4wn72b4SypS?=
 =?us-ascii?Q?eX1bF1OTdEgyN8wqed3ARFjT8l8TZ1EfhmrKyNq2XHKq68ncIjcIAEaXiHFJ?=
 =?us-ascii?Q?NNdaoNVGwRTlF7d/J5diI/OBRpbAW/dauGmni1R1NnBzH+k6dZOcXMfAiUlH?=
 =?us-ascii?Q?UYvR+huk5wbrgYNRW17Kx/0PFwFvwvixJl5tk8FYKd9d8slKMv7udfZHq33s?=
 =?us-ascii?Q?BDIu7MFUJTOlCAvxX1iFMcM4K/yyDnOxJaMMSvBs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b410db2e-f6a3-496e-e11e-08dabbe4eeeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 08:41:56.1094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUuM0KGqo+udaHPb4942kaPkFoVqtJegeAXutErXbZ3ta7YWv+CNxxilytilOWKPx2U0ZAskT8jPifXtxTYWsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, October 26, 2022 2:51 AM
>=20
>  if VFIO
> +config VFIO_CONTAINER
> +	bool "Support for the VFIO container /dev/vfio/vfio"
> +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM ||
> ARM64)
> +	default y
> +	help
> +	  The VFIO container is the classic interface to VFIO for establishing
> +	  mappings. If N is selected here then IOMMUFD must be used the

establishing IOMMU mappings.

s/used the manage/used to manage/

> manage
> +	  the mappings.
> +
> +	  Unless testing IOMMUFD say Y here.
> +
> +if VFIO_CONTAINER
>  config VFIO_IOMMU_TYPE1
>  	tristate
> -	default n
> +	default MMU && (X86 || S390 || ARM || ARM64)

there are already same conditions for selecting TYPE1 from
VFIO_CONTAINER. what does duplicating conditions here
bring to us?

