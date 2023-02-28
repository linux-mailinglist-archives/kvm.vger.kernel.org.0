Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF46A52CA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjB1GAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1GAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:00:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D201BAFC;
        Mon, 27 Feb 2023 22:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677564022; x=1709100022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uXfmrjWGxWXY86ZduF1xRz0wlvqTPiIM9ZRy1PFUCYI=;
  b=POu65cpLb+9gFz5iIaJ8QRtnj7axA6GSspv6Xfgd7UEC1loL5FhGv/YW
   k2E4U42znMX+4GhWeo9aRP+yMFLUVMg/FvTO7kkifj2o/T5bF+EqOJJ0C
   qTNjO8q5xBDm3hoXd1WSAVMV7qvCuXVEa6zXHCGb75/49EFnpOrtDqgL/
   BBT88E+zTVV5wDvEeGTGrbxgFTYMa4D9CBNNsveXppELCxNfUlNBzTM56
   FaYjUc7qqPsy32j4e64VwD9dV/Nd5JCrenHCaN11J6zbb27+rWsiKJII/
   gNKg+jTBGRBdC3co5fqFKKbsfkstNgGe0EpdrhD74hqRve8UkD92TCw8+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="361616741"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="361616741"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 22:00:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="674010298"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="674010298"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2023 22:00:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 22:00:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 22:00:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 22:00:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 22:00:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKnd6dys1kwHSrNH45/x27PoAwD93XPqTBZ/WbjIsacA4LllfwTMlyHx942M1f/mnuVH9vceU37ayhjMMuTtp9OCfdkoSS33uzRI37NMiwjvQSpR9RQj7+iMXXde2b7utl8kEeDqNTB/Z+E+D45UZKxEfV3yTgFJfr11AGSHnmaRDwB8P6RXgt/NaLKDCFEVUr20vQKcwDBclqbYwlBpJwm9kcR33/R2SkCzxV4v20jVjX2ZvNUKSXDdasZZ9X2XQAyeR4+yphJtoQA+AQhWdnLIM9x+6ukBFlCBStOd6KkJ6iorFNhW/AvCtuS1Rxsd1C2jKU4/0xr+LIX4rnPJ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGzFHGTQ9pYNwQCK9zvUhUvjaRz5+ZYLiBflOt5NQoU=;
 b=OvzhdZu6+JBFLBLL9wsu87kuO+zWjXwUOC2/LbL7nzjFE07S44H5LuWV0qQUjvXGS0lZW9gttJwCQrC8teZ/7ke15RkWiWLQitUj4nhIIQeP5BDCK1cxtSjoonGMAEWw7j4oBIFapbesn76rYrUnI/TSyEPCXc9ViwDuJBCASBxu3Gwc+0K6Au2Ew322LOPJYVNcfCuKj/3l+KvKjwARjQTzwa+nEBquvsPBhL3OoLoRmtWf+sW4GBJNcIO6SDujRAPk7nSjGazONRRG0KJ/jgX37XF2rl38M9PgMvmwZHZTznpdyCxec6Po0xWie/Wn1GJbgYSk6PU42IlTM+xuvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7881.namprd11.prod.outlook.com (2603:10b6:208:40b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 06:00:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 06:00:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Topic: [PATCH v5 18/19] vfio: Compile group optionally
Thread-Index: AQHZSpxOoJwf0hV6f0O8CRj2qSU0yK7j3QZw
Date:   Tue, 28 Feb 2023 06:00:09 +0000
Message-ID: <DS0PR11MB75296779110F91EA7648F9E1C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-19-yi.l.liu@intel.com>
In-Reply-To: <20230227111135.61728-19-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7881:EE_
x-ms-office365-filtering-correlation-id: c7d56b23-52e2-48e4-4522-08db19510cc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7uY1kf1XAhIiIOWU1ChNoY57VuIni1cWDYUlVa6qqW/wCN7X37XVQA1kLuTPAu/HIQoYyq3wErtOHapaUQAtyQb6i19YwzoDnRPjE98pG1TV9i/F3M6MhWQsgTDaVqqUQ6VO5jXiWxbdvUH/ETpmy3lnwUClLfaohsimTCH1HbaQ8MQBPCa7k62Gu5Jdsb2lq+GsPot/OF1U5ZSfa6vPlX7pp0RcbUfLgxnSwe0jbMc6XgskS7UQQzaI4XR82BHJlc9xrxyjNTo/ND38iGw4D7Z6T4orlwsv6odATuLoGe67LGOqvSZ2q7mvaXCWlwfZFBB9sjritIJNmUG0mTRxypQKFL9TdIVKsVW46aRjkqvkUo9SMiBJiFVlM9OgVLvQEX04g3m8ashwOciLhAh9J8kJbt0h4J6vGeQ/CncUAowBmVxkqBXtRUo8DnTmk1+R0ce1JfbZU517dIMpRYGmptcyTPaPzVJ1kgGA2LD0KC+3WkB+eHbOAz79cmX2PsNie0xfkle5ffrOr5C1i6Bnw3I37CqD92QCTBtSs+lU2swWQG9PGlFGk57G5OOECgrUo1AvbhjQkQrw9EGmoUCo8cOsNms/I6fZ5zcejGBlv03m6dtmHVgolNlJVUkOa1CyCaTMCxVP2LaqTJXQ/Lmlp6GqGBBK2YLkHnpaGB//U63++bd+niH2xSwnsdI7qUn3q4sl7QdZYiRPBHjZO/mOZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199018)(4326008)(76116006)(66946007)(66476007)(64756008)(66446008)(83380400001)(66556008)(41300700001)(316002)(9686003)(38070700005)(8676002)(6636002)(8936002)(122000001)(110136005)(54906003)(52536014)(38100700002)(7416002)(82960400001)(5660300002)(71200400001)(186003)(26005)(33656002)(7696005)(478600001)(86362001)(2906002)(55016003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lVbPDeJyax8j21zuRmj28oMc+Hp3YAT7wLkuEbO0ugiVt0x7f4kRT8KSeh/a?=
 =?us-ascii?Q?2SiwgImnjQH5xZHXV+00QxCLWdzrdb7eI1cedDPRxFfrcXRm3fradFBJFuna?=
 =?us-ascii?Q?riGAyBywEnHPCWKF34zoe6hikViLIwsqeV1MqHatPzFp9jS3/r2WEwfE9aVc?=
 =?us-ascii?Q?P6FGpWg3CFUfdWL9cu79DHeCU4XXepKP7KKKBoUb8VSnlTaVuR85fupc+9CM?=
 =?us-ascii?Q?qBdHgu4Z7TqDFyDv/S0CD3m31ncaYvcEptgWqkPIpOSxr5WlfPBxtIac+or9?=
 =?us-ascii?Q?UxyBXnBeW1sxvmiDrUmvk3PyVcToHLLm7ZhVvudIWqtkOqji8T+qpDR2RD83?=
 =?us-ascii?Q?KtCbIe1CupRq2n/QhydiYPeUZw0kTEZGm5oyi8j980mK7Mb3I7vM8OzNOBOb?=
 =?us-ascii?Q?b9GFeXgvtPMTLtfL2N5RlJv18gR55oE9/ncP4NBd2MR0ovQhh3/JueE5Yubr?=
 =?us-ascii?Q?63V4ATWPamHRVpMBd6lPNq1h9rVWMbEbYTfWM3IlirYGpR3wP8nK/nikVvRX?=
 =?us-ascii?Q?plvK8h54YIQnlwJ2VWPNzwi/j/fbmI6+rTbBrSBkYqqodg4FGGIjlvsPC1qU?=
 =?us-ascii?Q?oJaBsL0Mp2maU50YHmrrA7hUSc/UuhRftBDLZ9GcF86Y/OfU5MrHIYrwrbPO?=
 =?us-ascii?Q?HiLQHHj8bdeI5K+mFvBgdjxkSXQXSbhVZOSlgvaE3QT7+2pq09lZkO3ReyWF?=
 =?us-ascii?Q?fP/155fAyZNOILiVOydTjkNAVdCQwX9HAZSe/lXPrPGr4egng7UIQo8v/fcg?=
 =?us-ascii?Q?1CHTJalT7cZcRI+K+G1jcOvIomFVPGAwEtK++ZQ9SSgyWht1tHrB6nanG9XL?=
 =?us-ascii?Q?Iyvxx8naR6RgAA8YVmFYyrYbz35NatLfUQ0MT9IDZ6ghxiQzfOJJHGGm+Bfi?=
 =?us-ascii?Q?KUvpiyQep5pTKHRG5HofcYIiqrx+a1la+ItQP2u2sOUtxiEGLe+qXbZIQSi0?=
 =?us-ascii?Q?+Q/GMqumriZhEdmciJ1cyLj42DW3LSkpncsBEqUqdlwLeR/Sxffg7veFJkfV?=
 =?us-ascii?Q?dvIDKUUlTGiugFfLCk3WfebyrbCsmCoR++Lt7RrMWIADngAGn3jkSOMrciiE?=
 =?us-ascii?Q?cQDMxkHBV5qnM6WsZdyvCb8RBjnwSwrW85pJr3ickhXb4NBwUZ+RcbJzfDl+?=
 =?us-ascii?Q?AdwVTq/RSAUZHNtuAyiuWhKMipWrZILj3jG7lluAdEc095iYxFPdqxniSO3s?=
 =?us-ascii?Q?OkYIQ1lRjuM0f5NAGwKVM2brWeZFscla5MdkmRokm0wQD+g+uvgVi2d10vuJ?=
 =?us-ascii?Q?52lMOckVAA+n1wbBdklO+FPuR+Wo9CjGBWJDqx5lJDs54FEGHn54a4JlPvwB?=
 =?us-ascii?Q?16WfEQ9aEcjKzMiYN6IYyyFhShE4tw9TYdst6Vg1GBWIhxk03Jxpqyr7tzTr?=
 =?us-ascii?Q?9Tl3Y3T9J8Nq8ZzrRsFImGxiShhUVGpn7SgijIDBOMSqMF3Gxh3ZSdplqiSM?=
 =?us-ascii?Q?U6tBkzW1gbZwSeyL318dEB+NVxqf0pahrAze0FtheutuHuMwbaQLxi9dO/i5?=
 =?us-ascii?Q?2YxItYXdKbbrMJqwOmR5MkPQpMzlIqg6zkhPCEMjWdhi6nuVJvl0IouQ/1ns?=
 =?us-ascii?Q?dVBSpUQwF4LlxcCtPGLSmrPc+N/O5/Ga7WTzxchT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d56b23-52e2-48e4-4522-08db19510cc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 06:00:09.9928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GxkgOnK0Nxvfub1pdyvtBG6jU6fJ55v9fHmf6vtydEqwRdw/a3DF7Tk3tytijjfvfrxG/SjAhSVFDWa6ZQiC5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 27, 2023 7:12 PM
>=20
> group code is not needed for vfio device cdev, so with vfio device cdev
> introduced, the group infrastructures can be compiled out if only cdev
> is needed.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/Kconfig  | 14 +++++++++
>  drivers/vfio/Makefile |  2 +-
>  drivers/vfio/vfio.h   | 72
> +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h  | 24 ++++++++++++++-
>  4 files changed, 110 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 169762316513..c3ab06c314ea 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -4,6 +4,8 @@ menuconfig VFIO
>  	select IOMMU_API
>  	depends on IOMMUFD || !IOMMUFD
>  	select INTERVAL_TREE
> +	select VFIO_GROUP if SPAPR_TCE_IOMMU
> +	select VFIO_DEVICE_CDEV if !VFIO_GROUP && (X86 || S390 || ARM || ARM64)

Got below warning when IOMMUFD=3Dn, VFIO_GROUP=3Dn. so may remove
this select or needs to let VFIO_DEVICE_CDEV select IOMMUFD instead of
depends on IOMMUFD.

WARNING: unmet direct dependencies detected for VFIO_DEVICE_CDEV
  Depends on [n]: VFIO [=3Dm] && IOMMUFD [=3Dn]
  Selected by [m]:
  - VFIO [=3Dm] && (IOMMUFD [=3Dn] || !IOMMUFD [=3Dn]) && !VFIO_GROUP [=3Dn=
]

>  	select VFIO_CONTAINER if IOMMUFD=3Dn

Needs to be if IOMMUFD=3Dn && VFIO_GROUP, otherwise vfio container
is compiled even VFIO_GROUP=3Dn.

>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
> @@ -15,6 +17,7 @@ if VFIO
>  config VFIO_DEVICE_CDEV
>  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
>  	depends on IOMMUFD && (X86 || S390 || ARM || ARM64)

depends on IOMMUFD have warning when IOMMUFD=3Dn and VFIO_GROUP=3Dn.

> +	default !VFIO_GROUP
>  	help
>  	  The VFIO device cdev is another way for userspace to get device
>  	  access. Userspace gets device fd by opening device cdev under
> @@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
>=20
>  	  If you don't know what to do here, say N.
>=20
> +config VFIO_GROUP
> +	bool "Support for the VFIO group /dev/vfio/$group_id"
> +	default y
> +	help
> +	   VFIO group support provides the traditional model for accessing
> +	   devices through VFIO and is used by the majority of userspace
> +	   applications and drivers making use of VFIO.
> +
> +	   If you don't know what to do here, say Y.
> +
>  config VFIO_CONTAINER
>  	bool "Support for the VFIO container /dev/vfio/vfio"
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM ||
> ARM64)
> +	depends on VFIO_GROUP
>  	default y
>  	help
>  	  The VFIO container is the classic interface to VFIO for establishing
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 245394aeb94b..57c3515af606 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -2,9 +2,9 @@
>  obj-$(CONFIG_VFIO) +=3D vfio.o
>=20
>  vfio-y +=3D vfio_main.o \
> -	  group.o \
>  	  iova_bitmap.o
>  vfio-$(CONFIG_VFIO_DEVICE_CDEV) +=3D device_cdev.o
> +vfio-$(CONFIG_VFIO_GROUP) +=3D group.o
>  vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
>  vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
>  vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 5a1ceb014779..a7b88521bf48 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -62,6 +62,7 @@ enum vfio_group_type {
>  	VFIO_NO_IOMMU,
>  };
>=20
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct vfio_group {
>  	struct device 			dev;
>  	struct cdev			cdev;
> @@ -107,6 +108,77 @@ void vfio_group_set_kvm(struct vfio_group *group,
> struct kvm *kvm);
>  bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
> +#else
> +struct vfio_group;
> +
> +static inline int vfio_device_block_group(struct vfio_device *device)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_device_unblock_group(struct vfio_device *device)
> +{
> +}
> +
> +static inline int vfio_device_set_group(struct vfio_device *device,
> +					enum vfio_group_type type)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_device_remove_group(struct vfio_device *device)
> +{
> +}
> +
> +static inline void vfio_device_group_register(struct vfio_device *device=
)
> +{
> +}
> +
> +static inline void vfio_device_group_unregister(struct vfio_device *devi=
ce)
> +{
> +}
> +
> +static inline int vfio_device_group_use_iommu(struct vfio_device *device=
)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void vfio_device_group_unuse_iommu(struct vfio_device
> *device)
> +{
> +}
> +
> +static inline void vfio_device_group_close(struct vfio_device_file *df)
> +{
> +}
> +
> +static inline struct vfio_group *vfio_group_from_file(struct file *file)
> +{
> +	return NULL;
> +}
> +
> +static inline bool vfio_group_enforced_coherent(struct vfio_group *group=
)
> +{
> +	return true;
> +}
> +
> +static inline void vfio_group_set_kvm(struct vfio_group *group, struct k=
vm
> *kvm)
> +{
> +}
> +
> +static inline bool vfio_device_has_container(struct vfio_device *device)
> +{
> +	return false;
> +}
> +
> +static inline int __init vfio_group_init(void)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_group_cleanup(void)
> +{
> +}
> +#endif /* CONFIG_VFIO_GROUP */
>=20
>  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
>  /**
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ce390533cb30..d12384824656 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -43,7 +43,9 @@ struct vfio_device {
>  	 */
>  	const struct vfio_migration_ops *mig_ops;
>  	const struct vfio_log_ops *log_ops;
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  	struct vfio_group *group;
> +#endif
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> @@ -58,8 +60,10 @@ struct vfio_device {
>  	refcount_t refcount;	/* user count on registered device*/
>  	unsigned int open_count;
>  	struct completion comp;
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
> +#endif
>  	struct iommufd_access *iommufd_access;
>  	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> @@ -257,12 +261,30 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  /*
>   * External user API
>   */
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
>  bool vfio_file_is_group(struct file *file);
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
> +#else
> +static inline struct iommu_group *vfio_file_iommu_group(struct file *fil=
e)
> +{
> +	return NULL;
> +}
> +
> +static inline bool vfio_file_is_group(struct file *file)
> +{
> +	return false;
> +}
> +
> +static inline bool vfio_file_has_dev(struct file *file,
> +				     struct vfio_device *device)
> +{
> +	return false;
> +}
> +#endif
>  bool vfio_file_is_valid(struct file *file);
>  bool vfio_file_enforced_coherent(struct file *file);
>  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> -bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>=20
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned
> long))
>=20
> --
> 2.34.1

