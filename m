Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE017756321
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjGQMua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 08:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjGQMu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:50:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A79B1;
        Mon, 17 Jul 2023 05:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689598228; x=1721134228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gjLbFUh71fS6rPaU+/xpM1KvZw1n6tVzkeyYxYg3wd8=;
  b=XvXsQ9b/5zuhxNw7iq8DyxUXx4URnRCv2kUGypImzMnUo8QQeOUZAU4+
   PMDegkZlhY9toyuWk6QYS0c3gEdC5Kqv6imuvk9E/W/CDbX++rzNQ38NM
   ruisWUy2PwA0V35SstBS8DTk1kwggT8PCapkNZvTR3ABNqop8wcis79fh
   hNbh4ov+fv8wypzBCfP/kqDwEJyeZ0vHF7xI3Ks6uZf7KyNBsAUNWV15j
   E/aBqXvLFZQouKs5JXt09ep3uQXiPR0lIXL1BwI867S4waz70lSvbgvgT
   hlzJIcMxHisvDP7wG+qIL3qK5IapLpZqjkVbifhWD4NZdzgtw74+gySWk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="350783727"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="350783727"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 05:50:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673529381"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="673529381"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 17 Jul 2023 05:50:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 05:50:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 05:50:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 17 Jul 2023 05:50:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 17 Jul 2023 05:50:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccVuV2xSVnF0eU+EAecNS1D6wU4QlEUoFDYGxCrO8M5Wo1nx+a3W/kM5Jhs84B/K3KnqR1rOVXMY4pNjQXP1eB05QLYuEILKnLxCqwjFypdqdc1M21O65MTMpmHLTVuPA445vNOLYMNxGclYxUfJwDZijnK8IxYCWRiMhkXMz2p2Ib1k1GQ7EooZJHH/I7D6LIR2pFauZLjakSbmzId6I4+pKSPfVo8vfVsG8zljIeTj1GFAPSPBl7WYhOs67gXlx1M4OdVr8euKZ1G6N/r1BDrT+AZIq5x7uSVi0wEgtxxkrWfQhQZA9oWOQM7t9AOUY95Mydq6HbJsKm4NE8FSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjLbFUh71fS6rPaU+/xpM1KvZw1n6tVzkeyYxYg3wd8=;
 b=Qh05jNT1KF3QzNyZzrzxu7URfnKedsIlnBevyceo0oq4C381/faTuzQm0xAolt8hmr8tJuNZ3iWWCOQ39nWgShvPVpQI1zwcctkjPTBFAK9B26mL8nXVwjGCJXxRcUPauUF7TbckQfmG3wMhIC+Tt5ehZYFeYkZV3A2YtLIEV19e0VPuSBVyKA4UZ6f6tluV1j7rRCG8xAAu0UFRsQ3/I/syB6qdich9D01x79+X2aCoiDSLNsjnbSCe8WddGKgtMm26XHMH3n3wkjvRMnuQlUK+wJweRxN+wSDrkyBYAdZAnvSQdP0KOddccs0pMm/E7o7CMu4Ptlo/taWV29p+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7980.namprd11.prod.outlook.com (2603:10b6:806:2fc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 12:50:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 12:50:24 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Topic: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Index: AQHZoDagsdh+fCMUvkyHLuzt/JVGpq+9qlBwgABrKgCAAAQE0A==
Date:   Mon, 17 Jul 2023 12:50:23 +0000
Message-ID: <DS0PR11MB7529BFCCDDFDB1FE8F23FFC3C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
 <20230616093946.68711-22-yi.l.liu@intel.com>
 <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZLU1NKfKQkIPUIxw@nvidia.com>
In-Reply-To: <ZLU1NKfKQkIPUIxw@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7980:EE_
x-ms-office365-filtering-correlation-id: 04f624f5-fc56-4326-65f5-08db86c46311
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KCZQoX+Ai5Tn9iAdviIFpwh9GMqIq5cAp5a7J9uJ1B2wpguaIu5f7onR6w7RLrVN2ZfbwSJTO3IfBz6IEAus0fbkcc2E6DHbjN96O78Jerhin77Wv7hlXWzzb/OLhRWJ4aTacUUNCw2DChzhjIBwIS7WqSvgrLvlJNy686WpouPh2Z1iVHORa/+IFCR9GGxF3naLPu2u1pxArQzVkoES11Uggue6BHq5WpfMs3Xnr3DaOtpPzYxShBljUDWqjAeE7Qh5E+nip/XfTYDUcLS10Jyfzny9u7W74roR2aMOwuvlq4HLJUh2ixNHIxxius/lIC6YuoYW74NPnYhX3AgxUKpnrhBXslxPlDNNVyOv1a9usXzMzAqse9Rg1RGq7Xc/LV3eN2MxL6o2ZV5gOe1GTaY8yKT/wVBxtlab4I/Tsf8Qc4M92OfehO6YuLb5QwpNitT8efql5C2Rj1yYq1H+oSzNVi9xghArvaZDUedVnDPISPEM2SSwHfezwUG4uLOyY2jvsgnc1YG9USTNWERNK0na1JM3NJILQq6zzUYj3w8lck5dzLL86o/UYxOHYZ/PXQpSGXpNQxvTeA2ryDRoROzRLp6XXffgS1r7D39dZfklB5nKeUshWxj3id8gVEUh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(2906002)(54906003)(478600001)(71200400001)(7696005)(8676002)(4744005)(7416002)(4326008)(41300700001)(316002)(76116006)(64756008)(6916009)(66446008)(66556008)(66476007)(8936002)(66946007)(82960400001)(83380400001)(38100700002)(55016003)(122000001)(9686003)(52536014)(86362001)(5660300002)(33656002)(38070700005)(26005)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LTHjAg02ZaeCih8bSVxtOJeZIZ19RnLP00UlpfBahystF1qFa7yZHYrqmusj?=
 =?us-ascii?Q?St2CLbKZ80DNKQ5akmUsn/tBCEY3D0ObX150xyn1H6vLkDplevu4/W8cJknA?=
 =?us-ascii?Q?KDjYqcxlyU3lEksarVGi+fD8/SVmgn/0jyfz72TyWQJQ5YxaWEktXJgGGdr1?=
 =?us-ascii?Q?WViDFeKmaze8zjN0FMs9PyGw/Jo5/HVn8ZafmkxGktcBYwfEC7Dl/mMtIiIs?=
 =?us-ascii?Q?KIHrrqydOumKfviDua+TacyAqdaOuFuSVvNLRoyh72Xd1ze15XqHqFNv+MAh?=
 =?us-ascii?Q?jFfPe7YHox/eA8nbjcxUHtXIeWxikWxoenAgETff5/0YbtU+/GzkW3R9GMsc?=
 =?us-ascii?Q?liJT6hcKYMFaGLC6FuQD4WHnOUGGsSjoZCW1DqLq8wK+QnrP2MnlAy9G63Bh?=
 =?us-ascii?Q?cB3tHUWIihTqsU7oYZRBWblDfmygn4TPJp6sPODIeYCnDFBJkSTiYR+nqsxI?=
 =?us-ascii?Q?wCf1CdBRgJA7ZTLRWxkMaTqeO3kygK4GN3fCPJqlBTfw3vs709XrSeotDJwy?=
 =?us-ascii?Q?BONLBGpzd2Fi3h0SBP/X1O5lxVU8PMsHn5v2hAe2SSmOrx0Ox33kryUZP4CY?=
 =?us-ascii?Q?sM2DCp6wSUYocqAGDti8cEzCwNSC8dRNQC89okrAs3PdFen/6F+GsMGxjSFF?=
 =?us-ascii?Q?dq0cAdVhIjI8ogIsSLziHj87e/exWsX+8KCyF350VH3YSD9Cmo61KupK+iQo?=
 =?us-ascii?Q?ZaqJoj/dn0fXy/7KkhFDC+pb7gVmbUFiLu9hxY/UCrDs3BbFf6okM5SzSdeA?=
 =?us-ascii?Q?WnTizkngV+Z77sJh/m0EEmwQMIRf6k9DNDKkplsIIA+41wv9nTfWeBdCn/XO?=
 =?us-ascii?Q?mI0vEsBripoP1JY64pkyr15W0/+/ABf8pYA6vPiIEyPNaxXxeBKEv0xQfPP3?=
 =?us-ascii?Q?IFFI/TNGMfffl7NPiZKJZZNLKWJtO5LUilgXKLnWIAqVUY9FFc7X+CyKCtEE?=
 =?us-ascii?Q?GMJ4k4D7kP2sSOhpxOoMiCtu7syQIbP8MshUyz0AaN4b8wPMEGGktw5o+NDl?=
 =?us-ascii?Q?OhY7171BusdeZf7Q/wrPo06/VlV2vyzjeyjIyE1IhhaishOjRAm1rbku8VUY?=
 =?us-ascii?Q?JjfAR+AJYB2AIpJFSTQ4bAYGv051NLZOFzuELl/2ssbdmHc2uXGhtQLmvBUW?=
 =?us-ascii?Q?VtKj4OQ5f31ux4pMgzFG97OL7CX5PsJJC3sW3SxhIcG0xUw7rQ5ggbdc/CYu?=
 =?us-ascii?Q?D4vxptGJdI08NwKCJeN5KinQsYUcOGO/21cpLUBszDSPlaWbbK5qzWYk0xgB?=
 =?us-ascii?Q?4pKZEfNN+AwuO+0R7zb7PK2vWrGWa0GDxXycWEE2Pvx6xTN8gYAlGjhhLNmn?=
 =?us-ascii?Q?ONyMHmF5GLbAGi9l9ptp2eaxNhoLMGjiKqWsKFSWpaAXCBD9zTZUvBUKaEyz?=
 =?us-ascii?Q?W3SMUff70bHIpkzt0Ylns/Tbuj+U0hsoRg/IbsZ8jCM0WffxzGktaGnRG1q1?=
 =?us-ascii?Q?5dyC+5SIc+FmXwvE9vW88YZHM+aNGcu8jxMwUusntTHwMjUqNV0PK6B4h+tw?=
 =?us-ascii?Q?0VbjhuJqkZQ06a1mf/sVuXmo36yZckUO6L0GmsHaN3ATcIOV1LjZlCOOGc/P?=
 =?us-ascii?Q?RorW7dTKieYiYp0kehaXHXVnrafjgitvY6Ru+xFa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f624f5-fc56-4326-65f5-08db86c46311
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 12:50:23.6348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kE/1YpMetrjDMxPUZuiJyY4xpD0qLdJ6WetTf+gtHYSB+D5oTbA/ugH2cwBFa1cJkWEDg+n5z/RDzdPQuZrSTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7980
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, July 17, 2023 8:34 PM
>=20
> On Mon, Jul 17, 2023 at 06:36:19AM +0000, Liu, Yi L wrote:
> > Hi Alex, Jason,
> >
> > I found a minor nit on the kconfig. The below configuration is valid.
> > But user cannot use vfio directly as there is no /dev/vfio/vfio. Althou=
gh
> > user can open /dev/iommu instead. This is not good.
> >
> > CONFIG_IOMMUFD=3Dy
> > CONFIG_VFIO_DEVICE_CDEv=3Dn
> > CONFIG_VFIO_GROUP=3Dy
> > CONFIG_VFIO_CONTAINER=3Dn
> > CONFIG_IOMMUFD_VFIO_CONTAINER=3Dn
> >
> > So need to have the below change. I'll incorporate this change in
> > this series after your ack.
>=20
> This is fine, we decided to allow this in the original vfio series. It
> is usable in that you have to use iommufd natively with the group
> interface. It won't be backwards compatible with current userspace.

Sure. I'll keep the current code.

Regards,
Yi Liu
