Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDDE6CD6AC
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 11:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjC2Jlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjC2Jlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 05:41:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9B35B5;
        Wed, 29 Mar 2023 02:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680082899; x=1711618899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dUxQIY9QF0WAf2jXbO3sWaGLu6Fe0hHHbjzpOZ0ewWM=;
  b=XVtomoLBtTpEAbFeH46sFM0J1FSWIfF52eokz4HxfQUj2srQeoj03OtR
   XXGnQC+WqLEZQx/eUcVpdyE1K7wpmeWzf7eWNfXaRLLo9h2UOu+feENHY
   PlMdNAUgdXi1D7raR4n217QJmlk9q7AVNi+mvkF/IosDzra0s03X6vBxX
   L9LYCPuVDILNCcD8AxY7zug3Pd4mllvgQdtoaOsaUXXU9hwhh+IGtgcde
   OxD7eD52bhmY7BCOPAOU7NcuApUp++8i39PFuGL8HSO5BuLtAV0UfYIBg
   2OQrsxxkyihiOmepLqlePsLXzArHdtD2QkzmjWmdouPsYoiNTGc5xwm91
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403454229"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="403454229"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 02:41:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="930247711"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="930247711"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2023 02:41:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 02:41:28 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 02:41:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 02:41:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 02:41:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7yIee4yNDXYYKKx1NRwdSMa4oWqgg3OeucTW3fgqoRJrNkCQw6sDNimIxoyFEZQ2fzJ7uWbfYboY8fLisFKiAnBN+twBmcZJOwsJZEyskiYZ4E+Qi2IJRRqQyGmkELOT7jQ9U572l8txuTznD7+W/hdhNEDOpSl+RR3xSGfvZIJ+xgWgg3kSxq/PiIdIzxU1l9Lg1D/JmgcWt27z/7qj/IF2xjLtTtsPAuGxIgxIvp8gLnb/Dk0nxHPLnqIuaGnvJ/Xkp6rgSaK17QEY1fBLarqkVg9Ra/A4jja8G0LVJDQWeqFLmOj+g36r0nQSe5KkXwNSYAVE3lFoXNtpCjOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUxQIY9QF0WAf2jXbO3sWaGLu6Fe0hHHbjzpOZ0ewWM=;
 b=fswzYYjcVZMWgqJyDPnr2qfjUjaZ+EHSC0pRAbnekzTHszFruzpyPH/u1/jCM15EGSebnAKJ5aZmGia2Ofs5xtEscLoZS4KUf96Ft2Xv9nSUyh/mv+9UlNJl/zhoPBOzSCUWK1OP0DDVMgumHGDHhtE/CdQiEUBeABgSVXKStkiftc90q+4yCyyJwWBPNRw1BCPxFKQt4VnhnQATrthDjenwvygBxJSCIYZTJ+sgwIogj+nZpHOriDY+2NF2jgYYlmoejfDOn7KG9VxUpmx6a3wQxod4S0QS9qOps7I4iOmH4Hyz5sH17p6GR/sbh3BfzR6GXGul2w4iF7s7VtqvJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6879.namprd11.prod.outlook.com (2603:10b6:510:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Wed, 29 Mar
 2023 09:41:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 09:41:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92YoejP8gsuUepwiqB47+8d68PAuSAgACHvgCAAC35QIAAiJkAgAADhQCAAAJBAIAABAgAgAAE14CAAAe3AIAABCSAgAC8HoCAAGkTAA==
Date:   Wed, 29 Mar 2023 09:41:26 +0000
Message-ID: <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6879:EE_
x-ms-office365-filtering-correlation-id: c92e9d9b-0c0b-44d4-c2d1-08db3039c403
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfGJd/U72s4Kvrue21cAJHlEkOeZRweZPavtqPz8jU5n5szLSeKdoYOAagBli7zS7G9L48g9/6mLNoPL2XyYvMqvKImWEOp0Q0e9RqwW5bngJzEVTBFThFb4XcG6ukJPiCZ5Qzcvld+yNE8MkRh1ybT0x+mrjpRPyd+JKimNVaAXbGxa+gfcQyxYhiZShxwE2/oZU7OFsrYbAZl+UZxsCIEB3sUhSBikQbQlzUFhFKdhGeW29HK3DeW+rjcFVoeMivU9woRk33MXJOlJfFABuCksKWtqgMuy2C3r4gb9qdrbjR2NoxzMKJWLJXHQubIdc7+EDD9fVZ5h9VEBTU/N2xoJK9B9ODmO7R9MNneBVvyYfmVk9rO8EoJFRv8tpB0xgIscZBPKN09GRIYF7A/Vf/UKuCchrXwLD1Ba/cbQ7KR6Vg4Ai5aa4dsmcCiALCnKNBW5PjfLP+YIu1yODz+/Q6+p8Zv23YfYJ2okqRO6Cxtu2g47KHwK5VJbvIti2XIV3O+EOkYOT1KEPJEhEEPYbd2Q3/RmwQF5UHoYXfkAv6z4OpDpY91QuIWb3Xl+gIAGofEBqONPjJxd/K0jwVgYNmFwl7m4SCtnBAeUPht1utShfAf4W1Ivi54TNLnz75Y5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(2906002)(64756008)(8676002)(66946007)(4326008)(66476007)(478600001)(7696005)(66556008)(76116006)(71200400001)(54906003)(38070700005)(9686003)(110136005)(316002)(26005)(55016003)(7416002)(6506007)(186003)(52536014)(38100700002)(86362001)(41300700001)(5660300002)(82960400001)(122000001)(33656002)(66446008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFZzd3NPd1RJWk54azQ4Rm4wSFNYY2EwNmJCTmRCenJyVGZ1QVNnMUg2cmQz?=
 =?utf-8?B?OUNuTmJyNWJVdzBOVHhlRUJPbUtCazV3U0RxUmhhNThCYUIwa3BKR0pSUnh6?=
 =?utf-8?B?clNJZ0ZEK3pkL21ZOXlUVVIzdmdrOEJBbjk2dDYwdERFemdMNnlaV0tkQW1m?=
 =?utf-8?B?bHJSaGVyMUY1bWQydDIwUm84S3NMZFc5cmpkaTYyT1FXMHdXSVdab295SVhX?=
 =?utf-8?B?UkY3dUx5b3NxbDZtUnRENlE5eng5SGttYW1RcFZFZUk3dDJHckxJR3kyMStq?=
 =?utf-8?B?TUM0TkZsVjFwZXpZVmNZa3NDbjc3QkxTTUtKZjdUSEk2SkdPVEdBdXFoQytu?=
 =?utf-8?B?YnN6bVEwYlZKWis2R0tuUHVtc1FKNjg0ZENQVlVrZEVMb0l1VGhWM0huNVV2?=
 =?utf-8?B?VElrdnRhTVgxZ1BQdzFFNDA5MnVwVEoreGhVc2JuZncrMHUxcW5leVV6aGxp?=
 =?utf-8?B?UmVHYUd0aUxrMUJZcXRIc0dYd1RzQUFVU3p0bE1zcnEyVytMeENCV3J4aWQr?=
 =?utf-8?B?VlhweGMrNk91bitWS0RvUXZhL1lhRUVEUkF2S0VsaTBYM1E1ekxkVWU4U0Rv?=
 =?utf-8?B?SGV5M05oWmlLMUdkdnB0d1BYNUtIVlhWRTlYdzFnR0dGMk1qRExTM0h1RVRp?=
 =?utf-8?B?UThPejNsWTZGVzlZZFlpMmVNTWgzYzEycG9La011enhoYmVhb20xMVJvS3hS?=
 =?utf-8?B?c1VwTzNXQjM5ZlVISmdacnFENWhwakJJZVZjeG9xQ3d2ZHlQSEhnYUFFU25Y?=
 =?utf-8?B?SnpHWnREU200VnhVSG12bUNBLzdXaDRCaHZyaGhrWFBpVUtQT2JhbDh0dWxq?=
 =?utf-8?B?dWdGU0dVUk0rVEpJbFAzR1JyVjFPSThJdktPMFhTcUJDM2dPeEI4eW9Ma0tt?=
 =?utf-8?B?TG03bVlIVGV3ODAzc1FMWHJaWGd2U2JmZnBEZUlDM2lMbXZieDFmRVFGMGh6?=
 =?utf-8?B?cXdjU3RnaUYwRnl0Vm4zZVRhbFUycW1nM0VOK29YUmxRYzdhcXVUYUpicFJn?=
 =?utf-8?B?Njl4VkFYNG9LTXlNVEtFQmpaN3l3UE1zZzJCRmpib2pNeFhtSmFtbitDK1Uv?=
 =?utf-8?B?ZUpyTEJoSytnSzIza0dNZWhFQnFNN3NGcFgzT0FMcG16MlUvcjVMSkNBMncx?=
 =?utf-8?B?bGo2ajlsck43N0g4ZE9zdHNQWmlsZlZ3cHRGVFJ0cHE2TWRML2F0NnBjbytu?=
 =?utf-8?B?Sm1oSVJ0eU94SVlGdjNYejY2aUwvMWN3YWtzVlJ1TUlDcXhVc2ptYTh0V2dX?=
 =?utf-8?B?MEREcVdQTXlTbFllT1lyNzRGb1Y5M2lLMENESkJWQmN3Y0hiMXoxMjZMN1Z3?=
 =?utf-8?B?WjhZbXo3RkVFMXBTRjFyTS9uLzFoR2FmTWw5RUZpdThtNmFtNm1KTW1BZUF3?=
 =?utf-8?B?ZlJpaU9NMzBtaUdSQTRaYUt6ZXhwakp3MXJFZ3N5QW9LQXZlMkFqR1dqYytS?=
 =?utf-8?B?RXUzVDhtaWkvN3BBVXgrd0ZqZkdmblM3d0Fsb3FJcUs2VjNoYWRxUTJjWkR3?=
 =?utf-8?B?OGFGMStwNGpMMFZtT1kxbk9EZnp3OVNIajJFb1ppV0FzaUhIRGY1dUVDWWl0?=
 =?utf-8?B?SlpYanFidVJTTE1SUk12ZWZSTWlDZUNpOCtEdkI3NzB5Ly9JUy9vVTRhcUVm?=
 =?utf-8?B?MFhYU3c3RDk3WkVFVm15aVR2M3lLYWpjdUFTcGdwelN0UTVZZGhzTmdjUnF6?=
 =?utf-8?B?U1Qyd1ZndW9odlhSQ1ZlZUpHdGEwWnVRRmRScWxvQXp4cjZJU2hGQ3FyU3py?=
 =?utf-8?B?Wk5VQ1ZIQmM3L1pBZU0wRTZqNTVhZm82d2EzUWtLdTlwUjFIaFY3bVVKRjZQ?=
 =?utf-8?B?b1cyL0FDVllUK3lTZHZGcVdQVERud1JsbzlsbEhMTllxVStZRzF5M1FYeGlN?=
 =?utf-8?B?Wk5wMkZHMkVrRE16NUY0Mm1kNUNIRGxQbE81bXpvNXhsZ0pjUktpMUY1ZmdO?=
 =?utf-8?B?OVNDckZIMTNPbUNZUDF4TkxRZFZ2RXQyQjVMK0tIMitWRFN6TWpqeFljZ0dW?=
 =?utf-8?B?eWtQaEliT3cyS2o2T0V5WER5RHowYXc0YTREQXkzaFphSStYRzJxN1N4OXNY?=
 =?utf-8?B?R01Ia1NUNVJ0Um4rd0gweDZlOWhnTUVDVzI2TlpYVzFyQlpPT053UkZ5M3Ez?=
 =?utf-8?Q?nyH16z7b1QuiS+iVrBzIGWjLt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92e9d9b-0c0b-44d4-c2d1-08db3039c403
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 09:41:26.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDVqQyfknkZF4EPJsUGa1kdmkNbuvJsLxGOMRTgsD3GXKuwiyHyd8GAwl+0K+neG4ai2YqQXHa13YURw1uRshQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6879
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXJjaCAyOSwgMjAyMyAxMToxNCBBTQ0KPiANCj4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24g
PGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2gg
MjksIDIwMjMgMTI6MDAgQU0NCj4gPg0KPiA+DQo+ID4gUGVyc29uYWxseSBJIGRvbid0IGxpa2Ug
dGhlIHN1Z2dlc3Rpb24gdG8gZmFpbCB3aXRoIC1FUEVSTSBpZiB0aGUgdXNlcg0KPiA+IGRvZXNu
J3Qgb3duIGFsbCB0aGUgYWZmZWN0ZWQgZGV2aWNlcy4gIFRoaXMgaXNuJ3QgYSAicHJvYmUgaWYg
SSBjYW4gZG8NCj4gPiBhIHJlc2V0IiBpb2N0bCwgaXQncyBhICJwcm92aWRlIGluZm9ybWF0aW9u
IGFib3V0IHRoZSBkZXZpY2VzIGFmZmVjdGVkDQo+ID4gYnkgYSByZXNldCB0byBrbm93IGhvdyB0
byBjYWxsIHRoZSBob3QtcmVzZXQgaW9jdGwiLiAgV2UncmUgcmV0dXJuaW5nDQo+ID4gdGhlIGJk
ZiB0byB0aGUgY2RldiB2ZXJzaW9uIG9mIHRoaXMgaW9jdGwgZm9yIGV4YWN0bHkgdGhpcyBkZWJ1
Z2dpbmcNCj4gPiBwdXJwb3NlIHdoZW4gdGhlIGRldmljZXMgYXJlIG5vdCBvd25lZCwgdGhhdCBi
ZWNvbWVzIHVzZWxlc3MgaWYgd2UgZ2l2ZQ0KPiA+IHVwIGFuIHJldHVybiAtRVBFUk0gaWYgb3du
ZXJzaGlwIGRvZXNuJ3QgYWxpZ24uDQo+IA0KPiBKYXNvbidzIHN1Z2dlc3Rpb24gbWFrZXMgc2Vu
c2UgZm9yIHJldHVybmluZyB0aGUgY2FzZSBvZiByZXR1cm5pbmcgZGV2X2lkDQo+IGFzIGRldl9p
ZCBpcyBsb2NhbCB0byBpb21tdWZkLiBJZiB0aGVyZSBhcmUgZGV2aWNlcyBpbiB0aGUgc2FtZSBk
ZXZfc2V0IGFyZQ0KPiBvcGVuZWQgYnkgbXVsdGlwbGUgdXNlcnMsIG11bHRpcGxlIGlvbW11ZmQg
d291bGQgYmUgdXNlZC4gVGhlbiB0aGUNCj4gZGV2X2lkIHdvdWxkIGhhdmUgb3ZlcmxhcC4gZS5n
LiBhIGRldl9zZXQgaGFzIHRocmVlIGRldmljZXMuIERldmljZSBBIGFuZA0KPiBCIGFyZSBvcGVu
ZWQgYnkgdGhlIGN1cnJlbnQgdXNlciBhcyBjZGV2LCBkZXZfaWQgIzEgYW5kICMyIGFyZSBnZW5l
cmF0ZWQuDQo+IFdoaWxlIGRldmljZSBDIG9wZW5lZCBieSBhbm90aGVyIHVzZXIgYXMgY2Rldiwg
ZGV2X2lkICNuIGlzIGdlbmVyYXRlZCBmb3INCj4gaXQuIElmIGRldl9pZCAjbiBoYXBwZW5zIHRv
IGJlICMxLCB0aGVuIHVzZXIgZ2V0cyB0d28gaW5mbyBlbnRyaWVzIHRoYXQgaGF2ZQ0KPiB0aGUg
c2FtZSBkZXZfaWQuDQo+IA0KDQpJbiBBbGV4J3MgcHJvcG9zYWwgeW91J2xsIHNldCBhIGludmFs
aWQgZGV2X2lkIGZvciBkZXZpY2UgQyBzbyB0aGUgdXNlciBjYW4NCnN0aWxsIGdldCB0aGUgaW5m
byBmb3IgZGlhZ25vc3RpYyBwdXJwb3NlIGluc3RlYWQgb2Ygc2VlaW5nIGFuIC1FUEVSTSBlcnJv
ci4NCg0KYnR3IEkgZm91bmQgYW4gb3BlbiBhYm91dCBmZCBwYXNzIHNjaGVtZSB3aGljaCBtYXkg
YWZmZWN0IHRoZSBjaG9pY2UgaGVyZS4NCg0KSW4gY29uY2VwdCBldmVuIHdpdGggY2RldiB3ZSBz
dGlsbCBleHBlY3QgdGhlIHVzZXJzcGFjZSB0byBtYWludGFpbiB0aGUNCmdyb3VwIGtub3dsZWRn
ZSBzbyBpdCB3b24ndCBpbmFkdmVydGVudGx5IGF0dGVtcHQgdG8gYXNzaWduIGRldmljZXMgaW4N
CnRoZSBzYW1lIGdyb3VwIHRvIGRpZmZlcmVudCBJT0FTJ3MuIEl0IGFsc28gbmVlZHMgc3VjaCBr
bm93bGVkZ2Ugd2hlbg0KY29uc3RydWN0aW5nIGd1ZXN0IHRvcG9sb2d5Lg0KDQp3aXRoIGZkIHBh
c3NlZCBpbiBRZW11IGhhcyBubyB3YXkgdG8gYXNzb2NpYXRlIHRoZSBmZCB0byBhIGdyb3VwLg0K
DQpXZSBjb3VsZCBleHRlbmQgYmluZF9pb21tdWZkIHRvIHJldHVybiB0aGUgZ3JvdXAgaWQgb3Ig
aW50cm9kdWNlIGENCm5ldyBpb2N0bCB0byBxdWVyeSBpdCBwZXIgZGV2X2lkLg0KDQpPbmNlIHRo
YXQgaXMgaW4gcGxhY2UgbG9va3Mgd2UgZG9uJ3QgbmVlZCBhIG5ldyBfSU5GTyBpb2N0bD8NCg0K
VGhhbmtzDQpLZXZpbg0K
