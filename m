Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107E579A34B
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 08:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjIKGHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 02:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjIKGHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 02:07:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B2112D;
        Sun, 10 Sep 2023 23:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694412438; x=1725948438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EmIKp0Ph2orFXgNDTX/eXg97qKnVUDVZAygAH4pb324=;
  b=BH97jkx7AjKid+xNmPQG0zzf4zuBcFiMPdXxMASrJWF3TIqTmTb3Ilva
   b/fJ+kSXus4NAeyOKR3F9a5GpaN+RFLsCKg1zyxSEMQZrxjzRHJL7lR+J
   rNTeVGqZcy+7gBwaMXSye2TtsgDq205swurOw7z9rLkmikfRSMH28WbWF
   aWfTxywlBzDdVeLTu9HLUnTeRpaOmWfaXI11WhYdLAVy5XrzJlVpS7XlC
   wJtwbtdfylNqnNcfq+vL54Pvkddv+WA7inAKCgpAuCeN9m6SGUMl9zPv1
   1WVFP2nXO0uaxyezyoxgwoWlwa9770sfySc25KI57srHRhtv8p27Z/5xg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="357449651"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="357449651"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2023 23:07:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="778271646"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="778271646"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2023 23:07:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:07:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 10 Sep 2023 23:07:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 10 Sep 2023 23:07:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 10 Sep 2023 23:07:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUIeyAihQ+XEzg4Tl9BaPV1lEWYt/dEtwWtkhVN9vr9UmM/FMg6xZm6/EOylyRnrIgejELp2XDsCK5n6w9jHdS/kKZtFnBo3ZbuTsxuqL1E/KkHVIyG0c+SwS+xPShTD+YJk8pJz4PwgSWMRClUXkveMsMmwO3xbyg1wLoJObLTxp+STJJ3baWfoQ7uiKCmJ6Ze+nmT0P7tZVOWkGbr3LtITrFfBtwThwYStQ7vmvdN3CEnZI2JqsnvwXNu+xBBnq6+HPGjCZ1TD4AvqB/pWAfrD587Q5PXmUBLlqhcwuCi+kZZ1GPlsgQuBS+0XZu5sVcG+pzfop7x64U0UThObOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmIKp0Ph2orFXgNDTX/eXg97qKnVUDVZAygAH4pb324=;
 b=Io7nGxTDtWwuKKiIXxV9x2o0a4OnuO3HGOzbDVZpIZL0UXiZFs8kVioPFV8NdYMxgPMo7FOJVhqPR0lcQ3sTI2G7jsoyEOiFWD5N/yM4Dl56p1e8hMhzt/EYtuaAchusPMYI6Q3U7lykkho3P3L/DuLykj2xK+gyJAUY9qwmVcAAeKUCU1X/rhBcsy7he4coTWL0CeHJTk087wmxTQ1hobXTNSyF77Ip9f11yGirIecrxepf0mEDWYYk5WmJZS80/5ZSqTJyktjRTy0lw/IoCohJ9Oa2ilAXnojaEwf7LETFGRRWwLcLBc/JbM5JlLa6G670HUYx2DPNThqSlTj+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB5989.namprd11.prod.outlook.com (2603:10b6:8:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.32; Mon, 11 Sep
 2023 06:07:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 06:07:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: RE: [PATCH v2 2/3] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Topic: [PATCH v2 2/3] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Thread-Index: AQHZ2qaIObSO2hK5PU+CBiaYlf6m5rAVNwCQ
Date:   Mon, 11 Sep 2023 06:07:16 +0000
Message-ID: <BN9PR11MB5276D9562D1ADE41AF4324268CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-3-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-3-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB5989:EE_
x-ms-office365-filtering-correlation-id: f96066bd-7099-412a-f01d-08dbb28d5945
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5zi0uxzO1tVtfH2kDmZoigcmf0tZQWHXbR3AH+10HCi11Z+FHqBDryGZzQBX3casWNt5Sy6MYyWabkPwn0vZ23KGY7HU6Wlyqfjhhtuqv2sL/HZvZiHCXp80WVVAv9khDJ2gOL9hs/P9g3Rbn462lho3ZwEOPiNY0EEM8fxmRluNOqg8Q7xwp+LuXIhHIBBZc0ABuUVpve5L0Qdg2hfoCUr9RH79PZaj3FrTTaUqDW3u4Ay79OGmxQay7trZfw+hdDIMGr1P8I54mxveb6tydPBwI2jfUBQTvPsEPUb4K/ZPOamr3JTbbBLOyREnTPotFkxqLM95B8xIH/jL/DRFNgJs0ZiNaWd9i1fM0vzFqI2NjMw5VCE/Ew4goLOhIYY9s2sk47M0xIL874gz+a+sYFZvJiV60N975LD2sSwT8y2QWOwruqCyltqVYUKlM7keZ7SbfpHc9m1wSsCM+RfeJHxNSxHWu9UZvkCaMYU0mjIi7jZLum3Xaga4PCY7deppjc77Wy2TTUZmLp3O6eqFHmdfmfQTF5kazyqgChOgcr8D2BnYMDA5buQjy5g/HKEqVQ5QjpQcArYMsk0tyCl0v7lN1ud7y09wY3knQCsrndEySl4GdQdsaIVyQJqOGMCC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199024)(1800799009)(186009)(66476007)(4744005)(55016003)(86362001)(2906002)(8936002)(316002)(41300700001)(8676002)(52536014)(5660300002)(4326008)(33656002)(26005)(71200400001)(478600001)(122000001)(7696005)(6506007)(9686003)(38100700002)(38070700005)(82960400001)(110136005)(66946007)(76116006)(64756008)(66556008)(66446008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4JyYh3cr1m2EVcBg6uNMBmJVeGRv4inoEgonr13v83n67SZw9OnQLMHMhRZo?=
 =?us-ascii?Q?WhdD4CtkYu2XVOvirxGyNO9R6bjG4Ltew0LLmwIMEE5NNUrZ4tq+7vfjKi+o?=
 =?us-ascii?Q?+bdHGceyc2x3ws5IarBLE1DQplHqSaLJG6SzqPy5fZMTujbz7COYPlijPhiS?=
 =?us-ascii?Q?Ibk3Dyg+aNNKfyzCAAe4BVM7xIIreJLgifDVKx1I0QgA/1dliyHvGl+MnD2d?=
 =?us-ascii?Q?NI99KQdr3zM6j50EJhf/LG+p6n7uQQeLaOCP3IbWeBlYlewttLHwUbdKPMC8?=
 =?us-ascii?Q?lAowOq9U2HDYm18WCPWaIIR4KFsEZF+ynkIKfsaPfJ/5YSpRUnPHEzZ5u/lN?=
 =?us-ascii?Q?vkWDkNuP/Hb+7dsYiYnhIh3vA+ovWCvAupOzXAtQsO/J4N+ZgzDTtm0e4hEd?=
 =?us-ascii?Q?3AXhyFN2PN3/aSWtpmu5xneyHh4T4szHLBkgla30hVIgQu9gmnyliSStkYqw?=
 =?us-ascii?Q?Xn5o7FxKcmbufeeUsEDQhToQOEsiHEoOJWz+MwSFV7HluH0OJZavEcriZfm5?=
 =?us-ascii?Q?vnWlGMpZ7xAcMER9WebuseBRJmpWM3Sbd/+sC8Eo0aZ7H4JiCvNdY8xH3gY2?=
 =?us-ascii?Q?T3EbbHy33K3XIjuoXmcnT5cgEjZlxRT5ZhxY8X2uIgf4aj7bAeA2Wfv6V05Y?=
 =?us-ascii?Q?/Vw9DcX2DhLhkbRvMW1Bg+wks9/2SynbiUglWWfqfanNW4W8T4FarSIIi/Uz?=
 =?us-ascii?Q?FcAmPZcUpn0A7KyNIeQ9zmsJLbWumsbC1/AyaAdR9QwcFj21vDN/jjuB71sb?=
 =?us-ascii?Q?8kvAN+heCPmSJAPvJjEUI0kQyajMqU6NJhJoSTkPIktEkja2o+0LMMVc31TO?=
 =?us-ascii?Q?DBoiAhkgF/0lUaqgzjZYg/v9X4JWlR6GDLnVbZ+oGCiJxObgp4rBXUFBKRo/?=
 =?us-ascii?Q?VSBwz0a6U4kqn+RQz1j3japlRGXsBOaS56pgkaD0w0sQy4byKVairM9ndx9U?=
 =?us-ascii?Q?L268vQMeg8YxYz37UEzqSTBZs21wP0wtyYWir3yRBpMm4KmtpwrbqTEpI1R/?=
 =?us-ascii?Q?jyv6eF28t8s/zTf+55rqbIV9Ctc4xFBjwFChIbyScuxRvIyqb+PaPvvGJwmx?=
 =?us-ascii?Q?Oo3d2EUiuB01z/YrbWeRkduel6WwijIT65vFRMgo8cqRlLc48b4xeH88ZE8F?=
 =?us-ascii?Q?Jo+408VXlhSKI1PfmIbGWEmE2xbUqwG9krZkpBMZiCZUR8jBz0mn+2bCX/C9?=
 =?us-ascii?Q?8NxDGo0QPs4jP9jbQIM0CsslBZRfRzjb41oofQJ0ZdI6mB84+AmVyVHjfgS1?=
 =?us-ascii?Q?9M6joXdlThGl0oGbRUSzbk4rkxeMQzw7ksd8zh6qU/ial6OETedEbPjmBIfo?=
 =?us-ascii?Q?GCz+vaLNWD+esyvdyyUuww5C8aU+x5GbPgBYayPsPfYKn5xysQX0F25NT4GP?=
 =?us-ascii?Q?yE/z/AM6bKNrSeEHUkqRe6OsnrWF66SfAlE7h55oQ3353WP0h3C8ybVZlh1n?=
 =?us-ascii?Q?flmkHHYnFTM5fHKyCpqNPIFnKMSaSxNx+HDLugaHHfFa5I+3UICObKaEHxOQ?=
 =?us-ascii?Q?IuXJOMa6ThSeMb9uJsockhFfJ8CzmjIQqISanKeYM5vaU4pyxZ0FPIOWJ8K2?=
 =?us-ascii?Q?Ubh7KA84SFQXUCWgu8IcQFuPjWgYfP6/2xipJWzR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f96066bd-7099-412a-f01d-08dbb28d5945
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 06:07:16.0930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAHBKBGOl2UtWntIn7cGKitwPIJxoCPCL182K6nZIrnmlD3GEyPXZoJbV1w5pp8jBIO1OyI6YcWEkUACMZxW+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5989
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Wednesday, August 30, 2023 2:27 AM
>=20
> The memory layout of struct vfio_device_gfx_plane_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
>=20
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of 32-bit userspace on a 64-bit kernel breakage.
>=20
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
>=20
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
